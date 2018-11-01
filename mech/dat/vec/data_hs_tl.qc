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

string DAT_HS_TANKL_PITCH_N = "-25";
string DAT_HS_TANKL_PITCH_X = "45";

//CAMERA
float DAT_HS_TANKL_CAM_CNAME= -1;
vector DAT_HS_TANKL_CAM_OFFSET= '0 0 0';
vector DAT_HS_TANKL_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_HS_TANKL_ini;
void() data_HS_TANKL_ctor;
void() data_HS_TANKL_cam;
void() data_HS_TANKL_wep1;
void() data_HS_TANKL_wep2;

void() data_HS_TANKL_ini={
  self.unit_ctor = data_HS_TANKL_ctor;
  self.unit_wep1 = data_HS_TANKL_wep1;
  self.unit_wep2 = data_HS_TANKL_wep2;
  self.unit_cam = data_HS_TANKL_cam;
    
  self.data_idx= ID_VEC_HS_TANK_L;
  self.vec_name= DAT_HS_TANKL_NAME;
  self.data_type = DATA_VEHC;
  self.health = DAT_H_TANKL_HP;
  self.max_health = DAT_H_TANKL_HP;
  self.radar_range = DAT_HS_TANKL_RADAR_RANGE;
  self.i_techlvl= DAT_HS_TANKL_TECH_LEVEL;
  self.en_cur= DAT_HS_TANKL_ENERGY_MAX;
  self.en_max= DAT_HS_TANKL_ENERGY_MAX;
  self.en_rate= DAT_HS_TANKL_ENERGY_RATE;
  self.sh_cur= DAT_HS_TANKL_SHIELD_MAX;
  self.sh_max= DAT_HS_TANKL_SHIELD_MAX;
  self.sh_rate= DAT_HS_TANKL_SHIELD_RATE;
  self.m_rot_speed = DAT_HS_TANKL_YAW_SPEED;
  self.c_model = DAT_HS_TANKL_MDL_CHASSIS;
  self.m_fspeed = DAT_HS_TANKL_FSPEED;
  self.m_sspeed = DAT_HS_TANKL_SSPEED;
  self.m_bspeed = DAT_HS_TANKL_BSPEED;
  self.m_pitch_max = DAT_HS_TANKL_PITCH_N;
  self.m_pitch_min = DAT_HS_TANKL_PITCH_X;
  setsize(self, '-20 -20 -10', '20 20 14');
  setorigin(self, self.origin);
};

void() data_HS_TANKL_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_HS_TANKL_CTOR_MODEL;
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 0 0';
};

void() data_HS_TANKL_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_TANKL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0 ';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_HS_TANKL_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_TANKL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};

void() data_HS_TANKL_cam={ 
  self.comp_id = M_TOR_CENTER;
  self.c_ofs = DAT_HS_TANKL_CAM_OFFSET;
  self.c_alt_ofs = DAT_HS_TANKL_CAM_OFFSET_ALT;
  self.c_model = DAT_HS_TANKL_CAM_MODEL;
};