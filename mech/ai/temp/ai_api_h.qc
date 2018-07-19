/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI API Header, covers multiple impl files
*/
//CONSTANTS
float AI_SPAWNFLAG_CAMPAIGN = 1;  //belongs in campaign mode
float AI_SPAWNFLAG_COOP = 2;      //belongs in co-op mode
float AI_SPAWNFLAG_DM = 4;        //belongs in DeathMatch
float AI_SPAWNFLAG_TDM = 8;       //belongs in Team DeathMatch
float AI_SPAWNFLAG_COLDSTART = 16; //on-spawn, bot will ignore friendly help calls
float AI_SPAWNFLAG_RANDDOMSTART = 32; //start on random node if AI has patrol path
float AI_SPAWNFLAG_HASRADAR = 64;   //radar is expensive to use, use sparingly
                                    //generally this is for mech units
//GLOBALS
float enemy_infront;
float enemy_range;
float enemy_yaw;
float enemy_vis;
string AI_NODES[128];

//ENTITY VARS
.void() th_attack;      //apparently th_missile returns a float, wtf
.void() th_action;        //th_ func to execute
.float ai_fight;
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
float(float rank) ai_pilot_action_mod;

void() ai_unit_ini_var;
void(float rank) ai_pilot_ini_stats;

//AI Node
float AI_NODE_PATROL = 0;
float AI_NODE_DEFEND = 1;
float AI_NODE_ATTACK = 2;

void() ai_node_t_patrol;
void() ai_node_t_defend;
void() ai_node_t_attack;

//AI UTILS - 
float(float mode) ai_spawn_clean;
float() ai_find_target_visual;
entity() ai_find_target_radar;
float(entity targ, float ang_limit) ai_target_infront;
float (entity targ) ai_visible;
vector(entity wep) ai_attack_trace;
void() ai_ranged_attack;
float(entity wep) ai_attack_blockcheck;
float(entity t) ai_valid_target;
vector(entity ai) ai_attack_calcSpread;

//AI CONTROL - ai_ctrl.qc 
void(void() next_action, float next_time, float time_mod) ai_action_next;
void() ai_hunt_target;
void(float ifaction, float datatype ) ai_sfx_spotted;
void() ai_found_target;
string( string grpid ) ai_node_pick_rand;

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
