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

entity(float id, float dat_type) m_findData;

//BELOW MUST BE UPDATED IF YOU CHANGE THESE VALUES SERVER SIDE
//MECHS==================================
float ID_MCH_OUTLAW= 1;
float ID_MCH_MATOK= 2;
float ID_MCH_COLOSSUS= 3;

//WEAPONS================================
float ID_WEP_LATC=1;
float ID_WEP_EMP=2;
float ID_WEP_LAS=3;
float ID_WEP_MIS=4;
//PROTO WEAPONS
//BALLISTIC
float ID_WEP_ATC = 5;
float ID_WEP_QRF = 6;
float ID_WEP_RPC = 7;
//ENERGY
float ID_WEP_PAC = 8;
float ID_WEP_ESR = 9;

//MISSILE
float ID_WEP_MLGD = 10;
float ID_WEP_MARH = 11;
float ID_WEP_MAPR = 12;
float ID_WEP_MCRK = 13;

//MELEE
float ID_WEP_RAM = 14;
float ID_WEP_BLD = 15;

//PROJECTILE=============================
float ID_PRJ_LATC = 1;
float ID_PRJ_EMP = 2;
float ID_PRJ_MIS = 3;
float ID_PRJ_MLGD = 4;
float ID_PRJ_MARH = 5;

//VEHICLES===============================

//BUILDINGS==============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;
