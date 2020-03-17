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

  self.data_idx = UID_MECH_balaket;
  self.vec_size = 1;
  self.vec_name = "Balaket";
 
  self.max_health = 500;
  self.mins = '-18 -18 -35';
  self.maxs = '18 18 16';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 4.0;
  self.shieldMax = 400;
  self.shieldRate= 3;
  self.startupDelay = 5;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 4.5;  // lock-on time in seconds
  self.spreadDefault = ACCURACY_SKIRMISH;
//=====================================

//SPEED================================
  self.data_speed_forward = 225;
  self.data_speed_strafe = 175;
  self.data_speed_backward = 150;
  self.data_speed_accel = 1.5;
  #ifndef CSQC
  self.yaw_speed = 3.75;    // AI-only 
  self.turret_yaw_speed = 4.25;// AI-only
  self.ai_angleLimits = '-135 135 0';
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
  data_ini_arm_left_( "q3mdl/mechs/balaket/balaket_arm_l.md3", 350, '-12.1 3.5 -3', '-10.1 3.5 0');
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/balaket/balaket_arm_r.md3", 350, '12.1 3.5 -3', '10.1 3.5 0');
   
  //legs      
  data_ini_legs_( "q3mdl/mechs/balaket/balaket_legs.md3", 700, '0 -16 0');
  
  //camera location
  data_ini_camera_( '0 7 7', self.torsoCenter);
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 -90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 0', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC) );
//=====================================

//HUD DATA=============================
  self.pitchMax = 30; //pitch down limit
  self.pitchMin = -35;//pitch up limit
  self.weaponmodel = "q3mdl/mechs/balaket/balaket_view.md3";
  self.hud_model = "q3mdl/mechs/balaket/balaket_hud.obj";
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
  #ifdef CSQC
  self.abbrev = "BLK";
  self.description = "A primitive combat platform, BALAKETTs come from the early days of the Federation. Originally billed as exploration vehicles, Federation Military found them able anti-partisan units. | | BALAKETT units are best against other light and smaller targets. Their weapon mount limitations prevent them from engaging larger foes one-on-one. | | They are dangerous in packs though, their quick speed and variable-enough loadouts keeping singular targets distracted; unable to land that fatal blow.";
  self.icon = "gfx/ui/mech_icons/icon_balaket.png";
  #endif
//====================================
};
