/*
battleMETAL
Author: Peter Roohr
Date: 05/25/2019
Overview:
  Data File - Unit - Vehicle
      Trowel
        Super heavy assault tank.
        NON-PLAYABLE
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_trowel_={

  self.data_idx = UID_VEHICLE_trowel;  //
  self.vec_size = 3;  //
  self.vec_name = "Trowel";
 
  self.max_health = 400;
  setsize(self, '-30 -30 -7.75', '30 30 36');
  
//ENERGY AND SHIELDS===================
  self.energyMax = 700;
  self.energyRate= 1.85;
  self.shieldMax = 250;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 1200;
  self.w_firetime = 4;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 25;
  self.data_speed_strafe = 10;
  self.data_speed_backward = 10;
  self.data_speed_accel = 1;
  #ifndef CSQC
  self.yaw_speed = 1;    //AI-only 
  self.turret_yaw_speed = 1.5;//AI-only
  self.ai_angleLimits = '-110 110 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/trowel/mdl_trowel_chas.md3";
  
  //tank turret`
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/vecs/trowel/mdl_trowel_tur.md3", 1, '0 13.5 0', self, torsoCenter ); 
  
  //camera location
  data_ini_camera_( '0 18 10', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-4.75 12 10.5', '0 0 0', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-4.75 16.75 10.5', '0 0 0', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-3 -8 10.5', '-90 0 0', 3, (DMG_ENE | DMG_BAL));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
