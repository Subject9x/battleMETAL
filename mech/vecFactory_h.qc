/*
mech Mod
Author: Peter Roohr
Date: 8/31/2016
mod:  1/21/2017 - refactored due to new data value storage methods
Overview: used to build vehicles for players, this is the header
*/
//Basic unit assembly functions
entity(void() func) build_unit_camera;
void(void() func, entity own) build_unit_component;
entity(void() func, float nex_wep, entity own, float state1, float state2, float state3, .float stat) build_unit_weapon;
void() build_unit_weapon_list;

entity(void() func) build_building_base;

//mech-specific assembly functions
void(void() data_ini) build_mech_unit;
entity(void() func) build_mech_legs;
void(void() func) build_mech_torsoCenter;
entity(void() func) build_mech_torsoRight;
entity(void() func) build_mech_torsoLeft;
entity(void() func) build_mech_armRight;
entity(void() func) build_mech_armLeft;

//vehicle-specific assembly functions
void(void() data_ini) build_vehicle_unit;
entity(void() func) build_vehc_base;

//turret assembly
void(void() data_ini) build_turret_unit;
void(void() func) build_turret_top;
entity(void() func) build_turret_base;