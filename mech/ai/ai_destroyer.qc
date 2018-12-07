/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/

void() ai_dest_stand;
void() ai_dest_run;
void() ai_dest_run_strafe;
void() ai_dest_melee;
void() ai_dest_missile;

void() ai_vec_dest_die;
void() ai_vec_dest_die1;
void() ai_vec_dest_die1a;
void() ai_vec_dest_die2;

/*
  ST_STAND
*/
void() ai_dest_stand={
  ai_update_accuracy( FALSE );  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};

/*
  ST_RUN
*/
void() ai_dest_run={
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis){
      if( enemy_range <= 200 ){
        if( enemy_infront ){
          ai_next_state( ST_MELEE );
          return;
        }
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          ai_next_state( ST_MISSILE );
          return;
        }
      }
      ai_walkgoal( AI_RUN_SPD );
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_STAND );
    return;
  }
};

/*
  ST_RUN_STRAFE
*/
void() ai_dest_run_strafe={
  
};

/*
  ST_MELEE
*/
void() ai_dest_melee={
  ai_update_accuracy( TRUE );  
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, 0.99 ) ){
      ai_attack();
    }
    if( !ai_yaw_back( self.m_bspeed * AI_WALK_SPD ) ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  ST_MISSILE
*/
void() ai_dest_missile={
  ai_update_accuracy( FALSE );  
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, 0.99 ) ){
      ai_attack();
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  ST_HUNT
*/


/*
  ST_HUNT_START
*/



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
  
  ai_state_control( self.attack_state );
  
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
  self.attack_state = -1;
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );

  self.think = ai_vec_dest_die1;
  self.ai_action_time = time + 120;
  
  //basically overkill damage will just remove the tank (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.think = ai_vec_dest_die2;
  }
  self.nextthink = time + 0.1;
};

/*
  Death animation - tank sits as a smoking wreck
*/
void() ai_vec_dest_die1={
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_fspeed) + (v_right * world.m_fspeed) + (v_up * world.m_fspeed);
  te_smoke_test(self.origin, sm + '0 0 10', 2);
  
  self.think = ai_vec_dest_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_vec_dest_die1a;
    self.ai_action_time = time + 120;
  }
  self.nextthink = time + 0.1;
};
//stops smoking
void() ai_vec_dest_die1a={
  self.think = ai_vec_dest_die1a;
  if( time > self.ai_action_time ){
    self.think = ai_vec_dest_die2;
  }
  self.nextthink = time + 0.1;
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

  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_dest_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_dest_run;
  self.th_run_strafe = ai_dest_run_strafe;
  self.th_missile = ai_dest_missile;
  self.th_melee = ai_dest_melee;
  self.th_die = ai_vec_dest_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();
  
  droptofloor();
  
  self.colormod = '0 0.75 1'; //DEBUG

  self.think = ai_dest_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = (time + 7) + random()*1; //spread out thinks
  }
  else{
    self.nextthink = time + random()*1; //spread out thinks
  }
};