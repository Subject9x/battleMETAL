/*
mech Mod
Author: Peter Roohr
Date: 3/24/2017
 mod 4/9//2017
Overview: ui header file the deployment menu
*/

//sadly we need to limit navpoints too

//main hook for menu system
void() menu_deployDrawFrame;

//hook for input system
void() menu_deployListener;

//Listener hooks calle by menu_deployListener
void() navSelectListener;

//panels
void(vector ofs) menu_deploy_missionInfoPanel;
void(vector ofs) menu_deploy_navInfoPanel;
void(vector ofs) menu_deploy_mechInfoPanel;
void(vector ofs) menu_deploy_mapOverviewPanel;