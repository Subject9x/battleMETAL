/*
mech Mod
Author: Peter Roohr
Date: 9/1/2016
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think;
void(entity wep) ctrl_weapon_think_ai;
void(entity wep, float state) ctrl_weapon_addState;
void(entity wep, float state) ctrl_weapon_subState;
void(entity wep, float state1, float state2) ctrl_weapon_clearState;
void(entity wep, float state) ctrl_weapon_isReload;
void(entity wep, float state) ctrl_weapon_isReady;
void() ctrl_weapon_fireOffset;
void( float burstFire ) ctrl_weapon_updateAmmo;
void( float updateDelay ) ctrl_weapon_make_projectile;
float() ctrl_weapon_checkEnergy;