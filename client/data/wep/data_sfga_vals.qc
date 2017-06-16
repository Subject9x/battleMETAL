/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_SFGA_IDX = ID_WEP_SFGA;
string DAT_SFGA_NAME = "Snub Field Gun";
float DAT_SFGA_DMG = 8;
float DAT_SFGA_FIRERATE = 4;
float DAT_SFGA_RELOADTIME = 4;
string DAT_SFGA_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_SFGA_EN_COST= 0;
float DAT_SFGA_WSIZE = 2;
float DAT_SFGA_TECH_LEVEL = 1;
float DAT_SFGA_CLIPSIZE = 1;

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
    self.w_reloadtime = DAT_SFGA_RELOADTIME;
    self.c_model = DAT_SFGA_MODEL;
    self.en_max = DAT_SFGA_EN_COST;
    self.i_techlvl = DAT_SFGA_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_SFGA_WSIZE;
    self.w_abbr = "SFGA";
    self.note1 = "Massive Artillery Cannon";
    self.w_icon = UI_WEP_RPC;
    self.w_range = 1600;
  self = oself;
};

