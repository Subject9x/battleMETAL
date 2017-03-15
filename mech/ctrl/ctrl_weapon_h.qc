/*
mech Mod
Author: Subject9x
Date: 9/1/2016
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think;
void(entity wep) ctrl_weapon_tryFire;
void(entity wep, float state) ctrl_weapon_addState;
void(entity wep, float state) ctrl_weapon_subState;
void(entity wep, float state1, float state2) ctrl_weapon_clearState;
void(entity wep, float state) ctrl_weapon_isReload;
void(entity wep, float state) ctrl_weapon_isReady;