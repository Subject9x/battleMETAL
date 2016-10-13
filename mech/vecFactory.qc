/*
mech Mod
Author: Subject9x
Date: 8/31/2016
Overview: builds player vehicle
*/

void(entity data) buildVehicle={
  local entity oself, wep_slot, plr_slot;
  oself = self;
  self.vec_name = data.vec_name;
  self.m_rot_speed = data.m_rot_speed;
  configVehicleSpeeds(data);
  
  if(data.data_type == DATA_MECH){
    local entity legs, ctor, ltor, rtor, larm, rarm;
    local vector bb_n, bb_x;
    legs = data.e_legs;
    ctor = data.e_tor_c;
    
    ltor = data.e_tor_l;
    if(ltor != world && (ltor.c_name)){
      self.e_tor_l = buildSideTorso(ltor);
    }
    
    rtor = data.e_tor_r;
    if(rtor != world && (rtor.c_name)){
      self.e_tor_r = buildSideTorso(rtor);
    }
    
    larm = data.e_arm_l;
    if(larm != world && (larm.c_name)){
      self.e_arm_l = buildSideTorso(larm);
    }
    rarm = data.e_arm_r;
    if(rarm != world && (rarm.c_name)){
      self.e_tor_r = buildSideTorso(rarm);
    }
    
    buildCenterTorso(data, ctor);
    self.clientcamera = buildCameraEnt(data.e_cam);
    self.view_ofs = self.clientcamera.c_ofs;
    self.e_legs = buildLegs(legs);
    self = self.e_legs;
       leg_stand1();
    self = oself;
  }
  wep_slot = data.w_slot;
  plr_slot = self;
  while(wep_slot){
    plr_slot.w_slot = buildVehicleWeapon(wep_slot);
    plr_slot = plr_slot.w_slot;
    plr_slot.lst_p = plr_slot;
    wep_slot = wep_slot.w_slot;
  }
};

entity(entity leg_data) buildLegs={
  local entity oself, leg_ent;
  
  oself = self;
  leg_ent = spawn();
  self = leg_ent;
  self.deadflag = DEAD_NO;
  self.classname = self.c_name = leg_data.c_name;
  self.walkframe = 8;
  
  util_setHealthArmor(leg_data.health, leg_data.max_health, leg_data.armortype, leg_data.armorvalue);
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(leg_data.c_model, 0);
  util_setBoundBox('-1 -1 -1', '1 1 1');
  
  self.c_ofs = leg_data.c_ofs;
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

void(entity dat ,entity ct_dat)buildCenterTorso={
  //local entity ct, oself;
  //local vector ofs;
  
  //ct = spawn();
  //oself = self;
  //self = ct;

  self.en_cur = dat.en_cur;
  self.en_max = dat.en_max ;
  self.en_rate = dat.en_rate;
  self.sh_cur = dat.sh_cur;
  self.sh_max = dat.sh_max;
  self.sh_rate = dat.sh_rate;
  
  //self.classname = self.c_name = ct_dat.c_name;
  self.c_ofs = ct_dat.c_ofs;
  self.c_alt_ofs = ct_dat.c_alt_ofs;
  
  self.c_bbx_n = dat.c_bbx_n;//'-12 -12 -38';
  self.c_bbx_x = dat.c_bbx_x;//'12 12 8';
  
  self.c_model = ct_dat.c_model;
  
  ctor_stand();
  
  
 //util_setCollider(DAMAGE_AIM, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setHealthArmor(ct_dat.health, ct_dat.max_health, ct_dat.armortype, ct_dat.armorvalue);

  //ofs = self.c_alt_ofs + self.c_ofs;
  //util_setOffsetOrigin(self, oself, ofs);
  
  /*self.aiment = oself;
  self.owner = oself;
  self.punchangle = oself.angles;
  self.view_ofs = self.origin - oself.origin;
  self.angles = oself.angles;
  self.v_angle = self.angles - oself.angles;
  
  self.th_die = ctrl_dieMech;*/
  
  //self = oself;
  //return ct;
};

entity(entity dat) buildSideTorso={
  local entity oself, tor_ent;
  
  oself = self;
  tor_ent = spawn();
  self = tor_ent;
  self.deadflag = DEAD_NO;
  self.classname = self.c_name = dat.c_name;
  //self.walkframe = 8;
  
  util_setHealthArmor(dat.health, dat.max_health, dat.armortype,  dat.armorvalue);
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(dat.c_model, 0);
  util_setBoundBox(dat.c_bbx_n, dat.c_bbx_x);
  
  self.c_ofs = dat.c_ofs;
  util_setOffsetOrigin(self, oself, self.c_ofs);
  
  self.aiment = oself;
  self.owner = oself;
  self.punchangle = oself.angles;
  self.view_ofs = self.origin - oself.origin;
  self.angles = oself.angles;
  self.v_angle = self.angles - oself.angles;
   
  self.th_die = ctrl_die_weapon;
  
  self = oself;
  return tor_ent;
};

entity(entity cam_dat) buildCameraEnt={
  local entity oself, cam;
 // local vector ofs;
  
  cam = spawn();
  oself = self;
  self = cam;
  self.classname = self.c_name = cam_dat.classname;
  self.c_ofs = cam_dat.c_ofs;
  
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(cam_dat.c_model, 0);
  util_setBoundBox('-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, oself, self.c_ofs);
  
  self.aiment = oself;
  self.owner = oself;
  self.punchangle = oself.angles;
  self.view_ofs = self.origin - oself.origin;
  self.angles = oself.angles;
  self.v_angle = self.angles - oself.angles;

  self = oself;
  
  
  return cam;
};

entity(entity data) buildVehicleWeapon={
  local entity new_wep, oself, data_wep;
  local vector ofs;
  
  data_wep = mh_world_findData(data.data_idx, DATA_WEPN);
  
  new_wep = spawn();
  oself = self;
  self  = new_wep;
  self.deadflag = DEAD_NO;
  self.classname = self.c_name = "weapon";
  self.c_parent = data.c_parent;
  self.data_idx = data.data_idx;
  self.c_ofs = data.c_ofs;
  self.c_alt_ofs = data.c_alt_ofs;
  self.w_name = data_wep.w_name;
  self.w_group = data.w_group;
  self.w_proj = data_wep.w_proj;
  self.w_firetime = data_wep.w_firetime;
  self.w_clipsize = data_wep.w_clipsize;
  self.w_currentammo = data_wep.w_currentammo;
  self.w_firerate = data_wep.w_firerate;
  self.w_reloadtime = data_wep.w_reloadtime;
  self.w_isfire = data_wep.w_isfire;
  self.w_fire_ofs = data_wep.w_fire_ofs;
  self.en_max  = data_wep.en_max;
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(data_wep.c_model, 0);
  util_setBoundBox(data_wep.c_bbx_n, data_wep.c_bbx_x);
  util_setHealthArmor(data_wep.health, data_wep.max_health, data_wep.armortype, data_wep.armorvalue);
  
  ofs = self.c_ofs + self.c_alt_ofs;
  util_setOffsetOrigin(self, oself, ofs);
  
  self.punchangle = self.angles = data.angles;
  
  self.aiment = oself;
  self.owner = oself;
  self.punchangle = oself.angles;
  self.view_ofs = self.origin - oself.origin;
  self.angles = oself.angles;
  self.v_angle = self.angles - oself.angles;

  self.w_attack = data_wep.w_attack;
  self.th_die = ctrl_die_weapon;
  
  self = oself;
  return new_wep;
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