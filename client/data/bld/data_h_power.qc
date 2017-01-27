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
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_POWER;
    self.data_type = DATA_BLD;
    self.vec_name = "Power Generator";
  self = oself;
};