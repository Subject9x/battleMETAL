/*
battleMETAL
Author: Peter Roohr
Date: 1/16/2018
mod: 11/17/2018
Overview:
  Various 'misc model' entities, each unique for readability.
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