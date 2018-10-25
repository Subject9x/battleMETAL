/*
mech Mod
Author: Peter Roohr
Date: 8/30/2018
Overview: AI values that have been spun off from common/game
*/

//============================
//     AI STATS      
//============================
//AI movement speed ratio 
float AI_WALK_SPD = 0.025;
float AI_RUN_SPD = 0.035;

//PILOT RANKS - determines base states, and some realtime decisions
float AI_RANK_ACE = 0;
float AI_RANK_VET = 1;  //veteran
float AI_RANK_REG = 2;  //regular
float AI_RANK_ROK = 3;  //rookie

//
float AI_HUNT_NOV = 1;
float AI_HUNT_REG = 2;
float AI_HUNT_VET = 3;
float AI_HUNT_ELT = 4;

//DAMAGE DETUNING
float AI_DMG_SKILL_ROK = 0.2;
float AI_DMG_SKILL_REG = 0.3;
float AI_DMG_SKILL_VET = 0.4;
float AI_DMG_SKILL_ACE = 0.5;

float AI_DMG_ROK = 0.025;
float AI_DMG_REG = 0.05;
float AI_DMG_VET = 0.075;
float AI_DMG_ACE = 0.1;

//
float AI_ATTACK_ROK  =  0.2;
float AI_ATTACK_REG  =  0.3;
float AI_ATTACK_VET  =  0.4;
float AI_ATTACK_ACE  =  0.5;

//WEAPON TWEAKS
float AI_WEAPON_RPS_MOD = 1500;

//STATE VALUES
float AI_PATROL_DIST      = 100;  //how close to get to node before counting as 'close'
float AI_DEFEND_DIST_MIN  = 200;  //how close to get to a defense node before counting as close
float AI_DEFEND_DIST      = 3500;
float AI_ASSAULT_DIST_MIN = 400;
float AI_ASSAULT_DIST     = 1200;

//how well does the AI handle weapon convergence
float AI_CNV_ACE = 10;
float AI_CNV_VET = 15;
float AI_CNV_REG = 20;
float AI_CNV_ROK = 25;

//how does range affect the AI's accuracy
float AI_RNG_ACE = 1;
float AI_RNG_VET = 1.15;
float AI_RNG_REG = 1.25;
float AI_RNG_ROK = 1.5;

//Adjust Rotation Rate
//self.yaw_speed = rotation rate - (rotation rate * AI_ROT_X);
float AI_ROT_ACE = 0.1; //0.01
float AI_ROT_VET = 0.2; //0.05
float AI_ROT_REG = 0.3; //0.15
float AI_ROT_ROK = 0.4; //0.25

//armor based on difficulty
//hp = hp * AI_ARMOR
float AI_ARMOR_EASY =  0.3;
float AI_ARMOR_MEDM =  0.4;
float AI_ARMOR_HARD =  0.5;
float AI_ARMOR_NIGHT = 0.6;

//shield based on difficulty
//shield = shield * AI_SHIELD
float AI_SHIELD_EASY =  0.4;
float AI_SHIELD_MEDM =  0.6;
float AI_SHIELD_HARD =  0.8;
float AI_SHIELD_NIGHT = 1;

//ai_leading ratings, how well an ai tracks a slippery target
float AI_LEAD_ACE = 0.06;
float AI_LEAD_VET = 0.08;
float AI_LEAD_REG = 0.1;
float AI_LEAD_ROK = 0.12;

//ai's patience in hunting a target, the better the pilot the longer they hunting
float AI_PTNCE_ACE = 40;
float AI_PTNCE_VET = 30;
float AI_PTNCE_REG = 20;
float AI_PTNCE_ROK = 10;

//common engage ranges
float AI_RANGE_S = 1000;
float AI_RANGE_M = 2400;
float AI_RANGE_L = 4000;

//view check intervals
float AI_VIEW_ROK = 8;
float AI_VIEW_REG = 6;
float AI_VIEW_VET = 4;
float AI_VIEW_ACE = 2;

//view bracket
float AI_FOV_ROK = 0.2;
float AI_FOV_REG = 0.3;
float AI_FOV_VET = 0.4;
float AI_FOV_ACE = 0.5;

//action timer mod
float AI_REFLEX_ACE = 0.25;
float AI_REFLEX_VET = 0.2;
float AI_REFLEX_REG = 0.15;
float AI_REFLEX_ROK = 0.1;
