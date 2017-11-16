/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROTARY PLASMA CANNON=======================
float DAT_RPLAS_IDX = ID_WEP_RPC;
string DAT_RPLAS_NAME = "Rotary Plasma Cannon";
float DAT_RPLAS_CLIPSIZE = 1;
float DAT_RPLAS_FIRERATE = 3; //was 0.28 - 3/27/2017
float DAT_RPLAS_RELOADTIME = 3;
string DAT_RPLAS_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_RPLAS_EN_COST = 10;
float DAT_RPLAS_WSIZE = 2;
float DAT_RPLAS_TECH_LEVEL = 1;
float DAT_PRJ_RPLAS_DAMAGE = 20; //was 5 - 3/27/2017
float DAT_PRJ_RPLAS_BURN = 0.25;
float DAT_RPLAS_RANGE = 2400;//v0.0.3
void() data_wep_rplas;

void() data_wep_rplas={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_RPLAS_IDX;
    self.dmg_amt = DAT_PRJ_RPLAS_DAMAGE;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_RPLAS_NAME;
    self.w_name = DAT_RPLAS_NAME;
    self.w_clipsize = DAT_RPLAS_CLIPSIZE;
    self.w_firerate = DAT_RPLAS_FIRERATE;
    self.w_reloadtime = DAT_RPLAS_RELOADTIME;
    self.c_model = DAT_RPLAS_MODEL;
    self.en_max = DAT_RPLAS_EN_COST;
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

