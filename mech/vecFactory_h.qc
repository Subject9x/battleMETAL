/*
mech Mod
Author: Peter Roohr
Date: 8/31/2016
mod:  1/21/2017 - refactored due to new data value storage methods
Overview: used to build vehicles for players, this is the header
*/
//Basic unit assembly functions
void() build_unit_camera;
void(entity own) build_unit_component;
void(float nex_wep, entity own, float state1, float state2, float state3, .float stat) build_unit_weapon;
void() build_unit_weapon_list;

//mech-specific assembly functions
void(void() data_ini) build_mech_unit;
void(void() data_ini) build_mech_bot;
void() build_mech_legs;
void() build_mech_torsoCenter;
void() build_mech_torsoRight;
void() build_mech_torsoLeft;
void() build_mech_armRight;
void() build_mech_armLeft;

//vehicle-specific assembly functions
void() build_unit_turret;
void( void() data_ini ) build_vehicle_unit;
void( void() data_ini ) build_vtol_unit;

//turret assembly
void(void() data_ini) build_turret_unit;