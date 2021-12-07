/*
battleMETAL
Author: Peter Roohr
Date: 07/01/2019
Overview:
  Data File - Unit - Turret
	Missile Turret
		NON-PLAYABLE
		Only carries 1-2 missile weapons
*/

/*
	Main ini function for unit.
	Register this in <data_system.qc>
*/
void() data_ini_missile_turret_={

  self.data_idx = UID_TURRET_missile_turret;
  self.vec_size = 1;
  self.vec_name = "Missile Turret";
 
  self.max_health = 465;
  setsize(self, '-20 -20 -13', '20 20 20');
  
//ENERGY AND SHIELDS===================
  self.energyMax  = 100;
  self.energyRate = 0.25;
  self.shieldMax  = 100;
  self.shieldRate = 0.25;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 5;  //lock-on time in seconds
//=====================================

//SPEED================================
  #ifdef SSQC
  //only yaw speeds because turrets can't move...
  self.yaw_speed = 0;    //AI-only 
  self.turret_yaw_speed = 3;//AI-only
  self.ai_angleLimits = '-360 360 0';
  #endif
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/buildings/turret_missile/mdl_turret_missile_base.obj";
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/buildings/turret_missile/mdl_turret_missile_turret.md3", 1, '0 -12 0', self, torsoCenter, '0 0 0'); 
  
  //camera location
  data_ini_camera_( '0 20 8', self.torsoCenter );
//=====================================
 
//HARDPOINTS==========================
  self.hardpoint_cnt = 4;
  weaponList = self;
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-9 17 11', '0 0 90',EQP_ALL);
  data_ini_unitHardpoint_2( M_TOR_CENTER, '9 17 11', '0 0 90', EQP_ALL);
  data_ini_unitHardpoint_3( M_TOR_CENTER, '9 17 2', '90 0 90', EQP_ALL);
  data_ini_unitHardpoint_4( M_TOR_CENTER, '-9 17 2', '90 0 90',EQP_ALL);
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};