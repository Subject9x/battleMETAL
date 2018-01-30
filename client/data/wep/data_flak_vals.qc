/*
mech Mod
Author: Peter Roohr
Date: 01/18/2018
Overview: new year, new toys
*/
//FLAK CANNON=======================

void() data_wep_flak={
  local entity oself, las;
  las = spawn();
  oself = self;
  self = las;
    self.classname = "data";
    self.data_idx = ID_WEP_FLAK;
    self.dmg_amt = DAT_FLAK_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_FLAK_NAME;
    self.w_name = DAT_FLAK_NAME;
    self.w_clipsize = DAT_FLAK_CLIPSIZE;
    self.c_model = DAT_FLAK_MODEL;
    self.en_rate = DAT_FLAK_EN_RATE;
    self.rl_max = DAT_FLAK_RL_MAX;
    self.i_techlvl = DAT_FLAK_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_FLAK_WSIZE;
    self.w_abbr = "FLAK";
    self.note1 = "Fires cluser of shrapnel across target.";
    self.w_icon = UI_WEP_FLAK;
    self.w_range = DAT_FLAK_RANGE;
  self = oself;
};
