/*
mech Mod
Author: Subject9x
Date: 10/12/2016
Overview: csqc defs for main game
*/

//STAT TYPES
float AS_STRING = 1;
float AS_INT = 2;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;

//STAT FIELD VARS
.float stat_eid;
.float stat_en;
.float stat_sh;

.float stat_legs_hp;
.float stat_legs_am;
.float stat_ctor_hp;
.float stat_ctor_am;
.float stat_ltor_hp;
.float stat_ltor_am;
.float stat_rtor_hp;
.float stat_rtor_am;
.float stat_larm_hp;
.float stat_larm_am;
.float stat_rarm_hp;
.float stat_rarm_am;
.float stat_cofs_x;
.float stat_cofs_y;
.float stat_cofs_z;
.float stat_w1_id;
.float stat_w2_id;
.float stat_w3_id;
.float stat_w4_id;
.float stat_w5_id;
.float stat_w6_id;
.float stat_w7_id;
.float stat_w8_id;
.float stat_w9_id;
.float stat_trg_vid;
.float stat_trg_sh;
.float stat_trg_am;
.float stat_trg_dat;
.float stat_hit_dirs;
.float stat_rdr_mode;
.float stat_wep_state;
.float stat_trg_dist;
.float stat_trg_face;
.float stat_nav_dir;

//hit direction bit flags
float STAT_HIT_CL = 1;
float STAT_HIT_LF = 2;
float STAT_HIT_RT = 4;
float STAT_HIT_BK = 8;

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

//stat channels
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
//float STAT_WEP2_ST = 61;
float STAT_WEP3_ID = 62;
//float STAT_WEP3_GR = 63;
//float STAT_WEP3_ST = 64;
float STAT_WEP4_ID = 65;
//float STAT_WEP4_GR = 66;
//float STAT_WEP4_ST = 67;
float STAT_WEP5_ID = 68;
//float STAT_WEP5_GR = 69;
//float STAT_WEP5_ST = 70;
float STAT_WEP6_ID = 71;
//float STAT_WEP6_GR = 72;
//float STAT_WEP6_ST = 73;
float STAT_WEP7_ID = 74;
//float STAT_WEP7_GR = 75;
//float STAT_WEP7_ST = 76;
float STAT_WEP8_ID = 77;
//float STAT_WEP8_GR = 78;
//float STAT_WEP8_ST = 79;
float STAT_WEP9_ID = 80;
//float STAT_WEP9_GR = 81;
//float STAT_WEP9_ST = 82;
float STAT_WEP_STT = 57;
float STAT_WEP_GRP =83;

//Targeting stuff
float STAT_TRG_VID = 84;
float STAT_TRG_SH = 85;
float STAT_TRG_AM = 86;
float STAT_TRG_DAT = 87;

float STAT_RDR_FRNT = 88;
float STAT_RDR_BACK = 89;
float STAT_NAV_DIR = 60;

float STAT_HIT_DIR = 90;
float STAT_RDR_MODE = 91;

float STAT_TRG_DIST = 92;
float STAT_TRG_FACE = 58;