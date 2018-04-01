/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
void() data_wep_mlgd;

void() data_wep_mlgd={
  local entity oself, mlgd;
  mlgd = spawn();
  oself = self;
  self = mlgd;
    self.classname = "data";
    self.data_idx = ID_WEP_MLGD;
    self.dmg_amt = DAT_MLGD_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_MLGD_NAME;
    self.w_clipsize = DAT_MLGD_CLIPSIZE;
    self.c_model = DAT_MLGD_MODEL;
    self.en_rate= DAT_MLGD_EN_RATE;
    self.rl_max = DAT_MLGD_RL_MAX;
    self.i_techlvl = DAT_MLGD_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MLGD_WSIZE;
    self.w_abbr = "M-LGD";
    self.note1 = "Missile will follow your reticle. \n \n Does not require [ACTIVE] RADAR. \n \n Does not require TARGET LOCK.";
    self.w_icon = UI_WEP_MLGD;
    self.w_range = DAT_MLGD_RANGE;
  self = oself;
};