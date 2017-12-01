/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
      mod 3/16/2017
Overview: utility functions for mod, header
*/

//console logging
void(string msg, float val) cons_logAFloat;
void(string msg, vector v1) cons_logAVector;
void(string msg, string s1) cons_logAString;

void(string msg, float val, string split, float val2) cons_log2Float;
void(string msg, vector v1, string split, vector v2) cons_log2Vectors;
void(string msg, string s1, string split, string s2) cons_log2Strings;


float(float mod, float targ_val) util_zeroStat;
void(entity targ, entity src, vector ofs) util_setOffsetOrigin;
void(string mdl_name, float effects) util_setModel;
void(float dmgMode, float solid_type, float move_type) util_setCollider;
void(float hp, float max_hp, float arm_type, float arm_val) util_setHealthArmor;
void(vector bbx_min, vector bbx_max) util_setBoundBox;
float(vector p, vector min, vector max) util_checkInBounds;
float(entity trg) util_checkPointAngle;
void(float bits, float b, float bb, float bbb) util_subThreeBits;
entity(string part, entity unit) util_getPartFromName;

vector(entity own, float range) util_traceForPlayer;
vector(entity own, float range, float lead_factor) util_traceForAI;
vector(entity own, entity wep, vector prev_tracend, float spreadx, float spready) util_traceForOffset;

float(float t, float e) util_normalizeTimeAsPercent;
float(float v) anglemod;
float() crandom;