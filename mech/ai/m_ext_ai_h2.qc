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

.void() ai_prev_state;
.void() ai_next_state;
.float() ai_prev_move;
.float() ai_next_move;
.float ai_hasmoved;

void(float() move, float frames) ai_move_controller;
void(entity wep) ai_attack_basic;
void(entity wep) ai_attack_ene;
void(entity wep) ai_attack_bal;
void(entity wep) ai_attack_exp;

//move directives
void() ai_move_random;
float() ai_move_stand;
float() ai_move_walk_goal;
float() ai_move_run_goal;
float() ai_move_walkmove_strafeleft;
float() ai_move_walkmove_straferight;
float() ai_move_runmove_slideleft;
float() ai_move_runmove_slideright;
float() ai_move_forward;
float() ai_run_forward;
float() ai_move_backward;
float() ai_run_backward;
float() ai_move_charge_left;
float() ai_move_charge_right;

/*
  AI SPECIFIC ENT VARS======================
*/
//the code uses enemy/goalentity together as a buffer for where the 
//  AI will move to, node and trigger_field are the 'saved state'
//  for nodes and enemies respectively.
//.entity goalentity  //builtin, used by walkmove and movetogoal
//.entity enemy       //builtin, use by walkmove and movetogoal
//.entity trigger_field //builtin but - is the holder for the actual enemy
.entity node;         //the node that the ai wants to move to
.float ai_quirks;      //tracks the behavorial quirks of the ai
.float ai_type;
.float ai_style;
/*==========================================*/

/*
  AI STATE FUNCTIONS========================
*/
void(void() next_state) ai_state_control={
  if(next_state != self.ai_next_state){
     self.ai_prev_state = self.ai_next_state;
     self.ai_next_state = next_state;     
  }
};
//PATROL STATES
void() ai_patrol_startWithNode; 
void() ai_patrol_findNode;
void() ai_patrol_gotoNode;
void() ai_patrol_atNode;
//DEFEND STATES
void() ai_defend_startWithNode;
void() ai_defend_findNode;
void() ai_defend_gotoNode;
void() ai_defend_atNode;
//ASSAULT STATES
void() ai_assault_findNode;
void() ai_assault_gotoNode;
void() ai_assault_atNode;
//MISC STATES
void() ai_misc_unstuck;
void() ai_misc_stand;  
void() ai_misc_stand_debug;
//WANDER STATES
void() ai_wander_findNode;
void() ai_wander_gotoNode;
void() ai_wander_atNode;
//COMBAT STATES
void() ai_combat_findTarget;
void() ai_combat_huntTarget;
void() ai_combat_adjustPosition;
void() ai_combat_endFight;
//COMBAT SUB STATES 
void() ai_combat_adjustSniper;
void() ai_combat_adjustBrawler;
void() ai_combat_adjustSkirmish;
void() ai_combat_adjustFlanker;
/*==========================================*/

/*AI CORE FUNCTIONS=========================*/
entity() ai_core_findNode;
//NODE NOODLES
entity(entity pNode) ai_findNode_searchGroup;
//COMBAT
float(entity targ) ai_target_canSee;
float(entity targ) ai_target_inForwardArc;
float(entity t) ai_target_visualPing;
float(entity t) ai_target_radarPing;
float(entity t) ai_target_isValid;
float(entity t) ai_target_validType;
entity() ai_target_visualTarget;
entity() ai_target_radarTarget; 
void() ai_target_clearBuffers;
/*==========================================*/

//subs are in-between states for orders
void() ai_core_resetto_order;
void() ai_find_patrol_node;
void() ai_goto_patrol_node;
void() ai_at_patrol_node;
void() ai_sweep_stand;
void() ai_hunt_target;
entity() ai_core_radar_sweep;
void() ai_sub_fight;

//utility functions
entity(entity node) ai_find_patrol_node_recurse;
float() ai_core_noguns;

entity(entity node, float id) ai_query_graphnode;
entity(vector org, float start_dist) ai_core_findgraphnode;
float(entity targ) ai_target_infront;
float(entity targ) ai_target_insights;
float(entity targ) ai_target_visible;
float() ai_core_foundtarget; //ai has found a target, update state accordingly
float() ai_core_targetstate; //checks to see if target ent is still a valid ent to be a target
float() ai_target_facingideal;
void() ai_core_calcranges;
entity() ai_core_findfriendly;

entity() ai_core_opticaltarget;
entity() ai_core_radartarget;

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
void() ai_turret_control;
void() ai_turret_update;
void() ai_turret_touch;
void() ai_turret_die;