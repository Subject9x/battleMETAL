/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========
void() data_wep_marh;

void() data_wep_marh={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = ID_WEP_MARH;
    self.dmg_amt = 4;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_MARH_NAME;
    self.w_clipsize = DAT_MARH_CLIPSIZE;
    self.c_model = DAT_MARH_MODEL;
    self.en_rate = DAT_MARH_EN_RATE;
    self.rl_max = DAT_LATC_RL_MAX;
    self.i_techlvl = DAT_MARH_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MARH_WSIZE;
    self.w_abbr = "M-ARH";
    self.note1 = "Requires RADAR to be [ACTIVE]. \n Requires TARGET LOCK on target. \n Has minimum range. \n \n Fires 15 missiles at a time.";
    self.w_icon = UI_WEP_MARH;
    self.w_range = DAT_MARH_RANGE;
  self = oself;
};
