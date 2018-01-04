/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_SFGA_IDX = ID_WEP_SFGA;
string DAT_SFGA_NAME = "Snub Field Gun";


void() data_wep_sfga;

void() data_wep_sfga={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_SFGA_IDX;
    self.dmg_amt = DAT_SFGA_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_SFGA_NAME;
    self.w_clipsize = DAT_SFGA_CLIPSIZE;
    self.w_firerate = DAT_SFGA_FIRERATE;
    self.w_reloadtime = DAT_SFGA_EN_MAX / 100;
    self.c_model = DAT_SFGA_MODEL;
    self.en_max = 0;
    self.i_techlvl = DAT_SFGA_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_SFGA_WSIZE;
    self.w_abbr = "SFGA";
    self.note1 = "Large AoE blast.";
    self.w_icon = UI_WEP_SFG;
    self.w_range = DAT_SFGA_RANGE;
  self = oself;
};

