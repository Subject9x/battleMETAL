/*
battleMETAL
Author: Peter Roohr
Date: 05/23/2019
Overview:
    Data File - Unit - Mech
        Balaket
        Light Skirmisher Mech.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_balaket_={
  
  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_MECH_balaket;
  self.vec_size = 1;
  self.vec_name = "Balaket";
  
  //Center Torso Health / player central health.
  self.max_health = 500;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -35';
  self.maxs = '18 18 16';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 4.0;
  self.shieldMax = 400;
  self.shieldRate = 3;
  self.startupDelay = 5;
  self.evasionDrain = 2.85;
//=====================================
 
//RADAR================================
  self.radar_range = 1600;
  self.w_firetime = 4;  // lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 185.0;
  self.data_speed_strafe = 120.0;
  self.data_speed_backward = 90.0;
  self.data_speed_accel = 2.0;
  self.ramUpMax = 2;
  self.ramCooldown = 6;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 9.5;
  self.legRunRate = 12;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_SKIRMISH;
  self.yaw_speed = 5;
  self.turret_yaw_speed = 4.25;
  self.ai_angleLimits = '-175 175 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.025;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================

  //center torso
  data_ini_torso_center_( "q3mdl/mechs/balaket/balaket_tor_c.md3", 500, '0 0 0', '0 3 0' );
 
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/balaket/balaket_tor_l.md3", 375, '-7.5 5.5 -2.5', '-5.5 5.5 0');
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/balaket/balaket_tor_r.md3", 375, '7.5 5.5 -2.5', '5.5 5.5 0');
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/balaket/balaket_arm_l.md3", 350, '-10 7 -3', '-10.1 3.5 0');
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/balaket/balaket_arm_r.md3", 350, '10 7 -3', '10.1 3.5 0');
   
  //legs      
  data_ini_legs_( "q3mdl/mechs/balaket/balaket_legs.md3", 700, '0 -16 0');
  
  //camera location
#ifdef CSQC
  data_ini_camera_( '0 7 24', self.torsoCenter);
#else
  data_ini_camera_( '0 7 7', self.torsoCenter);
#endif
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 -90',(BAL1 | BAL2 | ENE1 | ENE2) );
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', (BAL1 | BAL2 | ENE1 | ENE2) );
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 0', (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-7.85 7.0 6.0', '0 0 0', MSC1 );
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '7.85 7.0 6.0', '0 0 0', (MSC1|MSC2|MSC3) );
//=====================================

//HUD DATA=============================
#ifdef CSQC
  self.weaponmodel = "q3mdl/mechs/balaket/balaket_view.obj";
  self.hud_model = "q3mdl/mechs/balaket/balaket_hud.obj";
  self.hud_StrutsOffset = '0 -1.5 -1';
  self.pitchMax = 30; //pitch down limit
  self.pitchMin = -35;//pitch up limit
  self.hud_rollangle = 4;
  self.hud_bob = 0.03;
  self.hud_bob_cycle = 0.5;
  self.hud_bob_up = 0.15;
  self.hud_bob_model = 1;
  self.hud_bob_side = 0.09;
  self.hud_bob_speed = 6;
  self.hud_bob_model_up = 0.1;
//====================================

//UI Data=============================
  self.abbrev = "BLK";
  self.description = "A primitive combat platform, BALAKETs come from the early days of the Federation. Originally billed as exploration vehicles, Federation Military found them able anti-partisan units. | | BALAKET units are best against other light and smaller targets. Their weapon mount limitations prevent them from engaging larger foes one-on-one. | | They are dangerous in packs though, their quick speed and variable-enough loadouts keeping singular targets distracted; unable to land that fatal blow.";
  self.icon = "gfx/ui/mech_icons/icon_balaket.png";
  
  //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
  local entity hardpnt;
  hardpnt = self.w_slot;
  hardpnt.uiOffset = '-85 25'; //#1
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '85 25'; //#2
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '12 -50';//#3
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-50 -18.0';//#4
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '50 -18.0'; //#5
//====================================
#endif
};