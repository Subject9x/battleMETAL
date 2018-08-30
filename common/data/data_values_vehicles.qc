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

//-------------------------Human Test Tank
float ID_VEC_HS_TANK_L = 7;
//-------------------------Human Tank Destroyer
float ID_VEC_HS_TDEST_L = 9;

//============================
//            Health           
//============================
//-------------------------Human Test Tank
float DAT_TNK_CTOR_HP = 100;
float DAT_TNK_LEG_HP = 100;
//-------------------------Human Tank Destroyer
float DAT_H_TD_HP_CTOR = 100;
//============================
//            Armor  ! NOT IMPLEMENTED !
//============================
//-------------------------Human Test Tank
float DAT_TNK_CTOR_ARMOR= 100;
float DAT_TNK_LEG_ARMOR= 100;
//-------------------------Human Tank Destroyer
//============================
//            Shield  
//============================
//-------------------------Human Test Tank
float DAT_TNK_SHIELD_MAX    = 200;
float DAT_TNK_SHIELD_RATE   = 0.35;
//-------------------------Human Tank Destroyer
float DAT_H_TD_SHIELD_MAX    = 200;
float DAT_H_TD_SHIELD_RATE   = 0.35;
  
//============================
//            Energy  
//============================
//-------------------------Human Test Tank
float DAT_TNK_ENERGY_MAX    = 300;
float DAT_TNK_ENERGY_RATE   = 1;
//-------------------------Human Tank Destroyer
float DAT_H_TD_ENERGY_MAX    = 350;
float DAT_H_TD_ENERGY_RATE   = 10;
//============================
//            Speed  
//============================
//-------------------------Human Test Tank
float DAT_TNK_M_FSPEED      = 75;
float DAT_TNK_M_SSPEED      = 75;
float DAT_TNK_M_BSPEED      = 25;
//-------------------------Human Tank Destroyer
float DAT_H_TD_FSPEED      = 50;
float DAT_H_TD_SSPEED      = 0;
float DAT_H_TD_BSPEED      = 15;
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Human Test Tank
float DAT_TNK_RADAR_RANGE     = 4000;
//-------------------------Human Tank Destroyer
float DAT_H_TD_RADAR_RANGE     = 6000;
//============================
//            Base Convergence
//============================
//-------------------------Human Test Tank
vector DAT_TNK_SPREAD_N      = '8 6 0.01';
vector DAT_TNK_SPREAD_X      = '14 10 0.03';
//-------------------------Human Tank Destroyer
vector DAT_H_TD_SPREAD_N      = '4 2 0.02';
vector DAT_H_TD_SPREAD_X      = '8 6 0.025';
//============================
//            Models  
//============================
//-------------------------Human Test Tank
string DAT_TNK_CTOR_MODEL   = "q3mdl/vecs/mdl_tank_tur.md3";
string DAT_TNK_LEG_MODEL    = "q3mdl/vecs/mdl_tank_chas.md3";
string DAT_TNK_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------Human Tank Destroyer
string DAT_H_TD_CTOR_MODEL   = "q3mdl/vecs/mdl_tank_chas.md3";
string DAT_H_TD_CAM_MODEL    = "q3mdl/testball.md3";
//============================
//            Model Offsets 
//============================
//-------------------------Human Test Tank
vector DAT_TNK_LEG_OFFSET   = '0 0 0';
vector DAT_TNK_WEP1_OFFSET  = '-8 6 4';
vector DAT_TNK_WEP2_OFFSET  = '8 6 4';
//-------------------------Human Tank Destroyer
vector DAT_H_TD_WEP1_OFFSET  = '-8 6 4';
//============================
//            Tech level  
//============================
//-------------------------Human Test Tank
float DAT_TNK_TECH_LEVEL = 1;
//-------------------------Human Tank Destroyer
float DAT_H_TD_TECH_LEVEL = 1;