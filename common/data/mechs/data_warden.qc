/*
battleMETAL
Author: Peter Roohr
Date: 11/21/2021
Overview:
    Data File - Unit - Mech
        Warden
        anti-light hunter.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_warden_={

  self.data_idx = UID_MECH_balaket;
  self.vec_size = 1;
  self.vec_name = "Warden";
 
  self.max_health = 500;
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
  self.spreadDefault = ACCURACY_SKIRMISH;
//=====================================

//SPEED================================
  self.data_speed_forward = 185;
  self.data_speed_strafe = 120;
  self.data_speed_backward = 90;
  self.data_speed_accel = 2;
  self.ramUpMax = 2;
  self.ramCooldown = 6;
#ifdef CSQC
  self.legMoveRate = 9.5;
  self.legRunRate = 12;
#endif
#ifdef SSQC
  self.yaw_speed = 5;    // AI-only 
  self.turret_yaw_speed = 4.25;// AI-only
  self.ai_angleLimits = '-175 175 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.025;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================

  //center torso
  data_ini_torso_center_( "q3mdl/mechs/warden/balaket_tor_c.md3", 500, '0 0 0', '0 3 0' );
 
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/warden/balaket_tor_l.md3", 375, '-7.5 5.5 -2.5', '-5.5 5.5 0');
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/warden/balaket_tor_r.md3", 375, '7.5 5.5 -2.5', '5.5 5.5 0');
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/warden/balaket_arm_l.md3", 350, '-10 7 -3', '-10.1 3.5 0');
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/warden/balaket_arm_r.md3", 350, '10 7 -3', '10.1 3.5 0');
   
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
#ifdef SSQC
  data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 -90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 0', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-7.85 7.0 6.0', '0 0 0', 1, DMG_MSC );
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '7.85 7.0 6.0', '0 0 0', 2, DMG_MSC );
#endif
#ifdef CSQC
  //client arms can aim up and down, so we bolt the weapons directly to the parent
  //bad, late-in-the-game hack frauds
  //see predraw_player_weapon()
  if((self.flags&FL_CLIENT)){
    data_ini_unitHardpoint_1( M_ARM_LEFT, '-2 -6.25 4', '0 0 -90', (BAL1 | BAL2 | ENE1 | ENE2), (DMG_BAL | DMG_ENE) );
    data_ini_unitHardpoint_2( M_ARM_RIGHT, '2 -6.25 4', '0 0 90', (BAL1 | BAL2 | ENE1 | ENE2), (DMG_BAL | DMG_ENE) );
  }
  else{
    data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 -90', (BAL1 | BAL2 | ENE1 | ENE2), (DMG_BAL | DMG_ENE) );
    data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', (BAL1 | BAL2 | ENE1 | ENE2), (DMG_BAL | DMG_ENE) );
  }
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 0', (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-7.85 7.0 6.0', '0 0 0', MSC1, DMG_MSC );
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '7.85 7.0 6.0', '0 0 0', (MSC2|MSC3), DMG_MSC );
#endif
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
  self.abbrev = "WRD";
  self.description = "null";
  self.icon = "gfx/ui/mech_icons/icon_balaket.png";
  
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
#ifdef CSQC
//oh the things done because csqc interpolation isn't a thing.
//simply syncs 
void() data_ini_balaket_offsets={
  self.centerTorso = '0 0 0';
  self.leftTorso = '-7.5 5.5 -2.5';
  self.rightTorso = '7.5 5.5 -2.5';
  self.leftArm = '-12.1 3.5 -3';
  self.rightArm = '12.1 3.5 -3';
  self.leg = '0 -16 0';
};
#endif