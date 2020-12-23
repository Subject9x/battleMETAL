/*
battleMETAL
Author: Peter Roohr
Date: 04/27/2020
Overview: 
  misc buildings that really serve no direct purpose
*/


float( float isNew, float changeFlags ) sendent_misc_building={
  local float newFlags;
  
  newFlags = 0;
  if( isNew ){
    newFlags = changeFlags;
    newFlags = newFlags | (SENDFLAG_MOVE | SENDFLAG_ANGLE | SENDFLAG_DEAD);
  }
  
  WriteByte( MSG_ENTITY, SENDTYPE_MISC_BLD );
  WriteCoord( MSG_ENTITY, newFlags );
  //======================
  
  if( (newFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    if(self.deadflag != DEAD_NO){
      WriteByte( MSG_ENTITY, self.vec_size );
    }
  }
  
  if( (newFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  if( (newFlags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (newFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.vec_size );
    WriteByte( MSG_ENTITY, self.data_idx );
    if( self.faction ){
      WriteByte( MSG_ENTITY, self.faction );
    }
    else{
      WriteByte( MSG_ENTITY, 255 );
    }
    WriteByte( MSG_ENTITY, self.canTarget );
  }
  return TRUE;
};

void() misc_build_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  switch( self.vec_size ){
    case 2:
      self.model = "q3mdl/map/ruins/ruin_medium.obj";
      break;
    case 3:
      self.model = "q3mdl/map/ruins/ruin_large.obj";
      break;
    default:
      self.model = "q3mdl/map/ruins/ruin_small.obj";
      break;
  }
	setmodel(self, self.model);
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin);
};

void() misc_build_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD; 
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );

  local vector shoot;
  shoot = randompos(self.absmin * 0.67, self.absmax * 0.67);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  
  self.think = misc_build_die2;
  self.nextthink = time + 0.1;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
};

/*
  Generic ini func for misc_buildings
*/
void( string modelName, float setSizeFlag ) misc_building={
  
  setmodel(self, modelName);
  if( setSizeFlag ){
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
  }
  
  if( !(self.spawnflags & MISC_NO_DROP) ){
    droptofloor();
  }
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.alpha = TRUE;
  
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.th_die = misc_build_die1;
  self.think = building_burn_th;
  self.nextthink = time + random() * 1;
  
  self.data_type = DATA_BLD;
  self.getTarget = FALSE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.getTarget = TRUE;
  }
  
  self.SendEntity = sendent_misc_building;
};

/*QUAKED building_misc_apartment (0 0 1) (-36 -20 0) (36 20 52) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apartment={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 1;
  
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 1;
  
  misc_building("q3mdl/buildings/misc/misc_apt_sm.obj", TRUE);
  self.solid = SOLID_SLIDEBOX;
  setsize(self, '-36 -20 0', '36 20 52');
  setorigin(self, self.origin);
  self.angles = '0 90 0';
};
/*QUAKED building_misc_apartment_wide (0 0 1) (-20 -36 0) (20 36 52) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apartment_wide={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 1;
  
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 1;
  
  misc_building("q3mdl/buildings/misc/misc_apt_sm.obj", TRUE);
  self.solid = SOLID_SLIDEBOX;
  setsize(self, '-20 -36 0', '20 36 52');
  setorigin(self, self.origin);
};


/*QUAKED building_misc_factory_med (0 0 1) (-88 -36 0) (88 36 76) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_factory_med={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 2;
  
  if( !self.health) {
    self.health = self.max_health = 350;
  }
  self.vec_size = 2;

  misc_building("q3mdl/buildings/misc/misc_fact_med.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  setsize(self, '-88 -36 0', '88 36 76');
  setorigin(self, self.origin);
  self.angles = '0 90 0';
};
/*QUAKED building_misc_factory_med_wide (0 0 1) (-36 -88 0) (36 88 76) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_factory_med_wide={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 2;
  
  if( !self.health) {
    self.health = self.max_health = 350;
  }
  self.vec_size = 2;
  misc_building("q3mdl/buildings/misc/misc_fact_med.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  setsize(self, '-36 -88 0', '36 88 76');
  setorigin(self, self.origin);
  self.angles = '0 0 0';
};





/*QUAKED building_misc_lodge(0 0 1) (-38 -38 0) (38 38 64) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)
note: long-side == arrow direction
-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_lodge={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 3;
  
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 1;
  
  misc_building("q3mdl/buildings/misc/misc_lodge.obj", TRUE);
};



/*QUAKED building_misc_off_pyra (0 0 1) (-68 -68 0) (68 68 72) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_pyra={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 4;
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 2;
  
  if( self.angles_y ){
    self.angles_y = 0;
    //quick hack to fix a BBOX issue: if this model is rotated, somehow players can fall INTO them...
  }
  
  misc_building("q3mdl/buildings/misc/misc_off_pyramid.obj", TRUE);
};

/*QUAKED building_misc_off_large (0 0 1) (-88 -88 0) (88 88 64) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 250. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_large={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 5;
  if( !self.health) {
    self.health = self.max_health = 250;
  }
  self.vec_size = 3;
  
  misc_building("q3mdl/buildings/misc/misc_off_large.obj", TRUE);
};

/*QUAKED building_misc_off_small (0 0 1) (-36 -56 0) (36 56 80) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 100. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_small={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 6;
  if( !self.health) {
    self.health = self.max_health = 100;
  }
  self.vec_size = 2;
  
  misc_building( "q3mdl/buildings/misc/misc_off_sm.obj", TRUE);
  self.solid = SOLID_SLIDEBOX;
  setsize( self, '-36 -56 0', '36 56 80');
  setorigin(self, self.origin);
};
/*QUAKED building_misc_off_small_wide (0 0 1) (-56 -36 0) (56 36 80)  NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 100. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_small_wide={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 6;
  if( !self.health) {
    self.health = self.max_health = 100;
  }
  self.vec_size = 2;
  
  misc_building( "q3mdl/buildings/misc/misc_off_sm.obj", TRUE );
  self.solid = SOLID_SLIDEBOX;
  setsize( self, '-56 -36 0', '56 36 80');
  setorigin(self, self.origin);
  self.angles = '0 90 0';
};

/*QUAKED building_misc_fact_steam (0 0 1) (-36 -36 0) (36 36 48) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 300. (default)

-------- KEYS --------
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_fact_steam={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 7;
  if( !self.health) {
    self.health = self.max_health = 100;
  }
  self.vec_size = 2;
  misc_building("q3mdl/buildings/misc/misc_fact_steam.obj", TRUE);
};


/*QUAKED building_misc_apt_large_north(0 0 1) (-96 0 0) (96 120 56) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)
note: flatside direction == arrow direction.

-------- KEYS --------
.faction : <float> 
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apt_large_north={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 8;
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 3;
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  self.angles = '0 270 0';
  setsize( self, '-96 0 0', '96 120 56');
  setorigin(self, self.origin);
};
/*QUAKED building_misc_apt_large_east (0 0 1) (0 -96 0) (120 96 56) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)
note: flatside direction == arrow direction.

-------- KEYS --------
.faction : <float> 
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apt_large_east={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 8;
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 3;
  
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  setsize( self, '0 -96 0', '120 96 56');
  setorigin(self, self.origin);
  self.angles = '0 180 0';
};
/*QUAKED building_misc_apt_large_west (0 0 1) (-120 -96 0) (0 96 56) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)
note: flatside direction == arrow direction.

-------- KEYS --------
.faction : <float> 
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apt_large_west={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 8;
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 3;
  
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  setsize( self, '-120 -96 0', '0 96 56');
  setorigin(self, self.origin);
  self.angles = '0 0 0';
};
/*QUAKED building_misc_apt_large_south(0 0 1) (-96 -120 0) (96 0 56) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET - - - DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

warning: don't arbitrarily rotate, non-uniform bbox size.

Base Decoration building.
Does not require power.

Max Health = 200. (default)
note: flatside direction == arrow direction.

-------- KEYS --------
.faction : <float> 
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
CAN_TARGET 16: turns building from scenery to valid target.
DO_NOT_USE 256: engine-linked value SPAWNFLAG_NOT_EASY
DO_NOT_USE 512: engine-linked value SPAWNFLAG_NOT_MEDIUM
DO_NOT_USE 1024: engine-linked value SPAWNFLAG_NOT_HARD
DO_NOT_USE 2048: engine-linked value SPAWNFLAG_NOT_DEATHMATCH
NO_NOVICE 4096: remove from Novice Difficulty
NO_REGULAR 8192: remove from Regular Difficulty
NO_VETERAN 16384: remove from Veteran Difficulty
NO_ELITE 32768: remove from Elite Difficulty
NODROP 65536: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apt_large_south={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 8;
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 3;
  
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", FALSE);
  self.solid = SOLID_SLIDEBOX;
  setsize( self, '-96 -120 0', '96 0 56');
  setorigin(self, self.origin);
  self.angles = '0 90 0';
};