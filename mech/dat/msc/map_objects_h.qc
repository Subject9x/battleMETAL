/*
mech Mod
Author: Subject9x
Date: 03/25/2017
Overview: map objects header, for cleanliness
*/

//nav point stuff
.float obj_status;
.float controllingFaction;
.float isActive;
.float nav_name;

void() nav_point_use;
void() nav_point_th;
float(entity ent, float changed) send_navpoint;

//AI nodes
void() ai_node_touch;
void() ai_node_graph_touch;
void() ai_node;

//map objectives
void() map_objective_th;
void() map_objective_use;
float(entity ent, float changed) send_objective;