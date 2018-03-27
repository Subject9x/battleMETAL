/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview:  header file for ui system
*/

float AVAILABLE_RESERVE;

entity SELECTED_MECH; //used across the menu system

float MENU_ACTIVE;
float MENU_CHOICE = 1; //always start at briefing
float MENU_BRIEF_ACTIVE = 1;
float MENU_HANGAR_ACTIVE = 2;
float MENU_ARMING_ACTIVE = 3;
float MENU_DEPLOY_ACTIVE = 4;
float MENU_LAUNCH_ROLLOVER = 5;

vector cursorpos;
vector last_view;

.void(vector org) menu_renderHardpoints;    //the mech data ent implements these
.float(vector org) menu_hardpointListener; //the mech data ent implements these
.void(vector org) menu_hardpointRows;

float(vector mpos, vector org, vector sz) menu_checkMouseInBounds;
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener;
void() ui_renderHUDHighlight;

vector MENU_BTN_LAUNCH_ORG;
vector MENU_BTN_LAUNCH_SZ;

void() menu_handleFrame;
void(vector ofs) menu_navBar;
void() menu_mainListener;
void() navBarListener;
void() mechAcceptButtonListener;
void(float wid, vector org, float selected) ui_renderHardPointGraphic;
void(entity nav) ui_renderNav;
void(float num, vector org) ui_renderHardPointNumber;
void(vector org, float hpt_num, float types, float sz)  ui_renderHardpointRow;

string MISSION_OBJECTIVES[12];
float MISSION_OBJ_STATUS[12];

//pre-launch validation
float LAUNCH_VALIDATION;
float VALID_MECH = 1;
float VALID_GRPS = 2;
float VALID_NODE = 4;

//image defs
string UI_DEF_BOX_512;
string UI_DEF_BOX_256;
string UI_DEF_BOX_256_TALL;
string UI_DEF_BOX_64;
string UI_DEF_NAVPOINT;
string UI_DEF_DEPLOYPOINT;
string UI_HANGAR_BOX;
string UI_BOX_SELECT;
string UI_CURSOR_IMG;

//hangar graphics
string UI_WEP_ENE;
string UI_WEP_BAL;
string UI_WEP_EXP;
string UI_WEP_MSC;
  
string UI_WEP_LAS;
string UI_WEP_ESR;
string UI_WEP_PAC;
string UI_WEP_EMP;
string UI_WEP_RCK;
string UI_WEP_MLGD;
string UI_WEP_MARH;
string UI_WEP_ATC;
string UI_WEP_QRF;
string UI_WEP_RPC;
string UI_WEP_SFG;
string UI_WEP_FLAK;
string UI_WEP_ION;
string UI_WEP_SWRM;