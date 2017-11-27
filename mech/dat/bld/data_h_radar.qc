/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_radar (.1 .1 .1) (-12 -12 0) (12 12 20)
*/
void() building_radar;
void() building_radar={
  self.data_idx = ID_BLD_H_RADAR;
  self.data_type = DATA_BLD;
  self.vec_name = "Listening Post";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_radar.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(250, 250, 1, 100) ;
  util_setBoundBox('-20 -20 0', '20 20 26');
  self.sh_cur= 0;
  self.sh_max= 200;
  self.sh_rate= 1;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = building_die;
  self.think = building_think;
  self.use = multi_trigger;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = 1;
};