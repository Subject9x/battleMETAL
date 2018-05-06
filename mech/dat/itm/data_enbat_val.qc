/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Energy Battery
*/
//Energy Battery=======================

void() data_eqp_enbat_upgrade;
void() data_eqp_enbat_die;

void() data_eqp_enbat_ini={
  self.data_idx = ID_EQP_ENBAT;
  self.w_name = DAT_EQP_ENBAT_NAME;
  self.c_model = DAT_EQP_ENBAT_MODEL;
  self.unit_wep1 = data_eqp_enbat_die;
  self.en_rate = DAT_EQP_ENBAT_EN_RATE;
  self.i_techlvl = DAT_EQP_ENBAT_TECH_LEVEL;
  self.i_size = DAT_EQP_ENBAT_WSIZE;
  self.w_think = data_eqp_enbat_upgrade;   //fired once on-spawn, then replaced by SUB_Null
  
  self.w_firetime = 0;
  self.w_clipsize = 0;
  self.w_currentammo = 0;
  self.w_fire_ofs = '0 0 0'; 
  self.w_attack = SUB_Null;               //dont do anything on attack
  self.w_proj = 0;
  self.rl_cur = 0;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.fire_sound = "";
  self.health = 1;
  self.max_health = 1;
  self.p_dmgtype = self.p_dmgtype | DMG_MSC;
  self.w_range = 0;
};

void() data_eqp_enbat_upgrade={
  self.en_max = self.owner.en_max;
  self.owner.en_max = self.owner.en_max + (self.owner.en_max * self.en_rate);
};

void() data_eqp_enbat_die={
  self.owner.en_max = self.en_max;
};