/*
battleMETAL
Author: Peter Roohr
Date: 11/16/2018
Overview: 
  Debugger for particle effects
  
Inputs
  .data_idx = <float> [particle id] - the particle effect to spawn
  .c_ofs = <vector> [endpoint] - if effect needs an endpoint, the origin of effect is the map object's origin
  .v_angle = <vector> [speed] -if effect needs a velocity vector
  .count = <float> [particle amount] - total number of particles in the effect
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .state_1 = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - restore original wind values
*/

//TE_SMOKE_TEST
void() debug_smoke={
  local vector dir;
  dir = (WINDDIR + self.v_angle) * WINDSPEED;
  te_smoke_test(self.origin, dir, self.count);
};

/*
  all of these share the same harness functions
*/
void() map_particle_use={
  
};

void() map_particle_debug_th={

  self.unit_ini();

  //lifetime
  
  //reactivate
  
  self.think = map_particle_debug_th;
  self.nextthink = time + 0.1;
};

/*
  parent 'constructor' to inherit
*/
void( void() partiFunc ) map_particle_ini={

  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, VEC_ORIGIN, VEC_ORIGIN );
  setorigin( self, self.origin );
  
  self.effects = self.effects | EF_NODRAW;
  self.use = map_particle_use;
  self.unit_ini = partiFunc;
  self.think = map_particle_debug_th;
  self.nextthink = time + 0.1;
};




/*QUAKED pdebug_smoke (0.25 0.25 0.25)

*/
void() debug_particles_smoke={

  map_particle_ini( debug_smoke );

};