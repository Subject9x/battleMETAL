/*
battleMETAL
Author: Peter Roohr
Date: 8/31/2016
mod: 11/27/2017 - data system refactor
Overview: builds player vehicle
*/

/*
  rewiring to use md3 tags would also involve changes to shot angle calcs for weapons..
  so, maybe one day
*/ 
/*void(void() func, entity own) build_unit_tag_component={
  local entity follow;
  func();
  follow = util_getPartFromName( self.c_parent, own );
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, own.skin, 0);
  setsize(self, '-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, own, self.c_ofs);
  self.owner = own;
  //self.aiment = follow;
  //self.punchangle = follow.angles;
  //self.view_ofs = self.origin - follow.origin;
  //self.angles = follow.angles;
  //self.v_angle = self.angles - follow.angles;
  self.th_die = ctrl_component_die;
  self.colormod = '1 1 1';
  setattachment(self, follow, "tag_tor_l");
};*/

void(void() func, entity own) build_unit_component={
  local entity follow;
  func();
  follow = util_getPartFromName( self.c_parent, own );
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.c_model, own.skin, 0);
  
  setsize(self, '-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, own, self.c_ofs);
  self.owner = own;
  self.aiment = follow;
  self.punchangle = follow.angles;
  self.view_ofs = self.origin - follow.origin;
  self.angles = follow.angles;
  self.v_angle = self.angles - follow.angles;
  self.th_die = ctrl_component_die;
  self.colormod = '1 1 1';
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
    if(self.next_wepn1 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep1, self.next_wepn1, self, WEAPON1_OK, WEAPON1_DD, WEAPON1_REL, stat_w1_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w1_rel = 100;
      }
    }
  }
  if(self.unit_wep2){
    if(self.next_wepn2 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep2, self.next_wepn2, self, WEAPON2_OK, WEAPON2_DD, WEAPON2_REL, stat_w2_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w2_rel = 100;
      }
    }
  }
  if(self.unit_wep3){
    if(self.next_wepn3 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep3, self.next_wepn3, self, WEAPON3_OK, WEAPON3_DD, WEAPON3_REL, stat_w3_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w3_rel = 100;
      }
    }
  }
  if(self.unit_wep4){
    if(self.next_wepn4 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep4, self.next_wepn4, self, WEAPON4_OK, WEAPON4_DD, WEAPON4_REL, stat_w4_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w4_rel = 100;
      }
    }
  }
  if(self.unit_wep5){
    if(self.next_wepn5 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep5, self.next_wepn5, self, WEAPON5_OK, WEAPON5_DD, WEAPON5_REL, stat_w5_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w5_rel = 100;
      }
    }
  }
  if(self.unit_wep6){
    if(self.next_wepn6 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep6, self.next_wepn6, self, WEAPON6_OK, WEAPON6_DD, WEAPON6_REL, stat_w6_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w6_rel = 100;
      }
    }
  }
  if(self.unit_wep7){
    if(self.next_wepn7 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep7, self.next_wepn7, self, WEAPON7_OK, WEAPON7_DD, WEAPON7_REL, stat_w7_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w7_rel = 100;
      }
    }
  }
  if(self.unit_wep8){
    if(self.next_wepn8 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep8, self.next_wepn8, self, WEAPON8_OK, WEAPON8_DD, WEAPON8_REL, stat_w8_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w8_rel = 100;
      }
    }
  }
  if(self.unit_wep9){
    if(self.next_wepn9 > 0){
      wslot.w_slot = build_unit_weapon(self.unit_wep9, self.next_wepn9, self, WEAPON9_OK, WEAPON9_DD, WEAPON9_REL, stat_w9_id);
      wslot = wslot.w_slot;
      if( (self.flags & FL_CLIENT)){
        self.stat_w9_rel = 100;
      }
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
      self.p_damage = ai_pilot_mod_damage( own.ai_rank, self.p_damage);
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
  local entity part_chain;
  
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  self.skin = self.i_faction - 1;
  if( self.skin < 0 ){
    self.skin = 0;
  }
  
  if( !(self.flags & FL_CLIENT) ){
    build_mech_bot( data_ini );
    return;
  }
  
  self.data_type = DATA_MECH;
  self.flags = self.flags | FL_UNIT;
  
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
    util_setModel(this.c_model, this.skin, 0);
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
    self.colormod = '1 1 1';
  self = this;
  ctor_stand();
};

void(void() data_ini) build_mech_bot={
  local entity part_chain;
  local vector hmins, hmaxs;
  
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  util_setModel("q3mdl/testball.md3", self.skin, 0);
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
  self.e_tor_c.yaw_speed = self.turret_yaw_speed;
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
    self.e_legs.th_walk = leg_walk1;
    self.e_legs.th_run = leg_back1;
    self.e_legs.th_stand = leg_stand1;
    self.e_legs.movetype = MOVETYPE_NONE;
    self.e_legs.yaw_speed = self.yaw_speed * 1.5;
    self.e_legs.attack_state = TR_NORM;
    self.ai_dir = self.angles_y;
  }
  
  //speed limits for AI because they change directions instantly :/
  if( self.m_fspeed > 175 ){
    self.m_fspeed = 175;
  }
  if( self.m_sspeed > 175 ){
    self.m_sspeed = 175;
  }
  if( self.m_bspeed > 175 ){
    self.m_bspeed = 175;
  }
  self.m_fspeed = self.m_fspeed * AI_MECH_MOVE_FACTOR;
  self.m_sspeed = self.m_sspeed * AI_MECH_MOVE_FACTOR;
  self.m_bspeed = self.m_bspeed * AI_MECH_MOVE_FACTOR;
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
    util_setModel(self.c_model, this.skin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.angles = this.angles;
    self.owner = this;
    self.th_die = ctrl_component_die;
    self.attack_state = TR_NORM;
    self.colormod = '1 1 1';
  self = this;
  return comp;
};

entity(void() func) build_mech_torsoLeft={
  local entity this, comp;
  this = self;
  comp = spawn();
  self = comp;
    build_unit_component(func, this);
    //build_unit_tag_component(func, this);
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
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    if( (this.flags & FL_CLIENT) ){
      util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
      self.aiment = this;
    }
    util_setModel(self.c_model, this.skin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
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
    //we pack the unit's original speed values here, to allow us to restore them if the unit repairs its legs
    self.m_fspeed = this.m_fspeed;
    self.m_bspeed = this.m_bspeed;
    self.m_sspeed = this.m_sspeed;
    self.m_maccel = this.m_maccel;
    if( this.data_type == DATA_MECH ){
      leg_stand1();
    }
    self.colormod = '1 1 1';
  self = this;
  return leg_ent;
};

void(void() data_ini) build_vehicle_unit={
  local entity part_chain;
  local vector hmins, hmaxs;
  
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  self.skin = self.i_faction - 1;
  if( self.skin < 0 ){
    self.skin = 0;
  }
  util_setModel(self.c_model, self.skin, 0);
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
    self.e_tor_c.yaw_speed = self.turret_yaw_speed;
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
};
