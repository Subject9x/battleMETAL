/*
battleMETAL
Author: Peter Roohr
Date: 11/17/20200
Overview: 
  modelindex appears to be unreliable, and why bind the client and server so tightly?
  
*/

void() model_misc_building_set={

  local string modelPath;
  
  switch( self.data_idx ){
    default:
      //building_misc_apartment
      modelPath = "q3mdl/buildings/misc/misc_apt_sm.obj";
      break;
    case 2:
      //building_misc_factory_med
      modelPath = "q3mdl/buildings/misc/misc_fact_med.obj";
      break;
    case 3:
      //building_misc_lodge
      modelPath = "q3mdl/buildings/misc/misc_lodge.obj";
      break;
    case 4:
      //building_misc_off_pyra
      modelPath = "q3mdl/buildings/misc/misc_off_pyramid.obj";
      break;
    case 5:
      //building_misc_off_large
      modelPath = "q3mdl/buildings/misc/misc_off_large.obj";
      break;
    case 6:
      //building_misc_off_small
      modelPath = "q3mdl/buildings/misc/misc_off_sm.obj";
      break;
    case 7:
      //building_misc_fact_steam
      modelPath = "q3mdl/buildings/misc/misc_fact_steam.obj";
      break;
    case 8:
      //building_misc_apt_larg
      modelPath = "q3mdl/buildings/misc/misc_apt_larg.obj";
      break;
  }
  
  setmodel(self, modelPath);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
};


void() model_misc_building_ruins_set={
  switch(self.vec_size){
      case 2:
        setmodel( self, "q3mdl/map/ruins/ruin_medium.obj");
        break;
      case 3:
        setmodel( self, "q3mdl/map/ruins/ruin_large.obj");
        break;
      default:
        setmodel( self, "q3mdl/map/ruins/ruin_small.obj");
        break;
    }
    setsize( self, self.mins, self.maxs );
    setorigin(self, self.origin);
};