/*
mech Mod
Author: Peter Roohr
Date: 02/14/2017
Overview:
  name: monitor
  type: mech
  size: heavy
*/

//MONITOR MECH=============================
float DAT_MNT_RESERVE_COST = 200;

//WEAPON GROUPS
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
string DAT_MNT_M_ROLLANGLE= "2.25";
string DAT_MNT_M_PITCH_N  = "90";
string DAT_MNT_M_PITCH_X  = "-90";
string DAT_MNT_M_BOB      = "0.03";
string DAT_MNT_M_BCYCLE   =  "0.85";
string DAT_MNT_M_BUP      = "0.5";
string DAT_MNT_M_BMODEL   = "1";
string DAT_MNT_M_BSIDE    = "0.65";
string DAT_MNT_M_BSPD     = "3.85";

//=========================================
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
  
  self.data_idx= ID_MCH_MONITOR;
  self.vec_name= MCH_NAME_MNT;
  self.vec_size = SZ_MCH_MONITOR;
  self.data_type = DATA_MECH;
  self.health = DAT_MNT_CTOR_HP;
  self.max_health = DAT_MNT_CTOR_HP;
  self.radar_range = DAT_MNT_RADAR_RANGE;
  self.i_techlvl= DAT_MNT_TECH_LEVEL;
  self.i_reserve= DAT_MNT_RESERVE_COST;
  self.en_cur= DAT_MNT_ENERGY_MAX;
  self.en_max= DAT_MNT_ENERGY_MAX;
  self.en_rate= DAT_MNT_ENERGY_RATE;
  self.sh_cur= DAT_MNT_SHIELD_MAX;
  self.sh_max= DAT_MNT_SHIELD_MAX;
  self.sh_rate= DAT_MNT_SHIELD_RATE;
  self.m_rot_speed = DAT_MNT_M_YAW;
  self.c_model = DAT_MNT_CTOR_MODEL;
  self.weaponmodel = DAT_MNT_CPIT_MODEL;
  self.weaponframe = 0;
  self.spreadDefault = ACCURACY_LOWTECH; 
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
  self.hardpoint_cnt = DAT_MNT_HARDPOINT_CNT;
  
  //unit variants
  if( (self.flags & FL_MONSTER) ){
   if( skill < 2 ){
      ai_ini_weapons( 3, 1, 3, 1, 12, 12, 4, 4, 4);
    }
    else if( skill == 2 ){
      ai_ini_weapons( 3, 1, 3, 1, 13, 5, 9, 4, 4);
    }
    else if( skill == 3 ){
      ai_ini_weapons( 1, 1, 1, 1, 13, 7, 16, 16, 4);
    } 
  }
  
  setsize( self, DAT_MNT_CTOR_BBX_N, DAT_MNT_CTOR_BBX_X);
};

void() data_mnt_legs={
  self.comp_id = M_LEGS;
  self.health = DAT_MNT_LEG_HP;
  self.max_health = DAT_MNT_LEG_HP;
  self.armorvalue = DAT_MNT_LEG_ARMMAX;
  self.max_armor = DAT_MNT_LEG_ARMMAX;
  self.c_model = DAT_MNT_LEG_MODEL;
  self.c_ofs = DAT_MNT_LEG_OFFSET;
};

void() data_mnt_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = DAT_MNT_CTOR_HP;
  self.max_health = DAT_MNT_CTOR_HP;
  self.armorvalue = DAT_MNT_CTOR_ARMMAX;
  self.max_armor = DAT_MNT_CTOR_ARMMAX;
  self.c_model = DAT_MNT_CTOR_MODEL;
  self.w_proj = 9;
};

void() data_mnt_ltor={
  self.comp_id = M_TOR_LEFT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_MNT_LTOR_HP;
  self.max_health = DAT_MNT_LTOR_HP;
  self.armorvalue = DAT_MNT_LTOR_ARMMAX;
  self.max_armor = DAT_MNT_LTOR_ARMMAX;
  self.c_model = DAT_MNT_LTOR_MODEL;
  self.c_ofs = DAT_MNT_LTOR_OFFSET;
};
void() data_mnt_rtor={
  self.comp_id = M_TOR_RIGHT;
  self.c_parent = M_TOR_CENTER;
  self.health = DAT_MNT_RTOR_HP;
  self.max_health = DAT_MNT_RTOR_HP;
  self.armorvalue = DAT_MNT_RTOR_ARMMAX;
  self.max_armor = DAT_MNT_RTOR_ARMMAX;
  self.c_model = DAT_MNT_RTOR_MODEL;
  self.c_ofs = DAT_MNT_RTOR_OFFSET;
};
void() data_mnt_larm={  
  self.comp_id = M_ARM_LEFT;
  self.c_parent = M_TOR_LEFT;
  self.health = DAT_MNT_LARM_HP;
  self.max_health = DAT_MNT_LARM_HP;
  self.armorvalue = DAT_MNT_LARM_ARMMAX;
  self.max_armor = DAT_MNT_LARM_ARMMAX;
  self.c_model = DAT_MNT_LARM_MODEL;
  self.c_ofs = DAT_MNT_LARM_OFFSET;
};
void() data_mnt_rarm={  
  self.comp_id = M_ARM_RIGHT;
  self.c_parent = M_TOR_RIGHT;
  self.health = DAT_MNT_RARM_HP;
  self.max_health = DAT_MNT_RARM_HP;
  self.armorvalue = DAT_MNT_RARM_ARMMAX;
  self.max_armor = DAT_MNT_RARM_ARMMAX;
  self.c_model = DAT_MNT_RARM_MODEL;
  self.c_ofs = DAT_MNT_RARM_OFFSET;
};
void() data_mnt_cam={
  self.c_parent = M_TOR_CENTER;
  self.comp_id = -1;
  self.c_ofs = DAT_MNT_CAM_OFFSET;
  self.c_alt_ofs = DAT_MNT_CAM_OFFSET_ALT;
  self.c_model = DAT_MNT_CAM_MODEL;
};

//TODO - restore offsets d'oh
void() data_mnt_wep1={  
  self.c_parent = M_ARM_RIGHT;
  self.c_ofs = DAT_MNT_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON1;
};
void() data_mnt_wep2={  
  self.c_parent = M_ARM_RIGHT;
  self.c_ofs = DAT_MNT_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON2;
};
void() data_mnt_wep3={  
  self.c_parent = M_ARM_LEFT;
  self.c_ofs = DAT_MNT_WEP3_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON3;
};
void() data_mnt_wep4={  
  self.c_parent = M_ARM_LEFT;
  self.c_ofs = DAT_MNT_WEP4_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON4;
};
void() data_mnt_wep5={  
  self.c_parent = M_TOR_RIGHT;
  self.c_ofs = DAT_MNT_WEP5_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON5;
};
void() data_mnt_wep6={  
  self.c_parent = M_TOR_LEFT;
  self.c_ofs = DAT_MNT_WEP6_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON6;
};
void() data_mnt_wep7={  
  self.c_parent = M_TOR_CENTER;
  self.c_ofs = DAT_MNT_WEP7_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON7;
};
void() data_mnt_wep8={  
  self.c_parent = M_TOR_RIGHT;
  self.c_ofs = DAT_MNT_WEP8_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON8;
};
void() data_mnt_wep9={  
  self.c_parent = M_TOR_LEFT;
  self.c_ofs = DAT_MNT_WEP9_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = WEAPON9;
};