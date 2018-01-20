/*
mech Mod
Author: Peter Roohr
Date: 01/20/2018
*/
//Ion Coil=======================
string DAT_ION_NAME = "Ion Coil";

void() data_wep_ion;

void() data_wep_ion={
  local entity oself, emp;
  emp = spawn();
  oself = self;
  self = emp;
    self.classname = "data";
    self.data_idx = ID_WEP_ION;
    self.dmg_amt = DAT_ION_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_ION_NAME;
    self.w_name = DAT_ION_NAME;
    self.w_clipsize = DAT_ION_CLIPSIZE;
    self.c_model = DAT_ION_MODEL;
    self.en_rate = DAT_ION_EN_RATE;
    self.rl_max = DAT_ION_RL_MAX;
    self.i_techlvl = DAT_ION_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_ION_WSIZE;
    self.w_abbr = "ION";
    self.note1 = "Only damages Target's SHIELDS.";
    self.note2 = "Proximity detonation at longer ranges.";
    self.note3 = "3-round burst";
    self.w_icon = UI_WEP_ION;
    self.w_range = DAT_ION_RANGE;
  self = oself;
};
