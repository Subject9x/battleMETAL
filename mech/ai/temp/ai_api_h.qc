/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI API Header, covers multiple impl files
*/
//CONSTANTS
float AI_SPAWNFLAG_CAMPAIGN     = 1;  //belongs in campaign mode
float AI_SPAWNFLAG_COOP         = 2;  //belongs in co-op mode
float AI_SPAWNFLAG_DM           = 4;  //belongs in DeathMatch
float AI_SPAWNFLAG_TDM          = 8;  //belongs in Team DeathMatch
float AI_SPAWNFLAG_COLDSTART    = 16; //on-spawn, bot will ignore friendly help calls
float AI_SPAWNFLAG_RANDDOMSTART = 32; //start on random node if AI has patrol path
float AI_SPAWNFLAG_HASRADAR     = 64; //radar is expensive to use, use sparingly
                                      //generally this is for mech units
float AI_SPAWNFLAG_SKILLUP      = 128;//promote AI by 1 rank depending on skill

float ST_STAND              = 1;  // stand around
float ST_STAND_SCAN         = 2;  // stationary, but check for targets
float ST_WALK               = 3;  // walk around
float ST_WALK_SCAN          = 4;  // walk but check for targets
float ST_RUN                = 5;  // run to target
float ST_RUN_STRAFE         = 6;  // run left or right
float ST_RUN_CHARGE         = 7;  // run at target, offset vector
float ST_ATTACK             = 8;  // stationary attack
float ST_ATTACK_WALK        = 9;  // attack while walking
float ST_ATTACK_WALK_STRAFE = 10; // attack while moving left / right
float ST_HUNT               = 11; // go to hunt node
float ST_HUNT_SCAN          = 12; // scan for new target
float ST_FIGHT_WALK         = 13; // during combat

//GLOBALS
float enemy_infront;
float enemy_range;
float enemy_yaw;
float enemy_vis;
entity AI_NODES[128];

//ENTITY VARS
.float ai_state;  //switch case
.float ai_time;   // flat time for all states

.void() th_attack;      //apparently th_missile returns a float, wtf
.float() th_check;       //each bot impl's their own attack check.
.void() th_action;        //th_ func to execute
.float ai_rank;
.float ai_action_time;  //for executing action states
.float ai_action_mod;
.float ai_rte_rng;
.float ai_rte_cnv;
.float ai_leading;      //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange;     //minimum range of guns;
.float ai_fov;      //the angle of the AI's view for visual target finding
.float ai_view;         //game unit range of vision within the angle
.float ai_radar;
.float patience;        //counter for if AI is stuck on something
.float maxpatience;     //how impatient is the AI
.vector ai_pitch;     //x = min, y= max, z = pitch speed
.float ai_wait;
.float ai_viewtime;
.float ai_viewcheck;    //interval for checking for enemies
.entity ai_hunt_node;  //simple node-on-decay-timer
.float ai_hunt_total; //current number of hunt nodes
.float ai_attack_chance;
.float ai_type;
.float ai_style;
.string target_die;
//Stat Equations
//AI STATISTICS - ai_stats.qc
float(float rank) ai_pilot_optical_range;
float(float rank, float range) ai_pilot_radar_range;
float(float rank) ai_pilot_view_interval;
float(float rank) ai_pilot_view_range;
float() ai_pilot_rating_converg;
float() ai_pilot_rating_range;
float() ai_pilot_rating_leading;
float() ai_pilot_yaw_mod;
float() ai_pilot_armor_mod;
float() ai_pilot_shield_mod;
float() ai_pilot_rating_patience;
float() ai_core_hitTimeCalc;
void() ai_pilot_mech_armor;
void() ai_pilot_vec_armor;
float(float rank) ai_pilot_action_mod;
float() ai_pilot_rank_byskill;
float(float rank) ai_pilot_attack_interval;
float( float rank ) ai_pilot_interval;

void() ai_unit_ini_var;
void(float rank) ai_pilot_ini_stats;

//AI Node
float AI_NODE_PATROL = 0;
float AI_NODE_DEFEND = 1;
float AI_NODE_ATTACK = 2;

void() ai_node_t_patrol;
void() ai_node_t_defend;
void() ai_node_t_attack;
entity(vector orig, string nodeid, float id, float fadetime, void() action) ai_node_hunt;
float(void() action) ai_hunt_dropnode;

//AI UTILS - 
float(float mode) ai_spawn_clean;
float() ai_find_target_visual;
float() ai_find_target_radar;
float(entity targ, float ang_limit) ai_target_infront;
float (entity targ) ai_visible;
vector(entity wep) ai_attack_trace;
void() ai_ranged_attack;
float(entity wep) ai_attack_blockcheck;
float() ai_check_forattack;
float() ai_check_allattack;
float(entity t) ai_valid_target;
vector(entity ai) ai_attack_calcSpread;
void() ai_wep_calcranges;
void(float dst, float grp, float bracket) ai_wep_group_track;
float(float movespeed, float distance, float ticrate) ai_move_time;
float( float yawspeed, float angmin, float angmax, float tim) ai_randyaw_time;
float(entity targ) ai_range;
float(entity wep) ai_attack_checkEne;

//AI CONTROL - ai_ctrl.qc 
void( float state ) ai_next_state;
void(void() next_action, float next_time, float time_mod) ai_action_next;
void() ai_hunt_target;
void() ai_make_attack;
void(float ifaction, float datatype ) ai_sfx_spotted;
void() ai_found_target;
void( string grpid ) ai_node_pick_rand
void(entity bot, entity attacker) ai_damage_react;
void(void() macro) ai_leg_frame;
void() ai_face_targ;

void(float dist) ai_forward;
void(float dist) ai_back;
void() ai_stand;
void(float dist) ai_walk;
void() ai_turn;
void(float dist) ai_run;
void() ai_run_slide;
void() ai_run_attack;
void() ai_charge_side;

//q1 legacy code ai_move_q1.qc
void(float dist) q1_ai_forward;
void(float dist) q1_ai_back;
void() q1_ai_stand;
void(float dist) q1_ai_walk;
void() q1_ai_turn;
void(float dist) q1_ai_run;
void() q1_ai_run_slide;
void() q1_ai_run_attack;

//test
void( float angl, float dist ) ai_move_forward;
void( float angl, float dist ) ai_move_backward;
void( float angl, float dist ) ai_move_left;
void( float angl, float dist ) ai_move_right;
void() ai_move_turn;