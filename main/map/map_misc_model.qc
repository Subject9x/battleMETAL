/*
battleMETAL
Author: Peter Roohr
Date: 1/16/2018
mod: 11/17/2018
Overview:
  Various 'misc model' entities, each unique for readability.
  
Line 20 - MAP_TERRAIN_MODEL
*/

float( float isNew, float changeFlags) terrain_model_send={

  WriteByte( MSG_ENTITY, SENDTYPE_TERRAIN );
  WriteByte( MSG_ENTITY, changeFlags );

  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteShort( MSG_ENTITY, self.modelindex );
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }

  return TRUE;
};

/*QUAKED map_terrain_model (0.75 0.2 0.75) (-24 -24 -24) (24 24 24) - OVERRIDE_ALPHA EF_NOSHADOW
  this is for injecting large 3D terrain meshes into a bsp file.
  If a level needs large outdoor terrain pieces, but this right after worldspawn.
  It's origin is set to the world's, SOLID_BSP, MOVETYPE_NONE.
  It's non-damageable, and should never be removed unless there's an express purpose for doing so

-------- KEYS --------
.model = <string> [file] - path to the model file
.count1 = <float> [alpha] - 0.001 - 1.0; defaults to '1'
.compOffset = <vector> [Red Green Blue] - color definition 0.0 - 1.0 for each color

-------- SPAWNFLAGS --------
OVERRIDE_ALPHA 2: overrides default alpha of '1'
EF_NOSHADOW 4: puts effect-flag EF_NOSHADOW onto model
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
  //self.SendEntity = terrain_model_send;
  //self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};


/*
  
*/
void() map_mismodelPath_static={

};

void() map_mismodelPath_solid_die={

  trigger_event( activator, self.trigOnDeath );

  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

/*QUAKED map_mismodelPath_solid 
  misc model with SOLID_BSP.
    
Inputs
  .model = <string> [file] - path to the model file
  .count1 = <float> [alpha] - 0.001 - 1.0; defaults to '1'
  .compOffset = <vector> [Red Green Blue] - color definition 0.0 - 1.0 for each color
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
void() map_mismodelPath_solid={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.takedamage = DAMAGE_NO;
  self.alpha = TRUE;
  
  //override alpha 
  if( (self.spawnflags & 2) )
    self.alpha = self.count1;
  
  precache_model(self.model);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
};


void() doodad_static_mech_use={
  self.use = SUB_Null;
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};


//generic ini
void() doodad_static_mech={
  if(!self.data_idx){
    self.data_idx = 1;
  }
  
  self.skin = self.faction - 1;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  if( self.targetname && (self.spawnflags & 1) ){
    self.use = doodad_static_mech_use;
  }
};

/*QUAKED doodad_mech_static_balaket (0 0.25 1) (-18 -18 -35) (18 18 16) TRIGGER_REMOVE
  { model("models/mechs/balaket/balaket.md3"); }
  misc. mech models used for decoration.
  these are static models, with no collision, no AI.
  they dont get any weapons, and aren't animated.
  
  DEFAULT - a PSC 
-------- KEYS -------- 
 .faction = <float> faction id to set skin type.

-------- SPAWNFLAGS -------- 
TRIGGER_REMOVE 1: remove this when given a targetname
*/
void() doodad_mech_static_balaket={
  self.data_idx = 1;
  if(!self.faction){
    self.faction = 1;
  }
  precache_model("models/mechs/balaket/balaket.md3");
  setmodel(self, "models/mechs/balaket/balaket.md3");
  setsize(self, '-18 -18 -35', '18 18 16');
  setorigin(self, self.origin);
  doodad_static_mech();
};

/*QUAKED doodad_mech_static_matok (0 0.25 1) (-18 -18 -40) (18 18 22) TRIGGER_REMOVE
  { model("models/mechs/matok/matok.md3"); }
  misc. mech models used for decoration.
  these are static models, with no collision, no AI.
  they dont get any weapons, and aren't animated.
  
  DEFAULT - a PSC 
-------- KEYS -------- 
 .faction = <float> faction id to set skin type.

-------- SPAWNFLAGS -------- 
TRIGGER_REMOVE 1: remove this when given a targetname
*/
void() doodad_mech_static_matok={
  self.data_idx = 2;
  if(!self.faction){
    self.faction = 1;
  }
  precache_model("models/mechs/matok/matok.md3");
  setmodel(self, "models/mechs/matok/matok.md3");
  setsize(self, '-18 -18 -40', '18 18 22');
  setorigin(self, self.origin);
  
  doodad_static_mech();
};

/*QUAKED doodad_mech_static_monitor (0 0.25 1) (-22 -22 -44) (22 22 24) TRIGGER_REMOVE
  { model("models/mechs/monitor/monitor.md3"); }
  misc. mech models used for decoration.
  these are static models, with no collision, no AI.
  they dont get any weapons, and aren't animated.
  
  DEFAULT - a PSC 
-------- KEYS -------- 
 .faction = <float> faction id to set skin type.

-------- SPAWNFLAGS -------- 
TRIGGER_REMOVE 1: remove this when given a targetname
*/
void() doodad_mech_static_monitor={
  self.data_idx = 3;
  if(!self.faction){
    self.faction = 1;
  }
  precache_model("models/mechs/monitor/monitor.md3");
  setmodel(self, "models/mechs/monitor/monitor.md3");
  setsize(self, '-22 -22 -44', '22 22 24');
  setorigin(self, self.origin);
  doodad_static_mech();
};

/*
  A model on the map that is destructible
*/
void() map_mismodelPath_break={

};