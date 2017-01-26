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
.float stat_w1_gr;
.float stat_w1_st;
.float stat_w2_id;
.float stat_w2_gr;
.float stat_w2_st;
.float stat_w3_id;
.float stat_w3_gr;
.float stat_w3_st;
.float stat_w4_id;
.float stat_w4_gr;
.float stat_w4_st;
.float stat_w5_id;
.float stat_w5_gr;
.float stat_w5_st;
.float stat_w6_id;
.float stat_w6_gr;
.float stat_w6_st;
.float stat_w7_id;
.float stat_w7_gr;
.float stat_w7_st;
.float stat_w8_id;
.float stat_w8_gr;
.float stat_w8_st;
.float stat_w9_id;
.float stat_w9_gr;
.float stat_w9_st;
.float stat_trg_vid;
.float stat_trg_sh;
.float stat_trg_am;

//ENT_TYPE
float ENT_PLR = 34; // scope of ent is the player
float ENT_TRG = 35; //scope is the player’s target
float ENT_WEP = 36; //scope is a player weapon sub-component
float ENT_CMP_LEG = 37; //scope is a player sub-component    
float ENT_CMP_CTOR = 38; //scope is a player sub-component    
float ENT_CMP_LTOR = 39; //scope is a player sub-component    
float ENT_CMP_RTOR = 40; //scope is a player sub-component    
float ENT_CMP_LARM = 41; //scope is a player sub-component    
float ENT_CMP_RARM = 42; //scope is a player sub-component    

//UPDATE FLAGS
float FLAG_INI_MCH = 1;
float FLAG_UPD_MCH = 2;

float FLAG_ORIGIN = 8;
float FLAG_ANGLE = 16;
float FLAG_ENTID = 32;

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

float STAT_WEP_GRP =83;

//Targeting stuff
float STAT_TRG_VID = 84;
float STAT_TRG_SH = 85;
float STAT_TRG_AM = 86;