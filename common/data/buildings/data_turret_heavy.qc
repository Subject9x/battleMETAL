/*
battleMETAL
Author: Peter Roohr
Date: 07/01/2019
Overview:
  Data File - Unit - Turret
	Heavy Turret
		NON-PLAYABLE
		Only carries 1-2 heavy weapons
*/

/*
	Main ini function for unit.
	Register this in <data_system.qc>
*/
void() data_ini_heavy_turret_={

  self.data_idx = UID_TURRET_heavy_turret;
  self.vec_size = 2;
  self.vec_name = "Heavy Turret";
 
  self.max_health = 581;
  setsize(self, '-28 -28 -16', '28 28 28');
  
//ENERGY AND SHIELDS===================
  self.energyMax  = 600;
  self.energyRate = 4;
  self.shieldMax  = 150;
  self.shieldRate = 0.25;
//=====================================
 
//RADAR================================
  self.radar_range = 1000;
  self.w_firetime = 2;  //lock-on time in seconds
//=====================================

//SPEED================================
  #ifdef SSQC
  //only yaw speeds because turrets can't move...
  self.yaw_speed = 0;    //AI-only 
  self.turret_yaw_speed = 4;//AI-only
  self.ai_angleLimits = '-360 360 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/buildings/turret_heavy/mdl_turret_heavy_base.obj";
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/buildings/turret_heavy/mdl_turret_heavy_turret.obj", 1, '0 20 0', self, torsoCenter, '0 0 0'); 
  
  //camera location
  data_ini_camera_( '0 28 8', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  self.hardpoint_cnt = 4;
  weaponList = self;
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-3.75 22 15', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_2( M_TOR_CENTER, '3.75 22 15', '0 0 0', EQP_ALL);
  data_ini_unitHardpoint_3( M_TOR_CENTER, '3.75 26 0', '90 0 0', EQP_ALL);
  data_ini_unitHardpoint_4( M_TOR_CENTER, '3.75 26 0', '90 0 0', EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};