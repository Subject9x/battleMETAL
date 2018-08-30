/*
mech Mod
Author: Peter Roohr
Date: 11/5/2017
Overview:
  name: Human medium tank
  type: vehicle
  size: mediums
*/

//HUMAN LIGHT TNKRET=============================
float DAT_H_TD_IDX = ID_VEC_HS_TDEST_L;
string DAT_H_TD_VEC_NAME = "Medium Tank";

float DAT_H_TD_YAWSPEED = 2.5;
vector DAT_H_TD_CTOR_BBX_N ='-20 -20 -10';
vector DAT_H_TD_CTOR_BBX_X ='20 20 14';

string DAT_H_TD_PITCH_N = "-25";
string DAT_H_TD_PITCH_X = "45";

//LEGS
string DAT_H_TD_LEG_CNAME= M_LEGS;

//CENTER TORSO
string DAT_H_TD_CTOR_CNAME= M_TOR_CENTER;

//WEAPON1
string DAT_H_TD_WEP1_CPARENT= M_TOR_CENTER;
vector DAT_H_TD_WEP1_OFFSET_ALT = '0 0 0';
vector DAT_H_TD_WEP1_ADJ_ANG= '0 0 90';

//CAMERA
string DAT_H_TD_CAM_CNAME= "camera";
vector DAT_H_TD_CAM_OFFSET= '0 0 0';
vector DAT_H_TD_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_H_TD_ini;
void() data_H_TD_ctor;
void() data_H_TD_cam;
void() data_H_TD_wep1;

void() data_H_TD_ini={
  self.unit_ctor = data_H_TD_ctor;
  self.unit_wep1 = data_H_TD_wep1;
  self.unit_cam = data_H_TD_cam;
    
  self.data_idx= DAT_H_TD_IDX;
  self.vec_name= DAT_H_TD_VEC_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_H_TD_RADAR_RANGE;
  self.i_techlvl= DAT_H_TD_TECH_LEVEL;
  self.en_cur= DAT_H_TD_ENERGY_MAX;
  self.en_max= DAT_H_TD_ENERGY_MAX;
  self.en_rate= DAT_H_TD_ENERGY_RATE;
  self.sh_cur= DAT_H_TD_SHIELD_MAX;
  self.sh_max= DAT_H_TD_SHIELD_MAX;
  self.sh_rate= DAT_H_TD_SHIELD_RATE;
  self.m_rot_speed = DAT_H_TD_YAWSPEED;
  self.c_bbx_n = DAT_H_TD_CTOR_BBX_N;
  self.c_bbx_x = DAT_H_TD_CTOR_BBX_X;
  self.c_model = DAT_H_TD_CTOR_MODEL;
  self.conv_min = DAT_H_TD_SPREAD_N; 
  self.conv_max = DAT_H_TD_SPREAD_X; 
  self.m_fspeed = DAT_H_TD_FSPEED;
  self.m_sspeed = DAT_H_TD_SSPEED;
  self.m_bspeed = DAT_H_TD_BSPEED;
  self.m_pitch_max = DAT_H_TD_PITCH_N;
  self.m_pitch_min = DAT_H_TD_PITCH_X;
};

void() data_H_TD_ctor={
  self.c_name = DAT_H_TD_CTOR_CNAME;
  self.health = DAT_H_TD_HP_CTOR;
  self.max_health = DAT_H_TD_HP_CTOR;
  self.c_model = DAT_H_TD_CTOR_MODEL;
};

void() data_H_TD_wep1={  
  self.c_parent = DAT_H_TD_WEP1_CPARENT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_H_TD_WEP1_OFFSET;
  self.c_alt_ofs = DAT_H_TD_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_H_TD_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};

void() data_H_TD_cam={ 
  self.c_name = DAT_H_TD_CAM_CNAME;
  self.c_ofs = DAT_H_TD_CAM_OFFSET;
  self.c_alt_ofs = DAT_H_TD_CAM_OFFSET_ALT;
  self.c_model = DAT_H_TD_CAM_MODEL;
};