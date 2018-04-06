/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: extends the global defs
*/


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

float GAME_M = 2;

//mech piece classname constants
string MECH_PIECE = "mech_piece";
string M_TOR_CENTER = "tor_center";
string M_TOR_RIGHT = "tor_right";
string M_TOR_LEFT = "tor_left";
string M_LEGS = "legs";
string M_LEG_L = "legs_l";
string M_LEG_R = "legs_r";
string M_ARM_LEFT = "arm_left";
string M_ARM_RIGHT = "arm_right";

//vehicle piece classname constants
string V_CHASSIS = "v_chas";
string V_TUR_MAIN = "v_tur_main";
string V_TUR_AUX = "v_tur_aux";

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
.string vec_name;
.float max_armor; //why wasn't this ever included!?

//Damage types
float DMG_BAL = 1;  //ballstic damage
float DMG_ENE = 2;  //energy damage
float DMG_EXP = 4;  //explosive damage
float EFF_PRC = 8;  //piercing damage
float EFF_RAM = 16; //dmg is doubled
float EFF_STX = 32; //dmg only affects shields
float EFF_ENG = 64; //dmg only affects energy

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

//target lock states
float LOCK_NONE = 1;
float LOCK_TARG = 2;
float LOCK_PLYR = 4;