/*
mech Mod
Author: Subject9x
Date: 11/18/2017
Overview: aaaaaand Subs.qc gets its own header too >.<
*/

void() SUB_Null;
void() SUB_Remove;
void() SetMovedir;
void() InitTrigger;
void() InitSolidBSPTrigger ;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void() SUB_CalcMoveDone;
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove ;
void() SUB_CalcAngleMoveDone;
void() DelayThink;
void() SUB_UseTargets;
void(float normal) SUB_AttackFinished;
float (entity targ) visible;
void (void() thinkst) SUB_CheckRefire;
vector (vector ang) SUB_NormalizeAngles;