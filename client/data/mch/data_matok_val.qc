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
string DAT_MTK_VEC_NAME = "Matok";
float DAT_MTK_RESERVE_COST = 200;
vector DAT_MTK_CTOR_BBX_N = '-17 -17 -40';
vector DAT_MTK_CTOR_BBX_X = '17 17 22';
float DAT_MTK_HARDPOINTS = 5;

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

//CENTER TORSO
string DAT_MTK_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_MTK_LTOR_CNAME= M_TOR_LEFT;
string DAT_MTK_LTOR_CPARENT= M_TOR_CENTER;

//RIGHT TORSO
string DAT_MTK_RTOR_CNAME= M_TOR_RIGHT;
string DAT_MTK_RTOR_CPARENT= M_TOR_CENTER;

//LEFT ARM 
string DAT_MTK_LARM_CNAME= M_ARM_LEFT;
string DAT_MTK_LARM_CPARENT= M_TOR_LEFT;

//RIGHT ARM
string DAT_MTK_RARM_CNAME= M_ARM_RIGHT;
string DAT_MTK_RARM_CPARENT= M_TOR_RIGHT;

//CAMERA
string DAT_MTK_CAM_CNAME= "camera";

//WEAPON1
string DAT_MTK_WEP1_CPARENT= M_TOR_RIGHT;
vector DAT_MTK_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_MTK_WEP2_CPARENT= M_TOR_LEFT;
vector DAT_MTK_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_MTK_WEP3_CPARENT= M_ARM_RIGHT;
vector DAT_MTK_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP3_ADJ_ANG= '0 0 90';

//WEAPON4
string DAT_MTK_WEP4_CPARENT= M_ARM_LEFT;
vector DAT_MTK_WEP4_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP4_ADJ_ANG= '0 0 0';

//WEAPON5
string DAT_MTK_WEP5_CPARENT= M_TOR_CENTER;
vector DAT_MTK_WEP5_OFFSET_ALT= '0 0 0';
vector DAT_MTK_WEP5_ADJ_ANG= '0 0 0';

//=========================================
void() data_mech_mtk;

void(vector org) mtk_renderHardpoints={
  if(self.plr_menu_choice == MENU_ARMING_ACTIVE){
    ui_renderHardPointGraphic(HARDPOINTS[1], (org + gui_percentToPixelRawVec('-77 16')), (self.plr_sel_hrpnt == 1));
    ui_renderHardPointGraphic(HARDPOINTS[2], (org + gui_percentToPixelRawVec('48 16')), (self.plr_sel_hrpnt == 2));
    ui_renderHardPointGraphic(HARDPOINTS[3], (org + gui_percentToPixelRawVec('-135 80')), (self.plr_sel_hrpnt == 3));
    ui_renderHardPointGraphic(HARDPOINTS[4], (org + gui_percentToPixelRawVec('105 80')), (self.plr_sel_hrpnt == 4));
    ui_renderHardPointGraphic(HARDPOINTS[5], (org + gui_percentToPixelRawVec('-15 -82')), (self.plr_sel_hrpnt == 5));
  }
  else if(self.plr_menu_choice == MENU_HANGAR_ACTIVE){
    ui_renderHardPointNumber(1, (org + gui_percentToPixelRawVec('-40 -36')));
    ui_renderHardPointNumber(2, (org + gui_percentToPixelRawVec('28 -36')));
    ui_renderHardPointNumber(3, (org + gui_percentToPixelRawVec('-74 -16')));
    ui_renderHardPointNumber(4, (org + gui_percentToPixelRawVec('64 -16')));
    ui_renderHardPointNumber(5, (org + gui_percentToPixelRawVec('-4 -74')));
  }
};

void(vector org) MTK_hardpointrows={
  ui_renderHardpointRow(org, 1, DAT_MTK_HARDPOINT1_TYPES, DAT_MTK_HARDPOINT1_SIZE);
  ui_renderHardpointRow(org, 2, DAT_MTK_HARDPOINT2_TYPES, DAT_MTK_HARDPOINT2_SIZE);
  ui_renderHardpointRow(org, 3, DAT_MTK_HARDPOINT3_TYPES, DAT_MTK_HARDPOINT3_SIZE);
  ui_renderHardpointRow(org, 4, DAT_MTK_HARDPOINT4_TYPES, DAT_MTK_HARDPOINT4_SIZE);
  ui_renderHardpointRow(org, 5, DAT_MTK_HARDPOINT5_TYPES, DAT_MTK_HARDPOINT5_SIZE);
};

float(vector org) mtk_hardpointListener={
  if(menu_checkMouseInBounds(cursorpos, org + gui_percentToPixelRawVec('-77 16'), gui_percentToPixelRawVec('28 28'))){
    self.plr_sel_wid = WEAPON1;
    self.plr_sel_hrpnt_size = DAT_MTK_HARDPOINT1_SIZE;
    self.plr_sel_hrpnt_types = DAT_MTK_HARDPOINT1_TYPES;
    return 1;
  }  
  if(menu_checkMouseInBounds(cursorpos, org + gui_percentToPixelRawVec('48 16'), gui_percentToPixelRawVec('28 28'))){
    self.plr_sel_wid = WEAPON2;
    self.plr_sel_hrpnt_size = DAT_MTK_HARDPOINT2_SIZE;
    self.plr_sel_hrpnt_types = DAT_MTK_HARDPOINT2_TYPES;
    return 2;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + gui_percentToPixelRawVec('-135 80'),gui_percentToPixelRawVec('28 28'))){
    self.plr_sel_wid = WEAPON3;
    self.plr_sel_hrpnt_size = DAT_MTK_HARDPOINT3_SIZE;
    self.plr_sel_hrpnt_types = DAT_MTK_HARDPOINT3_TYPES;
    return 3;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + gui_percentToPixelRawVec('105 80'), gui_percentToPixelRawVec('28 28'))){
    self.plr_sel_wid = WEAPON4;
    self.plr_sel_hrpnt_size = DAT_MTK_HARDPOINT4_SIZE;
    self.plr_sel_hrpnt_types = DAT_MTK_HARDPOINT4_TYPES;
    return 4;
  } 
  if(menu_checkMouseInBounds(cursorpos, org + gui_percentToPixelRawVec('-15 -82'), gui_percentToPixelRawVec('28 28'))){
    self.plr_sel_wid = WEAPON5;
    self.plr_sel_hrpnt_size = DAT_MTK_HARDPOINT5_SIZE;
    self.plr_sel_hrpnt_types = DAT_MTK_HARDPOINT5_TYPES;
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
    self.classname = "data_mech";
    self.data_type = DATA_MECH;
    self.vec_name = DAT_MTK_VEC_NAME;
    self.vec_size = SZ_MCH_MATOK;
    self.vec_name= DAT_MTK_VEC_NAME;
    self.i_techlvl= DAT_MTK_TECH_LEVEL;
    self.i_reserve= DAT_MTK_RESERVE_COST;
    self.c_mdl = DAT_MTK_UI_IMG;
    self.c_ui_hf = "gfx/ui/hgr_mtk_hf.png";
    self.en_cur= DAT_MTK_ENERGY_MAX;
    self.en_max= DAT_MTK_ENERGY_MAX;
    self.en_rate= DAT_MTK_ENERGY_RATE;
    self.sh_cur= DAT_MTK_SHIELD_MAX;
    self.sh_max= DAT_MTK_SHIELD_MAX;
    self.sh_rate= DAT_MTK_SHIELD_RATE;
    self.hardpoint_cnt = DAT_MTK_HARDPOINTS; 
    self.m_fspeed = DAT_MTK_M_FSPEED;
    self.m_sspeed = DAT_MTK_M_SSPEED;
    self.m_bspeed = DAT_MTK_M_BSPEED;
    self.m_maccel = DAT_MTK_M_ACCEL;
    self.e_model = DAT_MTK_CTOR_MODEL;
    self.hp_ctor = DAT_MTK_CTOR_HP;
    self.hp_stor = DAT_MTK_LTOR_HP;
    self.hp_arm = DAT_MTK_LARM_HP;
    self.hp_leg = DAT_MTK_LEG_HP;
    self.radar_range = DAT_MTK_RADAR_RANGE;
  
    self.menu_renderHardpoints = mtk_renderHardpoints;
    self.menu_hardpointListener = mtk_hardpointListener;
    self.menu_hardpointRows = MTK_hardpointrows;
    self.plr_nex_wep1 = ID_WEP_LATC;
    self.plr_nex_wep2 = ID_WEP_LATC;
    self.plr_nex_wep3 = ID_WEP_LAS;
    self.plr_nex_wep4 = ID_WEP_LAS;
    self.plr_nex_wep5 = ID_WEP_ESR;
    self.plr_nex_wep6 = 0;
    self.plr_nex_wep7 = 0;
    self.plr_nex_wep8 = 0;
    self.plr_nex_wep9 = 0;
    self.plr_nex_grp1 = WEAPON1 | WEAPON2;
    self.plr_nex_grp2 = WEAPON3 | WEAPON4;
    self.plr_nex_grp3 = WEAPON5;
    self.plr_nex_grp4 = 0;
    self.plr_nex_grp5 = 0;
    self.drawmask = MASK_NORMAL;
    self.note1 = "The MATOK was the second-generation combat mech that Federal Military churned out as the threat of AUTHOR was increasing. MATOKs are the main stay of Federal squadrons today, found in almost every  deployment and any combat. \n \n A dangerous generalist, the MATOK is design to engage targets head on with a slew of direct-fire power and large reactor recharge capacity. \n \n MATOK operators have to remember not to get surrounded though, the MATOK's defensive capabilities are not as strong as its defense. Its speed is also a problem against more agile targets.";
  self = oself;
};