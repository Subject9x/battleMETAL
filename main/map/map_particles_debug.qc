/*
battleMETAL
Author: Peter Roohr
Date: 11/16/2018
Overview: 
  Debugger for particle effects
  
*/

//TE_SMOKE_TEST
void() debug_smoke={
  te_smoke(self.origin, self.count);
};

/*
  all of these share the same harness functions
*/
void() map_particle_use={
  
};

void() map_particle_debug_th={
  local vector vdir;
  local vector pvel;
  
  makevectors(self.angles);
  vdir = self.origin + (v_up * self.dest1_y) + (v_forward * self.dest1_z)+ (v_right * self.dest1_x);
  pvel = normalize( vdir - self.origin) * self.count4;
  if( self.count3 ){
   client_send_particle_rail( num_for_edict(self), particleeffectnum(self.vec_name), self.origin + (v_up * self.compOffset_y) + (v_forward * self.compOffset_z) + (v_right * self.compOffset_x), pvel);
  }
  else{
    client_send_particle( particleeffectnum(self.vec_name), self.origin, pvel, self.count);
  }
  
  self.think = map_particle_debug_th;
  self.nextthink = time + self.count2;
};

/*
  parent 'constructor' to inherit
*/
void() map_particle_ini={

  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  setsize( self, VEC_ORIGIN, VEC_ORIGIN );
  setorigin( self, self.origin );
  
  self.effects = self.effects | EF_NODRAW;
  self.use = map_particle_use;
  self.think = map_particle_debug_th;
  self.nextthink = time + self.count2;
};

/*QUAKED debug_particles (0.988 0.267 0.553) (-3 -3 -3) (3 3 3) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE
  Debugger for particle effects
  
-------- KEYS -------- 
  .vec_name = <string> [effecinfo.txt name] - the particle effect to spawn
  .compOffset = <vector> [endpoint] - if effect needs an endpoint, the origin of effect is the map object's origin
  .dest1 = <vector> [speed] -if effect needs a velocity vector
  .count = <float> [particle amount] - total number of particles in the effect
  .data_lifetime = <float> - time to live, use with spawnflags[2]
  .aState = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .count2 = <float> - speed, rate of particle cycle
  .count3 = <bool> - 0 = pointparticle, 1 = trailparticle
  .count4 = <float> - velocity multiplier
-------- SPAWNFLAGS -------- 
START_OFF 1: only activated by trigger
LIFETIME 2: 
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
*/
void() debug_particles={

  map_particle_ini();

};