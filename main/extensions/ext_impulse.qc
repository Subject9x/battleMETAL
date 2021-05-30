/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 09/05/2019
Overview: 
defines all impulse numbers, prevents magic numbers for key definitions
*/

float IMP_WGROUP1 = 1;  //weapon group change impulses
float IMP_WGROUP2 = 2;
float IMP_WGROUP3 = 3;
float IMP_NEXWGRP = 4;  //next weapon group
float IMP_PRVWGRP = 5;  //previous weapon group
float IMP_SUICIDE = 6;  //debug suicide - DEPRECATE
float IMP_TARGET = 7; //target under reticule
float IMP_RADAR = 8;  //toggle radar
//float 9;
float IMP_FGROUP = 10; //toggle group fire
float IMP_FCHAIN = 11; //toggle chain fire
float IMP_TACMAP = 12;
float IMP_SELECT_WEAPON1 = 13;
float IMP_SELECT_WEAPON2 = 14;
float IMP_SELECT_WEAPON3 = 15;
float IMP_SELECT_WEAPON4 = 16;
float IMP_SELECT_WEAPON5 = 17;
float IMP_SELECT_WEAPON6 = 18;
float IMP_SELECT_WEAPON7 = 19;
float IMP_SELECT_WEAPON8 = 20;
float IMP_SELECT_WEAPON9 = 21;
float IMP_FSINGLE = 22;
float IMP_WGROUP4 = 23;
//-----------------24
float IMP_SHOWOBJ = 25;
float IMP_ZOOM = 26;
float IMP_SLIDE = 27;
float IMP_FAC_NEXT = 28;
float IMP_FAC_PREV = 29;
float IMP_EXTERNAL_CAMERA = 30;
float IMP_MENU_GROUP = 31;  //mostly clientside only for opening weapon rebind menu

void(float selector) mpls_groupFire;