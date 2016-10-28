/*
mech mod
Author: Subject9x
Date: 10/21/2016
Overview: csqc handler
*/

.float(entity to, float sendflags) SendEntity;
.float SendFlags;
float MSG_ENTITY = 5;
.float SENDDATA;

.float csqc_entType;
.float csqc_datType;
.float csqc_flgType;

entity() csqc_setHeader;
void(entity to, float sendFlags) send_DataTE;
void(entity to, float entType, float flagType) csqc_SendMechData;
//float(entity to, float sendFlags) sendData;
float() sendData;
void() sendDataThink;

