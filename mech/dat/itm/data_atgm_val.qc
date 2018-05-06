/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Equipment module - Advanced Targeting Module
this decreases a Metal's lock-on time by 20%
and improves accuracy recovery by 15%;
*/
//ADVANCED TARGETING MODULE=======================
void() data_eqp_atgm_upgrade; //this takes the place of the weapon's think code;
void() data_eqp_atgm_die;

void() data_eqp_atgm_ini={
  self.data_idx = ID_EQP_ATGM;
  self.w_name = DAT_EQP_ATGM_NAME;
  self.w_firetime = 0;
  self.w_clipsize = 0;
  self.w_currentammo = 0;
  self.w_fire_ofs = DAT_EQP_ATGM_FIRE_OFS; //carrier var for modification by equipment
  self.c_model = DAT_EQP_ATGM_MODEL;
  self.w_attack = SUB_Null;               //dont do anything on attack
  self.unit_wep1 = data_eqp_atgm_die;
  self.w_proj = 0;
  self.rl_cur = 0;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0;
  self.fire_sound = "";
  self.i_techlvl = DAT_EQP_ATGM_TECH_LEVEL;
  self.i_size = DAT_EQP_ATGM_WSIZE;
  self.w_think = data_eqp_atgm_upgrade;   //fired once on-spawn, then replaced by SUB_Null
  self.health = 1;
  self.max_health = 1;
  self.p_dmgtype = self.p_dmgtype | DMG_MSC;
  self.w_range = 0;
};

void() data_eqp_atgm_upgrade={
  local float lock, acc_n, acc_x;
  
  //stats cached here for restore on equip death
  self.w_firetime = self.owner.w_firetime;
  self.conv_min = self.owner.conv_min;
  self.conv_max = self.owner.conv_max;
  
  lock = self.owner.w_firetime;
  lock = lock - (lock * self.w_fire_ofs_z);
  if(lock < 0){
    lock = 0.01;
  }
  self.owner.w_firetime = lock;
  
  acc_n = self.owner.conv_min_z;
  acc_n = acc_n + (acc_n * self.w_fire_ofs_x);
  self.owner.conv_min_z = acc_n;
  
  acc_x = self.owner.conv_max_z;
  acc_x = acc_x + (acc_x * self.w_fire_ofs_y);
  self.owner.conv_max_z = acc_x;  
};

void() data_eqp_atgm_die={
  self.owner.w_firetime = self.w_firetime;
  self.owner.conv_min = self.conv_min;
  self.owner.conv_max = self.conv_max;
};