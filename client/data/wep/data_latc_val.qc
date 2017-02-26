/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_IDX = ID_WEP_LATC;
string DAT_LATC_NAME = "Autocannon";
float DAT_LATC_CLIPSIZE = 4;
float DAT_LATC_FIRERATE = 0.18;
float DAT_LATC_RELOADTIME = 0.45;
string DAT_LATC_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_LATC_EN_COST= 0;
float DAT_LATC_TECH_LEVEL = 1;

void() data_wep_latc;
void() data_latc_ini;

void() data_wep_latc={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_LATC_IDX;
    self.data_type = DATA_WEPN;
    data_latc_ini();
    self.w_name = DAT_LATC_NAME;
  self = oself;
};

void() data_latc_ini={
  self.w_name = DAT_LATC_NAME;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_firerate = DAT_LATC_FIRERATE;
  self.w_reloadtime = DAT_LATC_RELOADTIME;
  self.c_model = DAT_LATC_MODEL;
  self.en_max = DAT_LATC_EN_COST;
  self.i_techlvl = DAT_LATC_TECH_LEVEL;
};