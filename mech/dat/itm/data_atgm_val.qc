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
  self.spreadDefault = DAT_ATGM_ACC;
  self.c_model = DAT_EQP_ATGM_MODEL;
  self.w_attack = SUB_Null;               //dont do anything on attack
  self.unit_wep1 = data_eqp_atgm_die;
  self.w_proj = 0;
  self.reloadValue = 0;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0;
  self.fire_sound = "";
  self.techLevel = DAT_EQP_ATGM_TECH_LEVEL;
  self.i_size = DAT_EQP_ATGM_WSIZE;
  self.w_think = data_eqp_atgm_upgrade;   //fired once on-spawn, then replaced by SUB_Null
  self.health = 1;
  self.max_health = 1;
  self.damageType = self.damageType | DMG_MSC;
  self.w_range = 0;
};

void() data_eqp_atgm_upgrade={
  local float lock, acc_n, acc_x;
  
  //stats cached here for restore on equip death
  self.w_firetime = self.owner.w_firetime;
  self.w_fire_ofs = self.owner.spreadDefault;
  self.accuracyMod = self.spreadDefault_z * self.w_fire_ofs_z;
  self.owner.accuracyMod = self.owner.accuracyMod + self.accuracyMod;
  self.owner.spreadDefault_x = self.owner.spreadDefault_x - (self.owner.spreadDefault_x * self.spreadDefault_x);
  self.owner.spreadDefault_y = self.owner.spreadDefault_y - (self.owner.spreadDefault_y * self.spreadDefault_y);
  self.owner.spreadDefault_z = self.owner.spreadDefault_z - (self.owner.spreadDefault_z * self.spreadDefault_z);
  
  lock = self.owner.w_firetime;
  lock = lock - (lock * self.w_fire_ofs_z);
  if(lock < 0){
    lock = 0.01;
  }
  self.owner.w_firetime = lock;
  
};

void() data_eqp_atgm_die={
  self.owner.w_firetime = self.w_firetime;
  self.owner.spreadDefault = self.w_fire_ofs;
  self.owner.accuracyMod = self.owner.accuracyMod - self.accuracyMod;
};