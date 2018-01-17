/*
mech Mod
Author: Peter Roohr
Date: 1/16/2018
Overview: mimicking Quake 3 map functionality
*/

/*QUAKED misc_model (1 0 1) (-16 -16 -24) (16 16 32)
model : <filename> - model to load
count : number, first frame
delay : number, frame display time
solid : 
  SOLID_NOT				= 0;	// no interaction with other objects
  SOLID_TRIGGER			= 1;	// touch on edge, but not blocking
  SOLID_BBOX				= 2;	// touch on edge, block
  SOLID_SLIDEBOX			= 3;	// touch on edge, but not an onground
  SOLID_BSP				= 4;	// bsp clip, touch on edge, block
scale : float, starting size. default is 1.0
*/
void() misc_model={
  self.movetype = MOVETYPE_NONE;
  self.velocity = '0 0 0';
  precache_model(self.model);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  self.scale = self.scale;
};

/*QUAKED map_terrain_model (1 0 1) (-16 -16 -24) (16 16 32)
model : <filename> - model to load
cnt : number, first frame
solid : is defaulted to SOLID_BSP by engine
scale : float, starting size. default is 1.0
*/
void() map_terrain_model={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  precache_model(self.model);
  setmodel(self, self.model);
  self.takedamage = DAMAGE_NO;
  setsize(self, self.mins, self.maxs);
  dprint(strcat(self.model, " \n")); //DEBUG
  self.nextthink = time + 0.5;
  self.think = SUB_Null;
};