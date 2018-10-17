/*
mech Mod
Author: Peter Roohr
Date: 3/24/2017
 mod 4/9//2017
Overview: ui header file the deployment menu
*/

float DEPLOY_CNT;
float DEPLOY_IDS[32];
vector DEPLOY_MAP_ORG;
float DEPLOY_POINT_ID;
float DEPLOY_POINT_END;

//sadly we need to limit navpoints too

//main hook for menu system
void() menu_deployDrawFrame;

//hook for input system
void() menu_deployListener;

//Listener hooks calle by menu_deployListener
void() navSelectListener;
void() navListSelectListener;

//panels
void(vector ofs) menu_deploy_missionInfoPanel;
void(vector ofs) menu_deploy_navInfoPanel;
void(vector ofs) menu_deploy_mechInfoPanel;
void(vector ofs) menu_deploy_mapOverviewPanel;