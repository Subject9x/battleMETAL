/*
battleMETAL
Author: Peter Roohr
Date: 07/16/2018
Overview: all data pertaining to turrets, they're kinda a edge case between
vehicles and buildings, and figured it was better to give them their own space
*/

//============================
//            DATA ID's           
//============================
float ID_TUR_HLITE  = 1;
float ID_TUR_HMED   = 2;
float ID_TUR_HHEV   = 3;
float ID_TUR_SLITE  = 4;

//============================
//            Health           
//============================
//-------------------------Human Light Turret
float DAT_TUR_HLITE_HP  = 100;

//============================
//            Shield  
//============================
//-------------------------Human Light Turret
float DAT_TUR_HLITE_SH_MAX  = 100;
float DAT_TUR_HLITE_SH_RATE  = 0.25;

//============================
//            Energy  
//============================
//-------------------------Human Light Turret
float DAT_TUR_HLITE_EN_MAX  = 100;
float DAT_TUR_HLITE_EN_RATE  = 0.25;

//============================
//            BOUNDING BOX
//============================
//-------------------------Human Light Turret
vector DAT_TUR_HLITE_BBN ='-20 -20 -6';
vector DAT_TUR_HLITE_BBX ='20 20 13';
//============================
//          YAW SPEEDS    
//============================
//-------------------------Human Light Turret
float DAT_TUR_HLITE_YAWS = 3;
float DAT_TUR_HLITE_TURRET_YAW = 4;
//============================
//          PITCH SPEEDS    
//============================
//-------------------------Human Light Turret
vector DAT_TUR_HLITE_PITCH = '-25 45 5';

//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Human Light Turret
float DAT_TUR_HLITE_RADRANGE = 1000;
float DAT_TUR_HLITE_LOCK     = 10;

//============================
//            Models  
//============================
//-------------------------Human Light Turret
string DAT_TUR_HLITE_TUR = "q3mdl/buildings/turret_light/mdl_bld_h_ltur.md3";
string DAT_TUR_HLITE_BASE = "q3mdl/buildings/turret_light/mdl_bld_h_ltur_base.md3";
string DAT_TUR_HLITE_CAM = "q3mdl/testball.md3";

//============================
//            Model Offsets 
//============================
//-------------------------Human Light Turret
vector DAT_TUR_HLITE_WEP1_OFFSET      = '2.5 7.5 11';
vector DAT_TUR_HLITE_WEP1_OFFSET_ALT  = '0 0 0';
vector DAT_TUR_HLITE_WEP1_ADJ_ANG     = '0 0 90';

vector DAT_TUR_HLITE_WEP2_OFFSET      = '6 7.5 11';
vector DAT_TUR_HLITE_WEP2_OFFSET_ALT  = '0 0 0';
vector DAT_TUR_HLITE_WEP2_ADJ_ANG     = '0 0 90';

float DAT_TUR_HLITE_CAM_CNAME        = -1;
vector DAT_TUR_HLITE_CAM_OFFSET       = '0 0 0';
vector DAT_TUR_HLITE_CAM_OFFSET_ALT   = '0 0 0';//LEGS
vector DAT_TUR_HLITE_LEG_OFFSET       = '0 7.5 0';

//============================
//    NAMES 
//============================
//-------------------------Human Light Turret
string DAT_TUR_HLITE_NAME = "Light Turret";