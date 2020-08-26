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

  self.data_idx = UID_MECH_monitor;
  self.vec_size = 3;
  self.vec_name = "Monitor";
 
  self.max_health = 864;
  self.mins = '-22 -22 -44';
  self.maxs = '22 22 24';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 600;
  self.energyRate= 3.85;
  self.shieldMax = 375;
  self.shieldRate= 2.75;
  self.startupDelay = 9;
  self.evasionDrain = 1.4;
//=====================================
 
//RADAR================================
  self.radar_range = 1400;
  self.w_firetime = 3;  // lock-on time in seconds
  self.spreadDefault = ACCURACY_LOWTECH;
//=====================================

//SPEED================================
  self.data_speed_forward = 90; //85
  self.data_speed_strafe = 90; //85
  self.data_speed_backward = 90; //85
  self.data_speed_accel = 2;
  self.ramUpMax = 2;
  self.ramCooldown = 2;
#ifdef CSQC
  self.legMoveRate = 8;
  self.legRunRate = 12;
#endif
#ifndef CSQC
  self.yaw_speed = 2;    // AI-only 
  self.turret_yaw_speed = 3;// AI-only
  self.ai_angleLimits = '-150 150 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.005;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "q3mdl/mechs/monitor/monitor_tor_c.md3", 864, '0 0 0', '0 6 0' );
 
  //left tors
  data_ini_torso_left_( "q3mdl/mechs/monitor/monitor_tor_l.md3", 800, '-11.5 11 -0.5', '-9.5 11 0' );
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/monitor/monitor_tor_r.md3", 800, '11.5 11 -0.5', '8.5 11 0' );
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/monitor/monitor_arm_l.md3", 897, '-16 17 -1', '-16 9 0' );
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/monitor/monitor_arm_r.md3", 897, '16 17 -1', '16 9 0' );
   
  //legs
  data_ini_legs_( "q3mdl/mechs/monitor/monitor_legs.md3", 1197, '0 -22 0' );
  
  //camera location
#ifdef CSQC
  data_ini_camera_( '0 18 18', self.torsoCenter );
#else
  data_ini_camera_( '0 18 8', self.torsoCenter );
#endif
//=====================================
 
//HARDPOINT DATA======================
#ifndef CSQC
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '22 2 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '15 3 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_ARM_LEFT, '-22 2 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-15 3 10', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '9.45 15.9 6', '0 0 0', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_6( M_TOR_LEFT, '-9.45 15.9 6', '0 0 0', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 5 5.5', '0 0 0', 3, DMG_EXP);
  data_ini_unitHardpoint_8( M_TOR_RIGHT, '9 6 4.5', '0 0 0', 3, (DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_9( M_TOR_LEFT, '-9 6 4.5', '0 0 0', 3, (DMG_EXP | DMG_MSC));
#endif
#ifdef CSQC
  
  //client arms can aim up and down, so we bolt the weapons directly to the parent
  //bad, late-in-the-game hack frauds
  //see predraw_player_weapon()
  if((self.flags&FL_CLIENT)){
    data_ini_unitHardpoint_1( M_ARM_RIGHT, '5 -14 10', '0 0 0', (BAL1|ENE1), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_2( M_ARM_RIGHT, '-0.5 -14 10', '0 0 0', (BAL1|BAL2|ENE1|ENE2), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_3( M_ARM_LEFT, '-5 -14 10', '0 0 0', (BAL1|ENE1), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_4( M_ARM_LEFT, '0.5 -14 10', '0 0 0', (BAL1|BAL2|ENE1|ENE2), (DMG_BAL | DMG_ENE));
  }
  else{
    data_ini_unitHardpoint_1( M_ARM_RIGHT, '22 2 10', '0 0 0', (BAL1|ENE1), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_2( M_ARM_RIGHT, '15 3 10', '0 0 0', (BAL1|BAL2|ENE1|ENE2), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_3( M_ARM_LEFT, '-22 2 10', '0 0 0', (BAL1|ENE1), (DMG_BAL | DMG_ENE));
    data_ini_unitHardpoint_4( M_ARM_LEFT, '-15 3 10', '0 0 0', (BAL1|BAL2|ENE1|ENE2), (DMG_BAL | DMG_ENE));
  }
  
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '9.45 15.9 4.5', '0 0 0', (BAL1|ENE1|BAL2|ENE1|ENE2|ENE3|BAL3|MIS1|MIS3|MSC1|MSC2|MSC3), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_6( M_TOR_LEFT, '-9.45 15.9 4.5', '0 0 0', (BAL1|ENE1|BAL2|ENE1|ENE2|ENE3|BAL3|MIS1|MIS3|MSC1|MSC2|MSC3), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 5 6', '0 0 0', (BAL1|BAL2|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4), (DMG_BAL | DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_8( M_TOR_RIGHT, '9 6 5', '0 0 0', (BAL1|BAL2|BAL3|BAL4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_9( M_TOR_LEFT, '-9 6 5', '0 0 0', (BAL1|BAL2|BAL3|BAL4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
#endif
//=====================================

//HUD Data=============================
#ifndef CSQC
  self.weaponmodel = "q3mdl/mechs/monitor/monitor_hud.md3";
  self.hud_model = "q3mdl/mechs/monitor/monitor_hud.obj";
#endif
#ifdef CSQC
  self.pitchMax = 45;
  self.pitchMin = -25;
  self.hud_rollangle = 2.75;
  self.hud_bob = 0.05;
  self.hud_bob_cycle = 0.65;
  self.hud_bob_up = 0.35;
  self.hud_bob_model = 1;
  self.hud_bob_side = 0.4;
  self.hud_bob_speed = 3.85;
  self.hud_bob_model_up = 0.15;
//====================================

//UI Data=============================
  self.abbrev = "MNT";
  self.description = "The great cities of the Federation owe their foundations to the power of the MONITOR. The MONITOR started life as a construction and logistics vehicle used in the civilian markets. | | The MONITOR has taken to its new life as a combat unit fairly well. Being a construction unit gives the MONITOR some of the best armor and structure of any mech. It also allows the MONITOR to carry a large array of weapons and equipment. | | All of this comes at a large cost, unfortunately. The Monitor is the slowest mech on the battlefield, and its reactor capacity is incredibly small.";
  self.icon = "gfx/ui/mech_icons/icon_monitor.png";
  //ui offsets for hangar, not pretty
  local entity hardpnt;
  hardpnt = self.w_slot;
  hardpnt.uiOffset = '110 40'; //#1
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '80 40'; //#2
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-110 40';//#3
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-80 40';//#4
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '50 -35'; //#5
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-50 -35'; //#6
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset =  '0 30'; //#7
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '50 25'; //#8
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-50 25'; //#9
#endif
//====================================
};
#ifdef CSQC
//oh the things done because csqc interpolation isn't a thing.
//simply syncs 
void() data_ini_monitor_offsets={
  self.centerTorso = '0 0 0';
  self.leftTorso = '-11.5 11 -0.5';
  self.rightTorso = '11.5 11 -0.5';
  self.leftArm = '-18 9 3.5';
  self.rightArm = '18 9 3.5';
  self.leg = '0 -22 0';
};
#endif