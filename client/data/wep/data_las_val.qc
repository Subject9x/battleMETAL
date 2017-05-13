/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LAS_IDX = ID_WEP_LAS;
string DAT_LAS_NAME = "Laser";
float DAT_LAS_CLIPSIZE = 1;
float DAT_LAS_CURRENTAMMO = 1;
float DAT_LAS_FIRERATE = 0.25;
float DAT_LAS_RELOADTIME = 0.25;
string DAT_LAS_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_EN_COST= 5;
float DAT_LAS_TECH_LEVEL = 1;
float DAT_LAS_WSIZE = 1;

void() data_wep_las;

void() data_wep_las={
  local entity oself, las;
  las = spawn();
  oself = self;
  self = las;
    self.classname = "data";
    self.data_idx = DAT_LAS_IDX;
    self.dmg_amt = 15;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_LAS_NAME;
    self.w_name = DAT_LAS_NAME;
    self.w_clipsize = DAT_LAS_CLIPSIZE;
    self.w_firerate = DAT_LAS_FIRERATE;
    self.w_reloadtime = DAT_LAS_RELOADTIME;
    self.c_model = DAT_LAS_MODEL;
    self.en_max = DAT_LAS_EN_COST;
    self.i_techlvl = DAT_LAS_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_LAS_WSIZE;
    self.w_abbr = "LAS";
    self.note1 = "Small bonus damage against shields.";
    self.w_icon = UI_WEP_LAS;
    self.w_range = 1200;
  self = oself;
};