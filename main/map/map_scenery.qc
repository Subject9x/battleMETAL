/*
battleMETAL
Author: Peter Roohr
Date: 3/23/2018
Overview: 
  Entire file contains all necessary code for doodads.
  Doodads are mostly non-interactive bits of scenery like rocks and wreckage.

  spawnflag[1] = random choice of model
  spawnflag[2] = random yaw 
*/

/*
  5.0.0 - deprecated.
  Miscellaneous scenery actually doesn't need to be auomatically sent to the 
  client. Its better to leverage the server-side PVS culling than try to use
  my own poor stand-in on the client.
float( float isNew, float changeFlags ) send_scenery={
  local float newFlags;
  
  newFlags = changeFlags;
  if( isNew ){
    newFlags = newFlags | (SENDFLAG_MOVE | SENDFLAG_ANGLE);
  }
  
  WriteByte( MSG_ENTITY, SENDTYPE_MISC );
  WriteLong( MSG_ENTITY, newFlags );
  //======================================
  
  if( (newFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  if( (newFlags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (newFlags & SENDFLAG_DEAD) ){
    //dead event.
  }
  
  if( (newFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.skin );
    WriteShort( MSG_ENTITY, rint(self.modelindex) );
  }

  return TRUE;
};

*/
/*
  root spawn function
*/
void() scenery_obj={
  self.classname = "scenery";
  self.solid = SOLID_NOT;
  self.model = precache_model(self.model);
  setmodel( self, self.model );
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
  if( (self.spawnflags & 16) ){
    droptofloor();
  }
  self.effects = self.effects | EF_LOWPRECISION;
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
};

void() DoodadRockDie={
  local vector shoot;
  
  self.solid = SOLID_NOT;
  self.takedamage = DAMAGE_NO;
  //TODO - rock death effect.
  //self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.deadflag = DEAD_DEAD;
  
  shoot = self.origin + [0, 0, self.maxs_z/2];
  
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( shoot, 5, '1 0.85 0.33', 0.000025 );
  sound(self, CHAN_AUTO, "sound/fx_boom.ogg", ATTN_NORM, 1.0);
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

void() doodad_rocks_1={
  self.model = "models/map/rocks/rock1t.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
//self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
  self.takedamage = DAMAGE_AIM;
  if(!self.health){
    self.health = self.max_health = 250;
  }
  self.max_health = self.health;
  self.th_die = DoodadRockDie;
};
void() doodad_rocks_2={
  self.model = "models/map/rocks/rock2.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  //self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
  self.takedamage = DAMAGE_AIM;
  if(!self.health){
    self.health = self.max_health = 250;
  }
  self.max_health = self.health;
  self.th_die = DoodadRockDie;
};
void() doodad_rocks_3={
  self.model = "models/map/rocks/rock3.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  //self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
  self.takedamage = DAMAGE_AIM;
  if(!self.health){
    self.health = self.max_health = 250;
  }
  self.max_health = self.health;
  self.th_die = DoodadRockDie;
};

void() doodad_rocks_random={
  switch(  max(1, rint(random() * 3) )){
    default:
      doodad_rocks_1();
      return;
    case 2:
      doodad_rocks_2();
      return;
    case 3:
      doodad_rocks_3();
      return;
  }
};


void() doodad_rocks_column_1={
  self.model = "models/map/rocks/rockcol1.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin);
  //self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
};
void() doodad_rocks_column_2={
  self.model = "models/map/rocks/rockcol2.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin);
  //self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
};
void() doodad_rocks_column_3={
  self.model = "models/map/rocks/rockcol3.md3";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (1 + (crandom() * 1) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (1 + (crandom() * 1) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin );
  //self.SendEntity = send_scenery;
  //self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
};

void() doodad_rocks_col_random={
  switch(  ceil(random() * 3) ){
    default:
      doodad_rocks_column_1();
      return;
    case 2:
      doodad_rocks_column_2();
      return;
    case 3:
      doodad_rocks_column_3();
      return;
  }
};


void() doodad_ruins_urban_small={
  self.model = "models/map/ruins/ruin_small.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (1 + (crandom() * 3) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (1 + (crandom() * 3) );
  }
  scenery_obj();
  self.solid = SOLID_NOT;
  makevectors(self.angles);
  setorigin( self, self.origin);
};
void() doodad_ruins_urban_medium={
  self.model = "models/map/ruins/ruin_medium.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (1 + (crandom() * 3) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (1 + (crandom() * 3) );
  }
  scenery_obj();
  self.solid = SOLID_NOT;
  makevectors(self.angles);
  setorigin( self, self.origin);
};
void() doodad_ruins_urban_large={
  self.model = "models/map/ruins/ruin_large.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (1 + (crandom() * 3) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (1 + (crandom() * 3) );
  }
  scenery_obj();
  self.solid = SOLID_NOT;
  makevectors(self.angles);
  setorigin( self, self.origin );
};



void() doodad_urban_barrier_small_touch={
  local vector crunchVel;
  
  if( (other.flags & FL_CLIENT) || (other.flags & FL_MONSTER) ){
    self.angles_x = anglemod( self.angles_x - 180 );
    //TODO - crunch sound
    makevectors(other.angles);
    crunchVel = other.origin + v_forward * 2;
    crunchVel = normalize( crunchVel - other.origin);
    te_debris( self.origin + '0 0 6', other.angles, crunchVel, 5 + (random() * 10) , 1);
    self.solid = SOLID_NOT;
    self.touch = SUB_Null;
  }
};

void() doodad_urban_barrier_small={
  self.model = "models/map/walls/wall_small.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  
  if( (self.spawnflags & 2) ){
    self.touch = doodad_urban_barrier_small_touch;
  }
  else{
    //hint that object is not destructible
    self.color = '0.87 0.87 0.87';
  }
};

/*

  data_idx = type
*/
void() scenery_rock_column={
  local float rando;
  
  if( (self.spawnflags & 1) ){
    rando = random() * 4;
    rando = ceil(rando);
    self.data_idx = rando;
  }
  
  switch( self.data_idx ){
    case 1:
      self.model = "models/map/rocks/col/rock_col11.obj";
      break;
    case 2:
      self.model = "models/map/rocks/col/rock_col12.obj";
      break;
    case 3:
      self.model = "models/map/rocks/col/rock_col13.obj";
      break;
    default:
      self.model = "models/map/rocks/col/rock_col1.obj";
      break;
  }

  if( (self.spawnflags & 2) ){
    rando = anglemod(random() * 360);
    self.angles_y = rando;
  }
  self.angles_z = self.angles_z + 90; //corrects from noesis export
  scenery_obj();
};