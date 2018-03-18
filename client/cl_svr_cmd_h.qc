/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: definition file for the client -> server command layer

*/
void(float val) cl_set_movespeedkey;
void(float val, float w_bit) cl_setweapon;
void(float sz, float id) cl_setmech;
void() cl_spawnmech;
void(float grp_id, float grp_val) cl_setweapongroup;
void(float nav_id) cl_setspawnpoint;

void(string fileName) cl_get_msnfile;
void(string fileName) cl_get_animfile;
void(string mech_data) cl_get_mechs_light;
void(string mech_data) cl_get_mechs_medium;
void(string mech_data) cl_get_mechs_heavy;
void(string item_data) cl_get_items_all;