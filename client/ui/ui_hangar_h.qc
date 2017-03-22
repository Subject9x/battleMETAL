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
void() hardpointInfoListener;

void(vector offset) menu_hangar_DrawNavBar;
void(vector offset) menu_hangar_MechDisplay;
void(vector offset) menu_hangar_MechList;
void(vector offset) menu_hangar_MechInfo;
void(vector offset) menu_hangar_WeaponList;
void(vector offset) menu_hangar_HardPointInfo;

//utility
float(float slotid) getWeaponInHardpoint;
float(float comp) checkIfWeaponInGroup;
void(float wep_id, float grp_id) assignWeaponToGroup;
void() getNextWeaponGroup;
void() getPrevWeaponGroup;