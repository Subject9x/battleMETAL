/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: Main Impl for AI API
*/

/*
  Go through spawn flags
  Check Game Mode and Difficulty Skill
  remove AI if they're flagged to not be in a category; 
*/
float() ai_can_spawn={
  local float yesWecan;
  local float gameMode;
  
  yesWecan = TRUE;
  gameMode = cvar("gamemode");
  
  if( self.nextVecChoice <= 0 ){
    return FALSE;
  }
  
  if( (self.spawnflags & AI_SPAWNFLAG_CAMPAIGN) ){
    if( !coop && !deathmatch && !teamplay ){
      yesWecan = FALSE;
    }
  }
  
  if( (self.spawnflags & AI_SPAWNFLAG_COOP) ){
    if( coop && !deathmatch ){
      yesWecan = FALSE;
    }
  }

  if( (self.spawnflags & AI_SPAWNFLAG_DM) ){
    if( !coop && deathmatch ){
      yesWecan = FALSE;
    }
  }
  
  if( (self.spawnflags & AI_SPAWNFLAG_TDM) ){
    if( deathmatch && teamplay ){
      yesWecan = FALSE;
    }
  }
  
  switch( skill ){
    case SKILL_NOV:
      if ( (self.spawnflags & AI_SPAWNFLAG_NONOV) ){
        yesWecan = FALSE;
      }
      break;
    case SKILL_REG:
      if ( (self.spawnflags & AI_SPAWNFLAG_NOREG) ){
        yesWecan = FALSE;
      }
      break;
    case SKILL_VET:
      if ( (self.spawnflags & AI_SPAWNFLAG_NOVET) ){
        yesWecan = FALSE;
      }
      break;
    case SKILL_ELT:
      if ( (self.spawnflags & AI_SPAWNFLAG_NOELT) ){
        yesWecan = FALSE;
      }
      break;
  }

  return yesWecan;
};

float( entity t ) ai_line_of_sight={
  //use FoV choke
  //check turret
  //return false if blocked by world
  //check for radar.
  
  local entity trace;
  
  trace = self;
  if( (self.flags & FL_TURRET) ){
    trace = self.e_cam;
  }
  
  traceline( trace.origin, t.origin, MOVE_WORLDONLY, self);
  
  if( trace_fraction < 1 ){
    return FALSE;
  }
  return TRUE;
};

float(entity t) ai_valid_target={
  local float val;
  val = FALSE;
  if ( t ){
    if( (t.flags & FL_NOTARGET) ){
      val = FALSE;
    }
    else{
      if( t.deadflag <= DEAD_NO ){
        switch( t.data_type ){
          case DATA_VEHC:
            val =  TRUE;
          case DATA_BLD:
            val =  TRUE;
          case DATA_MECH:
            val =  TRUE;
        }
      }
    }
  }
  
  return val;
};

entity( float radiius) ai_find_friend={
  local entity ally, friend;
  local float dist, rad;
  
  rad = radiius;
  
  ally = findchainfloat( i_faction, self.i_faction );
  while( ally ){
    dist = vlen( ally.origin - self.origin );
    if( dist <= rad ){
      rad = dist;
      if( ai_valid_target(ally) ){
        //heh, sloppy check for combat units
        if( ally.w_slot != world ){
          friend = ally;
        }
      }
    }
    ally = ally.chain;
  }
  return friend;
};

float() ai_find_target_visual={
  if( self.enemy ){
    return FALSE;
  }
  local entity targ, found;
  local float dist, rng;
  
  targ = findradius(self.origin, self.ai_view);
  dist = self.ai_view ;
  rng = dist;
  while( targ ){
    if( targ != self ){
      if( ai_valid_target(targ) ){
        if( targ.i_faction != self.i_faction ){
          if( ai_check_face(targ, self.ai_fov) ){
            if( ai_check_vis(targ) ){
              local float ndist;
              ndist = vlen(targ.origin - self.origin);
              if( targ.fog_alpha ){
                rng = rng - ( targ.fog_alpha * rng ); //FOG?
              }
              if(ndist < rng){
                rng = ndist;
                found = targ;
              }
            }
          }
        }
      }
    }
    targ = targ.chain;
  }
  
  if( found ){
    self.enemy = found;
    ai_sfx_spotted();
    return TRUE;
  }
  return FALSE;
};

float() ai_find_target_radar={
  if( self.enemy ){
    return FALSE;
  }
  local entity targ, found;
  local float dist, rng;
  
  targ = findchainflags(flags, FL_UNIT);
  dist = self.radar_range;
  rng = dist;
  while( targ ){
    if( targ != self ){
      if( ai_valid_target(targ) ){
        local float ndist, nrng;
        nrng = rng;
        ndist = vlen(targ.origin - self.origin);
        if( ndist <= rng ){
          if( (targ.flags & FL_CLIENT) ){
            if( !targ.stat_rdr_mode ){
              if( ndist <= (nrng / 2 ) ){
                if( ai_line_of_sight(targ) ){
                  nrng = ndist;
                  found = targ;
                  
                }
              }
            }
          }
          else{
            if(ndist < nrng){
              if( ai_line_of_sight(targ) ){
                nrng = ndist;
                found = targ;
              }
            }
          }
        }
      }
    }
    targ = targ.chain;
  }
  if( found ){
    self.enemy = found;
    ai_sfx_spotted();
    return TRUE;
  }
  return FALSE;
};

void( entity ally, entity targ, float override ) ai_give_target={
  local entity this;
  this = self;
  if( !(ally.enemy) || override){
    self = ally;
      self.enemy = this.enemy;
      ai_sfx_spotted();
    self = this;
  }
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
  
  makevectors(self.v_angle); 
  traceline (cam.origin + v_forward * 1, self.origin + (lead * wep.w_range), FALSE, self);
  
  return trace_endpos;
};

void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  local vector diff;
  
  this = self;
  wep_chain = self.w_slot;     
  self.v_angle = self.angles;
  if( (self.flags & FL_TURRET) ){
    self.v_angle = self.e_tor_c.angles;
    diff = vectoangles( self.enemy.origin - self.e_cam.origin);
    self.v_angle_x = diff_x * -1;
  }
  while(wep_chain){
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( (self.currentWeaponGroup & wep_chain.w_group) ){
          if( self.stat_trg_dist <= wep_chain.w_range ){
            if( !ai_attack_blockcheck(wep_chain) ){
              if( ai_attack_checkEne(wep_chain) ){
                self = wep_chain;
                  if( (self.p_dmgtype & EFF_STX) ){
                    if (this.enemy.sh_cur > self.p_damage / 2){
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

/*
  How does the AI react to being shot?
*/
void(entity bot, entity attacker) ai_damage_react={
  local entity this, friend;
  local float my_hp;
  local float enemy_hp, enemy_size;
  local float atk_hp, atk_size;
  local float engage;
  
  my_hp = util_getMechHpAverage(self);
  atk_hp = util_getMechHpAverage(attacker);
  atk_size = attacker.vec_size;
  
  if( attacker.i_faction == self.i_faction ){
    return;
  }
  
  if( !self.enemy ){
    self.enemy = attacker;
    self.th_missile();
    return;
  }
  
  if( self.enemy ){
    enemy_hp  = util_getMechHpAverage(self.enemy);
    enemy_size = self.enemy.vec_size;
    if( self.ai_rank > AI_RANK_REG ){
      if( atk_hp < enemy_hp ){
        if( ai_check_face( attacker, self.ai_fov) ){
          self.enemy = attacker;
          self.th_missile();
          return;
        }
      }
      if( atk_size > enemy_size ){
        if( atk_hp < enemy_hp ){
          self.enemy = attacker;
          self.th_missile();
          return;
        }
      }
    }
    if( ai_check_face( attacker, self.ai_fov) && !ai_check_face( self.enemy, self.ai_fov) ){
      self.enemy = attacker;
      self.th_missile();
      return;
    }
  }
};


/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont, vang;

  if( (self.flags & FL_TURRET) ){
    vang = self.e_tor_c.angles;
  }
  else{
    vang = self.angles;
  }
  
  viewpont = normalize(self.enemy.origin - self.e_cam.origin);
  makevectors( vang );
  traceline (self.e_cam.origin + v_forward * 1, self.e_cam.origin + viewpont*wep.w_range, FALSE, self);
  if( (wep.p_dmgtype & EFF_ARC) ){
    return FALSE; // arcing attacks don't need LoS
  }
  
  if(trace_ent == world){
    return TRUE;
  }
  if( trace_ent.i_faction == self.i_faction ){
    return TRUE;
  }
  
  if( (viewpont * v_forward) <= 0.95 ){
    return TRUE;
  }

  
  return FALSE;
};

/*
  Only used for AI_SPAWNFLAG_RANDDOMSTART
*/
entity() ai_node_pick_rand={
  local entity anode, spot;
  local float clr, total, pick;
  local string name, grpid;
  
  if( self.target ){
    anode = find(world, targetname, self.target);
    if( anode && anode.group ){
      grpid = anode.group;
      total = 0;
      clr = 0;
      while( clr <= 128 ){
        AI_NODES[clr] = world;
        clr = clr + 1;
      }
      
      anode = findchain( group, grpid);
      if( anode && (anode.flags & FL_NODE) ){  
        while( anode ){
          AI_NODES[total] = anode;
          total = total + 1;
          anode = anode.chain;
        }
        pick = rint(random() * total );
        spot = AI_NODES[pick];
      }
    }
    else{
      self.spawnflags = self.spawnflags - (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART);
    }
  }
  return anode;
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
    self.flags = self.flags | FL_NOSHOOT;
  }
  
};

/*
  ported over from Quake and adapted here
*/
float(entity targ) ai_range={
  return vlen( self.origin - targ.origin );
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

/*
  AI attempts to hold-off on making an attack until their accuracy is as best as
  it can be
*/
float( float bestAccuracy ) ai_wait_for_shot={
  if( self.accuracy <= bestAccuracy ){
    return TRUE;
  }
  return FALSE;
};

void() ai_lock_on={
  //can only lock-on to enemy units
  if( self.enemy.i_faction != self.i_faction ){
    if( util_lockOnChoke(self.enemy.origin) ){
      if( !(self.stat_lck_stt & LOCK_TARG_START) && !(self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_START;
        self.power_timer_segment = time;
        if(self.stat_rdr_mode){
          self.lock_timer = time + self.w_firetime;
        }
        else{
          self.lock_timer = time + (self.w_firetime * 2);
        }
      }
      if( time > self.lock_timer ){
        if( !(self.stat_lck_stt & LOCK_TARG_HAS) ){
          self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
          self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_HAS;
        }
      }
    }
    else{
      if( (self.stat_lck_stt & LOCK_TARG_START) ){
        self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
      }
      if( (self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_HAS);
      } 
      if( (self.enemy.stat_lck_stt & LOCK_PLYR) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLYR);
      }
    }
    
  }
};

//AI MAP FUNCS
/*
    called by any AI unit that needs to spawn onto the map.
    This function delegates HOW the AI should be spawned based on its starting parameters.
    
    if the AI is to be triggered by another object, then postpone full ini into the use() function
    if the AI is a multiple - count > 0, as in, 'create multiples', then delegate to ai_unit_make_multi()
    if the AI count is < 0 but there's a delay param, then delay ini for that amount of time
    else
    fall-through and create the ai
*/
float( void() ai_to_make ) ai_unit_setup={

  if( !self.nextVecChoice ){
    self.nextVecChoice = 1;
  }
  
  if( (self.spawnflags & AI_SPAWNFLAG_TRIGGERME) && (self.targetname) ){
    //checking the targetname is mostly for validation
    self.use = ai_unit_make_trigger;
    self.unit_ini = ai_to_make;
    //allows for multiple spawn even on the 'trigger only' setting
    self.spawnflags = self.spawnflags - (self.spawnflags & AI_SPAWNFLAG_TRIGGERME);
    return TRUE;
  }
  if( (self.delay > 0) && ( !(self.count) || (self.count < 1) ) ){
    //this is a delayed one-off
    self.use = multi_trigger;
    self.nextthink = time + self.delay;
    self.think = ai_to_make;
    return TRUE;
  }
  if( self.count > 0 ){
    self.use = multi_trigger;
    self.unit_ini = ai_to_make;
    self.nextthink = time + self.count1; //baked in automatically
    self.think = ai_unit_make_multi;
    return TRUE;
  }
  //fall-through, AI is cleared to happen
  return TRUE;
};

void() ai_unit_make_trigger={
  self.use = multi_trigger;
  self.think = self.unit_ini;
  self.nextthink = time + self.delay;
};

void() ai_unit_make_multi={
  if( self.count > 0 ){
    newmis = spawn();
    copyentity( self, newmis );
    newmis.unit_ini = self.unit_ini;
    stemp = self;
    self = newmis;
      self.unit_ini();
      self.use = multi_trigger;
    self = stemp;
    self.count = self.count - 1;
    self.nextthink = time + self.count1;
    self.think = ai_unit_make_multi;
    return;
  }
};

/*
  initialize weapon loadout default IF
  the weapon slot is not overridden -
  ie the map spawn call can override any and all weapon
  choices.
*/
void( float wep1, float wep2, float wep3, float wep4, float wep5, float wep6, float wep7, float wep8, float wep9) ai_ini_weapons={
  if( !self.next_wepn1 ){
    self.next_wepn1 = wep1;
  }
  if( !self.next_wepn2 ){
    self.next_wepn2 = wep2;
  }
  if( !self.next_wepn3 ){
    self.next_wepn3 = wep3;
  }
  if( !self.next_wepn4 ){
    self.next_wepn4 = wep4;
  }
  if( !self.next_wepn5 ){
    self.next_wepn5 = wep5;
  }
  if( !self.next_wepn6 ){
    self.next_wepn6 = wep6;
  }
  if( !self.next_wepn7 ){
    self.next_wepn7 = wep7;
  }
  if( !self.next_wepn8 ){
    self.next_wepn8 = wep8;
  }
  if( !self.next_wepn9 ){
    self.next_wepn9 = wep9;
  }
}; 