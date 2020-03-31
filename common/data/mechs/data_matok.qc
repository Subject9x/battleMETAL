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

  self.data_idx = UID_MECH_matok;
  self.vec_size = 2;
  self.vec_name = "Matok";
 
  self.max_health = 650;
  self.mins = '-18 -18 -40';
  self.maxs = '18 18 22';
  
//ENERGY AND SHIELDS===================
  self.energyMax   = 800;
  self.energyRate  = 4.85;
  self.shieldMax   = 600;
  self.shieldRate  = 3.33;
  self.startupDelay = 7;
  self.evasionDrain = 3;
//=====================================
 
//RADAR================================
  self.radar_range = 1400;
  self.w_firetime = 2;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_MARKSMAN;
//=====================================

//SPEED================================
  self.data_speed_forward = 150;
  self.data_speed_strafe = 100;
  self.data_speed_backward = 90;
  self.data_speed_accel = 1.25;
#ifndef CSQC
  self.yaw_speed = 3;    // AI-only 
  self.turret_yaw_speed = 3.5;// AI-only
  self.ai_angleLimits = '-125 125 0';
#endif
//=====================================
 
//MECH COMPONENTS====================
#ifdef CSQC
  if( (self.flags & FL_MONSTER) ){
    self.hardpoint_cnt = 5;
    weaponList = self;
  }
#endif
  //center torso
  data_ini_torso_center_( "q3mdl/mechs/matok/matok_tor_c.md3", 650, '0 0 0', '0 6 0' );
 
  //left torso
  data_ini_torso_left_( "q3mdl/mechs/matok/matok_tor_l.md3", 600, '-10 12.25 1', '-8 12.25 0' );
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/matok/matok_tor_r.md3", 600, '10 12.25 1', '8 12.25 0' );
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/matok/matok_arm_l.md3", 675, '-16 7 3', '-14 7 0' );

  //right arm
  data_ini_arm_right_( "q3mdl/mechs/matok/matok_arm_r.md3", 675, '16 7 3', '14 7 0' );

  //legs
  data_ini_legs_( "q3mdl/mechs/matok/matok_legs.md3", 900, '0 -12 0' );
  
#ifndef CSQC
  //camera location
  data_ini_camera_( '0 15 7', self.torsoCenter);
#endif
//=====================================
 
//HARDPOINT DATA======================
#ifndef CSQC
  data_ini_unitHardpoint_1( M_TOR_RIGHT, '9.25 8.65 10', '0 0 0', 1, (DMG_BAL | DMG_ENE | DMG_MSC) );
  data_ini_unitHardpoint_2( M_TOR_LEFT, '-9.25 8.65 10', '0 0 0', 1, (DMG_BAL | DMG_ENE | DMG_MSC) );
  data_ini_unitHardpoint_3( M_ARM_RIGHT, '19.25 2.1 2.25', '0 0 90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-19.25 2.1 2.25', '0 0 -90', 2, (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_5( M_TOR_CENTER, '0 20 0', '0 0 0', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC) );
#endif
#ifdef CSQC
  //csqc quirk: offsets_z = (turret_z * -1) + ssqc offsets_z
  //csqc quirk: offsets_y = (turret_y  - ssqc offsets_y
  data_ini_unitHardpoint_1( M_TOR_RIGHT, '9.25 8.65 10', '0 0 0', (BAL1|BAL2|ENE1|MSC1|MIS1), (DMG_BAL | DMG_ENE | DMG_MSC | DMG_EXP) );
  data_ini_unitHardpoint_2( M_TOR_LEFT, '-9.25 8.65 10', '0 0 0', (BAL1|BAL2|ENE1|MSC1|MIS1), (DMG_BAL | DMG_ENE | DMG_MSC | DMG_EXP) );
  data_ini_unitHardpoint_3( M_ARM_RIGHT, '19.25 2.1 2.25', '0 0 90', (BAL1|ENE1|ENE2|ENE3), (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-19.25 2.1 2.25', '0 0 -90', (BAL1|ENE1|ENE2|ENE3), (DMG_BAL | DMG_ENE) );
  data_ini_unitHardpoint_5( M_TOR_CENTER, '0 20 0', '0 0 0', (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4), (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC) );
#endif
//=====================================

//HUD Data=============================
#ifndef CSQC
  self.weaponmodel = "q3mdl/mechs/matok/matok_hud.md3";
  self.hud_model = "q3mdl/mechs/matok/matok_hud.obj";
#endif
#ifdef CSQC
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
  self.description = "The MATOK was the second-generation combat mech that Federal Military churned out as the threat of AUTHOR was increasing. MATOKs are the main stay of Federal squadrons today, found in almost every  deployment and any combat. | | A dangerous generalist, the MATOK is design to engage targets head on with a slew of direct-fire power and large reactor recharge capacity. | | MATOK operators have to remember not to get surrounded though, the MATOK's defensive capabilities are not as strong as its offense. Its speed is also a problem against more agile targets.";
  self.icon = "gfx/ui/mech_icons/icon_matok.png";
//====================================
#endif
};
#ifdef CSQC
//oh the things done because csqc interpolation isn't a thing.
//simply syncs 
void() data_ini_matok_offsets={
  self.centerTorso = '0 0 0';
  self.leftTorso =  '-10 12.25 1';
  self.rightTorso = '10 12.25 1';
  self.leftArm = '-16 7 3';
  self.rightArm = '16 7 3';
  self.leg = '0 -12 0';
};
#endif
