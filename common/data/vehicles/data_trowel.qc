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

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_VEHICLE_trowel;
  self.vec_size = 3;
  self.vec_name = "Trowel";
 
  self.max_health = 550;//465;
  setsize(self, '-32 -32 -6', '32 32 20');
  self.flags = self.flags | (FL_TURRET | FL_MONSTER | FL_UNIT);
//ENERGY AND SHIELDS===================
  self.energyMax = 700;
  self.energyRate= 1.85;
  self.shieldMax = 250;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 1400;
  self.w_firetime = 4;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 25;
  self.data_speed_strafe = 10;
  self.data_speed_backward = 10;
  self.data_speed_accel = 1.0;
#ifdef SSQC
  self.yaw_speed = 1.5;//1;    //AI-only 
  self.turret_yaw_speed = 2;//1.5;//AI-only
  self.ai_angleLimits = '-160 160 0';
#endif
//=====================================
 
//MECH COMPONENTS====================
  self.hardpoint_cnt = 7;
  weaponList = self;
  
  //tank turret
  data_ini_torso_center_("models/vecs/trowel/mdl_trowel_tur.md3", 1, '0 13.5 0', '0 0 0');   //chassis
  data_ini_legs_( "models/vecs/trowel/mdl_trowel_chas.md3", 0, '0 0 0');
  
  //camera location
  self.cameraOffset = '0 20 0';
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-4.65 12 10.5', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-4.65 16.75 10.5', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_3( M_TOR_CENTER, '2 15.0 -7', '90 0 0', EQP_ALL);
  data_ini_unitHardpoint_4( M_TOR_CENTER, '2 15.0 -11', '90 0 0', EQP_ALL);
  data_ini_unitHardpoint_5( M_LEGS, '7 7.5 20', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_6( M_LEGS, '-7 7.5 20', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 12.5 -15.5', '0 180 0', EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================

};
