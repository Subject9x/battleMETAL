/*
mech Mod
Author: Peter Roohr
Date: 3/24/2017
Overview: ui header file the deployment menu
*/

//some menu globals
  float INFO_SWITCH = TRUE;
  vector OBJ_BTN_ORG;
  vector OBJ_BTN_SZ;
  vector INT_BTN_ORG;
  vector INT_BTN_SZ;
//sadly we need to limit navpoints too
  float NAVPOINTS[10];  //the contents relate to navpoint id's, and honestly I dont think anyone needs more than 10
  float NAVPOINTS_CNT;
//main hook for menu system
void() menu_briefDrawFrame;

//hook for input system
void() menu_briefListener;

//Listener hooks called by menu_deployListener
void() navpointListener;
void() objIntelSwitchListener;

//panels
void(vector ofs) menu_briefMissionInfo;
void(vector ofs) menu_briefMissionText;
void(vector ofs) menu_briefMapPanel;
void(vector ofs) menu_briefObjectivePanel;
void(vector ofs) menu_briefIntelPanel;
void(vector ofs) menu_objIntelSwitchPanel;
