/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI API Header, covers multiple impl files
*/
//CONSTANTS
float AI_SPAWNFLAG_CAMPAIGN = 1;
float AI_SPAWNFLAG_COOP = 2;
float AI_SPAWNFLAG_DM = 4;
float AI_SPAWNFLAG_TDM = 8;
float AI_SPAWNFLAG_COLDSTART = 16; //on-spawn, bot will ignore friendly help calls

//GLOBALS
float enemy_infront;
float enemy_range;
float enemy_yaw;
float enemy_vis;

//ENTITY VARS
.void() ai_action;        //th_ func to execute
.float ai_action_time;  //for executing action states
.float ai_rte_rng;
.float ai_rte_cnv;
.float ai_leading;      //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange;     //minimum range of guns;
.float ai_fov;      //the angle of the AI's view for visual target finding
.float ai_view;         //game unit range of vision within the angle
.float ai_radar;
.float patience;        //counter for if AI is stuck on something
.float maxpatience;     //how impatient is the AI

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
float() ai_core_attackInterval;
void() ai_pilot_mech_armor;
void() ai_pilot_vec_armor;

void() ai_unit_ini_var;
void(float rank) ai_pilot_ini_stats;

//AI UTILS - 
float(float mode) ai_spawn_clean;
entity() ai_find_target_visual;
entity() ai_find_target_radar;
float(entity targ, float ang_limit) ai_target_infront;
float (entity targ) ai_visible;
vector() ai_attack_trace;
void() ai_ranged_attack;
float(entity wep) ai_attack_blockcheck;

//AI CONTROL - ai_ctrl.qc 
void() ai_hunt_target;
void(float ifaction, float datatype ) ai_sfx_spotted;
void() ai_found_target;

void(float dist) ai_forward;
void(float dist) ai_back;
void() ai_stand;
void(float dist) ai_walk;
void() ai_turn;
void(float dist) ai_run;
void() ai_run_slide;
void() ai_run_attack;

//q1 legacy code ai_move_q1.qc
void(float dist) q1_ai_forward;
void(float dist) q1_ai_back;
void() q1_ai_stand;
void(float dist) q1_ai_walk;
void() q1_ai_turn;
void(float dist) q1_ai_run;
void() q1_ai_run_slide;
void() q1_ai_run_attack;

//Unit functions
void() ai_dest_walk;
void() ai_dest_run;
void() ai_dest_turn;
void() ai_dest_attack;
void() ai_dest_stand;