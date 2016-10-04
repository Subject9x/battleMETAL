/*
mech Mod
Author: Subject9x
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/
entity(vector point, float rad, entity src, entity own) t_find_recurse;
void(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage;
void(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_filter;
entity(entity targ, entity inflictor, entity attacker, vector dmg_point) damage_mech;
void(entity targ, entity attacker, float dmg_type) killed;
void(entity targ, entity attacker, float dmg_type) filter_killed;


