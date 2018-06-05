/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Weapon - Air Burst Torpedo
fires a single missile that will explode into bomblets on-contact with enemy target OR timer
but NOT before that
*/
//AIR BURST TORPEDO=======================
void() data_wep_abt;

void() data_wep_abt={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = ID_WEP_ABT;
    self.dmg_amt = DAT_ABT_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_SWRM_NAME;
    self.w_clipsize = DAT_ABT_CLIPSIZE;
    self.c_model = DAT_ABT_MODEL;
    self.en_rate = 0;
    self.rl_max = DAT_ABT_RL_MAX;
    self.i_techlvl = DAT_ABT_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_ABT_WSIZE;
    self.w_abbr = "ABT";
    self.note1 = "Requires RADAR to be [ACTIVE]. \n \n Fires 3 Missiles at EACH \n \n Target in your forward view";
    self.w_icon = UI_WEP_ABT;
    self.w_range = DAT_ABT_RANGE;
  self = oself;
};
