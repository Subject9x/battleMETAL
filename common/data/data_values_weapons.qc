/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most weapon values that are shared between 
server and client
*/
//====================================================================================
//            Game ID's  
//====================================================================================
float ID_WEP_LATC  = 1;
float ID_WEP_LAS   = 3;
float ID_WEP_EMP   = 2;
float ID_WEP_MIS   = 4;
float ID_WEP_QRF   = 5;
float ID_WEP_RPC   = 6;
float ID_WEP_PAC   = 7;
float ID_WEP_ESR   = 8;
float ID_WEP_MLGD  = 9;
float ID_WEP_MARH  = 10;
float ID_WEP_MAPR  = 11;
float ID_WEP_RAM   = 13;
float ID_WEP_BLD   = 14;
float ID_WEP_SFGA  = 15;
float ID_WEP_FLAK  = 16;
float ID_WEP_ION   = 17;
float ID_WEP_SWRM  = 18;
//TODO - Alpha 3 
float ID_WEP_ABT   = 19;
//-----EQUIP------------
float ID_EQP_BAT   = 20;
float ID_EQP_CAP   = 21;
float ID_EQP_EMT   = 22;
float ID_EQP_MOD   = 23;
float ID_EQP_SEN   = 24;
float ID_EQP_TAR   = 25;
//====================================================================================
//            Weapon Names
//====================================================================================
string DAT_LATC_NAME = "Light Autocannon";
string DAT_LAS_NAME = "Light Laser";
string DAT_EMP_NAME = "EMP Cannon";
string DAT_MIS_NAME = "Rocket Launcher";
string DAT_QRF_NAME = "Q-Rifle";
string DAT_RPC_NAME = "RPC";
string DAT_PAC_NAME = "PAC";
string DAT_ESR_NAME = "ESR";
string DAT_MLGD_NAME = "MIS-LGD";
string DAT_MARH_NAME = "MIS-ARH";
string DAT_SFGA_NAME = "Snub Field Gun";
string DAT_FLAK_NAME = "Flak Cannon";
string DAT_ION_NAME = "Ion Coil";
string DAT_SWRM_NAME = "Swarm Missile Launcher";

//====================================================================================
//            Range  
//====================================================================================
//-------------------------ATC
float DAT_LATC_RANGE      = 3800;
//-------------------------RPlas
float DAT_RPLAS_RANGE     = 2400;
//-------------------------QRifle
float DAT_QRFL_RANGE      = 3600;
//-------------------------SFGA
float DAT_SFGA_RANGE      = 3600;
//-------------------------FLAK
float DAT_FLAK_RANGE      = 4000;
//-------------------------Laser
float DAT_LAS_RANGE       = 4000;
//-------------------------ION
float DAT_ION_RANGE       = 3800;
//-------------------------EMP
float DAT_EMP_RANGE       = 1900;
//-------------------------ESR
float DAT_ESR_RANGE       = 800;
//-------------------------PAC
float DAT_PAC_RANGE       = 1600;
//-------------------------Rocket
float DAT_MIS_RANGE       = 1000;
//-------------------------Laser Missile
float DAT_MLGD_RANGE      = 2400;
//-------------------------Radar Missile
float DAT_MARH_RANGE      = 3600;
//-------------------------Swarm Missile
float DAT_SWRM_RANGE      = 1600;
//====================================================================================
//            Recharge Time  
//====================================================================================
//-------------------------ATC
float DAT_LATC_RL_RATE    = 0.1;
float DAT_LATC_RL_MAX     = 0.4;
float DAT_LATC_EN_RATE    = 0;
//-------------------------RPlas
float DAT_RPLAS_RL_RATE   = 0.1;
float DAT_RPLAS_RL_MAX    = 3;
float DAT_RPLAS_EN_RATE   = 0.3;
//-------------------------QRifle
float DAT_QRFL_RL_RATE    = 0.1;
float DAT_QRFL_RL_MAX     = 5;
float DAT_QRFL_EN_RATE    = 3;
//-------------------------SFGA
float DAT_SFGA_RL_RATE    = 0.1;
float DAT_SFGA_RL_MAX     = 8;
float DAT_SFGA_EN_RATE    = 0;
//-------------------------FLAK
float DAT_FLAK_RL_RATE    = 0.1;
float DAT_FLAK_RL_MAX     = 4;
float DAT_FLAK_EN_RATE    = 0;
//-------------------------Laser
float DAT_LAS_RL_RATE     = 0.1;
float DAT_LAS_RL_MAX      = 2;
float DAT_LAS_EN_RATE     = 0.5;
//-------------------------ION
float DAT_ION_RL_RATE     = 0.1;
float DAT_ION_RL_MAX      = 5;
float DAT_ION_EN_RATE     = 4;
//-------------------------EMP
float DAT_EMP_RL_RATE     = 0.1;
float DAT_EMP_RL_MAX      = 6;
float DAT_EMP_EN_RATE     = 6.67;
//-------------------------ESR
float DAT_ESR_RL_RATE     = 0.1;
float DAT_ESR_RL_MAX      = 5;
float DAT_ESR_EN_RATE     = 6;
//-------------------------PAC
float DAT_PAC_RL_RATE     = 0.1;
float DAT_PAC_RL_MAX      = 8;
float DAT_PAC_EN_RATE     = 6.25;
//-------------------------Rocket
float DAT_MIS_RL_RATE     = 0.1;
float DAT_MIS_RL_MAX      = 8;
float DAT_MIS_EN_RATE     = 0;
//-------------------------Laser Missile
float DAT_MLGD_RL_RATE    = 0.1;
float DAT_MLGD_RL_MAX     = 6;
float DAT_MLGD_EN_RATE    = 0.1;
//-------------------------Radar Missile
float DAT_MARH_RL_RATE    = 0.1;
float DAT_MARH_RL_MAX     = 7;
float DAT_MARH_EN_RATE    = 0.2;
//-------------------------Swarm Missile
float DAT_SWRM_RL_RATE    = 0.1;
float DAT_SWRM_RL_MAX     = 10;
float DAT_SWRM_EN_RATE    = 0;
//====================================================================================
//            Damage  
//====================================================================================
//-------------------------ATC
float DAT_LATC_DMG        = 3.5;
//-------------------------RPlas
float DAT_RPLAS_DMG       = 20;
float DAT_RPLAS_DMG_BURN  = 0.5; 
//-------------------------QRifle
float DAT_QRFL_DMG        = 10;
//-------------------------SFGA
float DAT_SFGA_DMG        = 300;
//-------------------------FLAK
float DAT_FLAK_DMG        = 0.5;
float DAT_FLAK_SHRAP_TOTAL= 14;
//-------------------------Laser
float DAT_LAS_DMG         = 20;
//-------------------------ION
float DAT_ION_DMG         = 100;
//-------------------------EMP
float DAT_EMP_DMG         = 400;
//-------------------------ESR
float DAT_ESR_DMG         = 25;
//-------------------------PAC
float DAT_PAC_DMG         = 200;
//-------------------------Rocket
float DAT_MIS_DMG         = 75;
//-------------------------Laser Missile
float DAT_MLGD_DMG        = 275;
//-------------------------Radar Missile
float DAT_MARH_DMG        = 2; 
//-------------------------Swarm Missile
float DAT_SWRM_DMG        = 20;
float DAT_SWRM_CLUSTER    = 3;  //3 missiles per target
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
//-------------------------FLAK
float DAT_FLAK_SPR_X      = 4;
float DAT_FLAK_SPR_Y      = 2;
//-------------------------Laser

//-------------------------ION
float DAT_ION_SPR_X       = 4;
float DAT_ION_SPR_Y       = 4;

//-------------------------EMP

//-------------------------ESR
float DAT_ESR_SPR_X       = 6;
float DAT_ESR_SPR_Y       = 6;
//-------------------------PAC
float DAT_PAC_SPR_X       = 2;
float DAT_PAC_SPR_Y       = 2;
//-------------------------Rocket
float DAT_MIS_SPR_X       = 10;
float DAT_MIS_SPR_Y       = 3;
//-------------------------Laser Missile
//-------------------------Radar Missile
//-------------------------Swarm Missile
float DAT_SWRM_SPR_X       = 10;
float DAT_SWRM_SPR_Y       = 10;
//====================================================================================
//            Clipsize  
//====================================================================================
//-------------------------ATC
float DAT_LATC_CLIPSIZE     = 1;
//-------------------------FLAK
float DAT_FLAK_CLIPSIZE     = 4;
//-------------------------RPlas
float DAT_RPLAS_CLIPSIZE    = 8;
//-------------------------QRifle
float DAT_QRFL_CLIPSIZE     = 1;
//-------------------------SFGA
float DAT_SFGA_CLIPSIZE     = 1;
//-------------------------Laser
float DAT_LAS_CLIPSIZE      = 1;
//-------------------------ION
float DAT_ION_CLIPSIZE      = 3;
//-------------------------EMP
float DAT_EMP_CLIPSIZE      = 1;
//-------------------------ESR
float DAT_ESR_CLIPSIZE      = 20;
//-------------------------PAC
float DAT_PAC_CLIPSIZE      = 1;
//-------------------------Rocket
float DAT_MIS_CLIPSIZE      = 6;
//-------------------------Laser Missile
float DAT_MLGD_CLIPSIZE     = 1;
//-------------------------Radar Missile
float DAT_MARH_CLIPSIZE     = 15;
//-------------------------Swarm Missile
float DAT_SWRM_CLIPSIZE     = 3;
//============================
//            Tech Level  
//============================
//-------------------------ATC
float DAT_LATC_TECH_LEVEL   = 1;
//-------------------------RPlas
float DAT_RPLAS_TECH_LEVEL  = 3;
//-------------------------QRifle
float DAT_QRFL_TECH_LEVEL   = 2;
//-------------------------SFGA
float DAT_SFGA_TECH_LEVEL   = 2;
//-------------------------FLAK
float DAT_FLAK_TECH_LEVEL   = 1;
//-------------------------Laser
float DAT_LAS_TECH_LEVEL    = 1;
//-------------------------ION
float DAT_ION_TECH_LEVEL    = 1;
//-------------------------EMP
float DAT_EMP_TECH_LEVEL    = 1;
//-------------------------ESR
float DAT_ESR_TECH_LEVEL    = 2;
//-------------------------PAC
float DAT_PAC_TECH_LEVEL    = 3;
//-------------------------Rocket
float DAT_MIS_TECH_LEVEL    = 1;
//-------------------------Laser Missile
float DAT_MLGD_TECH_LEVEL   = 1;
//-------------------------Radar Missile
float DAT_MARH_TECH_LEVEL   = 2;
//-------------------------Swarm Missile
float DAT_SWRM_TECH_LEVEL   = 3;
//============================
//            Size  
//============================
//-------------------------ATC
float DAT_LATC_WSIZE      = 1;
//-------------------------FLAK
float DAT_FLAK_WSIZE      = 1;
//-------------------------RPlas
float DAT_RPLAS_WSIZE     = 2;
//-------------------------QRifle
float DAT_QRFL_WSIZE      = 1;
//-------------------------SFGA
float DAT_SFGA_WSIZE      = 3;
//-------------------------Laser
float DAT_LAS_WSIZE       = 1;
//-------------------------ION
float DAT_ION_WSIZE       = 2;
//-------------------------EMP
float DAT_EMP_WSIZE       = 3;
//-------------------------ESR
float DAT_ESR_WSIZE       = 2;
//-------------------------PAC
float DAT_PAC_WSIZE       = 3;
//-------------------------Rocket
float DAT_MIS_WSIZE       = 1;
//-------------------------Laser Missile
float DAT_MLGD_WSIZE      = 2;
//-------------------------Radar Missile
float DAT_MARH_WSIZE      = 3;
//-------------------------Radar Missile
float DAT_SWRM_WSIZE      = 2;
//============================
//            Sound Url
//============================
//-------------------------ATC
string DAT_LATC_FIRESOUND = "sound/weapons/atc_fire.ogg";
//-------------------------FLAK
string DAT_FLAK_FIRESOUND = "sound/weapons/atc_fire.ogg";
//-------------------------RPlas
string DAT_RPLAS_FIRESOUND = "sound/weapons/atc_fire.ogg";
//-------------------------QRifle
string DAT_QRFL_FIRESOUND = "sound/weapons/qrfl_fire.ogg";
//-------------------------SFGA
string DAT_SFGA_FIRESOUND = "sound/fx_boom.ogg";
//-------------------------Laser
string DAT_LAS_FIRESOUND = "sound/weapons/laser_fire.ogg";
//-------------------------ION
string DAT_ION_FIRESOUND = "sound/weapons/emp_fire.ogg";
//-------------------------EMP
string DAT_EMP_FIRESOUND = "sound/weapons/emp_fire.ogg";
//-------------------------ESR
string DAT_ESR_FIRESOUND = "sound/weapons/esr_fire.ogg";
//-------------------------PAC
string DAT_PAC_FIRESOUND = "sound/weapons/pac_fire.ogg";
//-------------------------Rocket
string DAT_MIS_FIRESOUND = "sound/weapons/mis_fire.ogg";
//-------------------------Laser Missile
string DAT_MLGD_FIRESOUND = "sound/weapons/mis_fire.ogg";
//-------------------------Radar Missile
string DAT_MARH_FIRESOUND = "sound/weapons/mis_fire.ogg";
//-------------------------Radar Missile
string DAT_SWRM_FIRESOUND = "sound/weapons/mis_fire.ogg";
//============================
//            Model  
//============================
//-------------------------ATC
string DAT_LATC_MODEL    = "q3mdl/weapons/w_atc.md3";
//-------------------------FLAK
string DAT_FLAK_MODEL    = "q3mdl/weapons/w_atc.md3";
//-------------------------RPlas
string DAT_RPLAS_MODEL   = "q3mdl/weapons/w_rpc.md3";
//-------------------------QRifle
string DAT_QRFL_MODEL    = "q3mdl/weapons/w_qrf.md3";
//-------------------------SFGA
string DAT_SFGA_MODEL    = "q3mdl/weapons/w_sfga.md3";
//-------------------------Laser
string DAT_LAS_MODEL     = "q3mdl/weapons/w_laser.md3";
//-------------------------ION
string DAT_ION_MODEL     = "q3mdl/weapons/w_emp.md3";
//-------------------------EMP
string DAT_EMP_MODEL     = "q3mdl/weapons/w_emp.md3";
//-------------------------ESR
string DAT_ESR_MODEL     = "q3mdl/weapons/w_esr.md3";
//-------------------------PAC
string DAT_PAC_MODEL     = "q3mdl/weapons/w_pac.md3";
//-------------------------Rocket
string DAT_MIS_MODEL     = "q3mdl/weapons/w_mis.md3";
//-------------------------Laser Missile
string DAT_MLGD_MODEL    = "q3mdl/weapons/w_lgm.md3";
//-------------------------Radar Missile
string DAT_MARH_MODEL    = "q3mdl/weapons/w_arh.md3";
//-------------------------Radar Missile
string DAT_SWRM_MODEL    = "q3mdl/weapons/w_arh.md3";
//============================
//            Icon  
//============================
//-------------------------ATC
string DAT_LATC_ICON    = "gfx/ui/wep_icons/wi_atc.png";
//-------------------------FLAK
string DAT_FLAK_ICON     = "gfx/ui/wep_icons/wi_flak.png";
//-------------------------RPlas
string DAT_RPLAS_ICON    = "gfx/ui/wep_icons/wi_rpc.png";
//-------------------------QRifle
string DAT_QRFL_ICON     = "gfx/ui/wep_icons/wi_qrf.png";
//-------------------------SFGA
string DAT_SFGA_ICON     = "gfx/ui/wep_icons/wi_sfga.png";
//-------------------------Laser
string DAT_LAS_ICON      = "gfx/ui/wep_icons/wi_las.png";
//-------------------------ION
string DAT_ION_ICON      = "gfx/ui/wep_icons/wi_ion.png";
//-------------------------EMP
string DAT_EMP_ICON      = "gfx/ui/wep_icons/wi_emp.png";
//-------------------------ESR
string DAT_ESR_ICON      = "gfx/ui/wep_icons/wi_esr.png";
//-------------------------PAC
string DAT_PAC_ICON      = "gfx/ui/wep_icons/wi_pac.png";
//-------------------------Rocket
string DAT_MIS_ICON      = "gfx/ui/wep_icons/wi_rck.png";
//-------------------------Laser Missile
string DAT_MLGD_ICON     = "gfx/ui/wep_icons/wi_mlgd.png";
//-------------------------Radar Missile
string DAT_MARH_ICON     = "gfx/ui/wep_icons/wi_marh.png";
//-------------------------Radar Missile
string DAT_SWRM_ICON     = "gfx/ui/wep_icons/wi_swrm.png";
//============================
//            Model Offset 
//============================
//-------------------------ATC
vector DAT_LATC_FIRE_OFS    = '0 0 2';
//-------------------------ATC
vector DAT_FLAK_FIRE_OFS    = '0 0 2';
//-------------------------RPlas
vector DAT_RPLAS_FIRE_OFS   = '0 0 2';
//-------------------------QRifle
vector DAT_QRFL_FIRE_OFS    = '0 0 2';
//-------------------------SFGA
vector DAT_SFGA_FIRE_OFS    = '0 0 2';
//-------------------------Laser
vector DAT_LAS_FIRE_OFS     = '0 0 2';
//-------------------------ION
vector DAT_ION_FIRE_OFS     = '0 0 2';
//-------------------------EMP
vector DAT_EMP_FIRE_OFS     = '0 0 2';
//-------------------------ESR
vector DAT_ESR_FIRE_OFS     = '0 0 4';
//-------------------------PAC
vector DAT_PAC_FIRE_OFS     = '0 0 8';
//-------------------------Rocket
vector DAT_MIS_FIRE_OFS     = '0 0 2';
//-------------------------Laser Missile
vector DAT_MLGD_FIRE_OFS = '0 0 2';
//-------------------------Radar Missile
vector DAT_MARH_FIRE_OFS = '0 0 2';
//-------------------------Radar Missile
vector DAT_SWRM_FIRE_OFS = '0 0 2';
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
//-------------------------FLAK
float DAT_FLAK_PROJ_ID    = ID_PRJ_FLAK;
//-------------------------Laser

//-------------------------ION
float DAT_ION_PROJ_ID     = ID_PRJ_EMP;
//-------------------------EMP
float DAT_EMP_PROJ_ID     = ID_PRJ_EMP;
//-------------------------ESR

//-------------------------PAC

//-------------------------Rocket
float DAT_MIS_PROJ_ID     = ID_PRJ_MIS;
//-------------------------Laser Missile
float DAT_MLGD_PROJ_ID    = ID_PRJ_MLGD;
//-------------------------Radar Missile
float DAT_MARH_PROJ_ID    = ID_PRJ_MARH;
//-------------------------Radar Missile
float DAT_SWRM_PROJ_ID    = ID_PRJ_SWRM;