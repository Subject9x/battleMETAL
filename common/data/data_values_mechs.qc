/*
mech Mod
Author: Peter Roohr
Date: 1/2/2018
Overview: condensed data file for most mech values that are shared between 
server and client
*/

//============================
//            NAMES (client)           
//============================
string MCH_NAME_BLK = "Balaket";
string MCH_NAME_MTK = "Matok";
string MCH_NAME_MNT = "Monitor";

//============================
//            DATA ID's           
//============================
//-------------------------BALAKET------------------------
float ID_MCH_balaket = 1;
float SZ_MCH_BALAKET = 1;
//-------------------------MATOK------------------------
float ID_MCH_matok = 2;
float SZ_MCH_MATOK = 2;
//-------------------------MONITOR------------------------
float ID_MCH_monitor = 3;
float SZ_MCH_MONITOR = 3;

//============================
//            Health           
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_LEG_HP    = 700;
float DAT_OTL_CTOR_HP   = 500;
float DAT_OTL_LTOR_HP   = 375;
float DAT_OTL_RTOR_HP   = 375;
float DAT_OTL_LARM_HP   = 350;
float DAT_OTL_RARM_HP   = 350;
//-------------------------MATOK------------------------
float DAT_MTK_CTOR_HP   = 650;
float DAT_MTK_LEG_HP    = 900;
float DAT_MTK_LTOR_HP   = 600;
float DAT_MTK_RTOR_HP   = 600;
float DAT_MTK_LARM_HP   = 675;
float DAT_MTK_RARM_HP   = 675;
//-------------------------MONITOR------------------------
float DAT_MNT_CTOR_HP   = 1200;
float DAT_MNT_LEG_HP    = 1500;
float DAT_MNT_LTOR_HP   = 1200;
float DAT_MNT_RTOR_HP   = 1200;
float DAT_MNT_LARM_HP   = 1000;
float DAT_MNT_RARM_HP   = 1000;
//============================
//            Armor  ! NOT IMPLEMENTED !
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_LEG_ARMMAX    = 100;
float DAT_OTL_CTOR_ARMMAX   = 100;
float DAT_OTL_LTOR_ARMMAX   = 100;
float DAT_OTL_RTOR_ARMMAX   = 100;
float DAT_OTL_LARM_ARMMAX   = 100;
float DAT_OTL_RARM_ARMMAX   = 100;
//-------------------------MATOK------------------------
float DAT_MTK_CTOR_ARMMAX   = 100;
float DAT_MTK_RARM_ARMMAX   = 100;
float DAT_MTK_LARM_ARMMAX   = 100;
float DAT_MTK_RTOR_ARMMAX   = 100;
float DAT_MTK_LTOR_ARMMAX   = 100;
float DAT_MTK_LEG_ARMMAX    = 100;
//-------------------------MONITOR------------------------
float DAT_MNT_CTOR_ARMMAX   = 100;
float DAT_MNT_RARM_ARMMAX   = 100;
float DAT_MNT_LARM_ARMMAX   = 100;
float DAT_MNT_RTOR_ARMMAX   = 100;
float DAT_MNT_LTOR_ARMMAX   = 100;
float DAT_MNT_LEG_ARMMAX    = 100;
//============================
//            Shield  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_SHIELD_MAX    = 300;
float DAT_OTL_SHIELD_RATE   = 2;
//-------------------------MATOK------------------------
float DAT_MTK_SHIELD_MAX    = 425;
float DAT_MTK_SHIELD_RATE   = 1.5;
//-------------------------MONITOR------------------------
float DAT_MNT_SHIELD_MAX    = 600;
float DAT_MNT_SHIELD_RATE   = 0.7;
//============================
//            Energy  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_ENERGY_MAX    = 400;
float DAT_OTL_ENERGY_RATE   = 4;
//-------------------------MATOK------------------------
float DAT_MTK_ENERGY_MAX    = 800;
float DAT_MTK_ENERGY_RATE   = 5;
//-------------------------MONITOR------------------------
float DAT_MNT_ENERGY_MAX    = 700;
float DAT_MNT_ENERGY_RATE   = 3;
//============================
//            Speed  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_M_FSPEED      = 225;
float DAT_OTL_M_SSPEED      = 175;
float DAT_OTL_M_BSPEED      = 150;
float DAT_OTL_M_ACCEL       = 1.5;
float DAT_OTL_M_YAW         = 4;
//-------------------------MATOK------------------------
float DAT_MTK_M_FSPEED      = 150;
float DAT_MTK_M_SSPEED      = 100;
float DAT_MTK_M_BSPEED      = 90;
float DAT_MTK_M_ACCEL       = 1.5;
float DAT_MTK_M_YAW         = 2.5;
//-------------------------MONITOR------------------------
float DAT_MNT_M_FSPEED      = 85;
float DAT_MNT_M_SSPEED      = 85;
float DAT_MNT_M_BSPEED      = 85;
float DAT_MNT_M_ACCEL       = 2;
float DAT_MNT_M_YAW         = 1;
//============================
//            Radar Range and Lock-on Delay
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_RADAR_RANGE = 7000;
float DAT_OTL_LOCK = 6;
//-------------------------MATOK------------------------
float DAT_MTK_RADAR_RANGE = 5000;
float DAT_MTK_LOCK = 4;
//-------------------------MONITOR------------------------
float DAT_MNT_RADAR_RANGE = 3000;
float DAT_MNT_LOCK = 8;
//============================
//            HITBOX SIZES
//============================
//-------------------------BALAKET------------------------
vector DAT_OTL_CTOR_BBX_N ='-14 -14 -35';
vector DAT_OTL_CTOR_BBX_X ='14 14 16';
//-------------------------MATOK------------------------
vector DAT_MTK_CTOR_BBX_N ='-17 -17 -40';
vector DAT_MTK_CTOR_BBX_X ='17 17 22';
//-------------------------MONITOR------------------------
vector DAT_MNT_CTOR_BBX_N = '-22 -22 -44';
vector DAT_MNT_CTOR_BBX_X = '22 22 28';
//============================
//            Models  
//============================
//-------------------------BALAKET------------------------
string DAT_OTL_CPIT_MODEL   = "q3mdl/mechs/balaket/balaket_view.md3";
string DAT_OTL_CTOR_MODEL   = "q3mdl/mechs/balaket/balaket_tor_c.md3";
string DAT_OTL_LTOR_MODEL   = "q3mdl/mechs/balaket/balaket_tor_l.md3";
string DAT_OTL_RTOR_MODEL   = "q3mdl/mechs/balaket/balaket_tor_r.md3";
string DAT_OTL_LARM_MODEL   = "q3mdl/mechs/balaket/balaket_arm_l.md3";
string DAT_OTL_RARM_MODEL   = "q3mdl/mechs/balaket/balaket_arm_r.md3";
string DAT_OTL_LEG_MODEL    = "q3mdl/mechs/balaket/balaket_legs.md3";
string DAT_OTL_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------MATOK------------------------
string DAT_MTK_CPIT_MODEL   = "q3mdl/mechs/matok/matok_hud.md3";
string DAT_MTK_CTOR_MODEL   = "q3mdl/mechs/matok/matok_tor_c.md3";
string DAT_MTK_LEG_MODEL    = "q3mdl/mechs/matok/matok_legs.md3";
string DAT_MTK_LTOR_MODEL   = "q3mdl/mechs/matok/matok_tor_l.md3";
string DAT_MTK_RTOR_MODEL   = "q3mdl/mechs/matok/matok_tor_r.md3";
string DAT_MTK_LARM_MODEL   = "q3mdl/mechs/matok/matok_arm_l.md3";
string DAT_MTK_RARM_MODEL   = "q3mdl/mechs/matok/matok_arm_r.md3";
string DAT_MTK_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------MONITOR------------------------
string DAT_MNT_CPIT_MODEL   = "q3mdl/mechs/monitor/monitor_hud.md3";
string DAT_MNT_CTOR_MODEL   = "q3mdl/mechs/monitor/monitor_tor_c.md3";
string DAT_MNT_LEG_MODEL    = "q3mdl/mechs/monitor/monitor_legs.md3";
string DAT_MNT_LTOR_MODEL   = "q3mdl/mechs/monitor/monitor_tor_l.md3";
string DAT_MNT_RTOR_MODEL   = "q3mdl/mechs/monitor/monitor_tor_r.md3";
string DAT_MNT_LARM_MODEL   = "q3mdl/mechs/monitor/monitor_arm_l.md3";
string DAT_MNT_RARM_MODEL   = "q3mdl/mechs/monitor/monitor_arm_r.md3";
string DAT_MNT_CAM_MODEL    = "q3mdl/testball.md3";
//============================
//            Model Offsets 
//============================
//-------------------------BALAKET------------------------
vector DAT_OTL_LEG_OFFSET     = '0 -16 0';
vector DAT_OTL_LTOR_OFFSET    = '-7.5 5.5 -2.5';
vector DAT_OTL_RTOR_OFFSET    = '7.5 5.5 -2.5';
vector DAT_OTL_LARM_OFFSET    = '-12.1 7 -3';
vector DAT_OTL_RARM_OFFSET    = '12.1 7 -3';
vector DAT_OTL_CAM_OFFSET     = '0 6 7';
vector DAT_OTL_CAM_OFFSET_ALT = '0 1 0';
vector DAT_OTL_WEP1_OFFSET    = '-12.2 0.5 0.5';
vector DAT_OTL_WEP2_OFFSET    = '12.2 0.5 0.5';
vector DAT_OTL_WEP3_OFFSET    = '-2 10.5 0';
//-------------------------MATOK------------------------
vector DAT_MTK_LEG_OFFSET     = '0 -12 0';
vector DAT_MTK_LTOR_OFFSET    = '-10 12.25 1.5';
vector DAT_MTK_RTOR_OFFSET    = '10 12.25 1.5';
vector DAT_MTK_LARM_OFFSET    = '-15 11 0';
vector DAT_MTK_RARM_OFFSET    = '15 11 0';
vector DAT_MTK_CAM_OFFSET     = '0 14 7';
vector DAT_MTK_CAM_OFFSET_ALT = '0 1 0';
vector DAT_MTK_WEP1_OFFSET    = '9.25 8.65 10';
vector DAT_MTK_WEP2_OFFSET    = '-9.25 8.65 10';
vector DAT_MTK_WEP3_OFFSET    = '19.25 2.1 2.25';
vector DAT_MTK_WEP4_OFFSET    = '-19.25 2.1 2.25';
vector DAT_MTK_WEP5_OFFSET    = '0 20 0';
//-------------------------MONITOR------------------------
vector DAT_MNT_LEG_OFFSET     = '0 -22 0';
vector DAT_MNT_LTOR_OFFSET    = '-11.5 15.5 0';
vector DAT_MNT_RTOR_OFFSET    = '11.5 15.5 0';
vector DAT_MNT_LARM_OFFSET    = '-18 13 -1';
vector DAT_MNT_RARM_OFFSET    = '18 13 -1';
vector DAT_MNT_CAM_OFFSET     = '0 17 8';
vector DAT_MNT_CAM_OFFSET_ALT = '0 1 0';
vector DAT_MNT_WEP1_OFFSET    = '18.85 2 10';
vector DAT_MNT_WEP2_OFFSET    = '16.25 2 10';
vector DAT_MNT_WEP3_OFFSET    = '-18.85 2 10';
vector DAT_MNT_WEP4_OFFSET    = '-16.25 2 10';
vector DAT_MNT_WEP5_OFFSET    = '-9.45 15.9 6';
vector DAT_MNT_WEP6_OFFSET    = '9.45 15.9 6';
vector DAT_MNT_WEP7_OFFSET    = '0 5 5.5';
vector DAT_MNT_WEP8_OFFSET    = '9 6 4.5';
vector DAT_MNT_WEP9_OFFSET    = '-9 6 4.5';
//============================
//            Hardpoint Totals 
//============================
//-------------------------BALAKET
float DAT_BLK_HARDPOINT_CNT = 3;
//-------------------------MATOK
float DAT_MTK_HARDPOINT_CNT = 5;
//-------------------------MONITOR
float DAT_MNT_HARDPOINT_CNT = 9;
//============================
//            Hardpoint Size 
//============================
//-------------------------BALAKET
float DAT_BLK_HARDPOINT1_SIZE = 1;
float DAT_BLK_HARDPOINT2_SIZE = 1;
float DAT_BLK_HARDPOINT3_SIZE = 3;
//-------------------------MATOK
float DAT_MTK_HARDPOINT1_SIZE = 1;
float DAT_MTK_HARDPOINT2_SIZE = 1;
float DAT_MTK_HARDPOINT3_SIZE = 2;
float DAT_MTK_HARDPOINT4_SIZE = 2;
float DAT_MTK_HARDPOINT5_SIZE = 3;
//-------------------------MONITOR
float DAT_MNT_HARDPOINT1_SIZE = 1;
float DAT_MNT_HARDPOINT2_SIZE = 1;
float DAT_MNT_HARDPOINT3_SIZE = 1;
float DAT_MNT_HARDPOINT4_SIZE = 1;
float DAT_MNT_HARDPOINT5_SIZE = 3;
float DAT_MNT_HARDPOINT6_SIZE = 3;
float DAT_MNT_HARDPOINT7_SIZE = 3;
float DAT_MNT_HARDPOINT8_SIZE = 3;
float DAT_MNT_HARDPOINT9_SIZE = 3;
//============================
//            Hardpoint Type
//============================
//-------------------------BALAKET
float DAT_BLK_HARDPOINT1_TYPES = 3;
float DAT_BLK_HARDPOINT2_TYPES = 3;
float DAT_BLK_HARDPOINT3_TYPES = 135; //7;
//-------------------------MATOK
float DAT_MTK_HARDPOINT1_TYPES = 3;
float DAT_MTK_HARDPOINT2_TYPES = 3;
float DAT_MTK_HARDPOINT3_TYPES = 3;
float DAT_MTK_HARDPOINT4_TYPES = 3;
float DAT_MTK_HARDPOINT5_TYPES = 135; //7;
//-------------------------MONITOR
float DAT_MNT_HARDPOINT1_TYPES = 3;
float DAT_MNT_HARDPOINT2_TYPES = 3;
float DAT_MNT_HARDPOINT3_TYPES = 3;
float DAT_MNT_HARDPOINT4_TYPES = 3;
float DAT_MNT_HARDPOINT5_TYPES = 3;
float DAT_MNT_HARDPOINT6_TYPES = 3;
float DAT_MNT_HARDPOINT7_TYPES = 4;//4;
float DAT_MNT_HARDPOINT8_TYPES = 132;
float DAT_MNT_HARDPOINT9_TYPES = 132;//4;
//============================
//            Tech level  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_TECH_LEVEL = 1;
//-------------------------MATOK------------------------
float DAT_MTK_TECH_LEVEL = 2;
//-------------------------MONITOR------------------------
float DAT_MNT_TECH_LEVEL = 1;