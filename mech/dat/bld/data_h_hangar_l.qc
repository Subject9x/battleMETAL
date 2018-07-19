/*
mech Mod
Author: Peter Roohr
Date: 5/10/2017
Overview: data file for building
*/

/*QUAKED building_hangar (.1 .1 .1) (-72 -72 -40) (72 72 40)
*/
void() building_hangar;

void() building_hangar={
  self.data_idx = ID_BLD_H_HANGAR_L;
  self.data_type = DATA_BLD;
  self.vec_name = "Large Hangar";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  util_setModel(DAT_BLD_H_LG_HANGAR_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_LG_HANGAR_HP, DAT_BLD_H_LG_HANGAR_HP, 1, 100) ;
  util_setBoundBox('-72 -72 0', '72 72 80');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_LG_HANGAR_SH_MAX;
  self.sh_rate= DAT_BLD_H_LG_HANGAR_SH_RATE;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
   
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  
  self.movetype = MOVETYPE_NONE;
  self.th_die = building_die;
  self.think = building_think;
  self.nextthink = time + 1;
  self.use = multi_trigger;
  self.SendEntity = send_building;
  self.SendFlags = -1;
};