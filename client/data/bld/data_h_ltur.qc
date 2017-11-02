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
    self.e_model = "q3mdl/buildings/mdl_bld_h_ltur.md3";
    self.sh_cur= 0;
    self.sh_max= 100;
    self.sh_rate= 1;
  self = oself;
};