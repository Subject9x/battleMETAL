/*
mech Mod
Author: Peter Roohr
Date: 10/12/2016
Overview: csqc defs for main game
*/

//STAT TYPES
float AS_STRING = 1;
float AS_INT = 2;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;

//STAT FIELD VARS
.float stat_plr_camx;
.float stat_plr_camy;
.float stat_plr_camz;

.float stat_legs_hp;
.float stat_ctor_hp;
.float stat_ltor_hp;
.float stat_rtor_hp;
.float stat_larm_hp;
.float stat_rarm_hp;
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
.float stat_trg_dataidx;
.float stat_trg_sh;
.float stat_trg_dat;
.float stat_hit_dirs;
.float stat_rdr_mode;
.float stat_rdr_rng;
.float stat_wep_state;
.float stat_trg_dist;
.float stat_trg_face;
.float stat_wep_rel;
.float stat_spr_x;
.float stat_spr_y;
.float stat_plr_stt;
.float stat_plr_fir;
.float stat_lck_stt;
.float stat_trg_ddflg;
.float stat_ret_dist;

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