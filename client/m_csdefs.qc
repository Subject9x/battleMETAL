/*
mech Mod
Author: Subject9x
Date: 10/11/2016
Overview: csqc defs for the mod
*/
float CON_W;
float CON_H;
float CON_CW;
float CON_CH;

vector plr_orig;
vector plr_angles;
.entity cpit_mdl;
float plr_info_num;
.float() t_remove; // called by CSQC_Ent_Remove to clean up this entity, return TRUE if remove(self) should be performed afterward
// protocol bytes
float SVC_SETVIEWPORT = 5;
float SVC_SETANGLES = 10;
float	SVC_TEMPENTITY		= 23;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			= 31;
float	SVC_CDTRACK			= 32;
float	SVC_SELLSCREEN		= 33;

//UPDATE FLAGS
float FLAG_INI_MCH = 1;
float FLAG_UPD_MCH = 2;

float FLAG_ORIGIN = 8;
float FLAG_ANGLE = 16;
float FLAG_ENTID = 32;

//COMP_TYPE
float m_tor_c = 0;
float m_tor_l = 1;
float m_tor_r = 2;
float m_legs = 3;
float m_arm_r = 4;
float m_arm_l = 5;
float m_wep = 6;

.string c_model;
.string w_name;       //label for weapon, need to keep 'classname' reserved for actual class    
.float w_firerate;
.float w_firemod;     //used for modifying fire rate;
.float w_firemoddur;  //duration of effect;
.float w_reloadtime;
.float w_clipsize;
.float w_ammotype;
.float w_spread;
.float en_max;
.float i_techlvl;
.string data_type;

//player vars
.float LG_AM_MX;
.float LG_AM_CR;
.float LG_HP_MX;
.float LG_HP_CR;

.float LT_AM_MX;
.float LT_AM_CR;
.float LT_HP_MX;
.float LT_HP_CR;

.float RT_AM_MX;
.float RT_AM_CR;
.float RT_HP_MX;
.float RT_HP_CR;

.float LA_AM_MX;
.float LA_AM_CR;
.float LA_HP_MX;
.float LA_HP_CR;

.float RA_AM_MX;
.float RA_AM_CR;
.float RA_HP_MX;
.float RA_HP_CR;



//PLAYER CLASSES
float P_OBS = 0;
float P_MECH = 1;

//STAT CHANNEL
float STAT_ENTITY_ID = 33;
float STAT_PCLASS = 34;
float STAT_SPREADX = 35;
float STAT_SPREADY = 36;
float STAT_ENERGY = 37;
float STAT_SHIELD = 38;

float STAT_TARG_EID = 39;
float STAT_VID = 40;
//send ent is for the weak!
float STAT_CAM_ORG_X = 41;
float STAT_CAM_ORG_Y = 42;
float STAT_CAM_ORG_Z = 43;

float STAT_LEG_HP = 44;
float STAT_LEG_AM = 45;
float STAT_CTOR_HP = 46;
float STAT_CTOR_AM = 47;
float STAT_LTOR_HP = 48;
float STAT_LTOR_AM = 49;
float STAT_RTOR_HP = 50;
float STAT_RTOR_AM = 51;
float STAT_LARM_HP = 52;
float STAT_LARM_AM = 53;
float STAT_RARM_HP = 54;
float STAT_RARM_AM = 55;

float STAT_WEP1_ID = 56;
float STAT_WEP1_GR = 57;
float STAT_WEP1_ST = 58;
float STAT_WEP2_ID = 59;
float STAT_WEP2_GR = 60;
float STAT_WEP2_ST = 61;
float STAT_WEP3_ID = 62;
float STAT_WEP3_GR = 63;
float STAT_WEP3_ST = 64;
float STAT_WEP4_ID = 65;
float STAT_WEP4_GR = 66;
float STAT_WEP4_ST = 67;
float STAT_WEP5_ID = 68;
float STAT_WEP5_GR = 69;
float STAT_WEP5_ST = 70;
float STAT_WEP6_ID = 71;
float STAT_WEP6_GR = 72;
float STAT_WEP6_ST = 73;
float STAT_WEP7_ID = 74;
float STAT_WEP7_GR = 75;
float STAT_WEP7_ST = 76;
float STAT_WEP8_ID = 77;
float STAT_WEP8_GR = 78;
float STAT_WEP8_ST = 79;
float STAT_WEP9_ID = 80;
float STAT_WEP9_GR = 81;
float STAT_WEP9_ST = 82;

float STAT_WEP_GRP = 83;

//actual csqc constants
/*vector ENG_COLOR_CURRENT;
vector SHD_COLOR_CURRENT;
vector DMG_COLOR_CURRENT;
vector DMG_COLOR_GREEN = '0 1 0';
vector DMG_COLOR_YELLOW = '1 1 0';
vector DMG_COLOR_RED = '1 0 0';
vector DMG_COLOR_GRAY = '0.1 0.1 0.1';*/

//mech piece classname constants
string M_TOR_CENTER = "tor_center";
string M_TOR_RIGHT = "tor_right";
string M_TOR_LEFT = "tor_left";
string M_LEGS = "legs";
string M_LEG_L = "legs_l";
string M_LEG_R = "legs_r";
string M_ARM_LEFT = "arm_left";
string M_ARM_RIGHT = "arm_right";