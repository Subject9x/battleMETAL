/*
mech Mod
Author: Peter Roohr
Date: 1/26/2018
Overview: all the miscellaneous shared values between client and server
*/

//============================
//   PLAYER STATE ID's           
//============================
float PLAYER_DEAD = -1;
float PLAYER_CONNECT = 0;
float PLAYER_SPAWN = 1;
float PLAYER_IN_MENU = 2;
float PLAYER_POWERUP_BEGIN = 3;
float PLAYER_POWERUP_END = 4;
float PLAYER_ACTIVE = 5;
//============================
//         DATA_TYPE           
//============================
string DATA = "data";
float DATA_MECH = 1;
float DATA_VEHC = 2;
float DATA_WEPN = 3;
float DATA_PROJ = 4;
float DATA_HUD = 5;
float DATA_BLD = 6;
float DATA_NAVP = 7;
float DATA_OBJT = 8;
float DATA_NODE = 9;
float DATA_DEPL = 10;
float DATA_POBS = 11;
float DATA_MECH_AI = 12;
float DATA_PLR = 13;
float DATA_WEAPON = 14;
float DATA_INFO_START = 15;
//============================
//     WEAPON SLOT BITS           
//============================
float WEAPON1 = 1;
float WEAPON2 = 2;
float WEAPON3 = 4;
float WEAPON4 = 8;
float WEAPON5 = 16;
float WEAPON6 = 32;
float WEAPON7 = 64;
float WEAPON8 = 128;
float WEAPON9 = 256;
//============================
//     RADAR DEFS          
//============================
vector  RADAR_PASSIVE_ARC_PLAYER = '0 96 0';
vector  RADAR_ACTIVE_ARC_PLAYER = '0 256 0';
//============================
//     SHARED STATS         
//============================
.float hardpoint_cnt;
.float currentWeaponGroup;
.float stat_plr_camx;
.float stat_plr_camy;
.float stat_plr_camz;
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
.float stat_rdr_rng;
.float stat_wep_state;
.float stat_trg_dist;
.float stat_trg_face;
.float stat_nav_dir;
.float stat_wep_rel;
.float stat_spr_x;
.float stat_spr_y;
.float stat_plr_fir;
.float stat_lck_stt;
.float stat_trg_ddflg;
.float stat_ret_dist;
//============================
//     STAT CHANNELS         
//============================
float STAT_PLAYER_STATE = 33;
float STAT_OBS_FACTION = 34;

float STAT_SPREADX = 35;
float STAT_SPREADY = 36;

float STAT_TARG_EID = 39;
float STAT_VID = 40;

float STAT_CAM_ORG_X = 41;
float STAT_CAM_ORG_Y = 42;
float STAT_CAM_ORG_Z = 43;

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

float STAT_TRG_VID = 84;
float STAT_TRG_SH = 85;
float STAT_TRG_DAT = 87;

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
float STAT_TRG_IFAC = 116;

float STAT_LVL_RES = 79;