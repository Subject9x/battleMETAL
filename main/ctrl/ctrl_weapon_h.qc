/*
battleMETAL
Author: Peter Roohr
Date: 9/1/2016
mod: 07/31/2019 - removed weapon state functions, deprecated
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think;
void(entity wep) ctrl_weapon_think_ai;
void() ctrl_weapon_fireOffset;
void( float burstFire ) ctrl_weapon_updateAmmo;
void( float updateDelay ) ctrl_weapon_make_projectile;
float() ctrl_weapon_checkEnergy;