/*
battleMETAL
Author: Peter Roohr
Date: 01/11/2019
Overview:
  name    : SORCERER
  faction : Human Survivors | Mil
  type    : vehicle
  size    : medium
*/

//HUMAN SURVIVORS TANK LIGHT=============================

float DAT_sorcerer_PITCH_N = -25;
float DAT_sorcerer_PITCH_X = 45;

//CAMERA
float DAT_sorcerer_CAM_CNAME= -1;
vector DAT_sorcerer_CAM_OFFSET= '0 0 0';
vector DAT_sorcerer_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_sorcerer_ini;
void() data_sorcerer_ctor;
void() data_sorcerer_cam;
void() data_sorcerer_wep1;
void() data_sorcerer_wep2;
void() data_sorcerer_wep3;

void() data_sorcerer_ini={
  self.unit_ctor = data_sorcerer_ctor;
  self.unit_wep1 = data_sorcerer_wep1;
  self.unit_wep2 = data_sorcerer_wep2;
  self.unit_cam = data_sorcerer_cam;
    
  self.data_idx = ID_VEC_sorcerer;
  self.vec_name= DAT_sorcerer_NAME;
  self.vec_size = DAT_sorcerer_SIZE;
  self.data_type = DATA_VEHC;
  self.health = DAT_sorcerer_HP;
  self.max_health = DAT_sorcerer_HP;
  self.radar_range = DAT_sorcerer_RADAR_RANGE;
  self.techLevel= DAT_sorcerer_TECH_LEVEL;
  self.energy= DAT_sorcerer_ENERGY_MAX;
  self.energyMax= DAT_sorcerer_ENERGY_MAX;
  self.energyRate= DAT_sorcerer_ENERGY_RATE;
  self.shieldMax= DAT_sorcerer_SHIELD_MAX;
  self.shieldRate= DAT_sorcerer_SHIELD_RATE;
  self.yaw_speed = DAT_sorcerer_YAW_SPEED;
  self.c_model = DAT_sorcerer_MODEL;
  self.data_speed_forward = DAT_sorcerer_FSPEED;
  self.data_speed_strafe = DAT_sorcerer_SSPEED;
  self.data_speed_backward = DAT_sorcerer_BSPEED;
  self.pitchMax = DAT_sorcerer_PITCH_N;
  self.pitchMin = DAT_sorcerer_PITCH_X;
  self.w_firetime = DAT_sorcerer_LOCK_ON;
  setsize(self, DAT_sorcerer_CTOR_BBX_N, DAT_sorcerer_CTOR_BBX_X);
  setorigin(self, self.origin);

};

void() data_sorcerer_ctor={
  self.partTypeId = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_sorcerer_MODEL;
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 13.5 0';
};

void() data_sorcerer_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_sorcerer_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_sorcerer_wep2={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_sorcerer_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};

void() data_sorcerer_cam={ 
  self.partTypeId = M_TOR_CENTER;
  self.c_ofs = DAT_sorcerer_CAM_OFFSET;
  self.c_alt_ofs = DAT_sorcerer_CAM_OFFSET_ALT;
  self.c_model = "q3mdl/testball.md3";
};