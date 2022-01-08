/*
battleMETAL
Author: Peter Roohr
Date: 11/01/2021
Overview:
    Data File - Unit - Mech
        Sapper
        Medium harasser.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_sapper_={

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_MECH_sapper;
  self.vec_size = 2;
  self.vec_name = "Sapper";
  
  //Center Torso Health / player central health.
  self.max_health = 650;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -34.75';
  self.maxs = '18 18 22';
  
//ENERGY AND SHIELDS===================
  self.energyMax   = 500;
  self.energyRate  = 5.25;
  self.shieldMax   = 800;
  self.shieldRate  = 4.0;
  self.startupDelay = 8;
  self.evasionDrain = 4.5;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 1.33;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 125.0;
  self.data_speed_strafe = 105.0;
  self.data_speed_backward = 100.0;
  self.data_speed_accel = 2.25;
  self.ramUpMax = 1.75;
  self.ramCooldown = 3;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 10;
  self.legRunRate = 14;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_MARKSMAN;
  self.yaw_speed = 2.5;
  self.turret_yaw_speed = 3.33;
  self.ai_angleLimits = '-120 120 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.007;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "q3mdl/mechs/sapper/sapper_tor_c.md3", 575, '0 0 0', '0 6 0' );
  
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/sapper/sapper_tor_l.md3", 500, '-6.3 9.5 -2', '-8 12.25 0' );
  
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/sapper/sapper_tor_r.md3", 500, '6.3 9.5 -2', '8 12.25 0' );
  
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/sapper/sapper_arm_l.md3", 450, '-10.5 10 -2', '-14 7 0' );
  
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/sapper/sapper_arm_r.md3", 450, '10.5 10 -2', '14 7 0' );
  
  //legs
  data_ini_legs_( "q3mdl/mechs/sapper/sapper_legs.md3", 650, '0 0 0.5' );
  
  //camera location
  #ifdef CSQC
    data_ini_camera_( '0 13 8', self.torsoCenter);
  #else
    data_ini_camera_( '0 13 2', self.torsoCenter);
  #endif
  
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '12.5 0 5', '0 0 0',       (BAL1|ENE1|MIS1) );
  data_ini_unitHardpoint_2( M_ARM_LEFT, '-12.5 0 5', '0 0 0',      (BAL1|ENE1|MIS1) );
  data_ini_unitHardpoint_3( M_TOR_RIGHT, '8.35 14.75 -1', '0 0 0',  (BAL2|BAL3|MIS1|MIS2|MIS3|ENE3) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-8.35 14.75 -1', '0 0 0',(BAL2|BAL3|MIS1|MIS2|MIS3|ENE3));
  data_ini_unitHardpoint_5( M_TOR_CENTER, '3.35 5.5 3', '0 0 0',    (MSC1|MSC2) );
  data_ini_unitHardpoint_6( M_TOR_CENTER, '3.35 8.5 3', '0 0 0',    (MSC1|MSC3|MIS2));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '-3.35 5.5 3', '0 0 0',   (MSC1|MSC2) );
  data_ini_unitHardpoint_8( M_TOR_CENTER, '-3.35 8.5 3', '0 0 0',   (MSC1|MSC3|MIS4));
//=====================================

//HUD Data=============================
#ifdef CSQC
  self.weaponmodel = "q3mdl/mechs/sapper/sapper_view.obj";
  self.hud_model = "q3mdl/mechs/sapper/sapper_hud.obj";
  self.hud_StrutsOffset = '0 -2 -0.75';
  self.pitchMax = 40;
  self.pitchMin = -40;
  self.hud_rollangle = 3.25;
  self.hud_bob = 0.035;
  self.hud_bob_cycle = 0.5;
  self.hud_bob_up = 0.4;
  self.hud_bob_model = 1;
  self.hud_bob_side = 0.35;
  self.hud_bob_speed = 6.55;
  self.hud_bob_model_up = 0.1;
//====================================

//UI Data=============================
  self.abbrev = "SPR";
  self.description = "SAPPER mechs were drafted and produced right before the Federation treaty was ratified. Off-world concerns asked for a strong second-line METAL to support other medium formations. What they got from the factories was dubbed the SAPPER based on its hardpoint configuration and shield output. | | The mech trades a lot of offensive firepower for equipment and shields. Its ability to withstand heavy anti-shield damage allows the mech to move-and-fire against tougher opponents. | | SAPPERs won`t halt an attack by themselves but they remain a powerful force multiplier in both Militar and Survest armies...even if they can no longer be built in large numbers.";
  self.icon = "gfx/ui/mech_icons/icon_sapper.png";

  //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
  local entity hardpnt;
  hardpnt = self.w_slot;
  hardpnt.uiOffset = '-90 60';//#1 M_ARM_RIGHT
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '90 60'; //#3 M_ARM_LEFT
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-55 -52';//#2 M_TOR_RIGHT
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '55 -52';//#4 M_TOR_LEFT
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-25 25'; //#5 M_TOR_CENTER low/right
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-25 -10'; //#6 M_TOR_CENTER up/right
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '25 25'; //#7 M_TOR_CENTER low/left
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '25 -10'; //#8 M_TOR_CENTER up/left
//====================================
#endif
};