/*
battleMETAL
Author: Peter Roohr
Date: 11/17/20200
Overview: 
  modelindex appears to be unreliable, and why bind the client and server so tightly?
  
*/

void() model_misc_building_set={
  
  switch( self.data_idx ){
    default:
      //building_misc_apartment
      setmodel(self, "q3mdl/buildings/misc/misc_apt_sm.obj");
      if( self.angles_y == 90 ){
        setsize(self, '-20 -36 0', '20 36 52');
      }
      else{
        setsize(self, '-36 -20 0', '36 20 52');
      }
      break;
    case 2:
      //building_misc_factory_med
      setmodel(self, "q3mdl/buildings/misc/misc_fact_med.obj");
      if( self.angles_y == 90 ){
        setsize(self, '-88 -36 0', '88 36 76');
      }
      else{
        setsize(self, '-36 -88 0', '36 88 76');
      }
      break;
    case 3:
      //building_misc_lodge
      setmodel(self, "q3mdl/buildings/misc/misc_lodge.obj");
      setsize(self, self.mins, self.maxs);
      break;
    case 4:
      //building_misc_off_pyra
      setmodel(self, "q3mdl/buildings/misc/misc_off_pyramid.obj");
      setsize(self, self.mins, self.maxs);
      break;
    case 5:
      //building_misc_off_large
      setmodel(self, "q3mdl/buildings/misc/misc_off_large.obj");
      setsize(self, self.mins, self.maxs);
      break;
    case 6:
      //building_misc_off_small
       setmodel(self, "q3mdl/buildings/misc/misc_off_sm.obj");
      if( self.angles_y == 90 ){
        setsize(self, '-56 -36 0', '56 36 80');
      }
      else{
        setsize(self, '-36 -56 0', '36 56 80');
      }
      break;
    case 7:
      //building_misc_fact_steam
      setmodel(self, "q3mdl/buildings/misc/misc_fact_steam.obj");
      setsize(self, self.mins, self.maxs);
      break;
    case 8:
      //building_misc_apt_larg
      setmodel(self, "q3mdl/buildings/misc/misc_apt_larg.obj");
      if( self.angles_y == 90 ){
        setsize( self, '-96 -120 0', '96 0 56');
      }
      else if( self.angles_y == 180 ){
        setsize( self, '0 -96 0', '120 96 56');
      }
      else if( self.angles_y == 270 ){
        setsize( self, '-96 0 0', '96 120 56');
      }
      else{
        setsize( self, '-120 -96 0', '0 96 56');
      }
      break;
  }
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