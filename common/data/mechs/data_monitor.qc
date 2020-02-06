/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Monitor
        Juggernaut Heavy
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_monitor_={

  self.data_idx = UID_MECH_monitor;  //
  self.vec_size = 3;  //
  self.vec_name = "Monitor";
 
  self.max_health = 1200;
  self.mins = '-26 -26 -44';
  self.maxs = '26 26 28';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 700;
  self.energyRate= 3;
  self.shieldMax = 300;
  self.shieldRate= 1.67;
  self.startupDelay = 9;
//=====================================
 
//RADAR================================
  self.radar_range = 750;
  self.w_firetime = 8;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_LOWTECH;
//=====================================

//SPEED================================
  self.data_speed_forward = 85;
  self.data_speed_strafe = 85;
  self.data_speed_backward = 85;
  self.data_speed_accel = 2;
  #ifndef CSQC
  self.yaw_speed = 1;    //AI-only 
  self.turret_yaw_speed = 1;//AI-only
  self.ai_angleLimits = '-75 75 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  
  //center torso
  data_ini_torso_center_(  "q3mdl/mechs/monitor/monitor_tor_c.md3", 1300, '0 0 0', '0 6 0' );
 
  //left tors
  data_ini_torso_left_( "q3mdl/mechs/monitor/monitor_tor_l.md3", 1300, '-11.5 11 -0.5', '-9.5 11 0' );
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/monitor/monitor_tor_r.md3", 1300, '11.5 11 -0.5', '8.5 11 0' );
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/monitor/monitor_arm_l.md3", 1100, '-18 9 3.5', '-16 9 0' );
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/monitor/monitor_arm_r.md3", 1100, '18 9 3.5', '16 9 0' );
   
  //legs
  data_ini_legs_( "q3mdl/mechs/monitor/monitor_legs.md3", 1500, '0 -22 0' );
  
  //camera location
  data_ini_camera_( '0 18 8', self.torsoCenter );
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '22 2 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '15 3 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_ARM_LEFT, '-22 2 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-15 3 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '9.45 15.9 6', '0 0 0', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_6( M_TOR_LEFT, '-9.45 15.9 6', '0 0 0', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 5 5.5', '0 0 0', 3, DMG_EXP);
  data_ini_unitHardpoint_8( M_TOR_RIGHT, '9 6 4.5', '0 0 0', 3, (DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_9( M_TOR_LEFT, '-9 6 4.5', '0 0 0', 3, (DMG_EXP | DMG_MSC));
//=====================================

//HUD Data=============================
  self.pitchMax = 45;
  self.pitchMin = -25;
  self.weaponmodel = "q3mdl/mechs/monitor/monitor_hud.md3";
  self.hud_model = "q3mdl/mechs/monitor/monitor_hud.obj";
  self.hud_rollangle = "2.25";
  self.hud_bob = "0.03";
  self.hud_bob_cycle =  "0.85";
  self.hud_bob_up = "0.5";
  self.hud_bob_model = "1";
  self.hud_bob_side = "0.65";
  self.hud_bob_speed = "3.85";
//====================================

//UI Data=============================
  #ifdef CSQC
  self.abbrev = "MNT";
  self.description = "The great cities of the Federation owe their foundations to the power of the MONITOR. The MONITOR started life as a construction and logistics vehicle used in the civilian markets. | | The MONITOR has taken to its new life as a combat unit fairly well. Being a construction unit gives the MONITOR some of the best armor and structure of any mech. It also allows the MONITOR to carry a large array of weapons and equipment. | | All of this comes at a large cost, unfortunately. The Monitor is the slowest mech on the battlefield, and its reactor capacity is incredibly small.";
  self.icon = "gfx/ui/mech_icons/icon_monitor.png";
  #endif
//====================================
};
