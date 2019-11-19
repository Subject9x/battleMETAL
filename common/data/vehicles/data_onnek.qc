/*
battleMETAL
Author: Peter Roohr
Date: 05/25/2019
Overview:
  Data File - Unit - Vehicle
      Onnek
        medium tank destroyer.
        NON-PLAYABLE
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_onnek_={

  self.data_idx = UID_VEHICLE_onnek;  //
  self.vec_size = 2;  //
  self.vec_name = "Onnek";
 
  self.max_health = 399;
  setsize(self, '-25 -25 -10.25', '25 25 28');
  
//ENERGY AND SHIELDS===================
  self.energyMax = 1000;
  self.energyRate= 4;
  self.shieldMax = 175;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 6;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 33;
  self.data_speed_strafe = 20;
  self.data_speed_backward = 15;
  self.data_speed_accel = 1;
  #ifndef CSQC
  self.yaw_speed = 2.5;    //AI-only 
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/onnek/onnek.md3";
  
  //camera location
  data_ini_camera_( '0 10 18', self );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_LEGS, '7.25 1 12', '0 0 0', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_2( M_LEGS, '7.25 3.5 12', '0 0 0', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_3( M_LEGS, '7.25 6 11', '0 0 0', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_4( M_LEGS, '7.25 8.5 10', '0 0 0', 3, (DMG_ENE | DMG_BAL));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
