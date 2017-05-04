/*
mech Mod
Date: 5/3/2017
Overview: ai extension funcs
*/

void() ai_control={

  if(self.p_class == P_MECH){
    ai_mech_update();
  }

  ai_weapon_update();

  
  if(self.ai_state == AI_STAND){
    self.th_stand();
  }
  else if(self.ai_state == AI_RUN){
    self.th_run();
  }
  else if(self.ai_state == AI_WALK){
    self.th_walk();
  }
  else if(self.ai_state == AI_FORWARD){
    
  }
  else if(self.ai_state == AI_BACKWARD){
  
  }
  else if(self.ai_state == AI_HUNTTARGET){
    
    q_HuntTarget();
  }
  
  self.think = ai_control;
  self.nextthink = time + 0.05;
};


void() ai_mech_walk={
  q_ai_walk(1);
};

void() ai_mech_run={
  q_ai_run(2);
};

void() ai_mech_attack={
  
  q_ai_face();

  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    if(wep_chain.w_isready){
      wep_chain.w_attack();
    }
    wep_chain = wep_chain.w_slot;
  }
};

void() ai_mech_stand={
  q_ai_stand();
};


void() ai_weapon_update={
  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
};

void() ai_mech_update={
  local entity oself;
  oself = self;
  ctrl_updateCenterTorso();
  if(oself.e_legs){
    if(oself.e_legs != world && oself.e_legs.owner == oself){
      self = oself.e_legs;
        ctrl_updateLegs();
      self = oself;
    }
  }
};

void() ai_mech_die={
  local entity w_chain, next;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  mech_player_compdie(self.e_legs);
  
  ctor_die1();
  self.think = SUB_Remove;
  self.nextthink = time + 100;
};