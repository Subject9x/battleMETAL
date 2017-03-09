/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_QRFL_IDX = ID_WEP_QRF;
string DAT_QRFL_NAME = "Q-Rifle";
float DAT_QRFL_FIRETIME = 0;
float DAT_QRFL_CLIPSIZE = 1;
float DAT_QRFL_FIRERATE = 0.5;
float DAT_QRFL_RELOADTIME = 0.5;
float DAT_QRFL_EN_COST= -1;
float DAT_QRFL_TECH_LEVEL = 1;

void() data_wep_qrfl;
void() data_qrfl_ini;

void() data_wep_qrfl={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_QRFL_IDX;
    self.data_type = DATA_WEPN;
    data_qrfl_ini();
    self.w_name = DAT_QRFL_NAME;
  self = oself;
};

void() data_qrfl_ini={
  self.w_name = DAT_QRFL_NAME;
  self.w_clipsize = DAT_QRFL_CLIPSIZE;
  self.w_firerate = DAT_QRFL_FIRERATE;
  self.w_reloadtime = DAT_QRFL_RELOADTIME;
  self.en_max = DAT_QRFL_EN_COST;
  self.i_techlvl = DAT_QRFL_TECH_LEVEL;
};

