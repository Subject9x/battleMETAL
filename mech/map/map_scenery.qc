/*
battleMETAL
Author: Peter Roohr
Date: 3/23/2018
Overview: 
  these map ents are for scenery

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
  setmodel( self, self.model );
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
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