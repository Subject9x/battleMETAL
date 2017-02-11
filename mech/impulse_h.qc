/*
mech Mod
Author: Subject9x
Date: 9/3/2016
Overview: I pulled the ImpulseCommands() function out to its own
file....
*/
//float() W_CheckNoAmmo;
//void() W_ChangeWeapon;
//float() W_BestWeapon;
//void() W_SetCurrentAmmo;
//void() CycleWeaponCommand;
//void() CycleWeaponReverseCommand;
//void() CheatCommand;
//void() QuadCheat;



void() cycleWeaponGroup;
void() cycleWeaponGroupReverse;
void() playerAttack;
void() ImpulseCommands;
void(float current, float toRemove) removeWeaponGroup;