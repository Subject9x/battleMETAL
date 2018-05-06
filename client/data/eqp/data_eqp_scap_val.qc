/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Shield Capacitor
improves shield total by a percentage
*/
//Shield Capacitor =======================
void() data_eqp_scap_ini;

void() data_eqp_scap_ini={
  local entity oself, scap;
  scap = spawn();
  oself = self;
  self = scap;
    self.classname = "data";
    self.data_idx = ID_EQP_SCAP;
    self.dmg_amt = 0;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EQP_SCAP_NAME;
    self.w_clipsize = 0;
    self.c_model = DAT_EQP_SCAP_MODEL;
    self.en_rate = 0;
    self.rl_max = 0;
    self.i_techlvl = DAT_EQP_SCAP_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_MSC;
    self.i_size = DAT_EQP_SCAP_WSIZE;
    self.w_abbr = "SCAP";
    self.note1 = "Increases SHIELD TOTAL by 15%";
    self.w_icon = UI_EQP_SCAP;
    self.w_range = 0;
  self = oself;
};