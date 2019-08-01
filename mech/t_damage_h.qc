/*
battleMETAL
Author: Peter Roohr
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

entity(vector point, float rad, entity own) t_find_part;
entity(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage;

float( entity targ, entity inflictor, float dmg_amt ) t_damage_bal;
float( entity targ, entity inflictor, float dmg_amt ) t_damage_ene;
float( entity targ, entity inflictor, float dmg_amt ) t_damage_mis;

void(entity targ, entity attacker, float dmg_type) killed;
//float(entity targ, float dmg_amt, float dmg_type, float arm_type) damage_armor;
//entity(entity parent, vector org, float start_rad) closestWeapon;