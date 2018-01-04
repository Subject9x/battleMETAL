/*
mech Mod
Author: Peter Roohr
Date: 11/5/2017
Overview:
  name: Human medium tank
  type: vehicle
  size: mediums
*/

//HUMAN LIGHT TNKRET=============================
float DAT_TNK_IDX = ID_VEC_TANK;
string DAT_TNK_VEC_NAME = "Medium Tank";

//LEGS
string DAT_TNK_LEG_CNAME= M_LEGS;


void() data_TNK_hmn;
void() data_TNK_hmn={
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_VEC_TANK;
    self.data_type = DATA_VEHC;
    self.vec_name = "Medium Tank";
    self.e_model = "q3mdl/vecs/mdl_tank_tur.md3";
    self.sh_cur= 0;
    self.sh_max= 100;
    self.sh_rate= 1;
  self = oself;
};