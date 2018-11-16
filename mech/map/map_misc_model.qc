/*
mech Mod
Author: Peter Roohr
Date: 1/16/2018
Overview: mimicking Quake 3 map functionality
*/

/*QUAKED map_terrain_model (1 .5 .25) (-16 -16 -16) (16 16 16)
solid is defaulted to SOLID_BSP
Keys:
"model"
  path to model
*/
void() map_terrain_model={
  self.angles = '0 90 0';
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  self.alpha = 1;
  self.avelocity = '0 0 0';
  precache_model(self.model);
  setmodel(self, self.model);
  self.takedamage = DAMAGE_NO;
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
};



void() misc_target_listen_think={
  local entity player;
  local float hits;
  
  if( self.count2 ){
    hits = 0;
    player = nextent(world);
    while( player ){
      if( player.enemy != world ){
        if( (self.spawnflags & 1) ) {
          if( player.enemy.group == self.group ){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 2) ) {
          if( player.enemy.data_type == DATA_VEHC){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 4) ) {
          if( player.enemy.data_type == DATA_BLD){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 8) ) {
          if( player.enemy.data_type == DATA_MECH){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 16) ) {
          if( player.enemy.targetname == self.target){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 32) ) {
          if( player.enemy.i_faction == 1){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 64) ) {
          if( player.enemy.i_faction == 2){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 128) ) {
          if( player.enemy.i_faction == 3){
            hits = hits + 1;
          }
        }
        if( (self.spawnflags & 256) ) {
          if( player.enemy.i_faction == 4){
            hits = hits + 1;
          }
        }
      }
      player = nextent(player);
    }
    
    if( hits > 0 ){
      self.count2 = FALSE;
      self.count3 = time + self.delay;
    }
  }
  else{
    if( time > self.count3){
      self.count2 = TRUE;
      multi_trigger();
    }
  }
  
  self.think = misc_target_listen_think;
  self.nextthink = time + 1;
};

/*
  listens for a specific map target that the player gets
  use spawnflags to add listening types
  1 = groupid only
  2 = DATA_VEC
  4 = DATA_BLD
  8 = DATA_MECH
  16 = target name
  32 = Faction 1
  64 = Faction 2 
  128 = Faction 3
  256 = Faction 4
  512 = target 
  512 = refresh trigger after count1 countdown
  delay > 0 = timer;
*/
void() misc_target_listen={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  setsize( self, '-2 -2 -2', '2 2 2');
  setorigin( self,  self.origin);
  self.takedamage = DAMAGE_NO;
  
  self.count2 = 0;
  self.count3 = 0;
  
  self.think = misc_target_listen_think;
  self.nextthink = time + 1;

};