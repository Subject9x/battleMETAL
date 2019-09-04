/*
battleMETAL
Author: Peter Roohr
Date: 09/03/2019
Overview:
  a smaller, vehicle hangar.
*/


void() building_human_hangar_vec_th={
  
  building_burn();
  self.think = building_human_hangar_vec_th;
  self.nextthink = time + 0.1;
};

void() building_human_hangar_vehicle={

  self.data_idx = UI_BUILDING_hangar_med;
  self.data_type = DATA_BLD;
  self.vec_name = "VEhicle Hangar";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 2;
  
  self.takedamage = DAMAGE_AIM;
  
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 1;
  self.deadflag = DEAD_NO;
  
  self.th_die = building_die;
  self.use = multi_trigger;
  self.solid = SOLID_BSP;
  util_setHealthArmor(500, 800, 1, 100) ;
  util_setModel( "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3", self.skin, 0) ;
  setsize(self, self.mins, self.maxs);
  self.movetype = MOVETYPE_NONE;
  
  if( util_cornerSlopeCheck(self, 1) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  self.think = building_human_hangar_vec_th;
  self.nextthink = time + (random() * 0.1);
};