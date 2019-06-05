/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Large Sensor Array
improves sensor radius by a percentage
*/
//Large Sensor Array=======================

void() data_eqp_lsar_upgrade;
void() data_eqp_lsar_die;

void() data_eqp_lsar_ini={
  self.data_idx = ID_EQP_LSAR;
  self.w_name = DAT_EQP_LSAR_NAME;
  self.c_model = DAT_EQP_LSAR_MODEL;
  self.unit_wep1 = data_eqp_lsar_die;
  self.energyRate = DAT_EQP_LSAR_EN_RATE;
  self.techLevel = DAT_EQP_LSAR_TECH_LEVEL;
  self.i_size = DAT_EQP_LSAR_WSIZE;
  self.w_think = data_eqp_lsar_upgrade;   //fired once on-spawn, then replaced by SUB_Null
  
  self.w_firetime = 0;
  self.w_clipsize = 0;
  self.w_currentammo = 0;
  self.w_fire_ofs = '0 0 0'; 
  self.w_attack = SUB_Null;               //dont do anything on attack
  self.w_proj = 0;
  self.reloadValue = 0;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.fire_sound = "";
  self.health = 1;
  self.max_health = 1;
  self.damageType = self.damageType | DMG_MSC;
  self.w_range = 0;
};

void() data_eqp_lsar_upgrade={
  self.energyMax = self.owner.radar_range;
  
  self.owner.radar_range  = self.owner.radar_range  + (self.owner.radar_range  * self.energyRate);
};

void() data_eqp_lsar_die={
  self.owner.radar_range  = self.energyMax;
};