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
    self.e_model = "q3mdl/buildings/mdl_bld_h_fuel.md3";
    self.sh_cur= 0;
    self.sh_max= 100;
    self.sh_rate= 1;
  self = oself;
};