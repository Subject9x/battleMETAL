/*
battleMETAL
Author: Peter Roohr
Date: 11/27/2018
Overview: 
  A map object that modifies unit flags, controlling whether and for how long a unit
  has the given flags.
  
  this is very powerful and mostly only used for FL_NOSHOOT
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
    
    e = findchainflags(flags, FL_CLIENT);
    while( e ){
      if( (e.flags & self.partTypeId) ){
        e.flags = e.flags - (e.flags & self.partTypeId);
      }
      else{
        //simple revert code
        e.flags = e.flags | self.partTypeId;
      }
      if( (e.flags & FL_CLIENT) ){
        if(e.clientData != world ){
          e.clientData.SendFlags = e.clientData.SendFlags | SENDFLAG_EFLAGS;
        }
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
    if( (self.spawnflags & 8) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
      return;
    }
  }
};

/*QUAKED map_no_shoot (0.431 0.788 0.753) (-10 -10 -10) (10 10 10) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE
A map object that modifies unit flags, controlling whether and for how long a unit has the given flags.
this is very powerful and mostly only used for FL_NOSHOOT 32768

-------- KEYS -------- 
.comp_id = <float> [flags]  flags you want modified
.damageType = <float> [flags] 1 - Affect FL_CLIENT ONLY
.delay = <float> delayed start

-------- SPAWNFLAGS --------
START_OFF 1: only activated by trigger
LIFETIME 2: 
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
*/
void() map_no_shoot={
 
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.touch = map_noshoot_touch;
  self.use = map_noshoot_use;
  self.isActive = TRUE;
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
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