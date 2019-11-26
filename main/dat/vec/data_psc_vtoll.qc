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
  //self.item_remove_upgrade = data_PSC_VTOLL_wep1;
  //self.unit_wep2 = data_PSC_VTOLL_wep2;
  //self.unit_cam = data_PSC_VTOLL_cam;
    
  self.data_idx = ID_VEC_PSC_VTOL_L;
  self.vec_name = DAT_PSC_VTOLL_NAME;
  self.vec_size = DAT_PSC_VTOLL_SIZE;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_PSC_VTOLL_RADAR_RANGE;
  self.techLevel= DAT_vtol_TECH_LEVEL;
  
  setsize(self, DAT_PSC_VTOLL_BBX_N, DAT_PSC_VTOLL_BBX_X);

  self.partTypeId = M_TOR_CENTER;
  self.health = 1;
  self.max_health = 1;
  self.modelPath = "";
  
  self.energy= DAT_PSC_VTOLL_ENERGY_MAX;
  self.energyMax= DAT_PSC_VTOLL_ENERGY_MAX;
  self.energyRate= DAT_PSC_VTOLL_ENERGY_RATE;
  self.shieldMax= DAT_PSC_VTOLL_SHIELD_MAX;
  self.shieldRate= DAT_PSC_VTOLL_SHIELD_RATE;
  self.yaw_speed = DAT_PSC_VTOLL_YAW_SPEED;
  self.modelPath = DAT_PSC_VTOLL_MODEL;
  self.data_speed_forward = DAT_PSC_VTOLL_FSPEED;
  self.data_speed_strafe = DAT_PSC_VTOLL_SSPEED;
  self.data_speed_backward = DAT_PSC_VTOLL_BSPEED;
  self.pitchMax = DAT_vtol_PITCH_N;
  self.pitchMin = DAT_vtol_PITCH_X;
  self.w_firetime = DAT_vtol_LOCK_ON;
};

void() data_PSC_VTOLL_cam={  
  self.partParentId = M_TOR_CENTER;
  self.compOffset = '0 0 24';
  self.compAltOffset = '0 0 0';
};

void() data_PSC_VTOLL_wep1={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.compOffset = DAT_PSC_VTOLL_WEP1_OFFSET;
  self.compAltOffset = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON1;
};

void() data_PSC_VTOLL_wep2={  
  self.partParentId = M_TOR_CENTER;
  self.data_idx = 0; //consult weapon idx table!
  self.compOffset = DAT_PSC_VTOLL_WEP2_OFFSET;
  self.compAltOffset = '0 0 0';
  self.w_adj_ang = '0 0 90';
  self.w_group = WEAPON2;
};