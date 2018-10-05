/*
mech Mod
Author: Peter Roohr
Date: 11/5/2017
Overview:
  name    : Tank - Destroyer
  faction : Human Survivors
  type    : vehicle
  size    : medium
*/

//HUMAN LIGHT TNKRET=============================
string DAT_H_TD_PITCH_N = "-25";
string DAT_H_TD_PITCH_X = "45";

//=========================================
void() data_H_TD_ini;
void() data_H_TD_cam;
void() data_H_TD_wep1;

void() data_H_TD_ini={
  self.unit_wep1 = data_H_TD_wep1;
  self.unit_cam = data_H_TD_cam;
    
  self.data_idx= ID_VEC_HS_TDEST_L;
  self.vec_name= DAT_H_TD_VEC_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_H_TD_RADAR_RANGE;
  self.i_techlvl= DAT_H_TD_TECH_LEVEL;
  
  self.comp_id = M_TOR_CENTER;
  self.health = DAT_H_TD_HP_CTOR;
  self.max_health = DAT_H_TD_HP_CTOR;
  self.c_model = DAT_H_TD_CTOR_MODEL;
  setsize(self, DAT_H_TD_CTOR_BBX_N, DAT_H_TD_CTOR_BBX_X);
  
  self.en_cur= DAT_H_TD_ENERGY_MAX;
  self.en_max= DAT_H_TD_ENERGY_MAX;
  self.en_rate= DAT_H_TD_ENERGY_RATE;
  self.sh_cur= DAT_H_TD_SHIELD_MAX;
  self.sh_max= DAT_H_TD_SHIELD_MAX;
  self.sh_rate= DAT_H_TD_SHIELD_RATE;
  self.m_rot_speed = DAT_HS_TANKDEST_YAW_SPEED;
  self.conv_min = DAT_H_TD_SPREAD_N; 
  self.conv_max = DAT_H_TD_SPREAD_X; 
  self.m_fspeed = DAT_H_TD_FSPEED;
  self.m_sspeed = DAT_H_TD_SSPEED;
  self.m_bspeed = DAT_H_TD_BSPEED;
  self.m_pitch_max = DAT_H_TD_PITCH_N;
  self.m_pitch_min = DAT_H_TD_PITCH_X;
};

void() data_H_TD_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_H_TD_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};