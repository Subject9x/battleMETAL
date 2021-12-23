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
#define NO_CAMPAIGN 1    //remove from campaign mode
#define NO_COOP 2    //remove from co-op mode
#define NO_DM 4    //remove from DeathMatch
#define NO_TDM 8    //remove from Team DeathMatch
#define COLD_START 16   //on-spawn, bot will ignore friendly help calls
#define HAS_RADAR 64   //radar is expensive to use, use sparingly
                                   //generally this is for mech units
#define DEBUG_MODE 128 //dont do anything

//warning! these are tied to engine-specific values, and for now, there's no changing it for now.
//this is a hold over from classic Quake, and I'm torn on whether I want this to be used EVERYWHERE in battleMETAL....
//or just using my own defines in NO_NOVICE, etc.
//if the decision is made to remove these from the engine, then hey, we get 4 spawnflag slots back.
//float NO_EASY = 256;
//float NO_NORMAL = 512;
//float NO_HARD = 1024;
//float NO_NIGHT = 2048;

#define NO_NOVICE 4096  //remove from Novice Difficulty
#define NO_REGULAR 8192 //remove from Regular Difficulty
#define NO_VETERAN 16384 //remove from Veteran Difficulty
#define NO_ELITE 32768  //remove from Elit Difficulty
//-------------------

#define MISC_NO_DROP 65536 //overloaded flag, this is for misc_* ents
#define PROMOTE 65536  //AI rank is set by skill, this spawnflag bumps it up by 1
#define DEMOTE 131072  //AI rank is set by skill, this spawnflag debuffs it up by 1
#define TRIGGER_ME 524288  //ai only spawns when triggered
//#define MUTE_ME 1048576  //ai ignores sending voice effects / radio sounds.
#define UNARMED 2097152 //ai spawns with no weapons, skip build_weapons() factory step;

//============================
//     AI VOICE SYSTEM
//============================
#define AI_VOICE_TIME 32

//this works to balance AI mech stats vs player mech stats.
#define AI_ADJUST_ENERGY 0.85
#define AI_ADJUST_SHIELD 0.85 //rate, this is applied to .shieldRate

//Armor Values
//hp = hp * AI_ARMOR
//AI mechs share initial stats with the player, so we have to detune them now.
#define AI_ARMOR_MECH 0.7  //pre-release 0.5

//Shield Values
//shield = shield * AI_SHIELD
//AI mechs share initial stats with player, so we have to detune them now.
#define AI_SHIELD_MECH 0.8  //applied to .shieldMax pre-release 0.67

//AI TH_REACT cooldown
#define AI_REACT_ROK 2
#define AI_REACT_REG 1.5
#define AI_REACT_VET 1
#define AI_REACT_ACE 0.5

//AI movement speed ratio - AI movement is every 0.01 game tic, so speeds need to be ratio'd down to that scale.
#define AI_WALK_SPD 0.09
#define AI_RUN_SPD 0.19
#define AI_RUN_FACTOR 1.25
#define AI_MECH_MOVE_FACTOR 0.7 //mechs cannot move as fast as player
#define AI_PATROL_SPEED_LIMIT 100 //units going full speed on patrol so far is rough on game balance.

//Radar post
#define AI_POST_SWEEP_SIZE 6
#define AI_POST_SPOT_TIME 18

//lock on time modifiers for Radar Post
#define AI_POST_LOCK_ROK 1.25
#define AI_POST_LOCK_REG 1
#define AI_POST_LOCK_VET 0.75
#define AI_POST_LOCK_ACE 0.5

//PILOT RANKS - determines base states, and some realtime decisions
#define AI_RANK_ACE 3
#define AI_RANK_VET 2  //veteran
#define AI_RANK_REG 1  //regular
#define AI_RANK_ROK 0  //rookie

//DAMAGE DETUNING - Game Difficulty
#define AI_DMG_SKILL_ROK 0.8
#define AI_DMG_SKILL_REG 0.85
#define AI_DMG_SKILL_VET 0.9
#define AI_DMG_SKILL_ACE 1

//Field of View as normalized dot product
// 0.0 ~ 90d from center
//these are multipliers
#define AI_FOV_ROK 0.50
#define AI_FOV_REG 0.35
#define AI_FOV_VET 0.2
#define AI_FOV_ACE 0

//time interval between view sweeps
//these are multipliers
#define AI_VIEW_ROK 1
#define AI_VIEW_REG 0.85
#define AI_VIEW_VET 0.65
#define AI_VIEW_ACE 0.45

//View Ranges, multipliers against ai.radar_range
#define AI_VIEW_RANGE_ROK 0.7
#define AI_VIEW_RANGE_REG 0.8
#define AI_VIEW_RANGE_VET 0.9
#define AI_VIEW_RANGE_ACE 1

//Adjust yaw_speed
#define AI_YAW_VET 1.1
#define AI_YAW_ACE 1.15

//attack chances
#define AI_ATTACK_ROK 0.125
#define AI_ATTACK_REG 0.1
#define AI_ATTACK_VET 0.075
#define AI_ATTACK_ACE 0.05

//WEAPON TWEAKS - AI thinks are every 0.01 game tic, so weapon reload need to be ratio'd down to that scale.
#define AI_WEAPON_RPS_MOD 1500

//Minimum convergence modifier
#define AI_CNV_MIN_ROK 2
#define AI_CNV_MIN_REG 1.5
#define AI_CNV_MIN_VET 1
#define AI_CNV_MIN_ACE 0.5

//Maximum convergence modifier
#define AI_CNV_MAX_ROK 2.5
#define AI_CNV_MAX_REG 2
#define AI_CNV_MAX_VET 1.5
#define AI_CNV_MAX_ACE 1

//Convergence Rate modifier
#define AI_CNV_RATE_ROK 0.15
#define AI_CNV_RATE_REG 0.2
#define AI_CNV_RATE_VET 0.25
#define AI_CNV_RATE_ACE 0.3

//ai_leading ratings, how well an ai tracks a slippery target
#define AI_LEAD_ACE 0.25
#define AI_LEAD_VET 0.3
#define AI_LEAD_REG 0.35
#define AI_LEAD_ROK 0.4

//common engage ranges
#define AI_RANGE_S 400
#define AI_RANGE_M 1000
#define AI_RANGE_L 1600

//Patrol Node Check Range
#define AI_NODE_DISTANCE 67

//Help call cooldowns
#define AI_HELP_COOL_ROK 11
#define AI_HELP_COOL_REG 9
#define AI_HELP_COOL_VET 7
#define AI_HELP_COOL_ACE 5

//COMBAT PAUSING
//  during firefights with targets, a 'pause' will make the AI  stand still for a bit and fire a little less frequently.
//  this is used to give the player more breathing room, otherwise bots will just bury the player in weapons fire.
//COMBAT PAUSE CHANCE
#define AI_PAUSE_CHANCE_ROK 0.5
#define AI_PAUSE_CHANCE_REG 0.4
#define AI_PAUSE_CHANCE_VET 0.3
#define AI_PAUSE_CHANCE_ACE 0.2

//COMBAT PAUSE CHECK
#define AI_PAUSE_TIME_ROK 25
#define AI_PAUSE_TIME_REG 20
#define AI_PAUSE_TIME_VET 15
#define AI_PAUSE_TIME_ACE 10

//COMBAT PAUSE WAIT
#define AI_PAUSE_WAIT_ROK 5
#define AI_PAUSE_WAIT_REG 4
#define AI_PAUSE_WAIT_VET 2
#define AI_PAUSE_WAIT_ACE 1
