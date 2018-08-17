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
void() ai_mech_sk_run;
void() ai_mech_sk_melee;
void() ai_mech_sk_missile_strafe;
void() ai_mech_sk_hunt;
void() ai_mech_sk_pain;

void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die2;

//MECH SKIRMISH STAND
void() ai_mech_sk_stand={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_stand");  //DEBUG
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov ) ){
      ai_leg_frame( leg_walk1 );
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    ai_generic_stand();
  }
};

//MECH SKIRMISH RUN
void() ai_mech_sk_run={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_run");  //DEBUG
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    //cons_logAFloat("enemy_range", enemy_range); //DEBUG
    
    if( enemy_vis ){
      if( enemy_range < ( 400 )){
        if( enemy_infront ){
          ai_next_state( ST_MELEE );
          if( self.ai_rank > AI_RANK_REG ){
            ai_leg_frame( leg_walk1 );
            ai_next_state( ST_RUN_STRAFE );
          }
          return;
        }
        ai_leg_frame( leg_walk1 );
        ai_next_state( ST_RUN_STRAFE );
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          self.lefty = self.lefty * -1;
          self.ai_dirs = self.angles;
          ai_leg_frame( leg_walk1 );
          ai_next_state( ST_MISSILE_STRAFE );
          return;
        }
      }
      if( enemy_range <= (self.ai_minrange * 2) ){
        if( enemy_infront ){
          self.goalentity = self.enemy;
          ai_leg_frame( leg_walk1 );
          ai_next_state( ST_HUNT );
          return;
        }
      }
      movetogoal( self.m_fspeed * AI_RUN_SPD );
    }
    else{
      self.goalentity = self.enemy;
      ai_leg_frame( leg_walk1 );
      ai_next_state( ST_HUNT );
      return;
    }
  }
  else{
    ai_leg_frame( leg_stand1 );
    ai_next_state( ST_STAND );
    return;
  }
};

//MECH SKIRMISH MELEE
void() ai_mech_sk_melee={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_melee");  //DEBUG
  
  ai_face_targ();
  
  if( ai_check_face( self.enemy, 0.50 ) ){
    if( self.ai_rank <= AI_RANK_REG ){
      if( !ai_yaw_back( self.m_bspeed * AI_WALK_SPD) ){
        ai_next_state( ST_MISSILE );
        return;
      }
    }
    if( ai_check_face( self.enemy, 0.97 ) ){
      ai_attack();
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

//MECH SKIRMISH MISSILE STRAFE
void() ai_mech_sk_missile_strafe={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_missile_strafe");  //DEBUG
  local float moved;
  
  ai_face_targ();
  
  moved = ai_walk_left( self.m_sspeed * AI_WALK_SPD );
  
  if( ai_check_face( self.enemy, 0.97 ) ){
    ai_attack();
  }
  
  if( !moved ){
    self.lefty = self.lefty * -1;
    moved = ai_walk_right( self.m_sspeed * AI_WALK_SPD );
    if( !moved ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

//MECH SKIRMISH HUNT
void() ai_mech_sk_hunt={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_hunt");  //DEBUG
  ai_walkgoal(AI_RUN_SPD);
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

//MECH SKIRMISH PAIN
void() ai_mech_sk_pain={
  //cons_logAString(ftos(self.attack_state), "ai_mech_sk_pain");  //DEBUG
  
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
  
  droptofloor();
  
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
  
  self.e_cam.SendFlags = -1;
  
  ai_state_control( self.attack_state );
  
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
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  droptofloor();
   
  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = -1;
  
  self.th_stand = ai_mech_sk_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_mech_sk_run;
  self.th_run_strafe = ai_generic_run_strafe;
  self.th_missile = ai_generic_missile;
  self.th_melee = ai_mech_sk_melee;
  self.th_missile_strafe = ai_mech_sk_missile_strafe;
  self.th_hunt = ai_mech_sk_hunt;
  self.th_pain = ai_mech_sk_pain;
  self.th_die = ai_mech_sk_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();
  
  self.think = ai_mech_sk_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};