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

void() data_dunerunner_ini;
void() data_dunerunner_ctor;
void() data_dunerunner_cam;
void() data_dunerunner_wep1;
void() data_dunerunner_wep2;
void() data_dunerunner_death;

void() data_dunerunner_ini={
  self.unit_ctor = data_dunerunner_ctor;
  self.unit_wep1 = data_dunerunner_wep1;
  self.unit_wep2 = data_dunerunner_wep2;
  self.unit_cam = data_dunerunner_cam;
  
  self.data_idx= ID_VEC_dunerunner;
  self.vec_name= DAT_dunerunner_NAME;
  self.vec_size = DAT_dunerunner_SIZE;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_dunerunner_RADAR_RANGE;
  self.techLevel= DAT_dunerunner_TECH_LEVEL;
  
  self.health = DAT_dunerunner_HP;
  self.max_health = DAT_dunerunner_HP;
  self.c_model = "q3mdl/vecs/dunerunner/mdl_dunrun_chas.md3";
  
  self.energy= DAT_dunerunner_ENERGY_MAX;
  self.energyMax= DAT_dunerunner_ENERGY_MAX;
  self.energyRate= DAT_dunerunner_ENERGY_RATE;
  self.shield= 0;
  self.shieldMax= DAT_dunerunner_SHIELD_MAX;
  self.shieldRate= DAT_dunerunner_SHIELD_RATE;
  self.yaw_speed = DAT_dunerunner_YAW_SPEED;
  self.turret_yaw_speed = DAT_dunerunner_TUR_YAW;
  self.m_fspeed = DAT_dunerunner_FSPEED;
  self.m_sspeed = DAT_dunerunner_SSPEED;
  self.m_bspeed = DAT_dunerunner_BSPEED;
  self.m_pitch_max = DAT_dunerunner_PITCH_N;
  self.m_pitch_min = DAT_dunerunner_PITCH_X;
  self.w_firetime = DAT_dunerunner_LOCK_ON;
  setsize(self, DAT_dunerunner_BBX_N, DAT_dunerunner_BBX_X);
  setorigin(self, self.origin);
    
};

/*
  these are cosmetic, th_die() is per AI template and not cosmetic
  .anim_death() functions are called by the AI template th_die().
*/
void() data_dunerunner_death={
  
};

void() data_dunerunner_ctor={
  self.partTypeId = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.c_model = "q3mdl/vecs/dunerunner/mdl_dunrun_tur.md3";
  self.yaw_speed = 10;
  self.attack_state = 0;
  self.c_ofs = '0 5.35 1.25';
};

void() data_dunerunner_cam={  
  self.partParentId = M_TOR_CENTER;
  self.c_ofs = '0 12 20';
  self.c_alt_ofs = '0 0 0';
};

void() data_dunerunner_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_dunerunner_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_dunerunner_wep2={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_dunerunner_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};