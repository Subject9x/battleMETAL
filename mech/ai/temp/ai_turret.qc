/*
battleMETAL 
Author: Peter Roohr
Date: 7/16/2018
Overview: ai unit
  Stock Turret Unit
  an on-ground, static vehicle
*/

void() ai_turret_stand;
void() ai_turret_turn;
void() ai_turret_attack;
void() ai_turret_die;
void() ai_turret_die_burn;
void() ai_turret_th;
void() temp_chunk_burn;

/*
  TH_TURN
*/
void() ai_turret_turn={
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
  TH_STAND
*/
void() ai_turret_stand={
  if( self.enemy ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if( ai_visible(self.enemy) ){
      //if( ai_target_infront(self.enemy, 0.97) ){
        //ai_action_next( self.th_attack, 1, self.ai_action_mod );
        //return;
      //}
      ai_action_next( ai_turret_turn, 1, self.ai_action_mod );
      return;
    }
    else{
      self.enemy = world;
    }
  }
  
  ChangeYaw();
  if( time > self.ai_action_time ){
    local float turn;
    self.ideal_yaw = anglemod(45 + crandom() * 180 - self.angles_y);
    turn = anglemod(self.ideal_yaw - self.angles_y);
    turn = (turn / self.yaw_speed);
    turn = turn / 5;
    self.ai_action_time = time + turn + self.ai_action_mod;
  }
  
  if( time > self.ai_viewtime ){
    if( ai_find_target_visual() ){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      //ai_action_next( self.th_attack, 0.1, self.ai_action_mod);
      return;
    }
    self.ai_viewtime = time + self.ai_viewcheck;
  }
};

/*
  TH_ATTACK
*/
void() ai_turret_attack={
  if( self.enemy ){  
    if( ai_visible( self.enemy ) ){
      //if( ai_target_infront(self.enemy, 0.97) ){
       //if(  self.currentWeaponGroup > 0  ){
          //self.button0 = 1;
         /// self.th_action = self.th_attack;
          //return;
        //}
      //}
      ai_action_next( ai_turret_turn, 1, self.ai_action_mod );
      return;
    }
    self.enemy = world;
  }
  ai_action_next( self.th_stand, 0.1, 0 );
};

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
	self.nextthink = 0.1;
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
  
  ai_action_next(ai_turret_die_burn, 360, 0 );
};

void() ai_turret_die_burn={  
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_speed) + (v_right * world.m_speed) + (v_up * world.m_speed);
  te_smoke_test(self.origin, sm + '0 0 10', 1);
  if ( time > self.ai_action_time ){
    self.flags = self.flags | FL_SKIPTHINK;
    self.think = BecomeExplosion;
    self.nextthink = time + 0.01;
    return;
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
    if( self.button0 ){
      self.button0 = 0;
    }
  }
  
  //if( self.th_action ){
    //self.th_action();
  //}
  
  self.SendFlags = self.SendFlags | (SEND_FLAG_DATA_IDX | SEND_FLAG_SHIELD_VAL | SEND_FLAG_RADAR_MODE | SEND_FLAG_FACTION);
  
  if( !(self.flags & FL_SKIPTHINK) ){
    self.think = ai_turret_th;
    self.nextthink = time + 0.05;
  }
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
  data_iniTurret(self.nextVecChoice);
  ai_pilot_ini_stats(ai_pilot_rank_byskill());
  
  self.th_stand = ai_turret_stand;
  self.th_missile = ai_turret_attack;
  self.th_die = ai_turret_die;
  
  ai_initialize_system( ST_STAND );
  
  self.flags = self.flags | FL_ONGROUND;
   
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = -1;
  
  self.think = ai_turret_th;
  self.nextthink = time + random()*0.1; //spread out thinks
};