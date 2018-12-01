/*
mech Mod
Author: Peter Roohr
Date: 03/25/2017
Overview: map objects header, for cleanliness
*/
//TODO - deprecate, refactor, delete this file
//nav point stuff
.float controllingFaction;
.float isActive;
.float nav_name;

void() building_die;

//AI
void() ai_mech;
void() ai_spawner_use;
void() ai_spawner_think;
void() ai_spawner_activate;