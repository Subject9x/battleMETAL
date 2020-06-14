/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/16/2017
Overview: 
  Merely a necessary interstitial map object to set a Mission Objective to 'fail'.
  This should be used sparingly, they clean themsleves up after firing.
  
Inputs
  .target = <string> [objective targetname] - objective to 'fail'.
  .mins = <vector> [lower half of bounding box]
  .maxs = <vector> [upper half of bounding box] - use both of these with spawnflags[2]
  
  .spawnflag = <float> [flag] 2 - ALLOW TRIGGER TOUCH
*/

void() map_fail_objective_use={
  local entity obj;
  local entity thisEnt;
  
  OBJECTIVE_FAILED = TRUE;
  for( obj = nextent(world); obj != world; obj = nextent(obj) ){
    if( obj.classname != "map_objective" ){
      continue;
    }
    if( obj.targetname == "" || obj.targetname != self.target ){
      continue;
    }
    thisEnt = self;
    self = obj;
      obj.use();
    self = thisEnt;
  }
  OBJECTIVE_FAILED = FALSE;
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

/*QUAKED map_fail_objective (0.431 0.788 0.753) (-16 -8 -16) (16 8 16) - ON_TOUCH
Merely a necessary interstitial map object to set a Mission Objective to 'fail'.
This should be used sparingly, they clean themsleves up after firing.

-------- KEYS -------- 
.target = <string> [objective targetname] - objective to trigger.
.mins = <vector> [lower half of bounding box]
.maxs = <vector> [upper half of bounding box] - use both of these with spawnflags[2]

-------- SPAWNFLAGS -------- 
ON_TOUCH 2: ALLOW TRIGGER TOUCH
*/
void() map_fail_objective={
  
  self.movetype = MOVETYPE_NONE;
  if( (self.spawnflags & 2) ){
    setmodel( self, self.model);
    //trigger is touchable
    self.solid = SOLID_TRIGGER;
    setsize( self, self.mins, self.maxs );
  }
  else{
    util_MapDeveloperMarker();
    util_DeveloperNodeMark();
    self.solid = SOLID_NOT;
    setsize( self, VEC_ORIGIN, VEC_ORIGIN );
  }
  self.use = map_fail_objective_use;
  setorigin( self, self.origin );
};