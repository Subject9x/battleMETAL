/*
mech Mod
Author: Subject9x
Date: 05/13/2017
Overview: data file for large mech hangar, humans
*/

void() building_hangar_l;
void() building_hangar_l={
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_HANGAR_L;
    self.data_type = DATA_BLD;
    self.vec_name = "Large Hangar";
    self.e_model = "q3mdl/buildings/mdl_bld_h_hangar_l.md3";
  self = oself;
};