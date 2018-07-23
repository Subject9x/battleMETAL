/*
battleMETAL 
Author: Peter Roohr
Date: 7/20/2018
Overview: ai unit
  Mech - Skirmisher
  an on-ground, turreted, walking unit
  skirmishers play to engage targets at medium to close range
  they can strafe left and right against targets
*/

void() ai_mech_sk_stand;
void() ai_mech_sk_sentry;
void() ai_mech_sk_turn;
void() ai_mech_sk_walk;
void() ai_mech_sk_run;
void() ai_mech_sk_run_strafe;
void() ai_mech_sk_attack;
void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die1a;
void() ai_mech_sk_die2;

/*
  TH_STAND
*/
void() ai_mech_sk_stand={
  ChangeYaw();
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
      ai_leg_frame( leg_stand1 );
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }
  if( self.enemy ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if( ai_visible(self.enemy) ){
      if( ai_target_infront(self.enemy, 0.97) ){
        ai_action_next( self.th_run, 1, self.ai_action_mod );
        ai_leg_frame( leg_walk1 );
        return;
      }
      ai_action_next( ai_mech_sk_turn, 0.5, self.ai_action_mod );
      ai_leg_frame( leg_stand1 );
      return;
    }
    else{
      if( self.ai_hunt_total < AI_HUNT_VET ){
        if( ai_hunt_dropnode( self.th_walk ) ){
          self.enemy = world;
          return;
        }
      }
      self.enemy = world;
      return;
    }
  }
  
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
      ai_action_next( self.th_walk, 2, self.ai_action_mod);
      ai_leg_frame( leg_walk1 );
      return;
    }
    else{
      local float turn;
      turn = ai_randyaw_time( self.yaw_speed, 45, 180, 5); 
      self.ai_action_time = time + turn + self.ai_action_mod;
    }
  }
};

/*
  TH_SENTRY
  Lost LoS to target, but before going back to previous task, stand and look around.
*/
void() ai_mech_sk_sentry={
  ChangeYaw();
  if( self.angles_y == self.ideal_yaw ){
    self.ideal_yaw = anglemod(45 + crandom() * 180 - self.angles_y);
  }
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
      ai_leg_frame( leg_stand1 );
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }
  if( time > self.ai_action_time ){
    if( self.enemy ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      if( ai_visible( self.enemy ) ){
        if( ai_target_infront(self.enemy, 0.97) ){
          ai_action_next( self.th_attack, 1, self.ai_action_mod );
          ai_leg_frame( leg_stand1 );
          return;
        }
      }
      else{
        self.enemy = world;
      }
    }
    else{
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin);
      ai_action_next( self.th_walk, 4, self.ai_action_mod );
      ai_leg_frame( leg_walk1);
      return;
    }
  }
};


/*
  TH_TURN
*/
void() ai_mech_sk_turn={
  ChangeYaw();
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
      return;
    }
    self.ai_viewtime  = time + self.ai_viewcheck;
  }
  if( self.enemy ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if( ai_visible( self.enemy ) ){
      if( ai_target_infront(self.enemy, 0.97) ){
        
        ai_action_next( self.th_attack, 1, self.ai_action_mod );
        return;
      }
    }
    else{
      if( self.ai_hunt_total < AI_HUNT_VET ){
        if( ai_hunt_dropnode( self.th_walk ) ){
          self.enemy = world;
          return;
        }
      }
      self.enemy = world;
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_action_next( self.th_stand, 0.1, 0);
    ai_leg_frame( leg_stand1 );
    return;
  }
};

/*
  TH_WALK
*/
void() ai_mech_sk_walk={
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
      ai_action_next( self.th_run, 0.5, self.ai_action_mod );
      ai_leg_frame( leg_walk1 );
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }

  //as long as AI has movetarget, go there
  if( self.goalentity ){
    cons_logAString("self.goalentity", self.goalentity.targetname); //DEBUG
    movetogoal(self.m_fspeed * AI_WALK_SPD);
    return;
  }
  else{
    ai_action_next( self.th_stand, 1, self.ai_action_mod);
    ai_leg_frame( leg_stand1 );
    return;
  }
};
 
/*
  TH_RUN
*/ 
void() ai_mech_sk_run={

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  movetogoal(self.m_fspeed * AI_RUN_SPD);
  if( time > self.ai_action_time ){
    if( self.enemy ){
      if( ai_visible(self.enemy) ){
        if( ai_target_infront(self.enemy, 0.95) ){
          if( self.currentWeaponGroup > 0 ){
            ai_action_next( self.th_attack, 2, self.ai_action_mod );
            ai_leg_frame( leg_stand1 );
            return;
          }
          ai_action_next( self.th_run, 0.2, self.ai_action_mod );
          ai_leg_frame( leg_walk1 );
          return;
        }
        ai_action_next( ai_mech_sk_turn, 0.5, self.ai_action_mod );
        ai_leg_frame( leg_stand1 );
        return;
      }
      else{
        if( self.ai_hunt_total <= AI_HUNT_VET ){
          if( ai_hunt_dropnode( self.th_walk ) ){
            self.enemy = world;
            return;
          }
        }
        self.enemy = world;
      }
    }
    ai_action_next( self.th_stand, 0, self.ai_action_mod );
    ai_leg_frame( leg_stand1 );
    return;
  }
};

void() ai_mech_sk_run_strafe={
  if( self.enemy ){
    self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin);
    ChangeYaw();
    if( walkmove( self.ideal_yaw + self.lefty, self.m_fspeed * AI_RUN_SPD) ){
      self.e_legs.v_angle_y = anglemod(self.ideal_yaw + self.lefty);
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_action_next( ai_mech_sk_turn, 0.1, self.ai_action_mod );
    ai_leg_frame( leg_stand1 );
    return;
  }
};

/*
  TH_ATTACK
*/ 
void() ai_mech_sk_attack={

  if( self.enemy ){  
    if( ai_visible( self.enemy ) ){
      if( ai_target_infront(self.enemy, 0.95) ){
        if(  self.currentWeaponGroup > 0 ){
          self.button0 = 1;
          self.th_action = self.th_attack;
          return;
        }
      }
      if( self.stat_trg_dist <= AI_RANGE_S ){
        ai_action_next( ai_mech_sk_turn, 0.5, self.ai_action_mod );
        ai_leg_frame( leg_stand1 );
        return;
      }
    }
    ai_action_next( self.th_run, 2, self.ai_action_mod);
    ai_leg_frame( leg_walk1 );
    return;
  }
  ai_action_next( self.th_stand, 0.1, 0 );
  ai_leg_frame( leg_stand1 );
  self.ai_viewtime = time + self.ai_viewcheck;
};

/*
  TH_DIE
*/ 
void() ai_mech_sk_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.05 0.05 0.05';
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  ai_leg_frame( leg_stand1 );
    //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();
  
  //basically overkill damage will just remove the mech (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.flags = self.flags | FL_SKIPTHINK;
    self.think = ai_mech_sk_die2;
    self.nextthink = time + 0.1;
    return;
  }
  ai_action_next( ai_mech_sk_die1, 120, 0);
};

/*
  smoking wreck
*/
void() ai_mech_sk_die1={
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
  te_smoke_test(self.origin, sm + '0 0 5', 3);
  te_smoke_test(self.e_tor_l.origin, sm + '0 0 5', 1);
  te_smoke_test(self.e_tor_r.origin, sm + '0 0 5', 1);
  
  if ( time > self.ai_action_time ){
    ai_action_next( ai_mech_sk_die1a, 300, 0);
    return;
  }
};
void() ai_mech_sk_die1a={
  if ( time > self.ai_action_time ){
    self.flags = self.flags | FL_SKIPTHINK;
    self.think = ai_mech_sk_die2;
    self.nextthink = time + 0.1;
    return;
  }
};

//explode
void() ai_mech_sk_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  SKIRMISHER MECH PRIMARY THINK FUNCTION
*/
void() ai_mech_sk_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
  
  if( !self.deadflag ){
    if( self.enemy ){
      if( ai_valid_target( self.enemy ) ){
        self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
        ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
      }
      else{ 
        self.enemy = world;
      }
    }  
    if(self.e_legs.frame != $l_stand1){
      self.e_legs.angles_y = self.angles_y;
    }
    ai_ranged_attack();
    if( self.button0 ){
      self.button0 = 0;
    }
  }

  if( self.th_action ){
    self.th_action();
  }
  
  self.SendFlags = self.SendFlags | SEND_FLAG_ORIGIN | SEND_FLAG_ANGLE | SEND_FLAG_DATA_IDX | SEND_FLAG_SHIELD_VAL | SEND_FLAG_RADAR_MODE | SEND_FLAG_FACTION;
  
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_mech_sk_th;
    self.nextthink = time + 0.05;
  }
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE){
		objerror ("ai_mech_skirmish - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
    
  data_iniMech(self.nextVecChoice);
  ai_pilot_ini_stats(self.ai_rank);

  if( !self.pausetime ){
    self.pausetime = 999999;
  }
  
  self.th_stand = ai_mech_sk_stand; //-> th_stand is used as the unit's main think function
  self.th_walk = ai_mech_sk_walk; //-> th_walk is used the unit's 'Action' function, only 1 action execution per frame
  self.th_run = ai_mech_sk_run;
  self.th_attack = ai_mech_sk_attack;
  self.th_die = ai_mech_sk_die;
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  droptofloor();
   
  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = 31;

  ai_walk_setup();

  self.think = ai_mech_sk_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = (time + 7) + random()*1; //spread out thinks
  }
  else{
    self.nextthink = time + random()*1; //spread out thinks
  }
};