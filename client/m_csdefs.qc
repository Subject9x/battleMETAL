/*
mech Mod
Author: Subject9x
Date: 10/11/2016
Overview: csqc defs for the mod
*/

//player vars
float LEG_ARM_MX;
float LEG_ARM_CUR;
float LEG_HP_MX;
float LEG_HP_CUR;

float TOR_L_ARM_MX;
float TOR_L_ARM_CUR;
float TOR_L_HP_MX;
float TOR_L_HP_CUR;

float TOR_R_ARM_MX;
float TOR_R_ARM_CUR;
float TOR_R_HP_MX;
float TOR_R_HP_CUR;

//ent broadcast flags
float ENT_INVALID = 0; // never used
float ENT_GAMESETTINGS = 1; // provide game parameters such as frag limit, time limit, etc...
float ENT_PLAYER = 2; // player entity (origin, aimdir, active weapon, etc)
float ENT_INVENTORYITEM = 3; // inventory items in this player's inventory are networked this way
float ENT_ADDVECCOMP = 4; //mod: add vehicle component to cs
float ENT_ADDWEPCOMP = 5;

//stat channgels
float STAT_CPIT_MDL = 33;

float STAT_ENERGY_CUR = 34;
float STAT_ENERGY_MAX = 35;
float STAT_SHIELD_CUR = 36;
float STAT_SHIELD_MAX = 37;

//actual csqc constants
vector ENG_COLOR_CURRENT;
vector SHD_COLOR_CURRENT;
vector DMG_COLOR_CURRENT;
vector DMG_COLOR_GREEN = '0 1 0';
vector DMG_COLOR_YELLOW = '1 1 0';
vector DMG_COLOR_RED = '1 0 0';
vector DMG_COLOR_GRAY = '0.1 0.1 0.1';

//mech piece classname constants
string M_TOR_CENTER = "tor_center";
string M_TOR_RIGHT = "tor_right";
string M_TOR_LEFT = "tor_left";
string M_LEGS = "legs";
string M_LEG_L = "legs_l";
string M_LEG_R = "legs_r";
string M_ARM_LEFT = "arm_left";
string M_ARM_RIGHT = "arm_right";