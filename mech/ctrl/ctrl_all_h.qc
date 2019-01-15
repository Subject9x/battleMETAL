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
void() ctrl_die_comp;

void() touch_mech;
void() touch_mechPiece;

///building controllers
void() building_think;
void() building_die;

void() ctrl_updateTank;
