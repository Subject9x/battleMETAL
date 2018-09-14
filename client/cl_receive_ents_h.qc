/*
mech Mod
Author: Peter Roohr
Date: 3/13/2018
Overview: header for all reception of SendEntity calls made by
server.
*/

void() client_get_info;
void() client_get_contact;
void() client_get_hud_highlight;

void() receive_ent_bindData;

void( float isnew ) receive_ent_navPoint;
void( float isnew ) receive_ent_mapObjective;
void( float isnew ) receive_ent_aiBuilding;
void( float isnew ) receive_ent_aiVehicle;
void( float isnew ) receive_ent_mapDeployPoint;