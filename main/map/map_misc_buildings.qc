/*
battleMETAL
Author: Peter Roohr
Date: 04/27/2020
Overview: 
  misc buildings that really serve no direct purpose
*/

void() misc_build_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  switch( self.vec_size ){
    case 2:
      setmodel(self, "q3mdl/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel(self, "q3mdl/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
      break;
  }
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
  trigger_event( self, self.trigOnDeath );

  local vector shoot;
  shoot = randompos(self.absmin * 0.67, self.absmax * 0.67);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  
  self.think = misc_build_die2;
  self.nextthink = time + 0.1;
};

void() misc_building={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.alpha = TRUE;
  
  precache_model2(self.model);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  droptofloor();
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.th_die = misc_build_die1;
  self.think = building_burn_th;
  self.nextthink = time + random() * 3;
};

/*QUAKED building_misc_apartment (0 0 1) (-20 -20 0) (20 20 52) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apartment={
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 1;
  self.model = "q3mdl/buildings/misc/misc_apt_sm.obj";
  
  misc_building();
};

/*QUAKED building_misc_factory_med (0 0 1) (-36 -36 0) (36 36 76) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_factory_med={
  if( !self.health) {
    self.health = self.max_health = 350;
  }
  self.vec_size = 2;
  self.model = "q3mdl/buildings/misc/misc_fact_med.obj";

  misc_building();
};


/*QUAKED building_misc_lodge(0 0 1) (-38 -38 0) (38 38 64) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_lodge={
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 1;
  self.model = "q3mdl/buildings/misc/misc_lodge.obj";
  
  misc_building();
};



/*QUAKED building_misc_off_pyra (0 0 1) (-68 -68 0) (68 68 72) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_pyra={
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 2;
  self.model = "q3mdl/buildings/misc/misc_off_pyramid.obj";
  
  misc_building();
};

/*QUAKED building_misc_off_large (0 0 1) (-88 -88 0) (88 88 64) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 250. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_large={
  if( !self.health) {
    self.health = self.max_health = 250;
  }
  self.vec_size = 2;
  self.model = "q3mdl/buildings/misc/misc_off_large.obj";
  
  misc_building();
};


/*QUAKED building_misc_off_small (0 0 1) (-36 -36 0) (36 36 80) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 100. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_off_small={
  if( !self.health) {
    self.health = self.max_health = 100;
  }
  self.vec_size = 2;
  self.model = "q3mdl/buildings/misc/misc_off_sm.obj";
  
  misc_building();
};


/*QUAKED building_misc_fact_steam (0 0 1) (-36 -36 0) (36 36 48) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 300. (default)
faction = 255 (FACTION_ALL default)
-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_fact_steam={
  if( !self.health) {
    self.health = self.max_health = 100;
  }
  self.vec_size = 2;
  self.model = "q3mdl/buildings/misc/misc_fact_steam.obj";
  
  misc_building();
};



/*QUAKED building_misc_apt_larg (0 0 1) (-60 -60 0) (60 60 56) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - - - - - NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
Does not require power.

Max Health = 200. (default)

-------- KEYS --------
.faction : <float> optional if you want to use as base building.
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_misc_apt_larg={
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  self.vec_size = 3;
  self.model = "q3mdl/buildings/misc/misc_apt_larg.obj";
  
  misc_building();
};