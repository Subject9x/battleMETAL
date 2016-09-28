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

//DO NOT TOUCH THESE
/*
*/
float P_OBS = 0;
float P_MECH = 1;
float P_VECH = 2;

float GAME_M = 2;

//data class constants
string DATA = "data";
string DATA_MECH = "data_mech";
string DATA_VEHC = "data_vehc";
string DATA_WEPN = "data_wepn";
string DATA_PROJ = "data_proj";

//mech piece classname constants
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

//weapon group contants
float W_GROUPA = 1;
float W_GROUPB = 2;
float W_GROUPC = 3;

//class vars
.string data_type;
.string vec_name;