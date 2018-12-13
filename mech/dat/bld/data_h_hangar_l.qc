/*
mech Mod
Author: Peter Roohr
Date: 5/10/2017
Overview: data file for building
*/

void() building_human_hangar={

  self.data_idx = ID_BLD_H_HANGAR_L;
  self.data_type = DATA_BLD;
  self.vec_name = "Large Hangar";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 3;
  
  self.takedamage = DAMAGE_AIM;
  
  self.sh_cur = 0;
  self.sh_max = DAT_BLD_H_LG_HANGAR_SH_MAX;
  self.sh_rate = DAT_BLD_H_LG_HANGAR_SH_RATE;
  self.deadflag = DEAD_NO;
  
  self.th_die = building_die;
  self.use = multi_trigger;
  self.solid = SOLID_BSP;
  util_setHealthArmor(DAT_BLD_H_LG_HANGAR_HP, DAT_BLD_H_LG_HANGAR_HP, 1, 100) ;
  util_setModel(DAT_BLD_H_LG_HANGAR_MODEL, self.skin, 0) ;
  setsize(self, self.mins, self.maxs);
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  
  
  self.movetype = MOVETYPE_NONE;
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }

};