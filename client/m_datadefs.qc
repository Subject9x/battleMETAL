/*
mech Mod
Author: Subject9x
Date: 01/24/2017
Overview: really should have been synced with file of the same name serverside....
*/

.string vec_name;
.string c_name;

string DATA = "data";
float DATA_MECH = 1;
float DATA_VEHC = 2;
float DATA_WEPN = 3;
float DATA_PROJ = 4;
float DATA_HUD = 5;
float DATA_BLD = 6;

//MECHS==================================
float ID_MCH_OUTLAW= 1;
float ID_MCH_MATOK= 2;
float ID_MCH_COLOSSUS= 3;

//VEHICLE================================

//BUILDINGS===============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;

//WEAPONS================================
float ID_WEP_LATC=1;
float ID_WEP_EMP=2;
float ID_WEP_LAS=3;
float ID_WEP_MIS=4;

//PROJECTILE=============================
float ID_PRJ_LATC=1;
float ID_PRJ_EMP=2;
float ID_PRJ_MIS=3;

entity(float id, float dat_type) m_findData;