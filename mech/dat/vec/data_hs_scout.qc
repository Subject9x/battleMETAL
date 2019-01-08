/*
battleMETAL
Author: Peter Roohr
Date: 10/09/2018
Overview:
  name    : GEV light
  faction : Human Survivors
  type    : GEV
  size    : small
*/

void() data_HS_GEVL_ini;
void() data_HS_GEVL_ctor;
void() data_HS_GEVL_cam;
void() data_HS_GEVL_wep1;
void() data_HS_GEVL_wep2;

void() data_HS_GEVL_ini={
  self.unit_ctor = data_HS_GEVL_ctor;
  self.unit_wep1 = data_HS_GEVL_wep1;
  self.unit_wep2 = data_HS_GEVL_wep2;
  self.unit_cam = data_HS_GEVL_cam;
    
  self.data_idx= ID_VEC_HS_SCOUT;
  self.vec_name= DAT_HS_GEVL_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_HS_GEVL_RADAR_RANGE;
  self.i_techlvl= DAT_H_TD_TECH_LEVEL;
  
  self.health = DAT_HS_GEVL_HP;
  self.max_health = DAT_HS_GEVL_HP;
  self.c_model = "q3mdl/vecs/dunerunner/mdl_dunrun_chas.md3";
  
  self.en_cur= DAT_HS_GEVL_ENERGY_MAX;
  self.en_max= DAT_HS_GEVL_ENERGY_MAX;
  self.en_rate= DAT_HS_GEVL_ENERGY_RATE;
  self.sh_cur= 0;
  self.sh_max= DAT_HS_GEVL_SHIELD_MAX;
  self.sh_rate= DAT_HS_GEVL_SHIELD_RATE;
  self.m_rot_speed = DAT_HS_GEVL_YAW_SPEED;
  self.m_fspeed = DAT_HS_GEVL_FSPEED;
  self.m_sspeed = DAT_HS_GEVL_SSPEED;
  self.m_bspeed = DAT_HS_GEVL_BSPEED;
  self.m_pitch_max = DAT_H_TD_PITCH_N;
  self.m_pitch_min = DAT_H_TD_PITCH_X;
  
  setsize(self, DAT_HS_GEVL_BBX_N, DAT_HS_GEVL_BBX_X);
  setorigin(self, self.origin);
  
    //unit variants
  if( (self.flags & FL_MONSTER) ){
    //brawler
    if( self.style == TYPE_BRAWL ){
      //LATC | LAS
      ai_ini_weapons( 1, 3, -1, -1, -1, -1, -1, -1, -1);
    }
  }
  
};

void() data_HS_GEVL_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = "q3mdl/vecs/dunerunner/mdl_dunrun_tur.md3";
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 5.35 1.25';
};

void() data_HS_GEVL_cam={  
  self.c_parent = M_TOR_CENTER;
  self.c_ofs = '0 12 20';
  self.c_alt_ofs = '0 0 0';
};

void() data_HS_GEVL_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_GEVL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_HS_GEVL_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_GEVL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};