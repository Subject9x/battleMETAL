/*
battleMETAL 
Author: Peter Roohr
Date: 7/16/2018
Overview: ai unit
  Stock Turret Unit
  an on-ground, static vehicle
*/

void() ai_turret_stand;
void() ai_turret_walk;
void() ai_turret_run;
void() ai_turret_missile;
void() ai_turret_run_strafe;
void() ai_turret_die;
void() ai_turret_die_burn;
void() ai_turret_th;
void() temp_chunk_burn;


void() ai_turret_stand={
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_WALK );
    self.ai_action_time = time + ai_randyaw_time( self.yaw_speed, 45, 120, 0.1);
    return;
  }
};

void() ai_turret_walk={
  ai_move_turn();
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_STAND );
    return;
  }
};

void() ai_turret_run={
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          ai_next_state( ST_MISSILE );
          return;
        }
        else{
          ai_next_state( ST_RUN_STRAFE );
          return;
        }
      }
    }
    else{
      ai_next_state( ST_STAND );
      return;
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};


void() ai_turret_run_strafe={
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, 0.98 ) ){
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  else{
    ai_next_state( ST_STAND );
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_turret_missile={
  ai_face_targ();
  if( ai_valid_target( self.enemy ) ){
    if( ai_check_face( self.enemy, 0.97) ){
      ai_attack();
    }
  }
  else{
    ai_next_state( ST_STAND );
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

//this should really be moved to an FX impl
void() temp_chunk_burn={
  if( time > self.delay){
    self.think = SUB_Remove;
  }
  else{  
    makevectors( world.v_angle );
    local vector sm;
    sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
    te_smoke_test(self.origin, sm + '0 0 15', 3);
    self.think = temp_chunk_burn;
  }
	self.nextthink = time + 0.1;
};

/*
  TH_DIE
*/
void() ai_turret_die={
  local vector new_org, vfx_org;
  local string nmdl, cmdl;
  
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  new_org = self.e_legs.origin;
  nmdl = self.e_legs.model;
  cmdl = self.model;
  setmodel(self, nmdl);
  setorigin(self, self.e_legs.origin);
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);  
  mech_player_compdie(self.e_legs);
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();
 
  //blow the stack
  local	entity missile;
    missile = spawn ();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_NOT;
    makevectors (self.angles);
    local vector randvec;
    randvec = randomvec();
    if(randvec_z < 0 ){
      randvec_z = 1;
    }
    missile.velocity = randvec + (150 * v_up) + (v_right * 100*random()) + (v_forward * 100*random() );
    missile.velocity_z = missile.velocity_z + 250 + 50*random();
    missile.avelocity = '375 125 250';
    missile.colormod = '0.15 0.15 0.15';
  // set missile duration
    missile.delay = 360;
    missile.nextthink = 0.1;
    missile.think = temp_chunk_burn;

	setmodel (missile, cmdl);
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + (v_up * self.c_bbx_x_z * 2));
  
  self.think = ai_turret_die_burn;
  self.ai_action_time = time + 360;
};

void() ai_turret_die_burn={  
  makevectors( world.v_angle );
  
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
  te_smoke_test(self.origin, sm + '0 0 10', 1);
  
  self.think = ai_turret_die_burn;
  self.nextthink = time + 0.1;
  
  if ( time > self.ai_action_time ){
    self.think = BecomeExplosion;
    self.nextthink = time + 0.01;
  }
};

/*
  AI TURRET MAIN THINK
*/
void() ai_turret_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while( wep ){
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
  
  self.think = ai_turret_th;
  self.nextthink = time + 0.05; 
};

/*
  SPAWN
*/
void() ai_turret={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE){
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniTurret( self.nextVecChoice );
  ai_pilot_ini_stats( ai_pilot_rank_byskill() );
  
  self.th_stand = ai_turret_stand;
  self.th_walk = ai_turret_walk;
  self.th_run = ai_turret_run;
  self.th_run_strafe = ai_turret_run_strafe;
  self.th_missile = ai_turret_missile;
  self.th_die = ai_turret_die;
  
  ai_initialize_system( ST_STAND );
  
  self.think = ai_turret_th;
  self.nextthink = time + (random()*0.5); //spread out thinks
};