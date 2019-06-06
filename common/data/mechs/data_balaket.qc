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

  self.data_idx = UID_MECH_balaket;  //
  self.vec_size = 1;  //
  self.vec_name = "Balaket";
 
  self.max_health = 500;
  self.mins = '-14 -14 -35';
  self.maxs = '14 14 16';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 3.5;
  self.shieldMax = 300;
  self.shieldRate= 2;
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
  data_ini_camera_( '0 7 7' );
  
  //center torso
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/mechs/balaket/balaket_tor_c.md3", 500, '0 0 0', self, torsoCenter);
 
  //left torso
  data_ini_unitPiece_( M_TOR_LEFT, "q3mdl/mechs/balaket/balaket_tor_l.md3", 375, '-7.5 5.5 -2.5', self, torsoLeft);
 
  //right torso
  data_ini_unitPiece_( M_TOR_RIGHT, "q3mdl/mechs/balaket/balaket_tor_r.md3", 375, '7.5 5.5 -2.5', self, torsoRight);
 
  //left arm
  data_ini_unitPiece_( M_ARM_LEFT, "q3mdl/mechs/balaket/balaket_arm_l.md3", 350, '-12.1 7 -3', self.torsoLeft, armLeft);
 
  //right arm
  data_ini_unitPiece_( M_ARM_RIGHT, "q3mdl/mechs/balaket/balaket_arm_r.md3", 350, '12.1 7 -3', self.torsoRight, armRight);
   
  //legs
  data_ini_unitPiece_( M_LEGS, "q3mdl/mechs/balaket/balaket_legs.md3", 700, '0 -16 0', self, legs);
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 90', 3, (DMG_BAL | DMG_ENE | DMG_EXP | DMG_MSC));
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

//UI Data=============================
  self.abbrev = "BLK";
  self.description = "A primitive combat platform, BALAKETTs come from the early days of the Federation. Originally billed as exploration vehicles, Federation Military found them able anti-partisan units. | | BALAKETT units are best against other light and smaller targets. Their weapon mount limitations prevent them from engaging larger foes one-on-one. | | They are dangerous in packs though, their quick speed and variable-enough loadouts keeping singular targets distracted; unable to land that fatal blow.~";
  self.icon = "gfx/ui/hgr_blk.png";
//====================================
};
