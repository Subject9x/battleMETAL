/*
battleMETAL
Author: Peter Roohr
Date: 09/26/2018
Overview:
  name    : VTOL Light
  faction : PSC
  type    : vtol
  size    : small
*/

void() data_PSC_VTOLL_ini;
void() data_PSC_VTOLL_cam;
void() data_PSC_VTOLL_wep1;
void() data_PSC_VTOLL_wep2;

void() data_PSC_VTOLL_ini={
  self.unit_wep1 = data_PSC_VTOLL_wep1;
  self.unit_wep2 = data_PSC_VTOLL_wep2;
  self.unit_cam = data_PSC_VTOLL_cam;
    
  self.data_idx = ID_VEC_PSC_VTOL_L;
  self.vec_name = DAT_PSC_VTOLL_NAME;
  self.vec_size = DAT_PSC_VTOLL_SIZE;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_PSC_VTOLL_RADAR_RANGE;
  self.i_techlvl= DAT_vtol_TECH_LEVEL;
  
  setsize(self, DAT_PSC_VTOLL_BBX_N, DAT_PSC_VTOLL_BBX_X);

  self.comp_id = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = "";
  
  self.en_cur= DAT_PSC_VTOLL_ENERGY_MAX;
  self.en_max= DAT_PSC_VTOLL_ENERGY_MAX;
  self.en_rate= DAT_PSC_VTOLL_ENERGY_RATE;
  self.sh_max= DAT_PSC_VTOLL_SHIELD_MAX;
  self.sh_rate= DAT_PSC_VTOLL_SHIELD_RATE;
  self.m_rot_speed = DAT_PSC_VTOLL_YAW_SPEED;
  self.c_model = DAT_PSC_VTOLL_MODEL;
  self.m_fspeed = DAT_PSC_VTOLL_FSPEED;
  self.m_sspeed = DAT_PSC_VTOLL_SSPEED;
  self.m_bspeed = DAT_PSC_VTOLL_BSPEED;
  self.m_pitch_max = DAT_vtol_PITCH_N;
  self.m_pitch_min = DAT_vtol_PITCH_X;
  self.w_firetime = DAT_vtol_LOCK_ON;
};

void() data_PSC_VTOLL_cam={  
  self.c_parent = M_TOR_CENTER;
  self.c_ofs = '0 0 24';
  self.c_alt_ofs = '0 0 0';
};

void() data_PSC_VTOLL_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_PSC_VTOLL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_PSC_VTOLL_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_PSC_VTOLL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};