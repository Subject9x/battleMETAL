/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
mod: 11/16/2018
Overview: function extensions to world.qc
*/

//GLOBALS
float CLIENTS;

entity WeatherDominator;  //global weather controlling entity.
vector WINDDIR; //these get set by worldspawn but are here because 
void() WeatherDominator_think;

float TE_STOMP_TYPE;  //set by world type

//EXTENSIONS
.float client_num;

.string missionFile;
.string mapFile;
.entity particleCube; //used by mech/map/map_particlecube_effect.qc
.vector wind;

void() mh_world_ini;

void() world_get_fog;
float( entity t ) world_calc_fog;

//RTLight converter system---------------------------------------------
.float rtlShadows; //FALSE = write nothin | TRUE = write '!'
//.vector rtlOrigin; -> light ent's .origin
.float rtlLight;  //functionally equivalent to .light but doesn't trigger bsp light calc
//.vector color; -> already covered
.float rtlStyle;
//.string vec_name; -> write out as 'cubemap'
.float rtlCorona;
//.vector angles; -> light ent's .angles
.float rtlCoronaSize;
.float rtlAmbient;
.float rtlDiffuse;
.float rtlSpecular;
.float rtlMode;
/*
  0 = normalmode NO && realtimemode NO
  1 = normalmode YES && realtimemode NO
  2 = normalmode NO && realtimemode YES
  3 = normalmode YES && realtimemode YES
*/

void( float overrideFlag ) world_export_realtimelights;
void( entity light, float fileData ) world_export_realtimelights_write;
