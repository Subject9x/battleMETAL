/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/



void() ai_dest_walk={

};

void() ai_dest_run={
  if( time > self.ai_action_time ){
    if( self.enemy ){
      if( ai_target_infront(self.enemy, self.ai_fov) ){
        self.ai_action_time = time + 2;
        self.ai_action = self.th_missile;
        cons_logAString("Bot here", "->ai_dest_attack");  //DEBUG
        return;
      }
      else{
        self.ai_action_time = time + 5;
        self.ai_action = ai_dest_turn;
        cons_logAString("Bot here", "->ai_dest_turn");  //DEBUG
        return;
      }
    }
  }
  local float yawl;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  ChangeYaw();
  movetogoal(4);
};

void() ai_dest_turn={
  if( time > self.ai_action_time ){
    if( ai_target_infront(self.enemy, self.ai_fov) ){
      self.ai_action_time = time + 2;
      self.ai_action = self.th_missile;
      cons_logAString("Bot here", "->ai_dest_attack");  //DEBUG
      return;
    } 
  }
  ChangeYaw();
};

void() ai_dest_attack={
  cons_logAString("Bot here", "attacking"); //DEBUG
  if( self.enemy ){
    if( ai_visible( self.enemy ) ){
      self.button0 = 1;
      ai_ranged_attack();
      self.button0 = 0;
    }
  }
  if( time > self.ai_action_time ){
    if( self.enemy ){
      if( ai_target_infront(self.enemy, self.ai_fov) ){
        self.ai_action_time = time + 2;
        self.ai_action = self.th_missile;
        return;
      }
      else{
        self.ai_action_time = time + 2;
        self.ai_action = ai_dest_turn;
        cons_logAString("Bot here", "->ai_dest_turn");  //DEBUG
        return;
      }
    }
    self.ai_action_time = time + 2;
    self.ai_action = self.th_stand;
    return;
  }
};

void() ai_dest_stand={
  if( time > self.patience && !self.enemy){  
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG1
    cons_logAString("Bot Here", "Having a look around"); //DEBUG
    if( ai_find_target_visual() ){
      cons_logAString("Bot Here", "found target!"); //DEBUG
      return;
    }
  }
  if( time > self.pausetime ){
    self.ai_action = self.th_walk;
  }
};

void() ai_dest_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
  
  cons_logAFloat("en_cur", self.en_cur);  //DEBUG
  if( self.enemy ){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
  
  if( self.ai_action ){
    self.ai_action();
  }
  self.SendFlags = 31;
  self.think = ai_dest_th;
  self.nextthink = time + 0.05;
};


void() ai_vec_dest={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE){
    remove(self);
  }
  ai_unit_ini_var();
    
  data_iniVehc(self.nextVecChoice);
  ai_pilot_ini_stats(self.ai_rank);

  self.pausetime = 999999;
  
  self.th_stand = ai_dest_stand; //-> th_stand is used as the unit's main think function
  self.th_walk = ai_dest_walk; //-> th_walk is used the unit's 'Action' function, only 1 action execution per frame
  self.th_run = ai_dest_run;
  self.th_missile = ai_dest_attack;
  self.ai_action = ai_dest_stand;
  
  droptofloor();
  self.flags = self.flags | FL_ONGROUND;
   
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = 31;
  
  self.think = ai_dest_th;
  self.nextthink = time + random(); //spread out thinks
};