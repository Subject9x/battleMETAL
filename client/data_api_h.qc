/*
mech Mod
Author: Peter Roohr
Date: 01/28/2018
Overview: quick and dirty data retrieval
trying to not use entities as data collections cause its playing havoc with other functionality
*/

string data_WeaponNames[32];
string data_WeaponIcons[32];
//Store per-frame unit data in a buffer array, use the retrieval api to load the buffers
//yes I know, these are terrible data structs to mimic classes
/*
  name
  size
  speed forward
  speed strafe
  speed back
  energy max
  energy rate
  shield max
  shield rate
  armor ct
  armor torso
  armor arm
  armor leg
  radar range
*/
string buffer_MechInfo[13];

/*
  data id
  data type
  vec size
*/
string buffer_TargetInfo[8];

/*
  weapon name
  weapon icon
  damage/shot
  type
  energy/sec
  range
  clipsize
  size
  tech level
  notes-1
  notes-2
  notes-3
  notes-4
*/
string buffer_WeaponInfoA[12];
string buffer_WeaponInfoB[12];

//API functions
void() data_ini_arrays;
void(float data_idx, float vsize) data_get_mech;
void(float data_idx) data_get_weapon;
void(float dtype, float data_idx, float vsize) data_get_target;
void(float data_idx, float vsize) data_get_target_mech;
void(float data_idx, float vsize) data_get_target_vec;
void(float data_idx) data_get_target_bld;
string(float data_idx) data_get_weapon_name;
string(float data_idx) data_get_weapon_icon;