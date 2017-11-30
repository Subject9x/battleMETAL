/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
  mod: 11/26/2017
Overview: master data ID lists for all the game data
*/

.void() unit_ini;
.void() unit_legs;
.void() unit_ctor;
.void() unit_ltor;
.void() unit_rtor;
.void() unit_larm;
.void() unit_rarm;
.void() unit_cam;
.void() unit_wep1;
.void() unit_wep2;
.void() unit_wep3;
.void() unit_wep4;
.void() unit_wep5;
.void() unit_wep6;
.void() unit_wep7;
.void() unit_wep8;
.void() unit_wep9;

void() data_otl_ini;
void() data_mtk_ini;
void() data_mnt_ini;

void() data_emp_ini;
void() data_esr_ini;
void() data_las_ini;
void() data_latc_ini;
void() data_marh_ini;
void() data_mis_ini;
void() data_mlgd_ini;
void() data_pac_ini;
void() data_qrfl_ini;
void() data_rplas_ini;
void() data_sfga_ini;

void() data_prj_emp_ini;
void() data_prj_sfga_ini;
void() data_prj_marh_ini;
void() data_prj_mis_ini;
void() data_prj_mlgd_ini;
void() data_prj_qrfl_ini;
void() data_prj_rplas_ini;
void() data_prj_sfga_ini;

//UPDATE CSQC cs_datadefs.qc if you mod any of these!
//MECHS==================================
float ID_MCH_BALAKET = 1;
float ID_MCH_MATOK = 1;
float ID_MCH_MONITOR = 1;

//WEAPONS================================
//BALLISTIC
float ID_WEP_LATC = 1;
float ID_WEP_QRF = 5;
float ID_WEP_RPC = 6;
float ID_WEP_SFGA = 15;
//ENERGY
float ID_WEP_LAS = 3;
float ID_WEP_EMP = 2;
float ID_WEP_PAC = 7;
float ID_WEP_ESR = 8;

//MISSILE
float ID_WEP_MIS = 4;
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
float ID_PRJ_RPLAS = 6;
float ID_PRJ_QRFL = 7;
float ID_PRJ_SFGA = 8;
//VEHICLES===============================
float ID_VEC_TANK = 1;

//BUILDINGS==============================
float ID_BLD_H_RADAR = 1;
float ID_BLD_H_SHIELD = 2;
float ID_BLD_H_POWER = 3;
float ID_BLD_H_HANGAR_L = 4;
float ID_BLD_H_FUEL = 5;
float ID_BLD_H_TURRET = 6;
