/*
mech Mod
Author: Subject9x
Date: 02/14/2017
Overview:
  name: Hevidahl
  type: mech
  size: heavy
*/

//MATOK MECH=============================
float DAT_HVD_IDX = ID_MCH_COLOSSUS;
string DAT_HVD_VEC_NAME = "Hevidahl";
float DAT_HVD_TECH_LEVEL = 1;
float DAT_HVD_RADAR_RANGE = 2000;
float DAT_HVD_RESERVE_COST = 200;
float DAT_HVD_ENERGY_CUR = 1200;
float DAT_HVD_ENERGY_MAX = 1200;
float DAT_HVD_ENERGY_RATE = 2;
float DAT_HVD_SHIELD_CUR = 1200;
float DAT_HVD_SHIELD_MAX = 1200;
float DAT_HVD_SHIELD_RATE = 0.35;
vector DAT_HVD_CTOR_BBX_N ='-20 -20 -50';
vector DAT_HVD_CTOR_BBX_X ='20 20 14';
string DAT_HVD_CPIT_MODEL = "q3mdl/mechs/hvd/mdl_hvd_cpt.md3";
float DAT_HVD_M_FSPEED=150;
float DAT_HVD_M_SSPEED=150;
float DAT_HVD_M_BSPEED=100;

vector DAT_HVD_SPREAD_N = '8 6 0.01';
vector DAT_HVD_SPREAD_X = '14 10 0.03';

//HITPOINT VALUES
float DAT_HVD_CTOR_HP = 1200;
float DAT_HVD_CTOR_HPMAX= 1200;
float DAT_HVD_LEG_HP = 1500;
float DAT_HVD_LEG_HPMAX= 1500;
float DAT_HVD_LTOR_HP = 1200;
float DAT_HVD_LTOR_HPMAX= 1200;
float DAT_HVD_RTOR_HP = 1200;
float DAT_HVD_RTOR_HPMAX= 1200;
float DAT_HVD_LARM_HP = 1000;
float DAT_HVD_LARM_HPMAX= 1000;
float DAT_HVD_RARM_HP = 1000;
float DAT_HVD_RARM_HPMAX= 1000;

//ARMOR VALUES
float DAT_HVD_CTOR_ARMOR= 100;
float DAT_HVD_CTOR_ARMMAX= 100;
float DAT_HVD_RARM_ARMOR= 100;
float DAT_HVD_RARM_ARMMAX= 100;
float DAT_HVD_LARM_ARMOR= 100;
float DAT_HVD_LARM_ARMMAX= 100;
float DAT_HVD_RTOR_ARMOR= 100;
float DAT_HVD_RTOR_ARMMAX= 100;
float DAT_HVD_LTOR_ARMOR= 100;
float DAT_HVD_LTOR_ARMMAX= 100;
float DAT_HVD_LEG_ARMOR= 100;
float DAT_HVD_LEG_ARMMAX= 100;

//WEAOPON GROUPS
float DAT_HVD_WEP1_IDX= ID_WEP_LATC;
float DAT_HVD_WEP2_IDX= ID_WEP_LAS;
float DAT_HVD_WEP3_IDX= ID_WEP_LATC;
float DAT_HVD_WEP4_IDX= ID_WEP_LAS;
float DAT_HVD_WEP5_IDX= ID_WEP_EMP;
float DAT_HVD_WEP6_IDX= ID_WEP_EMP;
float DAT_HVD_WEP7_IDX= ID_WEP_MIS;
float DAT_HVD_WEP8_IDX= ID_WEP_MIS;
float DAT_HVD_WEP9_IDX= ID_WEP_MIS;
float DAT_HVD_WEP1_GROUP= 1;


//this is mostly cosmetics
string DAT_HVD_CTOR_MODEL= "q3mdl/mechs/hvd/mdl_hvd_t_cent.md3";
float DAT_HVD_M_ACCEL= 0.0005;
string DAT_HVD_M_ROLLANGLE="2.25";
string DAT_HVD_M_PITCH_N="90";
string DAT_HVD_M_PITCH_X="-90";
string DAT_HVD_M_BOB = "0.5";
string DAT_HVD_M_BCYCLE =  "0.85";
string DAT_HVD_M_BUP = "0.5";
string DAT_HVD_M_BMODEL = "1";
string DAT_HVD_M_BSIDE = "0.65";
string DAT_HVD_M_BSPD = "3.85";

//LEGS
string DAT_HVD_LEG_CNAME= M_LEGS;
string DAT_HVD_LEG_MODEL= "q3mdl/mechs/hvd/mdl_hvd_legs.md3";
vector DAT_HVD_LEG_OFFSET= '0 -30 0';

//CENTER TORSO
string DAT_HVD_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_HVD_LTOR_CNAME= M_TOR_LEFT;
string DAT_HVD_LTOR_CPARENT= M_TOR_CENTER;

string DAT_HVD_LTOR_MODEL= "q3mdl/mechs/hvd/mdl_hvd_t_left.md3";
vector DAT_HVD_LTOR_OFFSET= '-10 0 -1.5';

//RIGHT TORSO
string DAT_HVD_RTOR_CNAME= M_TOR_RIGHT;
string DAT_HVD_RTOR_CPARENT= M_TOR_CENTER; 

string DAT_HVD_RTOR_MODEL= "q3mdl/mechs/hvd/mdl_hvd_t_right.md3";
vector DAT_HVD_RTOR_OFFSET= '10 0 -1.5';

//LEFT ARM 
string DAT_HVD_LARM_CNAME= M_ARM_LEFT;
string DAT_HVD_LARM_CPARENT= M_TOR_LEFT;

string DAT_HVD_LARM_MODEL= "q3mdl/mechs/hvd/mdl_hvd_l_arm.md3";
vector DAT_HVD_LARM_OFFSET= '-18 0 3';

//RIGHT ARM
string DAT_HVD_RARM_CNAME= M_ARM_RIGHT;
string DAT_HVD_RARM_CPARENT= M_TOR_RIGHT;

string DAT_HVD_RARM_MODEL= "q3mdl/mechs/hvd/mdl_hvd_r_arm.md3";
vector DAT_HVD_RARM_OFFSET= '18 0 3';

//CAMERA
string DAT_HVD_CAM_CNAME= "camera";
string DAT_HVD_CAM_MODEL= "q3mdl/testball.md3";
vector DAT_HVD_CAM_OFFSET= '0 8 7';
vector DAT_HVD_CAM_OFFSET_ALT= '0 1 0';

//WEAPON1
string DAT_HVD_WEP1_CPARENT= M_ARM_RIGHT;
vector DAT_HVD_WEP1_OFFSET= '3 -6 14';
vector DAT_HVD_WEP1_OFFSET_ALT= DAT_HVD_RARM_OFFSET;
vector DAT_HVD_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_HVD_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_HVD_WEP2_OFFSET= '0 -8 14';
vector DAT_HVD_WEP2_OFFSET_ALT= DAT_HVD_RARM_OFFSET;
vector DAT_HVD_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_HVD_WEP3_CPARENT= M_ARM_LEFT;
vector DAT_HVD_WEP3_OFFSET= '-3 -6 14';
vector DAT_HVD_WEP3_OFFSET_ALT= DAT_HVD_LARM_OFFSET;
vector DAT_HVD_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_HVD_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_HVD_WEP4_OFFSET= '0 -8 14';
vector DAT_HVD_WEP4_OFFSET_ALT= DAT_HVD_LARM_OFFSET;
vector DAT_HVD_WEP4_ADJ_ANG= '0 0 0';

//WEAPON5
string DAT_HVD_WEP5_CPARENT= M_TOR_RIGHT;
vector DAT_HVD_WEP5_OFFSET= '0 9 6';
vector DAT_HVD_WEP5_OFFSET_ALT= DAT_HVD_RTOR_OFFSET;
vector DAT_HVD_WEP5_ADJ_ANG= '0 0 0';

//WEAPON6
string DAT_HVD_WEP6_CPARENT= M_TOR_LEFT;
vector DAT_HVD_WEP6_OFFSET= '0 9 6';
vector DAT_HVD_WEP6_OFFSET_ALT= DAT_HVD_LTOR_OFFSET;
vector DAT_HVD_WEP6_ADJ_ANG= '0 0 0';

//WEAPON7
string DAT_HVD_WEP7_CPARENT= M_TOR_CENTER;
vector DAT_HVD_WEP7_OFFSET= '0 -6 4';
vector DAT_HVD_WEP7_OFFSET_ALT= '0 0 0';
vector DAT_HVD_WEP7_ADJ_ANG= '0 0 0';

//WEAPON8
string DAT_HVD_WEP8_CPARENT= M_TOR_RIGHT;
vector DAT_HVD_WEP8_OFFSET= '10 -3 2';
vector DAT_HVD_WEP8_OFFSET_ALT= '0 0 0';
vector DAT_HVD_WEP8_ADJ_ANG= '0 0 0';

//WEAPON9
string DAT_HVD_WEP9_CPARENT= M_TOR_LEFT;
vector DAT_HVD_WEP9_OFFSET= '-10 -3 2';
vector DAT_HVD_WEP9_OFFSET_ALT= '0 0 0';
vector DAT_HVD_WEP9_ADJ_ANG= '0 0 0';


//=========================================
void() data_mech_hvd;
void() data_hvd_ini;
void() data_hvd_legs;
void() data_hvd_ctor;
void() data_hvd_ltor;
void() data_hvd_rtor;
void() data_hvd_larm;
void() data_hvd_rarm;
void() data_hvd_cam;
void() data_hvd_wep1;
void() data_hvd_wep2;
void() data_hvd_wep3;
void() data_hvd_wep4;
void() data_hvd_wep5;
void() data_hvd_wep6;
void() data_hvd_wep7;
void() data_hvd_wep8;
void() data_hvd_wep9;

//call this guy at the start of the world ini
void() data_mech_hvd={
  local entity HVD, oself;
  HVD = spawn();
  oself = self;
  self = HVD;
    self.data_idx = DAT_HVD_IDX;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_name = DAT_HVD_VEC_NAME;
    self.unit_ini = data_hvd_ini;
    self.unit_legs = data_hvd_legs;
    self.unit_ltor = data_hvd_ltor;
    self.unit_ctor = data_hvd_ctor;
    self.unit_rtor = data_hvd_rtor;
    self.unit_larm = data_hvd_larm;
    self.unit_rarm = data_hvd_rarm;
    self.unit_cam = data_hvd_cam;
    self.unit_wep1 = data_hvd_wep1;
    self.unit_wep2 = data_hvd_wep2;
    self.unit_wep3 = data_hvd_wep3;
    self.unit_wep4 = data_hvd_wep4;
    self.unit_wep5 = data_hvd_wep5;
    self.unit_wep6 = data_hvd_wep6;
    self.unit_wep7 = data_hvd_wep7;
    self.unit_wep8 = data_hvd_wep8;
    self.unit_wep9 = data_hvd_wep9;
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;    
    self.w_group2 = self.w_group2 | WEAPON5 | WEAPON6;    
    self.w_group3 = self.w_group3 | WEAPON7 | WEAPON8 | WEAPON9;
    self.w_group4 = self.w_group4;
    self.w_group5 = self.w_group5;
  self = oself;
};

void() data_hvd_ini={
  self.data_idx= DAT_HVD_IDX;
  self.vec_name= DAT_HVD_VEC_NAME;
  self.data_type = DATA_MECH;
  self.radar_range = DAT_HVD_RADAR_RANGE;
  self.i_techlvl= DAT_HVD_TECH_LEVEL;
  self.i_reserve= DAT_HVD_RESERVE_COST;
  self.en_cur= DAT_HVD_ENERGY_CUR;
  self.en_max= DAT_HVD_ENERGY_MAX;
  self.en_rate= DAT_HVD_ENERGY_RATE;
  self.sh_cur= DAT_HVD_SHIELD_CUR;
  self.sh_max= DAT_HVD_SHIELD_MAX;
  self.sh_rate= DAT_HVD_SHIELD_RATE;
  self.c_bbx_n = DAT_HVD_CTOR_BBX_N;
  self.c_bbx_x = DAT_HVD_CTOR_BBX_X;
  self.c_model = DAT_HVD_CTOR_MODEL;
  self.weaponmodel = DAT_HVD_CPIT_MODEL;
  self.weaponframe = 0;
  self.conv_min = DAT_HVD_SPREAD_N; 
  self.conv_max = DAT_HVD_SPREAD_X; 
  self.m_fspeed = DAT_HVD_M_FSPEED;
  self.m_sspeed = DAT_HVD_M_SSPEED;
  self.m_bspeed = DAT_HVD_M_BSPEED;
  self.m_maccel = DAT_HVD_M_ACCEL;
  self.m_rollangle = DAT_HVD_M_ROLLANGLE;
  self.m_pitch_max = DAT_HVD_M_PITCH_N;
  self.m_pitch_min = DAT_HVD_M_PITCH_X;
  self.m_bob = DAT_HVD_M_BOB;
  self.m_bcycle = DAT_HVD_M_BCYCLE;
  self.m_bup = DAT_HVD_M_BUP;
  self.m_bmodel = DAT_HVD_M_BMODEL;
  self.m_bside = DAT_HVD_M_BSIDE;
  self.m_bobspd = DAT_HVD_M_BSPD;
};

void() data_hvd_legs={
  self.c_name = DAT_HVD_LEG_CNAME;
  self.health = DAT_HVD_LEG_HP;
  self.max_health = DAT_HVD_LEG_HPMAX;
  self.armorvalue = DAT_HVD_LEG_ARMOR;
  self.max_armor = DAT_HVD_LEG_ARMMAX;
  self.c_model = DAT_HVD_LEG_MODEL;
  self.c_ofs = DAT_HVD_LEG_OFFSET;
};

void() data_hvd_ctor={
  self.c_name = DAT_HVD_CTOR_CNAME;
  self.health = DAT_HVD_CTOR_HP;
  self.max_health = DAT_HVD_CTOR_HPMAX;
  self.armorvalue = DAT_HVD_CTOR_ARMOR;
  self.max_armor = DAT_HVD_CTOR_ARMMAX;
  self.c_model = DAT_HVD_CTOR_MODEL;
};

void() data_hvd_ltor={
  self.c_name = DAT_HVD_LTOR_CNAME;
  self.c_parent = DAT_HVD_LTOR_CPARENT;
  self.health = DAT_HVD_LTOR_HP;
  self.max_health = DAT_HVD_LTOR_HPMAX;
  self.armorvalue = DAT_HVD_LTOR_ARMOR;
  self.max_armor = DAT_HVD_LTOR_ARMMAX;
  self.c_model = DAT_HVD_LTOR_MODEL;
  self.c_ofs = DAT_HVD_LTOR_OFFSET;
};
void() data_hvd_rtor={
  self.c_name = DAT_HVD_RTOR_CNAME;
  self.c_parent = DAT_HVD_RTOR_CPARENT;
  self.health = DAT_HVD_RTOR_HP;
  self.max_health = DAT_HVD_RTOR_HPMAX;
  self.armorvalue = DAT_HVD_RTOR_ARMOR;
  self.max_armor = DAT_HVD_RTOR_ARMMAX;
  self.c_model = DAT_HVD_RTOR_MODEL;
  self.c_ofs = DAT_HVD_RTOR_OFFSET;
};
void() data_hvd_larm={  
  self.c_name = DAT_HVD_LARM_CNAME;
  self.c_parent = DAT_HVD_LARM_CPARENT;
  self.health = DAT_HVD_LARM_HP;
  self.max_health = DAT_HVD_LARM_HPMAX;
  self.armorvalue = DAT_HVD_LARM_ARMOR;
  self.max_armor = DAT_HVD_LARM_ARMMAX;
  self.c_model = DAT_HVD_LARM_MODEL;
  self.c_ofs = DAT_HVD_LARM_OFFSET;
};
void() data_hvd_rarm={  
  self.c_name = DAT_HVD_RARM_CNAME;
  self.c_parent = DAT_HVD_RARM_CPARENT;
  self.health = DAT_HVD_RARM_HP;
  self.max_health = DAT_HVD_RARM_HPMAX;
  self.armorvalue = DAT_HVD_RARM_ARMOR;
  self.max_armor = DAT_HVD_RARM_ARMMAX;
  self.c_model = DAT_HVD_RARM_MODEL;
  self.c_ofs = DAT_HVD_RARM_OFFSET;
};
void() data_hvd_cam={  
  self.c_name = DAT_HVD_CAM_CNAME;
  self.c_ofs = DAT_HVD_CAM_OFFSET;
  self.c_alt_ofs = DAT_HVD_CAM_OFFSET_ALT;
  self.c_model = DAT_HVD_CAM_MODEL;
};
void() data_hvd_wep1={  
  self.c_parent = DAT_HVD_WEP1_CPARENT;
  self.data_idx = DAT_HVD_WEP1_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP1_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_hvd_wep2={  
  self.c_parent = DAT_HVD_WEP2_CPARENT;
  self.data_idx = DAT_HVD_WEP2_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP2_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};
void() data_hvd_wep3={  
  self.c_parent = DAT_HVD_WEP3_CPARENT;
  self.data_idx = DAT_HVD_WEP3_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP3_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP3_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP3_ADJ_ANG;
  self.w_group = WEAPON3;
};
void() data_hvd_wep4={  
  self.c_parent = DAT_HVD_WEP4_CPARENT;
  self.data_idx = DAT_HVD_WEP4_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP4_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP4_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP4_ADJ_ANG;
  self.w_group = WEAPON4;
};
void() data_hvd_wep5={  
  self.c_parent = DAT_HVD_WEP5_CPARENT;
  self.data_idx = DAT_HVD_WEP5_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP5_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP5_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP5_ADJ_ANG;
  self.w_group = WEAPON5;
};
void() data_hvd_wep6={  
  self.c_parent = DAT_HVD_WEP6_CPARENT;
  self.data_idx = DAT_HVD_WEP6_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP6_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP6_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP6_ADJ_ANG;
  self.w_group = WEAPON6;
};
void() data_hvd_wep7={  
  self.c_parent = DAT_HVD_WEP7_CPARENT;
  self.data_idx = DAT_HVD_WEP7_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP7_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP7_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP7_ADJ_ANG;
  self.w_group = WEAPON7;
};
void() data_hvd_wep8={  
  self.c_parent = DAT_HVD_WEP8_CPARENT;
  self.data_idx = DAT_HVD_WEP8_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP8_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP8_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP8_ADJ_ANG;
  self.w_group = WEAPON8;
};
void() data_hvd_wep9={  
  self.c_parent = DAT_HVD_WEP9_CPARENT;
  self.data_idx = DAT_HVD_WEP9_IDX; //consult weapon idx table!
  self.c_ofs = DAT_HVD_WEP9_OFFSET;
  self.c_alt_ofs = DAT_HVD_WEP9_OFFSET_ALT;
  self.w_adj_ang = DAT_HVD_WEP9_ADJ_ANG;
  self.w_group = WEAPON9;
};