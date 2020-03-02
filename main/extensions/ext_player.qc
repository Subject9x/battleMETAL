/*
battleMETAL
Author: Peter Roohr
Date: 9/7/2016
      mod 3/10/2017
      mod 5/22/2017 - addded some monster flag checks
Overview: implementation of mech player functions,

TODO - roll this into ctrl_mech.qc - Roohr 07/15/2019
*/

void() mech_clearWeaponGroups={
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.currentWeaponGroup = 0;
};

/*
  only called at the m_client level when player kills, respawns, or disconnects!
*/
void() mech_cleanupMech={
  
  local entity w_chain, next, lstp;
  
  mech_player_removecomp(self.torsoCenter);
  mech_player_removecomp(self.torsoLeft);
  mech_player_removecomp(self.torsoRight);
  mech_player_removecomp(self.armLeft);
  mech_player_removecomp(self.armRight);
  if(self.legs){
    if(self.legs != world && self.legs.owner == self){
      self.legs.think = leg_die1;
      self.legs.nextthink = time + 0.1;
      mech_player_removecomp(self.legs);
    }
  }

  w_chain = self.w_slot;
  while(w_chain){
    next = w_chain.w_slot;
    lstp = w_chain.lst_p;
    if(lstp){
      lstp.w_slot = next;
    }
    if( w_chain != world && (w_chain.partTypeId == M_ITEM) ){
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
  if( (self.flags & FL_MONSTER) ){
    mech_player_removecomp(self.cockpit);
    remove(self);
  }
};

void() mech_player_die={
  local entity w_chain;

  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.torsoCenter);
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.armLeft);
  mech_player_compdie(self.armRight);
  
  if( (self.flags & FL_CLIENT) ){
    mech_player_compdie(self.legs);
  }
};

void( entity comp ) mech_player_compdie={
  if( comp.model ){
    if( (comp != world) && (comp.owner == self) ){
      comp.think = SUB_Remove;
      if(comp.th_die){
        comp.think = comp.th_die;
      }
      comp.nextthink = time + 0.025;
    }
  }
};

void() mech_player_cameradie={
  msg_entity = self;
  WriteByte(MSG_ONE, SVC_SETVIEWPORT);
  WriteEntity(MSG_ONE, self);
  WriteByte(MSG_ONE, SVC_SETANGLES);
  WriteAngle(MSG_ONE, self.angles_x);
  WriteAngle(MSG_ONE, self.angles_y);
  WriteAngle(MSG_ONE, self.angles_z);
}

void() mech_player_removecamera={
  if( self.cockpit != world ){
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self);
    WriteByte(MSG_ONE, SVC_SETANGLES);
    WriteAngle(MSG_ONE, self.angles_x);
    WriteAngle(MSG_ONE, self.angles_y);
    WriteAngle(MSG_ONE, self.angles_z);
  }
  remove(self.cockpit);
};

void(entity comp) mech_player_removecomp={
  local entity this;
  if(comp.model){
    if( (comp != world) && (comp.owner == self) ){
      this = self;
      self = comp;
        remove(self);
      self = this;
    }
  }
};