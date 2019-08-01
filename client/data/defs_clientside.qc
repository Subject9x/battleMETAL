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

// protocol bytes
float SVC_SETVIEWPORT   = 5;
float SVC_SETANGLES     = 10;
float	SVC_TEMPENTITY		= 23;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			  = 31;
float	SVC_CDTRACK			  = 32;
float	SVC_SELLSCREEN		= 33;

//ported over from server
float	DEAD_NO				    = 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				  = 2;
float	DEAD_RESPAWNABLE	= 3;
float	DEAD_RESPAWNING		= 4; // dead, waiting for buttons to be released

.float player_state;
.float stat_hit_dirs;
.float target_entid;
.vector target_origin;

//input globals and constants
float INPUT_EVENT_KEYDOWN = 0;
float INPUT_EVENT_KEYUP = 1;
float INPUT_EVENT_MOUSE_MOVE = 2;
float INPUT_EVENT_MOUSE_POS = 3;

float INPUT_mouse_state;  //set by handle_input();
float INPUT_mouse_state_prev;
float MOUSE_DOWN = TRUE; 
float MOUSE_UP = FALSE;
float MOUSE_DRAG = 2;

float MOUSE_drag_timer;
float MOUSE_drag_rate = 0.005;
float MOUSE_drag_max = 1;

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