/*
mech Mod
Author: Peter Roohr
Date: 03/25/2017
Overview: map objects header, for cleanliness
*/

//nav point stuff
.float controllingFaction;
.float isActive;
.float nav_name;

void() building_die;

void() nav_point_use;
void() nav_point_th;
float(entity ent, float changed) send_navpoint;

//deploy point stuff
void() deploy_point_use;
void() th_deploy;
float(entity ent, float changed) send_deploypoint;

//AI
void() ai_mech;
void() ai_spawner_use;
void() ai_spawner_think;
void() ai_spawner_activate;

//map objectives
void() map_objective_th;
void() map_objective_use;
float(entity ent, float changed) send_objective;

//misc model
void() misc_model_remove;

//animatic stuff
void() animatic_event_execute;
void() animatic_event_use;
void() animatic_event_touch;

//player target listener
void() misc_target_listen_think;
void() misc_target_listen;