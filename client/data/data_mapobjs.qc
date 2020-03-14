/*
battleMETAL
Author: Peter Roohr
Date: 03/13/2020
Overview: 
  CSQC-side ini function for synced map objects    
    + objective entities.
    + nav points.
    + deploy points.
    + hazard zones.
    
*/

void( float isNew, float entFlags ) sendent_handle_map={

  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.data_type = ReadByte();
  self.data_idx = ReadByte();
  
  switch( self.data_type ){
    case DATA_NAVP:
      
      break;
    case DATA_OBJT:
    
      break;
    case DATA_DEPL:
      data_deploy( isNew, entFlags );
      break;
    case DATA_MAP_OBJ:
      data_objective( isNew, entFlags );
      break;
  }
};

void( float isNew, float entFlags ) data_nav_point={
};

void( float isNew, float entFlags ) data_objective={
  self.faction = ReadByte();
  self.isActive = ReadByte();

};

void( float isNew, float entFlags ) data_deploy={
  self.faction = ReadByte();
  self.isActive = ReadByte();
  
  DEPLOY_POINTS_ACTIVE[self.data_idx] = self.isActive;
  DEPLOY_POINTS_ORG[self.data_idx] = self.origin;
  
  if( cvar("developer") ){
    self.alpha = 0.9;
    self.scale = 1;
  }
  else{
    self.alpha = 0.01;
    self.scale = 0.01;
  }
  
  setmodel(self, "q3mdl/testball.md3");
  setorigin(self, self.origin);
  
  self.drawmask = MASK_ENGINE;

};

void( float isNew, float entFlags ) data_map_object={

};
