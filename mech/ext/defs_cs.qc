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

float STAT_LEG_HP = 39;
float STAT_LEG_AM = 40;
float STAT_CTOR_HP = 41;
float STAT_CTOR_AM = 42;
float STAT_LTOR_HP = 43;
float STAT_LTOR_AM = 44;
float STAT_RTOR_HP = 45;
float STAT_RTOR_AM = 46;
float STAT_LARM_HP = 47;
float STAT_LARM_AM = 48;
float STAT_RARM_HP = 49;
float STAT_RARM_AM = 50;

float STAT_WEP1_HP = 51;
float STAT_WEP1_RL = 52;
float STAT_WEP2_HP = 53;
float STAT_WEP2_RL = 54;
float STAT_WEP3_HP = 55;
float STAT_WEP3_RL = 56;
float STAT_WEP4_HP = 57;
float STAT_WEP4_RL = 58;
float STAT_WEP5_HP = 59;
float STAT_WEP5_RL = 60;
float STAT_WEP6_HP = 61;
float STAT_WEP6_RL = 62;
float STAT_WEP7_HP = 63;
float STAT_WEP7_RL = 64;
float STAT_WEP8_HP = 65;
float STAT_WEP8_RL = 66;
float STAT_WEP9_HP = 67;
float STAT_WEP9_RL = 68;

float STAT_TARG_EID = 69;
