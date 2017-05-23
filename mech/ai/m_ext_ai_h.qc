/*
mech Mod
Date: 5/3/2017
Overview: ai extension header
*/

//AI states
/*.float ai_state;
float AI_STAND = 0;
float AI_RUN = 1;
float AI_WALK = 2;
float AI_FORWARD = 4;
float AI_BACKWARD = 5;
float AI_HUNTTARGET = 6;*/


float AI_MOVE_STAND = 1; //movement state, AI just sits there
float AI_MOVE_WALK = 2;   //movement state, AI walks in a direction
float AI_MOVE_RUN = 3;      //movement state, AI runs in a direction
float AI_MOVE_RUN_STRAFE = 4;
float AI_MOVE_BACK = 5;

float AI_QUIRK_SUICIDAL = 1;
float AI_QUIRK_RANGED = 2;
float AI_QUIRK_MELEE = 4;
float AI_QUIRK_COWARD = 8;
float AI_QUIRK_AGGRO = 16;
float AI_QUIRK_ARSON = 32;
float AI_QUIRK_HUNTKILL = 64;
float AI_QUIRK_SNIPER = 128;
    

float AI_MOOD_IRON = 0;
float AI_MOOD_FINE = 1;
float AI_MOOD_SCARED = 2;
float AI_MOOD_PANIC = 3;

.float ai_move;
.float ai_state;
.float ai_state_prev;
.float ai_quirks;
.float ai_mood;

.entity ai_gunner; //this is the child of the AI that will face any targets, and the origin from which attacks are launched
.vector ai_strafe;

void() ai_control;
void(float new_state) ai_update_state;
entity() ai_find_node;
float() ai_find_target;
void() ai_move_strafe;
void() ai_mech_update;
void() ai_weapon_update;
void() ai_mech_die;
void() ai_mech_walk;
void() ai_mech_run;
void() ai_mech_attack;
void() ai_mech_stand;
void() ai_mech_cleanup;
void() ai_conv_update;