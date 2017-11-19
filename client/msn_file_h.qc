/*
mech Mod
Author: Subject9x
Date: 04/02/2017
mod: 5/5/2017 - added void(string line, string val) msn_setresrv
Overview: header for the mission file handler.
*/

float MSN_FILEFOUND = FALSE;
float MSN_LOADED = FALSE;
string MSN_FILENAME;
string MSN_MAPPIC;
string MSN_NAME;
string MSN_TYPE;
string MSN_RESERVETOTAL;
string MSN_SECTOR;
string MSN_LOCATION;
string MSN_LOCALTIME;
string MSN_BRIEF;
string MSN_INTEL;
float MSN_OBJ;

string MSN_OBJ_DESC[10];

void() msn_getfile;
void() msn_parsefile;
void(string line, string val) msn_setmappic;
void(string line, string val) msn_setname;
void(string line, string val) msn_settype;
void(string line, string val) msn_setresrv;
void(string line, string val) msn_setsector;
void(string line, string val) msn_setlocation;
void(string line, string val) msn_setlocaltime;
void(string line, string val) msn_setbrief;
void(string line, string val) msn_setintel;
void(string line, string val) msn_settotalobjectives;
float(string line, string val) msn_mapobjid;
void(float obj_id, string line, string val) msn_setobjdesc;