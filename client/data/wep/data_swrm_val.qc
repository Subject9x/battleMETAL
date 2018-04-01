/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========
void() data_wep_swrm;

void() data_wep_swrm={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = ID_WEP_SWRM;
    self.dmg_amt = DAT_SWRM_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_SWRM_NAME;
    self.w_clipsize = DAT_SWRM_CLIPSIZE;
    self.c_model = DAT_SWRM_MODEL;
    self.en_rate = DAT_SWRM_EN_RATE;
    self.rl_max = DAT_LATC_RL_MAX;
    self.i_techlvl = DAT_SWRM_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_SWRM_WSIZE;
    self.w_abbr = "M-ARH";
    self.note1 = "Requires RADAR to be [ACTIVE]. \n \n Fires 3 Missiles at EACH \n \n Target in your forward view";
    self.w_icon = UI_WEP_SWRM;
    self.w_range = DAT_SWRM_RANGE;
  self = oself;
};
