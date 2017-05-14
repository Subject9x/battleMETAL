/*
mech Mod
Date: 5/3/2017
Overview: ai extension funcs
*/

void() ai_control={
  local float astate, move, qrk;
  astate = self.ai_state;
  move = self.ai_move;
  qrk = self.ai_quirks;

  if(self.enemy != world){
    q_ai_face();
  }

  if(self.p_class == P_MECH){
    ai_mech_update();
  }

  ai_weapon_update();
  
  if(astate == AI_STATE_WANDER){
    
  }
  else if(astate == AI_STATE_TOPOINT){
  
  }
  else if(astate == AI_STATE_HUNT){
    q_HuntTarget();
    self.th_missile();
  }
 
  if(move == AI_STATE_STAND){
    self.th_stand();
  }
  else if(move == AI_STATE_WALK){
    self.th_walk();
  }
  else if(move == AI_STATE_RUN){
    self.th_run();
  }
  
  self.think = ai_control;
  self.nextthink = time + 0.005;
};


void() ai_mech_walk={
  local float spd;
  spd = self.m_fspeed;
  spd = spd / 250;
  q_ai_walk(spd);
};

void() ai_mech_run={
  local float spd;
  spd = self.m_fspeed;
  spd = spd / 250;
  spd = spd + (spd/3);
  q_ai_run(spd);
};

void() ai_mech_attack={
  local entity wep_chain, oself;
  local float dist;
  
  if(!q_infront(self.enemy)){
    return;
  }
  wep_chain = self.w_slot;
  dist = vlen(self.enemy.origin - self.origin);
  traceline(self.origin, self.enemy.origin, FALSE, self);
  if(trace_ent != self.enemy){
    //only fire on a clear shot.
    return;
  }
  while(wep_chain){
    //if((self.currentWeaponGroup & wep_chain.w_group)){
      if(wep_chain.w_isready){
        if( dist <= wep_chain.w_range){
          oself = self;
          self = wep_chain;
            self.w_attack();
          self = oself;
        }
      }
   // }
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

void(float move_state) ai_setmovestate={
  self.ai_move = move_state;
};

void(float dir_state) ai_setdirstate={
  self.ai_state = dir_state;
};