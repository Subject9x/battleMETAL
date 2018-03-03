/*
mech Mod
Author: Peter Roohr
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

entity(vector point, float rad, entity own) t_find_part;
entity(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage;
void(entity targ, entity attacker, float dmg_type) killed;
void(entity targ, entity attacker, float dmg_type) filter_killed;
float(entity targ, float dmg_amt, float dmg_type) damage_shield;
float(entity targ, float dmg_amt, float dmg_type) shield_vs_bal;
float(entity targ, float dmg_amt, float dmg_type) shield_vs_ene;
float(entity targ, float dmg_amt, float dmg_type) shield_vs_mis;
float(entity targ, float dmg_amt, float dmg_type, float arm_type) damage_armor;
entity(entity parent, vector org, float start_rad) closestWeapon;
void(entity atk) anger_monster;