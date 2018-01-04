/*
mech Mod
Author: Peter Roohr
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
    self.e_model = DAT_BLD_H_FUELTANK_MODEL;
    self.sh_cur= 0;
    self.sh_max= DAT_BLD_H_FUELTANK_SH_MAX;
    self.sh_rate= DAT_BLD_H_FUELTANK_SH_RATE;
  self = oself;
};