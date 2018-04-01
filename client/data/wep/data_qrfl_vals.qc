/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//QUANTUM RIFLE=======================
void() data_wep_qrfl;

void() data_wep_qrfl={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = ID_WEP_QRF;
    self.dmg_amt = DAT_QRFL_DMG;
    self.data_type = DATA_WEPN;
    self.w_name = DAT_QRF_NAME;
    self.w_clipsize = DAT_QRFL_CLIPSIZE;
    self.en_rate= DAT_QRFL_EN_RATE;
    self.rl_max = DAT_QRFL_RL_MAX;
    self.i_techlvl = DAT_QRFL_TECH_LEVEL;
    self.dmg_type = self.dmg_type | DMG_BAL;
    self.i_size = DAT_QRFL_WSIZE;
    self.w_abbr = "QRF";
    self.note1 = "Affects Shields Only. \n \n Instant-impact weapon. \n \n 8 submunitions.";
    self.w_icon = UI_WEP_QRF;
    self.w_range = DAT_QRFL_RANGE;
  self = oself;
};

