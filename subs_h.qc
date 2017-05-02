/*
mech Mod
Date: 5/2/2017
Overview: simple header file for subs.qc
because headers are a good thing
*/

void() SUB_Null;
void() SUB_Remove;
void() SetMovedir;
void() InitTrigger;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void()  SUB_CalcMoveDone;
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void() SUB_CalcAngleMoveDone;
void() DelayThink ;
void() SUB_UseTargets ;
void(float normal) SUB_AttackFinished;
void (void() thinkst) SUB_CheckRefire;
