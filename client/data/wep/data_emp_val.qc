/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_EMP_IDX = ID_WEP_EMP;
string DAT_EMP_NAME = "EMP Cannon";
float DAT_EMP_CLIPSIZE = 1;
float DAT_EMP_FIRERATE = 0.95;
float DAT_EMP_RELOADTIME = 0.95;
string DAT_EMP_MODEL = "q3mdl/weapons/w_emp.md3";
float DAT_EMP_EN_COST= 30;
float DAT_EMP_TECH_LEVEL = 1;
float DAT_EMP_WSIZE = 2;

void() data_wep_emp;

void() data_wep_emp={
  local entity oself, emp;
  emp = spawn();
  oself = self;
  self = emp;
    self.classname = "data";
    self.data_idx = DAT_EMP_IDX;
    self.dmg_amt = 65;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EMP_NAME;
    self.w_name = DAT_EMP_NAME;
    self.w_clipsize = DAT_EMP_CLIPSIZE;
    self.w_firerate = DAT_EMP_FIRERATE;
    self.w_reloadtime = DAT_EMP_RELOADTIME;
    self.c_model = DAT_EMP_MODEL;
    self.en_max = DAT_EMP_EN_COST;
    self.i_techlvl = DAT_EMP_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE | EFF_STX;
    self.i_size = DAT_EMP_WSIZE;
    self.w_abbr = "EMP";
    self.note1 = "Only damages Target's SHIELDS.";
    self.note2 = "Proximity detonation at longer ranges.";
    self.w_icon = UI_WEP_EMP;
  self = oself;
};
