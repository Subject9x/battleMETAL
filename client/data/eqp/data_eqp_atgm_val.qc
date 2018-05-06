/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Advanced Targeting Module
this decreases a Metal's lock-on time by 20%
and improves accuracy recovery by 15%;
*/
//ADVANCED TARGETING MODULE=======================
void() data_eqp_atgm_ini;

void() data_eqp_atgm_ini={
  local entity oself, atgm;
  atgm = spawn();
  oself = self;
  self = atgm;
    self.classname = "data";
    self.data_idx = ID_EQP_ATGM;
    self.dmg_amt = 0;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EQP_ATGM_NAME;
    self.w_clipsize = 0;
    self.c_model = DAT_EQP_ATGM_MODEL;
    self.en_rate = 0;
    self.rl_max = 0;
    self.i_techlvl = DAT_EQP_ATGM_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_MSC;
    self.i_size = DAT_EQP_ATGM_WSIZE;
    self.w_abbr = "ATGM";
    self.note1 = "Decrease LOCK-ON time by 20% \n Increase Convergence recovery by 15%";
    self.w_icon = UI_EQP_ATGM;
    self.w_range = 0;
  self = oself;
};
