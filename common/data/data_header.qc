/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
  mod: 11/26/2017
  mod: 01/28/2018
  mod: 05/20/2019
  mod: 06/27/2022
Overview: 
  header for all game-data related functions,
  its up to either the client or the server to define these functions
  
*/

#ifdef SSQC
entity weaponBuild; //used by vehicle factory to build current weapon
.void() unit_ini;
.void() item_remove_upgrade;
.void() item_run_upgrade;
#endif

entity weaponList;  //used by data functions to populate weapon lists for units

//just some syntactic sugar wrappings
void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_center_={
  #ifdef SSQC
    self.torC_hp = self.torC_hpMax = healthMax;
  #endif
  
  self.torC_hpMax = healthMax;
  self.torC_mdl = pathToModel;
  
  self.torC_parentId = M_UNIT;
  self.torC_compOffset = offsetOrigin;
  self.torC_compAltOffset = altOffset;
  precache_model(pathToModel);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_right_={
  #ifdef SSQC
    self.torR_hp = self.torR_hpMax = healthMax;
  #endif

  self.torR_hpMax = healthMax;
  self.torR_mdl = pathToModel;

  self.torR_parentId = M_TOR_CENTER;
  self.torR_compOffset = offsetOrigin;
  self.torR_compAltOffset = altOffset;
  precache_model(pathToModel);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_left_={
  #ifdef SSQC
    self.torL_hp = self.torL_hpMax = healthMax;
  #endif
  self.torL_hpMax = healthMax;
  self.torL_mdl = pathToModel;
  self.torL_parentId = M_TOR_CENTER;
  self.torL_compOffset = offsetOrigin;
  self.torL_compAltOffset = altOffset;
  precache_model(pathToModel);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_left_={
  #ifdef SSQC
    self.armL_hp = self.armL_hpMax = healthMax;
  #endif
  self.armL_hpMax = healthMax;
  self.armL_mdl = pathToModel;
  self.armL_parentId = M_TOR_LEFT;
  self.armL_compOffset = offsetOrigin;
  self.armL_compAltOffset = altOffset;
  precache_model(pathToModel);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_right_={
  #ifdef SSQC
    self.armR_hp = self.armR_hpMax = healthMax;
  #endif
  
  self.armR_hpMax = healthMax;
  self.armR_mdl = pathToModel;
  self.armR_parentId = M_TOR_RIGHT;
  self.armR_compOffset = offsetOrigin;
  self.armR_compAltOffset = altOffset;
  precache_model(pathToModel);
};

void(string pathToModel, float healthMax, vector offsetOrigin) data_ini_legs_={
  #ifdef SSQC
    self.legs_hp = self.legs_hpMax = healthMax;
  #endif
  
  #ifdef CSQC
    self.legs_hpMax = healthMax;
    self.legs_mdl = pathToModel;
    precache_model(pathToModel);
  #endif
  
  self.legs_parentId = M_TOR_CENTER;
  self.legs_compOffset = offsetOrigin;
};



void( float weaponBit, float parentPartID, vector pointOffsetVec , vector adjustAngleVec, float newHardPointSizeVal ) data_ini_unitHardpoint_={
  local entity item;
  local entity notItem;
  if( self.hardpoint_cnt < 10){
    #ifdef SSQC
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
    #endif
    
    #ifdef CSQC
      if( (self.classname == "UI_ITEM") ){
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
      }
    #endif
    
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

vector T_PART_PARENT_ORG;
vector T_PART_PARENT_ANGL;
vector T_PART_PARENT_OFFSET;
float T_PART_HP;

void(float part, entity unit) util_getPartFromName={
  local vector vOrg;
  switch( part ){
    case M_TOR_CENTER:
      if( (unit.flags & FL_TURRET) ){
        T_PART_PARENT_ORG = unit.torC_org;
        T_PART_PARENT_ANGL = unit.torC_angl;
        T_PART_PARENT_OFFSET = unit.torC_compOffset;
        T_PART_HP = unit.torC_hp;
      }
      else{
        T_PART_PARENT_ORG = unit.origin;
        T_PART_PARENT_ANGL = unit.angles;
        T_PART_PARENT_OFFSET = '0 0 0';
        T_PART_HP = unit.health;
      }
      break;
    case M_TOR_RIGHT:
      T_PART_PARENT_ORG = unit.torR_org;
      T_PART_PARENT_ANGL = unit.torR_angl;
      T_PART_PARENT_OFFSET = unit.torR_compOffset;
      T_PART_HP = unit.torR_hp;
      break;
    case M_TOR_LEFT:
      T_PART_PARENT_ORG = unit.torL_org;
      T_PART_PARENT_ANGL = unit.torL_angl;
      T_PART_PARENT_OFFSET = unit.torL_compOffset;
      T_PART_HP = unit.torL_hp;
      break;
    case M_LEGS:
      vOrg = unit.legs_compOffset;
      if( (unit.data_type == DATA_VEHC) ){
        //edge case for hull-mounted weapons on a turreted object
        T_PART_PARENT_ORG = unit.origin;
        T_PART_PARENT_ANGL = unit.angles;
        T_PART_PARENT_OFFSET = '0 0 0';
        T_PART_HP = unit.health;
      }
      else{
        T_PART_PARENT_ORG = unit.legs_org;
        T_PART_PARENT_ANGL = unit.legs_angl;
        T_PART_PARENT_OFFSET =  unit.legs_compOffset;
        T_PART_HP = unit.legs_hp;
      }
      break;
    case M_ARM_LEFT:
      T_PART_PARENT_ORG = unit.armL_org;
      T_PART_PARENT_ANGL = unit.armL_angl;
      T_PART_PARENT_OFFSET = unit.armL_compOffset;
      T_PART_HP = unit.armL_hp;
      break;
    case M_ARM_RIGHT:
      T_PART_PARENT_ORG = unit.armR_org;
      T_PART_PARENT_ANGL = unit.armR_angl;
      T_PART_PARENT_OFFSET = unit.armR_compOffset;
      T_PART_HP = unit.armR_hp;
      break;
    default:
      T_PART_PARENT_ORG = unit.origin;
      T_PART_PARENT_ANGL = unit.angles;
      T_PART_PARENT_OFFSET = '0 0 0';
      T_PART_HP = unit.health;
      break;
  }
};