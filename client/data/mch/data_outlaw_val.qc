/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: moving all mech values into a single global file for ease of maintenance.
  mech: OUTLAW
-the search function will be your best friend in these files...
-these are utilized by their relevant data entity and its ini functions
*/

//OUTLAW MECH=============================
string DAT_OTL_VEC_NAME = "Balakett";
float DAT_OTL_RESERVE_COST = 100;
vector DAT_OTL_CTOR_BBX_N ='-14 -14 -35';
vector DAT_OTL_CTOR_BBX_X ='14 14 16';

float DAT_OTL_HARDPOINTS = 3;

float DAT_OTL_WEP1_IDX= ID_WEP_LATC;
float DAT_OTL_WEP2_IDX= ID_WEP_LATC;
float DAT_OTL_WEP3_IDX= ID_WEP_EMP;

float DAT_OTL_WEP1_GROUP= 1;
float DAT_OTL_WEP2_GROUP= 1;
float DAT_OTL_WEP3_GROUP= 2;

string DAT_OTL_M_ROLLANGLE="2";
string DAT_OTL_M_PITCH_N="90";
string DAT_OTL_M_PITCH_X="-90";
string DAT_OTL_M_BOB = "0.0008";
string DAT_OTL_M_BCYCLE =  "0.5";
string DAT_OTL_M_BUP = "0.5";
string DAT_OTL_M_BMODEL = "1";
string DAT_OTL_M_BSIDE = "0.35";
string DAT_OTL_M_BSPD = "6.55";

//LEGS
string DAT_OTL_LEG_CNAME= M_LEGS;

//CENTER TORSO
string DAT_OTL_CTOR_CNAME= M_TOR_CENTER;

//LEFT TORSO
string DAT_OTL_LTOR_CNAME= M_TOR_LEFT;
string DAT_OTL_LTOR_CPARENT= M_TOR_CENTER;

//RIGHT TORSO
string DAT_OTL_RTOR_CNAME= M_TOR_RIGHT;
string DAT_OTL_RTOR_CPARENT= M_TOR_CENTER;

//LEFT ARM 
string DAT_OTL_LARM_CNAME= M_ARM_LEFT;
string DAT_OTL_LARM_CPARENT= M_TOR_LEFT;

//RIGHT ARM
string DAT_OTL_RARM_CNAME= M_ARM_RIGHT;
string DAT_OTL_RARM_CPARENT= M_TOR_RIGHT;

//CAMERA
string DAT_OTL_CAM_CNAME= "camera";

//WEAPON1
string DAT_OTL_WEP1_CPARENT= M_ARM_LEFT;
vector DAT_OTL_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_OTL_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_OTL_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_OTL_WEP3_CPARENT= M_TOR_CENTER;
vector DAT_OTL_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP3_ADJ_ANG= '0 0 0';

//=========================================

void() data_mech_otl;

void(vector org) otl_renderHardpoints={
  
  if(self.plr_menu_choice == MENU_ARMING_ACTIVE){
    ui_renderHardPointGraphic(HARDPOINTS[1], (org + gui_percentToPixelRawVec('52 65')), (self.plr_sel_hrpnt == 1));
    ui_renderHardPointNumber(1, (org + gui_percentToPixelRawVec('52 65')));
    
    ui_renderHardPointGraphic(HARDPOINTS[2], (org + gui_percentToPixelRawVec('-75 65')), (self.plr_sel_hrpnt == 2));
    ui_renderHardPointNumber(2, (org + gui_percentToPixelRawVec('-75 65')));
    
    ui_renderHardPointGraphic(HARDPOINTS[3], (org + gui_percentToPixelRawVec('0 -5')), (self.plr_sel_hrpnt == 3));
    ui_renderHardPointNumber(3, (org + gui_percentToPixelRawVec('0 -5')));
  }
  else if(self.plr_menu_choice == MENU_HANGAR_ACTIVE){
    ui_renderHardPointNumber(1, (org + gui_percentToPixelRawVec('42 -14')));
    ui_renderHardPointNumber(2, (org + gui_percentToPixelRawVec('-50 -14')));
    ui_renderHardPointNumber(3, (org + gui_percentToPixelRawVec('8 -50')));
  }
};

void(vector org) otl_hardpointrows={
  ui_renderHardpointRow(org, 1, DAT_BLK_HARDPOINT1_TYPES, DAT_BLK_HARDPOINT1_SIZE);
  ui_renderHardpointRow(org, 2, DAT_BLK_HARDPOINT2_TYPES, DAT_BLK_HARDPOINT2_SIZE);
  ui_renderHardpointRow(org, 3, DAT_BLK_HARDPOINT3_TYPES, DAT_BLK_HARDPOINT3_SIZE);
};

float(vector org) otl_hardpointListener={
  if(menu_checkMouseInBounds(cursorpos, (org + gui_percentToPixelRawVec('52 65')), gui_percentToPixelRawVec('24 24'))){
    self.plr_sel_wid = WEAPON1;
    self.plr_sel_hrpnt_size = DAT_BLK_HARDPOINT1_SIZE;
    self.plr_sel_hrpnt_types = DAT_BLK_HARDPOINT1_TYPES;
    return 1;
  }  
  if(menu_checkMouseInBounds(cursorpos, (org + gui_percentToPixelRawVec('-75 65')), gui_percentToPixelRawVec('24 24'))){
    self.plr_sel_wid = WEAPON2;
    self.plr_sel_hrpnt_size = DAT_BLK_HARDPOINT2_SIZE;
    self.plr_sel_hrpnt_types = DAT_BLK_HARDPOINT2_TYPES;
    return 2;
  }
  if(menu_checkMouseInBounds(cursorpos, (org + gui_percentToPixelRawVec('0 -5')), gui_percentToPixelRawVec('24 24'))){
    self.plr_sel_wid = WEAPON3;
    self.plr_sel_hrpnt_size = DAT_BLK_HARDPOINT3_SIZE;
    self.plr_sel_hrpnt_types = DAT_BLK_HARDPOINT3_TYPES;
    return 3;
  }  
  return 0;
};

//call this guy at the start of the world ini
void() data_mech_otl={
  local entity otl, oself;
  oself = self;
  otl = spawn();
  self = otl;
    self.data_idx = ID_MCH_BALAKET;
    self.vec_name = DAT_OTL_VEC_NAME;
    self.classname = "data_mech";
    self.data_type = DATA_MECH;
    self.vec_size = SZ_MCH_BALAKET;
    self.vec_name= DAT_OTL_VEC_NAME;
    self.i_techlvl= DAT_OTL_TECH_LEVEL;
    self.i_reserve= DAT_OTL_RESERVE_COST;
    self.c_mdl = DAT_OTL_UI_IMG;
    self.c_ui_hf = "gfx/ui/hgr_blk_hf.png";
    self.en_cur= DAT_OTL_ENERGY_MAX;
    self.en_max= DAT_OTL_ENERGY_MAX;
    self.en_rate= DAT_OTL_ENERGY_RATE;
    self.sh_cur= DAT_OTL_SHIELD_MAX;
    self.sh_max= DAT_OTL_SHIELD_MAX;
    self.sh_rate= DAT_OTL_SHIELD_RATE;
    self.hardpoint_cnt = DAT_OTL_HARDPOINTS; 
    self.m_fspeed = DAT_OTL_M_FSPEED;
    self.m_sspeed = DAT_OTL_M_SSPEED;
    self.m_bspeed = DAT_OTL_M_BSPEED;
    self.m_maccel = DAT_OTL_M_ACCEL;
    self.e_model = DAT_OTL_CTOR_MODEL;
    self.hp_ctor = DAT_OTL_CTOR_HP;
    self.hp_stor = DAT_OTL_LTOR_HP;
    self.hp_arm = DAT_OTL_LARM_HP;
    self.hp_leg = DAT_OTL_LEG_HP;
    self.radar_range = DAT_OTL_RADAR_RANGE;
    self.menu_renderHardpoints = otl_renderHardpoints;
    self.menu_hardpointListener = otl_hardpointListener;
    self.menu_hardpointRows = otl_hardpointrows;
    self.plr_nex_wep1 = 1;
    self.plr_nex_wep2 = 1;
    self.plr_nex_wep3 = 17;
    self.plr_nex_wep4 = 0;
    self.plr_nex_wep5 = 0;
    self.plr_nex_wep6 = 0;
    self.plr_nex_wep7 = 0;
    self.plr_nex_wep8 = 0;
    self.plr_nex_wep9 = 0;
    self.plr_nex_grp1 = WEAPON1 | WEAPON2;
    self.plr_nex_grp2 = WEAPON3;
    self.plr_nex_grp3 = 0;
    self.plr_nex_grp4 = 0;
    self.plr_nex_grp5 = 0;
    self.drawmask = MASK_NORMAL;
    //38 chars per line
    self.note1 = "A primitive combat platform, BALAKETTs| come from the early days of the| Federation. Originally billed as exp| loration vehicles, Federation Military| found them able anti-partisan units.| |BALAKETT units are best against other| light and smaller targets. Their | weapon mount limitations prevent them| from engaging larger foes one-on-one.| |They are dangerous in packs though, | their quick speed and variable-enough| loadouts keeping singular targets| distracted; unable to land that fatal| blow.";
  self = oself;
  addentity(otl);
};