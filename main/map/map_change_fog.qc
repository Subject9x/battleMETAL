/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  A Map Wrapper for the fog cvar. Allows a map to take control of the fog setting in a controllabe way. 
  This allows for fog transitions between parts of the map enabling better execution of game atmosphere.
*/

void() map_changefog_touch={
  
  if( (other.flags & FL_CLIENT) ){
    activator = other;
    self.use();
  }
  else if( (other.flags & FL_MONSTER) ){
   other.fog_density = self.fog_density;
   other.fog_alpha = self.fog_alpha;
   other.fog_dist = self.fog_dist;
   other.fade = self.fade;
  }
};

void() map_changefog_use={
  if( (activator.flags & FL_CLIENT) ){
    
    client_sendFog(other, FALSE, self.fog_density, self.fog_color, self.fog_alpha, self.fog_dist, self.fade);
    other.fog_alpha = self.fog_alpha;
    
    if( (self.spawnflags & 1) ){
      self.think = SUB_Remove;
      self.nextthink = 0.01;
    }
  }
};

/*QUAKED map_change_fog (0.431 0.788 0.753) (-16 -16 -32) (16 16 32) REMOVE_ONTOUCH
A Map Wrapper for the fog cvar. Allows a map to take control of the fog setting in a controllabe way. 
This allows for fog transitions between parts of the map enabling better execution of game atmosphere.
  
fog cvar
  density red green blue alpha mindist maxdist top fadedepth
  
-------- KEYS -------- 
.fog_density = <float> [density] - new fog thickness
.fog_color = <vector> [red, green, blue] - new color to transition to
.fog_alpha = <float> [alpha] - new alpha value
.fog_dist = <vector> [dist min, dist max, height] - new fog distance
.fade = <float> [fade depth] - transition time
    
-------- SPAWNFLAGS -------- 
REMOVE_ONTOUCH 1: remove on first touch
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
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  setsize(self, '-16 -16 -32', '16 16 32');
  setorigin(self, self.origin);
};