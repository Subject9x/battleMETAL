/*
mech Mod
Author: Subject9x
Date: 04/02/2017
Overview: header for the mission file handler.
*/

float MSN_FILEFOUND = FALSE;
float MSN_LOADED = FALSE;
string MSN_FILENAME;
string MSN_NAME;
string MSN_TYPE;
string MSN_SECTOR;
string MSN_LOCATION;
string MSN_LOCALTIME;
string MSN_BRIEF;
string MSN_INTEL;

void() msn_getfile;

void() msn_parsefile;