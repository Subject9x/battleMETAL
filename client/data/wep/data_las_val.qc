/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
void() data_wep_las;

void() data_wep_las={
  local entity oself, las;
  las = spawn();
  oself = self;
  self = las;
    self.classname = "data";
    self.data_idx = ID_WEP_LAS;
    self.dmg_amt = DAT_LAS_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_LAS_NAME;
    self.w_clipsize = DAT_LAS_CLIPSIZE;
    self.c_model = DAT_LAS_MODEL;
    self.en_rate = DAT_LAS_EN_RATE;
    self.rl_max = DAT_LAS_RL_MAX;
    self.i_techlvl = DAT_LAS_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_LAS_WSIZE;
    self.w_abbr = "LAS";
    self.note1 = "Small bonus damage against shields.";
    self.w_icon = UI_WEP_LAS;
    self.w_range = DAT_LAS_RANGE;
  self = oself;
};