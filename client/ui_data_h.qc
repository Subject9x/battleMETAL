/*
mech Mod
Author: Peter Roohr
Date: 6/26/2018
Overview: refactor ui data to file loading, header
*/

float MECH_DATA_SIZES[GAME_TOTAL_MECHS];
string MECH_DATA_NAMES[GAME_TOTAL_MECHS];

//MECH DATA FILE
float   MECH_DATA_ID;
string  MECH_DATA_ABR;
string  MECH_DATA_NAME;
float   MECH_DATA_SIZE;
float   MECH_DATA_TECH;
string  MECH_DATA_ICON;
float   MECH_DATA_ENMAX;
float   MECH_DATA_ENRATE;
float   MECH_DATA_SHMAX;
float   MECH_DATA_SHRATE;
float   MECH_DATA_HPOINTS;
float   MECH_DATA_SPEEDF;
float   MECH_DATA_SPEEDS;
float   MECH_DATA_SPEEDB;
float   MECH_DATA_ACCEL;
float   MECH_DATA_HPCT;
float   MECH_DATA_HPST;
float   MECH_DATA_HPAR;
float   MECH_DATA_HPLG;
float   MECH_DATA_RAD;
string  MECH_DATA_DESC;

float   MECH_DATA_H_TYPE[10];
float   MECH_DATA_H_SIZE[10];
vector  MECH_DATA_H_ARM[10];
vector  MECH_DATA_H_HNG[10];
float   MECH_DATA_STOCK[10];
float   MECH_DATA_GRPS[6];


//items are compared to each other so they get 2 listings
//ITEM 1 is the data for the weapon on top
//ITEM 1 DATA

//ITEM 2 DATA 


//functions
void() ui_data_load_mechnames;
void() ui_data_load_mechsizes;
void() ui_data_clear_mechdata;
float(float id) ui_data_load_mech;