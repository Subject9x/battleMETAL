/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: defines all impulse numbers, prevents magic numbers for key definitions
*/


float IMP_WGROUP1 = 1;  //weapon group change impulses
float IMP_WGROUP2 = 2;
float IMP_WGROUP3 = 3;
float IMP_NEXWGRP = 4;  //next weapon group
float IMP_PRVWGRP = 5;  //previous weapon group
float IMP_SUICIDE = 6;  //debug suicide - DEPRECATE
float IMP_TARGET = 7; //target under reticule
float IMP_RADAR = 8;  //toggle radar
float IMP_GETNAV = 9;
float IMP_FGROUP = 10; //toggle group fire
float IMP_FCHAIN = 11; //toggle chain fire
float IMP_SHIELD = 12; //toggle shield autocharge
float IMP_SWEAPON1 = 13;
float IMP_SWEAPON2 = 14;
float IMP_SWEAPON3 = 15;
float IMP_SWEAPON4 = 16;
float IMP_SWEAPON5 = 17;
float IMP_SWEAPON6 = 18;
float IMP_SWEAPON7 = 19;
float IMP_SWEAPON8 = 20;
float IMP_SWEAPON9 = 21;
float IMP_FSINGLE = 22;
float IMP_WGROUP4 = 23;
float IMP_WGROUP5 = 24;
float IMP_SHOWOBJ = 25;
float IMP_REPAIR = 26;

void() mpls_singleFire;
void(float selector) mpls_groupFire;