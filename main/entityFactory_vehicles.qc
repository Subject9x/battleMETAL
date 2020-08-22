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
  util_setModel(self.modelPath, own.skin, 0);
  setsize(self, '-1 -1 -1', '1 1 1');
  util_setOffsetOrigin(self, own, self.compOffset);
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
  
  macro_set_collider(DAMAGE_NO,SOLID_NOT,MOVETYPE_FOLLOW)
  macro_set_model(self.model, own.skin, 0)
  setsize(self, '-1 -1 -1', '1 1 1');
  macro_set_offset(own,self.compOffset)
  
  self.owner = own;
  self.aiment = follow;
  self.punchangle = follow.angles;
  self.view_ofs = self.origin - follow.origin;
  self.angles = follow.angles;
  self.v_angle = self.angles - follow.angles;
  if( self.partTypeId == M_ARM_RIGHT || self.partTypeId == M_ARM_LEFT ){
    self.th_die = ctrl_arm_die;
  }
  else{
    self.th_die = ctrl_component_die;
  }
  self.realowner = follow;
  self.colormod = self.owner.colormod;
};

void() build_unit_camera={
  local entity this, cam, partParent;
  this = self;
  cam = this.cockpit;
  partParent = util_getPartFromName( cam.partParentId, this);
  
  self = cam;
    self.partTypeId = M_CAMERA;
    self.classname = "camera";
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW)
    setmodel( self, "q3mdl/testball.md3");
    setsize(self, '-1 -1 -1', '1 1 1');
    macro_set_offset(this, self.compOffset)
    self.scale = 0.001;
    
    self.aiment = partParent;
    self.owner = this;
    self.punchangle = partParent.angles;
    self.view_ofs = self.origin - partParent.origin;
    self.angles = partParent.angles;
    self.v_angle = self.angles - partParent.angles;
    self.effects = self.effects | (EF_LOWPRECISION | EF_NODRAW);
  self = this;
};

void() build_unit_weapon_list={
  local entity weaponMount;
  local entity prevWeapon;
  local float weaponCount;
  prevWeapon = self;
  weaponMount = self.w_slot;
  if( weaponMount ){
    weaponCount = 1;
    while( weaponMount ){
      weaponBuild = weaponMount;
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
      weaponMount.partPrev = prevWeapon;
      prevWeapon = weaponMount;
      if( (weaponMount.owner.flags & FL_MONSTER) ){
        weaponMount.effects = weaponMount.effects | EF_NODRAW;
      }
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
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW)
    setsize(self, '-1 -1 -1','1 1 1');
    setmodel(self, "q3mdl/testball.md3");
    ofs = self.compOffset + self.compAltOffset;
    macro_set_offset(own, ofs)
    
    partParent = util_getPartFromName( self.partParentId, own );
    
    self.angles_x = anglemod(partParent.angles_x + self.w_adj_ang_x);
    self.angles_y = anglemod(partParent.angles_y + self.w_adj_ang_y);
    self.angles_z = anglemod(partParent.angles_z + self.w_adj_ang_z);
    
    self.aiment = partParent;
    self.owner = own;
    self.punchangle = partParent.angles;
    self.view_ofs = self.origin - partParent.origin;
    self.v_angle = self.angles - partParent.angles;
    
    if( (self.damageType & DMG_MSC) ){
      //Fire Equipment 'upgrade' functions now
      if( self.item_run_upgrade ){
        self.item_run_upgrade();
      }
    }
    self.wepFireOffsetCache = self.wepFireOffset;
    self.th_die = ctrl_die_weapon;
    self.w_think = self.think;
  self = parentEntity;
};

/*
  Builds mech data for Players and Bots.
*/
void() build_mech_unit={
  local vector tempMin, tempMax;

  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  self.skin = self.faction - 1;

  if( self.skin < 0 ){
    self.skin = 0;
  }
  if( self.skin > 3){
    //Deathmach randomizer;
    self.skin = min(rint(random()*3),0);
  }
  
  self.data_type = DATA_MECH;
  self.flags = self.flags | FL_UNIT;
  
  //-> sub out to making specific bots.
  if( !(self.flags & FL_CLIENT) ){
    build_mech_bot();
    return;
  }

  tempMin = self.mins;
  tempMax = self.maxs;
  
  build_mech_torsoCenter();
  
  self.health = self.max_health;
  self.shieldRateMod = 1.33; //unmodified here.
  
  setsize(self, tempMin, tempMax);
  
  self.shieldHitDelay = 0;
  self.shieldHitRegen = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  unitPartList = self;
  if( self.torsoRight ){
    build_mech_torsoRight();
    self.torsoRight.partPrev = unitPartList;
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
  }
  if( self.torsoLeft ){
    build_mech_torsoLeft();
    self.torsoLeft.partPrev = unitPartList;
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
  }
  if( self.armRight ){
    build_mech_armRight();
    self.armRight.partPrev = unitPartList;
    unitPartList.partNext = self.armRight;
    unitPartList = unitPartList.partNext;
  }
  if( self.armLeft ){
    build_mech_armLeft();
    self.armLeft.partPrev = unitPartList;
    unitPartList.partNext = self.armLeft;
    unitPartList = unitPartList.partNext;
  }
  if( self.legs ){
    build_mech_legs();
    self.legs.partPrev = unitPartList;
    unitPartList.partNext = self.legs;
    unitPartList = unitPartList.partNext;
  }
  
  if( self.cockpit ){
    build_unit_camera();
  }
  self.energy = self.energyMax;
  self.shield = self.shieldMax;
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

  client_update_faction();
};

void() build_mech_torsoCenter={
  local entity this;
  local vector hmins, hmaxs;

  if( (self.flags & FL_CLIENT) ){
    macro_set_collider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_WALK)
  }
  else{
    macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  }
  
  hmins = self.mins;
  hmaxs = self.maxs;
  macro_set_model("q3mdl/testball.md3", 0, 0)
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  this = self;
  self = self.torsoCenter;
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW)
    macro_set_model(self.model, this.skin, 0)
    setsize(self, '-1 -1 -1','1 1 1');
    macro_set_offset(this,'0 0 0')
    self.punchangle = self.angles = '0 0 0';
    self.aiment = this;
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles;
    this.torsoCenter = self;
    self.colormod = this.colormod;
    self.th_die = ctrl_component_die;
  self = this;
};

void() build_mech_bot={
  local vector hmins, hmaxs;
  
  self.flags = self.flags | FL_MONSTER;
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  macro_set_model("q3mdl/testball.md3", self.skin, 0)
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  
  self.energy = self.energyMax;
  self.shield = self.shieldMax;
  self.health = self.max_health;
  
  unitPartList = self;
  
  build_unit_turret();
  self.torsoCenter.yaw_speed = self.turret_yaw_speed;
  unitPartList.partNext = self.torsoCenter;
  unitPartList = unitPartList.partNext;
  self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  
  if( self.torsoRight ){
    build_mech_torsoRight();
    self.torsoRight.partPrev = unitPartList;
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
    self.torsoRight.effects = self.torsoRight.effects | EF_NODRAW;
  }
  if( self.torsoLeft ){
    build_mech_torsoLeft();
    self.torsoLeft.partPrev = unitPartList;
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
    self.torsoLeft.effects = self.torsoLeft.effects | EF_NODRAW;
  }
  if( self.armRight ){
    build_mech_armRight();
    self.armRight.partPrev = unitPartList;
    unitPartList.partNext = self.armRight;
    unitPartList = unitPartList.partNext;
    self.armRight.effects = self.armRight.effects | EF_NODRAW;
  }
  if( self.armLeft ){
    build_mech_armLeft();
    self.armLeft.partPrev = unitPartList;
    unitPartList.partNext = self.armLeft;
    unitPartList = unitPartList.partNext;
    self.armLeft.effects = self.armLeft.effects | EF_NODRAW;
  }
  if( (self.legs) ){
    build_mech_legs();
    self.legs.partPrev = unitPartList;
    unitPartList.partNext = self.legs;
    unitPartList = unitPartList.partNext;
    self.legs.th_walk = bot_leg_walk1;
    self.legs.th_run = bot_leg_back1;
    self.legs.th_stand = bot_leg_stand1;
    self.legs.movetype = MOVETYPE_NONE;
    self.legs.yaw_speed = self.yaw_speed * 2.5;
    self.legs.attack_state = TR_NORM;
    self.legs.ai_dir = self.angles_y;
  }
  
  if( (self.cockpit) ){
    build_unit_camera();
  }
  //speed limits for AI because they change directions instantly :/
  if( self.data_speed_forward > 200 ){
    self.data_speed_forward = 200;
  }
  if( self.data_speed_strafe > 200 ){
    self.data_speed_strafe = 200;
  }
  if( self.data_speed_backward > 200 ){
    self.data_speed_backward = 200;
  }
  self.data_speed_forward = self.data_speed_forward * AI_MECH_MOVE_FACTOR;
  self.data_speed_strafe = self.data_speed_strafe * AI_MECH_MOVE_FACTOR;
  self.data_speed_backward = self.data_speed_backward * AI_MECH_MOVE_FACTOR;
  
  if( self.hardpoint_cnt > 0 ){
    if( (self.spawnflags & UNARMED) ){
      self.flags = self.flags | FL_DISARMED;
    }
    else{
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
  if( self.data_speed_forward > AI_PATROL_SPEED_LIMIT ){
    self.ai_patrol_speed = AI_PATROL_SPEED_LIMIT;
  }
  else{
    self.ai_patrol_speed = self.data_speed_forward;
  }
};

void() build_unit_turret={
  local entity this;
  this = self;
  self = self.torsoCenter;
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE; 
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE)
    macro_set_model(self.model, this.skin, 0)
    setsize(self, self.mins, self.maxs);
    macro_set_offset(this, self.compOffset)
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
  self = this;
};

void() build_mech_armRight={
  local entity this;
  this = self;
  self = self.armRight;
    build_unit_component( this );
  self = this;
};

void() build_mech_legs={
  local entity this;
  this = self;
  
  self = self.legs;
    self.deadflag = DEAD_NO;
    self.classname = MECH_PIECE;
    self.walkframe = 1;
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE)
    if( (this.flags & FL_CLIENT) ){
      self.aiment = this;
    }
    macro_set_model(self.model, this.skin, 0)
    setsize(self, '-1 -1 -1','1 1 1');
    macro_set_offset(this, self.compOffset)
    self.owner = this;
    self.punchangle = this.angles;
    self.view_ofs = self.origin - this.origin;
    self.angles = this.angles;
    self.v_angle = self.angles - this.angles; 

    self.laser_sight_org = '0 0 0';
    self.laser_sight_timer = time + 0.5; 
    self.w_firerate = 0; //used to track data_speed_accel changes
    self.th_stand = leg_stand1;
    self.th_walk = leg_walk1;
    self.th_die = ctrl_dieLegs;
    //we pack the unit's original speed values here, to allow us to restore them if the unit repairs its legs
    self.data_speed_forward = this.data_speed_forward;
    self.data_speed_backward = this.data_speed_backward;
    self.data_speed_strafe = this.data_speed_strafe;
    self.data_speed_accel = this.data_speed_accel;  
    leg_stand1();
    self.colormod = this.colormod;
  self = this;
};

void() build_vehicle_unit={
  local vector hmins, hmaxs;
  
  self.data_type = DATA_VEHC;
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  //->CSQC
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  //self.skin = self.faction - 1;
  //if( self.skin < 0 ){
  //  self.skin = 0;
 // }
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  macro_set_model("q3mdl/testball.md3", 0, 0) //->CSQC for specifics
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.evasionDrain = self.vec_size;
  
  unitPartList = self;
  
  if( (self.flags & FL_TURRET) && (self.torsoCenter) ){
    build_unit_turret();
    self.torsoCenter.yaw_speed = self.turret_yaw_speed;
    self.torsoCenter.partPrev = unitPartList;
    unitPartList.partNext = self.torsoCenter;
    unitPartList = unitPartList.partNext;
    self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  }
  
  if( (self.torsoRight) ){
    build_mech_torsoRight();
    self.torsoRight.partPrev = unitPartList;
    unitPartList.partNext = self.torsoRight;
    unitPartList = unitPartList.partNext;
    self.torsoRight.effects = self.torsoRight.effects | EF_NODRAW;
  }
  if( (self.torsoLeft) ){
    build_mech_torsoLeft();
    self.torsoLeft.partPrev = unitPartList;
    unitPartList.partNext = self.torsoLeft;
    unitPartList = unitPartList.partNext;
    self.torsoLeft.effects = self.torsoLeft.effects | EF_NODRAW;
  }
  if( (self.cockpit) ){
    build_unit_camera();
  }
  
  if( self.hardpoint_cnt > 0 ){
    if( (self.spawnflags & UNARMED) ){
      self.flags = self.flags | FL_DISARMED;
    }
    else{
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
  if( self.data_speed_forward > AI_PATROL_SPEED_LIMIT ){
    self.ai_patrol_speed = AI_PATROL_SPEED_LIMIT;
  }
  else{
    self.ai_patrol_speed = self.data_speed_forward;
  }
};

//TODO - deprecated, needs rebuild
void( void() data_ini ) build_vtol_unit={
  self.flags = self.flags | FL_FLY;
  build_vehicle_unit();
};
//----------------------------------

void() build_turret_unit={

  build_vehicle_unit();
  self.data_type = DATA_BLD;
  self.hitOffset = self.origin + (v_up * (self.maxs_z * 0.85));
  setorigin(self, self.origin);

  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 4) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
};
