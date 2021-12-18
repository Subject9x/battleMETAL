/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Matok
        Medium Lancer.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_matok_={
  
  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  
  self.data_idx = UID_MECH_matok;
  self.vec_size = 2;
  self.vec_name = "Matok";
 
  //Center Torso Health / player central health.
  self.max_health = 650;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -40';
  self.maxs = '18 18 22';
  
//ENERGY AND SHIELDS===================
  self.energyMax   = 800;
  self.energyRate  = 4.85;
  self.shieldMax   = 600;
  self.shieldRate  = 3.33;
  self.startupDelay = 7;
  self.evasionDrain = 2.5;
//=====================================
 
//RADAR================================
  self.radar_range = 1800;
  self.w_firetime = 2;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 155.0;
  self.data_speed_strafe = 155.0;
  self.data_speed_backward = 80.0;
  self.data_speed_accel = 1.45;
  self.ramUpMax = 1.5;
  self.ramCooldown = 3;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 12;
  self.legRunRate = 18;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_MARKSMAN;
  self.yaw_speed = 3;
  self.turret_yaw_speed = 3.75;
  self.ai_angleLimits = '-180 180 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.015;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "q3mdl/mechs/matok/matok_tor_c.md3", 650, '0 0 0', '0 6 0' );
 
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/matok/matok_tor_l.md3", 600, '-10 12.25 1', '-8 12.25 0' );
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/matok/matok_tor_r.md3", 600, '10 12.25 1', '8 12.25 0' );
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/matok/matok_arm_l.md3", 675, '-11 12 0', '-14 7 0' );

  //right arm
  data_ini_arm_right_( "q3mdl/mechs/matok/matok_arm_r.md3", 675, '11 12 0', '14 7 0' );

  //legs
  data_ini_legs_( "q3mdl/mechs/matok/matok_legs.md3", 900, '0 -12 0' );
  
  //camera location
  #ifdef CSQC
    data_ini_camera_( '0 15 15', self.torsoCenter);
  #else
    data_ini_camera_( '0 15 7', self.torsoCenter);
  #endif
  
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_TOR_RIGHT, '9.25 8.65 9', '0 0 0',     (BAL1|BAL2|ENE1|MSC1|MIS1) );
  data_ini_unitHardpoint_2( M_TOR_LEFT, '-9.25 8.65 9', '0 0 0',     (BAL1|BAL2|ENE1|MSC1|MIS1) );
  data_ini_unitHardpoint_3( M_ARM_RIGHT, '19 3 2.25', '0 0 90', (BAL1|ENE1|ENE2|ENE3) );
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-19 3 2.25', '0 0 -90',(BAL1|ENE1|ENE2|ENE3) );
  data_ini_unitHardpoint_5( M_TOR_CENTER, '0 20 0', '0 0 0',         (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2) );
  data_ini_unitHardpoint_6( M_TOR_CENTER, '0 6 7', '0 0 0',          (MSC1|MSC2|MSC3|MSC4) );
//=====================================

//HUD Data=============================
#ifdef CSQC
  self.weaponmodel = "q3mdl/mechs/matok/matok_view.obj";
  self.hud_model = "q3mdl/mechs/matok/matok_hud.obj";
  self.hud_StrutsOffset = '0 -2 -0.75';
  self.pitchMax = 55;
  self.pitchMin = -45;
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
  self.abbrev = "MTK";
  self.description = "The MATOK was the second-generation combat mech that Federal Military churned out as the threat of AUTHOR was increasing. MATOKs are the main stay of Federal squadrons today, found in almost every deployment and any combat. | | A dangerous generalist, the MATOK is design to engage targets head on with a slew of direct-fire power and large reactor recharge capacity. | | MATOK operators have to remember not to get surrounded though, the MATOK's defensive capabilities are not as strong as its offense. Its speed is also a problem against more agile targets.";
  self.icon = "gfx/ui/mech_icons/icon_matok.png";
  
  //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
  local entity hardpnt;
  hardpnt = self.w_slot;
  hardpnt.uiOffset = '55 5';//#3
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-55 5';//#4
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '110 50'; //#1
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '-55 5';//#4
  hardpnt.uiOffset = '-110 50'; //#2
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '0 -65 0'; //#5
  
  hardpnt = hardpnt.w_slot;
  hardpnt.uiOffset = '0 25 0'; //#6
//====================================
#endif
};