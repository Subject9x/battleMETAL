/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Heavy Shield Emitter 
improves shield recharge rate by a percentage
*/
//Heavy Shield Emitter =======================
void() data_eqp_hsem_ini;

void() data_eqp_hsem_ini={
  local entity oself, atgm;
  atgm = spawn();
  oself = self;
  self = atgm;
    self.classname = "data";
    self.data_idx = ID_EQP_HSEM;
    self.dmg_amt = 0;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EQP_HSEM_NAME;
    self.w_clipsize = 0;
    self.c_model = DAT_EQP_HSEM_MODEL;
    self.en_rate = 0;
    self.rl_max = 0;
    self.i_techlvl = DAT_EQP_HSEM_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_MSC;
    self.i_size = DAT_EQP_HSEM_WSIZE;
    self.w_abbr = "HSEM";
    self.note1 = "Increases SHIELD RECHARGE by 50%";
    self.w_icon = UI_EQP_HSEM;
    self.w_range = 0;
  self = oself;
};