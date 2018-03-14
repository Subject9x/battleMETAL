/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: Balaket
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//OUTLAW MECH=============================
string DAT_OTL_VEC_NAME = "Balaket";
float DAT_OTL_RESERVE_COST = 100;
float DAT_OTL_YAWSPEED = 6;
vector DAT_OTL_CTOR_BBX_N ='-14 -14 -35';
vector DAT_OTL_CTOR_BBX_X ='14 14 16';

float DAT_OTL_WEP1_IDX= ID_WEP_LATC;
float DAT_OTL_WEP2_IDX= ID_WEP_LATC;
float DAT_OTL_WEP3_IDX= ID_WEP_EMP;

float DAT_OTL_WEP1_GROUP= 1;
float DAT_OTL_WEP2_GROUP= 1;
float DAT_OTL_WEP3_GROUP= 2;

string DAT_OTL_M_ROLLANGLE  = "2";
string DAT_OTL_M_PITCH_N    = "90";
string DAT_OTL_M_PITCH_X    = "-90";
string DAT_OTL_M_BOB        = "0.0008";
string DAT_OTL_M_BCYCLE     = "0.5";
string DAT_OTL_M_BUP        = "0.15";
string DAT_OTL_M_BMODEL     = "1";
string DAT_OTL_M_BSIDE      = "0.09";
string DAT_OTL_M_BSPD       = "6";

//LEGS
string DAT_OTL_LEG_CNAME= M_LEGS;

//CENTER TORSO
string DAT_OTL_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_OTL_LTOR_CNAME= M_TOR_LEFT;
string DAT_OTL_LTOR_CPARENT= M_TOR_CENTER;

//RIGHT TORSO
string DAT_OTL_RTOR_CNAME= M_TOR_RIGHT;
string DAT_OTL_RTOR_CPARENT= M_TOR_CENTER; 

//LEFT ARM 
string DAT_OTL_LARM_CNAME= M_ARM_LEFT;
string DAT_OTL_LARM_CPARENT= M_TOR_LEFT;


//RIGHT ARM
string DAT_OTL_RARM_CNAME= M_ARM_RIGHT;
string DAT_OTL_RARM_CPARENT= M_TOR_RIGHT;

//CAMERA
string DAT_OTL_CAM_CNAME= "camera";

//WEAPON1
string DAT_OTL_WEP1_CPARENT= M_ARM_LEFT;
vector DAT_OTL_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_OTL_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_OTL_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_OTL_WEP3_CPARENT= M_TOR_CENTER;
vector DAT_OTL_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP3_ADJ_ANG= '0 0 0';

//=========================================
void() data_otl_legs;
void() data_otl_ctor;
void() data_otl_ltor;
void() data_otl_rtor;
void() data_otl_larm;
void() data_otl_rarm;
void() data_otl_cam;
void() data_otl_wep1;
void() data_otl_wep2;
void() data_otl_wep3;

void() data_otl_ini={
  self.unit_legs = data_otl_legs;
  self.unit_ctor = data_otl_ctor;
  self.unit_ltor = data_otl_ltor;
  self.unit_rtor = data_otl_rtor;
  self.unit_larm = data_otl_larm;
  self.unit_rarm = data_otl_rarm;
  self.unit_cam = data_otl_cam;
  self.unit_wep1 = data_otl_wep1;
  self.unit_wep2 = data_otl_wep2;
  self.unit_wep3 = data_otl_wep3;

  self.data_idx= ID_MCH_BALAKET;
  self.vec_size = SZ_MCH_BALAKET;
  self.vec_name= DAT_OTL_VEC_NAME;
  self.data_type = DATA_MECH;
  self.radar_range = DAT_OTL_RADAR_RANGE;
  self.i_techlvl= DAT_OTL_TECH_LEVEL;
  self.i_reserve= DAT_OTL_RESERVE_COST;
  self.en_cur= DAT_OTL_ENERGY_MAX;
  self.en_max= DAT_OTL_ENERGY_MAX;
  self.en_rate= DAT_OTL_ENERGY_RATE;
  self.sh_cur= DAT_OTL_SHIELD_MAX;
  self.sh_max= DAT_OTL_SHIELD_MAX;
  self.sh_rate= DAT_OTL_SHIELD_RATE;
  self.c_bbx_n = DAT_OTL_CTOR_BBX_N;
  self.c_bbx_x = DAT_OTL_CTOR_BBX_X;
  self.c_model = DAT_OTL_CTOR_MODEL;
  if( (self.flags & FL_CLIENT) ){
    self.weaponmodel = DAT_OTL_CPIT_MODEL;
    self.weaponframe = 0;  
  }
  self.conv_min = DAT_OTL_SPREAD_N; 
  self.conv_max = DAT_OTL_SPREAD_X;
  self.m_rot_speed = DAT_OTL_YAWSPEED;
  self.m_fspeed = DAT_OTL_M_FSPEED;
  self.m_sspeed = DAT_OTL_M_SSPEED;
  self.m_bspeed = DAT_OTL_M_BSPEED;
  self.m_maccel = DAT_OTL_M_ACCEL;
  self.m_rollangle = DAT_OTL_M_ROLLANGLE;
  self.m_pitch_max = DAT_OTL_M_PITCH_N;
  self.m_pitch_min = DAT_OTL_M_PITCH_X;
  self.m_bob = DAT_OTL_M_BOB;
  self.m_bcycle =  DAT_OTL_M_BCYCLE;
  self.m_bup = DAT_OTL_M_BUP;
  self.m_bmodel = DAT_OTL_M_BMODEL;
  self.m_bside = DAT_OTL_M_BSIDE;
  self.m_bobspd = DAT_OTL_M_BSPD;
  self.w_firetime = DAT_OTL_LOCK; //using this as 'lock on time;
  self.hardpoint_cnt = DAT_BLK_HARDPOINT_CNT;
};
void() data_otl_ctor={
  self.c_name = DAT_OTL_CTOR_CNAME;
  self.health = DAT_OTL_CTOR_HP;
  self.max_health = DAT_OTL_CTOR_HP;
  self.armorvalue = DAT_OTL_CTOR_ARMMAX;
  self.max_armor = DAT_OTL_CTOR_ARMMAX;
  self.c_model = DAT_OTL_CTOR_MODEL;
  self.w_proj = 3;
};
void() data_otl_legs={
  self.c_name = DAT_OTL_LEG_CNAME;
  self.health = DAT_OTL_LEG_HP;
  self.max_health = DAT_OTL_LEG_HP;
  self.armorvalue = DAT_OTL_LEG_ARMMAX;
  self.max_armor = DAT_OTL_LEG_ARMMAX;
  self.c_model = DAT_OTL_LEG_MODEL;
  self.c_ofs = DAT_OTL_LEG_OFFSET;
};
void() data_otl_ltor={
  self.c_name = DAT_OTL_LTOR_CNAME;
  self.c_parent = DAT_OTL_LTOR_CPARENT;
  self.health = DAT_OTL_LTOR_HP;
  self.max_health = DAT_OTL_LTOR_HP;
  self.armorvalue = DAT_OTL_LTOR_ARMMAX;
  self.max_armor = DAT_OTL_LTOR_ARMMAX;
  self.c_model = DAT_OTL_LTOR_MODEL;
  self.c_ofs = DAT_OTL_LTOR_OFFSET;
};
void() data_otl_rtor={
  self.c_name = DAT_OTL_RTOR_CNAME;
  self.c_parent = DAT_OTL_RTOR_CPARENT;
  self.health = DAT_OTL_RTOR_HP;
  self.max_health = DAT_OTL_RTOR_HP;
  self.armorvalue = DAT_OTL_RTOR_ARMMAX;
  self.max_armor = DAT_OTL_RTOR_ARMMAX;
  self.c_model = DAT_OTL_RTOR_MODEL;
  self.c_ofs = DAT_OTL_RTOR_OFFSET;
};
void() data_otl_larm={  
  self.c_name = DAT_OTL_LARM_CNAME;
  self.c_parent = DAT_OTL_LARM_CPARENT;
  self.health = DAT_OTL_LARM_HP;
  self.max_health = DAT_OTL_LARM_HP;
  self.armorvalue = DAT_OTL_LARM_ARMMAX;
  self.max_armor = DAT_OTL_LARM_ARMMAX;
  self.c_model = DAT_OTL_LARM_MODEL;
  self.c_ofs = DAT_OTL_LARM_OFFSET;
};
void() data_otl_rarm={  
  self.c_name = DAT_OTL_RARM_CNAME;
  self.c_parent = DAT_OTL_RARM_CPARENT;
  self.health = DAT_OTL_RARM_HP;
  self.max_health = DAT_OTL_RARM_HP;
  self.armorvalue = DAT_OTL_RARM_ARMMAX;
  self.max_armor = DAT_OTL_RARM_ARMMAX;
  self.c_model = DAT_OTL_RARM_MODEL;
  self.c_ofs = DAT_OTL_RARM_OFFSET;
};
void() data_otl_cam={  
  self.c_name = DAT_OTL_CAM_CNAME;
  self.c_ofs = DAT_OTL_CAM_OFFSET;
  self.c_alt_ofs = DAT_OTL_CAM_OFFSET_ALT;
  self.c_model = DAT_OTL_CAM_MODEL;
};
void() data_otl_wep1={  
  self.c_parent = DAT_OTL_WEP1_CPARENT;
  self.data_idx = DAT_OTL_WEP1_IDX; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP1_OFFSET;
  self.c_alt_ofs = DAT_OTL_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_OTL_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_otl_wep2={  
  self.c_parent = DAT_OTL_WEP2_CPARENT;
  self.data_idx = DAT_OTL_WEP2_IDX; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP2_OFFSET;
  self.c_alt_ofs = DAT_OTL_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_OTL_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};
void() data_otl_wep3={  
  self.c_parent = DAT_OTL_WEP3_CPARENT;
  self.data_idx = DAT_OTL_WEP3_IDX; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP3_OFFSET;
  self.c_alt_ofs = DAT_OTL_WEP3_OFFSET_ALT;
  self.w_adj_ang = DAT_OTL_WEP3_ADJ_ANG;
  self.w_group = WEAPON3;
};