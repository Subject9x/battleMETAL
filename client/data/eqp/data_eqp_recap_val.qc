/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Reactor Capacitor
improves reactor recharge by a percentage
*/
//Reactor Capacitor=======================
void() data_eqp_recap_ini;

void() data_eqp_recap_ini={
  local entity oself, atgm;
  atgm = spawn();
  oself = self;
  self = atgm;
    self.classname = "data";
    self.data_idx = ID_EQP_RECAP;
    self.dmg_amt = 0;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EQP_RECAP_NAME;
    self.w_clipsize = 0;
    self.c_model = DAT_EQP_RECAP_MODEL;
    self.en_rate = 0;
    self.rl_max = 0;
    self.i_techlvl = DAT_EQP_RECAP_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_MSC;
    self.i_size = DAT_EQP_RECAP_WSIZE;
    self.w_abbr = "RECAP";
    self.note1 = "Increases Reactor RECHARGE rate by 20%";
    self.w_icon = UI_EQP_RECAP;
    self.w_range = 0;
  self = oself;
};