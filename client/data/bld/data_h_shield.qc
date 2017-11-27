/*
mech Mod
Author: Peter Roohr
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
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_SHIELD;
    self.data_type = DATA_BLD;
    self.vec_name = "Shield Generator";
    self.e_model = "q3mdl/buildings/mdl_bld_h_shield.md3";
    self.sh_cur= 0;
    self.sh_max= 800;
    self.sh_rate= 1;
  self = oself;
};