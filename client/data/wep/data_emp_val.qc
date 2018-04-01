/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//EMP Degausser=======================
void() data_wep_emp;

void() data_wep_emp={
  local entity oself, emp;
  emp = spawn();
  oself = self;
  self = emp;
    self.classname = "data";
    self.data_idx = ID_WEP_EMP;
    self.dmg_amt = DAT_EMP_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_EMP_NAME;
    self.w_clipsize = DAT_EMP_CLIPSIZE;
    self.c_model = DAT_EMP_MODEL;
    self.en_rate = DAT_EMP_EN_RATE;
    self.rl_max = DAT_EMP_RL_MAX;
    self.i_techlvl = DAT_EMP_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_ENE;
    self.i_size = DAT_EMP_WSIZE;
    self.w_abbr = "EMP";
    self.note1 = "Only damages Target's SHIELDS. \n Proximity detonation at longer ranges.";
    self.w_icon = UI_WEP_EMP;
    self.w_range = DAT_EMP_RANGE;
  self = oself;
};
