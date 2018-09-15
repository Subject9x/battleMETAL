/*
mech Mod
Author: Peter Roohr
Date: 01/28/2018
Overview: quick and dirty data retrieval
trying to not use entities as data collections cause its playing havoc with other functionality
*/

string data_WeaponNames[32];
string data_WeaponIcons[32];
float data_WeaponSize[32];
float data_WeaponType[32];

//API functions
void() data_ini_arrays;
void(float data_idx) data_get_weapon;
string(float data_idx) data_get_weapon_name;
string(float data_idx) data_get_weapon_icon;