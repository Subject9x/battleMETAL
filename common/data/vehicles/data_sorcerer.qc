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

  self.data_idx = 10;  //
  self.vec_size = 2;  //
  self.vec_name = "Sorcerer";
 
  self.max_health = 250;
  setsize(self, '-20 -20 -11', '20 20 14');
  
//ENERGY AND SHIELDS===================
  self.en_max = 300;
  self.en_rate= 1;
  self.sh_max = 225;
  self.sh_rate= 0;
//=====================================
 
//RADAR================================
  self.radar_range = 2000;
  self.w_firetime = 3;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.m_fspeed = 125;
  self.m_sspeed = 0;
  self.m_bspeed = 25;
  self.m_maccel = 1;
  self.yaw_speed = 2.5;    //AI-only 
  //self.turret_yaw_speed = 3;//AI-only - but has no turret
//=====================================
 
//MECH COMPONENTS====================
  self.model = "q3mdl/vecs/sorcerer/mdl_sorcerer_chas.md3";
  //camera location
  data_ini_unitPiece_( -1, "q3mdl/testball.md3", 0, '0 12 20', self, e_cam);
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_LEGS, '-10.5 5 -7', '0 0 90', 1, (DMG_EXP | DMG_MSC));
  data_ini_unitHardpoint_2( M_LEGS, '10.5 5 -7', '0 0 90', 1, (DMG_EXP | DMG_MSC));
//=====================================

//HUD DATA=============================
  //Unit is non-playable
//====================================
};
