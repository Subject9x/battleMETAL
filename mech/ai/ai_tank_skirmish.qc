/*
battleMETAL 
Author: Peter Roohr
Date: 9/21/2018
Overview: ai unit
  Tank - Skirmisher
  kinda like a mech skirmisher but slower,
  a default tank
*/

void() ai_tank_sk_stand;
void() ai_tank_sk_run;
void() ai_tank_sk_melee;
void() ai_tank_sk_missile;
void() ai_tank_sk_missile_strafe;
void() ai_tank_sk_hunt;
void() ai_tank_sk_pain;

void() ai_tank_sk_die;
void() ai_tank_sk_die1;
void() ai_tank_sk_die2;

void() ai_tank_sk_stand={
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

void() ai_tank_sk_run={
  if( ai_valid_target( self.enemy ) ){
    ai_turret_set_state( TR_TARG );
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range < ( 400 )){
        if( enemy_infront ){
          ai_next_state( ST_MELEE );
          self.ai_action_time = self.ai_action_time + 2;
          self.ai_dir = anglemod( self.ideal_yaw + 45 );
          return;
        }
        ai_leg_frame( leg_stand1 );
        ai_next_state( ST_STAND );
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          ai_leg_frame( leg_stand1 );
          ai_next_state( ST_MISSILE );
          return;
        }
        ai_leg_frame( leg_stand1 );
        ai_next_state( ST_STAND );
        return;
      }
      if( enemy_range <= (self.ai_minrange * 2) ){
        if( enemy_infront ){
          ai_next_state( ST_RUN_STRAFE );
          ai_leg_frame( leg_walk1 );
          self.ai_action_time = self.ai_action_time + 5;
          return;
        }
        ai_leg_frame( leg_stand1 );
        ai_next_state( ST_STAND );
        return;
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
    ai_turret_set_state( TR_NORM );
    ai_leg_frame( leg_stand1 );
    ai_next_state( ST_STAND );
    return;
  }
};

void() ai_tank_sk_melee={
  ai_face_targ();
  if( ai_check_face(self.enemy, 0.6) ){
    local float moved, avg;

    avg = (self.m_fspeed + self.m_sspeed) / 2;
    
    moved = ai_move( self.ai_dir, avg * AI_RUN_SPD);
    if( !moved ){
      ai_leg_frame( leg_walk1 );
      ai_next_state( ST_RUN );
      return;
    }
  }
  
  if( time > self.ai_action_time ){
    ai_leg_frame( leg_stand1 );
    ai_next_state( ST_MISSILE );
    return;
  }
};

void() ai_tank_sk_missile={
  ai_face_targ();
  if( ai_check_face( self.enemy, 0.92 ) ){
    if( ai_attack() ){
      ai_leg_frame( leg_stand1 );
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_leg_frame( leg_walk1 );
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_tank_sk_missile_strafe={
  local float moved;
  
  ai_face_targ();
  ai_turret_set_state( TR_TARG );
  
  moved = ai_walk_right( self.m_sspeed * AI_WALK_SPD );
  
  if( ai_check_face( self.enemy, 0.92 ) ){
    ai_attack();
  }
  
  if( !moved ){
    self.lefty = self.lefty * -1;
    moved = ai_walk_left( self.m_sspeed * AI_WALK_SPD );
    if( !moved ){
      ai_leg_frame( leg_stand1 );
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  
  if( time > self.ai_action_time ){
    ai_leg_frame( leg_walk1 );
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_tank_sk_hunt={
  ai_walkgoal( AI_RUN_SPD );
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_tank_sk_pain={

};

void() ai_tank_sk_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();

  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_tor_c);
  
  setsize( self, '-8 -8 -3' , '8 8 3' );
  setorigin( self, self.origin);
  
  self.think = ai_tank_sk_die1;
  self.ai_action_time = time + 120;
  
  //basically overkill damage will just remove the tank (nice and clean)
  if( self.health <= (self.max_health / 1.15) * -1 ){
    self.think = ai_tank_sk_die2;
  }
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1a={
  self.think = ai_tank_sk_die1a;
  if( time > self.ai_action_time ){
    self.think = ai_tank_sk_die2;
  }
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={

  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
  te_smoke_test(self.origin, sm + '0 0 10', 2);
  
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_tank_sk_die1;
    self.ai_action_time = time + 120;
  }
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  SKIRMISHER TANK THINK FUNCTION
*/
void() ai_tank_sk_th={
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
    
      
    if( (self.flags & FL_TURRET) ){
      ai_state_control( self.attack_state ); 
      ai_turret_control();
    }
  }
  
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_tank_sk_th;
    self.nextthink = time + 0.05;
  }
};

/*
  AI SPAWN FUNCTION
*/
void() ai_tank_skirmish={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_tank_skirmish - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats( self.ai_rank );
  
  droptofloor();
  
  self.th_stand = ai_tank_sk_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_tank_sk_run;
  self.th_run_strafe = ai_generic_run_strafe;
  self.th_missile = ai_generic_missile;
  self.th_melee = ai_tank_sk_melee;
  self.th_missile_strafe = ai_tank_sk_missile_strafe;
  self.th_hunt = ai_tank_sk_hunt;
  self.th_pain = ai_tank_sk_pain;
  self.th_die = ai_tank_sk_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();
  self.colormod = '1 0 0'; //DEBUG
  self.e_tor_c.colormod = '1 0 0'; //DEBUG
  
  self.think = ai_tank_sk_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};