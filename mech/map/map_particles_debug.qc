/*
battleMETAL
Author: Peter Roohr
Date: 11/16/2018
Overview: 
  Debugger for particle effects
  
Inputs
  .vec_name = <string> [effecinfo.txt name] - the particle effect to spawn
  .c_ofs = <vector> [endpoint] - if effect needs an endpoint, the origin of effect is the map object's origin
  .dest1 = <vector> [speed] -if effect needs a velocity vector
  .count = <float> [particle amount] - total number of particles in the effect
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .state_1 = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .count2 = <float> - speed, rate of particle cycle
  .count3 = <bool> - 0 = pointparticle, 1 = trailparticle
  .count4 = <float> - velocity multiplier
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - restore original wind values
*/

//TE_SMOKE_TEST
void() debug_smoke={
  te_smoke_test(self.origin, self.count);
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
    trailparticles( self, particleeffectnum(self.vec_name), self.origin + (v_up * self.c_ofs_y) + (v_forward * self.c_ofs_z) + (v_right * self.c_ofs_x), pvel , self.count);
  }
  else{
    pointparticles( particleeffectnum(self.vec_name), self.origin, pvel, self.count);
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
  setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, VEC_ORIGIN, VEC_ORIGIN );
  setorigin( self, self.origin );
  
  self.effects = self.effects | EF_NODRAW;
  self.use = map_particle_use;
  self.think = map_particle_debug_th;
  self.nextthink = time + self.count2;
};

void() debug_particles={

  map_particle_ini();

};