/*
mech Mod
Author: Subject9x
Date:05/13/2017
Overview: data file for fuel bunker
*/

void() building_fuel;
void() building_fuel={
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_FUEL;
    self.data_type = DATA_BLD;
    self.vec_name = "Fuel Tank";
  self = oself;
};