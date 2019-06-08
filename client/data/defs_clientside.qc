/*
battleMETAL
Author: Peter Roohr
Date: 10/11/2016
mod:  05/16/2019
Overview:
  CSQC definition extensions for battleMETAL.
  Extensions are for the CS part of CSQC, and less about
  {entity} stuff vs defs_entity.qc
*/

float PLAYER_ENTITYNUM;

float CON_W;
float CON_H;
float CON_CW;
float CON_CH;

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


.float player_state;

.float stat_hit_dirs;
.float target_entid;
.vector target_origin;

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


//Difficulty
float SKILL_NOV = 0;
float SKILL_REG = 1;
float SKILL_VET = 2;
float SKILL_ELT = 3;

//WEAPON FIRE STATUS
float READY = 0;
float RELOADING = 1;
float WAITING = 2;
float RECOIL = 4;

//used for worldspaw, dictates unlocks to save file post-mission
.string inv_items;
.string inv_mechs;

.entity lst_p; //linked list parent

//from world.qc
entity lastspawn;
void() InitBodyQue;
void(entity ent) CopyToBodyQue;
//======================

//from client.qc
string nextmap;
float	intermission_running;
float	intermission_exittime;
//======================

//direction values
float DIR_N   = 0;
float DIR_NE  = 1;
float DIR_E   = 2;
float DIR_SE  = 3;
float DIR_S   = 4;
float DIR_SW  = 5;
float DIR_W   = 6;
float DIR_NW  = 7;

//used by ctrl_weapon_fireOffset
vector FIRE_OFFSET;
entity WEAPON_PARENT;
entity FIRE_ENT;
entity NEWSHOT;
vector FIRE_ORIGIN;
vector FIRE_ENDPOINT;

//These should have been floats from the start
//these are component id's (compid) for model pieces
string MECH_PIECE    = "mech_piece";
float M_TOR_CENTER  = 2;
float M_TOR_RIGHT   = 3;
float M_TOR_LEFT    = 4;
float M_LEGS        = 5;
float M_LEG_L       = 6;
float M_LEG_R       = 7;
float M_ARM_LEFT    = 8;
float M_ARM_RIGHT   = 9;

//Armor Types
float ARM_LIT = 2;  //light armor
float ARM_MED = 4;  //heavy armor;
float ARM_HVY = 8;  //radiation armor
float ARM_CER = 16; 
float ARM_RAD = 24;

//fire modes
float FIRE_SINGLE = 1;
float FIRE_GROUP = 2;
float FIRE_CHAIN = 3;