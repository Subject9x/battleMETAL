/*
battleMETAL
Author: Peter Roohr
Date: 11/15/2018
Overview: 
  Every map can have a wind direction and velocity that affects VFX like sparks and smoke.
  This map object is to allow the map to alter this value.
  This is NEVER a touchable map object!
  
  world.v_angle = win direction
  world.data_speed_forward = wind speed
  
Inputs
  .c_ofs = <vector> [wind direction] - the 3d direction of the new wind
  .p_velocity = <float> [wind speed] - speed of wind in given direction
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - restore original wind values
*/

void() map_change_wind_new;

void() map_change_wind_revert={
  self.isActive = FALSE;
  if( (self.spawnflags & 16) ){
    //revert to original
    WINDDIR = self.c_alt_ofs;
  }
  
  if( (self.spawnflags & 8) ){
    //we're done here.
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
  }
  
  if( (self.spawnflags & 4) ){
    //reactivate effect after cooldown.
    self.think = map_change_wind_new;
    self.nextthink = time + self.wait;
  }
}

void() map_change_wind_new={
  if( (self.spawnflags & 16) ){
    //cache old wind values
    self.c_alt_ofs = WINDDIR;
  }

  WINDDIR = self.c_ofs;
  
  self.think = map_change_wind_revert;
  self.nextthink = time + 0.1;
  if( (self.spawnflags & 2) ){
    //wind change lasts for p_lifetime amount of time
    self.nextthink = time + self.p_lifetime;
  }
}

void() map_change_wind_use={
  if( (self.spawnflags & 1) ){
    if( !self.isActive ){
      self.isActive = TRUE;
    }
  }
  
  if( (self.spawnflags & 4) ){
    //prevents infinite re-triggering if in cooldown
    if( time < self.nextthink ){
      return;
    }
  }
  
  if( !self.isActive ){
    self.isActive = TRUE;
    self.think = map_change_wind_new;
    self.nextthink = time + 0.01;
  }
};

/*QUAKED map_change_wind
*/
void() map_change_wind={
  local vector tempMin;
  local vector tempMax;
  
  tempMin = VEC_ORIGIN;
  tempMax = VEC_ORIGIN;
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  
  self.data_speed_forward = 0;
  self.c_alt_ofs = '0 0 0';
  self.use = map_change_wind_use;
  self.isActive = TRUE;
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
  
  self.think = map_change_wind_new;
  self.nextthink = time + 0.01;
};