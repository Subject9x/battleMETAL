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
float DATWEP_MLGD_CLIPSIZE = 10;
float DATWEP_MLGD_CURRENTAMMO = 10;
float DATWEP_MLGD_FIRERATE = 0.5;//0.95;
float DATWEP_MLGD_RELOADTIME = 0.95;
float DATWEP_MLGD_ISFIRE = 0;
vector DATWEP_MLGD_FIRE_OFS = '0 0 8';
string DATWEP_MLGD_MODEL = "q3mdl/weapons/w_mis.md3";
float DATWEP_MLGD_PROJ_ID= ID_PRJ_MLGD;
float DATWEP_MLGD_EN_COST= -1;
string DATWEP_MLGD_FIRESOUND = "sound/llaser.ogg";
float DATWEP_MLGD_TECH_LEVEL = 2;

void() data_wep_mlgd;
void() data_mlgd_ini;

void() data_wep_mlgd={
  local entity oself, mlgd;
  mlgd = spawn();
  oself = self;
  self = mlgd;
    self.classname = "data";
    self.data_idx = DATWEP_MLGD_IDX;
    self.data_type = DATA_WEPN;
    data_mlgd_ini();
    self.w_name = DATWEP_MLGD_NAME;
  self = oself;
};

void() data_mlgd_ini={
  self.w_name = DATWEP_MLGD_NAME;
  self.w_clipsize = DATWEP_MLGD_CLIPSIZE;
  self.w_firerate = DATWEP_MLGD_FIRERATE;
  self.w_reloadtime = DATWEP_MLGD_RELOADTIME;
  self.c_model = DATWEP_MLGD_MODEL;
  self.en_max = DATWEP_MLGD_EN_COST;
  self.i_techlvl = DATWEP_MLGD_TECH_LEVEL;
  self.dmg_type = self.dmg_type | DMG_EXP;
  self.w_abbr = "M-LGD";
};
