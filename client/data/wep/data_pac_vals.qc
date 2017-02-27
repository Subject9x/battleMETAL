/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_PAC_IDX = ID_WEP_PAC;
string DAT_PAC_NAME = "PAC";
float DAT_PAC_FIRETIME = 0;
float DAT_PAC_CLIPSIZE = 1;
float DAT_PAC_FIRERATE = 1;
float DAT_PAC_RELOADTIME = 1;
string DAT_PAC_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_PAC_EN_COST = 60;
float DAT_PAC_TECH_LEVEL = 1;

void() data_wep_pac;
void() data_pac_ini;
void() data_pac_atk;

void() data_wep_pac={
  local entity oself, PAC;
  PAC = spawn();
  oself = self;
  self = PAC;
    self.classname = "data";
    self.data_idx = DAT_PAC_IDX;
    self.data_type = DATA_WEPN;
    data_pac_ini();
    self.w_name = DAT_PAC_NAME;
  self = oself;
};

void() data_pac_ini={
  self.w_name = DAT_PAC_NAME;
  self.w_clipsize = DAT_PAC_CLIPSIZE;
  self.w_firerate = DAT_PAC_FIRERATE;
  self.w_reloadtime = DAT_PAC_RELOADTIME;
  self.c_model = DAT_PAC_MODEL;
  self.en_max = DAT_PAC_EN_COST;
  self.i_techlvl = DAT_PAC_TECH_LEVEL;
};


