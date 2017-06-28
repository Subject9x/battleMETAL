/*
mech mod
Author: Subject9x
Date: 10/21/2016
Overview: csqc handler
*/

float MSG_ENTITY = 5;
.float(entity ent, float changedflags) SendEntity;
.float SendFlags;
void(float buf, float fl) WriteFloat = #280;

float(entity piece) csqc_updateCompStat;
entity() csqc_setHeader;
void(entity to, float entType, float flagType) csqc_SendMechData;
//float(entity to, float sendFlags) sendData;
float() sendData;
void() sendDataThink;

