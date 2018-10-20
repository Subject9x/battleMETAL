/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: MATOK
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//MATOK MECH=============================
string DAT_MTK_VEC_NAME = "MATOK";

float DAT_MTK_RESERVE_COST = 200;

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

string DAT_MTK_M_ROLLANGLE="2.25";
string DAT_MTK_M_PITCH_N="90";
string DAT_MTK_M_PITCH_X="-90";
string DAT_MTK_M_BOB = "0.0008";
string DAT_MTK_M_BCYCLE =  "0.5";
string DAT_MTK_M_BUP = "0.5";
string DAT_MTK_M_BMODEL = "1";
string DAT_MTK_M_BSIDE = "0.35";
string DAT_MTK_M_BSPD = "6.55";

//=========================================

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

void() data_mtk_ini={
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

  self.data_idx = ID_MCH_MATOK;
  self.vec_name= DAT_MTK_VEC_NAME;
  self.vec_size = SZ_MCH_MATOK;
  self.data_type = DATA_MECH;
  self.health = DAT_MTK_CTOR_HP;
  self.max_health = DAT_MTK_CTOR_HP;
  self.radar_range = DAT_MTK_RADAR_RANGE;
  self.i_techlvl= DAT_MTK_TECH_LEVEL;
  self.i_reserve= DAT_MTK_RESERVE_COST;
  self.en_cur= DAT_MTK_ENERGY_MAX;
  self.en_max= DAT_MTK_ENERGY_MAX;
  self.en_rate= DAT_MTK_ENERGY_RATE;
  self.sh_cur= DAT_MTK_SHIELD_MAX;
  self.sh_max= DAT_MTK_SHIELD_MAX;
  self.sh_rate= DAT_MTK_SHIELD_RATE;
  self.c_model = DAT_MTK_CTOR_MODEL;
  self.m_rot_speed = DAT_MTK_M_YAW;
  self.conv_min = DAT_MTK_SPREAD_N; 
  self.conv_max = DAT_MTK_SPREAD_X;
  self.m_fspeed = DAT_MTK_M_FSPEED;
  self.m_sspeed = DAT_MTK_M_SSPEED;
  self.m_bspeed = DAT_MTK_M_BSPEED;
  self.m_maccel = DAT_MTK_M_ACCEL;
  self.w_firetime = DAT_MTK_LOCK; //using this as 'lock on time;
  self.hardpoint_cnt = DAT_MTK_HARDPOINT_CNT;
  if( (self.flags & FL_CLIENT) ){
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
  setsize(self, DAT_MTK_CTOR_BBX_N, DAT_MTK_CTOR_BBX_X);
};
void() data_mtk_legs={
  self.comp_id = M_LEGS;
  self.health = DAT_MTK_LEG_HP;
  self.max_health = DAT_MTK_LEG_HP;
  self.armorvalue = DAT_MTK_LEG_ARMMAX;
  self.max_armor = DAT_MTK_LEG_ARMMAX;
  self.c_model = DAT_MTK_LEG_MODEL;
  self.c_ofs = DAT_MTK_LEG_OFFSET;
};
void() data_mtk_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = DAT_MTK_CTOR_HP;
  self.max_health = DAT_MTK_CTOR_HP;
  self.armorvalue = DAT_MTK_CTOR_ARMMAX;
  self.max_armor = DAT_MTK_CTOR_ARMMAX;
  self.c_model = DAT_MTK_CTOR_MODEL;
  self.w_proj = 5;
};

void() data_mtk_ltor={
  self.comp_id = M_TOR_LEFT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_MTK_LTOR_HP;
  self.max_health = DAT_MTK_LTOR_HP;
  self.armorvalue = DAT_MTK_LTOR_ARMMAX;
  self.max_armor = DAT_MTK_LTOR_ARMMAX;
  self.c_model = DAT_MTK_LTOR_MODEL;
  self.c_ofs = DAT_MTK_LTOR_OFFSET;
};
void() data_mtk_rtor={
  self.comp_id = M_TOR_RIGHT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_MTK_RTOR_HP;
  self.max_health = DAT_MTK_RTOR_HP;
  self.armorvalue = DAT_MTK_RTOR_ARMMAX;
  self.max_armor = DAT_MTK_RTOR_ARMMAX;
  self.c_model = DAT_MTK_RTOR_MODEL;
  self.c_ofs = DAT_MTK_RTOR_OFFSET;
};
void() data_mtk_larm={  
  self.comp_id = M_ARM_LEFT;
  self.c_parent = M_TOR_LEFT;
  self.health = DAT_MTK_LARM_HP;
  self.max_health = DAT_MTK_LARM_HP;
  self.armorvalue = DAT_MTK_LARM_ARMMAX;
  self.max_armor = DAT_MTK_LARM_ARMMAX;
  self.c_model = DAT_MTK_LARM_MODEL;
  self.c_ofs = DAT_MTK_LARM_OFFSET;
};
void() data_mtk_rarm={  
  self.comp_id = M_ARM_RIGHT;
  self.c_parent = M_TOR_RIGHT;
  self.health = DAT_MTK_RARM_HP;
  self.max_health = DAT_MTK_RARM_HP;
  self.armorvalue = DAT_MTK_RARM_ARMMAX;
  self.max_armor = DAT_MTK_RARM_ARMMAX;
  self.c_model = DAT_MTK_RARM_MODEL;
  self.c_ofs = DAT_MTK_RARM_OFFSET;
};
void() data_mtk_cam={  
  self.comp_id = -1;
  self.c_parent = M_TOR_CENTER;
  self.c_ofs = DAT_MTK_CAM_OFFSET;
  self.c_alt_ofs = DAT_MTK_CAM_OFFSET_ALT;
  self.c_model = DAT_MTK_CAM_MODEL;
};
void() data_mtk_wep1={  
  self.c_parent = M_ARM_RIGHT;
  self.c_ofs = DAT_MTK_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};
void() data_mtk_wep2={  
  self.c_parent = M_ARM_LEFT;
  self.c_ofs = DAT_MTK_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};
void() data_mtk_wep3={  
  self.c_parent = M_TOR_RIGHT;
  self.c_ofs = DAT_MTK_WEP3_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON3;
};
void() data_mtk_wep4={  
  self.c_parent = M_ARM_LEFT;
  self.c_ofs = DAT_MTK_WEP4_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON4;
};
void() data_mtk_wep5={  
  self.c_parent = M_TOR_CENTER;
  self.c_ofs = DAT_MTK_WEP5_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON5;
};