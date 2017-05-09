/*
mech Mod
Author: Subject9x
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
float DATWEP_MLGD_IDX = ID_WEP_MLGD;
string DATWEP_MLGD_NAME = "Laser-Guided Missile";
float DATWEP_MLGD_FIRETIME = 0;
float DATWEP_MLGD_CLIPSIZE = 1;
float DATWEP_MLGD_CURRENTAMMO = 1;
float DATWEP_MLGD_FIRERATE = 0.5;//0.95;
float DATWEP_MLGD_RELOADTIME = 0.95;
float DATWEP_MLGD_ISFIRE = 0;
vector DATWEP_MLGD_FIRE_OFS = '0 0 8';
string DATWEP_MLGD_MODEL = "q3mdl/weapons/w_mis.md3";
float DATWEP_MLGD_PROJ_ID= ID_PRJ_MLGD;
float DATWEP_MLGD_EN_COST= 0;
string DATWEP_MLGD_FIRESOUND = "sound/llaser.ogg";
float DATWEP_MLGD_TECH_LEVEL = 2;
float DAT_MLGD_WSIZE = 1;

void() data_wep_mlgd;

void() data_wep_mlgd={
  local entity oself, mlgd;
  mlgd = spawn();
  oself = self;
  self = mlgd;
    self.classname = "data";
    self.data_idx = DATWEP_MLGD_IDX;
    self.dmg_amt = 40;
    self.data_type = DATA_WEPN;
    self.w_name = DATWEP_MLGD_NAME;
    self.w_name = DATWEP_MLGD_NAME;
    self.w_clipsize = DATWEP_MLGD_CLIPSIZE;
    self.w_firerate = DATWEP_MLGD_FIRERATE;
    self.w_reloadtime = DATWEP_MLGD_RELOADTIME;
    self.c_model = DATWEP_MLGD_MODEL;
    self.en_max = DATWEP_MLGD_EN_COST;
    self.i_techlvl = DATWEP_MLGD_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_EXP;
    self.i_size = DAT_MLGD_WSIZE;
    self.w_abbr = "M-LGD";
    self.note1 = "Missile will follow your reticule.";
    self.note2 = "Does not require [ACTIVE] RADAR.";
    self.note3 = "Does not require TARGET LOCK.";
    self.w_icon = UI_WEP_MLGD;
  self = oself;
};