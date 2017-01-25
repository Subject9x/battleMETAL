/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_power (.1 .1 .1) (-12 -12 0) (12 12 20)
*/
void() building_power;
void() building_power={
  util_setModel("q3mdl/buildings/mdl_bld_h_power.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(100, 100, 1, 100) ;
  util_setBoundBox('-16 -16 0', '16 16 20');
  self.scale = 1;
  droptofloor();
  self.think = SUB_Null;
  self.nextthink = time + 10000000;
};