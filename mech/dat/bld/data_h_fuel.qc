/*
mech Mod
Author: Subject9x
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_fuel (.1 .1 .1) (-64 -64 0) (64 64 40)
*/
void() building_fuel;

void() building_fuel={
  self.data_idx = ID_BLD_H_FUEL;
  self.data_type = DATA_BLD;
  self.vec_name = "Fuel Tank";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_fuel.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(500, 500, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 64');
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = BecomeExplosion;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = 1;
};