/*
mech mod
Author: Peter Roohr
Date: 10/21/2016
Overview: csqc handler
*/

float MSG_ENTITY = 5;
.float(entity ent, float changedflags) SendEntity;
.float SendFlags;

float(entity piece) csqc_updateCompStat;
entity() csqc_setHeader;
//float(entity to, float sendFlags) sendData;
float() sendData;
void() sendDataThink;

