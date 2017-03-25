/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: ui header file the hangar menu
*/
//might as well go wild with the globals
  float MECHLIST_LIGHT_ARR[8]; 
  float MECHLIST_MEDIUM_ARR[8]; 
  float MECHLIST_HEAVY_ARR[8]; 

  float WEPLIST_BAL_ARR[8];
  float WEPLIST_ENE_ARR[8];
  float WEPLIST_EXP_ARR[8];
  float WEPLIST_MSC_ARR[8];

  float HARDPOINTS[8];
  float NEXT_WEAPONS[9];
  
  float WEPBITS[8];
  
  vector MECHPANEL_CTR;
//light mech list globals
  vector MECHLIST_SIZE_LIGHT;
  vector MECHLIST_ORG_LIGHT;
  float MECHLIST_CNT_LIGHT;
//medium mech list globals
  vector MECHLIST_SIZE_MEDIUM;
  vector MECHLIST_ORG_MEDIUM;
  float MECHLIST_CNT_MEDIUM;
//heavy mech list globals
  vector MECHLIST_SIZE_HEAVY;
  vector MECHLIST_ORG_HEAVY;
  float MECHLIST_CNT_HEAVY;
vector WEPNLIST_ORG;
vector WEPNLIST_SIZE;
float WEPNLIST_CNT;
//ballistic weapon list globals
  float WEPNLIST_CNT_BAL;
  vector WEPNLIST_ORG_BAL;
  vector WEPNLIST_SIZE_BAL;
//energy weapon  mech list globals
  float WEPNLIST_CNT_ENE;
  vector WEPNLIST_ORG_ENE;
  vector WEPNLIST_SIZE_ENE;
//missile / explosive weapon  mech list globals
  float WEPNLIST_CNT_EXP;
  vector WEPNLIST_ORG_EXP;
  vector WEPNLIST_SIZE_EXP;
// miscellaneous weapon list globals
  float WEPNLIST_CNT_MSC;
  vector WEPNLIST_ORG_MSC;
  vector WEPNLIST_SIZE_MSC;

// weapon group A
  float WEPNGRP_CNT_A;
  vector WEPNGRP_ORG_A;
  vector WEPNGRP_SIZE_A;
// weapon group B
  float WEPNGRP_CNT_B;
  vector WEPNGRP_ORG_B;
  vector WEPNGRP_SIZE_B;
// weapon group C
  float WEPNGRP_CNT_C;
  vector WEPNGRP_ORG_C;
  vector WEPNGRP_SIZE_C;
  
//hardpoint count
  float HARDPOINT_CNT;
  
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
void() weaponGroupPanelListener;

void(vector ofs) menu_hangar_DrawNavBar;
void(vector ofs) menu_hangar_MechDisplay;
void(vector ofs) menu_hangar_MechList;
void(vector ofs) menu_hangar_MechListLight;
void(vector ofs) menu_hangar_MechListMedium;
void(vector ofs) menu_hangar_MechListHeavy;
void(vector ofs) menu_hangar_MechInfo;
void(vector ofs) menu_hangar_WeaponList;
void(vector ofs) menu_hangar_WeaponList_BAL;
void(vector ofs) menu_hangar_WeaponList_ENE;
void(vector ofs) menu_hangar_WeaponList_EXP;
void(vector ofs) menu_hangar_WeaponList_MSC;
void(vector ofs) menu_hangar_HardPointInfo;
void(vector ofs) menu_hangar_WeaponGroupPanel;

//utility
float(float comp) checkIfWeaponInGroup;
void(float wep_id, float grp_id) assignWeaponToGroup;
void() getNextWeaponGroup;
void() getPrevWeaponGroup;