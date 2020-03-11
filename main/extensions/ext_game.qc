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

//WEAPON FIRE STATUS
float READY = 0;
float RELOADING = 1;
float WAITING = 2;
float RECOIL = 4;

.entity lst_p; //linked list parent

//from world.qc
entity lastspawn;
//void() InitBodyQue;
//void(entity ent) CopyToBodyQue;
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
float M_UNIT        = 0;
float M_CAMERA      = 1;
float M_TOR_CENTER  = 2;
float M_TOR_RIGHT   = 3;
float M_TOR_LEFT    = 4;
float M_LEGS        = 5;
float M_LEG_L       = 6;
float M_LEG_R       = 7;
float M_ARM_LEFT    = 8;
float M_ARM_RIGHT   = 9;
float M_ITEM        = 10;

//direction values
float DIR_N   = 0;
float DIR_NE  = 1;
float DIR_E   = 2;
float DIR_SE  = 3;
float DIR_S   = 4;
float DIR_SW  = 5;
float DIR_W   = 6;
float DIR_NW  = 7;

//fire modes
float FIRE_SINGLE = 1;
float FIRE_GROUP = 2;
float FIRE_CHAIN = 3;

//MISSION STATS
float MISSION_TOTAL_PSC;
float MISSION_TOTAL_SURVEST;
float MISSION_TOTAL_MILITAR;

float MISSION_LOSSES_PSC;
float MISSION_LOSSES_SURVEST;
float MISSION_LOSSES_MILITAR;

float GAME_TIME_TO_DEBRIEF = 3.33;

string MAP_UNLOCK_MECHS;  //quakeC abhors modifying world
string MAP_UNLOCK_EQUIP;