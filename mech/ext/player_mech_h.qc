/*
mech mod
Author: Subject9x
Date: 9/7/2016
Overview: head for mech management functions
*/


void() ctrl_update_mechplayer;
void() stat_update_weapons;

void() mech_player_die;
void() mech_player_weapondie;
void() mech_player_cameradie;
void(entity comp) mech_player_compdie;

void() cleanup_mech;
void() mech_player_removecamera;
void(entity comp) mech_player_removecomp;