/*
mech Mod
Author: Peter Roohr
Date: 8/31/2016
mod: 11/27/2017 - data system refactor
Overview: builds player vehicle
*/

void(void() func, entity own) build_unit_component={
  func();
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, own.mskin, 0);
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

entity(void() func) build_unit_camera={
  local entity this, cam;
  cam = spawn();
  this = self;
  self = cam;
    self.classname = "camera";
    self.scale = 0.05;
    func();
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, 0, 0);
    self.alpha = 0;
    util_setBoundBox('-1 -1 -1', '1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles;
  self = this;
  return cam;
};

void() build_unit_weapon_list={
  local entity wslot;
  wslot = self;
  if(self.unit_wep1){
    if(self.next_wepn1){
      wslot.w_slot = build_unit_weapon(self.unit_wep1, self.next_wepn1, self, WEAPON1_OK, WEAPON1_DD, WEAPON1_REL, stat_w1_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w1_rel = 100;
      }
    }
  }
  if(self.unit_wep2){
    if(self.next_wepn2){
      wslot.w_slot = build_unit_weapon(self.unit_wep2, self.next_wepn2, self, WEAPON2_OK, WEAPON2_DD, WEAPON2_REL, stat_w2_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w2_rel = 100;
      }
    }
  }
  if(self.unit_wep3){
    if(self.next_wepn3){
      wslot.w_slot = build_unit_weapon(self.unit_wep3, self.next_wepn3, self, WEAPON3_OK, WEAPON3_DD, WEAPON3_REL, stat_w3_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w3_rel = 100;
      }
    }
  }
  if(self.unit_wep4){
    if(self.next_wepn4){
      wslot.w_slot = build_unit_weapon(self.unit_wep4, self.next_wepn4, self, WEAPON4_OK, WEAPON4_DD, WEAPON4_REL, stat_w4_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w4_rel = 100;
      }
    }
  }
  if(self.unit_wep5){
    if(self.next_wepn5){
      wslot.w_slot = build_unit_weapon(self.unit_wep5, self.next_wepn5, self, WEAPON5_OK, WEAPON5_DD, WEAPON5_REL, stat_w5_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w5_rel = 100;
      }
    }
  }
  if(self.unit_wep6){
    if(self.next_wepn6){
      wslot.w_slot = build_unit_weapon(self.unit_wep6, self.next_wepn6, self, WEAPON6_OK, WEAPON6_DD, WEAPON6_REL, stat_w6_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w6_rel = 100;
      }
    }
  }
  if(self.unit_wep7){
    if(self.next_wepn7){
      wslot.w_slot = build_unit_weapon(self.unit_wep7, self.next_wepn7, self, WEAPON7_OK, WEAPON7_DD, WEAPON7_REL, stat_w7_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w7_rel = 100;
      }
    }
  }
  if(self.unit_wep8){
    if(self.next_wepn8){
      wslot.w_slot = build_unit_weapon(self.unit_wep8, self.next_wepn8, self, WEAPON8_OK, WEAPON8_DD, WEAPON8_REL, stat_w8_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w8_rel = 100;
      }
    }
  }
  if(self.unit_wep9){
    if(self.next_wepn9){
      wslot.w_slot = build_unit_weapon(self.unit_wep9, self.next_wepn9, self, WEAPON9_OK, WEAPON9_DD, WEAPON9_REL, stat_w9_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w9_rel = 100;
      }
    }
  }
};

entity(void() func, float nex_wep, entity own, float state1, float state2, float state3, .float stat) build_unit_weapon={
  local entity wep, this;
  local vector ofs;
  this = self;
  wep = spawn();
  self = wep;
    func();
    self.data_idx = nex_wep;
    this.stat = self.data_idx;
    data_iniWep(nex_wep);
    
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    self.c_name = "weapon";

    if((own.flags & FL_MONSTER)){
      if(self.w_clipsize > 1){
        self.w_firerate = self.w_firerate * AI_WEAPON_RPS_MOD;
      }
    }
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, own.mskin, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    ofs = self.c_ofs + self.c_alt_ofs;
    util_setOffsetOrigin(self, own, ofs);
    
    self.punchangle = self.angles = '0 0 0';
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
  self = this;
  return wep;
};


void(void() data_ini) build_mech_unit={
  local entity part_chain;
  data_ini();
  build_mech_torsoCenter(self.unit_ctor);
  self.sh_hit = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.e_cam = build_unit_camera(self.unit_cam);
  part_chain = self;
  if(self.unit_rtor){
    self.e_tor_r = build_mech_torsoRight(self.unit_rtor);
    part_chain.c_part = self.e_tor_r;
    part_chain = part_chain.c_part;
  }
  if(self.unit_ltor){
    self.e_tor_l = build_mech_torsoLeft(self.unit_ltor);
    part_chain.c_part = self.e_tor_l;
    part_chain = part_chain.c_part;
  }
  if(self.unit_rarm){
    self.e_arm_r = build_mech_armRight(self.unit_rarm);
    part_chain.c_part = self.e_arm_r;
    part_chain = part_chain.c_part;
  }
  if(self.unit_larm){
    self.e_arm_l = build_mech_armLeft(self.unit_larm);
    part_chain.c_part = self.e_arm_l;
    part_chain = part_chain.c_part;
  }
  if(self.unit_legs){
    self.e_legs = build_mech_legs(self.unit_legs);
    part_chain.c_part = self.e_legs;
    part_chain = part_chain.c_part;
  }
  build_unit_weapon_list();
};

void(void() func) build_mech_torsoCenter={
  local entity this, ctor;
  func();
  if( (self.flags & FL_CLIENT) ){
    util_setCollider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_WALK);
  }
  else{
    util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  }
  //util_setModel(self.c_model, 0);
  util_setModel("q3mdl/testball.md3", 0, 0);
  util_setBoundBox(self.c_bbx_n, self.c_bbx_x);
  self.alpha = 1;
  this = self;
  ctor = spawn();
  self = ctor;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(this.c_model, this.mskin, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, '0 0 0');
    self.punchangle = self.angles = '0 0 0';
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles;
  self = this;
  self.e_tor_c = ctor;
  ctor_stand();
};

entity(void() func) build_mech_torsoLeft={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    build_unit_component(func, this);
  self = this;
  return comp;
};
entity(void() func) build_mech_torsoRight={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    build_unit_component(func, this);
  self = this;
  return comp;
};
entity(void() func) build_mech_armLeft={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    build_unit_component(func, this);
    self.c_part = this.e_tor_l;
  self = this;
  return comp;
};
entity(void() func) build_mech_armRight={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    build_unit_component(func, this);
    self.c_part = this.e_tor_r;
  self = this;
  return comp;
};

entity(void() func) build_mech_legs={
  local entity this, leg_ent;
  this = self;
  leg_ent = spawn();
  self = leg_ent;
    func();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 1;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, this.mskin, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles; 
    self.th_die = ctrl_dieLegs;
    self.laser_sight_org = '0 0 0';
    self.laser_sight_timer = time + 0.5; 
    self.w_firerate = 0; //used to track m_maccel changes
    if( (this.data_type == DATA_MECH) || (this.data_type == DATA_MECH_AI) ){
      leg_stand1();
    }
  self = this;
  return leg_ent;
};

void(void() data_ini) build_vehicle_unit={
  local entity part_chain;
  data_ini();
  build_mech_torsoCenter(self.unit_ctor);
  self.sh_hit = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.e_cam = build_unit_camera(self.unit_cam);
  part_chain = self;
  if(self.unit_rtor){
    self.e_tor_r = build_mech_torsoRight(self.unit_rtor);
    part_chain.c_part = self.e_tor_r;
    part_chain = part_chain.c_part;
  }
  if(self.unit_ltor){
    self.e_tor_l = build_mech_torsoLeft(self.unit_ltor);
    part_chain.c_part = self.e_tor_l;
    part_chain = part_chain.c_part;
  }
  if(self.unit_legs){
    if(self.vec_name == "Light Turret"){
      self.e_legs = build_building_base(self.unit_legs);
    }
    else{
      self.e_legs = build_vehc_base(self.unit_legs);
    }

    part_chain.c_part = self.e_legs;
    part_chain = part_chain.c_part;
  }
  build_unit_weapon_list();
};

entity(void() func) build_vehc_base={
  local entity this, base_ent;
  this = self;
  base_ent = spawn();
  self = base_ent;
    func();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, this.mskin, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles; 
    self.th_die = ctrl_dieLegs;
    self.laser_sight_org = '0 0 0';
    self.laser_sight_timer = time + 0.5; 
    self.w_firerate = 0; //used to track m_maccel changes
  self = this;
  return base_ent;
};

entity(void() func) build_building_base={
  local entity this, leg_ent;
  this = self;
  leg_ent = spawn();
  self = leg_ent;
    func();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 1;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    util_setModel(self.c_model, this.mskin, 0);
    util_setBoundBox('-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.owner = this;
    self.view_ofs = self.origin - this.origin;
    self.th_die = ctrl_dieLegs;
    self.laser_sight_org = '0 0 0';
    self.laser_sight_timer = time + 0.5; 
    self.w_firerate = 0; //used to track m_maccel changes
    //leg_stand1();
  self = this;
  return leg_ent;
};
