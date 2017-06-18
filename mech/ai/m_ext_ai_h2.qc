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
.float nexnode25;
.float nexnode26;
.float nexnode27;
.float nexnode28;
.float nexnode29;
.float nexnode30;
.float nexnode31;
.float nexnode32;
//=========================


float AI_RANGE_S = 800;
float AI_RANGE_M = 1600;
float AI_RANGE_L = 2400;

.entity oldgoal;
.float ai_dmg_l;
.float ai_dmg_m;
.float ai_dmg_s;
.float ai_rng_s;
.float ai_rng_m;
.float ai_rng_l;

.float ai_leading; //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange; //minimum range of guns;
.float ai_optical; //the 'visual' range the ai can see out before relying on sensors
.float patience; //counter for if AI is stuck on something
.float maxpatience; //how impatient is the AI
.vector ai_prev_org;

.void() ai_unit_update; //depends on unit type
//.goalentity should always be where the AI *MOVES* to
//.target should always be the thing the AI *SHOOTS* at and aims at
void() ai_spawn_start;
void() ai_control;

//new
.void() ai_first_order; //order the unit was spawned with
.void() ai_current_order; //order the ai is currently processing;


.void() ai_prev_state; //*-refactor
.void() ai_next_move;  //*-refactor//run this move on this frame
.void() ai_next_state; //*-refactor
.void() ai_state_cache; //*-refactor
.void() ai_move_cache; //*-refactor


void(entity wep) ai_attack_basic;
void(entity wep) ai_attack_ene;
void(entity wep) ai_attack_bal;
void(entity wep) ai_attack_exp;

//move directives
void() ai_move_stand;
void() ai_move_walk_goal;
void() ai_move_walk_goal_slide;
void() ai_move_run_goal;
void() ai_move_run_goal_slide;
void() ai_move_forward;
void() ai_move_backward;

//ai orders - these things sit atop all other ai directives
void() ai_order_topoint;
void() ai_order_fight;
void() ai_order_defend;
void() ai_order_patrol;
void() ai_order_stand;

void() ai_sub_hunt;
void() ai_sub_tonode;
void() ai_sub_trynode;
void() ai_sub_wander

//state directives
void() ai_state_hunt; //*-refactor
void() ai_state_fight; //*-refactor
void() ai_state_wander; //*-refactor
void() ai_state_tonode; //*-refactor
void() ai_state_defend; //*-refactor
void() ai_state_ready; //*-refactor
void() ai_state_panic; //*-refactor
void() ai_state_trynode; //*-refactor

//utility functions
void(void() state, void() move, float cache_state) ai_update_statemove;
float(entity ai, entity goal) ai_core_trynode;
entity(entity node, float id) ai_query_graphnode;
entity(vector org, float start_dist) ai_core_findgraphnode;
float(entity targ) ai_target_infront;
float(entity targ) ai_target_insights;
float(entity targ) ai_target_visible;
entity() ai_core_findnode; // find the closest AI node
entity() ai_core_findtarget; //ai scans for a target
float() ai_core_foundtarget; //ai has found a target, update state accordingly
float() ai_core_targetstate; //checks to see if target ent is still a valid ent to be a target
entity() ai_core_opticaltarget;
entity() ai_core_radartarget;
float() ai_target_facingideal;
float() ai_core_panicnode;
float(vector chk, vector node) ai_core_nodelos;

//TODO - separate header?
void() ai_mech_update;
void() ai_mech_attack;
void() ai_mech_die;
void() ai_mech_cleanup;
void() ai_mech_touch;