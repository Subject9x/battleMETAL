/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
Overview:
  TE_ message ID's, these are sent via SVC_TEMPENTITY
  and are read in client_main.CSQC_Parse_TempEntity()
  
*/

//Projectile Impact Events
#define IMPACT_SKY 0
#define IMPACT_DIRT 1
#define IMPACT_SHIELD 2
#define IMPACT_ARMOR 3

//CD commands stuff
#define MUSIC_ON     1
#define MUSIC_OFF    2
#define MUSIC_RESET  3
#define MUSIC_REMAP  4
#define MUSIC_CLOSE  5
#define MUSIC_PLAY   6
#define MUSIC_LOOP   7
#define MUSIC_STOP   8
#define MUSIC_PAUSE  9
#define MUSIC_RESUME 10
#define MUSIC_EJECT  11
#define MUSIC_INFO   12

//ALERT: 70-75 are reserved, otherwise go nuts?
//TE_ ID's
#define TE_CLIENT_INFO 80
#define TE_SERVERINFO 81
#define TE_CLIENT_INFO_DM 82
#define TE_PLAYER_CRIT 83
#define TE_UI_BOX 84

#define TE_FOG_SET 90
#define TE_ISMENU 91
#define TE_PARTICLE_CUBE 92
//93
//94;
//95;
//96;
//97;
//98;
#define TE_MSN_BOUND 99
//======================

//100;
//101;
//102;
//103;
//104;
//105;
#define TE_MISSION_END 106
//107;

//108;
//109;

#define TE_VFX_EXPLODE 110

#define TE_MSG_INFO 111
//112;
#define TE_REPAIRS_ON 113

//114;
//115;
#define TE_VFX_POINT 116
#define TE_VFX_RAIL 117