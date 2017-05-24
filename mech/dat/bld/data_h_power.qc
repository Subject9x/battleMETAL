/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_power (.1 .1 .1) (-56 -56 0) (56 56 46)
*/
void() building_power;
void() building_power={
  self.data_idx = ID_BLD_H_POWER;
  self.data_type = DATA_BLD;
  self.vec_name = "Power Generator";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_power.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(100, 100, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 46');
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = BecomeExplosion;
  self.think = SUB_Null;
  self.nextthink = time + 10000000;
};