/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview:  header file for ui system
*/

float AVAILABLE_RESERVE;

entity PLAYER_HELPER;

float MENU_ACTIVE;
float MENU_HANGAR_ACTIVE = FALSE;
float MENU_BRIEF_ACTIVE = FALSE;
float MENU_DEPLOY_ACTIVE = FALSE;
float MENU_LAUNCH_ROLLOVER = FALSE;

vector cursorpos;
vector last_view;

.void(vector org) menu_renderHardpoints;    //the mech data ent implements these
.float(vector org) menu_hardpointListener; //the mech data ent implements these

float(vector mpos, vector org, vector sz) menu_checkMouseInBounds;
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener;


vector MENU_BTN_LAUNCH_ORG;
vector MENU_BTN_LAUNCH_SZ;

void() menu_handleFrame;
void(vector ofs) menu_navBar;
void() menu_mainListener;
void() navBarListener;
void() mechAcceptButtonListener;

void(entity nav) ui_renderNav;


//image defs
string UI_DEF_BOX_512;
string UI_DEF_BOX_256;
string UI_DEF_BOX_256_TALL;
string UI_DEF_BOX_64;
string UI_DEF_NAVPOINT;
string UI_HANGAR_BOX;