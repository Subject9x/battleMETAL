/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
      mod 3/16/2017
Overview: utility functions for mod, header
*/

//console logging==========================================================
void(string msg, float val) cons_logAFloat;
void(string msg, vector v1) cons_logAVector;
void(string msg, string s1) cons_logAString;

void(string msg, float val, string split, float val2) cons_log2Float;
void(string msg, vector v1, string split, vector v2) cons_log2Vectors;
void(string msg, string s1, string split, string s2) cons_log2Strings;
//=========================================================================

vector(vector facing, vector centerpoint, vector sz_max) util_findOpenSpawnArea;

float(entity t) util_getMechHpAverage;
float(entity t) util_getMechHpTotal;

float( float yee, float targAng, float buffer ) util_checkAngNotIdeal;

float(float mod, float targ_val) util_zeroStat;
void(entity targ, entity src, vector ofs) util_setOffsetOrigin;
void(string mdl_name, float skinNum, float ef_flags) util_setModel;
void(float dmgMode, float solid_type, float move_type) util_setCollider;
void(float hp, float max_hp, float arm_type, float arm_val) util_setHealthArmor;
float(vector p, vector min, vector max) util_checkInBounds;
float(entity trg) util_checkPointAngle;
float(vector orig) util_checkPointAngleImpl;
float(vector org) util_lockOnChoke;
void(entity ent, vector pnt) util_chekPointToHitDir;

void(float bits, float b, float bb, float bbb) util_subThreeBits;
entity(float part, entity unit) util_getPartFromName;

float(float numOfSides) util_roll_dice;

vector(entity own, float range) util_traceForPlayer;
vector( vector startOrigin, vector viewAngle, float wepRange, entity parent) util_traceForAI;
vector( vector prevTraceEnd, vector viewAngle, float targetDist, float idealRange, float spreadx, float spready) util_applySpreadToTrace;
vector( vector start, vector offsets, vector viewAngle) util_getOffsetOfVector;

float(float t, float e) util_normalizeTimeAsPercent;
float(float v) anglemod;
float() crandom;

float(entity t, float tolerance) util_cornerSlopeCheck;
void(entity t) util_generateBuildingFoundation;

vector(vector rgb) util_rgbToFloat;

vector(vector angl, vector org, float zAdjust) util_dropToGround;