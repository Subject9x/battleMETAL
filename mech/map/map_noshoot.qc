/*
battleMETAL
Author: Peter Roohr
Date: 11/27/2018
Overview: 
  A map object that modifies unit flags, controlling whether and for how long a unit
  has the given flags.
  
  this is very powerful and mostly only used for FL_NOSHOOT
  
Inputs
  .partTypeId = <float> [flags]  flags you want modified
  .damageType = <float> [flags] 1 - Affect FL_CLIENT ONLY
  .delay = <float> delayed start
  
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - restore flags (generally for single use() )
  
*/

void() map_noshoot_th={
  if( !self.isActive ){    
    self.isActive = TRUE;
    
    if( (self.spawnflags & 16) ){
      self.use();
      self.spawnflags = self.spawnflags - (self.spawnflags & 4);
      self.think = SUB_Null;
      self.nextthink = time;
      self.isActive = FALSE;
      return;
    }
    self.think = self.use;
    self.nextthink = time + 0.1;
    return;
  }
  else{
  }
};

void() map_noshoot_shutoff={
  
};

void() map_noshoot_use={
  if( self.isActive ){
    self.isActive = FALSE;
    local entity e;
    local float findFlags;
    findFlags = FL_MONSTER;
    if( (self.damageType) ){
      findFlags = findFlags | FL_CLIENT;
    }
    e = findchainflags(flags, findFlags);
    while( e ){
      if( (e.flags & self.partTypeId) ){
        e.flags = e.flags - (e.flags & self.partTypeId);
      }
      else{
        //simple revert code
        e.flags = e.flags | self.partTypeId;
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
void() map_no_shoot={
 
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.touch = map_noshoot_touch;
  self.use = map_noshoot_use;
  self.isActive = TRUE;
  
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

  //default wait
  if( (self.spawnflags & 4) ){
    if( !self.wait ){
      self.wait = 10;
    }
  }
  
  //START_OFF
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
};