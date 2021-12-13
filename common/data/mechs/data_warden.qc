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
  
  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  
  self.data_idx = UID_MECH_warden;
  
  self.vec_size = 1;
  self.vec_name = "Warden";
  
  //Center Torso Health / player central health.
  self.max_health = 575;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-16 -16 -32';
  self.maxs = '16 16 14';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 4.0;
  self.shieldMax = 250;
  self.shieldRate = 2;
  self.startupDelay = 6;
  self.evasionDrain = 3;
//=====================================
 
//RADAR================================
  self.radar_range = 2000;
  self.w_firetime = 3;  // lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 165.0;
  self.data_speed_strafe = 165.0;
  self.data_speed_backward = 165.0;
  self.data_speed_accel = 1.33;
  self.ramUpMax = 3;
  self.ramCooldown = 8;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 12;
  self.legRunRate = 14;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_SKIRMISH;
  self.yaw_speed = 4;
  self.turret_yaw_speed = 4.75;
  self.ai_angleLimits = '-215 215 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.025;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================

  //center torso
  data_ini_torso_center_( "q3mdl/mechs/warden/warden_tor_c.md3", 575, '0 0 0', '0 3 0' );
 
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/warden/warden_tor_l.md3", 450, '-3.9 8.5 -3', '-8.4 8.5 -3');
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/warden/warden_tor_r.md3", 450, '3.9 8.5 -3', '8.4 8.5 -3');
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/warden/warden_arm_r.md3", 400, '-14 7.5 -3', '-15 6.5 -3');
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/warden/warden_arm_r.md3", 400, '14 7.5 -3', '-15 6.5 -3');
   
  //legs      
  data_ini_legs_( "q3mdl/mechs/warden/warden_legs.md3", 800, '0 0 0');
  
  //camera location
#ifdef CSQC
  data_ini_camera_( '0 8 14', self.torsoCenter);
#else
  data_ini_camera_( '0 8 7', self.torsoCenter);
#endif
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '7.25 3 -0.5', '0 0 0', (BAL2|BAL3|BAL4|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC2|MSC3|MSC4));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-5.7 2.9 1', '0 0 0', (BAL1|ENE1));
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-7.5 2.9 1', '0 0 0', (BAL1|ENE1));
  data_ini_unitHardpoint_4( M_TOR_RIGHT, '6.4 10.5 -0.5', '0 0 0', (BAL1|ENE1|MIS1|MSC1));
  data_ini_unitHardpoint_5( M_TOR_LEFT, '-10 10.8 -2', '0 0 0', (MIS1|MIS2|MIS3|MIS4|MSC2|MSC3|MSC4));
//=====================================


//HUD DATA=============================
#ifdef CSQC
  self.weaponmodel = "q3mdl/mechs/warden/warden_view.obj";
  self.hud_model = "q3mdl/mechs/balaket/balaket_hud.obj";
  self.hud_StrutsOffset = '0 -1.5 -1';
  self.pitchMax = 25; //pitch down limit
  self.pitchMin = -28;//pitch up limit
  self.hud_rollangle = 4;
  self.hud_bob = 0.03;
  self.hud_bob_cycle = 0.5;
  self.hud_bob_up = 0.20; //0.15
  self.hud_bob_model = 1;
  self.hud_bob_side = 0.09;
  self.hud_bob_speed = 6;
  self.hud_bob_model_up = 0.1;
//====================================

//UI Data=============================
  self.abbrev = "WRD";
  self.description = "MILITAR burned out their best hackers on black ICE breaking into a salvaged Federation data core. Amongst the encrypted modules was blueprints for a highly advanced light metal - the WARDEN. | | Tech degradation after the toppling of the Federation meant that MILITAR could not create a perfect copy...but they tried anyway. | | The result is a tough-as-nails light metal. It is not the fastest metal on the planet, but well-protected hardpoints and fast enough movement allow the WARDEN to stay out of most trouble. | | BALAKET pilots have a particular disdain for WARDEN units, frustrated that their vaunted hit-and-run style won`t take a WARDEN down quickly.";
  self.icon = "gfx/ui/mech_icons/icon_warden.png";

  //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
  local entity hardpnt;
  hardpnt = self.w_slot;
  hardpnt.uiOffset = '-50 20'; //#1
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '40 20'; //#2
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '75 20';//#3
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-45 -24.0';//#4
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '65 -24.0'; //#5
//====================================
#endif
};