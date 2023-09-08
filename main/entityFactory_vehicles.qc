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
void() build_unit_weapon_list={
  local entity weaponMount;
  local entity prevWeapon;
  local float weaponCount;
  local entity unit;
  
  prevWeapon = self;
  weaponMount = self.w_slot;
  if( weaponMount ){
    weaponCount = 1;
    while( weaponMount ){
      weaponBuild = weaponMount;
      switch( weaponCount ){
        case 1:
          build_unit_weapon( self.next_wepn1, self );
          break;
        case 2:
          build_unit_weapon( self.next_wepn2, self );
          break;
        case 3:
          build_unit_weapon( self.next_wepn3, self );
          break;
        case 4:
          build_unit_weapon( self.next_wepn4, self );
          break;
        case 5:
          build_unit_weapon( self.next_wepn5, self );
          break;
        case 6:
          build_unit_weapon( self.next_wepn6, self );
          break;
        case 7:
          build_unit_weapon( self.next_wepn7, self );
          break;
        case 8:
          build_unit_weapon( self.next_wepn8, self );
          break;
        case 9:
          build_unit_weapon( self.next_wepn9, self );
          break;
      }
      weaponCount = weaponCount + 1;
      weaponMount.partPrev = prevWeapon;
      prevWeapon = weaponMount;
      weaponMount = weaponMount.w_slot;
    }
    //run upgrades now because per-weapon updates need the full list.
    weaponMount = self.w_slot;
    unit = self;
    while( weaponMount ){
      self = weaponMount;
      if( weaponMount.item_run_upgrade ){
        weaponMount.item_run_upgrade();
      }
      weaponMount = weaponMount.w_slot;
    }
    self = unit;
  }
};

void( float nex_wep, entity own ) build_unit_weapon={
  local entity parentEntity, partParent;
  local vector ofs;
  parentEntity = self;
  
  self = weaponBuild;
    self.data_idx = nex_wep;
    self.damageType = 0; //zero-out this stat
    initialize_data_item_(nex_wep);
    
    self.reloadMaxCache = self.reloadMax; //bug fix - might as well stash it here, regardless of player choosing upgrades.
    self.reloadValue = 100; // bug fix - weapon reload indicator not starting at correct value
    self.w_firetime = 0;
    self.w_currentammo = self.w_clipsize;
    self.wepReloadState = READY;
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
    macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE)
    setmodel(self, "models/testball.md3");
    setsize(self, '-1 -1 -1','1 1 1');
    ofs = self.compOffset + self.compAltOffset;
    
    macro_set_offset(own, ofs)
    
    util_getPartFromName( self.partParentId, own );
    
    self.angles_x = anglemod(T_PART_PARENT_ANGL_x + self.w_adj_ang_x);
    self.angles_y = anglemod(T_PART_PARENT_ANGL_y + self.w_adj_ang_y);
    self.angles_z = anglemod(T_PART_PARENT_ANGL_z + self.w_adj_ang_z);
    
    self.aiment = own;
    self.owner = own;
    self.punchangle = T_PART_PARENT_ANGL;
    self.view_ofs = self.origin - T_PART_PARENT_ORG;
    self.v_angle = self.angles - T_PART_PARENT_ANGL;
    
    self.wepFireOffsetCache = self.wepFireOffset;
    self.th_die = ctrl_die_weapon;
    self.w_think = self.think;
    self.SendEntity = ctrl_send_weapon;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWUNIT;
  self = parentEntity;
};

/*
  Builds mech data for Players and Bots.
*/
void() build_mech_unit={
  local vector tempMin, tempMax;
  
  //modflags safety check
  if( !self.unitModFlags ){
    self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  }
  
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
  self.flags = self.flags | FL_UNIT | FL_TURRET;
  
  makevectors(self.angles);
  
  self.cache_speed_fwd = self.data_speed_forward;
  self.cache_speed_sid = self.data_speed_strafe;
  self.cache_speed_back = self.data_speed_backward;
  
  self.cache_shieldMax = self.shieldMax;
  self.cache_maxs = self.maxs;
  self.cache_mins = self.mins;
  
  //-> sub out to making specific bots.
  if( !(self.flags & FL_CLIENT) ){
    build_mech_bot();
    return;
  }
  
  self.canTarget = TRUE;

  tempMin = self.mins;
  tempMax = self.maxs;
  
  build_mech_torsoCenter();
  
  self.health = self.max_health;
  
  setsize(self, tempMin, tempMax);
  
  self.chain_timer = time;
  self.lock_timer = 0;
  
  self.cameraOrigin = self.origin + (v_forward * self.cameraOffset_z) + (v_right * self.cameraOffset_x) + (v_up * self.cameraOffset_y);
  
  if( !(self.unitModFlags & MOD_HEAT_NOT_ENERGY) ){
    self.energy = self.energyMax;
  }
  
  if( (self.unitModFlags & MOD_HAS_SHIELD) ){
    self.shieldRateMod = 0; //unmodified here.
    self.shield = self.shieldMax;
    self.shieldHitDelay = 0;
    self.shieldHitRegen = 0;
  }
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
    macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_WALK)
  }
  else{
    macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  }
  self.partTypeId = M_TOR_CENTER;
  
  hmins = self.mins;
  hmaxs = self.maxs;
  macro_set_model("models/testball.md3", 0, 0)
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
};

void() build_mech_bot={
  local vector hmins, hmaxs;
  
  //modflags safety check
  if( !self.unitModFlags ){
    self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  }
  
  self.flags = self.flags | (FL_MONSTER | FL_TURRET);
  self.canTarget = TRUE;
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  macro_set_model("models/testball.md3", self.skin, 0)
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.entnum = num_for_edict(self);
  
  if( !(self.unitModFlags & MOD_HEAT_NOT_ENERGY) ){
    self.energy = self.energyMax;
  }
  
  if( (self.unitModFlags & MOD_HAS_SHIELD) ){
    self.shield = self.shieldMax;
  }
  self.health = self.max_health;
  
  build_unit_turret();
  self.torC_yawSpeed = self.turret_yaw_speed;

  build_mech_legs();

  
  self.cameraOrigin = self.origin + (v_forward * self.cameraOffset_z) + (v_right * self.cameraOffset_x) + (v_up * self.cameraOffset_y);
  
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
  if( (self.unitModFlags & MOD_HAS_SHIELD) ){ 
    self.shield = self.shieldMax;
    self.stat_client_shield = (self.shield / self.shieldMax) * 100;
  }
};

void() build_unit_turret={  
  self.torC_attackState = TR_NORM;
  self.torC_angl = self.angles;
  self.torC_yawSpeed = self.turret_yaw_speed;
};


void() build_mech_legs={
  /*self.laser_sight_org = '0 0 0';
  self.laser_sight_timer = time + 0.5; 
  self.w_firerate = 0; //used to track data_speed_accel changes*/

  self.legs_angl = self.angles;
  //we pack the unit's original speed values here, to allow us to restore them if the unit repairs its legs
  self.legs_speed_f = self.data_speed_forward;
  self.legs_speed_s = self.data_speed_strafe;
  self.legs_speed_b = self.data_speed_backward;
  self.legs_speed_acc = self.data_speed_accel;
  self.legs_yawSpeed = self.yaw_speed * 2.5;
  self.legs_attackState = TR_NORM;
  self.legDir = self.angles_y;
};

void() build_vehicle_unit={
  local vector hmins, hmaxs;
  
  makevectors(self.angles);
  
  self.data_type = DATA_VEHC;
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.canTarget = TRUE;
  self.entnum = num_for_edict(self);
  
  hmaxs = self.maxs;
  hmins = self.mins;
  
  //->CSQC
  //Darkplaces needs md3 .skin files to increment at exactly _0.skin, _1.skin
  //self.skin = self.faction - 1;
  //if( self.skin < 0 ){
  //  self.skin = 0;
 // }
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_STEP)
  macro_set_model("models/testball.md3", 0, 0) //->CSQC for specifics
  setsize( self, hmins, hmaxs );
  
  self.alpha = 1;
  self.shieldHitDelay = 0;
  self.chain_timer = time;
  self.lock_timer = 0;
  self.evasionDrain = self.vec_size;
  
  if( (self.flags & FL_TURRET) ){
    build_unit_turret();
  }
  
  self.cameraOrigin = self.origin + (v_forward * self.cameraOffset_z) + (v_right * self.cameraOffset_x) + (v_up * self.cameraOffset_y);
   
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
  self.stat_client_shield = 0;
};

//deprecated, needs rebuild
/*void( void() data_ini ) build_vtol_unit={
  self.flags = self.flags | FL_FLY;
  build_vehicle_unit();
};*/
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
