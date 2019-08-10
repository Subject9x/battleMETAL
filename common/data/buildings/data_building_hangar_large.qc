/*
battleMETAL
Author: Peter Roohr
Date: 5/10/2017
Overview: data file for building
*/


void() building_human_hangar_th={
  
  building_burn();
  self.think = building_human_hangar_th;
  self.nextthink = time + 0.1;
};

void() building_human_hangar={

  self.data_idx = UI_BUILDING_hangar_large;
  self.data_type = DATA_BLD;
  self.vec_name = "Large Hangar";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 3;
  
  self.takedamage = DAMAGE_AIM;
  
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 1;
  self.deadflag = DEAD_NO;
  
  self.th_die = building_die;
  self.use = multi_trigger;
  self.solid = SOLID_BSP;
  util_setHealthArmor(800, 800, 1, 100) ;
  util_setModel( "q3mdl/buildings/hangar/mdl_bld_h_hangar_l.md3", self.skin, 0) ;
  setsize(self, self.mins, self.maxs);
  self.movetype = MOVETYPE_NONE;
  
  if( util_cornerSlopeCheck(self, 1) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  self.think = building_human_hangar_th;
  self.nextthink = time + (random() * 0.1);
};