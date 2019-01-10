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

string DAT_foslager_PITCH_N = "-25";
string DAT_foslager_PITCH_X = "45";

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
  self.data_type = DATA_VEHC;
  self.health = DAT_foslager_HP;
  self.max_health = DAT_foslager_HP;
  self.radar_range = DAT_foslager_RADAR_RANGE;
  self.i_techlvl= DAT_foslager_TECH_LEVEL;
  self.en_cur= DAT_foslager_ENERGY_MAX;
  self.en_max= DAT_foslager_ENERGY_MAX;
  self.en_rate= DAT_foslager_ENERGY_RATE;
  self.sh_cur= DAT_foslager_SHIELD_MAX;
  self.sh_max= DAT_foslager_SHIELD_MAX;
  self.sh_rate= DAT_foslager_SHIELD_RATE;
  self.m_rot_speed = DAT_foslager_YAW_SPEED;
  self.c_model = DAT_foslager_MDL_CHASSIS;
  self.m_fspeed = DAT_foslager_FSPEED;
  self.m_sspeed = DAT_foslager_SSPEED;
  self.m_bspeed = DAT_foslager_BSPEED;
  self.m_pitch_max = DAT_foslager_PITCH_N;
  self.m_pitch_min = DAT_foslager_PITCH_X;
 
  setsize(self, DAT_foslager_CTOR_BBX_N, DAT_foslager_CTOR_BBX_X);
  setorigin(self, self.origin);
  
  //unit variants
  if( (self.flags & FL_MONSTER) ){
    //brawler
    if( self.style == TYPE_BRAWL ){
     if( skill < 2 ){
        //MIS | LATC | LAS
        ai_ini_weapons( 4, 1, 3, -1, -1, -1, -1, -1, -1);
      }
      else if( skill == 2 ){
        //MLG | LATC | LAS
        ai_ini_weapons( 9, 1, 3, -1, -1, -1, -1, -1, -1);
      }
      else if( skill == 3 ){
        //ION | LATC | FLAK
        ai_ini_weapons( 13, 1, 12, -1, -1, -1, -1, -1, -1);
      } 
    }
  }
};

void() data_foslager_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = DAT_foslager_CTOR_MODEL;
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 10.5 -3.75';
};

void() data_foslager_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_foslager_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};

void() data_foslager_wep3={  
  self.c_parent = M_LEGS;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_foslager_WEP3_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON3;
};

void() data_foslager_cam={ 
  self.comp_id = M_TOR_CENTER;
  self.c_ofs = DAT_foslager_CAM_OFFSET;
  self.c_alt_ofs = DAT_foslager_CAM_OFFSET_ALT;
  self.c_model = DAT_foslager_CAM_MODEL;
};