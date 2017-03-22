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
float DAT_OTL_ENERGY_CUR = 75;
float DAT_OTL_ENERGY_MAX = 75;
float DAT_OTL_ENERGY_RATE = 0.15;
float DAT_OTL_SHIELD_CUR = 125;
float DAT_OTL_SHIELD_MAX = 125;
float DAT_OTL_SHIELD_RATE = 0.075;
vector DAT_OTL_CTOR_BBX_N ='-11 -11 -34';
vector DAT_OTL_CTOR_BBX_X ='11 11 12';
string DAT_OTL_CPIT_MODEL= "gfx/ui/hgr_otl.png";
float DAT_OTL_M_FSPEED=175;
float DAT_OTL_M_SSPEED=150;
float DAT_OTL_M_BSPEED=150;

float DAT_OTL_LEG_HP = 100;
float DAT_OTL_LEG_HPMAX= 100;
float DAT_OTL_CTOR_HP = 100;
float DAT_OTL_CTOR_HPMAX= 100;
float DAT_OTL_LTOR_HP = 100;
float DAT_OTL_LTOR_HPMAX= 100;
float DAT_OTL_RTOR_HP = 100;
float DAT_OTL_RTOR_HPMAX= 100;
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
string DAT_OTL_M_BUP = "0.5";
string DAT_OTL_M_BMODEL = "1";
string DAT_OTL_M_BSIDE = "0.35";
string DAT_OTL_M_BSPD = "6.55";

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
vector DAT_OTL_WEP1_OFFSET= '-14 -3 1';
vector DAT_OTL_WEP1_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_OTL_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_OTL_WEP2_OFFSET= '14 -3 1';
vector DAT_OTL_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP2_ADJ_ANG= '0 0 90';

//WEAPON3
string DAT_OTL_WEP3_CPARENT= M_TOR_CENTER;
vector DAT_OTL_WEP3_OFFSET= '0 8 0';
vector DAT_OTL_WEP3_OFFSET_ALT= '0 0 0';
vector DAT_OTL_WEP3_ADJ_ANG= '0 0 0';

//=========================================

void() data_mech_otl;
void() data_otl_ini;


void(vector org) otl_renderHardpoints={
  gui_DrawHighlightRect((PLAYER_HELPER.plr_sel_hrpnt == 3), org + '-10 -104', '32 32', '8 8', '1 1 0', '4 4', '1 1 1');
  drawstring(org + '-10 -104', ftos(PLAYER_HELPER.plr_nex_wep3), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawHighlightRect((PLAYER_HELPER.plr_sel_hrpnt == 2), org + '-75 -64', '32 32', '8 8', '1 1 0', '4 4', '1 1 1');
  drawstring(org + '-75 -64', ftos(PLAYER_HELPER.plr_nex_wep2), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawHighlightRect((PLAYER_HELPER.plr_sel_hrpnt == 1), org + '48 -64', '32 32', '8 8 0', '1 1 0', '4 4', '1 1 1'); 
  drawstring(org + '48 -64', ftos(PLAYER_HELPER.plr_nex_wep1), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

float(vector org) otl_hardpointListener={

  if(menu_checkMouseInBounds(cursorpos, org + '-10 -104', '32 32')){
    PLAYER_HELPER.plr_sel_wid = WEAPON3;
    return 3;
  }  
  
  if(menu_checkMouseInBounds(cursorpos, org + '-75 -64', '32 32')){
    PLAYER_HELPER.plr_sel_wid = WEAPON2;
    return 2;
  } 

  if(menu_checkMouseInBounds(cursorpos, org + '48 -64', '32 32')){
    PLAYER_HELPER.plr_sel_wid = WEAPON1;
    return 1;
  } 
};

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
    self.vec_size = 1;
    self.c_mdl = DAT_OTL_CPIT_MODEL;
    self.menu_renderHardpoints = otl_renderHardpoints;
    self.menu_hardpointListener = otl_hardpointListener;
    data_otl_ini();
  self = oself;
  addentity(otl);
};

void() data_otl_ini={
  self.data_idx= DAT_OTL_IDX;
  self.vec_name= DAT_OTL_VEC_NAME;
  self.i_techlvl= DAT_OTL_TECH_LEVEL;
  self.i_reserve= DAT_OTL_RESERVE_COST;
  self.c_mdl = DAT_OTL_CPIT_MODEL;
  self.en_cur= DAT_OTL_ENERGY_CUR;
  self.en_max= DAT_OTL_ENERGY_MAX;
  self.en_rate= DAT_OTL_ENERGY_RATE;
  self.sh_cur= DAT_OTL_SHIELD_CUR;
  self.sh_max= DAT_OTL_SHIELD_MAX;
  self.sh_rate= DAT_OTL_SHIELD_RATE;
  
  self.m_fspeed = DAT_OTL_M_FSPEED;
  self.m_sspeed = DAT_OTL_M_SSPEED;
  self.m_bspeed = DAT_OTL_M_BSPEED;
  self.m_maccel = DAT_OTL_M_ACCEL;
  self.m_pitch_max = DAT_OTL_M_PITCH_N;
  self.m_pitch_min = DAT_OTL_M_PITCH_X;
  self.c_bbx_x = DAT_OTL_CTOR_BBX_X;
  self.c_bbx_n = DAT_OTL_CTOR_BBX_N;
};