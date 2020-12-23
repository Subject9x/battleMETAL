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

float( float isNew, float changeFlags ) send_scenery={
  local float newFlags;
  
  newFlags = changeFlags;
  if( isNew ){
    newFlags = newFlags | (SENDFLAG_MOVE | SENDFLAG_ANGLE);
  }
  
  WriteByte( MSG_ENTITY, SENDTYPE_MISC );
  WriteCoord( MSG_ENTITY, newFlags );
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
  
  if( (newFlags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.modelindex );
  }

  return TRUE;
};

/*
  root spawn function
*/
void() scenery_obj={
  self.classname = "scenery";
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BBOX;
  self.model = precache_model(self.model);
  setmodel( self, self.model );
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
  if( (self.spawnflags & 16) ){
    droptofloor();
  }
  self.effects = self.effects | EF_LOWPRECISION;
};

void() doodad_rocks_desert_1={
  self.model = "q3mdl/map/rocks/rock1t.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin + (v_up * -24));
  self.SendEntity = send_scenery;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};
void() doodad_rocks_desert_2={
  self.model = "q3mdl/map/rocks/rock2.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin + (v_up * -24));
  self.SendEntity = send_scenery;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};
void() doodad_rocks_desert_3={
  self.model = "q3mdl/map/rocks/rock3.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
  makevectors(self.angles);
  setorigin( self, self.origin + (v_up * -12));
  self.SendEntity = send_scenery;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};

void() doodad_rocks_desert_random={
  switch(  ceil(random() * 3) ){
    default:
      doodad_rocks_desert_1();
      return;
    case 2:
      doodad_rocks_desert_2();
      return;
    case 3:
      doodad_rocks_desert_3();
      return;
  }
};

void() doodad_ruins_urban_small={
  self.model = "q3mdl/map/ruins/ruin_small.obj";
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
  self.model = "q3mdl/map/ruins/ruin_medium.obj";
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
  self.model = "q3mdl/map/ruins/ruin_large.obj";
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
  self.model = "q3mdl/map/walls/wall_small.obj";
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
      self.model = "q3mdl/map/rocks/col/rock_col11.obj";
      break;
    case 2:
      self.model = "q3mdl/map/rocks/col/rock_col12.obj";
      break;
    case 3:
      self.model = "q3mdl/map/rocks/col/rock_col13.obj";
      break;
    default:
      self.model = "q3mdl/map/rocks/col/rock_col1.obj";
      break;
  }

  if( (self.spawnflags & 2) ){
    rando = anglemod(random() * 360);
    self.angles_y = rando;
  }
  self.angles_z = self.angles_z + 90; //corrects from noesis export
  scenery_obj();
};