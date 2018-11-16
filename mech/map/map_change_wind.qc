/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  Every map can have a wind direction and velocity that affects VFX like sparks and smoke.
  This map object is to allow the map to alter this value.
  This is NEVER a touchable map object!
  
  world.v_angle = win direction
  world.m_fspeed = wind speed
  
Inputs
  .c_alt_ofs = <vector> [wind direction] - the 3d direction of the new wind
  .p_velocity = <float> [wind speed] - speed of wind in given direction
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .state_1 = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - restore original wind values
*/


void() map_change_wind_new={

}

void() map_change_wind_revert={

}

void() map_change_wind_think={
  

};

void() map_change_wind_use={  
  
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
  setmodel( self, "q3mdl/testball.md3" );
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  
};