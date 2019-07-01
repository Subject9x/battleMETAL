/*
mech Mod
Author: Peter Roohr
Date: 09/22/2018
Overview:
  name    : Tank - Light
  faction : Human Survivors
  type    : vehicle
  size    : medium
*/

//HUMAN SURVIVORS TANK LIGHT=============================

float DAT_foslager_PITCH_N = -25;
float DAT_foslager_PITCH_X = 45;

//CAMERA
float DAT_foslager_CAM_CNAME= -1;
vector DAT_foslager_CAM_OFFSET= '0 0 0';
vector DAT_foslager_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_foslager_ini;
void() data_foslager_ctor;
void() data_foslager_cam;
void() data_foslager_wep1;
void() data_foslager_wep2;
void() data_foslager_wep3;

void() data_foslager_ini={
  self.unit_ctor = data_foslager_ctor;
  self.unit_wep1 = data_foslager_wep1;
  self.unit_wep2 = data_foslager_wep2;
  self.unit_wep3 = data_foslager_wep3;
  self.unit_cam = data_foslager_cam;
    
  self.data_idx= ID_VEC_foslager;
  self.vec_name= DAT_foslager_NAME;
  self.vec_size = DAT_foslager_SIZE;
  self.data_type = DATA_VEHC;
  self.health = DAT_foslager_HP;
  self.max_health = DAT_foslager_HP;
  self.radar_range = DAT_foslager_RADAR_RANGE;
  self.techLevel= DAT_foslager_TECH_LEVEL;
  self.energy= DAT_foslager_ENERGY_MAX;
  self.energyMax= DAT_foslager_ENERGY_MAX;
  self.energyRate= DAT_foslager_ENERGY_RATE;
  self.shieldMax= DAT_foslager_SHIELD_MAX;
  self.shieldRate= DAT_foslager_SHIELD_RATE;
  self.yaw_speed = DAT_foslager_YAW_SPEED;
  self.turret_yaw_speed = DAT_foslager_TUR_YAW;
  self.c_model = DAT_foslager_MDL_CHASSIS;
  self.data_speed_forward = DAT_foslager_FSPEED;
  self.data_speed_strafe = DAT_foslager_SSPEED;
  self.data_speed_backward = DAT_foslager_BSPEED;
  self.pitchMax = DAT_foslager_PITCH_N;
  self.pitchMin = DAT_foslager_PITCH_X;
  self.w_firetime = DAT_foslager_LOCK_ON;
  setsize(self, DAT_foslager_CTOR_BBX_N, DAT_foslager_CTOR_BBX_X);
  setorigin(self, self.origin);
};

void() data_foslager_ctor={
  self.partTypeId = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_foslager_CTOR_MODEL;
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 10.5 -3.75';
};

void() data_foslager_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_foslager_wep2={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};

void() data_foslager_wep3={  
  self.partParentId = M_LEGS;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP3_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON3;
};

void() data_foslager_cam={ 
  self.partTypeId = M_TOR_CENTER;
  self.c_ofs = DAT_foslager_CAM_OFFSET;
  self.c_alt_ofs = DAT_foslager_CAM_OFFSET_ALT;
  self.c_model = DAT_foslager_CAM_MODEL;
};