/*
mech Mod
Author: Peter Roohr
Date: 3/21/2018
Overview: data file for the human repair bay
*/

void() building_repair;
void() building_repair={
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_REPAIR;
    self.data_type = DATA_BLD;
    self.vec_name = "Large Hangar";
    self.e_model = DAT_BLD_H_REPAIR_MODEL;
    self.sh_cur = 0;
    self.sh_max = DAT_BLD_H_REPAIR_SH_MAX;
    self.sh_rate  = DAT_BLD_H_REPAIR_SH_RATE;
  self = oself;
};