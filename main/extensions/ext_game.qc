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

float HIT_LOCATION;

//WEAPON FIRE STATUS
#define READY 0
#define RELOADING 1
#define WAITING 2
#define RECOIL 4

//from world.qc
entity lastspawn;
//void() InitBodyQue;
//void(entity ent) CopyToBodyQue;
//======================

//from client.qc
string sv_nextmap;
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

//direction values
#define DIR_N  0
#define DIR_NE 1
#define DIR_E  2
#define DIR_SE 3
#define DIR_S  4
#define DIR_SW 5
#define DIR_W  6
#define DIR_NW 7

//fire modes
#define FIRE_SINGLE 1
#define FIRE_GROUP 2
#define FIRE_CHAIN 3

//MISSION STATS
float MISSION_TOTAL_PSC;
float MISSION_TOTAL_SURVEST;
float MISSION_TOTAL_MILITAR;

float MISSION_LOSSES_PSC;
float MISSION_LOSSES_SURVEST;
float MISSION_LOSSES_MILITAR;

//#define GAME_TIME_TO_DEBRIEF 3.33
#define GAME_TIME_TO_DEBRIEF 10
//debug high value

string MAP_UNLOCK_MECHS;  //quakeC abhors modifying world
string MAP_UNLOCK_EQUIP;