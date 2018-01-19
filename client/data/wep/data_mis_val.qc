/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROCKET POD=======================
float DAT_MIS_IDX = ID_WEP_MIS;
string DAT_MIS_NAME = "Rocket Pod";

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
    self.c_model = DAT_MIS_MODEL;
    self.en_rate = DAT_MIS_EN_RATE;
    self.rl_max = DAT_MIS_RL_MAX;
    self.i_techlvl = DAT_MIS_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MIS_WSIZE;
    self.w_abbr = "RCK";
    self.note1 = "Damage is PER MISSILE";
    self.note2 = "Fires entire clip at once.";
    self.note3 = "Does not require [ACTIVE] RADAR.";
    self.note4 = "Does not require TARGET LOCK.";
    self.w_icon = UI_WEP_RCK;
    self.w_range = DAT_MIS_RANGE;
  self = oself;
};