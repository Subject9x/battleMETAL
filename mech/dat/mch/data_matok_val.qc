/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: MATOK
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//MATOK MECH=============================
float DAT_MTK_IDX = ID_MCH_MATOK;
string DAT_MTK_VEC_NAME = "MATOK";
float DAT_MTK_TECH_LEVEL = 2;
float DAT_MTK_RADAR_RANGE = 3000;
float DAT_MTK_RESERVE_COST = 200;
float DAT_MTK_ENERGY_CUR = 800;
float DAT_MTK_ENERGY_MAX = 800;
float DAT_MTK_ENERGY_RATE = 3;
float DAT_MTK_SHIELD_CUR = 425;
float DAT_MTK_SHIELD_MAX = 425;
float DAT_MTK_SHIELD_RATE = 0.75;
float DAT_MTK_YAWSPEED = 5;
vector DAT_MTK_CTOR_BBX_N ='-15 -15 -35';
vector DAT_MTK_CTOR_BBX_X ='15 15 14';
string DAT_MTK_CPIT_MODEL = "q3mdl/mechs/ntmk/mdl_ntmk_cpt.md3";
float DAT_MTK_M_FSPEED=225;
float DAT_MTK_M_SSPEED=225;
float DAT_MTK_M_BSPEED=190;

vector DAT_MTK_SPREAD_N = '4 4 0.008';
vector DAT_MTK_SPREAD_X = '8 8 0.008';

//HITPOINT VALUES
float DAT_MTK_CTOR_HP = 650;
float DAT_MTK_CTOR_HPMAX= 650;
float DAT_MTK_LEG_HP = 900;
float DAT_MTK_LEG_HPMAX= 900;
float DAT_MTK_LTOR_HP = 600;
float DAT_MTK_LTOR_HPMAX= 600;
float DAT_MTK_RTOR_HP = 600;
float DAT_MTK_RTOR_HPMAX= 600;
float DAT_MTK_LARM_HP = 675;
float DAT_MTK_LARM_HPMAX= 675;
float DAT_MTK_RARM_HP = 675;
float DAT_MTK_RARM_HPMAX= 675;

//ARMOR VALUES
float DAT_MTK_CTOR_ARMOR= 100;
float DAT_MTK_CTOR_ARMMAX= 100;
float DAT_MTK_RARM_ARMOR= 100;
float DAT_MTK_RARM_ARMMAX= 100;
float DAT_MTK_LARM_ARMOR= 100;
float DAT_MTK_LARM_ARMMAX= 100;
float DAT_MTK_RTOR_ARMOR= 100;
float DAT_MTK_RTOR_ARMMAX= 100;
float DAT_MTK_LTOR_ARMOR= 100;
float DAT_MTK_LTOR_ARMMAX= 100;
float DAT_MTK_LEG_ARMOR= 100;
float DAT_MTK_LEG_ARMMAX= 100;

//WEAOPON GROUPS
float DAT_MTK_WEP1_IDX= ID_WEP_LATC;
float DAT_MTK_WEP2_IDX= ID_WEP_LATC;
float DAT_MTK_WEP3_IDX= ID_WEP_LAS;
float DAT_MTK_WEP4_IDX= ID_WEP_LAS;
float DAT_MTK_WEP5_IDX= ID_WEP_ESR;
float DAT_MTK_WEP1_GROUP= 1;
float DAT_MTK_WEP2_GROUP= 1;
float DAT_MTK_WEP3_GROUP= 2;
float DAT_MTK_WEP4_GROUP= 2;
float DAT_MTK_WEP5_GROUP= 3;

//this is mostly cosmetics
string DAT_MTK_CTOR_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_t_cent.md3";
float DAT_MTK_M_ACCEL=0.0007;
string DAT_MTK_M_ROLLANGLE="2.25";
string DAT_MTK_M_PITCH_N="90";
string DAT_MTK_M_PITCH_X="-90";
string DAT_MTK_M_BOB = "0.0008";
string DAT_MTK_M_BCYCLE =  "0.5";
string DAT_MTK_M_BUP = "0.5";
string DAT_MTK_M_BMODEL = "1";
string DAT_MTK_M_BSIDE = "0.35";
string DAT_MTK_M_BSPD = "6.55";

//LEGS
string DAT_MTK_LEG_CNAME= M_LEGS;
string DAT_MTK_LEG_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_legs.md3";
vector DAT_MTK_LEG_OFFSET= '0 -21 0';

//CENTER TORSO
string DAT_MTK_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_MTK_LTOR_CNAME= M_TOR_LEFT;
string DAT_MTK_LTOR_CPARENT= M_TOR_CENTER;

string DAT_MTK_LTOR_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_t_left.md3";
vector DAT_MTK_LTOR_OFFSET= '-8 3 -1.5';

//RIGHT TORSO
string DAT_MTK_RTOR_CNAME= M_TOR_RIGHT;
string DAT_MTK_RTOR_CPARENT= M_TOR_CENTER; 

string DAT_MTK_RTOR_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_t_right.md3";
vector DAT_MTK_RTOR_OFFSET= '8 3 -1.5';

//LEFT ARM 
string DAT_MTK_LARM_CNAME= M_ARM_LEFT;
string DAT_MTK_LARM_CPARENT= M_TOR_LEFT;

string DAT_MTK_LARM_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_l_arm.md3";
vector DAT_MTK_LARM_OFFSET= '-13 -0.5 -2.25';

//RIGHT ARM
string DAT_MTK_RARM_CNAME= M_ARM_RIGHT;
string DAT_MTK_RARM_CPARENT= M_TOR_RIGHT;

string DAT_MTK_RARM_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_r_arm.md3";
vector DAT_MTK_RARM_OFFSET= '13 -0.5 -2.25';

//CAMERA
string DAT_MTK_CAM_CNAME= "camera";
string DAT_MTK_CAM_MODEL= "q3mdl/testball.md3";
vector DAT_MTK_CAM_OFFSET= '0 3.75 7';
vector DAT_MTK_CAM_OFFSET_ALT= '0 1 0';

//WEAPON1
string DAT_MTK_WEP1_CPARENT= M_TOR_RIGHT;
vector DAT_MTK_WEP1_OFFSET= '8 8 1';
vector DAT_MTK_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_MTK_WEP2_CPARENT= M_TOR_LEFT;
vector DAT_MTK_WEP2_OFFSET= '-8 8 1';
vector DAT_MTK_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_MTK_WEP3_CPARENT= M_ARM_RIGHT;
vector DAT_MTK_WEP3_OFFSET= '14 -3 5';
vector DAT_MTK_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_MTK_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_MTK_WEP4_OFFSET= '-14 -3 5';
vector DAT_MTK_WEP4_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP4_ADJ_ANG= '0 0 0';

//WEAPON5
string DAT_MTK_WEP5_CPARENT= M_TOR_CENTER;
vector DAT_MTK_WEP5_OFFSET= '0 10 -4';
vector DAT_MTK_WEP5_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP5_ADJ_ANG= '0 0 0';

//=========================================
void() data_mech_mtk;
void() data_mtk_ini;
void() data_mtk_legs;
void() data_mtk_ctor;
void() data_mtk_ltor;
void() data_mtk_rtor;
void() data_mtk_larm;
void() data_mtk_rarm;
void() data_mtk_cam;
void() data_mtk_wep1;
void() data_mtk_wep2;
void() data_mtk_wep3;
void() data_mtk_wep4;
void() data_mtk_wep5;

//call this guy at the start of the world ini
void() data_mech_mtk={
  local entity mtk, oself;
  mtk = spawn();
  oself = self;
  self = mtk;
    self.data_idx = DAT_MTK_IDX;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_name = DAT_MTK_VEC_NAME;
    self.unit_ini = data_mtk_ini;
    self.unit_legs = data_mtk_legs;
    self.unit_ltor = data_mtk_ltor;
    self.unit_ctor = data_mtk_ctor;
    self.unit_rtor = data_mtk_rtor;
    self.unit_larm = data_mtk_larm;
    self.unit_rarm = data_mtk_rarm;
    self.unit_cam = data_mtk_cam;
    self.unit_wep1 = data_mtk_wep1;
    self.unit_wep2 = data_mtk_wep2;
    self.unit_wep3 = data_mtk_wep3;
    self.unit_wep4 = data_mtk_wep4;
    self.unit_wep5 = data_mtk_wep5;
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2;    
    self.w_group2 = self.w_group2 | WEAPON3 | WEAPON4;    
    self.w_group3 = self.w_group3 | WEAPON5;
    self.w_group4 = self.w_group4;
    self.w_group5 = self.w_group5;    
  self = oself;
};

void() data_mtk_ini={
  self.data_idx= DAT_MTK_IDX;
  self.vec_name= DAT_MTK_VEC_NAME;
  self.data_type = DATA_MECH;
  self.radar_range = DAT_MTK_RADAR_RANGE;
  self.i_techlvl= DAT_MTK_TECH_LEVEL;
  self.i_reserve= DAT_MTK_RESERVE_COST;
  self.en_cur= DAT_MTK_ENERGY_CUR;
  self.en_max= DAT_MTK_ENERGY_MAX;
  self.en_rate= DAT_MTK_ENERGY_RATE;
  self.sh_cur= DAT_MTK_SHIELD_CUR;
  self.sh_max= DAT_MTK_SHIELD_MAX;
  self.sh_rate= DAT_MTK_SHIELD_RATE;
  self.c_bbx_n = DAT_MTK_CTOR_BBX_N;
  self.c_bbx_x = DAT_MTK_CTOR_BBX_X;
  self.c_model = DAT_MTK_CTOR_MODEL;
  self.m_rot_speed = DAT_MTK_YAWSPEED;
  self.conv_min = DAT_MTK_SPREAD_N; 
  self.conv_max = DAT_MTK_SPREAD_X;
  self.m_fspeed = DAT_MTK_M_FSPEED;
  self.m_sspeed = DAT_MTK_M_SSPEED;
  self.m_bspeed = DAT_MTK_M_BSPEED;
  self.m_maccel = DAT_MTK_M_ACCEL;
  if((self.flags & FL_CLIENT)){
    self.weaponmodel = DAT_MTK_CPIT_MODEL;
    self.weaponframe = 0;
    self.m_rollangle = DAT_MTK_M_ROLLANGLE;
    self.m_pitch_max = DAT_MTK_M_PITCH_N;
    self.m_pitch_min = DAT_MTK_M_PITCH_X;
    self.m_bob = DAT_MTK_M_BOB;
    self.m_bcycle = DAT_MTK_M_BCYCLE;
    self.m_bup = DAT_MTK_M_BUP;
    self.m_bmodel = DAT_MTK_M_BMODEL;
    self.m_bside = DAT_MTK_M_BSIDE;
    self.m_bobspd = DAT_MTK_M_BSPD;
  }
};
void() data_mtk_legs={
  self.c_name = DAT_MTK_LEG_CNAME;
  self.health = DAT_MTK_LEG_HP;
  self.max_health = DAT_MTK_LEG_HPMAX;
  self.armorvalue = DAT_MTK_LEG_ARMOR;
  self.max_armor = DAT_MTK_LEG_ARMMAX;
  self.c_model = DAT_MTK_LEG_MODEL;
  self.c_ofs = DAT_MTK_LEG_OFFSET;
};
void() data_mtk_ctor={
  self.c_name = DAT_MTK_CTOR_CNAME;
  self.health = DAT_MTK_CTOR_HP;
  self.max_health = DAT_MTK_CTOR_HPMAX;
  self.armorvalue = DAT_MTK_CTOR_ARMOR;
  self.max_armor = DAT_MTK_CTOR_ARMMAX;
  self.c_model = DAT_MTK_CTOR_MODEL;
};

void() data_mtk_ltor={
  self.c_name = DAT_MTK_LTOR_CNAME;
  self.c_parent = DAT_MTK_LTOR_CPARENT;
  self.health = DAT_MTK_LTOR_HP;
  self.max_health = DAT_MTK_LTOR_HPMAX;
  self.armorvalue = DAT_MTK_LTOR_ARMOR;
  self.max_armor = DAT_MTK_LTOR_ARMMAX;
  self.c_model = DAT_MTK_LTOR_MODEL;
  self.c_ofs = DAT_MTK_LTOR_OFFSET;
};
void() data_mtk_rtor={
  self.c_name = DAT_MTK_RTOR_CNAME;
  self.c_parent = DAT_MTK_RTOR_CPARENT;
  self.health = DAT_MTK_RTOR_HP;
  self.max_health = DAT_MTK_RTOR_HPMAX;
  self.armorvalue = DAT_MTK_RTOR_ARMOR;
  self.max_armor = DAT_MTK_RTOR_ARMMAX;
  self.c_model = DAT_MTK_RTOR_MODEL;
  self.c_ofs = DAT_MTK_RTOR_OFFSET;
};
void() data_mtk_larm={  
  self.c_name = DAT_MTK_LARM_CNAME;
  self.c_parent = DAT_MTK_LARM_CPARENT;
  self.health = DAT_MTK_LARM_HP;
  self.max_health = DAT_MTK_LARM_HPMAX;
  self.armorvalue = DAT_MTK_LARM_ARMOR;
  self.max_armor = DAT_MTK_LARM_ARMMAX;
  self.c_model = DAT_MTK_LARM_MODEL;
  self.c_ofs = DAT_MTK_LARM_OFFSET;
};
void() data_mtk_rarm={  
  self.c_name = DAT_MTK_RARM_CNAME;
  self.c_parent = DAT_MTK_RARM_CPARENT;
  self.health = DAT_MTK_RARM_HP;
  self.max_health = DAT_MTK_RARM_HPMAX;
  self.armorvalue = DAT_MTK_RARM_ARMOR;
  self.max_armor = DAT_MTK_RARM_ARMMAX;
  self.c_model = DAT_MTK_RARM_MODEL;
  self.c_ofs = DAT_MTK_RARM_OFFSET;
};
void() data_mtk_cam={  
  self.c_name = DAT_MTK_CAM_CNAME;
  self.c_ofs = DAT_MTK_CAM_OFFSET;
  self.c_alt_ofs = DAT_MTK_CAM_OFFSET_ALT;
  self.c_model = DAT_MTK_CAM_MODEL;
};
void() data_mtk_wep1={  
  self.c_parent = DAT_MTK_WEP1_CPARENT;
  self.data_idx = DAT_MTK_WEP1_IDX; //consult weapon idx table!
  self.c_ofs = DAT_MTK_WEP1_OFFSET;
  self.c_alt_ofs = DAT_MTK_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_MTK_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_mtk_wep2={  
  self.c_parent = DAT_MTK_WEP2_CPARENT;
  self.data_idx = DAT_MTK_WEP2_IDX; //consult weapon idx table!
  self.c_ofs = DAT_MTK_WEP2_OFFSET;
  self.c_alt_ofs = DAT_MTK_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_MTK_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};
void() data_mtk_wep3={  
  self.c_parent = DAT_MTK_WEP3_CPARENT;
  self.data_idx = DAT_MTK_WEP3_IDX; //consult weapon idx table!
  self.c_ofs = DAT_MTK_WEP3_OFFSET;
  self.c_alt_ofs = DAT_MTK_WEP3_OFFSET_ALT;
  self.w_adj_ang = DAT_MTK_WEP3_ADJ_ANG;
  self.w_group = WEAPON3;
};
void() data_mtk_wep4={  
  self.c_parent = DAT_MTK_WEP4_CPARENT;
  self.data_idx = DAT_MTK_WEP4_IDX; //consult weapon idx table!
  self.c_ofs = DAT_MTK_WEP4_OFFSET;
  self.c_alt_ofs = DAT_MTK_WEP4_OFFSET_ALT;
  self.w_adj_ang = DAT_MTK_WEP4_ADJ_ANG;
  self.w_group = WEAPON4;
};
void() data_mtk_wep5={  
  self.c_parent = DAT_MTK_WEP5_CPARENT;
  self.data_idx = DAT_MTK_WEP5_IDX; //consult weapon idx table!
  self.c_ofs = DAT_MTK_WEP5_OFFSET;
  self.c_alt_ofs = DAT_MTK_WEP5_OFFSET_ALT;
  self.w_adj_ang = DAT_MTK_WEP5_ADJ_ANG;
  self.w_group = WEAPON5;
};