/*
mech Mod
Author: Subject9x
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========
float DATWEP_MARH_IDX = ID_WEP_MARH;
string DATWEP_MARH_NAME = "Active-Radar Homing Missile";
float DATWEP_MARH_FIRETIME = 0;
float DATWEP_MARH_CLIPSIZE = 1;
float DATWEP_MARH_CURRENTAMMO = 1;
float DATWEP_MARH_FIRERATE = 0.25;//0.95;
float DATWEP_MARH_RELOADTIME = 0.95;
float DATWEP_MARH_ISFIRE = 0;
vector DATWEP_MARH_FIRE_OFS = '0 0 8';
string DATWEP_MARH_MODEL = "q3mdl/weapons/w_mis.md3";
float DATWEP_MARH_PROJ_ID= ID_PRJ_MARH;
float DATWEP_MARH_EN_COST= -1;
string DATWEP_MARH_FIRESOUND = "sound/llaser.ogg";
float DATWEP_MARH_TECH_LEVEL = 2;

void() data_wep_marh;
void() data_marh_ini;  

void() data_wep_marh={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = DATWEP_MARH_IDX;
    self.data_type = DATA_WEPN;
    data_mis_ini();
    self.w_name = DATWEP_MARH_NAME;
  self = oself;
};

void() data_marh_ini={
  self.w_name = DATWEP_MARH_NAME;
  self.w_clipsize = DATWEP_MARH_CLIPSIZE;
  self.w_firerate = DATWEP_MARH_FIRERATE;
  self.w_reloadtime = DATWEP_MARH_RELOADTIME;
  self.c_model = DATWEP_MARH_MODEL;
  self.en_max = DATWEP_MARH_EN_COST;
  self.i_techlvl = DATWEP_MARH_TECH_LEVEL;
  self.dmg_type = self.dmg_type | DMG_EXP;
  self.w_abbr = "M-ARH";
};
