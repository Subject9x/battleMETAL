/*
mech Mod
Author: Peter Roohr
Date: 02/14/2017
Overview:
  name: monitor
  type: mech
  size: heavy
*/

//MATOK MECH=============================
float DAT_MNT_IDX = ID_MCH_MONITOR;
string DAT_MNT_VEC_NAME = "Monitor";
float DAT_MNT_TECH_LEVEL = 1;
float DAT_MNT_RADAR_RANGE = 3000;
float DAT_MNT_LOCK = 7;
float DAT_MNT_RESERVE_COST = 200;
float DAT_MNT_ENERGY_CUR = 1200;
float DAT_MNT_ENERGY_MAX = 1200;
float DAT_MNT_ENERGY_RATE = 2;
float DAT_MNT_SHIELD_CUR = 600;
float DAT_MNT_SHIELD_MAX = 600;
float DAT_MNT_SHIELD_RATE = 0.35;
float DAT_MNT_YAWSPEED = 3;
vector DAT_MNT_CTOR_BBX_N ='-22 -22 -44';//'-20 -20 -44';
vector DAT_MNT_CTOR_BBX_X ='22 22 28';//'20 20 24';
string DAT_MNT_CPIT_MODEL = "q3mdl/mechs/mnt/mdl_mnt_cpt.md3";
float DAT_MNT_M_FSPEED=85;//v0.0.3
float DAT_MNT_M_SSPEED=85;//v0.0.3
float DAT_MNT_M_BSPEED=85;//v0.0.3
float DAT_MNT_M_ACCEL=2; //v0.0.3

vector DAT_MNT_SPREAD_N = '8 6 0.01';
vector DAT_MNT_SPREAD_X = '14 10 0.03';

//HITPOINT VALUES
float DAT_MNT_CTOR_HP = 1200;
float DAT_MNT_CTOR_HPMAX= 1200;
float DAT_MNT_LEG_HP = 1500;
float DAT_MNT_LEG_HPMAX= 1500;
float DAT_MNT_LTOR_HP = 1200;
float DAT_MNT_LTOR_HPMAX= 1200;
float DAT_MNT_RTOR_HP = 1200;
float DAT_MNT_RTOR_HPMAX= 1200;
float DAT_MNT_LARM_HP = 1000;
float DAT_MNT_LARM_HPMAX= 1000;
float DAT_MNT_RARM_HP = 1000;
float DAT_MNT_RARM_HPMAX= 1000;

//ARMOR VALUES
float DAT_MNT_CTOR_ARMOR= 100;
float DAT_MNT_CTOR_ARMMAX= 100;
float DAT_MNT_RARM_ARMOR= 100;
float DAT_MNT_RARM_ARMMAX= 100;
float DAT_MNT_LARM_ARMOR= 100;
float DAT_MNT_LARM_ARMMAX= 100;
float DAT_MNT_RTOR_ARMOR= 100;
float DAT_MNT_RTOR_ARMMAX= 100;
float DAT_MNT_LTOR_ARMOR= 100;
float DAT_MNT_LTOR_ARMMAX= 100;
float DAT_MNT_LEG_ARMOR= 100;
float DAT_MNT_LEG_ARMMAX= 100;

//WEAOPON GROUPS
float DAT_MNT_WEP1_IDX= ID_WEP_LATC;
float DAT_MNT_WEP2_IDX= ID_WEP_LAS;
float DAT_MNT_WEP3_IDX= ID_WEP_LATC;
float DAT_MNT_WEP4_IDX= ID_WEP_LAS;
float DAT_MNT_WEP5_IDX= ID_WEP_EMP;
float DAT_MNT_WEP6_IDX= ID_WEP_EMP;
float DAT_MNT_WEP7_IDX= ID_WEP_MIS;
float DAT_MNT_WEP8_IDX= ID_WEP_MIS;
float DAT_MNT_WEP9_IDX= ID_WEP_MIS;
float DAT_MNT_WEP1_GROUP= 1;


//this is mostly cosmetics
string DAT_MNT_CTOR_MODEL= "q3mdl/mechs/mnt/mdl_mnt_t_cent.md3";
string DAT_MNT_M_ROLLANGLE="2.25";
string DAT_MNT_M_PITCH_N="90";
string DAT_MNT_M_PITCH_X="-90";
string DAT_MNT_M_BOB = "0.03";
string DAT_MNT_M_BCYCLE =  "0.85";
string DAT_MNT_M_BUP = "0.5";
string DAT_MNT_M_BMODEL = "1";
string DAT_MNT_M_BSIDE = "0.65";
string DAT_MNT_M_BSPD = "3.85";

//LEGS
string DAT_MNT_LEG_CNAME= M_LEGS;
string DAT_MNT_LEG_MODEL= "q3mdl/mechs/mnt/mdl_mnt_legs.md3";
vector DAT_MNT_LEG_OFFSET= '0 -22 0';

//CENTER TORSO
string DAT_MNT_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_MNT_LTOR_CNAME= M_TOR_LEFT;
string DAT_MNT_LTOR_CPARENT= M_TOR_CENTER;

string DAT_MNT_LTOR_MODEL= "q3mdl/mechs/mnt/mdl_mnt_t_left.md3";
vector DAT_MNT_LTOR_OFFSET= '-11.5 15.5 0';

//RIGHT TORSO
string DAT_MNT_RTOR_CNAME= M_TOR_RIGHT;
string DAT_MNT_RTOR_CPARENT= M_TOR_CENTER; 

string DAT_MNT_RTOR_MODEL= "q3mdl/mechs/mnt/mdl_mnt_t_right.md3";
vector DAT_MNT_RTOR_OFFSET= '11.5 15.5 0';

//LEFT ARM 
string DAT_MNT_LARM_CNAME= M_ARM_LEFT;
string DAT_MNT_LARM_CPARENT= M_TOR_LEFT;

string DAT_MNT_LARM_MODEL= "q3mdl/mechs/mnt/mdl_mnt_l_arm.md3";
vector DAT_MNT_LARM_OFFSET= '-18 13 -1';

//RIGHT ARM
string DAT_MNT_RARM_CNAME= M_ARM_RIGHT;
string DAT_MNT_RARM_CPARENT= M_TOR_RIGHT;

string DAT_MNT_RARM_MODEL= "q3mdl/mechs/mnt/mdl_mnt_r_arm.md3";
vector DAT_MNT_RARM_OFFSET= '18 13 -1';

//CAMERA
string DAT_MNT_CAM_CNAME= "camera";
string DAT_MNT_CAM_MODEL= "q3mdl/testball.md3";
vector DAT_MNT_CAM_OFFSET= '0 15 8';
vector DAT_MNT_CAM_OFFSET_ALT= '0 1 0';

//WEAPON1
string DAT_MNT_WEP1_CPARENT= M_ARM_RIGHT;
vector DAT_MNT_WEP1_OFFSET= '1.5 2 10';
vector DAT_MNT_WEP1_OFFSET_ALT= DAT_MNT_RARM_OFFSET;
vector DAT_MNT_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_MNT_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_MNT_WEP2_OFFSET= '-1.5 2 10';
vector DAT_MNT_WEP2_OFFSET_ALT= DAT_MNT_RARM_OFFSET;
vector DAT_MNT_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_MNT_WEP3_CPARENT= M_ARM_LEFT;
vector DAT_MNT_WEP3_OFFSET= '-1.5 2 10';
vector DAT_MNT_WEP3_OFFSET_ALT= DAT_MNT_LARM_OFFSET;
vector DAT_MNT_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_MNT_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_MNT_WEP4_OFFSET= '1.5 2 10';
vector DAT_MNT_WEP4_OFFSET_ALT= DAT_MNT_LARM_OFFSET;
vector DAT_MNT_WEP4_ADJ_ANG= '0 0 0';

//WEAPON5
string DAT_MNT_WEP5_CPARENT= M_TOR_RIGHT;
vector DAT_MNT_WEP5_OFFSET= '-2 15.5 6';
vector DAT_MNT_WEP5_OFFSET_ALT= DAT_MNT_RTOR_OFFSET;
vector DAT_MNT_WEP5_ADJ_ANG= '0 0 0';

//WEAPON6
string DAT_MNT_WEP6_CPARENT= M_TOR_LEFT;
vector DAT_MNT_WEP6_OFFSET= '2 15.5 6';
vector DAT_MNT_WEP6_OFFSET_ALT= DAT_MNT_LTOR_OFFSET;
vector DAT_MNT_WEP6_ADJ_ANG= '0 0 0';

//WEAPON7
string DAT_MNT_WEP7_CPARENT= M_TOR_CENTER;
vector DAT_MNT_WEP7_OFFSET= '0 5 6';
vector DAT_MNT_WEP7_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP7_ADJ_ANG= '0 0 0';

//WEAPON8
string DAT_MNT_WEP8_CPARENT= M_TOR_RIGHT;
vector DAT_MNT_WEP8_OFFSET= '9 6 4';
vector DAT_MNT_WEP8_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP8_ADJ_ANG= '0 0 0';

//WEAPON9
string DAT_MNT_WEP9_CPARENT= M_TOR_LEFT;
vector DAT_MNT_WEP9_OFFSET= '-9 6 4';
vector DAT_MNT_WEP9_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP9_ADJ_ANG= '0 0 0';


//=========================================
void() data_mech_mnt;

void() data_mnt_legs;
void() data_mnt_ctor;
void() data_mnt_ltor;
void() data_mnt_rtor;
void() data_mnt_larm;
void() data_mnt_rarm;
void() data_mnt_cam;
void() data_mnt_wep1;
void() data_mnt_wep2;
void() data_mnt_wep3;
void() data_mnt_wep4;
void() data_mnt_wep5;
void() data_mnt_wep6;
void() data_mnt_wep7;
void() data_mnt_wep8;
void() data_mnt_wep9;

//call this guy at the start of the world ini
void() data_mech_mnt={
  local entity MNT, oself;
  MNT = spawn();
  oself = self;
  self = MNT;
    self.data_idx = DAT_MNT_IDX;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_name = DAT_MNT_VEC_NAME;
    self.vec_size = 3;
    self.unit_ini = data_mnt_ini;

    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;    
    self.w_group2 = self.w_group2 | WEAPON5 | WEAPON6;
    self.w_group3 = self.w_group3 | WEAPON7 | WEAPON8 | WEAPON9;
    self.w_group4 = self.w_group4;
    self.w_group5 = self.w_group5;
  self = oself;
};

void() data_mnt_ini={
  self.unit_legs = data_mnt_legs;
  self.unit_ltor = data_mnt_ltor;
  self.unit_ctor = data_mnt_ctor;
  self.unit_rtor = data_mnt_rtor;
  self.unit_larm = data_mnt_larm;
  self.unit_rarm = data_mnt_rarm;
  self.unit_cam = data_mnt_cam;
  self.unit_wep1 = data_mnt_wep1;
  self.unit_wep2 = data_mnt_wep2;
  self.unit_wep3 = data_mnt_wep3;
  self.unit_wep4 = data_mnt_wep4;
  self.unit_wep5 = data_mnt_wep5;
  self.unit_wep6 = data_mnt_wep6;
  self.unit_wep7 = data_mnt_wep7;
  self.unit_wep8 = data_mnt_wep8;
  self.unit_wep9 = data_mnt_wep9;
  
  self.data_idx= DAT_MNT_IDX;
  self.vec_name= DAT_MNT_VEC_NAME;
  self.data_type = DATA_MECH;
  self.radar_range = DAT_MNT_RADAR_RANGE;
  self.i_techlvl= DAT_MNT_TECH_LEVEL;
  self.i_reserve= DAT_MNT_RESERVE_COST;
  self.en_cur= DAT_MNT_ENERGY_CUR;
  self.en_max= DAT_MNT_ENERGY_MAX;
  self.en_rate= DAT_MNT_ENERGY_RATE;
  self.sh_cur= DAT_MNT_SHIELD_CUR;
  self.sh_max= DAT_MNT_SHIELD_MAX;
  self.sh_rate= DAT_MNT_SHIELD_RATE;
  self.m_rot_speed = DAT_MNT_YAWSPEED;
  self.c_bbx_n = DAT_MNT_CTOR_BBX_N;
  self.c_bbx_x = DAT_MNT_CTOR_BBX_X;
  self.c_model = DAT_MNT_CTOR_MODEL;
  self.weaponmodel = DAT_MNT_CPIT_MODEL;
  self.weaponframe = 0;
  self.conv_min = DAT_MNT_SPREAD_N; 
  self.conv_max = DAT_MNT_SPREAD_X; 
  self.m_fspeed = DAT_MNT_M_FSPEED;
  self.m_sspeed = DAT_MNT_M_SSPEED;
  self.m_bspeed = DAT_MNT_M_BSPEED;
  self.m_maccel = DAT_MNT_M_ACCEL;
  self.m_rollangle = DAT_MNT_M_ROLLANGLE;
  self.m_pitch_max = DAT_MNT_M_PITCH_N;
  self.m_pitch_min = DAT_MNT_M_PITCH_X;
  self.m_bob = DAT_MNT_M_BOB;
  self.m_bcycle = DAT_MNT_M_BCYCLE;
  self.m_bup = DAT_MNT_M_BUP;
  self.m_bmodel = DAT_MNT_M_BMODEL;
  self.m_bside = DAT_MNT_M_BSIDE;
  self.m_bobspd = DAT_MNT_M_BSPD;
  self.w_firetime = DAT_MNT_LOCK; //using this as 'lock on time;
};

void() data_mnt_legs={
  self.c_name = DAT_MNT_LEG_CNAME;
  self.health = DAT_MNT_LEG_HP;
  self.max_health = DAT_MNT_LEG_HPMAX;
  self.armorvalue = DAT_MNT_LEG_ARMOR;
  self.max_armor = DAT_MNT_LEG_ARMMAX;
  self.c_model = DAT_MNT_LEG_MODEL;
  self.c_ofs = DAT_MNT_LEG_OFFSET;
};

void() data_mnt_ctor={
  self.c_name = DAT_MNT_CTOR_CNAME;
  self.health = DAT_MNT_CTOR_HP;
  self.max_health = DAT_MNT_CTOR_HPMAX;
  self.armorvalue = DAT_MNT_CTOR_ARMOR;
  self.max_armor = DAT_MNT_CTOR_ARMMAX;
  self.c_model = DAT_MNT_CTOR_MODEL;
  self.w_proj = 9;
};

void() data_mnt_ltor={
  self.c_name = DAT_MNT_LTOR_CNAME;
  self.c_parent = DAT_MNT_LTOR_CPARENT;
  self.health = DAT_MNT_LTOR_HP;
  self.max_health = DAT_MNT_LTOR_HPMAX;
  self.armorvalue = DAT_MNT_LTOR_ARMOR;
  self.max_armor = DAT_MNT_LTOR_ARMMAX;
  self.c_model = DAT_MNT_LTOR_MODEL;
  self.c_ofs = DAT_MNT_LTOR_OFFSET;
};
void() data_mnt_rtor={
  self.c_name = DAT_MNT_RTOR_CNAME;
  self.c_parent = DAT_MNT_RTOR_CPARENT;
  self.health = DAT_MNT_RTOR_HP;
  self.max_health = DAT_MNT_RTOR_HPMAX;
  self.armorvalue = DAT_MNT_RTOR_ARMOR;
  self.max_armor = DAT_MNT_RTOR_ARMMAX;
  self.c_model = DAT_MNT_RTOR_MODEL;
  self.c_ofs = DAT_MNT_RTOR_OFFSET;
};
void() data_mnt_larm={  
  self.c_name = DAT_MNT_LARM_CNAME;
  self.c_parent = DAT_MNT_LARM_CPARENT;
  self.health = DAT_MNT_LARM_HP;
  self.max_health = DAT_MNT_LARM_HPMAX;
  self.armorvalue = DAT_MNT_LARM_ARMOR;
  self.max_armor = DAT_MNT_LARM_ARMMAX;
  self.c_model = DAT_MNT_LARM_MODEL;
  self.c_ofs = DAT_MNT_LARM_OFFSET;
};
void() data_mnt_rarm={  
  self.c_name = DAT_MNT_RARM_CNAME;
  self.c_parent = DAT_MNT_RARM_CPARENT;
  self.health = DAT_MNT_RARM_HP;
  self.max_health = DAT_MNT_RARM_HPMAX;
  self.armorvalue = DAT_MNT_RARM_ARMOR;
  self.max_armor = DAT_MNT_RARM_ARMMAX;
  self.c_model = DAT_MNT_RARM_MODEL;
  self.c_ofs = DAT_MNT_RARM_OFFSET;
};
void() data_mnt_cam={  
  self.c_name = DAT_MNT_CAM_CNAME;
  self.c_ofs = DAT_MNT_CAM_OFFSET;
  self.c_alt_ofs = DAT_MNT_CAM_OFFSET_ALT;
  self.c_model = DAT_MNT_CAM_MODEL;
};
void() data_mnt_wep1={  
  self.c_parent = DAT_MNT_WEP1_CPARENT;
  self.c_ofs = DAT_MNT_WEP1_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_mnt_wep2={  
  self.c_parent = DAT_MNT_WEP2_CPARENT;
  self.c_ofs = DAT_MNT_WEP2_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};
void() data_mnt_wep3={  
  self.c_parent = DAT_MNT_WEP3_CPARENT;
  self.c_ofs = DAT_MNT_WEP3_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP3_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP3_ADJ_ANG;
  self.w_group = WEAPON3;
};
void() data_mnt_wep4={  
  self.c_parent = DAT_MNT_WEP4_CPARENT;
  self.c_ofs = DAT_MNT_WEP4_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP4_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP4_ADJ_ANG;
  self.w_group = WEAPON4;
};
void() data_mnt_wep5={  
  self.c_parent = DAT_MNT_WEP5_CPARENT;
  self.c_ofs = DAT_MNT_WEP5_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP5_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP5_ADJ_ANG;
  self.w_group = WEAPON5;
};
void() data_mnt_wep6={  
  self.c_parent = DAT_MNT_WEP6_CPARENT;
  self.c_ofs = DAT_MNT_WEP6_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP6_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP6_ADJ_ANG;
  self.w_group = WEAPON6;
};
void() data_mnt_wep7={  
  self.c_parent = DAT_MNT_WEP7_CPARENT;
  self.c_ofs = DAT_MNT_WEP7_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP7_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP7_ADJ_ANG;
  self.w_group = WEAPON7;
};
void() data_mnt_wep8={  
  self.c_parent = DAT_MNT_WEP8_CPARENT;
  self.c_ofs = DAT_MNT_WEP8_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP8_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP8_ADJ_ANG;
  self.w_group = WEAPON8;
};
void() data_mnt_wep9={  
  self.c_parent = DAT_MNT_WEP9_CPARENT;
  self.c_ofs = DAT_MNT_WEP9_OFFSET;
  self.c_alt_ofs = DAT_MNT_WEP9_OFFSET_ALT;
  self.w_adj_ang = DAT_MNT_WEP9_ADJ_ANG;
  self.w_group = WEAPON9;
};