/*
mech Mod
Author: Peter Roohr
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
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_RADAR;
    self.data_type = DATA_BLD;
    self.vec_name = "Listening Post";
    self.e_model = "q3mdl/buildings/mdl_bld_h_radar.md3";
    self.sh_cur= 0;
    self.sh_max= 200;
    self.sh_rate= 1;
  self = oself;
};