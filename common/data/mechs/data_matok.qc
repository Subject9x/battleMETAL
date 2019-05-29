/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Matok
        Medium Lancer.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_matok_={

  self.data_idx = 2;  //
  self.vec_size = 2;  //
  self.vec_name = "Matok";
 
  self.max_health = 650;
  self.mins = '-17 -17 -40';
  self.maxs = '17 17 22';
  
  
//ENERGY AND SHIELDS===================
  self.en_max   = 800;
  self.en_rate  = 4.25;
  self.sh_max   = 425;
  self.sh_rate  = 1.5;
//=====================================
 
//RADAR================================
  self.radar_range = 1200;
  self.w_firetime = 4;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_MARKSMAN;
//=====================================

//SPEED================================
  self.m_fspeed = 150;
  self.m_sspeed = 100;
  self.m_bspeed = 90;
  self.m_maccel = 1.5;
  self.yaw_speed = 2.5;    //AI-only 
  self.turret_yaw_speed = 2.5;//AI-only
//=====================================
 
//MECH COMPONENTS====================
  //camera location
  data_ini_camera_( '0 15 7' );
  
  //center torso
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/mechs/matok/matok_tor_c.md3", 650, '0 0 0', self, e_tor_c);
 
  //left torso
  data_ini_unitPiece_( M_TOR_LEFT, "q3mdl/mechs/matok/matok_tor_l.md3", 600, '-10 12.25 1.5', self, e_tor_l);
 
  //right torso
  data_ini_unitPiece_( M_TOR_RIGHT, "q3mdl/mechs/matok/matok_tor_r.md3", 600, '10 12.25 1.5', self, e_tor_r);
 
  //left arm
  data_ini_unitPiece_( M_ARM_LEFT, "q3mdl/mechs/matok/matok_arm_l.md3", 675, '-15 11 0', self.e_tor_l, e_arm_l);
 
  //right arm
  data_ini_unitPiece_( M_ARM_RIGHT, "q3mdl/mechs/matok/matok_arm_r.md3", 675, '15 11 0', self.e_tor_r, e_arm_r);
   
  //legs
  data_ini_unitPiece_( M_LEGS, "q3mdl/mechs/matok/matok_legs.md3", 900, '0 -12 0', self, e_legs);
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_TOR_RIGHT, '9.25 8.65 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_TOR_LEFT, '-9.25 8.65 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_ARM_RIGHT, '19.25 2.1 2.25', '0 0 90', 2, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-19.25 2.1 2.25', '0 0 90', 2, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_5( M_TOR_CENTER, '0 20 0', '0 0 90', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
//=====================================

//HUD Data=============================
  self.m_pitch_max = 55;  //DEBUG
  self.m_pitch_min = -45;
  self.weaponmodel = "q3mdl/mechs/matok/matok_hud.md3";
  self.m_rollangle = "2.25";
  self.m_bob = "0.0008";
  self.m_bcycle =  "0.5";
  self.m_bup = "0.5";
  self.m_bmodel = "1";
  self.m_bside = "0.35";
  self.m_bobspd = "6.55";
//====================================
};
