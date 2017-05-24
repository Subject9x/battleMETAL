/*
mech Mod
Author: Subject9x
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
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(100, 100, 1, 100) ;
  util_setBoundBox('-16 -16 0', '16 16 20');
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = BecomeExplosion;
  self.think = SUB_Null;
  self.nextthink = time + 10000000;
};