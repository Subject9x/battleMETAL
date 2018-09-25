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

float ID_VEC_HS_TANK_H = 8;

float ID_VEC_HS_TDEST_H = 10;

float ID_VEC_HS_SCOUT = 11;
//HUMAN RAIDERS

//-------------------------Human Tank Light
float ID_VEC_HS_TANK_L = 7;
//-------------------------Human Tank Destroyer
float ID_VEC_HS_TDEST_L = 9;

//============================
//            Health           
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_HP = 100;
//-------------------------Human Test Tank
float DAT_H_TANKL_CTOR_HP = 200;
float DAT_H_TANKL_LEG_HP = 200;
//-------------------------Human Tank Destroyer
float DAT_H_TD_HP_CTOR = 100;
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
string DAT_HS_TANKL_NAME = "<Medium Tank>";
//-------------------------Human Tank Destroyer
string DAT_H_TD_VEC_NAME = "<Tank Destroyer>";

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
//-------------------------Human Tank Light
float DAT_HS_TANKL_SHIELD_MAX    = 200;
float DAT_HS_TANKL_SHIELD_RATE   = 0.35;
//-------------------------Human Tank Destroyer
float DAT_H_TD_SHIELD_MAX    = 200;
float DAT_H_TD_SHIELD_RATE   = 0.35;
//============================
//            Energy  
//============================
//-------------------------Human Tank Light
float DAT_HS_TANKL_ENERGY_MAX  = 300;
float DAT_HS_TANKL_ENERGY_RATE = 1;
//-------------------------Human Tank Destroyer
float DAT_H_TD_ENERGY_MAX    = 350;
float DAT_H_TD_ENERGY_RATE   = 10;
//============================
//            Speed  
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_FSPEED      = 100;
float DAT_HS_TRUCK_SSPEED      = 75;
float DAT_HS_TRUCK_BSPEED      = 25;
//-------------------------Human Tank Light
float DAT_HS_TANKL_FSPEED      = 100;
float DAT_HS_TANKL_SSPEED      = 75;
float DAT_HS_TANKL_BSPEED      = 25;
//-------------------------Human Tank Destroyer
float DAT_H_TD_FSPEED      = 50;
float DAT_H_TD_SSPEED      = 0;
float DAT_H_TD_BSPEED      = 15;
//============================
//            Bounding Box
//============================
//-------------------------Human Tank Light
vector DAT_HS_TANKL_CTOR_BBX_N ='-20 -20 -10';
vector DAT_HS_TANKL_CTOR_BBX_X ='20 20 14';
//-------------------------Human Tank Destroyer
vector DAT_H_TD_CTOR_BBX_N ='-20 -20 -10';
vector DAT_H_TD_CTOR_BBX_X ='20 20 14';
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Human Tank Light
float DAT_HS_TANKL_RADAR_RANGE  = 4000;
//-------------------------Human Tank Destroyer
float DAT_H_TD_RADAR_RANGE      = 6000;
//============================
//            Base Convergence
//============================
//-------------------------Human Tank Light
vector DAT_HS_TANKL_SPREAD_N      = '8 6 0.01';
vector DAT_HS_TANKL_SPREAD_X      = '14 10 0.03';
//-------------------------Human Tank Destroyer
vector DAT_H_TD_SPREAD_N      = '4 2 0.02';
vector DAT_H_TD_SPREAD_X      = '8 6 0.025';
//============================
//         Base Yaw Speed
//============================
//-------------------------Human Truck A, B, C
float DAT_HS_TRUCK_YAW_SPEED  = 1.9;
//-------------------------Human Tank Light
float DAT_HS_TANKL_YAW_SPEED  = 2.5;
//-------------------------Human Tank Destroyer
float DAT_HS_TANKDEST_YAW_SPEED = 2.5;
//============================
//            Models  
//============================
//-------------------------Human Tank Light
string DAT_HS_TANKL_CTOR_MODEL   = "q3mdl/vecs/mdl_tank_tur.md3";
string DAT_HS_TANKL_MDL_CHASSIS    = "q3mdl/vecs/mdl_tank_chas.md3";
string DAT_HS_TANKL_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------Human Tank Destroyer
string DAT_H_TD_CTOR_MODEL   = "q3mdl/vecs/mdl_tank_chas.md3";
string DAT_H_TD_CAM_MODEL    = "q3mdl/testball.md3";
//============================
//            Model Offsets 
//============================
//-------------------------Human Tank Light
vector DAT_HS_TANKL_LEG_OFFSET   = '0 0 0';
vector DAT_HS_TANKL_WEP1_OFFSET  = '-8 6 4';
vector DAT_HS_TANKL_WEP2_OFFSET  = '8 6 4';
//-------------------------Human Tank Destroyer
vector DAT_H_TD_WEP1_OFFSET  = '-8 6 4';
//============================
//            Tech level  
//============================
//-------------------------Human Tank Light
float DAT_HS_TANKL_TECH_LEVEL = 1;
//-------------------------Human Tank Destroyer
float DAT_H_TD_TECH_LEVEL = 1;