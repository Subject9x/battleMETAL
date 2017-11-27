/*
mech Mod
Author: Peter Roohr
Date: 8/31/2016
mod:  1/21/2017 - refactored due to new data value storage methods
Overview: used to build vehicles for players, this is the header
*/

void(entity data) buildVehicle;
entity(entity leg_data) buildLegs;
void(entity own) buildUnitPiece;
void(entity data) buildCenterTorso;
entity(entity data, entity own) buildLeftTorso;
entity(entity data, entity own) buildRightTorso;
entity(entity data, entity own) buildLeftArm;
entity(entity data, entity own) buildRightArm;
entity(entity data, entity own) buildCameraEnt;
void(entity data, entity own) buildWeaponList;
void(entity data, entity own, float state1, float state2, float state3) buildVehicleWeapon;





//Basic unit assembly functions
entity(void() func) build_unit_camera;
void(void() func, entity own) build_unit_component;
entity(void() func, float nex_wep, entity own, float state1, float state2, float state3, .float stat) build_unit_weapon;
void() build_unit_weapon_list;

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