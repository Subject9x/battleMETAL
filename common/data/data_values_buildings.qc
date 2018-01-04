/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most building unit values that are shared between 
server and client
*/

//============================
//            Health           
//============================
//-------------------------Human-Fuel Tank
float DAT_BLD_H_FUELTANK_HP     = 150;
//-------------------------Human-Large Hangar
float DAT_BLD_H_LG_HANGAR_HP    = 2000;
//-------------------------Human-Radar Post
float DAT_BLD_H_SM_RADAR_HP     = 250;
//-------------------------Human-Power Plant
float DAT_BLD_H_POWER_PLANT_HP  = 2500;
//-------------------------Human-Shield Generator
float DAT_BLD_H_SHIELDGEN_HP    = 1000;
//-------------------------Human-Light turret
float DAT_TUR_CTOR_HP           = 100;
float DAT_TUR_LEG_HP            = 100;
//============================
//            Armor  ! NOT IMPLEMENTED !
//============================
//-------------------------Human-Fuel Tank
float DAT_BLD_H_FUELTANK_AM    = 10;
//-------------------------Human-Large Hangar
float DAT_BLD_H_LG_HANGAR_AM   = 10;
//-------------------------Human-Radar Post

//-------------------------Human-Power Plant

//-------------------------Human-Shield Generator

//-------------------------Human-Light turret
float DAT_TUR_CTOR_ARMOR      = 100;
float DAT_TUR_LEG_ARMOR       = 100;
//============================
//            Shield  
//============================
//-------------------------Human-Fuel Tank
float DAT_BLD_H_FUELTANK_SH_MAX   = 100;
float DAT_BLD_H_FUELTANK_SH_RATE  = 1;
//-------------------------Human-Large Hangar
float DAT_BLD_H_LG_HANGAR_SH_MAX   = 500;
float DAT_BLD_H_LG_HANGAR_SH_RATE  = 1;
//-------------------------Human-Radar Post
float DAT_BLD_H_SM_RADAR_SH_MAX    = 150;
float DAT_BLD_H_SM_RADAR_SH_RATE   = 1;
//-------------------------Human-Power Plant
float DAT_BLD_H_POWER_PLANT_SH_MAX = 600;
float DAT_BLD_H_POWER_PLANT_SH_RATE = 1;
//-------------------------Human-Shield Generator
float DAT_BLD_H_SHIELDGEN_SH_MAX    = 1000;
float DAT_BLD_H_SHIELDGEN_SH_RATE   = 2;
//-------------------------Human-Light turret
float DAT_TUR_SHIELD_MAX          = 200;
float DAT_TUR_SHIELD_RATE         = 0.35;
//============================
//            Energy  
//============================
//-------------------------Human-Fuel Tank

//-------------------------Human-Large Hangar

//-------------------------Human-Radar Post

//-------------------------Human-Power Plant
float DAT_BLD_H_POWER_PLANT_EN_MAX = 4000;
float DAT_BLD_H_POWER_PLANT_EN_RATE = 4;
//-------------------------Human-Shield Generator

//-------------------------Human-Light turret
float DAT_TUR_ENERGY_MAX    = 400;
float DAT_TUR_ENERGY_RATE   = 1;
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------Human-Fuel Tank

//-------------------------Human-Large Hangar

//-------------------------Human-Radar Post
float DAT_BLD_H_SM_RADAR_RADAR_RANGE = 10000;
//-------------------------Human-Power Plant

//-------------------------Human-Shield Generator

//-------------------------Human-Light turret
float DAT_TUR_RADAR_RANGE   = 3000;
//============================
//            Base Convergence
//============================
//-------------------------Human-Fuel Tank

//-------------------------Human-Large Hangar

//-------------------------Human-Radar Post

//-------------------------Human-Power Plant

//-------------------------Human-Shield Generator

//-------------------------Human-Light turret
vector DAT_TUR_SPREAD_N = '2 3 0.09';
vector DAT_TUR_SPREAD_X = '6 6 0.01';
//============================
//            Models  
//============================
//-------------------------Human-Fuel Tank
string DAT_BLD_H_FUELTANK_MODEL = "q3mdl/buildings/mdl_bld_h_fuel.md3";
//-------------------------Human-Large Hangar
string DAT_BLD_H_LG_HANGAR_MODEL = "q3mdl/buildings/mdl_bld_h_hangar_l.md3";
//-------------------------Human-Radar Post
string DAT_BLD_H_SM_RADAR_MODEL = "q3mdl/buildings/mdl_bld_h_radar.md3";
//-------------------------Human-Power Plant
string DAT_BLD_H_POWER_PLANT_MODEL = "q3mdl/buildings/mdl_bld_h_power.md3";
//-------------------------Human-Shield Generator
string DAT_BLD_H_SHIELDGEN_MODEL = "q3mdl/buildings/mdl_bld_h_shield.md3";
//-------------------------Human-Light turret
string DAT_TUR_CTOR_MODEL     = "q3mdl/buildings/mdl_bld_h_ltur.md3";
string DAT_TUR_LEG_MODEL      = "q3mdl/buildings/mdl_bld_h_ltur_base.md3";
string DAT_TUR_CAM_MODEL      = "q3mdl/testball.md3";