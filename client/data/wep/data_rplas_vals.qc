/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROTARY PLASMA CANNON=======================
float DAT_RPLAS_IDX = ID_WEP_RPC;
string DAT_RPLAS_NAME = "Rotary Plasma Cannon";

void() data_wep_rplas;

void() data_wep_rplas={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_RPLAS_IDX;
    self.dmg_amt = DAT_RPLAS_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_RPLAS_NAME;
    self.w_name = DAT_RPLAS_NAME;
    self.w_clipsize = DAT_RPLAS_CLIPSIZE;
    self.c_model = DAT_RPLAS_MODEL;
    self.en_rate = DAT_RPLAS_EN_RATE;
    self.rl_max = DAT_RPLAS_RL_MAX;
    self.i_techlvl = DAT_RPLAS_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_RPLAS_WSIZE;
    self.w_abbr = "RPC";
    self.note1 = "Fires 6 sub-munitions.";
    self.note2 = "Ricochets off the ground and most walls.";
    self.note3 = "Will burn over time on unshielded targets.";
    self.w_icon = UI_WEP_RPC;
    self.w_range = DAT_RPLAS_RANGE;
  self = oself;
};

