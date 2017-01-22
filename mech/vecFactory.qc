/*
mech Mod
Author: Subject9x
Date: 8/31/2016
Overview: builds player vehicle
*/

void(entity data) buildVehicle={
  local entity oself, wep_slot, plr_slot;
  oself = self;
  data.unit_ini();
  
  if(data.data_type == DATA_MECH){
  
    self.sh_hit = 0;
    
    if(data.unit_ctor){
      buildCenterTorso(data);
    }
    if(data.unit_ltor){
      self.e_tor_l = buildLeftTorso(data, self);
    }
    if(data.unit_rtor){
      self.e_tor_r = buildRightTorso(data, self);
    }
    if(data.unit_larm){
      self.e_arm_l = buildLeftArm(data, self);
    }
    if(data.unit_rarm){
      self.e_arm_r = buildRightArm(data, self);
    }
    if(data.unit_cam){
      self.e_cam = buildCameraEnt(data, self);
    }
    if(data.unit_legs){
       self.e_legs = buildLegs(data); 
    }
    self = self.e_legs;
       leg_stand1();
    self = oself;   
    //local entity legs, ctor, ltor, rtor, larm, rarm;
    //local vector bb_n, bb_x;
    //legs = data.e_legs;
    //ctor = data.e_tor_c;    
    /*
    //ltor = data.e_tor_l;
    if(ltor != world && (ltor.c_name)){
      self.e_tor_l = buildSideTorso(ltor);
    }rtor = data.e_tor_r;
    if(rtor != world && (rtor.c_name)){
      self.e_tor_r = buildSideTorso(rtor);
    }
    
    larm = data.e_arm_l;
    if(larm != world && (larm.c_name)){
      self.e_arm_l = buildSideTorso(larm);
    }
    rarm = data.e_arm_r;
    if(rarm != world && (rarm.c_name)){
      self.e_arm_r = buildSideTorso(rarm);
    }*/
    
    //buildCenterTorso(data, ctor);
    //self.e_cam = buildCameraEnt(data.e_cam);   
    //self.e_legs = buildLegs(legs);    
  }
  buildWeaponList(data, self);
  
  
  /*wep_slot = data.w_slot;
  plr_slot = self;
  while(wep_slot){
    plr_slot.w_slot = buildVehicleWeapon(wep_slot);
    plr_slot = plr_slot.w_slot;
    plr_slot.lst_p = plr_slot;
    wep_slot = wep_slot.w_slot;
  }*/
};

entity(entity data) buildLegs={
  local entity oself, leg_ent;
  oself = self;
  leg_ent = spawn();
  self = leg_ent;
    data.unit_legs();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 8;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, oself, self.c_ofs);
    self.aiment = oself;
    self.owner = oself;
    self.punchangle = oself.angles;
    self.view_ofs = self.origin - oself.origin;
    self.angles = oself.angles;
    self.v_angle = self.angles - oself.angles; 
    self.th_die = ctrl_dieLegs;   
  self = oself;
  return leg_ent;
};

void(entity data) buildCenterTorso={
  data.unit_ctor();
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_WALK);
  util_setModel(self.c_model, 0);
  util_setBoundBox(self.c_bbx_n, self.c_bbx_x);
  ctor_stand();
};

entity(entity dat, entity own) buildLeftTorso={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_ltor(comp);
    buildUnitPiece(own);
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildRightTorso={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_rtor(comp);
    buildUnitPiece(own);
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildLeftArm={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_larm(comp);
    buildUnitPiece(own);
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildRightArm={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_rarm(comp);
    buildUnitPiece(own);
  self = oself;
  return comp;
};

void(entity own) buildUnitPiece={
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, 0);
  util_setBoundBox('-1 -1 -1','1 1 1');
  util_setOffsetOrigin(self, own, self.c_ofs);
  self.aiment = own;
  self.owner = own;
  self.punchangle = own.angles;
  self.view_ofs = self.origin - own.origin;
  self.angles = own.angles;
  self.v_angle = self.angles - own.angles;
  self.th_die = ctrl_die_comp;
};

entity(entity data, entity own) buildCameraEnt={
  local entity oself, cam;
  cam = spawn();
  oself = self;
  self = cam;
    self.classname = "camera";
    self.scale = 0.05;
    data.unit_cam(cam);
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, 0);
    self.alpha = 0;
    util_setBoundBox('-1 -1 -1', '1 1 1');
    util_setOffsetOrigin(self, own, self.c_ofs);
    
    self.aiment = own;
    self.owner = own;
    self.punchangle = own.angles;
    self.view_ofs = self.origin - own.origin;
    self.angles = own.angles;
    self.v_angle = self.angles - own.angles;
  self = oself;
  return cam;
};

//im outta tricks, brute force away
void(entity mechData, entity own)buildWeaponList={
  local entity point, oself;
  point = own;
  if(mechData.unit_wep1){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep1();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep2){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep2();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep3){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep3();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep4){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep4();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep5){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep5();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep6){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep6();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep7){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep7();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep8){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep8();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep9){
    local entity wep;
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep9();
      buildVehicleWeapon(mechData, own);
    self = oself;
    point.w_slot = wep;
    point = point.w_slot;
  }
};


void(entity mechData, entity own) buildVehicleWeapon={
  local entity wepData;
  local vector ofs;
 
  wepData = mh_world_findData(self.data_idx, DATA_WEPN);
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  self.c_name = "weapon";

  wepData.unit_ini();

  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, 0);
  util_setBoundBox('-1 -1 -1','1 1 1');
  ofs = self.c_ofs + self.c_alt_ofs;
  util_setOffsetOrigin(self, own, ofs);
  
  self.punchangle = self.angles = mechData.angles;
  self.aiment = own;
  self.owner = own;
  self.punchangle = own.angles;
  self.view_ofs = self.origin - own.origin;
  self.angles = own.angles;
  self.v_angle = self.angles - own.angles;
  self.th_die = ctrl_die_weapon;
};

void(entity data) configVehicleSpeeds={
  
  //Movement variables
  self.m_fspeed = data.m_fspeed;
  self.m_sspeed = data.m_sspeed;
  self.m_bspeed = data.m_bspeed;
  self.m_maccel = data.m_maccel;
  self.m_rollangle = data.m_rollangle;
  self.m_pitch_max = data.m_pitch_max;
  self.m_pitch_min = data.m_pitch_min;
  
  //Cosmetic variables
  self.m_bob = data.m_bob;
  self.m_bcycle =  data.m_bcycle;
  self.m_bup = data.m_bup;
  
  self.m_bmodel = data.m_bmodel;
  self.m_bside = data.m_bside;
  self.m_bobspd = data.m_bobspd;
  self.m_rollangle = data.m_rollangle;
};