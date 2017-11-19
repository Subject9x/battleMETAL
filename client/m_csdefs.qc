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

//client parms ported from server
.float parm1;
.float parm2;
.float parm3;
.float parm4;
.float parm5;
.float parm6;
.float parm7; // bitflags for light mechs
.float parm8; // bitflags for medium mechs
.float parm9; // bitflags for heavy mechs

//
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

//ported over from server
float	DEAD_NO					= 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				= 2;
float	DEAD_RESPAWNABLE		= 3;
float	DEAD_RESPAWNING			= 4; // dead, waiting for buttons to be released


//satus colors
vector STATUS_AOK = '0.13 0.6 0.329';
vector STATUS_DMG = '0.952 0.611 0.07';
vector STATUS_DED = '0.2 0.286 0.368'; //change to this soon 95, 106, 106
vector STATUS_REL = '0.18 0.525 0.756';
vector STATUS_RNG = '0.513 0.568 0.572';

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
.float data_type;
.float i_faction;   //which faction? consult table
.float i_techlvl; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?
.float en_max;   //max amount
.float en_cur;  //current amount
.float en_rate; //how much energy built per frame
.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.string m_maccel;
.string m_pitch_min;
.string m_pitch_max;
.vector c_bbx_x;
.vector c_bbx_n;
.string w_abbr;
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
float P_VEHC = 2;
float P_BULD = 3;

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
float STAT_WEP2_ID = 59;
float STAT_WEP3_ID = 62;
float STAT_WEP4_ID = 65;
float STAT_WEP5_ID = 68;
float STAT_WEP6_ID = 71;
float STAT_WEP7_ID = 74;
float STAT_WEP8_ID = 77;
float STAT_WEP9_ID = 80;

float STAT_WEP1_REL = 81;
float STAT_WEP2_REL = 82;
float STAT_WEP3_REL = 86;
float STAT_WEP4_REL = 99;
float STAT_WEP5_REL = 100;
float STAT_WEP6_REL = 101;
float STAT_WEP7_REL = 102;
float STAT_WEP8_REL = 103;
float STAT_WEP9_REL = 104;

float STAT_WEP_STT = 57;
float STAT_WEP_GRP = 83;
float STAT_WEP_REL = 61;

float STAT_PLR_IFAC = 105;

float STAT_TRG_VID = 84;
float STAT_TRG_SH = 85;
float STAT_TRG_DAT = 87;

float STAT_RET_DIST = 88;
float STAT_RDR_RNG = 89;
float STAT_HIT_DIR = 90;
float STAT_RDR_MODE = 91;
float STAT_TRG_DIST = 92;
float STAT_TRG_FACE = 58;
float STAT_NAV_DIR = 60;
float STAT_SPR_X = 63;
float STAT_SPR_Y = 64;
float STAT_PLR_STT = 66;
float STAT_PLR_FIR = 67;
float STAT_LCK_STT = 69;
float STAT_PLR_PTC = 72;
float STAT_PLR_ANG = 73;

float STAT_TRG_DDFLG = 81;
float STAT_TRG_ORGX = 75;
float STAT_TRG_ORGY = 76;
float STAT_TRG_ORGZ = 78;

float STAT_TRG_LEG_HP = 93;
float STAT_TRG_CTOR_HP = 94;
float STAT_TRG_LTOR_HP = 95;
float STAT_TRG_RTOR_HP = 96;
float STAT_TRG_LARM_HP = 97;
float STAT_TRG_RARM_HP = 98;

float UI_BOX_POSX = 106;
float UI_BOX_POSY = 107;
float UI_BOX_SZEX = 108;
float UI_BOX_SZEY = 109;
float UI_BOX_CLRX = 110;
float UI_BOX_CLRY = 111;
float UI_BOX_CLRZ = 112;
float UI_BOX_TIME = 113;

float TRG_VEC_SIZ = 114;
float TRG_P_CLASS = 115;

//mech piece classname constants
string M_TOR_CENTER = "tor_center";
string M_TOR_RIGHT = "tor_right";
string M_TOR_LEFT = "tor_left";
string M_LEGS = "legs";
string M_LEG_L = "legs_l";
string M_LEG_R = "legs_r";
string M_ARM_LEFT = "arm_left";
string M_ARM_RIGHT = "arm_right";

//hit direction bit flags
float STAT_HIT_CL = 1;
float STAT_HIT_LF = 2;
float STAT_HIT_RT = 4;
float STAT_HIT_BK = 8;
float STAT_HIT_TRG = 16;

//status floats specific components
float COMP_OK = 5;
float COMP_DMG = 6;
float COMP_DYN = 7;
float COMP_REL = 8;
float COMP_RDY = 9;

//allows us to track all of a targets health states over a single float channel
float TARG_CT_OK = 1;
float TARG_CT_DM = 2;
float TARG_CT_DD = 4;
float TARG_RT_OK = 8;
float TARG_RT_DM = 16;
float TARG_RT_DD = 32;
float TARG_LT_OK = 64;
float TARG_LT_DM = 128;
float TARG_LT_DD = 256;
float TARG_RA_OK = 512;
float TARG_RA_DM = 1024;
float TARG_RA_DD = 2048;
float TARG_LA_OK = 4096;
float TARG_LA_DM = 8192;
float TARG_LA_DD = 16384;
float TARG_LG_OK = 32768;
float TARG_LG_DM = 65536;
float TARG_LG_DD = 131072;

//weapon status all-in-one for bitflags
float WEAPON1_OK = 1;
float WEAPON1_DD = 2;
float WEAPON2_OK = 4;
float WEAPON2_DD = 8;
float WEAPON3_OK = 16;
float WEAPON3_DD = 32;
float WEAPON4_OK = 64;
float WEAPON4_DD = 128;
float WEAPON5_OK = 256;
float WEAPON5_DD = 512;
float WEAPON6_OK = 1024;
float WEAPON6_DD = 2048;
float WEAPON7_OK = 4096;
float WEAPON7_DD = 8192;
float WEAPON8_OK = 16384;
float WEAPON8_DD = 32768;
float WEAPON9_OK = 65536;
float WEAPON9_DD = 131072;

//weapon reload states
float WEAPON1_REL = 1;
float WEAPON2_REL = 2;
float WEAPON3_REL = 4;
float WEAPON4_REL = 8;
float WEAPON5_REL = 16;
float WEAPON6_REL = 32;
float WEAPON7_REL = 64;
float WEAPON8_REL = 128;
float WEAPON9_REL = 256;

//weapon slot bits
float WEAPON1 = 1;
float WEAPON2 = 2;
float WEAPON3 = 4;
float WEAPON4 = 8;
float WEAPON5 = 16;
float WEAPON6 = 32;
float WEAPON7 = 64;
float WEAPON8 = 128;
float WEAPON9 = 256;

//PLAYER STATE BITS
float PLAYER_IDLE = 0;
float PLAYER_SPAWN = 1;
float PLAYER_CRITDAM = 2;
float PLAYER_GETNAV = 3;

//target lock states
float LOCK_NONE = 1;
float LOCK_TARG = 2;
float LOCK_PLYR = 4;

//level
float STAT_LVL_RES = 79;