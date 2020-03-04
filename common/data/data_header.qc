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

#ifndef CSQC
entity unitPartList;  //used by vehicle factory to build full list of unit's parts as a chain.
entity weaponBuild; //used by vehicle factory to build current weapon
.void() unit_ini;
.void() item_remove_upgrade;
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
  self.partSlot = piece;
  piece.owner = self;
};

//just some syntactic sugar wrappings
void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_center_={
  data_ini_unitPiece_( M_TOR_CENTER, pathToModel, healthMax, offsetOrigin, self, torsoCenter, altOffset);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_right_={
  data_ini_unitPiece_( M_TOR_RIGHT, pathToModel, healthMax, offsetOrigin, self.torsoCenter, torsoRight, altOffset);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_torso_left_={
  data_ini_unitPiece_( M_TOR_LEFT, pathToModel, healthMax, offsetOrigin, self.torsoCenter, torsoLeft, altOffset);
};

void(string pathToModel, float healthMax, vector offsetOrigin) data_ini_legs_={
  data_ini_unitPiece_( M_LEGS, pathToModel, healthMax, offsetOrigin, self, legs, '0 0 0');
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_left_={
  data_ini_unitPiece_( M_ARM_LEFT, pathToModel, healthMax, offsetOrigin, self.torsoLeft, armLeft, altOffset);
};

void(string pathToModel, float healthMax, vector offsetOrigin, vector altOffset) data_ini_arm_right_={
  data_ini_unitPiece_( M_ARM_RIGHT, pathToModel, healthMax, offsetOrigin, self.torsoRight, armRight, altOffset);
};

void( float weaponBit, float parentPartID, vector pointOffsetVec , vector adjustAngleVec, float newHardPointSizeVal, float newHardPointTypeVal ) data_ini_unitHardpoint_={
  local entity item;
  local entity notItem;
  if( self.hardpoint_cnt < 10){
    item = spawn();
    notItem = self;
    self = item;
      self.data_idx = 0;
      self.w_group = weaponBit;
      self.partParentId = parentPartID;
      self.compOffset = pointOffsetVec;
      self.w_adj_ang = adjustAngleVec;
      self.owner = notItem;
      self.hardpointSize = newHardPointSizeVal;
      self.hardpointType = newHardPointTypeVal;
      weaponList.w_slot = self;
    self = notItem;
    weaponList = item;
    self.hardpoint_cnt = self.hardpoint_cnt + 1;
  }
};

void( vector thisPartOffset, entity partParent ) data_ini_camera_={
  data_ini_unitPiece_( M_TOR_CENTER,  "q3mdl/testball.md3",  1, thisPartOffset, partParent, cockpit, '0 0 0');
};

/*
  Simple wrapper functions for data_ini_unitHardpoint_.
  these are probably easier to read / write than 
  using the wrapped function.
*/
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_1={
 data_ini_unitHardpoint_( WEAPON1, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_2={
 data_ini_unitHardpoint_( WEAPON2, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_3={
 data_ini_unitHardpoint_( WEAPON3, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_4={
 data_ini_unitHardpoint_( WEAPON4, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_5={
 data_ini_unitHardpoint_( WEAPON5, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_6={
 data_ini_unitHardpoint_( WEAPON6, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_7={
 data_ini_unitHardpoint_( WEAPON7, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_8={
 data_ini_unitHardpoint_( WEAPON8, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpoint_Size, float hardpoint_Type ) data_ini_unitHardpoint_9={
 data_ini_unitHardpoint_( WEAPON9, parentPartId, pointOffset, adjustAngle, hardpoint_Size, hardpoint_Type );
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
#ifndef CSQC
void() default_weapon_think={
  local float delta, lim;
  
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
      self.reloadValue = 100;
      self.w_state = READY;
      if( (self.owner.flags & FL_MONSTER) ){
        //AI re-fire timing is offset to be more fair to the player.
        self.ai_nextFireTime = self.owner.ai_attack_chance + self.reloadMax;  //ai_attack_chance set by ai_stats.qc
        self.ai_nextFireTime = self.ai_nextFireTime + ((4 - self.owner.ai_rank) / 2); //4 is magic, its max skill (3) + 1, tougher AI attacks more frequently
        self.ai_nextFireTime = time + (random() * self.ai_nextFireTime);  //gotta love randomization
      }
    }
    else{
      delta = time - self.count1;
      lim = self.reloadMax;
      self.reloadValue = (delta / lim) * 100;
    }
  }
  self.think = default_weapon_think;
};

.void() data_ini_projectile;

#endif
/*
	This was promoted up to common/data because its portable and
	reuseable in both client and server.
*/
entity(float part, entity unit) util_getPartFromName={
  
  switch( part ){
    case M_TOR_CENTER:
      if( (unit.flags & FL_TURRET) ){
        return unit.torsoCenter;
      }
      return unit;
    case M_TOR_RIGHT:
      return unit.torsoRight;
    case M_TOR_LEFT:
      return unit.torsoLeft;
    case M_LEGS:
      if( (unit.data_type == DATA_VEHC) ){
        return unit;  //edge case for hull-mounted weapons on a turreted object
      }
      return unit.legs;
    case M_ARM_LEFT:
      return unit.armLeft;
    case M_ARM_RIGHT:
      return unit.armRight;
    default:
      return unit;
  }
};
