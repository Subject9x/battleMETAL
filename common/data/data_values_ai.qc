/*
battleMETAL
Author: Peter Roohr
Date: 8/30/2018
Mod: 02/11/2019
Mod: 02/25/2019
Overview: AI values that have been spun off from common/game
*/

//============================
//     AI STATS      
//============================
//SPAWNFLAGS
float NO_CAMPAIGN = 1;    //remove from campaign mode
float NO_COOP = 2;    //remove from co-op mode
float NO_DM = 4;    //remove from DeathMatch
float NO_TDM = 8;    //remove from Team DeathMatch
float COLD_START = 16;   //on-spawn, bot will ignore friendly help calls
float HAS_RADAR = 64;   //radar is expensive to use, use sparingly
                                        //generally this is for mech units
float DEBUG_MODE = 128; //dont do anything

//warning! these are tied to engine-specific values, and for now, there's no changing it for now.
//this is a hold over from classic Quake, and I'm torn on whether I want this to be used EVERYWHERE in battleMETAL....
//or just using my own defines in NO_NOVICE, etc.
//if the decision is made to remove these from the engine, then hey, we get 4 spawnflag slots back.
//float NO_EASY = 256;
//float NO_NORMAL = 512;
//float NO_HARD = 1024;
//float NO_NIGHT = 2048;

float NO_NOVICE = 4096;  //remove from Novice Difficulty
float NO_REGULAR = 8192; //remove from Regular Difficulty
float NO_VETERAN = 16384; //remove from Veteran Difficulty
float NO_ELITE = 32768;  //remove from Elit Difficulty
//-------------------

float MISC_NO_DROP = 65536; //overloaded flag, this is for misc_* ents
float PROMOTE = 65536;  //AI rank is set by skill, this spawnflag bumps it up by 1
float DEMOTE = 131072;  //AI rank is set by skill, this spawnflag debuffs it up by 1
float TRIGGER_ME = 524288;  //ai only spawns when triggered
float MUTE_ME = 1048576;  //ai ignores sending voice effects / radio sounds.
float UNARMED = 2097152; //ai spawns with no weapons, skip build_weapons() factory step;

//============================
//     AI VOICE SYSTEM
//============================
float AI_VOICE_TIME = 32;

//this works to balance AI mech stats vs player mech stats.
float AI_ADJUST_ENERGY = 0.85;
float AI_ADJUST_SHIELD = 0.85;  //rate, this is applied to .shieldRate

//Armor Values
//hp = hp * AI_ARMOR
//AI mechs share initial stats with the player, so we have to detune them now.
float AI_ARMOR_MECH = 0.7;  //pre-release 0.5

//Shield Values
//shield = shield * AI_SHIELD
//AI mechs share initial stats with player, so we have to detune them now.
float AI_SHIELD_MECH = 0.8;  //applied to .shieldMax pre-release 0.67

//AI TH_REACT cooldown
float AI_REACT_ROK = 2;
float AI_REACT_REG = 1.5;
float AI_REACT_VET = 1;
float AI_REACT_ACE = 0.5;

//AI movement speed ratio - AI movement is every 0.01 game tic, so speeds need to be ratio'd down to that scale.
float AI_WALK_SPD = 0.09;
float AI_RUN_SPD = 0.19;
float AI_RUN_FACTOR = 1.25;
float AI_MECH_MOVE_FACTOR = 0.7; //mechs cannot move as fast as player
float AI_PATROL_SPEED_LIMIT = 100; //units going full speed on patrol so far is rough on game balance.

//Radar post
float AI_POST_SWEEP_SIZE = 6;
float AI_POST_SPOT_TIME = 18;

//lock on time modifiers for Radar Post
float AI_POST_LOCK_ROK = 1.25;
float AI_POST_LOCK_REG = 1;
float AI_POST_LOCK_VET = 0.75;
float AI_POST_LOCK_ACE = 0.5;

//PILOT RANKS - determines base states, and some realtime decisions
float AI_RANK_ACE = 3;
float AI_RANK_VET = 2;  //veteran
float AI_RANK_REG = 1;  //regular
float AI_RANK_ROK = 0;  //rookie

//DAMAGE DETUNING - Game Difficulty
float AI_DMG_SKILL_ROK = 0.8;
float AI_DMG_SKILL_REG = 0.85;
float AI_DMG_SKILL_VET = 0.9;
float AI_DMG_SKILL_ACE = 1;

//Field of View as normalized dot product
// 0.0 ~ 90d from center
//these are multipliers
float AI_FOV_ROK = 0.50;
float AI_FOV_REG = 0.35;
float AI_FOV_VET = 0.2;
float AI_FOV_ACE = 0;

//time interval between view sweeps
//these are multipliers
float AI_VIEW_ROK = 1;
float AI_VIEW_REG = 0.85;
float AI_VIEW_VET = 0.65;
float AI_VIEW_ACE = 0.45;

//View Ranges, multipliers against ai.radar_range
float AI_VIEW_RANGE_ROK = 0.7;
float AI_VIEW_RANGE_REG = 0.8;
float AI_VIEW_RANGE_VET = 0.9;
float AI_VIEW_RANGE_ACE = 1;

//Adjust yaw_speed
float AI_YAW_VET = 1.1;
float AI_YAW_ACE = 1.15;

//attack chances
float AI_ATTACK_ROK = 0.125;
float AI_ATTACK_REG = 0.1;
float AI_ATTACK_VET = 0.075;
float AI_ATTACK_ACE = 0.05;

//WEAPON TWEAKS - AI thinks are every 0.01 game tic, so weapon reload need to be ratio'd down to that scale.
float AI_WEAPON_RPS_MOD = 1500;

//Minimum convergence modifier
float AI_CNV_MIN_ROK  = 2;
float AI_CNV_MIN_REG  = 1.5;
float AI_CNV_MIN_VET  = 1;
float AI_CNV_MIN_ACE  = 0.5;

//Maximum convergence modifier
float AI_CNV_MAX_ROK  = 2.5;
float AI_CNV_MAX_REG  = 2;
float AI_CNV_MAX_VET  = 1.5;
float AI_CNV_MAX_ACE  = 1;

//Convergence Rate modifier
float AI_CNV_RATE_ROK  = 0.15;
float AI_CNV_RATE_REG  = 0.2;
float AI_CNV_RATE_VET  = 0.25;
float AI_CNV_RATE_ACE  = 0.3;

//ai_leading ratings, how well an ai tracks a slippery target
float AI_LEAD_ACE = 0.25;
float AI_LEAD_VET = 0.3;
float AI_LEAD_REG = 0.35;
float AI_LEAD_ROK = 0.4;

//common engage ranges
float AI_RANGE_S = 400;
float AI_RANGE_M = 1000;
float AI_RANGE_L = 1600;

//Patrol Node Check Range
float AI_NODE_DISTANCE = 67;

//Help call cooldowns
float AI_HELP_COOL_ROK = 11;
float AI_HELP_COOL_REG = 9;
float AI_HELP_COOL_VET = 7;
float AI_HELP_COOL_ACE = 5;

//COMBAT PAUSING
//  during firefights with targets, a 'pause' will make the AI  stand still for a bit and fire a little less frequently.
//  this is used to give the player more breathing room, otherwise bots will just bury the player in weapons fire.
//COMBAT PAUSE CHANCE
float AI_PAUSE_CHANCE_ROK = 0.5; //0.67
float AI_PAUSE_CHANCE_REG = 0.4;  //0.5
float AI_PAUSE_CHANCE_VET = 0.3; //0.35
float AI_PAUSE_CHANCE_ACE = 0.2;

//COMBAT PAUSE CHECK
float AI_PAUSE_TIME_ROK = 25;
float AI_PAUSE_TIME_REG = 20;
float AI_PAUSE_TIME_VET = 15;
float AI_PAUSE_TIME_ACE = 10;

//COMBAT PAUSE WAIT
float AI_PAUSE_WAIT_ROK = 5;  //7
float AI_PAUSE_WAIT_REG = 4;  //5
float AI_PAUSE_WAIT_VET = 2;  //3
float AI_PAUSE_WAIT_ACE = 1;
