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
 
  self.max_health = 300;
  setsize(self, '-25 -25 -10.25', '25 25 14');
  
//ENERGY AND SHIELDS===================
  self.en_max = 400;
  self.en_rate= 2;
  self.sh_max = 175;
  self.sh_rate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 2000;
  self.w_firetime = 6;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.m_fspeed = 75;
  self.m_sspeed = 0;
  self.m_bspeed = 75;
  self.m_maccel = 1;
  self.yaw_speed = 2;    //AI-only 
  //self.turret_yaw_speed = 3;//AI-only - but has no turret
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/onnek/onnek.md3";
  //camera location
  data_ini_camera_( '-5 3 10' );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_LEGS, '7.25 3.5 12', '0 0 90', 3, (DMG_ENE | DMG_BAL));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
