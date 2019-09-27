/*
battleMETAL
Author: Peter Roohr
Date: 8/30/2018
Mod: 02/11/2019
Overview: AI values that have been spun off from common/game
*/

//============================
//     AI STATS      
//============================
//AI TH_REACT cooldown
float AI_REACT_ROK = 3;
float AI_REACT_REG = 2;
float AI_REACT_VET = 1;
float AI_REACT_ACE = 0.5;

//AI movement speed ratio 
float AI_WALK_SPD = 0.075;
float AI_RUN_FACTOR = 1.25;
float AI_MECH_MOVE_FACTOR = 0.75; //mechs cannot move as fast as player
float AI_RUN_SPD = 0.2;

//Radar post
float AI_POST_SWEEP_SIZE = 6;
float AI_POST_SPOT_TIME = 24;
//lock on time modifiers for Radar Post
float AI_POST_LOCK_ROK = 2;
float AI_POST_LOCK_REG = 1;
float AI_POST_LOCK_VET = 0.75;
float AI_POST_LOCK_ACE = 0.5;

//PILOT RANKS - determines base states, and some realtime decisions
float AI_RANK_ACE = 3;
float AI_RANK_VET = 2;  //veteran
float AI_RANK_REG = 1;  //regular
float AI_RANK_ROK = 0;  //rookie

//DAMAGE DETUNING - Game Difficulty
float AI_DMG_SKILL_ROK = 0.1;
float AI_DMG_SKILL_REG = 0.2;
float AI_DMG_SKILL_VET = 0.3;
float AI_DMG_SKILL_ACE = 0.4;

//DAMAGE DETUNING - Specific AI stats
float AI_DMG_ROK = 0.025;
float AI_DMG_REG = 0.05;
float AI_DMG_VET = 0.075;
float AI_DMG_ACE = 0.1;

//Field of View as normalized dot product
float AI_FOV     = 0.5;
//these are multipliers
float AI_FOV_ROK = 0.75;
float AI_FOV_REG = 1.25;
float AI_FOV_VET = 1.5;
float AI_FOV_ACE = 1.75;

//time interval between view sweeps
float AI_VIEW_INTERVAL = 2;
//these are multipliers
float AI_VIEW_ROK = 1.33;
float AI_VIEW_REG = 1;
float AI_VIEW_VET = 0.67;
float AI_VIEW_ACE = 0.33;

//View Ranges, multipliers against ai.radar_range
float AI_VIEW_RANGE_ROK = 0.85;
float AI_VIEW_RANGE_REG = 1;
float AI_VIEW_RANGE_VET = 1.25;
float AI_VIEW_RANGE_ACE = 1.5;

//Adjust yaw_speed
float AI_YAW_ROK = 0.67;
float AI_YAW_REG = 0.75;
float AI_YAW_VET = 0.9;
float AI_YAW_ACE = 1.1;

//attack chances
float AI_ATTACK_ROK = 0.50;
float AI_ATTACK_REG = 0.35;
float AI_ATTACK_VET = 0.30;
float AI_ATTACK_ACE = 0.20;

//WEAPON TWEAKS
float AI_WEAPON_RPS_MOD = 1500;

//Minimum convergence modifier
float AI_CNV_MIN_ROK  = 3.5;
float AI_CNV_MIN_REG  = 3;
float AI_CNV_MIN_VET  = 2.5;
float AI_CNV_MIN_ACE  = 2;

//Maximum convergence modifier
float AI_CNV_MAX_ROK  = 7;
float AI_CNV_MAX_REG  = 6;
float AI_CNV_MAX_VET  = 5;
float AI_CNV_MAX_ACE  = 4;

//Convergence Rate modifier
float AI_CNV_RATE_ROK  = 0.05;
float AI_CNV_RATE_REG  = 0.1;
float AI_CNV_RATE_VET  = 0.15;
float AI_CNV_RATE_ACE  = 0.2;

//armor based on difficulty
//hp = hp * AI_ARMOR
float AI_ARMOR_EASY =  0.5;
float AI_ARMOR_MEDM =  1;
float AI_ARMOR_HARD =  1.25;
float AI_ARMOR_NIGHT = 1.35;

float AI_ARMOR_MECH_EASY = 0.3;
float AI_ARMOR_MECH_MEDM = 0.4;
float AI_ARMOR_MECH_HARD = 0.5;
float AI_ARMOR_MECH_NIGHT = 0.6;

//shield based on difficulty
//shield = shield * AI_SHIELD
float AI_SHIELD_ROK = 0.2;
float AI_SHIELD_REG = 0.4;
float AI_SHIELD_VET = 0.6;
float AI_SHIELD_ACE = 0.8;

//ai_leading ratings, how well an ai tracks a slippery target
float AI_LEAD_ACE = 0.15;
float AI_LEAD_VET = 0.25;
float AI_LEAD_REG = 0.35;
float AI_LEAD_ROK = 0.45;

//common engage ranges
float AI_RANGE_S = 400;
float AI_RANGE_M = 1000;
float AI_RANGE_L = 1600;

//Frameset counter, how many loops of a frame set
float AI_REFLEX_ACE = 3;
float AI_REFLEX_VET = 4;
float AI_REFLEX_REG = 5;
float AI_REFLEX_ROK = 6;
