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
string DAT_MTK_VEC_NAME = "Matok";
float DAT_MTK_TECH_LEVEL = 2;
float DAT_MTK_RADAR_RANGE = 3000;
float DAT_MTK_RESERVE_COST = 200;
float DAT_MTK_ENERGY_CUR = 800;
float DAT_MTK_ENERGY_MAX = 800;
float DAT_MTK_ENERGY_RATE = 3;
float DAT_MTK_SHIELD_CUR = 425;
float DAT_MTK_SHIELD_MAX = 425;
float DAT_MTK_SHIELD_RATE = 0.75;
vector DAT_MTK_CTOR_BBX_N ='-15 -15 -35';
vector DAT_MTK_CTOR_BBX_X ='15 15 14';
string DAT_MTK_CPIT_MODEL = "gfx/ui/hgr_mtk.png";
float DAT_MTK_M_FSPEED=112; //225;
float DAT_MTK_M_SSPEED=112; //225;
float DAT_MTK_M_BSPEED=95; //190;
float DAT_MTK_HARDPOINTS = 5;

//HITPOINT VALUES
float DAT_MTK_CTOR_HPMAX= 650;
float DAT_MTK_LEG_HPMAX= 900;
float DAT_MTK_LTOR_HPMAX= 600;
float DAT_MTK_RTOR_HPMAX= 600;
float DAT_MTK_LARM_HPMAX= 675;
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
float DAT_MTK_WEP5_IDX= ID_WEP_EMP;
float DAT_MTK_WEP1_GROUP= 1;
float DAT_MTK_WEP2_GROUP= 1;
float DAT_MTK_WEP3_GROUP= 2;
float DAT_MTK_WEP4_GROUP= 2;
float DAT_MTK_WEP5_GROUP= 3;

//this is mostly cosmetics
string DAT_MTK_CTOR_MODEL= "q3mdl/mechs/ntmk/mdl_ntmk_t_cent.md3";
string DAT_MTK_M_ACCEL="1";
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
vector DAT_MTK_WEP1_OFFSET= '9 9 -1';
vector DAT_MTK_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_MTK_WEP2_CPARENT= M_TOR_LEFT;
vector DAT_MTK_WEP2_OFFSET= '-9 9 -1';
vector DAT_MTK_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_MTK_WEP3_CPARENT= M_ARM_RIGHT;
vector DAT_MTK_WEP3_OFFSET= '15 -4 1.5';
vector DAT_MTK_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_MTK_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_MTK_WEP4_OFFSET= '-15 -4 1.5';
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

void(vector org) mtk_renderHardpoints={
  ui_renderHardPointGraphic(HARDPOINTS[1], (org + '-44 -100'), (PLAYER_HELPER.plr_sel_hrpnt == 1));
  ui_renderHardPointGraphic(HARDPOINTS[2], (org + '22 -100'), (PLAYER_HELPER.plr_sel_hrpnt == 2));
  ui_renderHardPointGraphic(HARDPOINTS[3], (org + '-84 -40'), (PLAYER_HELPER.plr_sel_hrpnt == 3));
  ui_renderHardPointGraphic(HARDPOINTS[4], (org + '58 -40'), (PLAYER_HELPER.plr_sel_hrpnt == 4));
  ui_renderHardPointGraphic(HARDPOINTS[5], (org + '-12 -94'), (PLAYER_HELPER.plr_sel_hrpnt == 5));
};

float(vector org) mtk_hardpointListener={
  if(menu_checkMouseInBounds(cursorpos, org + '-44 -100', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON1;
    return 1;
  }  
  if(menu_checkMouseInBounds(cursorpos, org + '22 -100', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON2;
    return 2;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + '-84 -40','24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON3;
    return 3;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + '58 -40', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON4;
    return 4;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + '-12 -94', '24 24')){
    PLAYER_HELPER.plr_sel_wid = WEAPON5;
    return 5;
  } 
  return 0;
};

//call this guy at the start of the world ini
void() data_mech_mtk={
  local entity mtk, oself;
  mtk = spawn();
  oself = self;
  self = mtk;
    self.data_idx = ID_MCH_MATOK;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_name = DAT_MTK_VEC_NAME;
    self.vec_size = SZ_MCH_MATOK;
    self.c_mdl = DAT_MTK_CPIT_MODEL;
    self.menu_renderHardpoints = mtk_renderHardpoints;
    self.menu_hardpointListener = mtk_hardpointListener;
    data_mtk_ini();
    self.plr_nex_wep1 = ID_WEP_LATC;
    self.plr_nex_wep2 = ID_WEP_LATC;
    self.plr_nex_wep3 = ID_WEP_LAS;
    self.plr_nex_wep4 = ID_WEP_LAS;
    self.plr_nex_wep5 = ID_WEP_ESR;
    self.plr_nex_wep6 = 0;
    self.plr_nex_wep7 = 0;
    self.plr_nex_wep8 = 0;
    self.plr_nex_wep9 = 0;
    self.plr_nex_grp1 = 0;
    self.plr_nex_grp2 = 0;
    self.plr_nex_grp3 = 0;
    self.plr_nex_grp4 = 0;
    self.plr_nex_grp5 = 0;
  self = oself;
};

void() data_mtk_ini={
  self.vec_name= DAT_MTK_VEC_NAME;
  self.i_techlvl= DAT_MTK_TECH_LEVEL;
  self.i_reserve= DAT_MTK_RESERVE_COST;
  self.c_mdl = DAT_MTK_CPIT_MODEL;
  self.en_cur= DAT_MTK_ENERGY_CUR;
  self.en_max= DAT_MTK_ENERGY_MAX;
  self.en_rate= DAT_MTK_ENERGY_RATE;
  self.sh_cur= DAT_MTK_SHIELD_CUR;
  self.sh_max= DAT_MTK_SHIELD_MAX;
  self.sh_rate= DAT_MTK_SHIELD_RATE;
  self.hardpoint_cnt = DAT_MTK_HARDPOINTS; 
  self.m_fspeed = DAT_MTK_M_FSPEED;
  self.m_sspeed = DAT_MTK_M_SSPEED;
  self.m_bspeed = DAT_MTK_M_BSPEED;
  self.m_maccel = DAT_MTK_M_ACCEL;
  self.m_pitch_max = DAT_MTK_M_PITCH_N;
  self.m_pitch_min = DAT_MTK_M_PITCH_X;
  self.c_bbx_x = DAT_MTK_CTOR_BBX_X;
  self.c_bbx_n = DAT_MTK_CTOR_BBX_N;
  self.e_model = DAT_MTK_CTOR_MODEL;
  self.hp_ctor = DAT_MTK_CTOR_HPMAX;
  self.hp_stor = DAT_MTK_LTOR_HPMAX;
  self.hp_arm = DAT_MTK_LARM_HPMAX;
  self.hp_leg = DAT_MTK_LEG_HPMAX;
};