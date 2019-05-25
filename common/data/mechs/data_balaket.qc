/*
battleMETAL
Author: Peter Roohr
Date: 05/23/2019
Overview:
    Data File - Unit - Mech
        Balaket
        Light Skirmisher Mech.
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_balaket_={

  self.data_idx = 1;  //
  self.vec_size = 1;  //
  self.vec_name = "Balaket";
 
  self.max_health = 500;
  setsize(self, '-14 -14 -35', '14 14 16');
  
//ENERGY AND SHIELDS===================
  self.en_max = 400;
  self.en_rate= 3.5;
  self.sh_max = 300;
  self.sh_rate= 2;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 6;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_SKIRMISH;
//=====================================

//SPEED================================
  self.m_fspeed = 225;
  self.m_sspeed = 175;
  self.m_bspeed = 150;
  self.m_maccel = 1.5;
  self.yaw_speed = 2.75;    //AI-only 
  self.turret_yaw_speed = 3;//AI-only
//=====================================
 
//MECH COMPONENTS====================
  //camera location
  data_ini_unitPiece_( -1, "q3mdl/testball.md3", 0, '0 7 7', self, e_cam);
  
  //center torso
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/mechs/balaket/balaket_tor_c.md3", 500, '0 0 0', self, e_tor_c);
 
  //left torso
  data_ini_unitPiece_( M_TOR_LEFT, "q3mdl/mechs/balaket/balaket_tor_l.md3", 375, '-7.5 5.5 -2.5', self, e_tor_l);
 
  //right torso
  data_ini_unitPiece_( M_TOR_RIGHT, "q3mdl/mechs/balaket/balaket_tor_r.md3", 375, '7.5 5.5 -2.5', self, e_tor_r);
 
  //left arm
  data_ini_unitPiece_( M_ARM_LEFT, "q3mdl/mechs/balaket/balaket_arm_l.md3", 350, '-12.1 7 -3', self.e_tor_l, e_arm_l);
 
  //right arm
  data_ini_unitPiece_( M_ARM_RIGHT, "q3mdl/mechs/balaket/balaket_arm_r.md3", 350, '12.1 7 -3', self.e_tor_r, e_arm_r);
   
  //legs
  data_ini_unitPiece_( M_LEGS, "q3mdl/mechs/balaket/balaket_legs.md3", 700, '0 -16 0', self, e_legs);
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_( WEAPON1, M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON2, M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON3, M_TOR_CENTER, '-2 10.5 0', '0 0 90', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
//=====================================

//HUD DATA=============================
  self.m_pitch_max = 45;  //DEBUG
  self.m_pitch_min = -15;
  self.weaponmodel = "q3mdl/mechs/balaket/balaket_view.md3";
  self.m_rollangle = "2";
  self.m_bob = "0.0008";
  self.m_bcycle =  "0.5";
  self.m_bup = "0.15";
  self.m_bmodel = "1";
  self.m_bside = "0.09";
  self.m_bobspd = "16";
//====================================
};
