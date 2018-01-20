/*
mech Mod
Author: Peter Roohr
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
float DATA_NODE = 9;
float DATA_DEPL = 10;
float DATA_POBS = 11;

entity(float id, float dat_type) m_findData;
entity(float sz, float id) m_findMechData;
entity(float sz, float id) m_findHUDData;

//MECHS==================================
float ID_MCH_BALAKET = 1;
float SZ_MCH_BALAKET = 1;

float ID_MCH_MATOK = 1;
float SZ_MCH_MATOK = 2;

float ID_MCH_HEVDAHL = 1;
float SZ_MCH_HEVDAHL = 3;

//VEHICLES===============================
float ID_VEC_TANK = 1;

//BUILDINGS==============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;
float ID_BLD_H_HANGAR_L = 4;
float ID_BLD_H_FUEL = 5;
float ID_BLD_H_LTUR = 6;
