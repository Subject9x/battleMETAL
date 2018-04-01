/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
void() data_wep_esr;

void() data_wep_esr={
  local entity oself, esr;
  esr = spawn();
  oself = self;
  self = esr;
    self.classname = "data";
    self.data_idx = ID_WEP_ESR;
    self.dmg_amt = 25;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_ESR_NAME;
    self.w_clipsize = DAT_ESR_CLIPSIZE;
    self.c_model = DAT_ESR_MODEL;
    self.en_rate = DAT_ESR_EN_RATE;
    self.rl_max = DAT_ESR_RL_MAX;
    self.i_techlvl = DAT_ESR_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_ESR_WSIZE;
    self.w_abbr = "ESR";
    self.note1 = "Devastating short range weapon. \n Highly innaccurate.";
    self.w_icon = UI_WEP_ESR;
    self.w_range = 800;//v0.0.3
  self = oself;
};