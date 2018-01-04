/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most weapon values that are shared between 
server and client
*/

//====================================================================================
//            Range  
//====================================================================================
//-------------------------ATC
float DAT_LATC_RANGE      = 3600;
//-------------------------RPlas
float DAT_RPLAS_RANGE     = 2400;
//-------------------------QRifle
float DAT_QRFL_RANGE      = 3600;
//-------------------------SFGA
float DAT_SFGA_RANGE      = 3600;
//-------------------------Laser
float DAT_LAS_RANGE       = 4000;
//-------------------------EMP
float DAT_EMP_RANGE       = 2400;
//-------------------------ESR
float DAT_ESR_RANGE       = 800;
//-------------------------PAC
float DAT_PAC_RANGE       = 1600;
//-------------------------Rocket
float DAT_MIS_RANGE       = 1000;
//-------------------------Laser Missile
float DAT_MLGD_RANGE      = 2400;
//-------------------------Radar Missile
float DAT_MARH_RANGE      = 3000;
//====================================================================================
//            Recharge Time  
//====================================================================================
//-------------------------ATC
float DAT_LATC_EN_COST    = 10;
float DAT_LATC_EN_MAX     = 100;
float DAT_LATC_FIRERATE   = 0.05;
//-------------------------RPlas
float DAT_RPLAS_EN_COST   = 10;
float DAT_RPLAS_EN_MAX    = 300;
float DAT_RPLAS_FIRERATE  = 0;
//-------------------------QRifle
float DAT_QRFL_EN_COST    = 10;
float DAT_QRFL_EN_MAX     = 500;
float DAT_QRFL_FIRERATE   = 0;
//-------------------------SFGA
float DAT_SFGA_EN_COST    = 10;
float DAT_SFGA_EN_MAX     = 800;
float DAT_SFGA_FIRERATE   = 0;
//-------------------------Laser
float DAT_LAS_EN_RATE     = 10;
float DAT_LAS_EN_MAX      = 200;
float DAT_LAS_FIRERATE    = 0;
//-------------------------EMP
float DAT_EMP_EN_COST     = 10;
float DAT_EMP_EN_MAX      = 600;
float DAT_EMP_FIRERATE    = 0;
//-------------------------ESR
float DAT_ESR_EN_COST     = 10;
float DAT_ESR_EN_MAX      = 500;
float DAT_ESR_FIRERATE    = 0.05;
//-------------------------PAC
float DAT_PAC_EN_COST     = 10;
float DAT_PAC_EN_MAX      = 800;
float DAT_PAC_FIRERATE    = 0;
//-------------------------Rocket
float DAT_MIS_EN_COST     = 10;
float DAT_MIS_EN_MAX      = 800;
float DAT_MIS_FIRERATE    = 0.2;
//-------------------------Laser Missile
float DATWEP_MLGD_EN_COST = 10;
float DATWEP_MLGD_EN_MAX  = 500;
float DATWEP_MLGD_FIRERATE = 0;
//-------------------------Radar Missile
float DATWEP_MARH_EN_COST = 10;
float DATWEP_MARH_EN_MAX  = 500;
float DATWEP_MARH_FIRERATE = 0;
//====================================================================================
//            Damage  
//====================================================================================
//-------------------------ATC
float DAT_LATC_DMG        = 5;
//-------------------------RPlas
float DAT_RPLAS_DMG       = 20;  //this is a derived value
//-------------------------QRifle
float DAT_QRFL_DMG        = 150;  //this is a derived value
//-------------------------SFGA
float DAT_SFGA_DMG        = 300;
//-------------------------Laser
float DAT_LAS_DMG         = 20;
//-------------------------EMP
float DAT_EMP_DAMAGE      = 300;
//-------------------------ESR
float DAT_ESR_DMG         = 25;
//-------------------------PAC
float DAT_PAC_DMG         = 200;
//-------------------------Rocket
float DAT_MIS_DAMAGE      = 75;
//-------------------------Laser Missile
float DAT_MLGD_DAMAGE     = 275;
//-------------------------Radar Missile
float DAT_MARH_DAMAGE     = 2; 
//====================================================================================
//            Inaccuracy  
//====================================================================================
//-------------------------ATC
float DAT_LATC_SPR_X      = 3; 
float DAT_LATC_SPR_Y      = 3; 
//-------------------------RPlas
float DAT_RPLAS_SPR_X     = 8;
float DAT_RPLAS_SPR_Y     = 8;
//-------------------------QRifle
float DAT_QRFL_SPR_X      = 0; 
float DAT_QRFL_SPR_Y      = 0;
//-------------------------SFGA
float DAT_SFGA_SPR_X      = 3;
float DAT_SFGA_SPR_Y      = 2;
//-------------------------Laser

//-------------------------EMP

//-------------------------ESR
float DAT_ESR_SPR_X       = 6;
float DAT_ESR_SPR_Y       = 6;
//-------------------------PAC
float DAT_PAC_SPR_X       = 2;
float DAT_PAC_SPR_Y       = 2;
//-------------------------Rocket
float DAT_LAS_SPR_X       = 10;
float DAT_LAS_SPR_Y       = 3;
//-------------------------Laser Missile

//-------------------------Radar Missile
//====================================================================================
//            Clipsize  
//====================================================================================
//-------------------------ATC
float DAT_LATC_CLIPSIZE     = 1;
//-------------------------RPlas
float DAT_RPLAS_CLIPSIZE    = 1;
//-------------------------QRifle
float DAT_QRFL_CLIPSIZE     = 1;
//-------------------------SFGA
float DAT_SFGA_CLIPSIZE     = 1;
//-------------------------Laser
float DAT_LAS_CLIPSIZE      = 1;
//-------------------------EMP
float DAT_EMP_CLIPSIZE      = 1;
//-------------------------ESR
float DAT_ESR_CLIPSIZE      = 20;
//-------------------------PAC
float DAT_PAC_CLIPSIZE      = 1;
//-------------------------Rocket
float DAT_MIS_CLIPSIZE      = 6;
//-------------------------Laser Missile
float DATWEP_MLGD_CLIPSIZE  = 1;
//-------------------------Radar Missile
float DATWEP_MARH_CLIPSIZE  = 1;
//============================
//            Tech Level  
//============================
//-------------------------ATC
float DAT_LATC_TECH_LEVEL   = 1;
//-------------------------RPlas
float DAT_RPLAS_TECH_LEVEL  = 1;
//-------------------------QRifle
float DAT_QRFL_TECH_LEVEL   = 1;
//-------------------------SFGA
float DAT_SFGA_TECH_LEVEL   = 1;
//-------------------------Laser
float DAT_LAS_TECH_LEVEL    = 1;
//-------------------------EMP
float DAT_EMP_TECH_LEVEL    = 1;
//-------------------------ESR
float DAT_ESR_TECH_LEVEL    = 1;
//-------------------------PAC
float DAT_PAC_TECH_LEVEL    = 1;
//-------------------------Rocket
float DAT_MIS_TECH_LEVEL    = 1;
//-------------------------Laser Missile
float DATWEP_MLGD_TECH_LEVEL = 2;
//-------------------------Radar Missile
float DATWEP_MARH_TECH_LEVEL = 2;
//============================
//            Size  
//============================
//-------------------------ATC
float DAT_LATC_WSIZE      = 1;
//-------------------------RPlas
float DAT_RPLAS_WSIZE     = 2;
//-------------------------QRifle
float DAT_QRFL_WSIZE      = 3;
//-------------------------SFGA
float DAT_SFGA_WSIZE      = 1;
//-------------------------Laser
float DAT_LAS_WSIZE       = 1;
//-------------------------EMP
float DAT_EMP_WSIZE       = 2;
//-------------------------ESR
float DAT_ESR_WSIZE       = 3;
//-------------------------PAC
float DAT_PAC_WSIZE       = 2;
//-------------------------Rocket
float DAT_MIS_WSIZE       = 1;
//-------------------------Laser Missile
float DAT_MLGD_WSIZE      = 1;
//-------------------------Radar Missile
float DAT_MARH_WSIZE      = 3;
//============================
//            Sound Url
//============================
//-------------------------ATC
string DAT_LATC_SOUND = "sound/weapons/atc_fire.ogg";
//-------------------------RPlas
string DAT_RPLAS_SOUND = "sound/weapons/atc_fire.ogg";
//-------------------------QRifle
string DAT_QRFL_SOUND = "sound/weapons/qrfl_fire.ogg";
//-------------------------SFGA
string DAT_SFGA_SOUND = "sound/fx_boom.ogg";
//-------------------------Laser
string DAT_LAS_SOUND = "sound/weapons/laser_fire.ogg";
//-------------------------EMP
string DAT_EMP_SOUND = "sound/weapons/emp_fire.ogg";
//-------------------------ESR
string DAT_ESR_SOUND = "sound/weapons/esr_fire.ogg";
//-------------------------PAC
string DAT_PAC_SOUND = "sound/weapons/pac_fire.ogg";
//-------------------------Rocket
string DAT_MIS_SOUND = "sound/weapons/mis_fire.ogg";
//-------------------------Laser Missile
string DATWEP_MLGD_FIRESOUND = "sound/weapons/mis_fire.ogg";
//-------------------------Radar Missile
string DATWEP_MARH_FIRESOUND = "sound/weapons/mis_fire.ogg";
//============================
//            Model  
//============================
//-------------------------ATC
string DAT_LATC_MODEL    = "q3mdl/weapons/w_atc.md3";
//-------------------------RPlas
string DAT_RPLAS_MODEL   = "q3mdl/weapons/w_rpc.md3";
//-------------------------QRifle
string DAT_QRFL_MODEL    = "q3mdl/weapons/w_qrf.md3";
//-------------------------SFGA
string DAT_SFGA_MODEL    = "q3mdl/weapons/w_sfga.md3";
//-------------------------Laser
string DAT_LAS_MODEL     = "q3mdl/weapons/w_laser.md3";
//-------------------------EMP
string DAT_EMP_MODEL     = "q3mdl/weapons/w_emp.md3";
//-------------------------ESR
string DAT_ESR_MODEL     = "q3mdl/weapons/w_esr.md3";
//-------------------------PAC
string DAT_PAC_MODEL     = "q3mdl/weapons/w_pac.md3";
//-------------------------Rocket
string DAT_MIS_MODEL     = "q3mdl/weapons/w_mis.md3";
//-------------------------Laser Missile
string DATWEP_MLGD_MODEL = "q3mdl/weapons/w_lgm.md3";
//-------------------------Radar Missile
string DATWEP_MARH_MODEL = "q3mdl/weapons/w_arh.md3";
//============================
//            Model Offset 
//============================
//-------------------------ATC
vector DAT_LATC_FIRE_OFS    = '0 0 2';
//-------------------------RPlas
vector DAT_RPLAS_FIRE_OFS   = '0 0 2';
//-------------------------QRifle
vector DAT_QRFL_FIRE_OFS    = '0 0 2';
//-------------------------SFGA
vector DAT_SFGA_FIRE_OFS    = '0 0 2';
//-------------------------Laser
vector DAT_LAS_FIRE_OFS     = '0 0 2';
//-------------------------EMP
vector DAT_EMP_FIRE_OFS     = '0 0 2';
//-------------------------ESR
vector DAT_ESR_FIRE_OFS     = '0 0 4';
//-------------------------PAC
vector DAT_PAC_FIRE_OFS     = '0 0 8';
//-------------------------Rocket
vector DAT_MIS_FIRE_OFS     = '0 0 2';
//-------------------------Laser Missile
vector DATWEP_MLGD_FIRE_OFS = '0 0 2';
//-------------------------Radar Missile
vector DATWEP_MARH_FIRE_OFS = '0 0 2';
//============================
//            Projectile ID
//============================
//-------------------------ATC

//-------------------------RPlas
float DAT_RPLAS_PROJ_ID   = ID_PRJ_RPLAS;
//-------------------------QRifle
float DAT_QRFL_PROJ_ID    = ID_PRJ_QRFL;
//-------------------------SFGA
float DAT_SFGA_PROJ_ID    = ID_PRJ_SFGA;
//-------------------------Laser

//-------------------------EMP
float DAT_EMP_PROJ_ID     = ID_PRJ_EMP;
//-------------------------ESR

//-------------------------PAC

//-------------------------Rocket
float DAT_MIS_PROJ_ID     = ID_PRJ_MIS;
//-------------------------Laser Missile
float DATWEP_MLGD_PROJ_ID = ID_PRJ_MLGD;
//-------------------------Radar Missile
float DATWEP_MARH_PROJ_ID = ID_PRJ_MARH;