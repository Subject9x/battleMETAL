/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
  mod: 11/26/2017
  mod: 01/28/2018
  mod: 05/20/2019
Overview: 
  header for all game-data related functions,
  its up to either the client or the server to define these functions
  
*/

#ifdef SSQC
entity unitPartList;  //used by vehicle factory to build full list of unit's parts as a chain.
entity weaponBuild; //used by vehicle factory to build current weapon
.void() unit_ini;
.void() item_remove_upgrade;
.void() item_run_upgrade;
#endif

entity weaponList;  //used by data functions to populate weapon lists for units

/*
  called when building something with common/data info.
  instantiates the target object and populates it with
  parameter values.
*/
void( float partId, string pathToModel, float maxHp, vector partOffset, entity parentPart, .entity partSlot, vector altOffsett ) data_ini_unitPiece_={
  local entity piece;

  piece = spawn();
  piece.partTypeId = partId;
  piece.partParentId = parentPart.partTypeId;
  piece.max_health = piece.health = maxHp;
  piece.model = pathToModel;
  piece.compOffset = partOffset;
  piece.hitOffset = '0 0 0';
  piece.compAltOffset = piece.compAltOffsetCache = altOffsett;
  #ifdef CSQC
    piece.nextthink = time + 0.1;
  #else
    if( (self.flags & FL_MONSTER) ){
      if( piece.partTypeId != M_LEGS ){
        piece.effects = piece.effects | EF_NODRAW;
      }
    }
  #endif
  self.partSlot = piece;
  piece.owner = self;
};

//just some syntactic sugar wrappings
void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_center_={
  #ifdef SSQC
    data_ini_unitPiece_( M_TOR_CENTER, pathToModel, healthMax, offsetOrigin, self, torsoCenter, altOffset);
    self.torC_hp = self.torC_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.torC_hpMax = healthMax;
    self.torC_mdl = pathToModel;
  #endif
  
  self.torC_parentId = M_UNIT;
  self.torC_compOffset = offsetOrigin;
  self.torC_compAltOffset = altOffset;
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_right_={
  #ifdef SSQC
    data_ini_unitPiece_( M_TOR_RIGHT, pathToModel, healthMax, offsetOrigin, self.torsoCenter, torsoRight, altOffset);
    self.torR_hp = self.torR_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.torR_hpMax = healthMax;
    self.torR_mdl = pathToModel;
  #endif
  
  self.torR_parentId = M_TOR_CENTER;
  self.torR_compOffset = offsetOrigin;
  self.torR_compAltOffset = altOffset;
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_left_={
  #ifdef SSQC
    data_ini_unitPiece_( M_TOR_LEFT, pathToModel, healthMax, offsetOrigin, self.torsoCenter, torsoLeft, altOffset);
    self.torL_hp = self.torL_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.torL_hpMax = healthMax;
    self.torL_mdl = pathToModel;
  #endif
  
  self.torL_parentId = M_TOR_CENTER;
  self.torL_compOffset = offsetOrigin;
  self.torL_compAltOffset = altOffset;
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_left_={
  #ifdef SSQC
    data_ini_unitPiece_( M_ARM_LEFT, pathToModel, healthMax, offsetOrigin, self.torsoLeft, armLeft, altOffset);
    self.armL_hp = self.armL_hpMax = healthMax;
  #endif

  
  #ifdef CSQC
    self.armL_hpMax = healthMax;
    self.armL_mdl = pathToModel;
  #endif
  
  self.armL_parentId = M_TOR_LEFT;
  self.armL_compOffset = offsetOrigin;
  self.armL_compAltOffset = altOffset;
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_right_={
  #ifdef SSQC
    data_ini_unitPiece_( M_ARM_RIGHT, pathToModel, healthMax, offsetOrigin, self.torsoRight, armRight, altOffset);
    self.armR_hp = self.armR_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.armR_hpMax = healthMax;
    self.armR_mdl = pathToModel;
  #endif
  
  self.armR_parentId = M_TOR_RIGHT;
  self.armR_compOffset = offsetOrigin;
  self.armR_compAltOffset = altOffset;
};

void(string pathToModel, float healthMax, vector offsetOrigin) data_ini_legs_={
  #ifdef SSQC
    data_ini_unitPiece_( M_LEGS, pathToModel, healthMax, offsetOrigin, self, legs, '0 0 0');
    self.legs_hp = self.legs_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.legs_hpMax = healthMax;
    self.legs_mdl = pathToModel;
  #endif
  
  self.legs_parentId = M_TOR_CENTER;
  self.legs_compOffset = offsetOrigin;
};



void( float weaponBit, float parentPartID, vector pointOffsetVec , vector adjustAngleVec, float newHardPointSizeVal ) data_ini_unitHardpoint_={
  local entity item;
  local entity notItem;
  if( self.hardpoint_cnt < 10){
    item = spawn();
    weaponList.w_slot = item;
    notItem = self;
    self = item;
      self.data_idx = 0;
      self.w_group = self.w_group | weaponBit;
      self.partParentId = parentPartID;
      self.compOffset = pointOffsetVec;
      self.w_adj_ang = adjustAngleVec;
      self.owner = notItem;
      self.hardpointSize = newHardPointSizeVal;
    self = notItem;
    weaponList = item;
    self.hardpoint_cnt = self.hardpoint_cnt + 1;
  }
};

/*
  Simple wrapper functions for data_ini_unitHardpoint_.
  these are probably easier to read / write than 
  using the wrapped function.
*/
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_1={
 data_ini_unitHardpoint_( WEAPON1, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_2={
 data_ini_unitHardpoint_( WEAPON2, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_3={
 data_ini_unitHardpoint_( WEAPON3, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_4={
 data_ini_unitHardpoint_( WEAPON4, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_5={
 data_ini_unitHardpoint_( WEAPON5, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_6={
 data_ini_unitHardpoint_( WEAPON6, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_7={
 data_ini_unitHardpoint_( WEAPON7, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_8={
 data_ini_unitHardpoint_( WEAPON8, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size ) data_ini_unitHardpoint_9={
 data_ini_unitHardpoint_( WEAPON9, parentPartId, pointOffset, adjustAngle, hardpoint_Size );
};

void(float wep_id) initialize_data_item_;
void(float mech_id) initialize_data_mech_;
void(float vec_id) initialize_data_vehicle_;
void(float vec_id) initialize_data_turret_;

/*
  this is the default weapon update function used by
  all weapons. you can replace this in any weapon 
  by defining another function before assignment.
  -Roohr
*/
#ifdef SSQC
void() default_weapon_think={
  local float delta;
  
  if(self.wepReloadState == RECOIL){
    if(time > self.w_firetime){
      self.wepReloadState = READY;
    }
    self.reloadValue = (self.w_currentammo / self.w_clipsize) * 100;
  }
  else if(self.wepReloadState == RELOADING){
    if(time > self.w_firetime){
      self.reloadValue = 100;
      self.wepReloadState = READY;
      if( (self.owner.flags & FL_MONSTER) ){
        //AI re-fire timing is offset to be more fair to the player.
        self.ai_nextFireTime = self.owner.ai_attack_chance + self.reloadMax;  //ai_attack_chance set by ai_stats.qc
        self.ai_nextFireTime = self.ai_nextFireTime + ((4 - self.owner.ai_rank) / 2); //4 is magic, its max skill (3) + 1, tougher AI attacks more frequently
        self.ai_nextFireTime = time + (random() * self.ai_nextFireTime);  //gotta love randomization
      }
    }
    else{
      self.reloadValue = 0;
      if(self.reloadMax > 0){
        delta = time - self.count1;
        self.reloadValue = (delta / self.reloadMax) * 100;
      }
    }
  }
  self.think = default_weapon_think;
};

.void() data_ini_projectile;

#endif

/*
  modflags provide top-level directives for how mechs are configured for a game,
    they also pre-empt actual entity checks (sacrifice of readability),
    so we run this valiadotr
  
*/
void(entity unit) data_validate_mod_flags={

  if( !unit.torL_compOffset ){
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_EXPLODE_TOR_L);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_PITCH_TOR_L);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_HAS_TOR_L);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_NO_TOR_L);
  }
  
  if( !unit.torR_compOffset ){
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_EXPLODE_TOR_R);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_PITCH_TOR_R);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_HAS_TOR_R);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_NO_TOR_R);
  }
  
  if( !unit.armR_compOffset ){
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_EXPLODE_TOR_R);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_PITCH_TOR_R);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_HAS_ARM_R);
  }
  
  if( !unit.armL_compOffset ){
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_EXPLODE_TOR_L);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_MODEL_PITCH_TOR_L);
    unit.unitModFlags = unit.unitModFlags - (unit.unitModFlags & MOD_HAS_ARM_L);
  }
};


#ifdef SSQC
/*
	This was promoted up to common/data because its portable and
	reuseable in both client and server.
*/
entity(float part, entity unit) util_getPartFromName={
  local entity thepart;
  switch( part ){
    case M_TOR_CENTER:
      thepart = unit;
      if( (unit.flags & FL_TURRET) ){
        thepart = unit.torsoCenter;
      }
      break;
    case M_TOR_RIGHT:
      thepart = unit.torsoRight;
      break;
    case M_TOR_LEFT:
      thepart = unit.torsoLeft;
      break;
    case M_LEGS:
      thepart = unit.legs;
      if( (unit.data_type == DATA_VEHC) ){
        thepart = unit;  //edge case for hull-mounted weapons on a turreted object
      }
      break;
    case M_ARM_LEFT:
      thepart = unit.armLeft;
      break;
    case M_ARM_RIGHT:
      thepart = unit.armRight;
      break;
    default:
      thepart = unit;
      break;
  }
  
  return thepart;
};
#endif

#ifdef CSQC
vector T_PART_PARENT_ORG;
vector T_PART_PARENT_ANGL;
vector T_PART_PARENT_OFFSET;

void(float part, entity unit) util_getPartFromName={
  local vector vOrg;
  switch( part ){
    case M_TOR_CENTER:
      if( (unit.flags & FL_TURRET) ){
        T_PART_PARENT_ORG = unit.torC_org;
        T_PART_PARENT_ANGL = unit.torC_angl;
        T_PART_PARENT_OFFSET = unit.torC_compOffset;
      }
      else{
        T_PART_PARENT_ORG = unit.origin;
        T_PART_PARENT_ANGL = unit.angles;
        T_PART_PARENT_OFFSET = '0 0 0';
      }
      break;
    case M_TOR_RIGHT:
      T_PART_PARENT_ORG = unit.torR_org;
      T_PART_PARENT_ANGL = unit.torR_angl;
      T_PART_PARENT_OFFSET = unit.torR_compOffset;
      break;
    case M_TOR_LEFT:
      T_PART_PARENT_ORG = unit.torL_org;
      T_PART_PARENT_ANGL = unit.torL_angl;
      T_PART_PARENT_OFFSET = unit.torL_compOffset;
      break;
    case M_LEGS:
      vOrg = unit.legs_compOffset;
      if( (unit.data_type == DATA_VEHC) ){
        //edge case for hull-mounted weapons on a turreted object
        T_PART_PARENT_ORG = unit.origin;
        T_PART_PARENT_ANGL = unit.angles;
        T_PART_PARENT_OFFSET = '0 0 0';
      }
      else{
        T_PART_PARENT_ORG = unit.legs_org;
        T_PART_PARENT_ANGL = unit.legs_angl;
        T_PART_PARENT_OFFSET =  unit.legs_compOffset;
      }
      break;
    case M_ARM_LEFT:
      T_PART_PARENT_ORG = unit.armL_org;
      T_PART_PARENT_ANGL = unit.armL_angl;
      T_PART_PARENT_OFFSET = unit.armL_compOffset;
      break;
    case M_ARM_RIGHT:
      T_PART_PARENT_ORG = unit.armR_org;
      T_PART_PARENT_ANGL = unit.armR_angl;
      T_PART_PARENT_OFFSET = unit.armR_compOffset;
      break;
    default:
      T_PART_PARENT_ORG = unit.origin;
      T_PART_PARENT_ANGL = unit.angles;
      T_PART_PARENT_OFFSET = '0 0 0';
      break;
  }
};
#endif