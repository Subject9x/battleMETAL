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

/*QUAKED misc_model (1 .5 .25) (-16 -16 -16) (16 16 16)
Place a model in the map.
If target is set it follows the path defined by the target path_corner ents.
noise and noise1 then define the noises to play during movement.
button0 & 1 dont work when target is set.
Keys:
"angle" 
 Direction in which model will be oriented.
"model"
 Path/name of model to use (eg: models/mapobjects/mymodel.md3).
"target" 
 First node to follow.
"button0"
 Startframe to play
"button1"
 Endframe to play
"noise"
 Start and movement sound (eg: sound1start.wav)
"noise1"
 Stop sound (eg: sound1stop.wav)
"noise4"
 Target name for use with the misc_rotateengine
*/
void() misc_model={
  //apparently misc_model is ONLY for Q3map2
};