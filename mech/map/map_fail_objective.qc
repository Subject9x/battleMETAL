/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/16/2017
Overview: 
  Merely a necessary interstitial map object to set a Mission Objective to 'fail'.
  This should be used sparingly, they clean themsleves up after firing.
  
Inputs
  .target = <string> [objective targetname] - objective to trigger.
  .mins = <vector> [lower half of bounding box]
  .maxs = <vector> [upper half of bounding box] - use both of these with spawnflags[2]
  .spawnflag = <float> [flag] 2 - ALLOW TRIGGER TOUCH
*/

void() map_fail_objective_use={
  local entity obj;
  
  obj = find(world, targetname, self.target);
  if( obj ){
    obj.isActive = -1;
  }
  else{
    dprint( strcat("Objective ", self.target, " not found!\n") ); //DEBUG
  }
  remove(self);
};


/*QUAKED
*/
void() map_fail_objective={
  local vector tempMin;
  local vector tempMax;
  
  setmodel( self, "q3mdl/testball.md3" );
  self.movetype = MOVETYPE_NONE;
  if( (self.spawnflags & 2) ){
    //trigger is touchable
    self.solid = SOLID_TRIGGER;
    tempMin = self.mins;
    tempMax = self.maxs;
    setsize( self, tempMin, tempMax );
  }
  else{
    self.solid = SOLID_NOT;
    setsize( self, VEC_ORIGIN, VEC_ORIGIN );
  }
  setorigin( self, self.origin );
  
  
};