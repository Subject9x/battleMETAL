/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_IDX = ID_WEP_LATC;
string DAT_LATC_NAME = "Autocannon";


void() data_wep_latc;

void() data_wep_latc={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_LATC_IDX;
    self.dmg_amt = DAT_LATC_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_LATC_NAME;
    self.w_name = DAT_LATC_NAME;
    self.w_clipsize = DAT_LATC_CLIPSIZE;
    self.w_firerate = DAT_LATC_FIRERATE;
    self.w_reloadtime = DAT_LATC_EN_MAX / 100;
    self.c_model = DAT_LATC_MODEL;
    self.en_max = 0;
    self.i_techlvl = DAT_LATC_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_LATC_WSIZE;
    self.w_abbr = "ATC";
    self.note1 = "Basic automatic cannon.";
    self.w_icon = UI_WEP_ATC;
    self.w_range = DAT_LATC_RANGE;
  self = oself;
};