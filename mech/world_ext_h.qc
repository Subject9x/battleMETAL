/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
mod: 11/16/2018
Overview: function extensions to world.qc
*/

//GLOBALS
float CLIENTS;
vector WINDDIR; //these get set by worldspawn but are here because 
float WINDSPEED;//  modifying world.value is not kosher

float TE_STOMP_TYPE;  //set by world type

//EXTENSIONS
.float client_num;

.string msn_file;
.string map_file;

void() mh_world_ini;

//functional-style data lookup
void(float wep_id) data_iniWep;
void(float mech_id) data_iniMech;
void(float vec_id) data_iniVehc;
void(float prj_id) data_iniProjectile;
void(float vec_id) data_iniTurret;

//the following should probably be spun out to client_utils - Roohr 3/24/2018