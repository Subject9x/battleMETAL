/*
mech Mod
Author: Peter Roohr
Date: 1/5/2018
Overview: condensed data file for most projectile values that are shared between 
server and client
*/

//============================
//            Game ID        
//============================
float ID_PRJ_LATC = 1;
float ID_PRJ_EMP = 2;
float ID_PRJ_MIS = 3;
float ID_PRJ_MLGD = 4;
float ID_PRJ_MARH = 5;
float ID_PRJ_RPLAS = 6;
float ID_PRJ_QRFL = 7;
float ID_PRJ_SFGA = 8;
float ID_PRJ_FLAK = 9;
float ID_PRJ_ION = 10;
float ID_PRJ_SWRM = 11;
//============================
//            Velocity         
//============================
//-------------------------EMP
float DAT_PRJ_EMP_VELOCITY = 1500;
//-------------------------ION
float DAT_PRJ_ION_VELOCITY = 4000;
//-------------------------MIS-ARH
float DAT_PRJ_MARH_VELOCITY = 650;
//-------------------------Rocket
float DAT_PRJ_MIS_VELOCITY = 1300;
//-------------------------MIS-LGD
float DAT_PRJ_MLGD_VELOCITY = 800;
//-------------------------QRifle
float DAT_PRJ_QRFL_VELOCITY = 200;
//-------------------------RPlas
float DAT_PRJ_RPLAS_VELOCITY = 1600;
//-------------------------SFGA
float DAT_PRJ_SFGA_VELOCITY = 1500;
//-------------------------FLAK
float DAT_PRJ_FLAK_VELOCITY = 4500;
//-------------------------SWARM
float DAT_PRJ_SWRM_VELOCITY = 1600;
//============================
//            lifetime           
//============================
//-------------------------EMP
float DAT_PRJ_EMP_LIFETIME = 1.6;
//-------------------------ION
float DAT_PRJ_ION_LIFETIME = 5; //was 4;
//-------------------------MIS-ARH
float DAT_PRJ_MARH_LIFETIME = 13;
//-------------------------Rocket
float DAT_PRJ_MIS_LIFETIME = 1.4;
//-------------------------MIS-LGD
float DAT_PRJ_MLGD_LIFETIME = 1.75;
//-------------------------QRifle
float DAT_PRJ_QRFL_LIFETIME = 4;
//-------------------------RPlas
float DAT_PRJ_RPLAS_LIFETIME = 1.558;
//-------------------------SFGA
float DAT_PRJ_SFGA_LIFETIME = 8;
//-------------------------FLAK
float DAT_PRJ_FLAK_LIFETIME = 4.8;
//-------------------------SWARM
float DAT_PRJ_SWRM_LIFETIME = 2.5;
//============================
//            radius           
//============================
//-------------------------EMP
float DAT_PRJ_EMP_PROXYRAD    = 200;
float DAT_PRJ_EMP_EXPRAD      = 300;
//-------------------------EMP
float DAT_PRJ_ION_PROXYRAD    = 200;
float DAT_PRJ_ION_EXPRAD      = 300;
//-------------------------MIS-ARH
//-------------------------Rocket
//-------------------------MIS-LGD
//-------------------------QRifle
//-------------------------RPlas
//-------------------------SFGA
float DAT_PRJ_SFGA_RAD        = 150;
//-------------------------FLAK
float DAT_PRJ_FLAK_PROXYRAD   = 45;
float DAT_PRJ_FLAK_EXPRAD     = 50;
//============================
//            Model           
//============================
//-------------------------EMP
string DAT_PRJ_EMP_MODEL    = "q3mdl/proj_emp.md3";
//-------------------------EMP
string DAT_PRJ_ION_MODEL    = "q3mdl/proj_emp.md3";
//-------------------------MIS-ARH
string DAT_PRJ_MARH_MODEL   = "q3mdl/proj_mis.md3";
//-------------------------Rocket
string DAT_PRJ_MIS_MODEL    = "q3mdl/proj_mis.md3";
//-------------------------MIS-LGD
string DAT_PRJ_MLGD_MODEL   = "q3mdl/proj_mis.md3";
//-------------------------QRifle
string DAT_PRJ_QRFL_MODEL   = "progs/casing.mdl";
//-------------------------RPlas
string DAT_PRJ_RPLAS_MODEL  = "progs/casing.mdl";
//-------------------------SFGA
string DAT_PRJ_SFGA_MODEL   = "progs/casing.mdl";
//-------------------------FLAK
string DAT_PRJ_FLAK_MODEL   = "progs/casing.mdl";
//-------------------------SWARM
string DAT_PRJ_SWRM_MODEL   = "q3mdl/proj_mis.md3";
//============================
//            Effects           
//============================
//-------------------------EMP
float DAT_PRJ_EMP_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_EMP_MODELFLAGS = MF_TRACER3;
float DAT_PRJ_EMP_ALPHA = 0.75;
vector DAT_PRJ_EMP_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_EMP_GLOWCOLOR = 255;
float DAT_PRJ_EMP_GLOWSIZE = 0.0005;
float DAT_PRJ_EMP_GLOWTRAIL= FALSE;
//-------------------------ION
float DAT_PRJ_ION_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_ION_MODELFLAGS = MF_TRACER3;
float DAT_PRJ_ION_ALPHA = 0.75;
vector DAT_PRJ_ION_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_ION_GLOWCOLOR = 255;
float DAT_PRJ_ION_GLOWSIZE = 0.0005;
float DAT_PRJ_ION_GLOWTRAIL= FALSE;
//-------------------------MIS-ARH
float DAT_PRJ_MARH_EFFECTS = 0;
float DAT_PRJ_MARH_MODELFLAGS = MF_ROCKET;
float DAT_PRJ_MARH_ALPHA = 1;
vector DAT_PRJ_MARH_COLORMOD = '0 0 0';
float DAT_PRJ_MARH_GLOWCOLOR = 0;
float DAT_PRJ_MARH_GLOWSIZE = 0;
float DAT_PRJ_MARH_GLOWTRAIL= FALSE;
//-------------------------Rocket
float DAT_PRJ_MIS_EFFECTS = 0;
float DAT_PRJ_MIS_MODELFLAGS = MF_ROCKET;
float DAT_PRJ_MIS_ALPHA = 1;
vector DAT_PRJ_MIS_COLORMOD = '0 0 0';
float DAT_PRJ_MIS_GLOWCOLOR = 0;
float DAT_PRJ_MIS_GLOWSIZE = 0;
float DAT_PRJ_MIS_GLOWTRAIL= FALSE;
//-------------------------MIS-LGD
float DAT_PRJ_MLGD_EFFECTS = 0;
float DAT_PRJ_MLGD_MODELFLAGS = MF_ROCKET;
float DAT_PRJ_MLGD_ALPHA = 1;
vector DAT_PRJ_MLGD_COLORMOD = '0 0 0';
float DAT_PRJ_MLGD_GLOWCOLOR = 0;
float DAT_PRJ_MLGD_GLOWSIZE = 0;
float DAT_PRJ_MLGD_GLOWTRAIL= FALSE;
//-------------------------QRifle
float DAT_PRJ_QRFL_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_QRFL_MODELFLAGS = MF_TRACER3;
float DAT_PRJ_QRFL_ALPHA = 0.75;
vector DAT_PRJ_QRFL_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_QRFL_GLOWCOLOR = 255;
float DAT_PRJ_QRFL_GLOWSIZE = 0.0005;
float DAT_PRJ_QRFL_GLOWTRAIL= FALSE;
//-------------------------RPlas
float DAT_PRJ_RPLAS_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_RPLAS_MODELFLAGS = MF_TRACER2;
float DAT_PRJ_RPLAS_ALPHA = 1;
vector DAT_PRJ_RPLAS_COLORMOD = '0.35 0.85 0.45';
float DAT_PRJ_RPLAS_GLOWCOLOR = 150;
float DAT_PRJ_RPLAS_GLOWSIZE = 0.1;
float DAT_PRJ_RPLAS_GLOWTRAIL= FALSE;
//-------------------------SFGA
float DAT_PRJ_SFGA_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_SFGA_MODELFLAGS = MF_GRENADE;
float DAT_PRJ_SFGA_ALPHA = 1;
vector DAT_PRJ_SFGA_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_SFGA_GLOWCOLOR = 240;
float DAT_PRJ_SFGA_GLOWSIZE = 0.005;
float DAT_PRJ_SFGA_GLOWTRAIL= FALSE;
//-------------------------FLAK
float DAT_PRJ_FLAK_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_FLAK_MODELFLAGS = MF_GRENADE;
float DAT_PRJ_FLAK_ALPHA = 1;
vector DAT_PRJ_FLAK_COLORMOD = '0.1 0.1 0.1';
float DAT_PRJ_FLAK_GLOWCOLOR = 240;
float DAT_PRJ_FLAK_GLOWSIZE = 0.005;
float DAT_PRJ_FLAK_GLOWTRAIL= FALSE;
//-------------------------Swarm
float DAT_PRJ_SWRM_EFFECTS = 0;
float DAT_PRJ_SWRM_MODELFLAGS = MF_ROCKET;
float DAT_PRJ_SWRM_ALPHA = 1;
vector DAT_PRJ_SWRM_COLORMOD = '0 0 0';
float DAT_PRJ_SWRM_GLOWCOLOR = 0;
float DAT_PRJ_SWRM_GLOWSIZE = 0;
float DAT_PRJ_SWRM_GLOWTRAIL= FALSE;