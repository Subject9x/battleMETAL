/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI API Header, covers multiple impl files
*/

//will it blend?
#define macro_ai_frame(next_func) if((self.flags&FL_TURRET)){ai_turret_control();}if(self.legs){ai_leg_control();} self.think=next_func; self.nextthink=time+0.05;
#define macro_ai_update(update_func) update_func(); if(!(self.spawnflags&AI_SPAWNFLAG_DEBUG)){if(!self.deadflag){ai_update();}}
#define macro_ai_frame_count(repeat_frame) if( self.ai_action_time > 0 ){self.ai_action_time = self.ai_action_time - 1;macro_ai_frame(repeat_frame) return;}
#define macro_ai_frame_hunt(hunt_func) if(!self.ai_node_recall){ai_sfx_huntStart();node_recall_setup();self.goalentity=self.enemy;macro_ai_frame(hunt_func) return;} self.goalentity=self.ai_node_recall;macro_ai_frame(hunt_func) return;

//CONSTANTS
float AI_SPAWNFLAG_CAMPAIGN     = 1;    //remove from campaign mode
float AI_SPAWNFLAG_COOP         = 2;    //remove from co-op mode
float AI_SPAWNFLAG_DM           = 4;    //remove from DeathMatch
float AI_SPAWNFLAG_TDM          = 8;    //remove from Team DeathMatch
float AI_SPAWNFLAG_COLDSTART    = 16;   //on-spawn, bot will ignore friendly help calls
float AI_SPAWNFLAG_RANDDOMSTART = 32;   //start on random node if AI has patrol path
float AI_SPAWNFLAG_HASRADAR     = 64;   //radar is expensive to use, use sparingly
                                        //generally this is for mech units
                                        
float AI_SPAWNFLAG_PROMOTE      = 128;  //AI rank is set by skill, this spawnflag bumps it up by 1
float AI_SPAWNFLAG_DEMOTE       = 256;  //AI rank is set by skill, this spawnflag debuffs it up by 1
float AI_SPAWNFLAG_NONOV        = 512;  //remove from Novice Difficulty
float AI_SPAWNFLAG_NOREG        = 1024;  //remove from Regular Difficulty
float AI_SPAWNFLAG_NOVET        = 2048; //remove from Veteran Difficulty
float AI_SPAWNFLAG_NOELT        = 4096; //remove from Elit Difficulty
float AI_SPAWNFLAG_NODROP       = 8192; //don't drop bot to the floor onspawn

float AI_SPAWNFLAG_TRIGGERME    = 16384; //ai only spawns when triggered
float AI_SPAWNFLAG_DEBUG        = 32768;  //dont do anything

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
float TR_NORM               = 0;  //Turret follows the angles of its parent
float TR_TARG               = 1;  //Turret ideal yaw is the parent's .enemy
float TR_GOAL               = 3;  //Turret ideal yaw = parent's .goalentity
float TR_YAW                = 4;  //Turret ideal yaw set by outside source

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
float enemy_hunt;
entity AI_NODES[128];

//ENTITY VARS
.float ai_rank;
.float ai_action_time;  //for executing action states
.float ai_action_mod;   //how many times to repeat a frameset before adjusting
.float ai_leading;      //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange;     //minimum range of guns;
.float ai_fov;          //the angle of the AI's view for visual target finding
.float ai_view;         //range in game units of AI's vision
.vector ai_pitch;       //x = min, y= max, z = pitch speed
.float ai_viewtime;
.float ai_viewcheck;    //interval for checking for enemies
.float ai_hunt_total;   //current number of hunt nodes
.float ai_attack_chance;
.float ai_dir;          //chassis facing vs .angles
.entity ai_node_recall;

.float voiceTime; //when next to say something
.string ai_voice_warn;
.string ai_voice_spot;
.string ai_voice_huntStart;
.string ai_voice_huntEnd;
.string ai_voice_dying;
.string ai_voice_dead;
.string ai_voice_kill;
.string ai_voice_roger;
.string ai_voice_help;

//Stat Equations
//AI STATISTICS - ai_stats.qc
void() ai_promote;
float(float rank) ai_pilot_field_of_view;
float(float rank) ai_pilot_view_interval;
float(float rank) ai_pilot_view_range;
float() ai_pilot_rating_leading;
float() ai_pilot_yaw_mod;
float() ai_turret_yaw_mod;
float() ai_pilot_armor_mod;
float() ai_pilot_shield_mod;
void() ai_pilot_mech_armor;
void() ai_pilot_vec_armor;
float(float rank) ai_pilot_action_mod;
float(float rank) ai_pilot_attack_interval;
float( float rank, float damg) ai_pilot_mod_damage;
vector( float rank, vector spread ) ai_pilot_accuracy;
float( float rank, float lockOn ) ai_pilot_lock_time;
void() ai_unit_ini_var;
void(float rank) ai_pilot_ini_stats;

//AI NODES
void() node_setup;
void() node_touch;
void() node_patrol_touch;
void() node_defend_touch;
void() node_attack_touch;
void() node_recall_touch;
entity() node_recall_setup;

//AI UTILS - 
float() ai_can_spawn;
float() ai_find_target_visual;
float() ai_find_target_radar;
entity( float radiius ) ai_find_friend;
vector(entity wep) ai_attack_trace;
void() ai_ranged_attack;
float(entity wep) ai_attack_blockcheck;
float(entity t) ai_valid_target;
void() ai_wep_calcranges;
void(float dst, float grp, float bracket) ai_wep_group_track;
float(entity wep) ai_attack_checkEne;
void( entity ally, entity targ, float override ) ai_give_target;
float( float bestAccuracy ) ai_wait_for_shot;
void() ai_lock_on;
float( entity t ) ai_line_of_sight;
void( entity t) ai_call_for_help;

//AI MAP FUNCS
float( void() ai_to_make ) ai_unit_setup;
void() ai_unit_make_multi;
void() ai_unit_make_trigger;
void( float wep1, float wep2, float wep3, float wep4, float wep5, float wep6, float wep7, float wep8, float wep9) ai_ini_weapons;

//AI CONTROL - ai_ctrl.qc 
void() ai_touch;
void() ai_setup_patrol;
entity() ai_node_pick_rand
float(entity bot, entity attacker) ai_damage_react;

//AI VOICE STUFF
void() ai_sfx_spotted;
void() ai_sfx_warning;
void() ai_sfx_huntStart;
void() ai_sfx_huntEnd;
void() ai_sfx_dying;
void() ai_sfx_dead;
void() ai_sfx_kill;
void() ai_sfx_roger;
void() ai_sfx_help;

/*
  AI STATE FUNCTIONS=====================
*/
void() ai_update;
void() ai_turret_control;
void() ai_leg_control;
void( float estate ) ai_turret_set_state;

/*
  AI ACTION SET==========================
  Headers
*/
float( float scan_mode) ai_check_scan;
void(float speed) ai_walkgoal;
void() ai_face_targ;
float(entity targ, float ang_limit) ai_check_face;
float(entity t, float ang, float useTurret) ai_check_targ_infront;
float(entity targ) ai_check_range;
float(entity targ) ai_check_vis;
float() ai_attack;
void() ai_move_turn;
float( float angmod, float dist) ai_move;
float( float angmod, float dist ) ai_yaw_move;
void( float alt_low, float alt_max ) ai_fly_update;
void( float move ) ai_update_accuracy;
//========================================