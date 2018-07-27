/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: Main Impl for AI API
*/

/*
  Checks spawnflags to game mode, to make sure bot 
  is allowed to spawn in
*/
float(float mode) ai_spawn_clean={
  local float rem;
  
  rem = FALSE;
  switch(mode){
    case GAMEMODE_CAMPAIGN:
      if ( (self.spawnflags & AI_SPAWNFLAG_CAMPAIGN) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_COOP:
      if ( (self.spawnflags & AI_SPAWNFLAG_COOP) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_DM:
      if ( (self.spawnflags & AI_SPAWNFLAG_DM) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_TEAMDM:
      if ( (self.spawnflags & AI_SPAWNFLAG_TDM) ){
        rem = TRUE;
      }
      break;
  }
  return rem;
};

float(entity t) ai_valid_target={
  if ( t ){
    if( (t.flags & FL_NOTARGET) ){
      return FALSE;
    }
    if( t.deadflag <= DEAD_NO ){
      if( t.i_faction != self.i_faction ){
        if( t.data_type == DATA_BLD ){
          return TRUE;
        }
        if( t.data_type == DATA_MECH ){
          return TRUE;
        }
        if( t.data_type == DATA_MECH_AI ){
          return TRUE;
        }
        if( t.data_type == DATA_VEHC ){
          return TRUE;
        }
      }
    }
  }
  return FALSE;
};

float() ai_find_target_visual={
  if( self.enemy ){
    return FALSE;
  }
  local entity targ, found;
  local float dist, rng;
  
  targ = findradius(self.origin, self.ai_view);
  dist = self.ai_view;
  rng = dist;
  while( targ ){
    if( ai_valid_target(targ) ){
      if( ai_check_face(targ, self.ai_fov) ){
        if( ai_check_vis(targ) ){
          local float ndist;
          ndist = vlen(targ.origin - self.origin);
          if(ndist < rng){
            rng = ndist;
            found = targ;
          }
        }
      }
    }
    targ = targ.chain;
  }
  if( found ){
    if( found == self.enemy ){
      return FALSE;
    }
    self.enemy = found;
    ai_found_target();
    return TRUE;
  }
  return FALSE;
};

float() ai_find_target_radar={
  local entity targ, found;
  local float dist, rng;
  
  targ = findchainflags(flags, FL_UNIT);
  dist = self.radar_range;
  rng = dist;
  if( self.stat_rdr_mode ){
    rng = rng * 2;
  }
  while( targ ){
    if( ai_valid_target(targ) ){
      local float ndist, nrng;
      nrng = rng;
      ndist = vlen(targ.origin - self.origin);
      if( ndist <= rng ){
        if( (targ.flags & FL_CLIENT) ){
          if( !targ.stat_rdr_mode ){
            if( ndist <= (nrng / 2 ) ){
              nrng = ndist;
              found = targ;
            }
          }
        }
        else{
          if(ndist < nrng){
            nrng = ndist;
            found = targ;
          }
        }
      }
    }
    targ = targ.chain;
  }
  if( found ){
    if( found == self.enemy ){
      return FALSE;
    }
    self.enemy = found;
    ai_found_target();
    return TRUE;
  }
  return FALSE;
};

vector(entity ai) ai_attack_calcSpread={
  local vector hitorg;
  local float rng, cnv, cx, cy;
  
  if(ai.stat_trg_dist > ai.ai_minrange){
    cnv = cnv * rng;
  }
  cx = cnv;
  cx = cx + ( cnv / 2 * random() );
  cx = cx * crandom();
  cy = cnv; 
  cy = cy + ( cnv / 2 * random() );
  cy = cy * crandom();
  
  makevectors(ai.angles);
  hitorg = ai.w_fire_ofs + (v_up * cy) + (v_right * cx);
  return hitorg;
};

vector(entity wep) ai_attack_trace={
  local entity cam;
  local vector lead, cam_ofs;
  lead = '1 1 1';
  if( self.enemy ){
    lead = self.enemy.origin - (self.enemy.velocity * self.ai_leading);
    lead = normalize(lead - self.origin);
  }
  cam = self.e_cam;
  
  makevectors(self.angles);
  traceline (cam.origin + v_forward * 1, self.origin + (lead * wep.w_range), TRUE, self);
  
  return trace_endpos;
};

void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  
  this = self;
  wep_chain = self.w_slot;
  self.v_angle = self.angles;
  while(wep_chain){
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( (self.currentWeaponGroup & wep_chain.w_group) ){
          if( self.stat_trg_dist <= wep_chain.w_range ){
            self.w_fire_ofs = ai_attack_trace(wep_chain);
            if( !ai_attack_blockcheck(wep_chain) ){
              if( ai_attack_checkEne(wep_chain) ){
                self = wep_chain;
                  if( (self.p_dmgtype & EFF_STX) ){
                    if (this.enemy.sh_cur >= self.p_damage){
                      fired = fired + 1;
                      self.w_attack();
                    }
                  }
                  else{
                    fired = fired + 1;
                    self.w_attack();
                  }
                self = this; 
              }         
            }
          }
        }
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = this;
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};


void(entity bot, entity attacker) ai_damage_react={
  local entity this;
  local float change;
  //TODO - panic behavior
  if( (bot.flags & FL_NOGUNS) ){
    return;
  }
  this = self;
  self = bot;
  if( self.enemy && self.enemy != attacker  ){
    // size check
    if( (self.data_type == DATA_VEHC) && (attacker.data_type == DATA_MECH) ){
      change = 0.2;
    }
    change = attacker.vec_size - self.enemy.vec_size;
    //health check
    change = change + (util_getMechHpAverage(attacker) - util_getMechHpAverage(self.enemy));
    //range check
    local float  dst1, dst2;
    dst1 = vlen(self.enemy.origin - self.origin) / self.radar_range;
    dst2 = vlen(attacker.origin - self.origin) / self.radar_range;
    change = change + (dst1 - dst2);
    switch( self.ai_rank ){
      case AI_RANK_ROK:
        if( change ){
          self.enemy = attacker;
        }
        break;
      case AI_RANK_REG:
        if( change >= 0.7){
          self.enemy = attacker;
        }
        break;
      case AI_RANK_VET:
        if( change > 0.5){
          self.enemy = attacker;
        }
        break;
      case AI_RANK_ACE:
        if( change >= 0.25){
          self.enemy = attacker;
        }
        break;
    }
    if( self.enemy == attacker ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      //ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
    }
  }
  else{
    self.enemy = attacker;
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    //ai_action_next( self.th_attack, 0.6, self.ai_action_mod);
  }
  self = this;
};

/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont;

  viewpont = normalize(self.enemy.origin - self.e_cam.origin);
  makevectors(self.angles);
  traceline (self.e_cam.origin + v_forward * 1, self.e_cam.origin + viewpont*wep.w_range, FALSE, self);

  if(trace_ent == world){
    return TRUE;
  }
  if( trace_ent.i_faction == self.i_faction ){
    return TRUE;
  }
  /*if(trace_ent != self.enemy){
    if(self.p_damage <= AI_RANK_VET){
      if(self.ai_type != AI_TYPE_AGGRO){
        return TRUE;
      }
    }
  }*/
  return FALSE;
};

/*float() ai_check_allattack={
  if( self.th_check ){
    return self.th_check();
  }
  return ai_check_forattack();
};*/

/*float() ai_check_forattack={
  local vector spot1, spot2;
  local entity targ;
  local float chance, r;
  
  targ = self.enemy;
  
  spot1 = self.e_cam.origin;
  spot2 = targ.origin;
  
  traceline(spot1, spot2, FALSE, self);
  
  if( trace_ent != targ ){
    return FALSE;
  }
  
  if( trace_inopen && trace_inwater ){
    return FALSE;
  }
  
  if( !self.th_attack ){
    return FALSE;
  }
  
  r = ai_range( self.enemy );
  
  if( r > self.ai_minrange ){
    return FALSE;
  }
  
  if( !ai_visible( self.enemy ) ){
    return FALSE;
  }
  
  local float i;
  i = 0.1;
  if( r == AI_RANGE_S ){
    i = i + 0.4;
  }
  else if( r == AI_RANGE_M ){
    i = i + 0.3;
  }
  else if( r == AI_RANGE_L ){
    i = i + 0.2;
  }
  
  if( random() < i ){
    ai_action_next( self.th_attack, 0.5, self.ai_action_mod );
    ai_leg_frame( leg_stand1 );
    return TRUE;
  }
  return FALSE;
};*/

/*
  Only used for AI_SPAWNFLAG_RANDDOMSTART
*/
void( string nodename) ai_node_pick_rand={
  local entity anode, spot;
  local float clr, total, pick;
  local string name, grpid;
  
  if( self.target ){
    anode = find(world, targetname, nodename);
    if( anode && anode.group){
      grpid = anode.group;
      total = 0;
      clr = 0;
      while( clr <= 128 ){
        AI_NODES[clr] = world;
        clr = clr + 1;
      }
      
      anode = findchain( group, grpid);
      if( anode ){  
        while( anode ){
          AI_NODES[total] = anode;
          total = total + 1;
          anode = anode.chain;
        }
        pick = crandom() * total;
        spot = AI_NODES[pick];
        if( spot ){
          local vector org;
          local float angl, px, py;
          angl = self.angles_y * DEG2RAD;
          px = cos(angl);
          py = sin(angl);
          org_z = self.origin_z + 1;
          org_x = spot.origin_x - ( px * self.maxs_x * 3);
          org_y = spot.origin_y - ( py * self.maxs_y * 3);
          setorigin( self, org);
          self.target = spot.targetname;
        }
      }
    }
  }
};

void(float dst, float grp, float bracket) ai_wep_group_track={
  if( dst <= bracket ){
    self.currentWeaponGroup = self.currentWeaponGroup | grp;
  }
  else{
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & grp);
  }
};

void() ai_wep_calcranges={
  local entity w;
  local float sh, m, l;
  w = self.w_slot;
  while(w){
    if(w.deadflag <= DEAD_NO){
      local float damg;
      damg = w.p_damage * w.w_clipsize;
      if(w.w_range <= AI_RANGE_S){ 
        self.w_group1 = self.w_group1 | w.w_group;
        sh = sh + damg;
      }
      if(w.w_range > AI_RANGE_S){
        if(w.w_range <= AI_RANGE_M){
          self.w_group2 = self.w_group2 | w.w_group;
          m = m + damg;
        }
      }
      if(w.w_range > AI_RANGE_M){
        self.w_group3 = self.w_group3 | w.w_group;
        l = l + damg;
      }
    }
    w = w.w_slot;
  }
  
  if( (sh > m) && (sh > l) ){
    self.ai_minrange = AI_RANGE_S;
  }
  if( (m > sh) && (m > l) ){
    self.ai_minrange = AI_RANGE_M;
  }
  if( (l > sh) && (l > m) ){
    self.ai_minrange = AI_RANGE_L;
  }
  if( self.ai_minrange == 0 ){
    self.flags = self.flags | FL_NOGUNS;
  }
  
};

float(void() action) ai_hunt_dropnode={
  if( self.ai_hunt_total < AI_HUNT_VET ){
    if( self.ai_hunt_total < 0 ){
      self.ai_hunt_total = self.ai_hunt_total + 1;
      //start of hunt chain
      local float it;
      local vector torg;
      it = ai_move_time(self.m_fspeed * AI_WALK_SPD, 250, 0.1);
      
      makevectors( self.angles );
      torg = self.origin - (v_forward * (self.maxs_x * 2 + 2) );
      
      ai_node_hunt(torg, self.targetname, self.ai_hunt_total, it , action );
      self.ai_hunt_total = self.ai_hunt_total + 1;
    }
    local float t;
    t = ai_move_time(self.m_fspeed * AI_WALK_SPD, vlen(self.enemy.origin - self.origin), 0.1);
    cons_logAFloat( "fadetime", t); //DEBUG
    
    local vector eorg;
    makevectors( self.enemy.angles );
    eorg = self.enemy.origin + (v_up * (self.enemy.maxs_z / 1.5) );
    
    self.goalentity = self.ai_hunt_node = ai_node_hunt(eorg, self.targetname, self.ai_hunt_total, t , action ); 
    self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
    
    ai_action_next( self.th_walk, t, self.ai_action_mod );
    ai_leg_frame( leg_walk1 );
    
    self.ai_viewtime = time + self.ai_viewcheck;
    
    self.ai_hunt_total = self.ai_hunt_total + 1;
    
    local float update;
    update = self.ai_hunt_total;
    while( update > -1 ){
      local string tname;
      local entity e;
      tname = strcat(self.targetname, "_", ftos(update) );
      e = find( world, targetname, tname);
      if( (e) && (e != self.goalentity) ){
        e.pausetime = e.pausetime + (t * 2);
      }
      update = update - 1;
    }
    return TRUE;
  }
  return FALSE;
};

/*
  ported over from Quake and adapted here
*/
float(entity targ) ai_range={
  return vlen( self.origin - targ.origin );
};

/*
  calculates the number of game seconds the AI needs
  to traverse a given distance at a desired speed
*/
float(float movespeed, float distance, float ticrate) ai_move_time={
  local float t;
  t = movespeed * (1 / ticrate );
  t = distance / t;
  return t;
};

/*
  calculates the number of game seconds the AI needs
  to rotate to a desired angle
*/
float( float yawspeed, float angmin, float angmax, float tim) ai_randyaw_time={
  local float turn;
  self.ideal_yaw = anglemod(angmin + crandom() * angmax - self.angles_y);
  turn = anglemod(self.ideal_yaw - self.angles_y);
  turn = (turn / yawspeed);
  turn = turn / tim;
  return turn;
};

/*
  simple validation, AI should only fire a weapon that
  has a power draw IF the AI has more than half of the current energy
  on-hand
*/  
float(entity wep) ai_attack_checkEne={
  if(self.en_cur  >= wep.en_rate ){
    return TRUE;
  }
  return FALSE;
};


void(float startState) ai_initialize_system={
  self.ai_action_time = time + self.ai_action_mod;
  ai_pilot_validate_states();
  ai_state_control( startState );
};

/*
  this should be called right after assigning
  specific-action functions for a unit. This ini's
  any null action functions to SUB_Null to prevent
  <null function error>
*/
void() ai_pilot_validate_states={
  if( !(self.th_stand) ){
    self.th_stand = SUB_Null;
  }
  if( !(self.th_walk) ){
    self.th_walk = SUB_Null;
  }
  if( !(self.th_fly) ){
    self.th_fly = SUB_Null;
  }
  if( !(self.th_run) ){
    self.th_run = SUB_Null;
  }
  if( !(self.th_run_strafe) ){
    self.th_run_strafe = SUB_Null;
  }
  if( !(self.th_run_charge) ){
    self.th_run_charge = SUB_Null;
  }
  if( !(self.th_missile) ){
    self.th_missile = SUB_Null;
  }
  if( !(self.th_melee) ){
    self.th_melee = SUB_Null;
  }
  if( !(self.th_missile_strafe) ){
    self.th_missile_strafe = SUB_Null;
  }
  if( !(self.th_hunt) ){
    self.th_hunt = SUB_Null;
  }
};