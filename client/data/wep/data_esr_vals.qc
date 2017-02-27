/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_ESR_IDX = ID_WEP_ESR;
string DAT_ESR_NAME = "ESR";
float DAT_ESR_CLIPSIZE = 10;
float DAT_ESR_FIRERATE = 0.06;
float DAT_ESR_RELOADTIME = 1;
string DAT_ESR_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_EN_COST = 40;
float DAT_ESR_TECH_LEVEL = 1;


void() data_wep_esr;
void() data_esr_ini;

void() data_wep_esr={
  local entity oself, esr;
  esr = spawn();
  oself = self;
  self = esr;
    self.classname = "data";
    self.data_idx = DAT_ESR_IDX;
    self.data_type = DATA_WEPN;
    data_esr_ini();
    self.w_name = DAT_ESR_NAME;
  self = oself;
};

void() data_esr_ini={
  self.w_name = DAT_ESR_NAME;
  self.w_clipsize = DAT_ESR_CLIPSIZE;
  self.w_firerate = DAT_ESR_FIRERATE;
  self.w_reloadtime = DAT_ESR_RELOADTIME;
  self.c_model = DAT_ESR_MODEL;
  self.en_max = DAT_ESR_EN_COST;
  self.i_techlvl = DAT_ESR_TECH_LEVEL;
};