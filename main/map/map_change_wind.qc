/*
battleMETAL
Author: Peter Roohr
Date: 11/15/2018
Overview: 
  Every map can have a wind direction and velocity that affects VFX like sparks and smoke.
  This map object is to allow the map to alter this value.
  This is NEVER a touchable map object!
*/

void() map_change_wind_new;

void() map_change_wind_revert={
  self.isActive = FALSE;
  //revert to original
  if( (self.spawnflags & 16) )
    WeatherDominator.wind = self.compAltOffset;
  
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
  //cache old wind values
  if( (self.spawnflags & 16) )
    self.compAltOffset = WeatherDominator.wind;
  

  WeatherDominator.wind = self.wind;
  
  self.think = map_change_wind_revert;
  self.nextthink = time + 0.1;
  //wind change lasts for data_lifetime amount of time
  if( (self.spawnflags & 2) )
    self.nextthink = time + self.data_lifetime;
}

void() map_change_wind_use={
  if( (self.spawnflags & 1) ){
    if( !self.isActive )
      self.isActive = TRUE;
  }
  
  if( (self.spawnflags & 4) ){
    //prevents infinite re-triggering if in cooldown
    if( time < self.nextthink )
      return;
  }
  
  if( !self.isActive ){
    self.isActive = TRUE;
    self.think = map_change_wind_new;
    self.nextthink = time + 0.01;
  }
};

/*QUAKED map_change_wind (0.431 0.788 0.753) (-12 -12 -12) (12 12 12) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE RESTORE_WORLDVAL
Every map can have a wind direction and velocity that affects VFX like sparks and smoke.
This map object is to allow the map to alter this value.
This is NEVER a touchable map object!

world.v_angle = win direction
world.m_fspeed = wind speed  
-------- KEYS -------- 
.wind = <vector> [wind direction] - the 3d direction of the new wind, Z = 'force'
.data_lifetime = <float> - time to live, use with spawnflags[2]
.wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]

-------- SPAWNFLAGS -------- 
START_OFF 1: START_OFF - only activated by trigger
LIFETIME 2: lifetime
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
RESTORE_WORLDVAL 16: restore original wind values
*/
void() map_change_wind={
  local vector tempMin;
  local vector tempMax;
  
  tempMin = VEC_ORIGIN;
  tempMax = VEC_ORIGIN;
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  
  self.compAltOffset = '0 0 0';
  self.use = map_change_wind_use;
  self.isActive = TRUE;
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
  
  self.think = map_change_wind_new;
  self.nextthink = time + 0.01;
};