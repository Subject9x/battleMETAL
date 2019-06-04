/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Advanced Target Module
      significant upgrade to unit's accuracy variables.
      
*/
void() target_module_upgrade_;
void() target_module_remove_;

void() data_ini_equip_target_module_={

  self.data_idx = UID_ITEM_target_module;  
  self.w_name = "Adv. Target Module";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.2;
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.spreadDefault = '0.25 0.15 0.25';  //upgrades Unit's accuracy
  
  self.w_attack = target_module_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_atgm.md3";
  self.i_techlvl = 1;
  self.i_size = 2;
  
  self.unit_wep1 = target_module_remove_;
  
  self.w_isburst = FALSE;
};

void() target_module_upgrade_={
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

void() target_module_remove_={
  self.owner.w_firetime = self.w_firetime;
  self.owner.spreadDefault = self.w_fire_ofs;
  self.owner.accuracyMod = self.owner.accuracyMod - self.accuracyMod;
};
