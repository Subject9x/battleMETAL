/*
mech Mod
Author: Peter Roohr
Date: 1/29/2017
Overview: the defintion file for my radar idea
*/
//functions
vector() radar_MakeSweep;
float(entity contact, float current_total) radar_calcPlayerDist;
float(entity root, entity contact, float current_total) radar_calcEnemyDist;