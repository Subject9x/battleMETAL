/*
mech Mod
Author: Peter Roohr
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
    self.e_model = DAT_BLD_H_LG_HANGAR_MODEL;
    self.sh_cur= 0;
    self.sh_max= DAT_BLD_H_LG_HANGAR_SH_MAX;
    self.sh_rate= DAT_BLD_H_LG_HANGAR_SH_RATE;
  self = oself;
};