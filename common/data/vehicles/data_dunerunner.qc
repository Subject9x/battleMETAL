/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
  Data File - Unit - Vehicle
      DuneRunner
        super light recon GEV.
        NON-PLAYABLE
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_dunerunner_={

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_VEHICLE_dunerunner;
  self.vec_size = 1;
  self.vec_name = "Dunerunner";
 
  self.max_health = 115;
  setsize(self, '-16 -16 -8', '16 16 16');
  self.flags = self.flags | FL_TURRET | FL_MONSTER | FL_UNIT;
  
//ENERGY AND SHIELDS===================
  self.energyMax = 125;
  self.energyRate= 0.5;
  self.shieldMax = 50;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 2300;
  self.w_firetime = 4;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 167;
  self.data_speed_strafe = 113;
  self.data_speed_backward = 133;
  self.data_speed_accel = 1.0;
  #ifdef SSQC
  self.yaw_speed = 5;    //AI-only 
  self.turret_yaw_speed = 4;//AI-only
  self.ai_angleLimits = '-360 360 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.hardpoint_cnt = 2;
  weaponList = self;
  
  //tank turret
  data_ini_torso_center_( "models/vecs/dunerunner/mdl_dunrun_tur.md3", 1, '0 5.35 1.25', '0 0 0');  
  //chassis
  data_ini_legs_( "models/vecs/dunerunner/mdl_dunrun_chas.md3", 0, '0 0 0');
  
  //camera location
  self.cameraOffset = '0 24 0';
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-1.5 5.34 3.25', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_2( M_TOR_CENTER, '1.5 5.34 3.25', '0 0 0', EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
