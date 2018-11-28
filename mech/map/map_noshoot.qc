/*
battleMETAL
Author: Peter Roohr
Date: 11/27/2018
Overview: 
  A map object that modifies unit flags, controlling whether and for how long a unit
  has the given flags.
  
  this is very powerful and mostly only used for FL_NOSHOOT
  
Inputs
  .comp_id = <float> [flags]  flags you want modified
  .p_dmgtype = <float> [flags] 1 - Affect FL_CLIENT ONLY
  
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - draw the whole weapon model
  .spawnflags = <float> [flag] 32 - use limited number of shots
  
*/

void() map_noshoot_th={
  self.isActive = TRUE;
  self.think = self.use;
  self.nextthink = time + 0.1;
};

void() map_noshoot_use={
  if( self.isActive ){
    self.isActive = FALSE;
    local entity e;
    local float findFlags;
    findFlags = FL_MONSTER;
    if( (self.p_dmgtype) ){
      findFlags = findFlags | FL_CLIENT;
    }
    e = findchainflags(flags, findFlags);
    while( e ){
      if( (e.flags & self.comp_id) ){
        e.flags = e.flags - (e.flags & self.comp_id);
      }
      else{
        //simple revert code
        e.flags = e.flags | self.comp_id;
      }
      e = e.chain;
    }
    
    //remove after first use
    if( (self.spawnflags & 8) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
      return;
    }
    
    //cooldown
    if( (self.spawnflags & 4) ){
      self.think = map_noshoot_th;
      self.nextthink = time + self.wait;
      return;
    }
  }
  else{
    //activate?
    self.think = map_noshoot_th;
    self.nextthink = time + 0.1;
    return;
  }
};

void() map_noshoot_touch={
  if( (other.flags & FL_CLIENT) ){
    self.use();
  }
};


/*QUAKED map_noshoot () () ()
*/
void() map_noshoot={
  local vector tempMin;
  local vector tempMax;
  
  tempMax = self.maxs;
  tempMin = self.mins;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.touch = map_noshoot_touch;
  self.use = map_noshoot_use;
  self.isActive = TRUE;
  
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, tempMin, tempMax);
  setorigin(self, self.origin);

  //START_OFF
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
};