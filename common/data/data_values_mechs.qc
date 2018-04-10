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
float ID_MCH_BALAKET = 1;
float SZ_MCH_BALAKET = 1;
//-------------------------MATOK------------------------
float ID_MCH_MATOK = 1;
float SZ_MCH_MATOK = 2;
//-------------------------MONITOR------------------------
float ID_MCH_MONITOR = 1;
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
float DAT_OTL_SHIELD_RATE   = 1;
//-------------------------MATOK------------------------
float DAT_MTK_SHIELD_MAX    = 425;
float DAT_MTK_SHIELD_RATE   = 0.75;
//-------------------------MONITOR------------------------
float DAT_MNT_SHIELD_MAX    = 600;
float DAT_MNT_SHIELD_RATE   = 0.35;
//============================
//            Energy  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_ENERGY_MAX    = 400;
float DAT_OTL_ENERGY_RATE   = 1;
//-------------------------MATOK------------------------
float DAT_MTK_ENERGY_MAX    = 800;
float DAT_MTK_ENERGY_RATE   = 3;
//-------------------------MONITOR------------------------
float DAT_MNT_ENERGY_MAX    = 1200;
float DAT_MNT_ENERGY_RATE   = 2;
//============================
//            Speed  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_M_FSPEED      = 200;
float DAT_OTL_M_SSPEED      = 175;
float DAT_OTL_M_BSPEED      = 150;
float DAT_OTL_M_ACCEL       = 1.75;
//-------------------------MATOK------------------------
float DAT_MTK_M_FSPEED      = 150;
float DAT_MTK_M_SSPEED      = 100;
float DAT_MTK_M_BSPEED      = 90;
float DAT_MTK_M_ACCEL       = 1.25;
//-------------------------MONITOR------------------------
float DAT_MNT_M_FSPEED      = 85;
float DAT_MNT_M_SSPEED      = 85;
float DAT_MNT_M_BSPEED      = 85;
float DAT_MNT_M_ACCEL       = 2;
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
//            Base Convergence
//============================
//-------------------------BALAKET------------------------
vector DAT_OTL_SPREAD_N = '4 4 0.1';
vector DAT_OTL_SPREAD_X = '8 8 0.1';
//-------------------------MATOK------------------------
vector DAT_MTK_SPREAD_N = '4 4 0.008';
vector DAT_MTK_SPREAD_X = '8 8 0.008';
//-------------------------MONITOR------------------------
vector DAT_MNT_SPREAD_N = '8 6 0.01';
vector DAT_MNT_SPREAD_X = '14 10 0.03';
//============================
//            Models  
//============================
//-------------------------BALAKET------------------------
string DAT_OTL_CPIT_MODEL   = "q3mdl/mechs/notl/mdl_blk_cpt.md3";
string DAT_OTL_CTOR_MODEL   = "q3mdl/mechs/notl/mdl_blk_t_cent.md3";
string DAT_OTL_LEG_MODEL    = "q3mdl/mechs/notl/mdl_blk_legs.md3";
string DAT_OTL_LTOR_MODEL   = "q3mdl/mechs/notl/mdl_blk_t_left.md3";
string DAT_OTL_RTOR_MODEL   = "q3mdl/mechs/notl/mdl_blk_t_right.md3";
string DAT_OTL_LARM_MODEL   = "q3mdl/mechs/notl/mdl_blk_l_arm.md3";
string DAT_OTL_RARM_MODEL   = "q3mdl/mechs/notl/mdl_blk_r_arm.md3";
string DAT_OTL_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------MATOK------------------------
string DAT_MTK_CPIT_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_cpt.md3";
string DAT_MTK_CTOR_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_t_cent.md3";
string DAT_MTK_LEG_MODEL    = "q3mdl/mechs/ntmk/mdl_mtk_legs.md3";
string DAT_MTK_LTOR_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_t_left.md3";
string DAT_MTK_RTOR_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_t_right.md3";
string DAT_MTK_LARM_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_l_arm.md3";
string DAT_MTK_RARM_MODEL   = "q3mdl/mechs/ntmk/mdl_mtk_r_arm.md3";
string DAT_MTK_CAM_MODEL    = "q3mdl/testball.md3";
//-------------------------MONITOR------------------------
string DAT_MNT_CPIT_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_cpt.md3";
string DAT_MNT_CTOR_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_t_cent.md3";
string DAT_MNT_LEG_MODEL    = "q3mdl/mechs/mnt/mdl_mnt_legs.md3";
string DAT_MNT_LTOR_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_t_left.md3";
string DAT_MNT_RTOR_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_t_right.md3";
string DAT_MNT_LARM_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_l_arm.md3";
string DAT_MNT_RARM_MODEL   = "q3mdl/mechs/mnt/mdl_mnt_r_arm.md3";
string DAT_MNT_CAM_MODEL    = "q3mdl/testball.md3";
//============================
//            Model Offsets 
//============================
//-------------------------BALAKET------------------------
vector DAT_OTL_LEG_OFFSET     = '0 -16 0';
vector DAT_OTL_LTOR_OFFSET    = '-7 5.5 -2';
vector DAT_OTL_RTOR_OFFSET    = '7 5.5 -2';
vector DAT_OTL_LARM_OFFSET    = '-11 7 -2';
vector DAT_OTL_RARM_OFFSET    = '11 7 -2';
vector DAT_OTL_CAM_OFFSET     = '0 6 7';
vector DAT_OTL_CAM_OFFSET_ALT = '0 1 0';
vector DAT_OTL_WEP1_OFFSET    = '-11 0.5 1.5';
vector DAT_OTL_WEP2_OFFSET    = '11 0.5 1.5';
vector DAT_OTL_WEP3_OFFSET    = '-2 10.5 0';
//-------------------------MATOK------------------------
vector DAT_MTK_LEG_OFFSET     = '0 -12 0';
vector DAT_MTK_LTOR_OFFSET    = '-10 12.25 1.5';
vector DAT_MTK_RTOR_OFFSET    = '10 12.25 1.5';
vector DAT_MTK_LARM_OFFSET    = '-15 11 0';
vector DAT_MTK_RARM_OFFSET    = '15 11 0';
vector DAT_MTK_CAM_OFFSET     = '0 14 7';
vector DAT_MTK_CAM_OFFSET_ALT = '0 1 0';
vector DAT_MTK_WEP1_OFFSET    = '9.25 8.25 9';
vector DAT_MTK_WEP2_OFFSET    = '-9.25 8.25 9';
vector DAT_MTK_WEP3_OFFSET    = '19 2.5 2.25';
vector DAT_MTK_WEP4_OFFSET    = '-19 2.5 2.25';
vector DAT_MTK_WEP5_OFFSET    = '0 20 0';
//-------------------------MONITOR------------------------
vector DAT_MNT_LEG_OFFSET     = '0 -22 0';
vector DAT_MNT_LTOR_OFFSET    = '-11.5 15.5 0';
vector DAT_MNT_RTOR_OFFSET    = '11.5 15.5 0';
vector DAT_MNT_LARM_OFFSET    = '-18 13 -1';
vector DAT_MNT_RARM_OFFSET    = '18 13 -1';
vector DAT_MNT_CAM_OFFSET     = '0 17 8';
vector DAT_MNT_CAM_OFFSET_ALT = '0 1 0';
vector DAT_MNT_WEP1_OFFSET    = '1.5 2 10';
vector DAT_MNT_WEP2_OFFSET    = '-1.5 2 10';
vector DAT_MNT_WEP3_OFFSET    = '-1.5 2 10';
vector DAT_MNT_WEP4_OFFSET    = '1.5 2 10';
vector DAT_MNT_WEP5_OFFSET    = '-2 15.5 6';
vector DAT_MNT_WEP6_OFFSET    = '2 15.5 6';
vector DAT_MNT_WEP7_OFFSET    = '0 5 6';
vector DAT_MNT_WEP8_OFFSET    = '9 6 4';
vector DAT_MNT_WEP9_OFFSET    = '-9 6 4';
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
float DAT_BLK_HARDPOINT3_TYPES = 7;
//-------------------------MATOK
float DAT_MTK_HARDPOINT1_TYPES = 3;
float DAT_MTK_HARDPOINT2_TYPES = 3;
float DAT_MTK_HARDPOINT3_TYPES = 3;
float DAT_MTK_HARDPOINT4_TYPES = 3;
float DAT_MTK_HARDPOINT5_TYPES = 7;
//-------------------------MONITOR
float DAT_MNT_HARDPOINT1_TYPES = 3;
float DAT_MNT_HARDPOINT2_TYPES = 3;
float DAT_MNT_HARDPOINT3_TYPES = 3;
float DAT_MNT_HARDPOINT4_TYPES = 3;
float DAT_MNT_HARDPOINT5_TYPES = 3;
float DAT_MNT_HARDPOINT6_TYPES = 3;
float DAT_MNT_HARDPOINT7_TYPES = 4;
float DAT_MNT_HARDPOINT8_TYPES = 4;
float DAT_MNT_HARDPOINT9_TYPES = 4;
//============================
//            Tech level  
//============================
//-------------------------BALAKET------------------------
float DAT_OTL_TECH_LEVEL = 1;
//-------------------------MATOK------------------------
float DAT_MTK_TECH_LEVEL = 2;
//-------------------------MONITOR------------------------
float DAT_MNT_TECH_LEVEL = 1;