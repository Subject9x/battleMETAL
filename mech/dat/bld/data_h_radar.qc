/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_radar (.1 .1 .1) (-20 -20 -13) (20 20 13)
*/
void() building_radar;
void() building_radar={
  self.data_idx = ID_BLD_H_RADAR;
  self.data_type = DATA_BLD;
  self.vec_name = "Listening Post";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 1;
  util_setModel(DAT_BLD_H_SM_RADAR_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_SM_RADAR_HP, DAT_BLD_H_SM_RADAR_HP, 1, 100) ;
  util_setBoundBox('-20 -20 0', '20 20 26');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_SM_RADAR_SH_MAX;
  self.sh_rate= DAT_BLD_H_SM_RADAR_SH_RATE;
  self.stat_rdr_mode = 1;
  self.radar_range = DAT_BLD_H_SM_RADAR_RADAR_RANGE;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();  
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  self.th_die = building_die;
  self.think = building_think;
  self.use = multi_trigger;
  self.nextthink = time + 1;
};