/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
  Data File - Unit - Turret
	Light Turret
		NON-PLAYABLE
		Only carries 2 light, direct-fire weapons
*/

/*
	Main ini function for unit.
	Register this in <data_system.qc>
*/
void() data_ini_light_turret_={

  self.data_idx = UID_TURRET_light_turret;  //
  self.vec_size = 1;  //
  self.vec_name = "Light Turret";
 
  self.max_health = 100;
  setsize(self, '-20 -20 -6', '20 20 13');
  
//ENERGY AND SHIELDS===================
  self.energyMax  = 100;
  self.energyRate = 0.25;
  self.shieldMax  = 100;
  self.shieldRate = 0.25;
//=====================================
 
//RADAR================================
  self.radar_range = 1000;
  self.w_firetime = 10;  //lock-on time in seconds
//=====================================

//SPEED================================
  //only yaw speeds because turrets can't move...
  self.yaw_speed = 3;    //AI-only 
  self.turret_yaw_speed = 4;//AI-only - but has no turret
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/buildings/turret_light/mdl_bld_h_ltur_base.md3";
  //camera location
  data_ini_camera_( '0 12 20' );
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/buildings/turret_light/mdl_bld_h_ltur.md3", 1, '0 8 0', self, torsoCenter); 
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '2.5 7.5 11', '0 0 90', 2, (DMG_ENE | DMG_BAL));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '6 7.5 11', '0 0 90', 2, (DMG_ENE | DMG_BAL));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};