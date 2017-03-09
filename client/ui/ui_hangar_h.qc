/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: ui header file the hangar menu
*/

//main hook for menu system
void() menu_hangarDrawFrame;

//hook for input system
void() menu_hangarListener;

//Listener Hooks called by menu_hangarListener
void() mechSelectListener;
void() mechAcceptButtonListener;
void() weaponSelectListener;
void() hardpointListener;

void(vector offset) menu_hangar_DrawNavBar;
void(vector offset) menu_hangar_MechDisplay;
void(vector offset) menu_hangar_MechList;
void(vector offset) menu_hangar_MechInfo;
void(vector offset) menu_hangar_WeaponList;
float(float slotid) getWeaponInHardpoint;