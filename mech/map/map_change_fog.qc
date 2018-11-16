/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  A Map Wrapper for the fog cvar. Allows a map to take control of the fog setting in a controllabe way. 
  This allows for fog transitions between parts of the map enabling better execution of game atmosphere.
  
  1 0.85 0.65 0.5 0.45 6000 10000 8000 2500
  fog cvar
    density red green blue alpha mindist maxdist top fadedepth
  
Inputs
  .fog_density = <float> [density] - new fog thickness
  .fog_color = <vector> [red, green, blue] - new color to transition to
  .fog_alpha = <float> [alpha] - new alpha value
  .fog_dist = <vector> [dist min, dist max, height] - new fog distance
  .fade = <float> [fade depth] - transition time
  spawnflag 1 - remove on first touch

Globals
  .stat_wep_state = <float> event -
      0 = do nothing
      1 = transition to new fog
*/
//controlled on each client
.float fog_density;
.vector fog_color;
.float fog_alpha;
.vector fog_dist;
.float fade;

void() map_changefog_touch={
  
  if( (other.flags & FL_CLIENT) ){
    activator = other;
    self.use();
  }
};

void() map_changefog_use={
  if( (activator.flags & FL_CLIENT) ){
    client_sendFog(other, self.fog_density, self.fog_color, self.fog_alpha, self.fog_dist, self.fade);
  
    if( (self.spawnflags & 1) ){
      self.think = SUB_Remove;
      self.nextthink = 0.001;
    }
  }
};

/*QUAKED map_changefog (1 1 1) 
*/
void() map_change_fog={
  local vector tempMin;
  local vector tempMax;
  
  tempMax = self.maxs;
  tempMin = self.mins;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.use = map_changefog_use;
  self.touch = map_changefog_touch;
  self.stat_wep_state = 1;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, tempMin, tempMax);
  setorigin(self, self.origin);
};