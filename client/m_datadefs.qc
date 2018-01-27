/*
mech Mod
Author: Peter Roohr
Date: 01/24/2017
Overview: really should have been synced with file of the same name serverside....
*/

.string vec_name;
.float vec_size;
.string c_name;

entity(float id, float dat_type) m_findData;
entity(float sz, float id) m_findMechData;
entity(float sz, float id) m_findHUDData;

//VEHICLES===============================
float ID_VEC_TANK = 1;

//BUILDINGS==============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;
float ID_BLD_H_HANGAR_L = 4;
float ID_BLD_H_FUEL = 5;
float ID_BLD_H_LTUR = 6;
