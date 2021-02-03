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

//CD commands stuff
float MUSIC_ON      = 1;
float MUSIC_OFF     = 2;
float MUSIC_RESET   = 3;
float MUSIC_REMAP   = 4;
float MUSIC_CLOSE   = 5;
float MUSIC_PLAY    = 6;
float MUSIC_LOOP    = 7;
float MUSIC_STOP    = 8;
float MUSIC_PAUSE   = 9;
float MUSIC_RESUME  = 10;
float MUSIC_EJECT   = 11;
float MUSIC_INFO    = 12;

//ALERT: 70-75 are reserved, otherwise go nuts?
//TE_ ID's
float TE_CLIENT_INFO    = 80;
float TE_SERVERINFO     = 81;
float TE_CLIENT_INFO_DM = 82;
float TE_PLAYER_CRIT    = 83;
float TE_UI_BOX         = 84;

float TE_FOG_SET        = 90;
float TE_ISMENU         = 91;
//92;
//93
//94;
//95;
//96;
//97;
//98;
float TE_MSN_BOUND = 99;
//======================

//100;
//101;
//102;
//103;
//104;
//105;
float TE_MISSION_END = 106;
//107;

//108;
//109;

float TE_VFX_EXPLODE = 110;

float TE_MSG_INFO = 111;
//112;
float TE_REPAIRS_ON = 113;

//114;
//115;
float TE_VFX_POINT = 116;
float TE_VFX_RAIL = 117;