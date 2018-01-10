/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
float DATWEP_MLGD_IDX = ID_WEP_MLGD;
string DATWEP_MLGD_NAME = "Laser-Guided Missile";

void() data_wep_mlgd;

void() data_wep_mlgd={
  local entity oself, mlgd;
  mlgd = spawn();
  oself = self;
  self = mlgd;
    self.classname = "data";
    self.data_idx = DATWEP_MLGD_IDX;
    self.dmg_amt = DAT_MLGD_DAMAGE;
    self.data_type = DATA_WEPN;
    self.w_name = DATWEP_MLGD_NAME;
    self.w_name = DATWEP_MLGD_NAME;
    self.w_clipsize = DAT_MLGD_CLIPSIZE;
    self.c_model = DAT_MLGD_MODEL;
    self.en_rate= DAT_MLGD_EN_RATE;
    self.rl_max = DAT_MLGD_RL_MAX;
    self.i_techlvl = DAT_MLGD_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MLGD_WSIZE;
    self.w_abbr = "M-LGD";
    self.note1 = "Missile will follow your reticle.";
    self.note2 = "Does not require [ACTIVE] RADAR.";
    self.note3 = "Does not require TARGET LOCK.";
    self.w_icon = UI_WEP_MLGD;
    self.w_range = DAT_MLGD_RANGE;
  self = oself;
};