/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

//pathfinder node stuff
.float node_id;
.float nexnode1;
.float nexnode2;
.float nexnode3;
.float nexnode4;
.float nexnode5;
.float nexnode6;
.float nexnode7;
.float nexnode8;
.float nexnode9;
.float nexnode10;
.float nexnode11;
.float nexnode12;
.float nexnode13;
.float nexnode14;
.float nexnode15;
.float nexnode16;
.float nexnode17;
.float nexnode18;
.float nexnode19;
.float nexnode20;
.float nexnode21;
.float nexnode22;
.float nexnode23;
.float nexnode24;
//=========================


float AI_RANGE_S = 600;
float AI_RANGE_M = 1200;
float AI_RANGE_L = 1800;

.entity ai_goal;
.float ai_dmg_l;
.float ai_dmg_m;
.float ai_dmg_s;
.float ai_rng_s;
.float ai_rng_m;
.float ai_rng_l;

.float ai_leading; //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange; //minimum range of guns;
.float ai_optical; //the 'visual' range the ai can see out before relying on sensors
.float ai_patience; //counter for if AI is stuck on something
.vector ai_prev_org;

.void() ai_next_move; //run this move on this frame
.void() ai_next_state;
.void() ai_unit_update; //depends on unit type
.void() ai_prev_move;
//.goalentity should always be where the AI *MOVES* to
//.target should always be the thing the AI *SHOOTS* at and aims at
void() ai_spawn_start;
void() ai_control;

void(entity wep) ai_attack_basic;
void(entity wep) ai_attack_ene;
void(entity wep) ai_attack_bal;
void(entity wep) ai_attack_exp;
void() ai_calc_attackranges;

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
void() ai_state_panic;
void() ai_state_trynode;

//utility functions
float(entity ai, entity goal) ai_core_trynode;
entity(entity node, float id) ai_query_graphnode;
entity(vector org, float start_dist) ai_core_findgraphnode;
float(entity targ) ai_target_infront;
float(entity targ) ai_target_insights;
float(entity targ) ai_target_visible;
float() ai_core_findnode; // find the closest AI node
float() ai_core_findtarget; //ai scans for a target
float() ai_core_foundtarget; //ai has found a target, update state accordingly
float() ai_core_targetstate; //checks to see if target ent is still a valid ent to be a target
entity() ai_core_opticaltarget;
entity() ai_core_radartarget;
float() ai_target_facingideal;
float() ai_core_panicnode;
float(vector chk, vector node) ai_core_nodelos;
void(entity e, entity mask) ai_core_sortranges;

//TODO - separate header?
void() ai_mech_update;
void() ai_mech_attack;
void() ai_mech_die;
void() ai_mech_cleanup;
void() ai_mech_touch;