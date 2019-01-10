/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most vehicle values that are shared between 
server and client
*/
//============================
//            DATA ID's           
//============================
//HUMAN SURVIVORS
float ID_VEC_HS_TRUCK_C = 1;
float ID_VEC_HS_TRUCK_H = 2;
float ID_VEC_HS_TRUCK_CS = 3;

float ID_VEC_HS_DOZER = 4;
float ID_VEC_HS_LOADR = 5;
float ID_VEC_HS_EXCAT = 6;
//-------------------------Human Tank Light
float ID_VEC_HS_TANK_L = 7;
float ID_VEC_TROWEL = 8;
//-------------------------Human Tank Destroyer
float ID_VEC_HS_TDEST_L = 9;
float ID_VEC_HS_TDEST_H = 10;
float ID_VEC_HS_SCOUT = 11;
//HUMAN RAIDERS

//SYNTH

//PSC
float ID_VEC_PSC_VTOL_L = 48;

//============================
//            Health           
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_HP = 400;
//-------------------------Human Test Tank
float DAT_H_TANKL_HP = 300;
//-------------------------Trowel
float DAT_TROWEL_HP = 750;
//-------------------------Human Tank Destroyer
float DAT_H_TD_HP_CTOR = 200;
//-------------------------Human Gev Light
float DAT_HS_GEVL_HP = 200;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_HP = 600;
//============================
//            NAMES 
//============================
//-------------------------Human Truck A
string DAT_HS_TRUCKA_NAME = "Convoy Track";
//-------------------------Human Truck B
string DAT_HS_TRUCKB_NAME = "Convoy Hab";
//-------------------------Human Truck C
string DAT_HS_TRUCKC_NAME = "Convoy Supply";
//-------------------------Human Test Tank
string DAT_HS_TANKL_NAME = "Foslager";
//-------------------------Trowel
string DAT_TROWEL_NAME = "Foslager";
//-------------------------Human Tank Destroyer
string DAT_H_TD_VEC_NAME = "Onnek";
//-------------------------Human Gev Light
string DAT_HS_GEVL_NAME = "Dunerunner";
//-------------------------PSC VTOL Light
string DAT_PSC_VTOLL_NAME = "<recon killer>";
//============================
//            Armor  ! NOT IMPLEMENTED !
//============================
//-------------------------Human Test Tank
float DAT_TNK_CTOR_ARMOR  = 1;
float DAT_TNK_LEG_ARMOR = 1;
//-------------------------Human Tank Destroyer
//============================
//            Shield  
//============================
//-------------------------Foslager
float DAT_HS_TANKL_SHIELD_MAX   = 200;
float DAT_HS_TANKL_SHIELD_RATE  = 0.35;
//-------------------------Trowel
float DAT_TROWEL_SHIELD_MAX   = 200;
float DAT_TROWEL_SHIELD_RATE  = 0.35;
//-------------------------Onnek
float DAT_H_TD_SHIELD_MAX       = 200;
float DAT_H_TD_SHIELD_RATE      = 0.35;
//-------------------------Dunerunner
float DAT_HS_GEVL_SHIELD_RATE   = 0.05;
float DAT_HS_GEVL_SHIELD_MAX    = 50;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_SHIELD_MAX  = 100;
float DAT_PSC_VTOLL_SHIELD_RATE = 0.15;
//============================
//            Energy  
//============================
//-------------------------Human Tank Light
float DAT_HS_TANKL_ENERGY_MAX   = 300;
float DAT_HS_TANKL_ENERGY_RATE  = 1;
//-------------------------Trowel
float DAT_TROWEL_ENERGY_MAX   = 500;
float DAT_TROWEL_ENERGY_RATE  = 1;
//-------------------------Human Tank Destroyer
float DAT_H_TD_ENERGY_MAX       = 350;
float DAT_H_TD_ENERGY_RATE      = 10;
//-------------------------Human Gev Light
float DAT_HS_GEVL_ENERGY_MAX    = 100;
float DAT_HS_GEVL_ENERGY_RATE   = 1;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_ENERGY_MAX  = 300;
float DAT_PSC_VTOLL_ENERGY_RATE = 5;
//============================
//            Speed  
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_FSPEED      = 100;
float DAT_HS_TRUCK_SSPEED      = 75;
float DAT_HS_TRUCK_BSPEED      = 25;
//-------------------------Foslager
float DAT_HS_TANKL_FSPEED      = 100;
float DAT_HS_TANKL_SSPEED      = 75;
float DAT_HS_TANKL_BSPEED      = 25;
//-------------------------Trowel
float DAT_TROWEL_FSPEED      = 65;
float DAT_TROWEL_SSPEED      = 45;
float DAT_TROWEL_BSPEED      = 15;
//-------------------------Onnek
float DAT_H_TD_FSPEED          = 50;
float DAT_H_TD_SSPEED          = 0;
float DAT_H_TD_BSPEED          = 15;
//-------------------------Dunerunner
float DAT_HS_GEVL_FSPEED          = 300;
float DAT_HS_GEVL_SSPEED          = 200;
float DAT_HS_GEVL_BSPEED          = 100;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_FSPEED     = 450;
float DAT_PSC_VTOLL_SSPEED     = 375;
float DAT_PSC_VTOLL_BSPEED     = 300;
//============================
//            Bounding Box
//============================
//-------------------------Foslager
vector DAT_HS_TANKL_CTOR_BBX_N =  '-20 -20 -7.75';
vector DAT_HS_TANKL_CTOR_BBX_X =  '20 20 12';
//-------------------------Trowel
vector DAT_TROWEL_CTOR_BBX_N =  '-24 -24 -7.75';
vector DAT_TROWEL_CTOR_BBX_X =  '24 24 20';
//-------------------------Onnek
vector DAT_H_TD_CTOR_BBX_N    =   '-20 -20 -10';
vector DAT_H_TD_CTOR_BBX_X    =   '20 20 14';
//-------------------------Dunerunner
vector DAT_HS_GEVL_BBX_N    =   '-20 -20 -10';
vector DAT_HS_GEVL_BBX_X    =   '20 20 14';
//-------------------------PSC VTOL Light
vector DAT_PSC_VTOLL_BBX_N    =   '-30 -30 -15';
vector DAT_PSC_VTOLL_BBX_X    =   '30 30 15';
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Foslager
float DAT_HS_TANKL_RADAR_RANGE    = 4000;
//-------------------------Trowel
float DAT_TROWEL_RADAR_RANGE    = 2000;
//-------------------------Onnek
float DAT_H_TD_RADAR_RANGE        = 6000;
//-------------------------Dunerunner
float DAT_HS_GEVL_RADAR_RANGE      = 2000;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_RADAR_RANGE   = 3000;
//============================
//         Base Yaw Speed
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_YAW_SPEED    = 1.9;
//-------------------------Foslager
float DAT_HS_TANKL_YAW_SPEED    = 2.5;
//-------------------------Trowel
float DAT_TROWEL_YAW_SPEED    = 1.5;
//-------------------------Onnek
float DAT_HS_TANKDEST_YAW_SPEED = 2.5;
//-------------------------Dunerunner
float DAT_HS_GEVL_YAW_SPEED     = 5;
//-------------------------PSC VTOL Light
float DAT_PSC_VTOLL_YAW_SPEED   = 8;
//============================
//            Models  
//============================
//-------------------------Foslager
string DAT_HS_TANKL_CTOR_MODEL   = "q3mdl/vecs/foslager/mdl_foslager_tur.md3";
string DAT_HS_TANKL_MDL_CHASSIS    = "q3mdl/vecs/foslager/mdl_foslager_chas.md3";
string DAT_HS_TANKL_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------Trowel
string DAT_TROWEL_CTOR_MODEL   = "q3mdl/vecs/trowel/mdl_trowel_tur.md3";
string DAT_TROWEL_MDL_CHASSIS    = "q3mdl/vecs/trowel/mdl_trowel_chas.md3";
//-------------------------Onnek
string DAT_H_TD_CTOR_MODEL   = "q3mdl/vecs/onnek/mdl_onnek_chas.md3";
string DAT_H_TD_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------Dunerunner
string DAT_HS_GEVL_MDL_CAM    = "q3mdl/testball.md3";
//-------------------------PSC VTOL Light
string DAT_PSC_VTOLL_MODEL   = "q3mdl/vecs/mdl_tank_chas.md3";
//============================
//            Model Offsets 
//============================
//-------------------------Foslager
vector DAT_HS_TANKL_LEG_OFFSET    = '0 0 0';
vector DAT_HS_TANKL_WEP1_OFFSET   = '1.5 11 4';
vector DAT_HS_TANKL_WEP2_OFFSET   = '-5.1 11.5 3';
vector DAT_HS_TANKL_WEP3_OFFSET   = '-1.5 6 9';
//-------------------------Trowel
vector DAT_TROWEL_LEG_OFFSET    = '0 0 0';
vector DAT_TROWEL_WEP1_OFFSET   = '-4.75 12 12';
vector DAT_TROWEL_WEP2_OFFSET   = '-4.75 16.75 12';
//-------------------------Onnek
vector DAT_H_TD_WEP1_OFFSET       = '7.25 3.5 12';
//-------------------------Dunerunner
vector DAT_HS_GEVL_WEP1_OFFSET    = '-1.5 5.25 2';
vector DAT_HS_GEVL_WEP2_OFFSET    = '1.5 5.25 2';
//-------------------------PSC VTOL Light
vector DAT_PSC_VTOLL_WEP1_OFFSET  = '-9 -6 28';
vector DAT_PSC_VTOLL_WEP2_OFFSET  = '9 -6 28';
//============================
//            Tech level  
//============================
//-------------------------Foslager
float DAT_HS_TANKL_TECH_LEVEL = 1;
//-------------------------Trowel
float DAT_TROWEL_TECH_LEVEL = 2;
//-------------------------Onnek
float DAT_H_TD_TECH_LEVEL = 1;