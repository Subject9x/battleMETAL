/*
mech Mod
Author: Subject9x
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

entity(vector point, float rad, entity own) t_find_part;
void(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage;
void(entity targ, entity attacker, float dmg_type) killed;
void(entity targ, entity attacker, float dmg_type) filter_killed;
float(entity targ, entity attacker, float dmg, float dmg_type) damage_shield;

//kept for posterity, see the impl file for detials
//entity(vector point, float rad, entity src, entity own, entity prev) t_find_recurse;
//entity(entity targ, entity inflictor, entity attacker, vector dmg_point) damage_mech;


