/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod:  05/30/2019
Overview: extends the global defs
*/

//used by ctrl_weapon_fireOffset
vector FIRE_OFFSET;
entity WEAPON_PARENT;
entity FIRE_ENT;
entity NEWSHOT;
vector FIRE_ORIGIN;
vector FIRE_ENDPOINT;

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
.string inv_m_light;
.string inv_m_medim;
.string inv_m_heavy;

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

//from playermovement.qc in Darkplaces Mod
float lastclientthink;
float sv_accelerate;
float sv_maxairspeed;
float sv_friction;
float sv_maxspeed;
float sv_stopspeed;
float sv_gravity;
.float ladder_time;
.entity ladder_entity;
.float gravity;
//======================

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

//direction values
float DIR_N   = 0;
float DIR_NE  = 1;
float DIR_E   = 2;
float DIR_SE  = 3;
float DIR_S   = 4;
float DIR_SW  = 5;
float DIR_W   = 6;
float DIR_NW  = 7;

//class vars
.float data_type;
.float max_armor; //why wasn't this ever included!?

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