/*
mech Mod
Author: Subject9x
Date: 10/12/2016
Overview: csqc defs for main game
*/

//SendEnt constants
float E_NAV = 1;
float E_OBJ = 2;
float E_AIU = 3;
float E_BLD = 4;

//STAT TYPES
float AS_STRING = 1;
float AS_INT = 2;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;

//STAT FIELD VARS
.float stat_eid;
.float stat_en;
.float stat_sh;

.float stat_plr_camx;
.float stat_plr_camy;
.float stat_plr_camz;

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
.float stat_w1_rel;
.float stat_w2_rel;
.float stat_w3_rel;
.float stat_w4_rel;
.float stat_w5_rel;
.float stat_w6_rel;
.float stat_w7_rel;
.float stat_w8_rel;
.float stat_w9_rel;
.float stat_trg_vid;
.float stat_trg_sh;
.float stat_trg_dat;
.float stat_hit_dirs;
.float stat_rdr_mode;
.float stat_wep_state;
.float stat_trg_dist;
.float stat_trg_face;
.float stat_nav_dir;
.float stat_wep_rel;
.float stat_spr_x;
.float stat_spr_y;
.float stat_plr_stt;
.float stat_plr_fir;
.float stat_lck_stt;
.float stat_plr_ptc;
.float stat_plr_ang;
.float stat_trg_ddflg;
.float stat_trg_orgx;
.float stat_trg_orgy;
.float stat_trg_orgz;
.float stat_trg_lg_hp;
.float stat_trg_ct_hp;
.float stat_trg_lt_hp;
.float stat_trg_rt_hp;
.float stat_trg_la_hp;
.float stat_trg_ra_hp;
.float stat_ret_dist;

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

//PLAYER STATE BITS
float PLAYER_IDLE = 0;
float PLAYER_SPAWN = 1;
float PLAYER_CRITDAM = 2;

//stat channels
float STAT_PLR_ANG = 73;
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
float STAT_CTOR_HP = 46;
float STAT_LTOR_HP = 48;
float STAT_RTOR_HP = 50;
float STAT_LARM_HP = 52;
float STAT_RARM_HP = 54;

//these are on notice, might be removed
float STAT_LEG_AM = 45;
float STAT_CTOR_AM = 47;
float STAT_LTOR_AM = 49;
float STAT_RTOR_AM = 51;
float STAT_LARM_AM = 53;
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
float STAT_PLR_IFAC = 105;

float STAT_WEP_STT = 57;
float STAT_WEP_GRP = 83;
float STAT_WEP_REL = 61;

float STAT_SPR_X = 63;
float STAT_SPR_Y = 64;
float STAT_PLR_STT = 66;
float STAT_PLR_FIR = 67;
float STAT_LCK_STT = 69;
float STAT_PLR_PTC = 72;

float UI_BOX_POSX = 106;
float UI_BOX_POSY = 107;
float UI_BOX_SZEX = 108;
float UI_BOX_SZEY = 109;
float UI_BOX_CLRX = 110;
float UI_BOX_CLRY = 111;
float UI_BOX_CLRZ = 112;
float UI_BOX_TIME = 113;

//Targeting stuff
float STAT_TRG_VID = 84;
float STAT_TRG_SH = 85;
float STAT_TRG_DAT = 87;

float STAT_RET_DIST = 88;
float STAT_RDR_BACK = 89;
float STAT_NAV_DIR = 60;

float STAT_HIT_DIR = 90;
float STAT_RDR_MODE = 91;

float STAT_TRG_DDFLG = 81;
float STAT_TRG_DIST = 92;
float STAT_TRG_FACE = 58;

float STAT_TRG_ORGX = 75;
float STAT_TRG_ORGY = 76;
float STAT_TRG_ORGZ = 78;

float STAT_TRG_LEG_HP = 93;
float STAT_TRG_CTOR_HP = 94;
float STAT_TRG_LTOR_HP = 95;
float STAT_TRG_RTOR_HP = 96;
float STAT_TRG_LARM_HP = 97;
float STAT_TRG_RARM_HP = 98;

//level
float STAT_LVL_RES = 79;