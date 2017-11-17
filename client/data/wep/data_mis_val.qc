/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROCKET POD=======================
float DAT_MIS_IDX = ID_WEP_MIS;
string DAT_MIS_NAME = "Rocket Pod";
float DAT_MIS_CLIPSIZE = 6;
float DAT_MIS_FIRERATE = 0.2; //0.3;
float DAT_MIS_RELOADTIME = 8;//1.85;
string DAT_MIS_MODEL = "q3mdl/weapons/w_mis.md3";
float DAT_MIS_EN_COST= 10;
float DAT_MIS_TECH_LEVEL = 1;
float DAT_MIS_WSIZE = 2;
float DAT_MIS_RANGE = 1000;//v0.0.3
float DAT_MIS_DMG = 450;
void() data_wep_mis;

void() data_wep_mis={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = DAT_MIS_IDX;
    self.dmg_amt = DAT_MIS_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_MIS_NAME;
    self.w_name = DAT_MIS_NAME;
    self.w_clipsize = DAT_MIS_CLIPSIZE;
    self.w_firerate = DAT_MIS_FIRERATE;
    self.w_reloadtime = DAT_MIS_RELOADTIME;
    self.c_model = DAT_MIS_MODEL;
    self.en_max = 0;
    self.i_techlvl = DAT_MIS_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MIS_WSIZE;
    self.w_abbr = "RCK";
    self.note1 = "Fires entire clip at once.";
    self.note2 = "Does not require [ACTIVE] RADAR.";
    self.note3 = "Does not require TARGET LOCK.";
    self.w_icon = UI_WEP_RCK;
    self.w_range = DAT_MIS_RANGE;
  self = oself;
};