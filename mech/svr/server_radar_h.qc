/*
mech Mod
Author: Subject9x
Date: 1/29/2017
Overview: the defintion file for my radar idea
*/

//entity extensions
.float radar_range;
.float radar_mode;
.float radar_front;
.float radar_rear;

//GLOBALS
float RADAR_ISMECH = 2;
float RADAR_ISVEC = 1;
float RADAR_ISNEAR = 3;
float RADAR_ISCLOSE = 2;
float RADAR_ISFAR = 1;
float RADAR_ETOT_RATIO = 0.25; //ration of contact points per game unit for how far apart the enemy is to the target
float RADAR_ETOE_RATIO = 0.5; //ratio of contact points per game unit for how far apart enemies are

//SUBTYPES
float RADAR_ISCIV = 1;
float RADAR_ISLGTV = 2;
float RADAR_ISHVYV = 3;
float RADAR_ISLMCH = 4;
float RADAR_ISMMCH = 5;
float RADAR_ISHMCH = 6;

//functions

float() radar_MakeSweep;
float(entity contact, float current_total) radar_calcPlayerDist;
float(entity root, entity contact, float current_total) radar_calcEnemyDist;
float(entity contact, float current_total)  radar_calcUnitValue;
float(entity org, entity contact) radar_calcFacing;