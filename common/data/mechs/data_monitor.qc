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
  self.mins = '-22 -22 -44';
  self.maxs = '22 22 28';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 700;
  self.energyRate= 3;
  self.shieldMax = 600;
  self.shieldRate= 0.7;
//=====================================
 
//RADAR================================
  self.radar_range = 750;
  self.w_firetime = 8;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_LOWTECH;
//=====================================

//SPEED================================
  self.m_fspeed = 85;
  self.m_sspeed = 85;
  self.m_bspeed = 85;
  self.m_maccel = 2;
  self.yaw_speed = 1;    //AI-only 
  self.turret_yaw_speed = 1;//AI-only
//=====================================
 
//MECH COMPONENTS====================
  //camera location
  data_ini_camera_( '0 18 8' );
  
  //center torso
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/mechs/monitor/monitor_tor_c.md3", 1200, '0 0 0', self, torsoCenter);
 
  //left torso
  data_ini_unitPiece_( M_TOR_LEFT, "q3mdl/mechs/monitor/monitor_tor_l.md3", 1200, '-11.5 15.5 0', self, torsoLeft);
 
  //right torso
  data_ini_unitPiece_( M_TOR_RIGHT, "q3mdl/mechs/monitor/monitor_tor_r.md3", 1200, '11.5 15.5 0', self, torsoRight);
 
  //left arm
  data_ini_unitPiece_( M_ARM_LEFT, "q3mdl/mechs/monitor/monitor_arm_l.md3", 1000, '-18 13 -1', self.torsoLeft, armLeft);
 
  //right arm
  data_ini_unitPiece_( M_ARM_RIGHT, "q3mdl/mechs/monitor/monitor_arm_r.md3", 1000, '18 13 -1', self.torsoRight, armRight);
   
  //legs
  data_ini_unitPiece_( M_LEGS, "q3mdl/mechs/monitor/monitor_legs.md3", 1500, '0 -22 0', self, legs);
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '22 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '15 3 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_ARM_LEFT, '-22 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-15 3 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '9.45 15.9 6', '0 0 90', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_6( M_TOR_LEFT, '-9.45 15.9 6', '0 0 90', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 5 5.5', '0 0 90', 3, DMG_EXP);
  data_ini_unitHardpoint_8( M_TOR_RIGHT, '9 6 4.5', '0 0 90', 3, (DMG_EXP | DMG_EXP));
  data_ini_unitHardpoint_9( M_TOR_LEFT, '-9 6 4.5', '0 0 90', 3, (DMG_EXP | DMG_EXP));
//=====================================

//HUD Data=============================
  self.m_pitch_max = 45;  //DEBUG
  self.m_pitch_min = -25;
  self.weaponmodel = "q3mdl/mechs/monitor/monitor_hud.md3";
  self.m_rollangle = "2.25";
  self.m_bob = "0.03";
  self.m_bcycle =  "0.85";
  self.m_bup = "0.5";
  self.m_bmodel = "1";
  self.m_bside = "0.65";
  self.m_bobspd = "3.85";
//====================================

//UI Data=============================
  self.abbrev = "MNT";
  self.description = "The great cities of the Federation owe their foundations to the power of the MONITOR. The MONITOR started life as a construction and logistics vehicle used in the civilian markets. | | The MONITOR has taken to its new life as a combat unit fairly well. Being a construction unit gives the MONITOR some of the best armor and structure of any mech. It also allows the MONITOR to carry a large array of weapons and equipment. | | All of this comes at a large cost, unfortunately. The Monitor is the slowest mech on the battlefield, and its reactor capacity is incredibly small.~";
  self.icon = "gfx/ui/mech_icons/icon_monitor.png";

//====================================
};
