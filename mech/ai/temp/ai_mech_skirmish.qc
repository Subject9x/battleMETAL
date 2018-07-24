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

void() ai_mech_sk_walk;

void() ai_mech_sk_run;
void() ai_mech_sk_run_strafe;
void() ai_mech_sk_run_straight;

float() ai_mech_sk_check;
void() ai_mech_sk_attack;

void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die1a;
void() ai_mech_sk_die2;

/*
  TH_STAND
*/
void() ai_mech_sk_stand={
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }
  
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
      ai_action_next( self.th_walk, 1.4, 0);
      ai_leg_frame( leg_walk1 );
      return;
    }
    else{
      ai_action_next( self.th_stand, 0.9, 0);
      ai_leg_frame( leg_stand1 );
      return;
    }
  }
};

/*
  TH_SENTRY
  Lost LoS to target, but before going back to previous task, stand and look around.
*/
void() ai_mech_sk_sentry={

};

/*
  TH_CHECK
  basically turning the CheckAnyAttack() functionality of quake into more
  of an interface
*/
float() ai_mech_sk_check={
  local vector spot1, spot2;
  local entity targ;
  local float i;
  
  targ = self.enemy;
  
  spot1 = self.origin;
  spot2 = targ.origin;
  
  traceline( spot1, spot2, FALSE, self );
  
  if( trace_inopen && trace_inwater ){
    return FALSE;
  }
  
  if( trace_ent != targ ){
    return FALSE;
  }
  
  if( self.stat_trg_dist > AI_RANGE_L ){
    return FALSE;
  }
  
  if( self.stat_trg_dist > self.ai_minrange ){
    cons_logAString("self.attack_state", "AS_STRAIGHT");  //DEBUG
    self.attack_state = AS_STRAIGHT;
    return TRUE;
  }
  
  if( self.stat_trg_dist < self.ai_minrange / 2 ){
    cons_logAString("self.attack_state", "AS_MELEE");  //DEBUG
    self.attack_state = AS_MELEE;
    return TRUE;
  }

  cons_logAString("self.attack_state", "AS_MISSILE");  //DEBUG
  self.attack_state = AS_MISSILE;
  return TRUE;
};

/*
  TH_WALK
*/
void() ai_mech_sk_walk={
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }
  if( time > self.ai_action_time ){
    ai_action_next( self.th_walk, 1.4, 0 );
    ai_leg_frame( leg_walk1 );
    return;
  }
  movetogoal(self.m_fspeed * AI_WALK_SPD);
};
 
/*
  TH_RUN
*/ 
void() ai_mech_sk_run={
  if( !self.enemy ){
    if( self.movetarget ){
      ai_action_next( self.th_walk, 1.4, self.ai_action_mod );
      ai_leg_frame( leg_walk1 );
      return;
    }
    else{
      ai_action_next( self.th_stand, 0.9, self.ai_action_mod );
      ai_leg_frame( leg_stand1 );
      return;
    }
  }
  
  enemy_infront = ai_target_infront( self.enemy, 0.95 );
  enemy_range = ai_range( self.enemy );
  enemy_yaw = vectoyaw( self.enemy.origin - self.origin );
  
  //strafe left / right attack
  if( self.attack_state == AS_MELEE ){
    local float rand;
    rand = random();
    if( rand < 0.5 ){
      if( self.lefty > 0 ){
        self.lefty = 0;
      }
      else{
        self.lefty = -90;
      }
    }
    else{
      if( self.lefty < 0 ){
        self.lefty = 0;
      }
      else{
        self.lefty = 90;
      }
    }
    if( !self.lefty == 0 ){
      ai_action_next( ai_mech_sk_run_strafe, 3, self.ai_action_mod );
      ai_leg_frame( leg_walk1 );
      return;
    }
    self.attack_state = AS_MISSILE;
    return;
  }
  
  if( self.attack_state == AS_STRAIGHT ){
    ai_action_next( ai_mech_sk_run_straight, 1.2, self.ai_action_mod );
    ai_leg_frame( leg_walk1 );
    return;
  }
  
  //stand and fire
  if( self.attack_state == AS_MISSILE ){
    ai_action_next( self.th_attack, 0.9, self.ai_action_mod );
    ai_leg_frame( leg_stand1 );
    return;
  }
  
  if( ai_check_allattack() ){
    cons_logAString("ai_check_allattack", "targ visible");  //DEBUG
    return;
  }
  
  movetogoal( self.m_fspeed * AI_RUN_SPD );
};

void() ai_mech_sk_run_strafe={
  if( self.enemy ){
    ai_face_targ();
    if( walkmove( self.angles_y + self.lefty, self.m_fspeed * AI_RUN_SPD ) ){
      self.e_legs.v_angle_y = anglemod(90 - self.angles_y + self.lefty) ;
      droptofloor();
    }
    if( ai_target_infront( self.enemy, 0.95 ) ){
      if(  self.currentWeaponGroup > 0 ){
        if( random() <= self.ai_attack_time ){
          self.button0 = 1;
        }
      }
    }
    if( time > self.ai_action_time ){
      self.lefty = self.angles_y;
      self.e_legs.v_angle_y = self.angles_y;
      ai_action_next( self.th_run, 0.9, self.ai_action_mod );
      ai_leg_frame( leg_walk1 );
      return;
    }
  }
  self.lefty = self.angles_y;
  self.e_legs.angles_y = self.angles_y;
  ai_action_next( self.th_stand, 0.9, self.ai_action_mod );
  ai_leg_frame( leg_walk1 );
  return;

};

void() ai_mech_sk_run_straight={
  if( self.enemy ){
    ai_face_targ();
    movetogoal( self.m_fspeed * AI_RUN_SPD );
    if( ai_target_infront(self.enemy, 0.95) ){
      if( random() <= self.ai_attack_time){
        if(  self.currentWeaponGroup > 0 ){
          if( random() <= self.ai_attack_time ){
            self.button0 = 1;
          }
        }
      }
    }
    if( time > self.ai_action_time ){
      self.e_legs.v_angle_y = self.angles_y;
      ai_action_next( self.th_run, 0.9, self.ai_action_mod );
      ai_leg_frame( leg_walk1 );
      return;
    }
  }
  self.lefty = self.angles_y;
  self.e_legs.angles_y = self.angles_y;
  ai_action_next( self.th_stand, 0.9, self.ai_action_mod );
  ai_leg_frame( leg_walk1 );
  return;
};

/*
  TH_ATTACK
*/ 
void() ai_mech_sk_attack={
  ai_face_targ();
  if( ai_target_infront(self.enemy, 0.95) ){
    if( random() <= self.ai_attack_time){
      if(  self.currentWeaponGroup > 0 ){
        if( random() <= self.ai_attack_time ){
          self.button0 = 1;
        }
      }
    }
  }

  if( time > self.ai_action_time ){
    ai_action_next( self.th_run, 1.1, self.ai_action_mod );
    ai_leg_frame( leg_walk1 );
    return;
  }
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
  mech_player_compdie(self.e_cam);
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
    self.button0 = 0;
  }
  
  self.SendFlags = 31;
  if( self.th_action ){
    self.th_action();
  }
  
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
  
  self.th_check = ai_mech_sk_check;
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
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};