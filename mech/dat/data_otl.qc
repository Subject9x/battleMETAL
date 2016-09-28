/*
BattleMETAL mod
Author: Subject9x
Date: 7/17/2016 (8/6/2016)
  mech definition file to hold the stock data for a mech.
  MECH: OUTLAW
  ROLE: Striker
  DESC: Fast, low health, moderate damage. This mech is
  a hit and run specialist.
*/

void() otl_ini;
void() otl_fire_group1;
void() otl_fire_group2;
void() otl_fire_group3;

/*
  called by mech_data_ini.server_ini_mechdata;
  creates an ent that contains all the needed data
  to build an Outlaw mech for a player
  
  the data for all the parts are layed out here so that mechs can be
  customized in more fine detail instead of just mirroring left and right.
  
  SCOPE is 'self' = world 
*/
void() otl_ini={
  local entity otl_ent,otl_legs,otl_ctr,otl_lft,otl_rgt,otl_cam;
  local entity otl_wep1,otl_wep2,otl_wep3;
  local entity oself;
  
  self.M_IDX_MAX = self.M_IDX_MAX + 1;
  
  oself = self;
  otl_ent = spawn();
  self = otl_ent;
  self.m_idx = "1";
  self.classname = "mech_data"; //make sure these are unique!
  self.m_mechname = "Outlaw";
  self.m_rot_speed = 6;
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
  
  //LEG DATA===========================
  otl_legs = spawn();
  self = otl_legs;
  self.classname = M_LEGS;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 0;
  self.armorvalue = 100;
  self.m_model = "q3mdl/mechs/otl/mdl_otl_legs.md3";
  self.m_bbx_min = '-5 -5 -16';
  self.m_bbx_max = '5 5 16';
  self.m_main_ofs = '0 16 0';
  self.m_alt_ofs = '9 16 0';
  otl_ent.e_legs = self;
  //====================================
  //CENTER TORSO========================
  otl_ctr = spawn();
  self = otl_ctr;
  self.classname = M_TOR_CENTER;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.m_model = "q3mdl/mechs/notl/mdl_notl_t_cent.md3";
  self.m_main_ofs = '0 22 4';
  self.m_bbx_min = '-4 -4 -4';
  self.m_bbx_max = '4 4 4';
  otl_ent.e_tor_c = self;
  //====================================
  //LEFT TORSO==========================
  otl_lft = spawn();
  self = otl_lft;
  self.classname = M_TOR_LEFT;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.m_model = "q3mdl/mechs/notl/mdl_notl_t_left.md3";
  self.m_main_ofs = '-8 1 -4';
  self.m_alt_ofs = otl_ctr.m_main_ofs;
  self.m_bbx_min = '-5 -5 -4';
  self.m_bbx_max = '5 5 4';
  self.m_part_parent = M_TOR_CENTER;
  otl_ent.e_tor_l = self;
  //====================================
  //RIGHT TORSO=========================
  otl_rgt = spawn();
  self = otl_rgt;
  self.classname = M_TOR_RIGHT;
  self.frame = 0;
  self.health = 100;
  self.max_health = 100;
  self.armortype = 1;
  self.armorvalue = 100;
  self.m_model = "q3mdl/mechs/notl/mdl_notl_t_left.md3";
  self.m_main_ofs = '8 1 -4';
  self.m_alt_ofs = otl_ctr.m_main_ofs;
  self.m_bbx_min = '-5 -5 -4';
  self.m_bbx_max = '5 5 4';
  self.m_part_parent = M_TOR_CENTER;
  otl_ent.e_tor_r = self;
  //====================================
  //cockpit
  otl_cam = spawn();
  self = otl_cam;
  self.m_main_ofs = '0 0 5';
  self.m_model = "q3mdl/otl_cpit.md3";
  otl_ent.e_cam = self;
  //====================================
  //weapons
  otl_wep1 = spawn();
  self = otl_wep1;
  self.classname = "light_atc"; //cross-ref with the weapon's def file. game uses this to find the rest of the weapon data
  self.m_main_ofs = '5 1 -6';
  self.w_adj_ang = '0 0 90';
  self.m_part_parent = M_TOR_RIGHT;
  otl_ent.w_slot1 = self;
 
  otl_wep2 = spawn();
  self = otl_wep2;
  self.classname = "light_atc"; //cross-ref with the weapon's def file. game uses this to find the rest of the weapon data
  self.m_main_ofs = '-5 1 -6';
  self.w_adj_ang = '0 0 -90';
  self.m_part_parent = M_TOR_LEFT;
  otl_ent.w_slot2 = self;
  
  otl_wep3 = spawn();
  self = otl_wep3;
  self.classname = "emp"; //cross-ref with the weapon's def file. game uses this to find the rest of the weapon data
  self.m_main_ofs = '0 8 -4';
  self.w_adj_ang = '0 0 -90';
  self.m_part_parent = M_TOR_CENTER;
  otl_ent.w_slot3 = self;
  
  self = otl_ent;
  //define the mech's weapon groupings
  self.w_group1 = otl_fire_group1;
  self.w_group2 = otl_fire_group2;
  self.w_group3 = otl_fire_group3;
  
  self = oself;
};

void() otl_fire_group1={
  mech_weapon_trywep(self.e_mech.w_slot1);
  mech_weapon_trywep(self.e_mech.w_slot2);
};
void() otl_fire_group2={
  mech_weapon_trywep(self.e_mech.w_slot3);
};
void() otl_fire_group3={
  
};