/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: ui header file the hangar menu
*/

//DISPLAY CONSTANT
  float DISP_MAX_FSPEED = 225;
  float DISP_MAX_SSPEED = 200;
  float DISP_MAX_BSPEED = 175;
  float DISP_MAX_ENE = 1500;
  float DISP_MAX_ENE_RATE = 5;
  float DISP_MAX_SHIELD = 700;
  float DISP_MAX_SHIELD_RATE = 5;
  float DISP_MAX_ARM_CT = 1200;
  float DISP_MAX_ARM_ST = 1200;
  float DISP_MAX_ARM_AR = 1200;
  float DISP_MAX_ARM_LG = 1500;
  float DISP_MAX_RAD_RANGE = 9000;
//might as well go wild with the globals
  float MECHLIST_LIGHT_ARR[GAME_TOTAL_MECHS];
  float MECHLIST_LIGHT_VAL[GAME_TOTAL_MECHS];
  
  float MECHLIST_MEDIUM_ARR[GAME_TOTAL_MECHS];
  float MECHLIST_MEDIUM_VAL[GAME_TOTAL_MECHS];
  
  float MECHLIST_HEAVY_ARR[GAME_TOTAL_MECHS];
  float MECHLIST_HEAVY_VAL[GAME_TOTAL_MECHS];
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
void(vector ofs) menu_hangar_MechFluff;
void(vector ofs) menu_hangar_MechHPoints;