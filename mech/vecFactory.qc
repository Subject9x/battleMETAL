/*
mech Mod
Author: Peter Roohr
Date: 8/31/2016
mod: 11/27/2017 - data system refactor
Overview: builds player vehicle
*/

void(void() func, entity own) build_unit_component={
  local entity follow;
  func();
  follow = util_getPartFromName( self.c_parent, own );
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, own.mskin, 0);
  setsize(self, '-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, own, self.c_ofs);
  self.owner = own;
  self.aiment = follow;
  self.punchangle = follow.angles;
  self.view_ofs = self.origin - follow.origin;
  self.angles = follow.angles;
  self.v_angle = self.angles - follow.angles;
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
    setsize(self, '-1 -1 -1', '1 1 1');
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
    }
  }
  if(self.unit_wep2){
    if(self.next_wepn2){
      wslot.w_slot = build_unit_weapon(self.unit_wep2, self.next_wepn2, self, WEAPON2_OK, WEAPON2_DD, WEAPON2_REL, stat_w2_id);
      wslot = wslot.w_slot;
    }
  }
  if(self.unit_wep3){
    if(self.next_wepn3){
      wslot.w_slot = build_unit_weapon(self.unit_wep3, self.next_wepn3, self, WEAPON3_OK, WEAPON3_DD, WEAPON3_REL, stat_w3_id);
      wslot = wslot.w_slot;
    }
  }
  if(self.unit_wep4){
    if(self.next_wepn4){
      wslot.w_slot = build_unit_weapon(self.unit_wep4, self.next_wepn4, self, WEAPON4_OK, WEAPON4_DD, WEAPON4_REL, stat_w4_id);
      wslot = wslot.w_slot;
    }
  }
  if(self.unit_wep5){
    if(self.next_wepn5){
      wslot.w_slot = build_unit_weapon(self.unit_wep5, self.next_wepn5, self, WEAPON5_OK, WEAPON5_DD, WEAPON5_REL, stat_w5_id);
      wslot = wslot.w_slot;
    }
  }
  if(self.unit_wep6){
    if(self.next_wepn6){
      wslot.w_slot = build_unit_weapon(self.unit_wep6, self.next_wepn6, self, WEAPON6_OK, WEAPON6_DD, WEAPON6_REL, stat_w6_id);
      wslot = wslot.w_slot;
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
    }
  }
  if(self.unit_wep9){
    if(self.next_wepn9){
      wslot.w_slot = build_unit_weapon(self.unit_wep9, self.next_wepn9, self, WEAPON9_OK, WEAPON9_DD, WEAPON9_REL, stat_w9_id);
      wslot = wslot.w_slot;
    }
  }
};

entity(void() func, float nex_wep, entity own, float state1, float state2, float state3, .float stat) build_unit_weapon={
  local entity wep, this, prt;
  local vector ofs;
  this = self;
  wep = spawn();
  self = wep;
    func();
    self.data_idx = nex_wep;
    this.stat = self.data_idx;
    data_iniWep(nex_wep);
    
    self.rl_cur = 100; // bug fix - weapon reload indicator not starting at correct value
    
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    self.comp_id = -2;

    if( (own.flags & FL_MONSTER) ){
      self.p_damage = ai_pilot_mod_damage( self.ai_rank, cvar("skill"), self.p_damage);
      if(self.w_clipsize > 1){
        self.w_firerate = self.w_firerate * AI_WEAPON_RPS_MOD;
      }
    }
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    ofs = self.c_ofs + self.c_alt_ofs;
    util_setOffsetOrigin(self, own, ofs);
    
    prt = util_getPartFromName( self.c_parent, own );
    
    self.punchangle = self.angles = '0 0 0';
    self.aiment = prt;
    self.owner = own;
    self.punchangle = prt.angles;
    self.view_ofs = self.origin - prt.origin;
    self.angles = prt.angles;
    self.v_angle = self.angles - prt.angles;
    
    self.c_part = util_getPartFromName( self.c_parent, own );
    
    if( (self.p_dmgtype & DMG_MSC) ){
      self.w_think(); //run module's upgrade now;
      self.w_think = SUB_Null;
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

  if( !(self.flags &  FL_CLIENT) ){
    build_mech_bot( data_ini );
    return;
  }
  local entity part_chain;
  data_ini();
  build_mech_torsoCenter(self.unit_ctor);
  self.sh_hit = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  if( self.unit_cam ){
    self.e_cam = build_unit_camera(self.unit_cam);
  }
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
  local vector hmins, hmaxs;
  func();
  if( (self.flags & FL_CLIENT) ){
    util_setCollider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_WALK);
  }
  else{
    util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  }
  
  hmins = self.mins;
  hmaxs = self.maxs;
  util_setModel("q3mdl/testball.md3", 0, 0);
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  ctor = spawn();
  this = self;
  self = ctor;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(this.c_model, this.mskin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, '0 0 0');
    self.punchangle = self.angles = '0 0 0';
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles;
    this.e_tor_c = self;
  self = this;
  ctor_stand();
};


void(void() data_ini) build_mech_bot={
  local entity part_chain;
  local vector hmins, hmaxs;
  local string mdl;
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  util_setModel("q3mdl/testball.md3", self.mskin, 0);
  setsize( self, hmins, hmaxs );
  
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  
  self.alpha = 1;
  self.sh_hit = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  
  if( (self.unit_cam) ){
    self.e_cam = build_unit_camera(self.unit_cam);
  }
  part_chain = self;
  
  self.e_tor_c = build_unit_turret( self.unit_ctor );
  self.e_tor_c.yaw_speed = self.m_rot_speed;
  part_chain.c_part = self.e_tor_c;
  part_chain = part_chain.c_part;
  
  if( (self.unit_rtor) ){
    self.e_tor_r = build_mech_torsoRight(self.unit_rtor);
    part_chain.c_part = self.e_tor_r;
    part_chain = part_chain.c_part;
  }
  if( (self.unit_ltor) ){
    self.e_tor_l = build_mech_torsoLeft(self.unit_ltor);
    part_chain.c_part = self.e_tor_l;
    part_chain = part_chain.c_part;
  }
  if( (self.unit_larm) ){
    self.e_arm_l = build_mech_torsoLeft(self.unit_larm);
    part_chain.c_part = self.e_arm_l;
    part_chain = part_chain.c_part;
  }
  if( (self.unit_rarm) ){
    self.e_arm_r = build_mech_torsoLeft(self.unit_rarm);
    part_chain.c_part = self.e_arm_r;
    part_chain = part_chain.c_part;
  }
  if( (self.unit_legs) ){
    self.e_legs = build_mech_legs(self.unit_legs);
    part_chain.c_part = self.e_legs;
    part_chain = part_chain.c_part;
  }
  
  build_unit_weapon_list();
};

entity( void() func ) build_unit_turret={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    func();
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    util_setModel(self.c_model, this.mskin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.angles = this.angles;
    self.owner = this;
    self.th_die = ctrl_die_comp;
    self.attack_state = TR_NORM;
  self = this;
  return comp;
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
    setsize(self, '-1 -1 -1','1 1 1');
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
    self.th_stand = leg_stand1;
    self.th_walk = leg_walk1;
    self.th_die = leg_die1;
    if( (this.data_type == DATA_MECH) || (this.data_type == DATA_MECH_AI) ){
      leg_stand1();
    }
  self = this;
  return leg_ent;
};

void(void() data_ini) build_vehicle_unit={
  local entity part_chain;
  local vector hmins, hmaxs;
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  util_setModel(self.c_model, self.mskin, 0);
  setsize( self, hmins, hmaxs );
  
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  
  self.alpha = 1;
  self.sh_hit = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  if( (self.unit_cam) ){
    self.e_cam = build_unit_camera(self.unit_cam);
  }
  part_chain = self;
  
  if( (self.flags & FL_TURRET) ){
    self.e_tor_c = build_unit_turret( self.unit_ctor );
    part_chain.c_part = self.e_tor_c;
    part_chain = part_chain.c_part;
  }
  
  if( (self.unit_rtor) ){
    self.e_tor_r = build_mech_torsoRight(self.unit_rtor);
    part_chain.c_part = self.e_tor_r;
    part_chain = part_chain.c_part;
  }
  if( (self.unit_ltor) ){
    self.e_tor_l = build_mech_torsoLeft(self.unit_ltor);
    part_chain.c_part = self.e_tor_l;
    part_chain = part_chain.c_part;
  }
  
  build_unit_weapon_list();
};

void( void() data_ini ) build_vtol_unit={
  self.flags = self.flags | FL_FLY;
  build_vehicle_unit( data_ini );
};

void(void() data_ini) build_turret_unit={
  build_vehicle_unit( data_ini );

  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  util_setOffsetOrigin(self.e_legs, self, self.e_legs.c_ofs);
};
