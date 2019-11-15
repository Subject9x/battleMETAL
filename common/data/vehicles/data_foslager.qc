/*
battleMETAL
Author: Peter Roohr
Date: 05/25/2019
Overview:
  Data File - Unit - Vehicle
      Foslager
        Main battle tank.
        NON-PLAYABLE
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_foslager_={

  self.data_idx = UID_VEHICLE_foslager;  //
  self.vec_size = 2;  //
  self.vec_name = "Foslager";
 
  self.max_health = 266;
  setsize(self, '-20 -20 -8', '20 20 26');
  
//ENERGY AND SHIELDS===================
  self.energyMax = 250;
  self.energyRate= 1.2;
  self.shieldMax = 100;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 1600;
  self.w_firetime = 5;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 50;
  self.data_speed_strafe = 20;
  self.data_speed_backward = 15;
  self.data_speed_accel = 1;
  #ifndef CSQC
  self.yaw_speed = 3.5;    //AI-only 
  self.turret_yaw_speed = 3.75;//AI-only
  self.ai_angleLimits = '-110 110 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/foslager/mdl_foslager_chas.md3";
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/vecs/foslager/mdl_foslager_tur.md3", 1, '0 10.25 -3.75', self, torsoCenter);
  
  //camera location
  data_ini_camera_( '0 15 0', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '1.5 11 2', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-5.1 11.5 2.75', '0 0 0', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_LEGS, '-1.5 6 9', '0 0 0', 1, (DMG_BAL | DMG_ENE));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
