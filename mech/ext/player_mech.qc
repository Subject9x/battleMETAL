/*
mech mod
Author: Subject9x
Date: 9/7/2016
Overview: implementation of mech player functions,
*/

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


void() stat_update_weapons={
  local float cnt;
  local entity ent;
  ent = self.w_slot;
  cnt = 0;
  while(ent){
    
    ent = ent.w_slot;
  }

};


/*
  only called at the m_client level when player kills, respawns, or disconnects!
*/
void() cleanup_mech={
  
  local entity oself, w_chain, next, lstp;
  oself = self;
  if(self.flags & FL_CLIENT){
    mech_player_removecamera();
  }
  mech_player_removecomp(oself.e_tor_l);
  mech_player_removecomp(oself.e_tor_r);
  mech_player_removecomp(oself.e_arm_l);
  mech_player_removecomp(oself.e_arm_r);

  self = oself.e_legs;
    local entity n;
    n = spawn();
    copyentity(self, n);
    mech_player_removecomp(self);
    self = n;
      leg_die1();
  self = oself;

  w_chain = self.w_slot;
  while(w_chain){
    next = w_chain.w_slot;
    lstp = w_chain.lst_p;
    if(lstp){
      lstp.w_slot = next;
    }
    if(w_chain != world && w_chain.classname!="player"){
      remove(w_chain);
    }
    w_chain = next;
  }
  self = oself;

};


void() mech_player_die={
  local entity w_chain, next;
  
  if(self.flags & FL_CLIENT){
    mech_player_cameradie();
  }

  
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
};

void() mech_player_weapondie={

};

void(entity comp) mech_player_compdie={
  if(comp.model){
    if(comp != world && comp.owner == self){
      local entity old;
      old = self;
      self = comp;
        self.th_die();
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
  local entity old;
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