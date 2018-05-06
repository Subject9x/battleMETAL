/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Energy Battery
*/
//Energy Battery=======================
void() data_eqp_enbat_ini;

void() data_eqp_enbat_ini={
  local entity oself, atgm;
  atgm = spawn();
  oself = self;
  self = atgm;
    self.classname = "data";
    self.data_idx = ID_EQP_ENBAT;
    self.dmg_amt = 0;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EQP_ENBAT_NAME;
    self.w_clipsize = 0;
    self.c_model = DAT_EQP_ENBAT_MODEL;
    self.en_rate = 0;
    self.rl_max = 0;
    self.i_techlvl = DAT_EQP_ENBAT_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_MSC;
    self.i_size = DAT_EQP_ENBAT_WSIZE;
    self.w_abbr = "ENBAT";
    self.note1 = "Increases TOTAL ENERGY by 25%";
    self.w_icon = UI_EQP_ENBAT;
    self.w_range = 0;
  self = oself;
};