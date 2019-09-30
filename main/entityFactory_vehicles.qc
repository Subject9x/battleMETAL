/*
battleMETAL
Author: Peter Roohr
Date: 8/31/2016
mod: 11/27/2017 - data system refactor
mod: 05/23/2019 - another refactor
Overview: 
  responsible for building all units found in the game.
  This takes common/data/ and binds it to entities.
  Sets up entity sub-pieces, and attaches weapons.
*/

/*
  rewiring to use md3 tags would also involve changes to shot angle calcs for weapons..
  so, maybe one day...
*/ 
/*void(void() func, entity own) build_unit_tag_component={
  local entity follow;
  func();
  follow = util_getPartFromName( self.partParentId, own );
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

void(entity own) build_unit_component={
  local entity follow;

  follow = util_getPartFromName( self.partParentId, own );
  self.deadflag = DEAD_NO;
  self.classname = MECH_PIECE; 
  util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
  util_setModel(self.model, own.skin, 0);
  
  setsize(self, '-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, own, self.c_ofs);
  self.owner = own;
  self.aiment = follow;
  self.punchangle = follow.angles;
  self.view_ofs = self.origin - follow.origin;
  self.angles = follow.angles;
  self.v_angle = self.angles - follow.angles;
  self.th_die = ctrl_component_die;
  self.realowner = follow;
  self.colormod = '1 1 1';
};

void() build_unit_camera={
  local entity this, cam, partParent;
  this = self;
  cam = this.cockpit;
  partParent = util_getPartFromName( cam.partParentId, this);
  
  self = cam;
    self.partTypeId = M_CAMERA;
    self.classname = "camera";
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    setmodel( self, "q3mdl/testball.md3");
    setsize(self, '-1 -1 -1', '1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    
    self.scale = 0.001;
    
    self.aiment = partParent;
    self.owner = this;
    self.punchangle = partParent.angles;
    self.view_ofs = self.origin - partParent.origin;
    self.angles = partParent.angles;
    self.v_angle = self.angles - partParent.angles;
  self = this;
  //unitPartList.partNext = cam;
  //unitPartList = cam;
};

void() build_unit_weapon_list={
  local entity weaponMount;
  local float weaponCount;

  weaponMount = self.w_slot;
  if( weaponMount ){
    weaponCount = 1;
    unitPartList.partNext = weaponMount;  //should be last piece added to unit, now we add weapons
    unitPartList = weaponMount;
    while( weaponMount ){
      weaponBuild = weaponMount;
      unitPartList.partNext = weaponMount;
      switch( weaponCount ){
        case 1:
          build_unit_weapon( self.next_wepn1, self, stat_w1_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w1_rel = 100;
          }
          break;
        case 2:
          build_unit_weapon( self.next_wepn2, self, stat_w2_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w2_rel = 100;
          }
          break;
        case 3:
          build_unit_weapon( self.next_wepn3, self, stat_w3_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w3_rel = 100;
          }
          break;
        case 4:
          build_unit_weapon( self.next_wepn4, self, stat_w4_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w4_rel = 100;
          }
          break;
        case 5:
          build_unit_weapon( self.next_wepn5, self, stat_w5_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w5_rel = 100;
          }
          break;
        case 6:
          build_unit_weapon( self.next_wepn6, self, stat_w6_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w6_rel = 100;
          }
          break;
        case 7:
          build_unit_weapon( self.next_wepn7, self, stat_w7_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w7_rel = 100;
          }
          break;
        case 8:
          build_unit_weapon( self.next_wepn8, self, stat_w8_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w8_rel = 100;
          }
          break;
        case 9:
          build_unit_weapon( self.next_wepn9, self, stat_w9_id);
          if( (self.flags & FL_CLIENT)){
            self.stat_w9_rel = 100;
          }
          break;
      }
      weaponCount = weaponCount + 1;
      weaponMount = weaponMount.w_slot;
    }
  }
};

void( float nex_wep, entity own, .float stat) build_unit_weapon={
  local entity parentEntity, partParent;
  local vector ofs;
  parentEntity = self;
  
  self = weaponBuild;
    self.data_idx = own.stat = nex_wep;
    self.damageType = 0; //zero-out this stat
    initialize_data_item_(nex_wep);
    
    self.reloadValue = 100; // bug fix - weapon reload indicator not starting at correct value
    self.w_firetime = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = READY;
    self.health = 1;
    self.max_health = 1;
  
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    self.partTypeId = M_ITEM;

    if( (own.flags & FL_MONSTER) ){
      self.damageValue = ai_pilot_mod_damage( own.ai_rank, self.damageValue);
      if(self.w_clipsize > 1){
        self.w_firerate = self.w_firerate * AI_WEAPON_RPS_MOD;
      }
    }
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.model, 0, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    ofs = self.c_ofs + self.c_alt_ofs;
    util_setOffsetOrigin(self, own, ofs);
    
    partParent = util_getPartFromName( self.partParentId, own );
    
    self.angles_x = anglemod(partParent.angles_x + self.w_adj_ang_x);
    self.angles_y = anglemod(partParent.angles_y + self.w_adj_ang_y);
    self.angles_z = anglemod(partParent.angles_z + self.w_adj_ang_z);
    
    self.aiment = partParent;
    self.owner = own;
    self.punchangle = partParent.angles;
    self.view_ofs = self.origin - partParent.origin;
    //self.angles = partParent.angles;
    self.v_angle = self.angles - partParent.angles;
    
    if( (self.damageType & DMG_MSC) ){
      //Fire Equipment 'upgrade' functions now
      if( self.w_attack ){
        self.w_attack();
        self.w_attack = SUB_Null; //remove upgrade function
      }
    }
    self.th_die = ctrl_die_weapon;
  self = parentEntity;
};


void(void() data_ini) build_mech_unit={
  local vector tempMin, tempMax;
  
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  self.skin = self.faction - 1;
  if( self.skin < 0 ){
    self.skin = 0;
  }
  
  self.data_type = DATA_MECH;
  self.flags = self.flags | FL_UNIT;
  
  if( !(self.flags & FL_CLIENT) ){
    build_mech_bot( data_ini );
    return;
  }
  
  data_ini();
  tempMin = self.mins;
  tempMax = self.maxs;
  
  build_mech_torsoCenter();
  
  self.energy = self.energyMax;
  self.shield = self.shieldMax;
  self.health = self.max_health;
  self.evasionDrain = EVADE_DRAIN_PERCENT;
  
  setsize(self, tempMin, tempMax);
  
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  unitPartList = self;
  if( self.torsoRight ){
    build_mech_torsoRight();
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
  }
  if( self.torsoLeft ){
    build_mech_torsoLeft();
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
  }
  if( self.armRight ){
    build_mech_armRight();
    unitPartList.partNext = self.armRight;
    unitPartList = unitPartList.partNext;
  }
  if( self.armLeft ){
    build_mech_armLeft();
    unitPartList.partNext = self.armLeft;
    unitPartList = unitPartList.partNext;
  }
  if( self.legs ){
    build_mech_legs();
    unitPartList.partNext = self.legs;
    unitPartList = unitPartList.partNext;
  }
  
  if( self.cockpit ){
    build_unit_camera();
  }
  
  self.doRadarSweep = radarSweepBasic;
  
  if( self.hardpoint_cnt > 0 ){
    build_unit_weapon_list();
  }
  
  //fall_dist = fall velocity, if exceeded, check for slam
  self.fall_dist = self.vec_size - MAX_VEHICLE_SIZE;
  self.fall_dist = self.fall_dist * FALL_THRESHOLD;
  
  //fall_slam = fall velocity to check for damage
  self.fall_slam = self.fall_dist * FALL_DMG_MULTIPLIER;
  
  //fall_dmg = actual damage applied
  self.fall_dmg = (MAX_VEHICLE_SIZE - self.vec_size) / MAX_VEHICLE_SIZE ;
  
};

void() build_mech_torsoCenter={
  local entity this;
  local vector hmins, hmaxs;

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
  this = self;
  self = self.torsoCenter;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
    util_setModel(self.model, this.skin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, '0 0 0');
    self.punchangle = self.angles = '0 0 0';
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles;
    this.torsoCenter = self;
    self.colormod = '1 1 1';
    self.th_die = ctrl_component_die;
  self = this;
};

void(void() data_ini) build_mech_bot={
  local vector hmins, hmaxs;
  
  self.flags = self.flags | FL_MONSTER;
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  util_setModel("q3mdl/testball.md3", self.skin, 0);
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  
  self.energy = self.energyMax;
  self.shield = self.shieldMax;
  self.health = self.max_health;
  self.evasionDrain = EVADE_DRAIN_PERCENT;
  
  unitPartList = self;
  
  build_unit_turret();
  self.torsoCenter.yaw_speed = self.turret_yaw_speed;
  unitPartList.partNext = self.torsoCenter;
  unitPartList = unitPartList.partNext;
  
  if( (self.torsoRight) ){
    build_mech_torsoRight();
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
  }
  if( (self.torsoLeft) ){
    build_mech_torsoLeft();
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
  }
  if( (self.armLeft) ){
    build_mech_armLeft();
    unitPartList.partNext = self.armLeft;
    unitPartList = unitPartList.partNext;
  }
  if( (self.armRight) ){
    build_mech_armRight();
    unitPartList.partNext = self.armRight;
    unitPartList = unitPartList.partNext;
  }
  if( (self.legs) ){
    build_mech_legs();
    unitPartList.partNext = self.legs;
    unitPartList = unitPartList.partNext;
    self.legs.th_walk = leg_walk1;
    self.legs.th_run = leg_back1;
    self.legs.th_stand = leg_stand1;
    self.legs.th_die = bot_leg_die1;
    self.legs.movetype = MOVETYPE_NONE;
    self.legs.yaw_speed = self.yaw_speed * 1.5;
    self.legs.attack_state = TR_NORM;
    self.ai_dir = self.angles_y;
  }
  
  if( (self.cockpit) ){
    build_unit_camera();
  }
  
  //speed limits for AI because they change directions instantly :/
  if( self.data_speed_forward > 175 ){
    self.data_speed_forward = 175;
  }
  if( self.data_speed_strafe > 175 ){
    self.data_speed_strafe = 175;
  }
  if( self.data_speed_backward > 175 ){
    self.data_speed_backward = 175;
  }
  self.data_speed_forward = self.data_speed_forward * AI_MECH_MOVE_FACTOR;
  self.data_speed_strafe = self.data_speed_strafe * AI_MECH_MOVE_FACTOR;
  self.data_speed_backward = self.data_speed_backward * AI_MECH_MOVE_FACTOR;
  
  if( self.hardpoint_cnt > 0 ){
    if( !(self.spawnflags & AI_SPAWNFLAG_UNARMED) ){
      build_unit_weapon_list();
    }
  }
  switch( self.faction ){
    case FACTION_PSC:
      MISSION_TOTAL_PSC = MISSION_TOTAL_PSC + 1;
      break;
    case FACTION_SURVEST:
      MISSION_TOTAL_SURVEST = MISSION_TOTAL_SURVEST + 1;
      break;
    case FACTION_MILITAR:
      MISSION_TOTAL_MILITAR = MISSION_TOTAL_MILITAR + 1;
      break;
  }
  self.ai_minrange = ai_pilot_minrange();
};

void() build_unit_turret={
  local entity this;
  this = self;
  self = self.torsoCenter;
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    util_setModel(self.model, this.skin, 0);
    setsize(self, '-1 -1 -1','1 1 1');
    util_setOffsetOrigin(self, this, self.c_ofs);
    self.angles = this.angles;
    self.owner = this;
    self.th_die = ctrl_component_die;
    self.attack_state = TR_NORM;
    self.colormod = '1 1 1';
  self = this;
};

void() build_mech_torsoLeft={
  local entity this;
  this = self;
  self = self.torsoLeft;
    build_unit_component( this );
    //build_unit_tag_component(func, this);
  self = this;
};

void() build_mech_torsoRight={
  local entity this;
  this = self;
  self = self.torsoRight;
    build_unit_component( this );
  self = this;
};

void() build_mech_armLeft={
  local entity this;
  this = self;
  self = self.armLeft;
    build_unit_component( this );
    self.partNext = this.torsoLeft;
  self = this;
};

void() build_mech_armRight={
  local entity this;
  this = self;
  self = self.armRight;
    build_unit_component( this );
    self.partNext = this.torsoRight;
  self = this;
};

void() build_mech_legs={
  local entity this;
  this = self;
  
  self = self.legs;
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 1;
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    if( (this.flags & FL_CLIENT) ){
      util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW);
      self.aiment = this;
    }
    util_setModel(self.model, this.skin, 0);
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
    self.w_firerate = 0; //used to track data_speed_accel changes
    self.th_stand = leg_stand1;
    self.th_walk = leg_walk1;
    self.th_die = leg_die1;
    //we pack the unit's original speed values here, to allow us to restore them if the unit repairs its legs
    self.data_speed_forward = this.data_speed_forward;
    self.data_speed_backward = this.data_speed_backward;
    self.data_speed_strafe = this.data_speed_strafe;
    self.data_speed_accel = this.data_speed_accel;
    if( this.data_type == DATA_MECH ){
      leg_stand1();
    }
    self.colormod = '1 1 1';
  self = this;
};

void(void() data_ini) build_vehicle_unit={
  local vector hmins, hmaxs;
  
  self.data_type = DATA_VEHC;
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  
  data_ini();
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  self.skin = self.faction - 1;
  if( self.skin < 0 ){
    self.skin = 0;
  }
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP);
  util_setModel(self.model, self.skin, 0);
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.evasionDrain = EVADE_DRAIN_PERCENT;
  
  unitPartList = self;
  
  if( (self.flags & FL_TURRET) && (self.torsoCenter) ){
    build_unit_turret();
    self.torsoCenter.yaw_speed = self.turret_yaw_speed;
    unitPartList.partNext = self.torsoCenter;
    unitPartList = unitPartList.partNext;
  }
  
  if( (self.torsoRight) ){
    build_mech_torsoRight();
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
  }
  if( (self.torsoLeft) ){
    build_mech_torsoLeft();
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
  }
  if( (self.cockpit) ){
    build_unit_camera();
  }
  
  if( self.hardpoint_cnt > 0 ){
    if( !(self.spawnflags & AI_SPAWNFLAG_UNARMED) ){
      build_unit_weapon_list();
    }
  }
   
  self.health = self.max_health;
  
  switch( self.faction ){
    case FACTION_PSC:
      MISSION_TOTAL_PSC = MISSION_TOTAL_PSC + 1;
      break;
    case FACTION_SURVEST:
      MISSION_TOTAL_SURVEST = MISSION_TOTAL_SURVEST + 1;
      break;
    case FACTION_MILITAR:
      MISSION_TOTAL_MILITAR = MISSION_TOTAL_MILITAR + 1;
      break;
  }
  self.ai_minrange = ai_pilot_minrange();
};

//TODO - deprecated, needs rebuild
void( void() data_ini ) build_vtol_unit={
  self.flags = self.flags | FL_FLY;
  build_vehicle_unit( data_ini );
};
//----------------------------------

void(void() data_ini) build_turret_unit={

  build_vehicle_unit( data_ini );
  self.data_type = DATA_BLD;

  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
};
