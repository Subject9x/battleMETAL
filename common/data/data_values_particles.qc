/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
Overview:
  TE_ message ID's, these are sent via SVC_TEMPENTITY
  and are read in client_main.CSQC_Parse_TempEntity()
  
*/

//Projectile Impact Events
float IMPACT_SKY = 0;
float IMPACT_DIRT = 1;
float IMPACT_SHIELD = 2;
float IMPACT_ARMOR = 3;

//ALERT: 70-75 are reserved, otherwise go nuts?
//TE_ ID's
float TE_CLIENT_INFO = 80;
float TE_SERVERINFO =  81;
float TE_CLIENT_INFO_DM = 82;
//83;
float TE_UI_BOX = 84;

//90;
//91;
//92;
//93
//94;
//95;
//96;
//97;
//98;
float TE_MSN_BOUND = 99;
//======================

float TE_AI_VOICE = 100;
//101;
//102;
//103;
//104;
//105;
float TE_MISSION_END = 106;
//107;

float TE_MUZZLE_FLASH = 108;
//109;

float TE_VFX_EXPLODE = 110;

float TE_MSG_INFO = 111;
//112;
float TE_REPAIRS_ON = 113;

//114;
//115;
float TE_VFX_POINT = 116;
float TE_VFX_RAIL = 117;