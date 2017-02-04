/*
mech Mod
Date: 2/4/2017
Overview: just teasing out fight.qc's func definitons to its own header file
*/

float(float v) anglemod;

void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;

void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;

float()	DemonCheckAttack;
void(float side)	Demon_Melee;

void(vector dest) ChooseTurn;

void() ai_face;


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;

float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;