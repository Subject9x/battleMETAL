/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_RPLAS_IDX = ID_WEP_RPC;
string DAT_RPLAS_NAME = "Rotary Plasma Cannon";
float DAT_RPLAS_CLIPSIZE = 1;
float DAT_RPLAS_FIRERATE = 0.28;
float DAT_RPLAS_RELOADTIME = 0.28;
string DAT_RPLAS_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_RPLAS_EN_COST= -1;

float DAT_RPLAS_TECH_LEVEL = 1;

void() data_wep_rplas;
void() data_rplas_ini;

void() data_wep_rplas={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_RPLAS_IDX;
    self.data_type = DATA_WEPN;
    data_rplas_ini();
    self.w_name = DAT_RPLAS_NAME;
  self = oself;
};

void() data_rplas_ini={
  self.w_name = DAT_RPLAS_NAME;
  self.w_clipsize = DAT_RPLAS_CLIPSIZE;
  self.w_firerate = DAT_RPLAS_FIRERATE;
  self.w_reloadtime = DAT_RPLAS_RELOADTIME;
  self.c_model = DAT_RPLAS_MODEL;
  self.en_max = DAT_RPLAS_EN_COST;
  self.i_techlvl = DAT_RPLAS_TECH_LEVEL;
  self.dmg_type = self.dmg_type | DMG_BAL;
  self.w_abbr = "RPC";
};

