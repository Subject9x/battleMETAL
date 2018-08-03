/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/

void() ai_dest_walk;
void() ai_dest_run;
void() ai_dest_turn;
void() ai_dest_attack;
void() ai_dest_stand;
void() ai_vec_dest_die;
void() ai_vec_dest_die1;
void() ai_vec_dest_die1a;
void() ai_vec_dest_die2;

/*
  TH_WALK
*/
void() ai_dest_walk={

  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
      ai_action_next( self.th_run, 0.5, self.ai_action_mod );
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }

  //as long as AI has movetarget, go there
  if( self.movetarget ){
    movetogoal(self.m_fspeed * AI_WALK_SPD);
  }
  else{
    ai_action_next( self.th_stand, 1, self.ai_action_mod);
  }
};

/*
  TH_RUN
*/
void() ai_dest_run={
  if( !self.enemy ){
    if( self.movetarget ){
      ai_action_next( self.th_walk, 1.4, self.ai_action_mod );
      return;
    }
    else{
      ai_action_next( self.th_stand, 0.9, self.ai_action_mod );
      return;
    }
  }
  
  //enemy_infront = ai_target_infront( self.enemy, 0.95 );
  enemy_range = ai_range( self.enemy );
  enemy_yaw = vectoyaw( self.enemy.origin - self.origin );
  
  //stand and fire
  if( self.attack_state == AS_MISSILE ){
    //ai_action_next( self.th_attack, 0.9, self.ai_action_mod );
    return;
  }
  
  //if( ai_check_allattack() ){
    //self.attack_state = AS_MISSILE;
   // return;
 // }
  
  movetogoal( self.m_fspeed * AI_RUN_SPD );
};

/*
  TH_TURN
*/
void() ai_dest_turn={
  ChangeYaw();
  if( self.enemy ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if( ai_visible( self.enemy ) ){
      //if( ai_target_infront(self.enemy, 0.97) ){
        //ai_action_next( self.th_attack, 1, self.ai_action_mod );
        //return;
      //}
    }
    else{
      self.enemy = world;
    }
  }
  else{
    if( time > self.ai_viewtime ){
      if( ai_find_target_visual() ){
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        //ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
        return;
      }
      self.ai_viewtime  = time + self.ai_viewcheck;
    }
    if( time > self.ai_action_time ){
      ai_action_next( self.th_stand, 0.1, 0);
    }
  }
};

/*
  TH_ATTACK
*/
void() ai_dest_attack={
  if( self.enemy ){  
    if( ai_visible( self.enemy ) ){
      //if( ai_target_infront(self.enemy, 0.97) ){
        //if(  self.currentWeaponGroup > 0  ){
         //self.button0 = 1;
          //self.th_action = self.th_attack;
          //return;
        //}
      //}
      ai_action_next( ai_dest_turn, 1, self.ai_action_mod );
      return;
    }
    self.enemy = world;
  }
  ai_action_next( self.th_stand, 0.1, 0 );
};

/*
  TH_STAND
*/
void() ai_dest_stand={
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
      return;
    }
    else{
      ai_action_next( self.th_stand, 0.9, 0);
      return;
    }
  }
};

/*
  TANK DESTROYER PRIMARY THINK FUNCTION
*/
void() ai_dest_th={
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
    ai_ranged_attack();
    self.button0 = 0;
  }
  
  //if( self.th_action ){
   // self.th_action();
  //}
  
  self.SendFlags = self.SendFlags | SEND_FLAG_ORIGIN | SEND_FLAG_ANGLE | SEND_FLAG_DATA_IDX | SEND_FLAG_SHIELD_VAL | SEND_FLAG_RADAR_MODE | SEND_FLAG_FACTION;
  
  if( !(self.flags & FL_SKIPTHINK ) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_dest_th;
    self.nextthink = time + 0.05;
  }
};

/*
  TH_DIE Main
*/
void() ai_vec_dest_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();

  //basically overkill damage will just remove the tank (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.flags = self.flags | FL_SKIPTHINK;
    self.think = ai_vec_dest_die2;
    self.nextthink = time + 0.1;
    return;
  }
  ai_action_next( ai_vec_dest_die1, 120, 0);
};

/*
  Death animation - tank sits as a smoking wreck
*/
void() ai_vec_dest_die1={
  te_smoke_test(self.origin, '0 0 10', 2);
  if ( time > self.ai_action_time ){
    ai_action_next( ai_vec_dest_die1a, 300, 0);
    return;
  }
};
//stops smoking
void() ai_vec_dest_die1a={
  if ( time > self.ai_action_time ){
    self.flags = self.flags | FL_SKIPTHINK;
    self.think = ai_vec_dest_die2;
    self.nextthink = time + 0.1;
    return;
  }
};

/*
  explode the thing
*/
void() ai_vec_dest_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  AI SPAWN FUNCTION
*/
void() ai_vec_dest={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE){
		objerror ("ai_vec_dest - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();    
  data_iniVehc(self.nextVecChoice);
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  droptofloor();
   
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = 31;

  self.th_stand = ai_generic_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_generic_run;
  self.th_run_strafe = ai_generic_run_strafe;
  self.th_run_charge = ai_generic_run_charge;
  self.th_missile = ai_generic_missile;
  self.th_melee = ai_generic_melee;
  self.th_missile_strafe = ai_generic_missile_strafe;
  self.th_hunt = ai_generic_hunt;
  self.th_die = ai_vec_dest_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();

  self.think = ai_dest_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = (time + 7) + random()*1; //spread out thinks
  }
  else{
    self.nextthink = time + random()*1; //spread out thinks
  }
};