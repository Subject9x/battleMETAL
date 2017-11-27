/*
mech mod
Author: Peter Roohr
Date: 9/1/2016
Overview: header for all mech component controllers
*/

//mech controller functions
void() ctrl_updateCenterTorso;
void() ctrl_updateLegs;
void() ctrl_dieLegs;
void() ctrl_die_weapon;
void() ctrl_die_comp;

void() touch_mechPiece;

void() ctrl_updateTurret;

///building controllers
void() building_think;
void() building_die;