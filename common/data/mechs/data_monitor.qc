/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Monitor
        Juggernaut Heavy
*/

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_monitor_={

  self.data_idx = 3;  //
  self.vec_size = 3;  //
  self.vec_name = "Monitor";
 
  self.max_health = 1200;
  setsize(self, '-22 -22 -44', '22 22 28');
  
//ENERGY AND SHIELDS===================
  self.en_max = 700;
  self.en_rate= 3;
  self.sh_max = 600;
  self.sh_rate= 0.7;
//=====================================
 
//RADAR================================
  self.radar_range = 750;
  self.w_firetime = 8;  //lock-on time in seconds
  self.spreadDefault = ACCURACY_LOWTECH;
//=====================================

//SPEED================================
  self.m_fspeed = 85;
  self.m_sspeed = 85;
  self.m_bspeed = 85;
  self.m_maccel = 2;
  self.yaw_speed = 1;    //AI-only 
  self.turret_yaw_speed = 1;//AI-only
//=====================================
 
//MECH COMPONENTS====================
  //camera location
  data_ini_unitPiece_( -1, "q3mdl/testball.md3", 0, '0 18 8', self, e_cam);
  
  //center torso
  data_ini_unitPiece_( M_TOR_CENTER, "q3mdl/mechs/monitor/monitor_tor_c.md3", 1200, '0 0 0', self, e_tor_c);
 
  //left torso
  data_ini_unitPiece_( M_TOR_LEFT, "q3mdl/mechs/monitor/monitor_tor_l.md3", 1200, '-11.5 15.5 0', self, e_tor_l);
 
  //right torso
  data_ini_unitPiece_( M_TOR_RIGHT, "q3mdl/mechs/monitor/monitor_tor_r.md3", 375, '11.5 15.5 0', self, e_tor_r);
 
  //left arm
  data_ini_unitPiece_( M_ARM_LEFT, "q3mdl/mechs/monitor/monitor_arm_l.md3", 1000, '-18 13 -1', self.e_tor_l, e_arm_l);
 
  //right arm
  data_ini_unitPiece_( M_ARM_RIGHT, "q3mdl/mechs/monitor/monitor_arm_r.md3", 1000, '18 13 -1', self.e_tor_r, e_arm_r);
   
  //legs
  data_ini_unitPiece_( M_LEGS, "q3mdl/mechs/monitor/monitor_legs.md3", 1500, '0 -22 0', self, e_legs);
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_( WEAPON1, M_ARM_RIGHT, '18.85 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON2, M_ARM_RIGHT, '16.25 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON3, M_ARM_LEFT, '-18.85 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON4, M_ARM_LEFT, '-16.25 2 10', '0 0 90', 1, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON5, M_TOR_RIGHT, '9.45 15.9 6', '0 0 90', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON6, M_TOR_LEFT, '-9.45 15.9 6', '0 0 90', 3, (DMG_BAL | DMG_ENE));
  data_ini_unitHardpoint_( WEAPON7, M_TOR_CENTER, '0 5 5.5', '0 0 90', 3, DMG_EXP);
  data_ini_unitHardpoint_( WEAPON8, M_TOR_RIGHT, '9 6 4.5', '0 0 90', 3, (DMG_EXP | DMG_EXP));
  data_ini_unitHardpoint_( WEAPON9, M_TOR_LEFT, '-9 6 4.5', '0 0 90', 3, (DMG_EXP | DMG_EXP));
//=====================================

//HUD Data=============================
  self.m_pitch_max = 45;  //DEBUG
  self.m_pitch_min = -25;
  self.weaponmodel = "q3mdl/mechs/monitor/monitor_hud.md3";
  self.m_rollangle = "2.25";
  self.m_bob = "0.03";
  self.m_bcycle =  "0.85";
  self.m_bup = "0.5";
  self.m_bmodel = "1";
  self.m_bside = "0.65";
  self.m_bobspd = "3.85";
//====================================
};
