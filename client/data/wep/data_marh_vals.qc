/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========
float DATWEP_MARH_IDX = ID_WEP_MARH;
string DATWEP_MARH_NAME = "Active-Radar Homing Missile";


void() data_wep_marh;

void() data_wep_marh={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = DATWEP_MARH_IDX;
    self.dmg_amt = 4;
    self.data_type = DATA_WEPN;
    self.w_name = DATWEP_MARH_NAME;
    self.w_name = DATWEP_MARH_NAME;
    self.w_clipsize = DATWEP_MARH_CLIPSIZE;
    self.w_firerate = DATWEP_MARH_FIRERATE;
    self.w_reloadtime = DATWEP_MARH_EN_MAX / 100;
    self.c_model = DATWEP_MARH_MODEL;
    self.en_max = DATWEP_MARH_EN_COST;
    self.i_techlvl = DATWEP_MARH_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MARH_WSIZE;
    self.w_abbr = "M-ARH";
    self.note1 = "Requires RADAR to be [ACTIVE].";
    self.note2 = "Requires TARGET LOCK on target.";
    self.note3 = "Has minimum range.";
    self.note4 = "Fires 15 missiles at a time.";
    self.w_icon = UI_WEP_MARH;
    self.w_range = DAT_MARH_RANGE;
  self = oself;
};
