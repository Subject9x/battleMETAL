/*
battleMETAL
Author: Peter Roohr
Date: 06/25/2019
Overview: 
  Particle Cube System.
    The Why - stock Darkplaces ParticleCube() system is fantastic for small areas. The default functionality
    applies the amount of particulate over the prescribed area. However, after testing this with the scale of
    map that battleMETAL is using, this becomes unusable. The particlecube() chugs due to the size of the map, 
    and if the particulate count is too low (to avoid the chug) then it isn't visible - because its spread out
    across too-wide of an area.
    
    The What - So, this is how particle cubes got an update.
    Rain/Snow/Dust only matters to CLIENTs, therefore, lets just slap a particlecube on the Client and have it 
    loosely follow the player.
  
    We also need the effect of moving 'through' the particulate, so the cube's origin doesn't need to be updated
    every frame of client movement.
  
  void(vector mincorner, vector maxcorner, vector vel, float howmany, float color, float gravityflag, float randomveljitter) te_particlecube
  void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlerain
  void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow  
  
Inputs
  .data_idx = <float> [type] - type of particle effect 
    1 = particlecube
    2 = te_particlerain
    3 = te_particlesnow
  
  .mins = <vector> - cube minimum bounds
  .maxs = <vector> - cube maximum bounds - set these if you want a specific cube size, otherwise, go off brush size
  .velocity = <vector> - velocity of the particles: -Z is downward, +Z can be used for upward flowing particles.
  .count = <float> - how many particles.
  .count1 = <float> - color, in 8bit (why?)
  .jump_flag = <float> - gravityflag for te_particlecube.
  .count2 = <float> - velocity jitter for te_particlecube;
  .count3 = <float> - use with LIFETIME spawnflag.
  .sound = <string> - name of sound to play- TODO - implement
  
 1 START_OFF = Requires targetname and a trigger call.
 2 LIFETIME = Func is turned off after .data_lifetime game seconds.
 4 DELAY = wait .delay game seconds after being activated to begin.
 8 INTERVAL = fluctuate between on-and-off.
 16 USE_WIND = rain will be affected by map's WIND values.
 32 VARIABLE_COUNT = .count will be subject to slight randomization.
 64 REMOVE = remove on touch
*/


void() map_particlecube_effect_touch={
  local entity newCube;
  local entity trigger;
  
  if( !(other.flags & FL_CLIENT) ){
    return;
  }
  
  trigger = self;
  
  if( other.particleCube == self ){
    return;
  }
  //any-given client can only have 1 particle cube effect active on them at any time.
  other.particleCube = self;
  client_sendParticleCube(other, trigger);
  
  if( (self.spawnflags & 64) ){
    self.solid = SOLID_NOT;
    other.particleCube = world;
    remove(self);
    return;
  }
};

/*QUAKED (.9 .9 .9) (-32 -32 -16) (32 32 16)
This is to turn the effect on/off/update.
*/
void() map_particlecube_effect={
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  setsize( self, '-32 -32 -16', '32 32 16' );
  setorigin( self, self.origin);
  
  if( !(self.spawnflags & 2) ){
    self.count3 = 999999999;  //worked for iD, right?
  }
  
  self.effects = self.effects | EF_NODRAW;
  self.touch = map_particlecube_effect_touch;
};