/*
battleMETAL
Author: Peter Roohr
Date: 03/04/2020
Overview: 
  Controllers manage some state-level behavior for the target object.
    these are separated from model-control (animation).
  
  this particular set is generic functions for almost all units
*/

/*
  cleans player weapon groups
*/
void() ctrl_unit_clean_wgroups={
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.currentWeaponGroup = 0;
};

/*
  Garbage collection on truly dead unit,
  one-way execution, use carefully.
*/
void() ctrl_unit_cleanup_player={
  local entity w_chain, next, lstp;
  
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.armLeft);
  ctrl_unit_remove_piece(self.armRight);
  if(self.legs != world && self.legs.owner == self){
    self.legs.think = leg_die1;
    self.legs.nextthink = time + 0.1;
    ctrl_unit_remove_piece(self.legs);
  }
  ctrl_weapon_remove_all();
  
  if( (self.flags & FL_CLIENT) ){
    ctrl_unit_remove_cam(self.cockpit);
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
};

void() ctrl_unit_cleanup_mech={
  ctrl_unit_remove_piece(self.cockpit);
  ctrl_weapon_remove_all();
  ctrl_unit_remove_piece(self.armLeft);
  ctrl_unit_remove_piece(self.armRight);
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.legs);
};

void() ctrl_unit_cleanup_tank={
  ctrl_unit_remove_piece(self.cockpit);
  ctrl_weapon_remove_all();
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.legs);
};
/*
  Call's unit sub-piece's th_die() function but does not remove!
*/
void( entity comp ) ctrl_unit_part_death={
  local entity parentSelf;
  if( comp.th_die && comp.deadflag >= DEAD_NO ){
    parentSelf = self;
    self = comp;
      if( self.model ){
        if( (self != world) && (self.owner == parentSelf) ){
          self.th_die();
        }
      }
    self = parentSelf;
  }
};

/*
  Removes component from Unit, it's one-way so be careful!
*/
void(entity unitPiece) ctrl_unit_remove_piece={
  local entity this;
  if( unitPiece.partTypeId ){
    if( (unitPiece != world) && (unitPiece.owner == self) ){
      this = self;
      self = unitPiece;
        remove(self);
      self = this;
    }
  }
};

/*
  Deals with removing a player camera from the server.
*/
void(entity unitCam) ctrl_unit_remove_cam={
  setorigin(self, self.cockpit.origin);
  
  if( self.cockpit != world ){
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self);
    WriteByte(MSG_ONE, SVC_SETANGLES);
    WriteAngle(MSG_ONE, self.angles_x);
    WriteAngle(MSG_ONE, self.angles_y);
    WriteAngle(MSG_ONE, self.angles_z);
  }
  self.weaponmodel = self.weaponmodel;
  self.weaponframe = 0;
  remove(self.cockpit);
};
