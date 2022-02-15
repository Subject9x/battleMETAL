/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 09/05/2019
Overview: 
defines all impulse numbers, prevents magic numbers for key definitions
*/

#define IMP_WGROUP1 1  //weapon group change impulses
#define IMP_WGROUP2 2
#define IMP_WGROUP3 3
#define IMP_NEXWGRP 4  //next weapon group
#define IMP_PRVWGRP 5  //previous weapon group
#define IMP_SUICIDE 6  //debug suicide - DEPRECATE
#define IMP_TARGET 7 //target under reticule
#define IMP_RADAR 8  //toggle radar
//float 9;
#define IMP_FGROUP 10 //toggle group fire
#define IMP_FCHAIN 11 //toggle chain fire
#define IMP_TACMAP 12
#define IMP_SELECT_WEAPON1 13
#define IMP_SELECT_WEAPON2 14
#define IMP_SELECT_WEAPON3 15
#define IMP_SELECT_WEAPON4 16
#define IMP_SELECT_WEAPON5 17
#define IMP_SELECT_WEAPON6 18
#define IMP_SELECT_WEAPON7 19
#define IMP_SELECT_WEAPON8 20
#define IMP_SELECT_WEAPON9 21
#define IMP_FSINGLE 22
#define IMP_WGROUP4 23
//-----------------24
#define IMP_SHOWOB 25
#define IMP_ZOOM 26
#define IMP_SLIDE 27
#define IMP_FAC_NEXT 28
#define IMP_FAC_PREV 29
#define IMP_EXTERNAL_CAMERA 30
#define IMP_MENU_GROUP 31 //mostly clientside only for opening weapon rebind menu
#define IMP_HEADLIGHT 32  //toggle headlight.
void(float selector) mpls_groupFire;