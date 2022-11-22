/*
battleMETAL
Author: Peter Roohr
Date: 04/14/2018
Overview: Made the csqc color constants defs into a /common/ file
so that these defs can be shared / expanded by menu.dat
*/

//ui constants
#define CLR_DEF_TXT_GRAY_SMOOTH '0.78 0.78 0.78'
vector CLR_DEF_TXT_HIGHLIGHT = '0.98 0.98 0.98';  //explicitly a true global
#define CLR_DEF_TXT_NONSELECT '0.75 0.75 0.75'
#define CLR_DEF_TXT_CANTSELECT '0.4 0.4 0.4'
#define CLR_DEF_WHITE '1 1 1'
#define CLR_DEF_GRAY_H '0.85 0.85 0.85'
#define CLR_DEF_BLACK '0 0 0'
vector CLR_DEF_RED = '1 0 0';  //explicitly a true global
#define CLR_DEF_GREEN '0 1 0'
#define CLR_DEF_BLUE '0 0 1'
#define CLR_DEF_YELLOW '1.0 0.89 0.36'

#define CLR_DEF_GREEN_OK '0 0.8 0.25'
//UI Theming
#ifndef MENUQC
vector CLR_DEF_UI_BRIEF;
vector CLR_DEF_UI_HANGAR;
vector CLR_DEF_UI_ARMING;
vector CLR_DEF_UI_DEPLOY;
#endif

//PSC theming
#define CLR_UI_PSC_BRIEF '0.54 0.48 0.39'
#define CLR_UI_PSC_HANGAR '0.47 0.47 0.45'
#define CLR_UI_PSC_ARMING '0.4 0.2 0.1'
#define CLR_UI_PSC_DEPLOY '0.42 0.53 0.37'

//Survest Theming
#define CLR_UI_SRV_BRIEF '0.8 0.48 0'
#define CLR_UI_SRV_HANGAR '0.47 0.47 0.32'
#define CLR_UI_SRV_ARMING '0.37 0.5 0'
#define CLR_UI_SRV_DEPLOY '0.7 0.17 0'

//Militar theming
#define CLR_UI_MIL_BRIEF '0.12 0.17 0.27'
#define CLR_UI_MIL_HANGAR '0.14 0.137 0.29'
#define CLR_UI_MIL_ARMING '0.1 0.21 0.26'
#define CLR_UI_MIL_DEPLOY '0.27 0.5 0.6'

//Deathmatch theming
#define CLR_UI_DM_BRIEF '0.26 0.4 0.0'
#define CLR_UI_DM_HANGAR '0.26 0.4 0.0'
#define CLR_UI_DM_ARMING '0.26 0.4 0.0'
#define CLR_UI_DM_DEPLOY '0.26 0.4 0.0'


//Objectives
#define CLR_UI_OBJT_SECOND '0.7 0.55 0.0'
#define CLR_UI_OBJT_THIRD '0.85 0.85 0.0'

//HUD Colors
#define CLR_HUD_WHITE '0.9 0.9 0.9'     //0
#define CLR_HUD_GREEN '0.2 0.8 0.2'     //1
#define CLR_HUD_ORANGE '0.93 0.5 0.07'  //2
#define CLR_HUD_PURPLE '0.66 0.074 0.93'//3
#define CLR_HUD_BLUE '0.074 0.66 0.93'  //4

//Damage direction indicators
#define CLR_HUD_DMG_ARMOR '0.9 0.2 0.2'
#define CLR_HUD_DMG_SHIELD '0.2 0.9 0.2'

//armor constants
//fine
#define CLR_DEF_ARM_OK '0.2 0.8 0.2'
//75%
#define CLR_DEF_ARM_THREEQ '0.99 0.8 0'
//50%
#define CLR_DEF_ARM_HALF '0.99 0.59 0.2'
//25%
#define CLR_DEF_ARM_ONEQ '0.75 0 0'
//gone
#define CLR_DEF_ARM_DED '0.33 0.33 0.33'

//target armor meter
//fine
#define CLR_DEF_TARG_ARM_OK    '1.0 0.59 0'
//75%
#define CLR_DEF_TARG_ARM_THREEQ  '1.3 0.19 0'
//50%
#define CLR_DEF_TARG_ARM_HALF  '0.69 0 0'
//25%
#define CLR_DEF_TARG_ARM_ONEQ  '0.33 0 0'

//shield constants
//fine
#define CLR_DEF_SHD_OK '0.2 0.8 0.2'
//75%
#define CLR_DEF_SHD_THREEQ '0.4 1 0.4'
//50%
#define CLR_DEF_SHD_HALF '0.6 1 0.6'
//25%
#define CLR_DEF_SHD_ONEQ '0.8 1 0.8'
//gone
#define CLR_DEF_SHD_DED '0 0.2 0'

//energy constants 
//fine
#define CLR_DEF_ENG_OK '0.23 0.74 0.84'
//background
#define CLR_DEF_ENG_DED '0.18 0.32 0.6'

//IFF constants
#define CLR_DEF_IIF_FRIEND_BLD '0 0.6 1' 
//friendly
#define CLR_DEF_IIF_FRIEND '0.17 0.89 0.13'
//neutral
#define CLR_DEF_IFF_NEUTRAL '1 0.6 0.2'
//enemy
#define CLR_DEF_IFF_ENEMY '0.8 0 0'

#define CLR_DEF_IFF_ENEMY_BLD '0.8 0.49 0'

//CROSSHAIRS
//acquiring lock
#define CLR_DEF_RET_GETLOCK '1 0.6 0.2'

//have lock
#define CLR_DEF_RET_HASLOCK '1.0 1.0 0.4'

//ENERGY
#define CLR_DEF_ENE_BCK '0.18 0.32 0.6'
#define CLR_DEF_ENE_FRT '0.23 0.74 0.84'

//weapon constants
#define CLR_DEF_WEP_LOWENG '0.22 0.37 0.37' //82, 122, 122

//group1 

//group2

//group3

//in range
#define CLR_DEF_WEP_INRANGE '0.4 1 0.2'
//out of range
#define CLR_DEF_WPE_NORANGE '0 0.2 0'
//reloaded

//reloading


//radar
//mode active

//mode passive
