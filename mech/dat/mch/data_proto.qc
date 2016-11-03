/*
mech mod
Author: Subject9x
Date: 8/27/2016
  mech definition file to hold the stock data for a mech.
  MECH: OUTLAW
  ROLE: Striker
  DESC: Fast, low health, moderate damage. This mech is
  a hit and run specialist.
*/

void() prt_ini;

void() prt_ini={

  local entity oself, prt_data; 
  local entity prt_legs, prt_ctr, prt_ltr, prt_rtr, prt_cam;
  local entity prt_w1, prt_w2, prt_w3;
  
  oself = self;
  prt_data = spawn();
  self = prt_data;
  self.data_idx = 1;
  self.classname = "data";
  self.data_type = DATA_MECH;
  self.vec_name = "Prototype";
  self.m_rot_speed = 6;
  self.en_cur = 75;
  self.en_max = 75;
  self.en_rate = 0.095;
  self.sh_cur = 25;
  self.sh_max = 25;
  self.sh_rate = 2;
  
  
  //main collider info
  //this must account for the legs as -height, and the center torso / top weapons as +height
  self.c_bbx_n = '-12 -12 -38';//'-12 -12 -38';
  self.c_bbx_x = '12 12 10';//'12 12 10';
  
  //Movement variables
  self.m_fspeed = 175;
  self.m_sspeed = 150;
  self.m_bspeed = 150;
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
  prt_legs = spawn();
  self = prt_legs;
  self.c_name = M_LEGS;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/notl/mdl_notl_legs.md3";
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  self.c_ofs = '0 -22.5 -2';
  //self.c_alt_ofs = '9 16 0';
  prt_data.e_legs = prt_legs;
  //===========================
  //CENTER TORSO========================
  prt_ctr = spawn();
  self = prt_ctr;
  self.c_name = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/notl/mdl_notl_t_cent.md3";
  //self.c_ofs = '0 6.5 0';
  //self.c_alt_ofs = prt_data.e_legs.c_ofs;
  //the center torso is now the 'client'
  //self.c_bbx_n = '-6 -4 -4';
  //self.c_bbx_x = '6 4 4';
  prt_data.e_tor_c = self;
  //==========================
  //LEFT TORSO 
  prt_ltr = spawn();
  self = prt_ltr;
  self.c_name = M_TOR_LEFT;
  self.c_parent = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/notl/mdl_notl_t_left.md3";
  self.c_ofs = '7 1 -5';
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  prt_data.e_tor_l = self;
  //==========================
  //RIGHT TORSO
  prt_rtr = spawn();
  self = prt_rtr;
  self.c_name = M_TOR_RIGHT;
  self.c_parent = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.max_armor = 100;
  self.c_model = "q3mdl/mechs/notl/mdl_notl_t_left.md3";
  self.c_ofs = '-7 1 -5';
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  prt_data.e_tor_r = self;
  //==========================
  //cockpit
  prt_cam = spawn();
  self = prt_cam;
  self.c_name = "camera";
  self.c_ofs = '0 1 2';
  self.c_alt_ofs = '0 1 0';
  self.c_model = "q3mdl/testball.md3";
  prt_data.e_cam = prt_cam;
  //====================================
  prt_w1 = spawn();
  self = prt_w1;
  self.c_parent = M_TOR_LEFT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = '12 4 -3';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = 1;
  prt_data.w_slot = prt_w1;
  
  prt_w2 = spawn();
  self = prt_w2;
  self.c_parent = M_TOR_RIGHT;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = '-12 4 -3';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = 1;
  prt_w1.w_slot = prt_w2;
  
  prt_w3 = spawn();
  self = prt_w3;
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 1; //consult weapon idx table!
  self.c_ofs = '0 8 0';
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 0';
  self.w_group = 2;
  prt_w2.w_slot = prt_w3;
  
  self = oself;
};