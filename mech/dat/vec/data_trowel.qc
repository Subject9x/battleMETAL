/*
mech Mod
Author: Peter Roohr
Date: 09/22/2018
Overview:
  name    : TROWEL
  faction : Human Survivors | Mil
  type    : vehicle
  size    : large
*/

//HUMAN SURVIVORS TANK LIGHT=============================

string DAT_TROWEL_PITCH_N = "-25";
string DAT_TROWEL_PITCH_X = "45";

//CAMERA
float DAT_TROWEL_CAM_CNAME= -1;
vector DAT_TROWEL_CAM_OFFSET= '0 0 0';
vector DAT_TROWEL_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_TROWEL_ini;
void() data_TROWEL_ctor;
void() data_TROWEL_cam;
void() data_TROWEL_wep1;
void() data_TROWEL_wep2;
void() data_TROWEL_wep3;

void() data_TROWEL_ini={
  self.unit_ctor = data_TROWEL_ctor;
  self.unit_wep1 = data_TROWEL_wep1;
  self.unit_wep2 = data_TROWEL_wep2;
  self.unit_cam = data_TROWEL_cam;
    
  self.data_idx = ID_VEC_TROWEL;
  self.vec_name= DAT_TROWEL_NAME;
  self.data_type = DATA_VEHC;
  self.health = DAT_TROWEL_HP;
  self.max_health = DAT_TROWEL_HP;
  self.radar_range = DAT_TROWEL_RADAR_RANGE;
  self.i_techlvl= DAT_TROWEL_TECH_LEVEL;
  self.en_cur= DAT_TROWEL_ENERGY_MAX;
  self.en_max= DAT_TROWEL_ENERGY_MAX;
  self.en_rate= DAT_TROWEL_ENERGY_RATE;
  self.sh_cur= DAT_TROWEL_SHIELD_MAX;
  self.sh_max= DAT_TROWEL_SHIELD_MAX;
  self.sh_rate= DAT_TROWEL_SHIELD_RATE;
  self.m_rot_speed = DAT_TROWEL_YAW_SPEED;
  self.c_model = DAT_TROWEL_MDL_CHASSIS;
  self.m_fspeed = DAT_TROWEL_FSPEED;
  self.m_sspeed = DAT_TROWEL_SSPEED;
  self.m_bspeed = DAT_TROWEL_BSPEED;
  self.m_pitch_max = DAT_TROWEL_PITCH_N;
  self.m_pitch_min = DAT_TROWEL_PITCH_X;
 
  setsize(self, DAT_TROWEL_CTOR_BBX_N, DAT_TROWEL_CTOR_BBX_X);
  setorigin(self, self.origin);
  
  //unit variants
  if( (self.flags & FL_MONSTER) ){
    ai_ini_weapons( 7, 9, -1, -1, -1, -1, -1, -1, -1);
  }
};

void() data_TROWEL_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_TROWEL_CTOR_MODEL;
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 13.5 0';
};

void() data_TROWEL_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_TROWEL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_TROWEL_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_TROWEL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};

void() data_TROWEL_cam={ 
  self.comp_id = M_TOR_CENTER;
  self.c_ofs = DAT_TROWEL_CAM_OFFSET;
  self.c_alt_ofs = DAT_TROWEL_CAM_OFFSET_ALT;
  self.c_model = "q3mdl/testball.md3";
};