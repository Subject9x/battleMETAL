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
  if( time > self.patience && !ai_valid_target(self.enemy)){  
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG1
    cons_logAString("Bot Here", "Having a look around"); //DEBUG
    if( ai_find_target_visual() ){
      cons_logAString("Bot Here", "found target!"); //DEBUG
      return;
    }
  }
  movetogoal(self.m_fspeed * AI_WALK_SPD);
};

/*
  TH_RUN
*/
void() ai_dest_run={
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  movetogoal(self.m_fspeed * AI_RUN_SPD);
  if( time > self.ai_action_time ){
    if( ai_valid_target(self.enemy) ){
      if( ai_target_infront(self.enemy, 0.9) ){
        ai_action_next( self.th_attack, 2, self.ai_action_mod );
        cons_logAString("Bot here", "->ai_dest_attack");  //DEBUG
        return;
      }
      else{
        ai_action_next( ai_dest_turn, 5, self.ai_action_mod );
        cons_logAString("Bot here", "->ai_dest_turn");  //DEBUG
        return;
      }
    }
    ai_action_next( self.th_stand, 0, self.ai_action_mod );
    return;
  }
};

/*
  TH_TURN
*/
void() ai_dest_turn={
  if( ai_valid_target(self.enemy) ){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    ChangeYaw();
  }
  if( time > self.ai_action_time ){
    if( ai_target_infront(self.enemy, 0.9) ){
      ai_action_next( ai_dest_attack, 2, self.ai_action_mod );
      cons_logAString("Bot here", "->ai_dest_attack");  //DEBUG
      return;
    } 
  }
};


/*
  TH_ATTACK
*/
void() ai_dest_attack={
  cons_logAString("Bot here", "attacking"); //DEBUG

  if( ai_valid_target(self.enemy) ){  
    if( ai_target_infront(self.enemy, 0.9) && ai_visible( self.enemy )){
      self.button0 = 1;
      ai_ranged_attack();
      self.button0 = 0;
      self.th_action = self.th_attack;
      return;
    }
    ai_action_next( ai_dest_turn, 2, self.ai_action_mod );
    cons_logAString("Bot here", "->ai_dest_turn");  //DEBUG
    return; 
  }
  ai_action_next( self.th_stand, 2, self.ai_action_mod );
};

/*
  TH_STAND
*/
void() ai_dest_stand={
  
  if( time > self.patience && !ai_valid_target(self.enemy)){  
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG1
    cons_logAString("Bot Here", "Having a look around"); //DEBUG
    if( ai_find_target_visual() ){
      cons_logAString("Bot Here", "found target!"); //DEBUG
      return;
    }
  }
  if( time > self.pausetime ){
    ai_walk_setup();
    ai_action_next( self.th_walk, 2, self.ai_action_mod );
    return;
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
  
  if( self.enemy ){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
  
  if( self.th_action ){
    self.th_action();
  }
  
  self.SendFlags = self.SendFlags | (SEND_FLAG_ORIGIN | SEND_FLAG_ANGLE | SEND_FLAG_DATA_IDX | SEND_FLAG_SHIELD_VAL | SEND_FLAG_RADAR_MODE | SEND_FLAG_FACTION);
  
  if( !(self.flags & FL_SKIP ) ){
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
    self.flags = self.flags | FL_SKIP;
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
    self.flags = self.flags | FL_SKIP;
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

  if( !self.pausetime ){
    self.pausetime = 999999;
  }
  
  self.th_stand = ai_dest_stand; //-> th_stand is used as the unit's main think function
  self.th_walk = ai_dest_walk; //-> th_walk is used the unit's 'Action' function, only 1 action execution per frame
  self.th_run = ai_dest_run;
  self.th_attack = ai_dest_attack;
  self.th_die = ai_vec_dest_die;
  
  droptofloor();
  self.flags = self.flags | FL_ONGROUND;
   
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = 31;

 ai_walk_setup();

  self.think = ai_dest_th;
  self.nextthink = time + random()*0.5; //spread out thinks
};