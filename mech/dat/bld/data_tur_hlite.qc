/*
battleMETAL
Author: Peter Roohr
Date: 07/16/2018
Overview:
  AI Turret - Human Faction
  Light Turret
*/

void() data_tur_hlite_ini;
void() data_tur_hlite_ctor;
void() data_tur_hlite_cam;
void() data_tur_hlite_wep1;
void() data_tur_hlite_wep2;

void() data_tur_hlite_ini={
  self.unit_ctor = data_tur_hlite_ctor;
  self.unit_wep1 = data_tur_hlite_wep1;
  self.unit_wep2 = data_tur_hlite_wep2;
  self.unit_cam = data_tur_hlite_cam;

  self.data_idx= ID_TUR_HLITE;
  self.vec_name = DAT_TUR_HLITE_NAME;
  self.vec_size = 1;
  self.data_type = DATA_BLD;
  self.radar_range = DAT_TUR_HLITE_RADRANGE;
  self.energy= DAT_TUR_HLITE_EN_MAX;
  self.energyMax= DAT_TUR_HLITE_EN_MAX;
  self.energyRate= DAT_TUR_HLITE_EN_RATE;
  self.shield= DAT_TUR_HLITE_SH_MAX;
  self.shieldMax= DAT_TUR_HLITE_SH_MAX;
  self.shieldRate= DAT_TUR_HLITE_SH_RATE;
  self.yaw_speed = DAT_TUR_HLITE_YAWS;
  self.turret_yaw_speed = DAT_TUR_HLITE_TURRET_YAW;
  self.mins = DAT_TUR_HLITE_BBN;
  self.maxs = DAT_TUR_HLITE_BBX;
  self.ai_angleLimits = DAT_TUR_HLITE_PITCH;
  self.health = DAT_TUR_HLITE_HP;
  self.max_health = DAT_TUR_HLITE_HP;
  self.c_model = DAT_TUR_HLITE_BASE;
};

void() data_tur_hlite_ctor={
  self.partTypeId = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_TUR_HLITE_TUR;
  self.yaw_speed = 5;
  self.attack_state = 4;
  self.c_ofs = '0 8 0';
};

void() data_tur_hlite_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.c_ofs = DAT_TUR_HLITE_WEP1_OFFSET;
  self.c_alt_ofs = DAT_TUR_HLITE_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_TUR_HLITE_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_tur_hlite_wep2={  
  self.partParentId = M_TOR_CENTER;
  self.c_ofs = DAT_TUR_HLITE_WEP2_OFFSET;
  self.c_alt_ofs = DAT_TUR_HLITE_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_TUR_HLITE_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};

void() data_tur_hlite_cam={
  self.partParentId = M_TOR_CENTER;
  self.c_ofs = DAT_TUR_HLITE_CAM_OFFSET;
  self.c_alt_ofs = DAT_TUR_HLITE_CAM_OFFSET_ALT;
  self.c_model = DAT_TUR_HLITE_CAM;
};