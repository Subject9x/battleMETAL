/*
mech Mod
Author: Peter Roohr
Date: 3/16/2017
overview: the defs file for damage calculation numbers
primarily used by t_damage stuff.
*/

//Shield cooldown time
float SHIELD_RECHARGE_COOLDOWN = 8;

//shield vs effect by damage type
float SHVBAL_EFFPRC_PERCENTAGE = 5;
float SHVBAL_EFFRAM_PERCENTAGE = 1.5;
float SHVBAL_EFFNON_PERCENTAGE = 1.15;
float SHVBAL_EFFNON_REDUCE = 0.75;

float SHVENE_EFFPRC_PERCENTAGE = 10;
float SHVENE_EFFRAM_PERCENTAGE = 1.75;

float SHVEXP_EFFPRC_PERCENTAGE = 7;
float SHVEXP_EFFSTX_PERCENTAGE = 1.25;
float SHVEXP_EFFRAM_PERCENTAGE = 1.25;
float SHVEXP_EFFNON_PERCENTAGE = 1.25;
float SHVEXP_EFFNON_REDUCE = 10;

//Armor soak percentages
float ARM_LT_MOD = 0.05; //light
float ARM_MD_MOD = 0.1;   //medium
float ARM_HV_MOD = 0.15;  //heavy

float ARM_RAD_MOD = 0.05; //radiation armor
float ARM_CER_MOD = 0.1;  //ceramic armor
float ARM_ANG_MOD = 0.15; //angled armor