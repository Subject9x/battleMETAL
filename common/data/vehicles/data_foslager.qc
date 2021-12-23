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

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_VEHICLE_foslager;  //
  self.vec_size = 2;  //
  self.vec_name = "Foslager";
 
  self.max_health = 200;
  setsize(self, '-22 -22 -9', '22 22 26');
  self.flags = self.flags | (FL_TURRET | FL_MONSTER | FL_UNIT);
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 3;
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
#ifdef SSQC
  self.yaw_speed = 3.75;        //3.5;    //AI-only 
  self.turret_yaw_speed = 4.25; //3.75;//AI-only
  self.ai_angleLimits = '-180 180 0'; //-160 160
#endif
//=====================================
 
//MECH COMPONENTS====================
  self.hardpoint_cnt = 3;
  weaponList = self;
  
  self.model = "q3mdl/vecs/foslager/mdl_foslager_chas.md3";
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/vecs/foslager/mdl_foslager_tur.md3", 1, '0 10.25 -3.75', self, torsoCenter, '0 0 0');
  
  //camera location
  data_ini_camera_( '0 20 0', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '1.5 0.75 3', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_2( M_TOR_CENTER, '-5.1 1.25 3.75', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_3( M_LEGS, '-1.5 6 9', '0 0 0', EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
