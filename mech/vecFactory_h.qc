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