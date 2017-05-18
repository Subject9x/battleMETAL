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


float AI_STATE_STAND = 1; //movement state, AI just sits there
float AI_STATE_WALK = 2;   //movement state, AI walks in a direction
float AI_STATE_RUN = 3;      //movement state, AI runs in a direction

float AI_STATE_WANDER = 1; // mods the move state, wander = random movement
float AI_STATE_TOPOINT = 2; //mods the move state, move to a non-target point
float AI_STATE_HUNT = 3;      //mods the move state, actively chase a target

float AI_STATE_SWEEP = 64;  //make a sensor sweep to find a target
float AI_STATE_ATTACK = 128; //check to see if target can be attacked
float AI_STATE_PEACE = 256;

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
.float ai_quirks;
.float ai_mood;
void() ai_control;
void() ai_mech_update;
void() ai_weapon_update;
void() ai_mech_die;
void() ai_mech_walk;
void() ai_mech_run;
void() ai_mech_attack;
void() ai_mech_stand;
void() ai_conv_update;