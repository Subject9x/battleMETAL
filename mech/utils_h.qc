/*
mech Mod
Author: Subject9x
Date: 8/27/2016
      mod 3/16/2017
Overview: utility functions for mod, header
*/

void(float mod, float targ_val) util_zeroStat;
void(entity targ, entity src, vector ofs) util_setOffsetOrigin;
void(string mdl_name, float effects) util_setModel;
void(float dmgMode, float solid_type, float move_type) util_setCollider;
void(float hp, float max_hp, float arm_type, float arm_val) util_setHealthArmor;
void(vector bbx_min, vector bbx_max) util_setBoundBox;
float(vector p, vector min, vector max) util_checkInBounds;
float(entity trg) util_checkPointAngle;