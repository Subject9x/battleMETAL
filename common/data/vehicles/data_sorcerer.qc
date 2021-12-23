/*
battleMETAL
Author: Peter Roohr
Date: 05/25/2019
Overview:
  Data File - Unit - Vehicle
      Sorcerer
        Missile Carrier tank.
        NON-PLAYABLE
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_sorcerer_={

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_VEHICLE_sorcerer;
  self.vec_size = 2;
  self.vec_name = "Sorcerer";
 
  self.max_health = 285;
  setsize(self, '-22 -22 -9', '22 22 26');
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  
//ENERGY AND SHIELDS===================
  self.energyMax = 300;
  self.energyRate= 1;
  self.shieldMax = 225;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 2000;
  self.w_firetime = 3;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 66;
  self.data_speed_strafe = 40;
  self.data_speed_backward = 30;
  self.data_speed_accel = 1;
#ifdef SSQC
  self.yaw_speed = 2.5;    //AI-only 
#endif
//=====================================
 
//MECH COMPONENTS====================
  self.hardpoint_cnt = 2;
  weaponList = self;
  self.model = "q3mdl/vecs/sorcerer/mdl_sorcerer_chas.md3";
  
  //camera location
  data_ini_camera_( '0 24 0', self );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_LEGS, '-10.5 5 -7', '35 0 0', EQP_ALL);
  data_ini_unitHardpoint_2( M_LEGS, '10.5 5 -7', '35 0 0', EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
