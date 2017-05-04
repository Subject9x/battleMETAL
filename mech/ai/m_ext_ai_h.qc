/*
mech Mod
Date: 5/3/2017
Overview: ai extension header
*/

//AI states
.float ai_state;
float AI_STAND = 0;
float AI_RUN = 1;
float AI_WALK = 2;
float AI_FORWARD = 4;
float AI_BACKWARD = 5;
float AI_HUNTTARGET = 6;

void() ai_control;
void() ai_mech_update;
void() ai_weapon_update;
void() ai_mech_die;
void() ai_mech_walk;
void() ai_mech_run;
void() ai_mech_attack;
void() ai_mech_stand;