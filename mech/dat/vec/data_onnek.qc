/*
mech Mod
Author: Peter Roohr
Date: 11/5/2017
Overview:
  name    : Tank - Destroyer
  faction : Human Survivors
  type    : vehicle
  size    : medium
*/

float DAT_onnek_PITCH_N = -25;
float DAT_onnek_PITCH_X = 45;

vector DAT_onnek_CAM_OFFSET = '-5 3 10';
vector DAT_onnek_CAM_OFFSET_ALT = '0 0 0';
  
void() data_onnek_ini;
void() data_onnek_cam;
void() data_onnek_wep1;

void() data_onnek_ini={
  self.unit_wep1 = data_onnek_wep1;
  self.unit_cam = data_onnek_cam;
    
  self.data_idx= ID_VEC_onnek;
  self.vec_name= DAT_onnek_VEC_NAME;
  self.vec_size = DAT_onnek_SIZE;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_onnek_RADAR_RANGE;
  self.techLevel= DAT_onnek_TECH_LEVEL;
  
  self.partTypeId = M_TOR_CENTER;
  self.health = DAT_onnek_HP_CTOR;
  self.max_health = DAT_onnek_HP_CTOR;
  self.c_model = DAT_onnek_CTOR_MODEL;
  setsize(self, DAT_onnek_CTOR_BBX_N, DAT_onnek_CTOR_BBX_X);
  
  self.energy= DAT_onnek_ENERGY_MAX;
  self.energyMax= DAT_onnek_ENERGY_MAX;
  self.energyRate= DAT_onnek_ENERGY_RATE;
  self.shieldMax= DAT_onnek_SHIELD_MAX;
  self.shieldRate= DAT_onnek_SHIELD_RATE;
  self.yaw_speed = DAT_onnek_YAW_SPEED;
  self.data_speed_forward = DAT_onnek_FSPEED;
  self.data_speed_strafe = DAT_onnek_SSPEED;
  self.data_speed_backward = DAT_onnek_BSPEED;
  self.pitchMax = DAT_onnek_PITCH_N;
  self.pitchMin = DAT_onnek_PITCH_X;
  self.w_firetime = DAT_onnek_LOCK_ON;
};

void() data_onnek_cam={
  self.partTypeId = M_TOR_CENTER;
  self.c_ofs = DAT_onnek_CAM_OFFSET;
  self.c_alt_ofs = DAT_onnek_CAM_OFFSET_ALT;
  self.c_model = "q3mdl/testball.md3";
};

void() data_onnek_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_onnek_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};