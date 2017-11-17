/*
mech Mod
Author: Subject9x
Date: 8/31/2016
Overview: builds player vehicle
*/

void(entity data) buildVehicle={
  local entity oself;
  oself = self;
  data.unit_ini();
  if(data.data_type == DATA_MECH){
  
    self.sh_hit = 0;
    self.chain_timer = time;
    self.lock_timer = 0;
    if(data.unit_ctor){
      buildCenterTorso(data);
    }
    if((self.flags & FL_CLIENT)){
      if(self.w_group1 == 0){
        self.w_group1 = data.w_group1;
      }
      if(self.w_group2 == 0){
        self.w_group2 = data.w_group2;
      }
      if(self.w_group3 == 0){
        self.w_group3 = data.w_group3;
      }
      if(self.w_group4 == 0){
        self.w_group4 = data.w_group4;
      }
      if(self.w_group5 == 0){
        self.w_group5 = data.w_group5;
      }
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
    
    //now we chain all the components together for linked list power!
    //link flow ctor -> ltor -> la -> rtor -> la -> lg
    self.c_part = self.e_tor_l;
    self.e_tor_l.c_part = self.e_arm_l;
    self.e_arm_l.c_part = self.e_tor_r;
    self.e_tor_r.c_part = self.e_arm_r;
    self.e_arm_r.c_part = self.e_legs;
  }
  else if(data.data_type == DATA_VEHC){
    self.sh_hit = 0;
    self.chain_timer = time;
    self.lock_timer = 0;
    if(data.unit_ctor){
      buildCenterTorso(data);
    }
    if(data.unit_cam){
      self.e_cam = buildCameraEnt(data, self);
    }
    if(data.unit_legs){
       self.e_legs = buildLegs(data); 
    }
  }
  if(self != oself){
    self = oself;
  }

  buildWeaponList(data, self);
};

entity(entity data) buildLegs={
  local entity oself, leg_ent;
  oself = self;
  leg_ent = spawn();
  self = leg_ent;
    data.unit_legs();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 1;
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
    self.laser_sight_org = '0 0 0';
    self.laser_sight_timer = time + 0.5; 
    self.w_firerate = 0; //used to track m_maccel changes
  self = oself;
  return leg_ent;
};


void(entity data) buildCenterTorso={
  data.unit_ctor();
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_BOUNCE);
  util_setModel(self.c_model, 0);
  util_setBoundBox(self.c_bbx_n, self.c_bbx_x);
  self.radar_range = self.radar_range / 2; //mech starts in PASSIVE radar mode;
  ctor_stand();
};

entity(entity dat, entity own) buildLeftTorso={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_ltor();
    buildUnitPiece(own);
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildRightTorso={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_rtor();
    buildUnitPiece(own);
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildLeftArm={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_larm();
    buildUnitPiece(own);
    self.c_part = oself.e_tor_l;
  self = oself;
  return comp;
};
entity(entity dat, entity own) buildRightArm={
  local entity oself, comp;
  oself = self;
  comp = spawn();
  self = comp;
    dat.unit_rarm();
    buildUnitPiece(own);
    self.c_part = oself.e_tor_r;
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
    data.unit_cam();
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
  local entity point, oself, wep;
  point = own;
  if(mechData.unit_wep1){
    
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep1();
      if(oself.next_wepn1 > 0){
        self.data_idx = oself.next_wepn1;
      }
      buildVehicleWeapon(mechData, own, WEAPON1_OK, WEAPON1_DD, WEAPON1_REL);
    self = oself;
    self.stat_w1_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep2){
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep2();
      if(oself.next_wepn2 > 0){
        self.data_idx = oself.next_wepn2;
      }
      buildVehicleWeapon(mechData, own,  WEAPON2_OK, WEAPON2_DD, WEAPON2_REL);
    self = oself;
    self.stat_w2_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep3){

    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep3();
      if(oself.next_wepn3 > 0){
        self.data_idx = oself.next_wepn3;
      }
      buildVehicleWeapon(mechData, own,  WEAPON3_OK, WEAPON3_DD, WEAPON3_REL);
    self = oself;
    self.stat_w3_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep4){
   
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep4();
      if(oself.next_wepn4 > 0){
        self.data_idx = oself.next_wepn4;
      }
      buildVehicleWeapon(mechData, own,  WEAPON4_OK, WEAPON4_DD, WEAPON4_REL);
    self = oself;
    self.stat_w4_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep5){
    
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep5();
      if(oself.next_wepn5 > 0){
        self.data_idx = oself.next_wepn5;
      }
      buildVehicleWeapon(mechData, own,  WEAPON5_OK, WEAPON5_DD, WEAPON5_REL);
      if((own.flags & FL_MONSTER)){
        self.en_rate = self.en_rate / 10;
      }
    self = oself;
    self.stat_w5_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep6){
    
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep6();
      if(oself.next_wepn6 > 0){
        self.data_idx = oself.next_wepn6;
      }
      buildVehicleWeapon(mechData, own,  WEAPON6_OK, WEAPON6_DD, WEAPON6_REL);
    self = oself;
    self.stat_w6_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep7){
   
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep7();
      if(oself.next_wepn7 > 0){
        self.data_idx = oself.next_wepn7;
      }
      buildVehicleWeapon(mechData, own,  WEAPON7_OK, WEAPON7_DD, WEAPON7_REL);
    self = oself;
    self.stat_w7_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep8){
    
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep8();
      if(oself.next_wepn8 > 0){
        self.data_idx = oself.next_wepn8;
      }
      buildVehicleWeapon(mechData, own,  WEAPON8_OK, WEAPON8_DD, WEAPON8_REL);
    self = oself;
    self.stat_w8_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
  if(mechData.unit_wep9){
    
    wep = spawn();
    oself = self;
    self = wep;
      mechData.unit_wep9();
      if(oself.next_wepn9 > 0){
        self.data_idx = oself.next_wepn9;
      }
      buildVehicleWeapon(mechData, own,  WEAPON9_OK, WEAPON9_DD, WEAPON9_REL);
    self = oself;
    self.stat_w9_id = wep.data_idx;
    point.w_slot = wep;
    point = point.w_slot;
  }
};


void(entity mechData, entity own, float state1, float state2, float state3) buildVehicleWeapon={
  local entity wepData;
  local vector ofs;
 
  wepData = mh_world_findData(self.data_idx, DATA_WEPN);
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  self.c_name = "weapon";

  wepData.unit_ini();
  if((own.flags & FL_MONSTER)){
    if(self.w_clipsize > 1){
      self.w_firerate = self.w_firerate * 1000;
    }
  }
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
  
  if(self.c_parent == M_ARM_RIGHT){
    self.c_part = own.e_arm_r;
  }
  else if(self.c_parent == M_ARM_LEFT){
    self.c_part = own.e_arm_l;
  }
  
  self.th_die = ctrl_die_weapon;
  self.state_1 = state1;
  self.state_2 = state2;
  self.stat_wep_rel = state3;
  ctrl_weapon_addState(self, self.state_1);
};