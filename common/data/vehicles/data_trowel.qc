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
  setsize(self, '-30 -30 -7.75', '30 30 20');
  
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
  self.data_speed_forward = 100;
  self.data_speed_strafe = 0;
  self.data_speed_backward = 50;
  self.data_speed_accel = 1;
  self.yaw_speed = 0.75;    //AI-only 
  self.turret_yaw_speed = 1.25;//AI-only - but has no turret
  self.ai_angleLimits = '-90 90 0';
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/trowel/mdl_trowel_chas.md3";
  
  //tank turret`
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/vecs/trowel/mdl_trowel_tur.md3", 1, '0 13.5 0', self, torsoCenter ); 
  
  //camera location
  data_ini_camera_( '0 18 10', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-4.75 12 10.5', '0 0 90', 3, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-4.75 16.75 10.5', '0 0 90', 3, (DMG_ENE | DMG_BAL));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
