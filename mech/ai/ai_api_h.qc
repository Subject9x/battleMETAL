/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI API Header, covers multiple impl files
*/
//CONSTANTS
float AI_SPAWNFLAG_CAMPAIGN     = 1;    //belongs in campaign mode
float AI_SPAWNFLAG_COOP         = 2;    //belongs in co-op mode
float AI_SPAWNFLAG_DM           = 4;    //belongs in DeathMatch
float AI_SPAWNFLAG_TDM          = 8;    //belongs in Team DeathMatch
float AI_SPAWNFLAG_COLDSTART    = 16;   //on-spawn, bot will ignore friendly help calls
float AI_SPAWNFLAG_RANDDOMSTART = 32;   //start on random node if AI has patrol path
float AI_SPAWNFLAG_HASRADAR     = 64;   //radar is expensive to use, use sparingly
                                        //generally this is for mech units
float AI_SPAWNFLAG_SKILLUP      = 128;  //promote AI by 1 rank depending on skill
float AI_SPAWNFLAG_NONOV        = 256;  //remove from Novice Difficulty
float AI_SPAWNFLAG_NOREG        = 512;  //remove from Regular Difficulty
float AI_SPAWNFLAG_NOVET        = 1024; //remove from Veteran Difficulty
float AI_SPAWNFLAG_NOELT        = 2048; //remove from Elit Difficulty
float AI_SPAWNFLAG_NODROP       = 4096; //don't drop bot to the floor onspawn

//AI STATE CONSTANTS
float ST_STAND              = 1;  //th_stand
float ST_WALK               = 2;  //th_walk
float ST_FLYDIR             = 3;  //th_fly
float ST_RUN                = 4;  //th_run
float ST_RUN_STRAFE         = 5;  //th_run_strafe
float ST_RUN_CHARGE         = 6;  //th_run_charge
float ST_MISSILE            = 7;  //th_missile
float ST_MELEE              = 8;  //th_melee
float ST_MISSILE_STRAFE     = 9;  //th_missile_strafe
float ST_HUNT               = 10; //th_hunt
float ST_RADAR              = 11; //TODO, th_radar, - turn to face target even if LoS is lost
float ST_HUNT_START         = 12; //TODO
float ST_PAIN               = 13; //TODO - a fun holdover from Quake, this 'staggers' the target

//AI TURRET CONSTANTS
float TR_NORM               = 0;
float TR_TARG               = 1;
float TR_GOAL               = 3;

//VIS CONSTANTS
float VIS_FAIL = 0;
float VIS_FRAC = 1;
float VIS_TRG = 2;
float VIS_FRN = 3;

//GLOBALS
float enemy_infront;
float enemy_range;
float enemy_yaw;
float enemy_vis;
entity AI_NODES[128];

//ENTITY VARS
.float ai_time;   // flat time for all states
.void() th_fly;
.void() th_run_strafe;
.void() th_run_charge;
.void() th_missile_strafe;
.void() th_hunt;
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
.float ai_dir;

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
float( float rank, float skl, float damg) ai_pilot_mod_damage;

void() ai_unit_ini_var;
void(float rank) ai_pilot_ini_stats;

void() node_touch;
void() node_setup;
void() ai_node_t_defend;
void() ai_node_t_attack;
entity(vector orig, string nodeid, float id, float fadetime, void() action) ai_node_hunt;
float(void() action) ai_hunt_dropnode;

//AI UTILS - 
float(float mode) ai_spawn_clean;
float() ai_find_target_visual;
float() ai_find_target_radar;
entity( float radiius ) ai_find_friend;
vector(entity wep) ai_attack_trace;
void() ai_ranged_attack;
float(entity wep) ai_attack_blockcheck;
float(entity t) ai_valid_target;
vector(entity ai) ai_attack_calcSpread;
void() ai_wep_calcranges;
void(float dst, float grp, float bracket) ai_wep_group_track;
float(float movespeed, float distance, float ticrate) ai_move_time;
float( float yawspeed, float angmin, float angmax, float tim) ai_randyaw_time;
float(entity wep) ai_attack_checkEne;
void( entity ally, entity targ, float override ) ai_give_target;

//AI CONTROL - ai_ctrl.qc 
void( float state ) ai_next_state;
void(void() next_action, float next_time, float time_mod) ai_action_next;
void() ai_hunt_target;
void(float ifaction, float datatype ) ai_sfx_spotted;
void() ai_found_target;
void( string grpid ) ai_node_pick_rand
void(entity bot, entity attacker) ai_damage_react;
void(void() macro) ai_leg_frame;
void() ai_face_targ;

/*
  AI STATE FUNCTIONS=====================
*/
void( float estate ) ai_state_control;
void( float tstate) ai_turret_control;
void() ai_pilot_validate_states;  // assigns SUB_Null to any empty th_ states
void( float startState ) ai_initialize_system;

void( float estate ) ai_turret_set_state;

//generic state functions
//any and all can be replaced by an AI's own th_func standins
void() ai_generic_stand;
void() ai_generic_walk;
void() ai_generic_fly;
void() ai_generic_run;
void() ai_generic_run_strafe;
void() ai_generic_run_charge;
void() ai_generic_missile;
void() ai_generic_melee;
void() ai_generic_missile_strafe;
void() ai_generic_hunt;
void() ai_generic_pain;
//=======================================
/*
  AI ACTION SET==========================
  Headers
*/
float( float scan_mode) ai_check_scan;
void(float speed) ai_walkgoal;
void() ai_face_targ;
float(entity targ, float ang_limit) ai_check_face;
float(entity targ) ai_check_range;
float(entity targ) ai_check_vis;
float() ai_attack;
void() ai_move_turn;
float( float angmod, float dist) ai_move;
float( float dist ) ai_walk_back;
float( float dist ) ai_walk_left;
float( float dist ) ai_walk_right;
float( float dist ) ai_yaw_back;
float( float dist ) ai_yaw_left;
float( float dist ) ai_yaw_right;
float( float angmod, float dist ) ai_yaw_move;
float( float dist ) ai_fly_alt;
//========================================

//q1 legacy code ai_move_q1.qc
void(float dist) q1_ai_forward;
void(float dist) q1_ai_back;
void() q1_ai_stand;
void(float dist) q1_ai_walk;
void() q1_ai_turn;
void(float dist) q1_ai_run;
void() q1_ai_run_slide;
void() q1_ai_run_attack;
