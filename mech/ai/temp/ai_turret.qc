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
  if( ai_valid_target( self.enemy ) ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if( ai_target_infront(self.enemy, 0.97) ){
      ai_action_next( ai_turret_attack, 1, self.ai_action_mod );
      return;
    }
  }
  else{
    if( time > self.patience ){
      self.patience  = time + 1; //DEBUG1
      if( ai_find_target_visual() ){
        ai_action_next( self.th_attack, 1 , self.ai_action_mod);
        return;
      }
    }
    if( self.angles_y == self.ideal_yaw){
      ai_action_next( ai_turret_stand, (10 + crandom() * 10), self.ai_action_mod );
      return;
    }
  }
};

/*
  TH_STAND
*/
void() ai_turret_stand={
  if( !ai_valid_target(self.enemy) ){
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG1
    if( ai_find_target_visual() ){
      ai_action_next( self.th_attack, 1 , self.ai_action_mod);
      return;
    }
  }
  if( time > self.ai_action_time ){
    self.ideal_yaw = anglemod( 25 + crandom() * 45 );
    ai_action_next(ai_turret_turn, 1, self.ai_action_mod);
    return;
  }
};

/*
  TH_ATTACK
*/
void() ai_turret_attack={
  if( ai_valid_target(self.enemy) ){  
    if( ai_target_infront(self.enemy, 0.97) && ai_visible( self.enemy )){
      self.button0 = 1;
        ai_ranged_attack();
      self.button0 = 0;
      self.th_action = self.th_attack;
      
      return;
    }
    ai_action_next( ai_turret_turn, 1, self.ai_action_mod );
    return; 
  }
  ai_action_next( self.th_stand, 4, self.ai_action_mod );
};

void() temp_chunk_burn={
  if( time > self.delay){
    self.think = SUB_Remove;
  }
  else{
    te_smoke_test(self.origin, '0 0 25', 3);
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
  te_smoke_test(self.origin, '0 0 10', 1);
  if ( time > self.ai_action_time ){
    self.flags = self.flags | FL_SKIP;
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
  
  if( ai_valid_target(self.enemy) ){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
  
  if( self.th_action ){
    self.th_action();
  }
  
  self.SendFlags = self.SendFlags | (SEND_FLAG_DATA_IDX | SEND_FLAG_SHIELD_VAL | SEND_FLAG_RADAR_MODE | SEND_FLAG_FACTION);
  
  if( !(self.flags & FL_SKIP ) ){
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
  
  ai_pilot_ini_stats(self.ai_rank);

  self.pausetime = 999999;
  
  self.th_stand = ai_turret_stand; //-> th_stand is used as the unit's main think function
  //self.th_walk = ai_dest_walk; //-> th_walk is used the unit's 'Action' function, only 1 action execution per frame
  //self.th_run = ai_dest_run;
  self.th_attack = ai_turret_attack;
  self.th_die = ai_turret_die;
  
  self.flags = self.flags | FL_ONGROUND;
   
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = -1;
  
  ai_action_next( self.th_stand, 1, self.ai_action_mod);
  
  self.think = ai_turret_th;
  self.nextthink = time + random()*0.1; //spread out thinks
};