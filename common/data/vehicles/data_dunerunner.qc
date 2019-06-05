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

  self.data_idx = UID_VEHICLE_dunerunner;  //
  self.vec_size = 1;  //
  self.vec_name = "Dunerunner";
 
  self.max_health = 100;
  setsize(self, '-20 -20 -10', '20 20 14');
  
//ENERGY AND SHIELDS===================
  self.energyMax = 125;
  self.energyRate= 0.5;
  self.shieldMax = 50;
  self.shieldRate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 2100;
  self.w_firetime = 4;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.m_fspeed = 167;
  self.m_sspeed = 113;
  self.m_bspeed = 133;
  self.m_maccel = 1;
  self.yaw_speed = 5;    //AI-only 
  self.turret_yaw_speed = 4;//AI-only
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/dunerunner/mdl_dunrun_chas.md3";
  //camera location
  data_ini_camera_( '0 12 20' );
  
  //tank turret
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/vecs/dunerunner/mdl_dunrun_tur.md3", 1, '0 5.35 1.25', self, torsoCenter);
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_TOR_CENTER, '-1.5 5.25 2', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_TOR_CENTER, '1.5 5.25 2', '0 0 90', 1, (DMG_BAL | DMG_ENE));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
