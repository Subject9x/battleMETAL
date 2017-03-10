/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview:  header file for ui system
*/

entity PLAYER_HELPER;

float MENU_ACTIVE;
float MENU_HANGAR_ACTIVE = FALSE;
float MENU_BRIEF_ACTIVE = FALSE;

vector cursorpos;
vector last_view;

.void(vector org) menu_renderHardpoints;
.float(vector org) menu_hardpointListener;

float(vector mpos, vector org, vector sz) menu_checkMouseInBounds;

float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener;

void() menu_handleFrame;
void() menu_renderHangar;
void() menu_renderBriefing;