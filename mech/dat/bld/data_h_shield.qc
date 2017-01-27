/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_shield (.1 .1 .1) (-12 -12 0) (12 12 15)
*/
void() building_shield;

void() building_shield={
  self.data_idx = ID_BLD_H_SHIELD;
  self.data_type = DATA_BLD;
  self.vec_name = "Shield Generator";
  util_setModel("q3mdl/buildings/mdl_bld_h_shield.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(100, 100, 1, 100) ;
  util_setBoundBox('-16 -16 0', '16 16 20');
  self.scale = 1;
  droptofloor();
  self.think = SUB_Null;
  self.nextthink = time + 10000000;
};