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

//HUMAN LIGHT TNKRET=============================
//string DAT_H_TD_PITCH_N = "-25";
//string DAT_H_TD_PITCH_X = "45";

//WEAPON1
//vector DAT_H_TD_WEP1_OFFSET_ALT = '0 0 0';
//vector DAT_H_TD_WEP1_ADJ_ANG= '0 0 90';

//CAMERA
//string DAT_H_TD_CAM_CNAME= "camera";
//vector DAT_H_TD_CAM_OFFSET= '0 0 0';
//vector DAT_H_TD_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_PSC_VTOLL_ini;
void() data_PSC_VTOLL_ctor;
void() data_PSC_VTOLL_wep1;
void() data_PSC_VTOLL_wep2;

void() data_PSC_VTOLL_ini={
  self.unit_ctor = data_PSC_VTOLL_ctor;
  self.unit_wep1 = data_PSC_VTOLL_wep1;
  self.unit_wep2 = data_PSC_VTOLL_wep2;
    
  self.data_idx= ID_VEC_PSC_VTOL_L;
  self.vec_name= DAT_PSC_VTOLL_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_PSC_VTOLL_RADAR_RANGE;
  self.i_techlvl= DAT_H_TD_TECH_LEVEL;
  self.en_cur= DAT_PSC_VTOLL_ENERGY_MAX;
  self.en_max= DAT_PSC_VTOLL_ENERGY_MAX;
  self.en_rate= DAT_PSC_VTOLL_ENERGY_RATE;
  self.sh_cur= 0;
  self.sh_max= DAT_PSC_VTOLL_SHIELD_MAX;
  self.sh_rate= DAT_PSC_VTOLL_SHIELD_RATE;
  self.m_rot_speed = DAT_PSC_VTOLL_YAW_SPEED;
  self.c_bbx_n = DAT_PSC_VTOLL_BBX_N;
  self.c_bbx_x = DAT_PSC_VTOLL_BBX_X;
  self.c_model = DAT_PSC_VTOLL_MODEL;
  self.conv_min = DAT_PSC_VTOLL_SPREAD_N; 
  self.conv_max = DAT_PSC_VTOLL_SPREAD_X; 
  self.m_fspeed = DAT_PSC_VTOLL_FSPEED;
  self.m_sspeed = DAT_PSC_VTOLL_SSPEED;
  self.m_bspeed = DAT_PSC_VTOLL_BSPEED;
  self.m_pitch_max = DAT_H_TD_PITCH_N;
  self.m_pitch_min = DAT_H_TD_PITCH_X;
};

void() data_PSC_VTOLL_ctor={
  self.comp_id = M_TOR_CENTER;
  self.health = DAT_H_TD_HP_CTOR;
  self.max_health = DAT_H_TD_HP_CTOR;
  self.c_model = DAT_H_TD_CTOR_MODEL;
};

void() data_PSC_VTOLL_wep1={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_TANKL_WEP1_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_PSC_VTOLL_wep2={  
  self.c_parent = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.c_ofs = DAT_HS_TANKL_WEP2_OFFSET;
  self.c_alt_ofs = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};