void() building_ltur;
void() building_ltur={
  local entity oself, bld;
  oself = self;
  bld = spawn();
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_LTUR;
    self.data_type = DATA_VEHC;
    self.vec_name = "Light Turret";
    self.e_model = DAT_TUR_CTOR_MODEL;
    self.sh_cur= 0;
    self.sh_max= DAT_TUR_SHIELD_MAX;
    self.sh_rate= DAT_TUR_SHIELD_RATE;
  self = oself;
};