/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: HEVIDAHL
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//HEVIDAHL MECH=============================
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
string DAT_HVD_CPIT_MODEL = "gfx/ui/hgr_hvd.png";
float DAT_HVD_M_FSPEED=150;
float DAT_HVD_M_SSPEED=150;
float DAT_HVD_M_BSPEED=100;
float DAT_HVD_HARDPOINTS = 9;

//HITPOINT VALUES
float DAT_HVD_CTOR_HPMAX= 1200;
float DAT_HVD_LEG_HPMAX= 1500;
float DAT_HVD_LTOR_HPMAX= 1200;
float DAT_HVD_RTOR_HPMAX= 1200;
float DAT_HVD_LARM_HPMAX= 1000;
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
string DAT_HVD_M_ACCEL="1";
string DAT_HVD_M_ROLLANGLE="2.25";
string DAT_HVD_M_PITCH_N="90";
string DAT_HVD_M_PITCH_X="-90";
string DAT_HVD_M_BOB = "0.0008";
string DAT_HVD_M_BCYCLE =  "0.5";
string DAT_HVD_M_BUP = "0.5";
string DAT_HVD_M_BMODEL = "1";
string DAT_HVD_M_BSIDE = "0.35";
string DAT_HVD_M_BSPD = "6.55";

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

void(vector org) hvd_renderHardpoints={
  ui_renderHardPointGraphic(HARDPOINTS[1], (org + '-82 -48'), (PLAYER_HELPER.plr_sel_hrpnt == 1));
  ui_renderHardPointGraphic(HARDPOINTS[2], (org + '-64 -24'), (PLAYER_HELPER.plr_sel_hrpnt == 2));
  ui_renderHardPointGraphic(HARDPOINTS[3], (org + '60 -48'), (PLAYER_HELPER.plr_sel_hrpnt == 3));
  ui_renderHardPointGraphic(HARDPOINTS[4], (org + '44 -24'), (PLAYER_HELPER.plr_sel_hrpnt == 4));
  ui_renderHardPointGraphic(HARDPOINTS[5], (org + '-38 -90'), (PLAYER_HELPER.plr_sel_hrpnt == 5));
  ui_renderHardPointGraphic(HARDPOINTS[6], (org + '14 -90'), (PLAYER_HELPER.plr_sel_hrpnt == 6));
  ui_renderHardPointGraphic(HARDPOINTS[7], (org + '-12 -44'), (PLAYER_HELPER.plr_sel_hrpnt == 7));
  ui_renderHardPointGraphic(HARDPOINTS[8], (org + '-38 -54'), (PLAYER_HELPER.plr_sel_hrpnt == 8));
  ui_renderHardPointGraphic(HARDPOINTS[9], (org + '14 -54'), (PLAYER_HELPER.plr_sel_hrpnt == 9));
};

float(vector org) hvd_hardpointListener={
  if(menu_checkMouseInBounds(cursorpos, org +  '-82 -48', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON1;
    return 1;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '-64 -24', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON2;
    return 2;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '60 -48', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON3;
    return 3;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '44 -24', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON4;
    return 4;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '-34 -90', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON5;
    return 5;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '18 -90', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON6;
    return 6;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  '-8 -40', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON7;
    return 7;
  } 
  if(menu_checkMouseInBounds(cursorpos, org +  '-34 -50', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON8;
    return 8;
  } 
  if(menu_checkMouseInBounds(cursorpos, org +  '18 -50', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON9;
    return 9;
  }
};

//call this guy at the start of the world ini
void() data_mech_hvd={
  local entity hvd, oself;
  oself = self;
  hvd = spawn();
  self = hvd;
    self.data_idx = DAT_HVD_IDX;
    self.vec_name = DAT_HVD_VEC_NAME;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_size = 3;
    self.c_mdl = DAT_HVD_CPIT_MODEL;
    self.menu_renderHardpoints = hvd_renderHardpoints;
    self.menu_hardpointListener = hvd_hardpointListener;
    data_hvd_ini();
  self = oself;
};

void() data_hvd_ini={
  self.data_idx= DAT_HVD_IDX;
  self.vec_name= DAT_HVD_VEC_NAME;
  self.i_techlvl= DAT_HVD_TECH_LEVEL;
  self.i_reserve= DAT_HVD_RESERVE_COST;
  self.c_mdl = DAT_HVD_CPIT_MODEL;
  self.en_cur= DAT_HVD_ENERGY_CUR;
  self.en_max= DAT_HVD_ENERGY_MAX;
  self.en_rate= DAT_HVD_ENERGY_RATE;
  self.sh_cur= DAT_HVD_SHIELD_CUR;
  self.sh_max= DAT_HVD_SHIELD_MAX;
  self.sh_rate= DAT_HVD_SHIELD_RATE;
  self.hardpoint_cnt = DAT_HVD_HARDPOINTS; 
  self.m_fspeed = DAT_HVD_M_FSPEED;
  self.m_sspeed = DAT_HVD_M_SSPEED;
  self.m_bspeed = DAT_HVD_M_BSPEED;
  self.m_maccel = DAT_HVD_M_ACCEL;
  self.m_pitch_max = DAT_HVD_M_PITCH_N;
  self.m_pitch_min = DAT_HVD_M_PITCH_X;
  self.c_bbx_x = DAT_HVD_CTOR_BBX_X;
  self.c_bbx_n = DAT_HVD_CTOR_BBX_N;
  self.e_model = DAT_HVD_CTOR_MODEL;
  self.hp_ctor = DAT_HVD_CTOR_HPMAX;
  self.hp_stor = DAT_HVD_LTOR_HPMAX;
  self.hp_arm = DAT_HVD_LARM_HPMAX;
  self.hp_leg = DAT_HVD_LEG_HPMAX;
};