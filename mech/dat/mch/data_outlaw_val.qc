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
float DAT_OTL_RESERVE_COST = 100;

float DAT_OTL_WEP1_GROUP= 1;
float DAT_OTL_WEP2_GROUP= 1;
float DAT_OTL_WEP3_GROUP= 2;

string DAT_OTL_M_ROLLANGLE  = "2";
float DAT_OTL_M_PITCH_N    = 40;
float DAT_OTL_M_PITCH_X    = -50;
string DAT_OTL_M_BOB        = "0.0008";
string DAT_OTL_M_BCYCLE     = "0.5";
string DAT_OTL_M_BUP        = "0.15";
string DAT_OTL_M_BMODEL     = "1";
string DAT_OTL_M_BSIDE      = "0.09";
string DAT_OTL_M_BSPD       = "6";

//CAMERA
float DAT_OTL_CAM_CNAME = -1;

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

  self.data_idx = ID_MCH_balaket;
  self.vec_size = SZ_MCH_BALAKET;
  self.vec_name = MCH_NAME_BLK;
  self.data_type = DATA_MECH;
  self.health = DAT_OTL_CTOR_HP;
  self.max_health = DAT_OTL_CTOR_HP;
  self.radar_range = DAT_OTL_RADAR_RANGE;
  self.i_techlvl= DAT_OTL_TECH_LEVEL;
  self.i_reserve= DAT_OTL_RESERVE_COST;
  self.en_cur= DAT_OTL_ENERGY_MAX;
  self.en_max= DAT_OTL_ENERGY_MAX;
  self.en_rate= DAT_OTL_ENERGY_RATE;
  self.sh_cur= DAT_OTL_SHIELD_MAX;
  self.sh_max= DAT_OTL_SHIELD_MAX;
  self.sh_rate= DAT_OTL_SHIELD_RATE;
  self.c_model = DAT_OTL_CTOR_MODEL;
  self.weaponmodel = DAT_OTL_CPIT_MODEL;
  self.weaponframe = 0;
  self.spreadDefault = ACCURACY_SKIRMISH; 
  self.yaw_speed = DAT_OTL_M_YAW;
  self.turret_yaw_speed = DAT_OTL_TUR_YAW;
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
    
  setsize(self, DAT_OTL_CTOR_BBX_N, DAT_OTL_CTOR_BBX_X);
};

void() data_otl_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = DAT_OTL_CTOR_HP;
  self.max_health = DAT_OTL_CTOR_HP;
  self.c_model = DAT_OTL_CTOR_MODEL;
  self.w_proj = 3;
};
void() data_otl_legs={
  self.comp_id = M_LEGS;
  self.health = DAT_OTL_LEG_HP;
  self.max_health = DAT_OTL_LEG_HP;
  self.c_model = DAT_OTL_LEG_MODEL;
  self.c_ofs = DAT_OTL_LEG_OFFSET;
};
void() data_otl_ltor={
  self.comp_id = M_TOR_LEFT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_OTL_LTOR_HP;
  self.max_health = DAT_OTL_LTOR_HP;
  self.c_model = DAT_OTL_LTOR_MODEL;
  self.c_ofs = DAT_OTL_LTOR_OFFSET;
};
void() data_otl_rtor={
  self.comp_id = M_TOR_RIGHT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_OTL_RTOR_HP;
  self.max_health = DAT_OTL_RTOR_HP;
  self.c_model = DAT_OTL_RTOR_MODEL;
  self.c_ofs = DAT_OTL_RTOR_OFFSET;
};
void() data_otl_larm={  
  self.comp_id = M_ARM_LEFT;
  self.c_parent = M_TOR_LEFT;
  self.health = DAT_OTL_LARM_HP;
  self.max_health = DAT_OTL_LARM_HP;
  self.c_model = DAT_OTL_LARM_MODEL;
  self.c_ofs = DAT_OTL_LARM_OFFSET;
};
void() data_otl_rarm={  
  self.comp_id = M_ARM_RIGHT;
  self.c_parent = M_TOR_RIGHT;
  self.health = DAT_OTL_RARM_HP;
  self.max_health = DAT_OTL_RARM_HP;
  self.armorvalue = DAT_OTL_RARM_ARMMAX;
  self.max_armor = DAT_OTL_RARM_ARMMAX;
  self.c_model = DAT_OTL_RARM_MODEL;
  self.c_ofs = DAT_OTL_RARM_OFFSET;
};
void() data_otl_cam={
  self.c_parent = M_TOR_CENTER;
  self.comp_id = DAT_OTL_CAM_CNAME;
  self.c_ofs = DAT_OTL_CAM_OFFSET;
  self.c_alt_ofs = DAT_OTL_CAM_OFFSET_ALT;
  self.c_model = DAT_OTL_CAM_MODEL;
};
void() data_otl_wep1={  
  self.c_parent = M_ARM_LEFT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};
void() data_otl_wep2={  
  self.c_parent = M_ARM_RIGHT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};
void() data_otl_wep3={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_OTL_WEP3_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON3;
};