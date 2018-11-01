/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
Overview: ai unit
  Mech - Sniper
  an on-ground, turreted, walking unit
  sniperrs try to work the mid and long range
  close-up they're kinda useless, only should attack at longer ranges
*/

/*
float ST_STAND              = 1;  //th_stand
float ST_WALK               = 2;  //th_walk
float ST_RUN                = 4;  //th_run
float ST_RUN_STRAFE         = 5;  //th_run_strafe
float ST_RUN_CHARGE         = 6;  //th_run_charge
float ST_MISSILE            = 7;  //th_missile
float ST_MELEE              = 8;  //th_melee
float ST_MISSILE_STRAFE     = 9;  //th_missile_strafe
float ST_HUNT               = 10; //th_hunt
float ST_RADAR              = 11; //TODO, th_radar, - turn to face target even if LoS is lost
float ST_HUNT_START         = 12; //TODO
float ST_PAIN               = 13; //TODO - a fun holdover from Quake, this 'staggers' the target
*/

//set state time duration
float() ai_mech_sniper_setDuration={
  local float duration, vel;
  duration = 3.1 - skill;
  duration = duration + (4 - skill);
  duration = duration + (self.vec_size - 1);
  duration = duration / 10;
  vel = self.m_fspeed * AI_WALK_SPD;
  vel = vel * 20 / 500;
  duration = duration + vel;
  duration = duration * random();
  return duration;
};


void() ai_mech_sniper_stand;
void() ai_mech_sniper_walk;
void() ai_mech_sniper_run;
void() ai_mech_sniper_run_strafe;
void() ai_mech_sniper_run_charge;
void() ai_mech_sniper_melee;
void() ai_mech_sniper_missile;
void() ai_mech_sniper_missile_strafe;
void() ai_mech_sniper_hunt;
void() ai_mech_sniper_pain;

void() ai_mech_sniper_die;
void() ai_mech_sniper_die1;
void() ai_mech_sniper_die2;

//custom funcs
void() ai_mech_sniper_turn;
void() ai_mech_sniper_turn_back;


void() ai_mech_sniper_stand={
  //TODO - ?
};

void() ai_mech_sniper_walk={
  if( ai_valid_target(self.enemy) ){
  
  }
  if( time > self.ai_action_time ){
  
  
  }
};

void() ai_mech_sniper_run={
  local float angl;
  
  if( ai_valid_target(self.enemy) ){
    ai_turret_set_state( TR_TARG );
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if(enemy_vis){
      if( enemy_range <= 400 ){
        if( enemy_infront ){
          ai_next_state( ST_MELEE );
          angl = 100 + ( random() * 100);
          self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
          self.ai_dir = anglemod( self.ideal_yaw - angl );
          return;
        }
        
      }
      
      if( enemy_range <= self.ai_minrange / 2 ){
        if( enemy_infront ){
          ai_next_state( ST_MELEE );
          angl = 100 + ( random() * 100);
          self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
          self.ai_dir = anglemod( self.ideal_yaw - angl );
          return;
        }
        ai_next_state( ST_RUN_STRAFE );
        self.lefty = 0 - self.lefty;
        self.ai_dir = anglemod( self.ideal_yaw - (80 * self.lefty) );
        self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          ai_next_state( ST_MISSILE );
          self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
          return;
        }
        ai_next_state( ST_RUN_STRAFE );
        self.lefty = 0 - self.lefty;
        self.ai_dir = anglemod( self.ideal_yaw - (80 * self.lefty) );
        self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
        return;
      }
      ai_next_state( ST_RUN_CHARGE );
      self.ai_dir = anglemod( self.ideal_yaw  );
      self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
      return;
    }
    else{
      ai_next_state( ST_STAND);
      self.enemy = world;
      return;
    }
  }
  else{
    ai_next_state( ST_STAND);
    return;
  }
};

void() ai_mech_sniper_run_strafe={
  
  if( !ai_move( self.ai_dir, self.m_sspeed * AI_RUN_SPD ) ){
    self.lefty = 0 - self.lefty;
    self.ai_dir = anglemod( self.ideal_yaw - (self.ai_dir * self.lefty) );
  }
  
  if( time > self.ai_action_time ){
    if( (skill > 1) || (self.ai_rank < 2) ){
      ai_next_state( ST_MISSILE_STRAFE );
      self.lefty = 0 - self.lefty;
      self.ai_dir = self.ai_dir * self.lefty;
      self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_mech_sniper_run_charge={
  local float angl;
  
  if( !ai_move( self.ai_dir, self.m_sspeed * AI_RUN_SPD ) ){
    angl = 45 + ( random() * 90);
    self.lefty = 0 - self.lefty;
    self.ai_dir = anglemod( self.ideal_yaw - (self.ai_dir * self.lefty) );
  }
  
  if( time > self.ai_action_time ){
    if( (skill > 1) || (self.ai_rank < 2) ){
      ai_next_state( ST_MISSILE );
      self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_mech_sniper_melee={
  if( ai_valid_target(self.enemy) ){
    ai_move_turn();
    
    if( ai_check_face( self.enemy, 0.96 ) ){
      ai_attack();
    }
    
    if( !ai_move( self.ai_dir, self.m_bspeed * AI_WALK_SPD ) ){
      ai_next_state( ST_RUN_STRAFE );
      self.lefty = 0 - self.lefty;
      self.ai_dir = anglemod( self.ideal_yaw - (80 * self.lefty) );
      self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_mech_sniper_missile={
  local float angl;
  
  if( ai_valid_target(self.enemy) ){
    enemy_range = ai_check_range( self.enemy );
    if( enemy_range <= 600 ){
      ai_next_state( ST_MELEE );
      angl = 100 + ( random() * 100);
      self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
      self.ai_dir = anglemod( self.ideal_yaw - angl );
      return;
    }
    //TODO - AI convergence code
    if( ai_check_face( self.enemy, 0.96 ) ){
      if( ai_wait_for_shot( self.spreadDefault_x + 0.2 ) ){      
        if( ai_attack() ){
          ai_next_state( ST_RUN );
          return;
        }
      }
    }
  }
  else{
    ai_next_state( ST_STAND );
    return;
  }
};

void() ai_mech_sniper_missile_strafe={
  if( ai_valid_target(self.enemy) ){
    ai_move( self.ai_dir, self.m_fspeed * AI_WALK_SPD );
    if( ai_check_face( self.enemy, 0.96 ) ){
      if( !ai_attack() ){
        ai_next_state( ST_MISSILE );
        self.ai_action_time = self.ai_action_time + ai_mech_sniper_setDuration();
        return;
      }
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

void() ai_mech_sniper_hunt={};

void() ai_mech_sniper_pain={
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

//TODO - die

/*
  SNIPER MECH THINK FUNCTION
*/
void() ai_mech_sniper_th={  
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
    
    ai_state_control( self.attack_state );
    self.v_angle = self.angles;
    if( (self.flags & FL_TURRET) ){
      ai_turret_control();
    }
    self.e_legs.angles_y = self.angles_y;
  }
  
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_mech_sniper_th;
    self.nextthink = time + 0.05;
  }
}

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={

  if( !ai_create_unit( data_iniMech )){
    return;
  }
  
  self.th_stand = ai_generic_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_mech_sniper_run;
  self.th_run_strafe = ai_mech_sniper_run_strafe;
  self.th_run_charge = ai_mech_sniper_run_charge;
  self.th_missile = ai_mech_sniper_missile;
  self.th_melee = ai_mech_sniper_melee;
  self.th_missile_strafe = ai_mech_sniper_missile_strafe;
  self.th_hunt = ai_mech_sniper_hunt;
  self.th_pain = ai_mech_sniper_pain;
  self.th_die = ai_mech_sniper_die;
  
  ai_initialize_system( ST_STAND );
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  droptofloor();
  
  ai_walk_setup();
  
  self.think = ai_mech_sniper_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};