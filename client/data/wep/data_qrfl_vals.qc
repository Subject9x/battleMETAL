/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//QUANTUM RIFLE=======================
float DAT_QRFL_IDX = ID_WEP_QRF;
string DAT_QRFL_NAME = "Quantum Rifle";


void() data_wep_qrfl;

void() data_wep_qrfl={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_QRFL_IDX;
    self.dmg_amt = DAT_QRFL_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_QRFL_NAME;
    self.w_name = DAT_QRFL_NAME;
    self.w_clipsize = DAT_QRFL_CLIPSIZE;
    self.w_firerate = DAT_QRFL_FIRERATE;
    self.w_reloadtime = DAT_QRFL_EN_MAX / 100;
    self.en_max = DAT_QRFL_EN_COST;
    self.i_techlvl = DAT_QRFL_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL | EFF_STX;
    self.i_size = DAT_QRFL_WSIZE;
    self.w_abbr = "QRF";
    self.note1 = "Affects Shields Only.";
    self.note2 = "Instant-impact weapon.";
    self.note3 = "8 submunitions.";
    self.w_icon = UI_WEP_QRF;
    self.w_range = DAT_QRFL_RANGE;
  self = oself;
};

