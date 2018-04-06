/*
mech Mod
Author: Peter Roohr
Date: 3/17/2018
Overview: This code writes out the single player save file.
The save file is mostly an inter-level intermediary file
to track player unlocks
*/

//globals
string SAVE_FILE_NAME = "save_me.sav"; //bake this in cause the name shouldnt change
string SAVE_MECHS_LIGHT;
string SAVE_MECHS_MEDIM;
string SAVE_MECHS_HEAVY;
string SAVE_ITEMS_ALL;
float SAVE_MISSN_POINTS;

string SAVE_FILE_EXT = ".sav";

//file tags
string SAVE_FILE_MSN_NAME = "mission";
string SAVE_FILE_MECHS_LIGHT = "light";
string SAVE_FILE_MECHS_MEDIUM = "medium";
string SAVE_FILE_MECHS_HEAVY = "heavy";
string SAVE_FILE_ITEMS = "items";
string SAVE_FILES_POINTS = "points";

//functions
void() savefile_load; //single player only
void() savefile_save; //single player only
void() savefile_default;  //single player, but initial start
void() savefile_append;
string(string item, string source) savefile_insert;

void() mapfile_coop_load;  //coop options
void(float faction) mapfile_pvp_load;  //pvp options