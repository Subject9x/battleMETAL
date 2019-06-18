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
  root spawn function
*/
void() scenery_obj={
  self.classname = "scenery";
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.model = precache_model(self.model);
  setmodel( self, self.model );
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
};


void() doodad_rocks_desert_small_1={
  self.model = "q3mdl/map/rocks/rock1t.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
};
void() doodad_rocks_desert_small_2={
  self.model = "q3mdl/map/rocks/rock2.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
};
void() doodad_rocks_desert_small_3={
  self.model = "q3mdl/map/rocks/rock3.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
};

void() doodad_rocks_desert_small_random={
  local float diceRoll;
  diceRoll = ceil(random() * 3);
  switch( diceRoll ){
    default:
      doodad_rocks_desert_small_1();
      return;
    case 2:
      doodad_rocks_desert_small_2();
      return;
    case 3:
      doodad_rocks_desert_small_3();
      return;
    
  }
};

void() doodad_urban_barrier_small={
  self.model = "q3mdl/map/urban/barrier.obj";
  if( (self.spawnflags & 1)) {
    self.angles_x = self.angles_x + (5 + (crandom() * 5) );
    self.angles_y = self.angles_y + (25 + (crandom() * 180) );
    self.angles_z = self.angles_z + (5 + (crandom() * 5) );
  }
  scenery_obj();
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