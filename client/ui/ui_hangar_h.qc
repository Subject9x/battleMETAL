/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: ui header file the hangar menu
*/
//might as well go wild with the globals
  float MECHLIST_LIGHT_ARR[24]; 
  float MECHLIST_MEDIUM_ARR[24]; 
  float MECHLIST_HEAVY_ARR[24]; 
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
  
//main hook for menu system
void() menu_hangarDrawFrame;

//hook for input system
void() menu_hangarListener;

//Listener Hooks called by menu_hangarListener
void() mechSelectListener;
void() mechAcceptButtonListener;

void(vector ofs) menu_hangar_MechDisplay;
void(vector ofs) menu_hangar_MechList;
void(vector ofs) menu_hangar_MechListLight;
void(vector ofs) menu_hangar_MechListMedium;
void(vector ofs) menu_hangar_MechListHeavy;
void(vector ofs) menu_hangar_MechInfo;
