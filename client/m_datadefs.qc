/*
mech Mod
Author: Subject9x
Date: 01/24/2017
Overview: really should have been synced with file of the same name serverside....
*/

.string vec_name;
.float vec_size;
.string c_name;

string DATA = "data";
float DATA_MECH = 1;
float DATA_VEHC = 2;
float DATA_WEPN = 3;
float DATA_PROJ = 4;
float DATA_HUD = 5;
float DATA_BLD = 6;
float DATA_NAVP = 7;
float DATA_OBJT = 8;

entity(float id, float dat_type) m_findData;
entity(float sz, float id) m_findMechData;
entity(float sz, float id) m_findHUDData;

//BELOW MUST BE UPDATED IF YOU CHANGE THESE VALUES SERVER SIDE
//MECHS==================================
float ID_MCH_BALAKET = 1;
float SZ_MCH_BALAKET = 1;

float ID_MCH_MATOK = 1;
float SZ_MCH_MATOK = 2;

float ID_MCH_HEVDAHL = 1;
float SZ_MCH_HEVDAHL = 3;

//WEAPONS================================
float ID_WEP_LATC=1;
float ID_WEP_EMP=2;
float ID_WEP_LAS=3;
float ID_WEP_MIS=4;
//PROTO WEAPONS
//BALLISTIC
float ID_WEP_QRF = 5;
float ID_WEP_RPC = 6;
float ID_WEP_SFGA = 15;
//ENERGY
float ID_WEP_PAC = 7;
float ID_WEP_ESR = 8;

//MISSILE
float ID_WEP_MLGD = 9;
float ID_WEP_MARH = 10;
float ID_WEP_MAPR = 11;
float ID_WEP_MCRK = 12;

//MELEE
float ID_WEP_RAM = 13;
float ID_WEP_BLD = 14;

//PROJECTILE=============================
float ID_PRJ_LATC = 1;
float ID_PRJ_EMP = 2;
float ID_PRJ_MIS = 3;
float ID_PRJ_MLGD = 4;
float ID_PRJ_MARH = 5;
float ID_PRJ_SFGA = 6;

//VEHICLES===============================

//BUILDINGS==============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;
float ID_BLD_H_HANGAR_L = 4;
float ID_BLD_H_FUEL = 5;
