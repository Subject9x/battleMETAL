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
    trace = self.cockpit;
  }
  
  traceline( trace.origin, t.origin, MOVE_WORLDONLY, self);
  
  if( trace_fraction < 1 ){
    return FALSE;
  }
  return TRUE;
};


void( entity t ) ai_call_for_help={
  local float allies;
  local entity ally;
  
  ai_sfx_help();
  ally = findchainflags( flags, FL_MONSTER );
  while( ally ){
    if( ai_valid_target(ally) ){
      if( vlen( ally.origin - self.origin ) <= self.ai_view ){
        if( ally != self ){
          if( (ally.flags & FL_UNIT) && !(ally.flags & FL_DISARMED)){
            ai_give_target( ally, t, (self.ai_rank <= ally.ai_rank) );
            allies = allies + 1;
          }
        }
      }
    }
    ally = ally.chain;
  }
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
  
  ally = findchainfloat( faction, self.faction );
  while( ally ){
    if( (ally.flags & FL_UNIT) ){
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
  local float rng, fog, fogLen, ndist;
  
  targ = findradius(self.origin, self.ai_view);
  rng =  self.ai_view;
  if( self.fog_alpha ){
    fogLen = self.fog_dist_y - self.fog_dist_x;
    
    fog = self.fog_alpha * self.fog_density;
    fog = fog * fogLen;
    
    rng = self.ai_view - fogLen;
    if( rng < AI_RANGE_S ){
      rng = AI_RANGE_S;
    }
    rng = rng + fog;
  }

  while( targ ){
    if( targ != self ){
      if( targ.faction != self.faction ){
        if( ai_valid_target(targ) ){
          if( ai_check_face(targ, self.ai_fov) ){
            if( ai_check_vis(targ) ){
              ndist = vlen(targ.origin - self.origin);
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
    if( (self.flags & FL_DISARMED) ){
      if( self.stat_rdr_mode ){
        local entity ally;        
        ai_sfx_help();
        ally = ai_find_friend( self.radar_range );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

float() ai_find_target_radar={
  if( self.enemy ){
    return FALSE;
  }
  local entity targ, found;
  local float rng, ndist, nrng;
  
  targ = findchainflags(flags, FL_UNIT);
  rng = self.radar_range;
  while( targ ){
    if( targ != self ){
      if( targ.faction != self.faction ){
        if( ai_valid_target(targ) ){
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
    }
    targ = targ.chain;
  }
  if( found ){
    if( (self.flags & FL_DISARMED) ){
      if( self.stat_rdr_mode ){
        local entity ally;        
        ai_sfx_help();
        ally = ai_find_friend( self.radar_range );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

void( entity ally, entity targ, float override ) ai_give_target={
  local entity this;
  if( !ally.th_missile ){
    return;
  }
  this = self;
  if( !ai_valid_target(ally.enemy) || override){
    self = ally;
      self.enemy = this.enemy;
      ai_sfx_roger();
      self.th_missile();
    self = this;
  }
};

vector(entity wep) ai_attack_trace={
  local entity cam;
  local vector lead;
  lead = '1 1 1';
  if( self.enemy ){
    lead = self.enemy.origin - (self.enemy.velocity * self.ai_leading);
    lead = normalize(lead - self.origin);
  }
  cam = self.cockpit;
  
  makevectors(self.v_angle); 
  traceline (cam.origin + v_forward * 1, self.origin + (lead * wep.w_range), FALSE, self);
  
  return trace_endpos;
};

/*
  Main AI attack function, called when AI's self.button0 = 1.
  Runs through AI's weapon list, and finds which are able to be fired, then calls that function.
*/
void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  local vector diff;
  
  self.ai_weaponEnergy = 0;
  this = self;
  wep_chain = self.w_slot;     
  self.v_angle = self.angles;
  if( (self.flags & FL_TURRET) ){
    //if the AI has a turret, use the turret's angles for Line of Sight offset origins.
    self.v_angle = self.torsoCenter.angles;
    diff = vectoangles( self.enemy.origin - self.cockpit.origin);
    self.v_angle_x = diff_x * -1; //still correcting for age-old pitch bug
  }
  while(wep_chain){
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( (self.currentWeaponGroup & wep_chain.w_group) ){
          if( !ai_attack_blockcheck(wep_chain) ){
            self = wep_chain;
              if( ai_check_face(this.enemy, 0.95) ){
                self.w_attack();
                fired = fired + 1;
              }
            self = this;
          }
        }
      }
    }
    else{
      //Weapon has a bust-fire mode, and has been fired at least once, run through the burst.
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
float(entity bot, entity attacker) ai_damage_react={
  local float my_hp;
  local float enemy_hp, enemy_size;
  local float atk_hp, atk_size;

  if( (self.flags & FL_DISARMED) ){
    ai_call_for_help( attacker );
    return FALSE;
  }
  
  if( attacker.faction == self.faction ){
    return FALSE;
  }
  
  if( !self.enemy ){
    self.enemy = attacker;
    self.th_missile();
    ai_sfx_spotted();
    if( self.th_pain ){
      if( self.ai_rank < AI_RANK_VET ){
        if( util_getMechHpAverage(self) <= 0.25){
          if( random() <= 0.5 ){
            
            self.th_pain( self.enemy );
          }
        }
      }
    }
    return TRUE;
  }
  
  my_hp = util_getMechHpAverage(self);
  atk_hp = util_getMechHpAverage(attacker);
  atk_size = attacker.vec_size;
  
  if( self.enemy ){
    enemy_hp  = util_getMechHpAverage(self.enemy);
    enemy_size = self.enemy.vec_size;
    if( self.ai_rank > AI_RANK_REG ){
      if( atk_hp < enemy_hp ){
        if( ai_check_face( attacker, self.ai_fov) ){
          self.enemy = attacker;
          self.th_missile();
          return TRUE;
        }
      }
      if( atk_size > enemy_size ){
        if( atk_hp < enemy_hp ){
          self.enemy = attacker;
          self.th_missile();
          return TRUE;
        }
      }
    }
    if( ai_check_face( attacker, self.ai_fov) && !ai_check_face( self.enemy, self.ai_fov) ){
      self.enemy = attacker;
      self.th_missile();
      return TRUE;
    }
  }
  return FALSE;
};


/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity,
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont, vang;

  if( (self.flags & FL_TURRET) ){
    vang = self.torsoCenter.angles;
  }
  else{
    vang = self.angles;
  }
  
  viewpont = normalize(self.enemy.origin - self.cockpit.origin);
  makevectors( vang );
  traceline (self.cockpit.origin + v_forward * 1, self.cockpit.origin + viewpont*wep.w_range, FALSE, self);
  if( (wep.damageType & EFF_ARC) ){
    return FALSE; // arcing attacks don't need LoS
  }
  
  if(trace_ent == world){
    return TRUE;
  }
  if( trace_ent.faction == self.faction ){
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
  local entity anode;
  local float clr, total, pick;
  local string grpid;
  
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
        anode = AI_NODES[pick];
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

/*
  AI checks to see if it has enough energy to fire this weapon in relation
  to the total energy cost of ALL its energy weapons.
*/  
float(entity wep) ai_attack_checkEne={
  if( self.energy >= self.ai_weaponEnergy ){
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
  if( self.enemy.faction != self.faction ){
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
      if( (self.enemy.stat_lck_stt & LOCK_PLAYER) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLAYER);
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
    return FALSE;
  }
  if( (self.delay > 0) && ( !(self.count) || (self.count < 1) ) ){
    //this is a delayed one-off
    self.use = multi_trigger;
    self.nextthink = time + self.delay;
    self.think = ai_to_make;
    return FALSE;
  }
  if( self.count > 0 ){
    self.use = multi_trigger;
    self.unit_ini = ai_to_make;
    self.nextthink = time + self.count1; //baked in automatically
    self.think = ai_unit_make_multi;
    return FALSE;
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