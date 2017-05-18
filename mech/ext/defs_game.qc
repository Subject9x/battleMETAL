/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: extends the global defs
*/

.entity lst_p; //linked list parent
.entity lst_c; //linked list child

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

//DO NOT TOUCH THESE - bad things will happen if you mod these
float P_OBS = 0;
float P_MECH = 1;
float P_VECH = 2;
float P_BULD = 3;

float GAME_M = 2;

float SHIELD_DELAY = 5;
float SHIELD_SOAK = 4;

//data class constants
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

//weapon slot bits
float WEAPON1 = 1;
float WEAPON2 = 2;
float WEAPON3 = 4;
float WEAPON4 = 8;
float WEAPON5 = 16;
float WEAPON6 = 32;
float WEAPON7 = 64;
float WEAPON8 = 128;
float WEAPON9 = 256;

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