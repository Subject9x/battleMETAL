/*
battleMETAL
Author: Peter Roohr
Date: 09/24/2018
Overview:
  name    : NonCom Truck Type A
  faction : Human Survivors
  type    : vehicle
  size    : medium
*/

void() data_HS_TruckA_ini;
void() data_HS_TruckA_chas;

void() data_HS_TruckA_ini={
  self.unit_ctor = data_HS_TruckA_chas;
    
  self.data_idx= ID_VEC_HS_TRUCK_C;
  self.vec_name= DAT_HS_TRUCKA_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_H_TD_RADAR_RANGE;
  self.i_techlvl= DAT_H_TD_TECH_LEVEL;
  self.en_cur= 0;
  self.en_max= 0;
  self.en_rate= 0;
  self.sh_cur= 0;
  self.sh_max= 100;
  self.sh_rate= 0;
  self.m_rot_speed = DAT_HS_TRUCK_YAW_SPEED;
  self.c_bbx_n = DAT_H_TD_CTOR_BBX_N;
  self.c_bbx_x = DAT_H_TD_CTOR_BBX_X;
  self.c_model = DAT_H_TD_CTOR_MODEL;
  self.m_fspeed = DAT_HS_TRUCK_FSPEED;
  self.m_sspeed = DAT_HS_TRUCK_SSPEED;
  self.m_bspeed = DAT_HS_TRUCK_BSPEED;
};

void() data_HS_TruckA_chas={
  self.c_name = M_TOR_CENTER;
  self.health = DAT_HS_TRUCK_HP;
  self.max_health = DAT_HS_TRUCK_HP;
  self.c_model = DAT_H_TD_CTOR_MODEL;
};
