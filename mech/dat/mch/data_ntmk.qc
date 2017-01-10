/*
mech mod
Author: Subject9x
Date: 10/04/2016
  mech definition file to hold the stock data for a mech.
  MECH: TOMAHAWK
  ROLE: Striker
  DESC: medium level skirmisher.
*/

void() tmk_ini;

void() tmk_ini={

  local entity oself, tmk_data; 
  local entity tmk_legs, tmk_ctr, tmk_ltr, tmk_rtr, tmk_alt, tmk_art, tmk_cam;
  local entity tmk_w1, tmk_w2, tmk_w3, tmk_w4, tmk_w5;
  
  oself = self;
  tmk_data = spawn();
  self = tmk_data;
  self.data_idx = 2;
  self.classname = "data";
  self.data_type = DATA_MECH;
  self.vec_name = "Tomahawk";
  self.i_techlvl = 0;
  self.i_reserve = 200;
  self.m_rot_speed = 6;
  self.en_cur = 100;
  self.en_max = 100;
  self.en_rate = 0.075;
  self.sh_cur = 50;
  self.sh_max = 50;
  self.sh_rate = 1;
  
  //main collider info
  //this must account for the legs as -height, and the center torso / top weapons as +height
  self.c_bbx_n = '-12 -12 -40.5';//'-12 -12 -38';
  self.c_bbx_x = '12 12 14';//'12 12 10';
  
  //Movement variables
  self.m_fspeed = 125;
  self.m_sspeed = 100;
  self.m_bspeed = 100;
  self.m_maccel = "1";
  self.m_rollangle = "2";
  self.m_pitch_max = "90";
  self.m_pitch_min = "-90";
  
  //Cosmetic variables
  self.m_bob = "0.0008";
  self.m_bcycle =  "0.5";
  self.m_bup = "0.5";
  
  self.m_bmodel = "1";
  self.m_bside = "0.35";
  self.m_bobspd = "6.55";
  self.m_rollangle = "2.25";
  
  //LEGS=======================
  tmk_legs = spawn();
  self = tmk_legs;
  self.c_name = M_LEGS;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_legs.md3";
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  self.c_ofs = '0 -24 -2';
  //self.c_alt_ofs = '9 16 0';
  tmk_data.e_legs = tmk_legs;
  //===========================
  //CENTER TORSO========================
  tmk_ctr = spawn();
  self = tmk_ctr;
  self.c_name = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_t_cent.md3";
  tmk_data.e_tor_c = self;
  //==========================
  //tmk_ltr, ,
  //LEFT TORSO
  tmk_ltr = spawn();
  self = tmk_ltr;
  self.c_name = M_TOR_LEFT;
  self.c_parent = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_t_left.md3";
  self.c_ofs = '-9 2.75 -4';
  tmk_data.e_tor_l = self;
  //==========================
  //RIGHT TORSO
  tmk_rtr = spawn();
  self = tmk_rtr;
  self.c_name = M_TOR_RIGHT;
  self.c_parent = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_t_right.md3";
  self.c_ofs = '9 2.75 -4';
  tmk_data.e_tor_r = self;
  //=========================
  //LEFT ARM 
  tmk_alt = spawn();
  self = tmk_alt;
  self.c_name = M_ARM_LEFT;
  self.c_parent = M_TOR_LEFT;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_l_arm.md3";
  self.c_ofs = '-14.5 -0.5 -4';
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  tmk_data.e_arm_l = self;
  //==========================
  //RIGHT ARM 
  tmk_art = spawn();
  self = tmk_art;
  self.c_name = M_ARM_RIGHT;
  self.c_parent = M_TOR_RIGHT;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/ntmk/mdl_ntmk_r_arm.md3";
  self.c_ofs = '14.5 -0.5 -4';
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  tmk_data.e_arm_r = self;
  //==========================
  //cockpit
  tmk_cam = spawn();
  self = tmk_cam;
  self.c_name = "camera";
  self.c_ofs = '0 3 4';
  self.c_alt_ofs = '0 0 0';
  self.c_model = "q3mdl/testball.md3";
  tmk_data.e_cam = tmk_cam;
  //====================================
  tmk_w1 = spawn();
  self = tmk_w1;
  self.c_parent = M_TOR_RIGHT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = '9 9 -1';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = 1;
  tmk_data.w_slot = tmk_w1;
  
  tmk_w2 = spawn();
  self = tmk_w2;
  self.c_parent = M_TOR_LEFT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = '-9 9 -1';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = 1;
  tmk_w1.w_slot = tmk_w2;
  
  tmk_w3 = spawn();
  self = tmk_w3;
  self.c_parent = M_ARM_LEFT;
  self.data_idx = 3; //consult weapon idx table!
  self.c_ofs = '-15 -4 1.5';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = 2;
  tmk_w2.w_slot = tmk_w3;
  
  tmk_w4 = spawn();
  self = tmk_w4;
  self.c_parent = M_ARM_RIGHT;
  self.data_idx = 3; //consult weapon idx table!
  self.c_ofs = '15 -4 1.5';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = 2;
  tmk_w3.w_slot = tmk_w4;
  
  tmk_w5 = spawn();
  self = tmk_w5;
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 2; //consult weapon idx table!
  self.c_ofs = '0 10 -4';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = 3;
  tmk_w4.w_slot = tmk_w5;
  
  self = oself;
};