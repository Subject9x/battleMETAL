/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_ESR_IDX = ID_WEP_ESR;
string DAT_ESR_NAME = "Electro-Static Coil";
float DAT_ESR_CLIPSIZE = 20;
float DAT_ESR_FIRERATE = 0.01;
float DAT_ESR_RELOADTIME = 5;
string DAT_ESR_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_EN_COST = 10;
float DAT_ESR_TECH_LEVEL = 1;
float DAT_ESR_WSIZE = 3;

void() data_wep_esr;

void() data_wep_esr={
  local entity oself, esr;
  esr = spawn();
  oself = self;
  self = esr;
    self.classname = "data";
    self.data_idx = DAT_ESR_IDX;
    self.dmg_amt = 25;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_ESR_NAME;
    self.w_name = DAT_ESR_NAME;
    self.w_clipsize = DAT_ESR_CLIPSIZE;
    self.w_firerate = DAT_ESR_FIRERATE;
    self.w_reloadtime = DAT_ESR_RELOADTIME;
    self.c_model = DAT_ESR_MODEL;
    self.en_max = DAT_ESR_EN_COST / 1.5;
    self.i_techlvl = DAT_ESR_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_ESR_WSIZE;
    self.w_abbr = "ESR";
    self.note1 = "Devastating short range weapon.";
    self.note2 = "Highly innaccurate.";
    self.w_icon = UI_WEP_ESR;
    self.w_range = 800;//v0.0.3
  self = oself;
};