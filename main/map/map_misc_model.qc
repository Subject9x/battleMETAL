/*
battleMETAL
Author: Peter Roohr
Date: 1/16/2018
mod: 11/17/2018
Overview:
  Various 'misc model' entities, each unique for readability.
  
Line 20 - MAP_TERRAIN_MODEL
*/

/*QUAKED map_terrain_model (1 .5 .25) (-16 -16 -16) (16 16 16)
  this is for injecting large 3D terrain meshes into a bsp file.
  If a level needs large outdoor terrain pieces, but this right after worldspawn.
  It's origin is set to the world's, SOLID_BSP, MOVETYPE_NONE.
  It's non-damageable, and should never be removed unless there's an express purpose for doing so
    
Inputs
  .model = <string> [file] - path to the model file
  .count1 = <float> [alpha] - 0.001 - 1.0; defaults to '1'
  .c_ofs = <vector> [Red Green Blue] - color definition 0.0 - 1.0 for each color
  .spawnflags = <float> [flag] 2 - override alpha - ignores default
  .spawnflags = <float> [flag] 4 - activate EF_NOSHADOW on model
*/
void() map_terrain_model={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.takedamage = DAMAGE_NO;
  
  self.alpha = TRUE;
  if( (self.spawnflags & 2) ){
    //override alpha 
    self.alpha = self.count1;
  }
  
  precache_model2(self.model);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.solid = SOLID_BSP;
  
  if( (self.spawnflags & 4) ){
    self.effects = EF_NOSHADOW;  
  }
};


/*
  
*/
void() map_misc_model_static={

};

void() map_misc_model_solid_die={

  trigger_event( activator, trigOnDeath );

  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

/*QUAKED map_misc_model_solid 
  misc model with SOLID_BSP.
    
Inputs
  .model = <string> [file] - path to the model file
  .count1 = <float> [alpha] - 0.001 - 1.0; defaults to '1'
  .c_ofs = <vector> [Red Green Blue] - color definition 0.0 - 1.0 for each color
  .takedamage = <float> [enum] - allows for taking damage, defaul is 0
                                1 = yes but bounce projectiles
                                2 = yes, and trigger projectiles hits
  .trigOnDeath = <string> [ent] - map object to fire when killed
  .max_health = <float> [starting health] - starting health of the model
  .spawnflags = <float> [flag] 1 - 
  .spawnflags = <float> [flag] 2 - override alpha - ignores default
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - remove on first touch
  .spawnflags = <float> [flag] 32 - activate on-touch
  
*/
void() map_misc_model_solid={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.takedamage = DAMAGE_NO;
  self.alpha = TRUE;
  if( (self.spawnflags & 2) ){
    //override alpha 
    self.alpha = self.count1;
  }
  
  precache_model(self.model);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
};

/*
  A model on the map that is destructible
*/
void() map_misc_model_break={

};