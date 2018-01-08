/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: monitor
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//monitor MECH=============================
string DAT_MNT_VEC_NAME = "Monitor";
float DAT_MNT_RESERVE_COST = 200;
vector DAT_MNT_CTOR_BBX_N ='-22 -22 -44';
vector DAT_MNT_CTOR_BBX_X ='22 22 28';
string DAT_MNT_UI_IMG = "gfx/ui/hgr_MNT.png";
float DAT_MNT_HARDPOINTS = 9;

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
string DAT_MNT_M_ROLLANGLE="2.25";
string DAT_MNT_M_PITCH_N="90";
string DAT_MNT_M_PITCH_X="-90";
string DAT_MNT_M_BOB = "0.0008";
string DAT_MNT_M_BCYCLE =  "0.5";
string DAT_MNT_M_BUP = "0.5";
string DAT_MNT_M_BMODEL = "1";
string DAT_MNT_M_BSIDE = "0.35";
string DAT_MNT_M_BSPD = "6.55";

//LEGS
string DAT_MNT_LEG_CNAME= M_LEGS;

//CENTER TORSO
string DAT_MNT_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_MNT_LTOR_CNAME= M_TOR_LEFT;
string DAT_MNT_LTOR_CPARENT= M_TOR_CENTER;

//RIGHT TORSO
string DAT_MNT_RTOR_CNAME= M_TOR_RIGHT;
string DAT_MNT_RTOR_CPARENT= M_TOR_CENTER;

//LEFT ARM 
string DAT_MNT_LARM_CNAME= M_ARM_LEFT;
string DAT_MNT_LARM_CPARENT= M_TOR_LEFT;

//RIGHT ARM
string DAT_MNT_RARM_CNAME= M_ARM_RIGHT;
string DAT_MNT_RARM_CPARENT= M_TOR_RIGHT;

//CAMERA
string DAT_MNT_CAM_CNAME= "camera";

//WEAPON1
string DAT_MNT_WEP1_CPARENT= M_ARM_RIGHT;
vector DAT_MNT_WEP1_OFFSET_ALT= DAT_MNT_RARM_OFFSET;
vector DAT_MNT_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_MNT_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_MNT_WEP2_OFFSET_ALT= DAT_MNT_RARM_OFFSET;
vector DAT_MNT_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_MNT_WEP3_CPARENT= M_ARM_LEFT;
vector DAT_MNT_WEP3_OFFSET_ALT= DAT_MNT_LARM_OFFSET;
vector DAT_MNT_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_MNT_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_MNT_WEP4_OFFSET_ALT= DAT_MNT_LARM_OFFSET;
vector DAT_MNT_WEP4_ADJ_ANG= '0 0 0';

//WEAPON5
string DAT_MNT_WEP5_CPARENT= M_TOR_RIGHT;
vector DAT_MNT_WEP5_OFFSET_ALT= DAT_MNT_RTOR_OFFSET;
vector DAT_MNT_WEP5_ADJ_ANG= '0 0 0';

//WEAPON6
string DAT_MNT_WEP6_CPARENT= M_TOR_LEFT;
vector DAT_MNT_WEP6_OFFSET_ALT= DAT_MNT_LTOR_OFFSET;
vector DAT_MNT_WEP6_ADJ_ANG= '0 0 0';

//WEAPON7
string DAT_MNT_WEP7_CPARENT= M_TOR_CENTER;
vector DAT_MNT_WEP7_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP7_ADJ_ANG= '0 0 0';

//WEAPON8
string DAT_MNT_WEP8_CPARENT= M_TOR_RIGHT;
vector DAT_MNT_WEP8_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP8_ADJ_ANG= '0 0 0';

//WEAPON9
string DAT_MNT_WEP9_CPARENT= M_TOR_LEFT;
vector DAT_MNT_WEP9_OFFSET_ALT= '0 0 0';
vector DAT_MNT_WEP9_ADJ_ANG= '0 0 0';


//=========================================

void() data_mech_MNT;
void() data_MNT_ini;

void(vector org) MNT_renderHardpoints={
  if(PLAYER_HELPER.plr_menu_choice == MENU_ARMING_ACTIVE){
    ui_renderHardPointGraphic(HARDPOINTS[1], (org + gui_percentToPixelRawVec('-82 -48')), (PLAYER_HELPER.plr_sel_hrpnt == 1));
    ui_renderHardPointGraphic(HARDPOINTS[2], (org + gui_percentToPixelRawVec('-64 -24')), (PLAYER_HELPER.plr_sel_hrpnt == 2));
    ui_renderHardPointGraphic(HARDPOINTS[3], (org + gui_percentToPixelRawVec('60 -48')), (PLAYER_HELPER.plr_sel_hrpnt == 3));
    ui_renderHardPointGraphic(HARDPOINTS[4], (org + gui_percentToPixelRawVec('44 -24')), (PLAYER_HELPER.plr_sel_hrpnt == 4));
    ui_renderHardPointGraphic(HARDPOINTS[5], (org + gui_percentToPixelRawVec('-38 -90')), (PLAYER_HELPER.plr_sel_hrpnt == 5));
    ui_renderHardPointGraphic(HARDPOINTS[6], (org + gui_percentToPixelRawVec('14 -90')), (PLAYER_HELPER.plr_sel_hrpnt == 6));
    ui_renderHardPointGraphic(HARDPOINTS[7], (org + gui_percentToPixelRawVec('-12 -44')), (PLAYER_HELPER.plr_sel_hrpnt == 7));
    ui_renderHardPointGraphic(HARDPOINTS[8], (org + gui_percentToPixelRawVec('-38 -54')), (PLAYER_HELPER.plr_sel_hrpnt == 8));
    ui_renderHardPointGraphic(HARDPOINTS[9], (org + gui_percentToPixelRawVec('14 -54')), (PLAYER_HELPER.plr_sel_hrpnt == 9));
  }
  else if(PLAYER_HELPER.plr_menu_choice == MENU_HANGAR_ACTIVE){
    ui_renderHardPointNumber(1, (org + gui_percentToPixelRawVec('-64 -18')));
    ui_renderHardPointNumber(2, (org + gui_percentToPixelRawVec('-54 -18')));
    ui_renderHardPointNumber(3, (org + gui_percentToPixelRawVec('54 -18')));
    ui_renderHardPointNumber(4, (org + gui_percentToPixelRawVec('44 -18')));
    ui_renderHardPointNumber(5, (org + gui_percentToPixelRawVec('-32 -60')));
    ui_renderHardPointNumber(6, (org + gui_percentToPixelRawVec('22 -60')));
    ui_renderHardPointNumber(7, (org + gui_percentToPixelRawVec('-4 -30')));
    ui_renderHardPointNumber(8, (org + gui_percentToPixelRawVec('-30 -30')));
    ui_renderHardPointNumber(9, (org + gui_percentToPixelRawVec('24 -30')));
  }
};

void(vector org) MNT_hardpointrows={
  ui_renderHardpointRow(org, 1, DAT_MNT_HARDPOINT1_TYPES, DAT_MNT_HARDPOINT1_SIZE);
  ui_renderHardpointRow(org, 2, DAT_MNT_HARDPOINT2_TYPES, DAT_MNT_HARDPOINT2_SIZE);
  ui_renderHardpointRow(org, 3, DAT_MNT_HARDPOINT3_TYPES, DAT_MNT_HARDPOINT3_SIZE);
  ui_renderHardpointRow(org, 4, DAT_MNT_HARDPOINT4_TYPES, DAT_MNT_HARDPOINT4_SIZE);
  ui_renderHardpointRow(org, 5, DAT_MNT_HARDPOINT5_TYPES, DAT_MNT_HARDPOINT5_SIZE);
  ui_renderHardpointRow(org, 6, DAT_MNT_HARDPOINT6_TYPES, DAT_MNT_HARDPOINT6_SIZE);
  ui_renderHardpointRow(org, 7, DAT_MNT_HARDPOINT7_TYPES, DAT_MNT_HARDPOINT7_SIZE);
  ui_renderHardpointRow(org, 8, DAT_MNT_HARDPOINT8_TYPES, DAT_MNT_HARDPOINT8_SIZE);
  ui_renderHardpointRow(org, 9, DAT_MNT_HARDPOINT9_TYPES, DAT_MNT_HARDPOINT9_SIZE);
};

float(vector org) MNT_hardpointListener={
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('-82 -48'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON1;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT1_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT1_TYPES;
    return 1;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('-64 -24'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON2;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT2_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT2_TYPES;
    return 2;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('60 -48'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON3;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT3_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT3_TYPES;
    return 3;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('44 -24'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON4;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT4_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT4_TYPES;
    return 4;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('-34 -90'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON5;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT5_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT5_TYPES;
    return 5;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('18 -90'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON6;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT6_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT6_TYPES;
    return 6;
  }
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('-8 -40'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON7;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT7_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT7_TYPES;
    return 7;
  } 
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('-34 -50'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON8;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT8_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT8_TYPES;
    return 8;
  } 
  if(menu_checkMouseInBounds(cursorpos, org +  gui_percentToPixelRawVec('18 -50'), gui_percentToPixelRawVec('24 24'))){
    PLAYER_HELPER.plr_sel_wid = WEAPON9;
    PLAYER_HELPER.plr_sel_hrpnt_size = DAT_MNT_HARDPOINT9_SIZE;
    PLAYER_HELPER.plr_sel_hrpnt_types = DAT_MNT_HARDPOINT9_TYPES;
    return 9;
  }
  return 0;
};

//call this guy at the start of the world ini
void() data_mech_MNT={
  local entity MNT, oself;
  oself = self;
  MNT = spawn();
  self = MNT;
    self.data_idx = ID_MCH_HEVDAHL;
    self.vec_name = DAT_MNT_VEC_NAME;
    self.classname = "data";
    self.data_type = DATA_MECH;
    self.vec_size = SZ_MCH_HEVDAHL;
    self.c_mdl = DAT_MNT_CPIT_MODEL;
    self.menu_renderHardpoints = MNT_renderHardpoints;
    self.menu_hardpointListener = MNT_hardpointListener;
    self.menu_hardpointRows = MNT_hardpointrows;
    data_MNT_ini();
    self.plr_nex_wep1 = ID_WEP_LATC;
    self.plr_nex_wep2 = ID_WEP_LATC;
    self.plr_nex_wep3 = ID_WEP_LAS;
    self.plr_nex_wep4 = ID_WEP_LAS;
    self.plr_nex_wep5 = ID_WEP_EMP;
    self.plr_nex_wep6 = ID_WEP_EMP;
    self.plr_nex_wep7 = ID_WEP_MIS;
    self.plr_nex_wep8 = ID_WEP_MIS;
    self.plr_nex_wep9 = ID_WEP_MIS;
    self.plr_nex_grp1 = WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;
    self.plr_nex_grp2 = WEAPON5 | WEAPON6;
    self.plr_nex_grp3 = WEAPON7 | WEAPON8 | WEAPON9;
    self.plr_nex_grp4 = 0;
    self.plr_nex_grp5 = 0;
  self = oself;
};

void() data_MNT_ini={
  self.vec_name= DAT_MNT_VEC_NAME;
  self.i_techlvl= DAT_MNT_TECH_LEVEL;
  self.i_reserve= DAT_MNT_RESERVE_COST;
  self.c_mdl = DAT_MNT_UI_IMG;
  self.en_cur= DAT_MNT_ENERGY_MAX;
  self.en_max= DAT_MNT_ENERGY_MAX;
  self.en_rate= DAT_MNT_ENERGY_RATE;
  self.sh_cur= DAT_MNT_SHIELD_MAX;
  self.sh_max= DAT_MNT_SHIELD_MAX;
  self.sh_rate= DAT_MNT_SHIELD_RATE;
  self.hardpoint_cnt = DAT_MNT_HARDPOINTS; 
  self.m_fspeed = DAT_MNT_M_FSPEED;
  self.m_sspeed = DAT_MNT_M_SSPEED;
  self.m_bspeed = DAT_MNT_M_BSPEED;
  self.m_maccel = DAT_MNT_M_ACCEL;
  self.m_pitch_max = DAT_MNT_M_PITCH_N;
  self.m_pitch_min = DAT_MNT_M_PITCH_X;
  self.c_bbx_x = DAT_MNT_CTOR_BBX_X;
  self.c_bbx_n = DAT_MNT_CTOR_BBX_N;
  self.e_model = DAT_MNT_CTOR_MODEL;
  self.hp_ctor = DAT_MNT_CTOR_HP;
  self.hp_stor = DAT_MNT_LTOR_HP;
  self.hp_arm = DAT_MNT_LARM_HP;
  self.hp_leg = DAT_MNT_LEG_HP;
  self.radar_range = DAT_MNT_RADAR_RANGE;
};