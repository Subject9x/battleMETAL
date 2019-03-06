/*
mech mod
Author: Peter Roohr
Date: 9/1/2016
mod - 1/15/2019 - a few refactors
Overview: header for all mech component controllers
*/

//mech controller functions
void() ctrl_updateCenterTorso;
void() ctrl_updateLegs;
void() ctrl_dieLegs;
void() ctrl_die_weapon;
void() ctrl_component_die;
void() ctrl_component_burn;
void() ctrl_component_drop;

void() touch_mech;
void() touch_mechPiece;

///building controllers
void() building_burn_th;
void() building_burn;
void() building_die_removeFire;
void() building_think;
void() building_die;

void() ctrl_updateTank;
