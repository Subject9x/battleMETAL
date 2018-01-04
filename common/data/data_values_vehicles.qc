/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most vehicle values that are shared between 
server and client
*/

//============================
//            Health           
//============================
//-------------------------Human Test Tank
float DAT_TNK_CTOR_HP = 100;
float DAT_TNK_LEG_HP = 100;
//============================
//            Armor  ! NOT IMPLEMENTED !
//============================
//-------------------------Human Test Tank
float DAT_TNK_CTOR_ARMOR= 100;
float DAT_TNK_LEG_ARMOR= 100;
//============================
//            Shield  
//============================
//-------------------------Human Test Tank
float DAT_TNK_SHIELD_MAX    = 200;
float DAT_TNK_SHIELD_RATE   = 0.35;
  
//============================
//            Energy  
//============================
//-------------------------Human Test Tank
float DAT_TNK_ENERGY_MAX    = 300;
float DAT_TNK_ENERGY_RATE   = 1;
//============================
//            Speed  
//============================
//-------------------------Human Test Tank
float DAT_TNK_M_FSPEED      = 75;
float DAT_TNK_M_SSPEED      = 75;
float DAT_TNK_M_BSPEED      = 25;
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Human Test Tank
float DAT_TNK_RADAR_RANGE     = 4000;

//============================
//            Base Convergence
//============================
//-------------------------Human Test Tank
vector DAT_TNK_SPREAD_N      = '8 6 0.01';
vector DAT_TNK_SPREAD_X      = '14 10 0.03';
//============================
//            Models  
//============================
//-------------------------Human Test Tank
string DAT_TNK_CTOR_MODEL   = "q3mdl/vecs/mdl_tank_tur.md3";
string DAT_TNK_LEG_MODEL    = "q3mdl/vecs/mdl_tank_chas.md3";
string DAT_TNK_CAM_MODEL    = "q3mdl/testball.md3";
//============================
//            Model Offsets 
//============================
//-------------------------Human Test Tank
vector DAT_TNK_LEG_OFFSET   = '0 0 0';
vector DAT_TNK_WEP1_OFFSET  = '-8 6 4';
vector DAT_TNK_WEP2_OFFSET  = '8 6 4';
//============================
//            Tech level  
//============================
//-------------------------Human Test Tank
float DAT_TNK_TECH_LEVEL = 1;