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
void() mech_sk_stand;
void() mech_sk_stand_scan;
void() mech_sk_walk;
void() mech_sk_walk_scan;

void() mech_sk_run;
void() mech_sk_run_strafe;
void() mech_sk_run_charge;

void() mech_sk_attack;
void() mech_sk_walk_attack;
void() mech_sk_walk_strafe_attack;
void() mech_sk_walk_fight;

void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die1a;
void() ai_mech_sk_die2;


void() mech_sk_stand={
  cons_logAString("state", "mech_sk_stand"); //DEBUG
  if( time > self.ai_viewtime ){
    self.ai_viewtime = time + self.ai_viewcheck;
    ai_next_state( ST_STAND_SCAN );
    return;
  }
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
      ai_next_state( ST_WALK );
      return;
    } 
    ai_next_state( ST_STAND );
  }
};

void() mech_sk_stand_scan={
  cons_logAString("state", "mech_sk_stand_scan"); //DEBUG
  if( ai_find_target_visual() ){
    ai_next_state( ST_RUN );
    return;
  }
  if( time > self.ai_action_time ){
    self.ai_viewtime = time + self.ai_viewcheck;
    if( self.movetarget ){
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};

void() mech_sk_walk={
  cons_logAString("state", "mech_sk_walk"); //DEBUG
  if( time > self.ai_viewtime ){
    self.ai_viewtime = time + self.ai_viewcheck;
    ai_next_state( ST_WALK_SCAN );
    return;
  }
  movetogoal(self.m_fspeed * AI_WALK_SPD);
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      self.goalentity = self.movetarget;
      self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
      ai_next_state( ST_WALK );
      return;
    } 
    ai_next_state( ST_STAND );
  }
};

void() mech_sk_walk_scan={
  cons_logAString("state", "mech_sk_walk_scan"); //DEBUG
  if( ai_find_target_visual() ){
    return;
  }
  movetogoal(self.m_fspeed * AI_WALK_SPD);
  if( time > self.ai_action_time ){
    self.ai_viewtime = time + self.ai_viewcheck;
    self.goalentity = self.movetarget;
    self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
    ai_next_state( ST_WALK );
    return;
  }
};

void() mech_sk_run={
  if( ai_valid_target( self.enemy ) ){
    cons_logAString("state", "mech_sk_run"); //DEBUG

    enemy_range = ai_range( self.enemy );
    enemy_yaw = vectoyaw( self.enemy.origin - self.origin );
    enemy_infront = ai_target_infront( self.enemy, 0.9 );
    
    cons_logAFloat("enemy_range", enemy_range );  //DEBUG
    
    if( enemy_range > self.ai_minrange ){ 
      movetogoal(self.m_fspeed * AI_RUN_SPD);
      ai_next_state( ST_RUN );
      return;
    }
    
    self.ideal_yaw = enemy_yaw;
    
    if( enemy_range < 200 ){
      if( enemy_infront ){
        self.lefty = 1 - self.lefty;
        ai_next_state( ST_RUN_CHARGE );
        return;
      }
      self.lefty = 0;
      ai_next_state( ST_FIGHT_WALK );
      return;
    }
    
    if( enemy_range <= ( self.ai_minrange / 2 ) ){
      if( enemy_infront ){
        
      }
    }
    
    if( enemy_range <= self.ai_minrange ){
      if( enemy_infront ){
        ai_next_state( ST_ATTACK );
        return;
      }
    } 
    movetogoal(self.m_fspeed * AI_RUN_SPD);
  }
  else{
    if( ai_find_target_visual() ){
      return;
    }
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};

void() mech_sk_run_charge={
  cons_logAString("state", "mech_sk_run_charge"); //DEBUG
  ai_charge_side();
  if( time > self.ai_action_time ){
    self.lefty = 0;
    ai_next_state( ST_RUN );
    return;
  }
};

void() mech_sk_attack={
  cons_logAString("state", "mech_sk_attack"); //DEBUG
  ai_face_targ();
  if( ai_target_infront( self.enemy, 0.95 ) ){
    ai_make_attack();
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

void() mech_sk_walk_attack={

};

void() mech_sk_walk_strafe_attack={

};

void() mech_sk_walk_fight={
  cons_logAString("state", "mech_sk_walk_fight"); //DEBUG
  local float infront;
  infront = ai_target_infront( self.enemy, 0.95 );
  
  ai_face_targ();
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
  switch( self.lefty ){
    case 0:
      if( infront ){
        ai_make_attack();
      }
      ai_move_backward( self.ideal_yaw, self.m_fspeed * AI_WALK_SPD);
      break;
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
  self.attack_state = -1;
  
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
  
  self.think = ai_mech_sk_die1;
  self.ai_action_time = time + 300;
  //basically overkill damage will just remove the mech (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.think = ai_mech_sk_die2;
  }
  self.nextthink = time + 0.1;
};

/*
  smoking wreck
*/
void() ai_mech_sk_die1={
  cons_logAString("state", "ai_mech_sk_die1"); //DEBUG
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
  te_smoke_test(self.origin, sm + '0 0 5', 3);
  te_smoke_test(self.e_tor_l.origin, sm + '0 0 5', 1);
  te_smoke_test(self.e_tor_r.origin, sm + '0 0 5', 1);
  
  self.think = ai_mech_sk_die1;
  if( time > self.ai_action_time ){
    self.think = ai_mech_sk_die2;
  } 
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sk_die2={
  cons_logAString("state", "ai_mech_sk_die2"); //DEBUG
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
  
  switch( self.attack_state ){
    case ST_STAND:
      mech_sk_stand();
      break;
    case ST_STAND_SCAN:
      mech_sk_stand_scan();
      break;
    case ST_WALK:
      mech_sk_walk();
      break;
    case ST_WALK_SCAN:
      mech_sk_walk_scan();
      break;
    case ST_RUN:
      mech_sk_run();
      break;
    case ST_RUN_STRAFE:
    
      break;
    case ST_RUN_CHARGE:
      mech_sk_run_charge();
      break;
    case ST_ATTACK:
      mech_sk_attack();
      break;
    case ST_ATTACK_WALK:
    
      break;
    case ST_ATTACK_WALK_STRAFE:
    
      break;
    case ST_HUNT:
    
      break;
    case ST_FIGHT_WALK:
      mech_sk_walk_fight();
      break;
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
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_mech_skirmish - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniMech(self.nextVecChoice);
  ai_pilot_ini_stats(self.ai_rank);
  
  self.th_die = ai_mech_sk_die;
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  self.movetype = MOVETYPE_STEP;
  
  droptofloor();
   
  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = 31;

  ai_walk_setup();

  self.attack_state = ST_STAND;
  self.ai_action_time = time + self.ai_action_mod;
  
  self.think = ai_mech_sk_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};