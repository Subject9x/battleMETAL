/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: OUTLAW
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//OUTLAW MECH=============================
float DAT_OTL_IDX = ID_MCH_OUTLAW;
string DAT_OTL_VEC_NAME = "Outlaw";
float DAT_OTL_TECH_LEVEL = 1;
float DAT_OTL_RESERVE_COST = 100;
float DAT_OTL_RADAR_RANGE = 17000;
float DAT_OTL_ENERGY_CUR = 75;
float DAT_OTL_ENERGY_MAX = 75;
float DAT_OTL_ENERGY_RATE = 0.09;
float DAT_OTL_SHIELD_CUR = 125;
float DAT_OTL_SHIELD_MAX = 125;
float DAT_OTL_SHIELD_RATE = 0.12;
vector DAT_OTL_CTOR_BBX_N ='-11 -11 -34';
vector DAT_OTL_CTOR_BBX_X ='11 11 12';
string DAT_OTL_CTOR_MODEL= "q3mdl/mechs/notl/mdl_notl_t_cent.md3";
string DAT_OTL_CPIT_MODEL= "q3mdl/mechs/notl/mdl_notl_cpt.md3";
float DAT_OTL_M_FSPEED= 525;//350; - 5/21/2017
float DAT_OTL_M_SSPEED= 450;//350; - 5/21/2017
float DAT_OTL_M_BSPEED= 400;//290; - 5/21/2017

vector DAT_OTL_SPREAD_N = '4 4 0.01';
vector DAT_OTL_SPREAD_X = '8 8 0.01';

float DAT_OTL_LEG_HP = 200;
float DAT_OTL_LEG_HPMAX= 200;
float DAT_OTL_CTOR_HP = 150;
float DAT_OTL_CTOR_HPMAX= 150;
float DAT_OTL_LTOR_HP = 125;
float DAT_OTL_LTOR_HPMAX= 125;
float DAT_OTL_RTOR_HP = 125;
float DAT_OTL_RTOR_HPMAX= 125;
float DAT_OTL_LARM_HP = 100;
float DAT_OTL_LARM_HPMAX= 100;
float DAT_OTL_RARM_HP = 100;
float DAT_OTL_RARM_HPMAX= 100;

float DAT_OTL_LEG_ARMOR= 100;
float DAT_OTL_LEG_ARMMAX= 100;
float DAT_OTL_CTOR_ARMOR= 100;
float DAT_OTL_CTOR_ARMMAX= 100;
float DAT_OTL_LTOR_ARMOR= 100;
float DAT_OTL_LTOR_ARMMAX= 100;
float DAT_OTL_RTOR_ARMOR= 100;
float DAT_OTL_RTOR_ARMMAX= 100;
float DAT_OTL_LARM_ARMOR= 100;
float DAT_OTL_LARM_ARMMAX= 100;
float DAT_OTL_RARM_ARMOR= 100;
float DAT_OTL_RARM_ARMMAX= 100;

float DAT_OTL_WEP1_IDX= ID_WEP_LATC;
float DAT_OTL_WEP2_IDX= ID_WEP_LATC;
float DAT_OTL_WEP3_IDX= ID_WEP_EMP;

float DAT_OTL_WEP1_GROUP= 1;
float DAT_OTL_WEP2_GROUP= 1;
float DAT_OTL_WEP3_GROUP= 2;

string DAT_OTL_M_ACCEL="1";
string DAT_OTL_M_ROLLANGLE="2";
string DAT_OTL_M_PITCH_N="90";
string DAT_OTL_M_PITCH_X="-90";
string DAT_OTL_M_BOB = "0.0008";
string DAT_OTL_M_BCYCLE =  "0.5";
string DAT_OTL_M_BUP = "0.15";
string DAT_OTL_M_BMODEL = "1";
string DAT_OTL_M_BSIDE = "0.09";
string DAT_OTL_M_BSPD = "6";

//LEGS
string DAT_OTL_LEG_CNAME= M_LEGS;
string DAT_OTL_LEG_MODEL= "q3mdl/mechs/notl/mdl_notl_legs.md3";
vector DAT_OTL_LEG_OFFSET= '0 -19.5 -4';

//CENTER TORSO
string DAT_OTL_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_OTL_LTOR_CNAME= M_TOR_LEFT;
string DAT_OTL_LTOR_CPARENT= M_TOR_CENTER;
string DAT_OTL_LTOR_MODEL= "q3mdl/mechs/notl/mdl_notl_t_left.md3";
vector DAT_OTL_LTOR_OFFSET= '-6.5 1 -2';

//RIGHT TORSO
string DAT_OTL_RTOR_CNAME= M_TOR_RIGHT;
string DAT_OTL_RTOR_CPARENT= M_TOR_CENTER; 
string DAT_OTL_RTOR_MODEL= "q3mdl/mechs/notl/mdl_notl_t_right.md3";
vector DAT_OTL_RTOR_OFFSET= '6.5 1 -2';

//LEFT ARM 
string DAT_OTL_LARM_CNAME= M_ARM_LEFT;
string DAT_OTL_LARM_CPARENT= M_TOR_LEFT;

string DAT_OTL_LARM_MODEL= "q3mdl/mechs/notl/mdl_notl_l_arm.md3";
vector DAT_OTL_LARM_OFFSET= '-11 -0.5 -0.5';

//RIGHT ARM
string DAT_OTL_RARM_CNAME= M_ARM_RIGHT;
string DAT_OTL_RARM_CPARENT= M_TOR_RIGHT;
string DAT_OTL_RARM_MODEL= "q3mdl/mechs/notl/mdl_notl_r_arm.md3";
vector DAT_OTL_RARM_OFFSET= '11 -0.5 -0.5';

//CAMERA
string DAT_OTL_CAM_CNAME= "camera";
string DAT_OTL_CAM_MODEL= "q3mdl/testball.md3";
vector DAT_OTL_CAM_OFFSET= '0 0.5 7.5';
vector DAT_OTL_CAM_OFFSET_ALT= '0 1 0';

//WEAPON1
string DAT_OTL_WEP1_CPARENT= M_ARM_LEFT;
vector DAT_OTL_WEP1_OFFSET= '-11.5 -2 6';
vector DAT_OTL_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_OTL_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_OTL_WEP2_OFFSET= '11.5 -2 6';
vector DAT_OTL_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_OTL_WEP3_CPARENT= M_TOR_CENTER;
vector DAT_OTL_WEP3_OFFSET= '-1 5.5 3';
vector DAT_OTL_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP3_ADJ_ANG= '0 0 0';

//=========================================

void() data_mech_otl;
void() data_otl_ini;
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

//call this guy at the start of the world ini
void() data_mech_otl={
  local entity otl, oself;
  oself = self;
  otl = spawn();
  self = otl;
    self.data_idx = DAT_OTL_IDX;
    self.vec_name = DAT_OTL_VEC_NAME;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.unit_ini = data_otl_ini;
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
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2;    
    self.w_group2 = self.w_group2 | WEAPON3;    
    self.w_group3 = 0;
    self.w_group4 = self.w_group4;
    self.w_group5 = self.w_group5;
  self = oself;
};

void() data_otl_ini={
  self.data_idx= DAT_OTL_IDX;
  self.vec_name= DAT_OTL_VEC_NAME;
  self.data_type = DATA_MECH;
  self.radar_range = DAT_OTL_RADAR_RANGE;
  self.i_techlvl= DAT_OTL_TECH_LEVEL;
  self.i_reserve= DAT_OTL_RESERVE_COST;
  self.en_cur= DAT_OTL_ENERGY_CUR;
  self.en_max= DAT_OTL_ENERGY_MAX;
  self.en_rate= DAT_OTL_ENERGY_RATE;
  self.sh_cur= DAT_OTL_SHIELD_CUR;
  self.sh_max= DAT_OTL_SHIELD_MAX;
  self.sh_rate= DAT_OTL_SHIELD_RATE;
  self.c_bbx_n = DAT_OTL_CTOR_BBX_N;
  self.c_bbx_x = DAT_OTL_CTOR_BBX_X;
  self.c_model = DAT_OTL_CTOR_MODEL;
  self.weaponmodel = DAT_OTL_CPIT_MODEL;
  self.weaponframe = 0;
  self.conv_min = DAT_OTL_SPREAD_N; 
  self.conv_max = DAT_OTL_SPREAD_X; 
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
};
void() data_otl_ctor={
  self.c_name = DAT_OTL_CTOR_CNAME;
  self.health = DAT_OTL_CTOR_HP;
  self.max_health = DAT_OTL_CTOR_HPMAX;
  self.armorvalue = DAT_OTL_CTOR_ARMOR;
  self.max_armor = DAT_OTL_CTOR_ARMMAX;
  self.c_model = DAT_OTL_CTOR_MODEL;
};
void() data_otl_legs={
  self.c_name = DAT_OTL_LEG_CNAME;
  self.health = DAT_OTL_LEG_HP;
  self.max_health = DAT_OTL_LEG_HPMAX;
  self.armorvalue = DAT_OTL_LEG_ARMOR;
  self.max_armor = DAT_OTL_LEG_ARMMAX;
  self.c_model = DAT_OTL_LEG_MODEL;
  self.c_ofs = DAT_OTL_LEG_OFFSET;
};
void() data_otl_ltor={
    self.c_name = DAT_OTL_LTOR_CNAME;
    self.c_parent = DAT_OTL_LTOR_CPARENT;
    self.health = DAT_OTL_LTOR_HP;
    self.max_health = DAT_OTL_LTOR_HPMAX;
    self.armorvalue = DAT_OTL_LTOR_ARMOR;
    self.max_armor = DAT_OTL_LTOR_ARMMAX;
    self.c_model = DAT_OTL_LTOR_MODEL;
    self.c_ofs = DAT_OTL_LTOR_OFFSET;
};
void() data_otl_rtor={
  self.c_name = DAT_OTL_RTOR_CNAME;
  self.c_parent = DAT_OTL_RTOR_CPARENT;
  self.health = DAT_OTL_RTOR_HP;
  self.max_health = DAT_OTL_RTOR_HPMAX;
  self.armorvalue = DAT_OTL_RTOR_ARMOR;
  self.max_armor = DAT_OTL_RTOR_ARMMAX;
  self.c_model = DAT_OTL_RTOR_MODEL;
  self.c_ofs = DAT_OTL_RTOR_OFFSET;
};
void() data_otl_larm={  
  self.c_name = DAT_OTL_LARM_CNAME;
  self.c_parent = DAT_OTL_LARM_CPARENT;
  self.health = DAT_OTL_LARM_HP;
  self.max_health = DAT_OTL_LARM_HPMAX;
  self.armorvalue = DAT_OTL_LARM_ARMOR;
  self.max_armor = DAT_OTL_LARM_ARMMAX;
  self.c_model = DAT_OTL_LARM_MODEL;
  self.c_ofs = DAT_OTL_LARM_OFFSET;
};
void() data_otl_rarm={  
  self.c_name = DAT_OTL_RARM_CNAME;
  self.c_parent = DAT_OTL_RARM_CPARENT;
  self.health = DAT_OTL_RARM_HP;
  self.max_health = DAT_OTL_RARM_HPMAX;
  self.armorvalue = DAT_OTL_RARM_ARMOR;
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