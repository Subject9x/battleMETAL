/*
mech mod
Author: Peter Roohr
Date: 9/7/2016
      mod 3/10/2017
      mod 5/22/2017 - addded some monster flag checks
Overview: implementation of mech player functions,
*/


void() mech_clearWeaponGroups={
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.w_group5 = 0;
  self.currentWeaponGroup = 0;
};

void() ctrl_update_mechplayer={
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

/*
  only called at the m_client level when player kills, respawns, or disconnects!
*/
void() mech_cleanupMech={
  
  local entity w_chain, next, lstp;
  
  mech_player_removecomp(self.e_tor_c);
  mech_player_removecomp(self.e_tor_l);
  mech_player_removecomp(self.e_tor_r);
  mech_player_removecomp(self.e_arm_l);
  mech_player_removecomp(self.e_arm_r);
  if(self.e_legs){
    if(self.e_legs != world && self.e_legs.owner == self){
      local entity this;
      this = self;
      self = self.e_legs;
        self.think = leg_die1;
        self.nextthink = time + 0.1;
      self = this;
      mech_player_removecomp(self.e_legs);
    }
  }

  w_chain = self.w_slot;
  while(w_chain){
    next = w_chain.w_slot;
    lstp = w_chain.lst_p;
    if(lstp){
      lstp.w_slot = next;
    }
    if(w_chain != world && ((!(w_chain.flags & FL_CLIENT)) || (!(w_chain.flags & FL_MONSTER)))){
      remove(w_chain);
    }
    w_chain = next;
  }
  if( (self.flags & FL_CLIENT) ){
    mech_player_removecamera();
    self.stat_w1_id = -1;
    self.stat_w2_id = -1;
    self.stat_w3_id = -1;
    self.stat_w4_id = -1;
    self.stat_w5_id = -1;
    self.stat_w6_id = -1;
    self.stat_w7_id = -1;
    self.stat_w8_id = -1;
    self.stat_w9_id = -1;
  }
  if((self.flags & FL_MONSTER)){
    mech_player_removecomp(self.e_cam);
    remove(self);
  }
};


void() mech_player_die={
  local entity w_chain;
  
  if( (self.flags & FL_CLIENT) ){
    mech_player_cameradie();
  }

  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_tor_c);
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  mech_player_compdie(self.e_legs);
  self.stat_ctor_hp = -1;
  ctor_die1();
};


void(entity comp) mech_player_compdie={
  if(comp.model){
    if(comp != world && comp.owner == self){
      local entity old;
      old = self;
      self = comp;
        if(self.th_die){
          self.th_die();
        }
        else{
          self.think = SUB_Remove;
          self.nextthink = time + 0.1;
        }
      self = old;
    }
  }
};

void() mech_player_cameradie={
  self.view_ofs = '0 0 1';
  msg_entity = self;
  WriteByte(MSG_ONE, SVC_SETVIEWPORT);
  WriteEntity(MSG_ONE, self);
}

void() mech_player_removecamera={
  if(self.e_cam.classname){
    self.view_ofs = '0 0 1';
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self);
    remove(self.e_cam);
  }
};

void(entity comp) mech_player_removecomp={
  local entity old;
  if(comp.model){
    if(comp != world && comp.owner == self){
      old = self;
      self = comp;
        remove(self);
      self = old;
    }
  }
};