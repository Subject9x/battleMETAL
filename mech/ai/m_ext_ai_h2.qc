/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

float AI_STATE_READY = 0;
float AI_STATE_WANDER = 1; // mods the move state, wander = random movement
float AI_STATE_TOPOINT = 2; //mods the move state, move to a non-target point
float AI_STATE_HUNT = 3;      //mods the move state, actively chase a target
float AI_STATE_COVER = 4;
float AI_STATE_DEFEND = 5;


.float ai_state; //tracks the state of the AI
.float ai_optical; //the 'visual' range the ai can see out before relying on sensors
.float ai_patience; //counter for if AI is stuck on something
.vector ai_prev_org;

.void() ai_next_move; //run this move on this frame
.void() ai_next_state;
.void() ai_unit_update; //depends on unit type

//.goalentity should always be where the AI *MOVES* to
//.target should always be the thing the AI *SHOOTS* at and aims at
void() ai_spawn_start;
void() ai_control;

//move directives
void() ai_move_stand;
void() ai_move_walk;
void() ai_mive_walk_slide;
void() ai_move_run;
void() ai_move_run_slide;
void() ai_move_forward;
void() ai_move_backward;

//state directives
void() ai_state_hunt;
void() ai_state_wander;
void() ai_state_tonode;
void() ai_state_defend;
void() ai_state_ready;

//utility functions
float(entity targ) ai_target_infront;
float(entity targ) ai_target_visible;
float() ai_core_findnode; // find the closest AI node
float() ai_core_findtarget; //ai scans for a target
float() ai_core_foundtarget; //ai has found a target, update state accordingly
float() ai_core_targetstate; //checks to see if target ent is still a valid ent to be a target
entity() ai_core_opticaltarget;
entity() ai_core_radartarget;
float() ai_target_facingideal;
//TODO - separate header?
void() ai_mech_update;
void() ai_mech_attack;
void() ai_mech_die;
void() ai_mech_cleanup;
