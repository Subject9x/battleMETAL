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

//how well does the AI handle weapon convergence
float AI_CNV_ACE = 10;//16;
float AI_CNV_VET = 15;//24;
float AI_CNV_REG = 20;//36;
float AI_CNV_ROK = 25;//48;

//how does range affect the AI's accuracy
float AI_RNG_ACE = 1;
float AI_RNG_VET = 1.15;
float AI_RNG_REG = 1.25;
float AI_RNG_ROK = 1.5;

//Adjust Rotation Rate
//self.yaw_speed = rotation rate + (rotation rate * AI_ROT_X);
float AI_ROT_ACE = 0.7;//0.7;
float AI_ROT_VET = 0.6;//0.5;
float AI_ROT_REG = 0.4;//0.3;
float AI_ROT_ROK = 0.25;//0.1;

//armor based on difficulty
//hp = hp * AI_ARMOR
float AI_ARMOR_EASY = 0.3;//0.2;
float AI_ARMOR_MEDM = 0.4;
float AI_ARMOR_HARD = 0.6;
float AI_ARMOR_NIGHT = 0.75;

//ai_leading ratings, how well an ai tracks a slippery targt
float AI_LEAD_ACE = 0.04;//0.05;
float AI_LEAD_VET = 0.06;//0.1;
float AI_LEAD_REG = 0.08;//0.18;
float AI_LEAD_ROK = 0.1;//0.24;

//ai's patience in hunting a target, the better the pilot the longer they hunting
float AI_PTNCE_ACE = 40;
float AI_PTNCE_VET = 30;
float AI_PTNCE_REG = 20;
float AI_PTNCE_ROK = 10;

//
float AI_RANGE_S = 1000;
float AI_RANGE_M = 2400;
float AI_RANGE_L = 4000;

float AI_WALK_SPD = 0.035;//0.03;
float AI_RUN_SPD = 0.045;//0.045;

//AI order constants, refactored from func pointers
float AI_ORDER_DEBUG = -1;
float AI_ORDER_STAND = 0;
float AI_ORDER_DEFEND = 1;
float AI_ORDER_PATROL = 2;
float AI_ORDER_ATTACK = 3;

.float ai_first_order;
.float ai_current_order;

.vector prev_pos;
.entity oldgoal;
.float ai_dmg_l;
.float ai_dmg_m;
.float ai_dmg_s;
.float ai_rte_rng;
.float ai_rte_cnv;

.float ai_leading; //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange; //minimum range of guns;
.float ai_optical; //the 'visual' range the ai can see out before relying on sensors
.float patience; //counter for if AI is stuck on something
.float maxpatience; //how impatient is the AI
//.vector ai_prev_org; use the pre-existing 'dest' vars

.void() ai_unit_update; //depends on unit type
//.goalentity should always be where the AI *MOVES* to
//.target should always be the thing the AI *SHOOTS* at and aims at
void() ai_control;

//new
//.void() ai_first_order; //order the unit was spawned with

.void() ai_prev_state;
.void() ai_next_state;
.void() ai_prev_move;
.void() ai_next_move;

void(void() move, float frames) ai_move_controller;
void(entity wep) ai_attack_basic;
void(entity wep) ai_attack_ene;
void(entity wep) ai_attack_bal;
void(entity wep) ai_attack_exp;

//move directives
void() ai_move_random;
void() ai_move_stand;
void() ai_move_walk_goal;
void() ai_move_walkmove_slide;
void() ai_move_walkmove_strafeleft;
void() ai_move_walkmove_straferight;
void() ai_move_run_goal;
void() ai_move_runmove_slideleft;
void() ai_move_runmove_slideright;
void() ai_move_forward;
void() ai_run_forward;
void() ai_move_backward;
void() ai_run_backward;
void() ai_move_charge;
void() ai_move_charge_left;
void() ai_move_charge_right;

//ai orders - these things sit atop all other ai directives
void() ai_order_attack;
void() ai_order_defend;
void() ai_order_test;

//subs are in-between states for orders
void() ai_find_patrol_node;
void() ai_goto_patrol_node;
void() ai_at_patrol_node;
void() ai_sweep_stand;
void() ai_hunt_target;
entity() ai_core_radar_sweep;

void() ai_sub_fight;

//state directives
void() ai_state_defend; //*-refactor
void() ai_state_ready; //*-refactor
void() ai_state_panic; //*-refactor

//utility functions
entity(entity node) ai_find_patrol_node_recurse;

void(void() nex_state, float cache_state) ai_update_state;
float(entity ai, entity goal) ai_core_trynode;
entity(entity node, float id) ai_query_graphnode;
entity(vector org, float start_dist) ai_core_findgraphnode;
float(entity targ) ai_target_infront;
float(entity targ) ai_target_insights;
float(entity targ) ai_target_visible;
entity(entity ai, entity goal) ai_core_nodetogoal; //find closest node to goal
entity() ai_core_findnode; // find the closest AI node
entity() ai_core_findtarget; //ai scans for a target
float() ai_core_foundtarget; //ai has found a target, update state accordingly
float() ai_core_targetstate; //checks to see if target ent is still a valid ent to be a target
entity() ai_core_opticaltarget;
entity() ai_core_radartarget;
float() ai_target_facingideal;
float() ai_core_panicnode;
float(vector chk, vector node) ai_core_nodelos;
void() ai_core_calcranges;

float() ai_pilot_rating_converg;
float() ai_pilot_rating_range;
float() ai_pilot_rating_leading;
float() ai_pilot_yaw_mod;
float() ai_pilot_armor_mod;
float() ai_pilot_rating_patience;

//TODO - separate header?
void() ai_mech_update;
void() ai_mech_attack;
void() ai_mech_die;
void() ai_mech_cleanup;
void() ai_mech_touch;
void() ai_turret_update;
void() ai_turret_touch;
void() ai_turret_die;