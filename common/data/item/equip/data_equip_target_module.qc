/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Advanced Target Module
      significant upgrade to unit's accuracy variables.
      
*/
#ifndef CSQC
void() target_module_upgrade_;
void() target_module_remove_;
#endif

void() data_ini_equip_target_module_={

  self.data_idx = UID_ITEM_target_module;  
  self.w_name = "Adv. Target Module";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.25;
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);

  self.techLevel = 1;
  self.equipSize = 1;
  
  #ifdef CSQC    
    self.model = "q3mdl/weapons/e_atgm.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "ATGM";
    self.description = "+ Decrease <Lock-on> time by 25%. + Increase <Convergence> recovery by 20%.";
    self.icon = "gfx/ui/wep_icons/eqp_atgm.png";
  #endif
  
  #ifndef CSQC
  self.spreadDefault = '0.25 0.20 0.25';  //upgrades Unit's accuracy
  self.w_attack = target_module_upgrade_;
  self.item_remove_upgrade = target_module_remove_;
  self.think = SUB_Null;
  self.w_isburst = FALSE;
  self.model = "q3mdl/weapons/e_atgm.md3";
  #endif

};

#ifndef CSQC
void() target_module_upgrade_={
  local float lock;
  
  //stats cached here for restore on equip death
  self.w_firetime = self.owner.w_firetime;
  self.wepFireOffset = self.owner.spreadDefault;
  self.accuracyMod = self.spreadDefault_z * self.wepFireOffset_z;
  self.owner.accuracyMod = self.owner.accuracyMod + self.accuracyMod;
  self.owner.spreadDefault_x = self.owner.spreadDefault_x - (self.owner.spreadDefault_x * self.spreadDefault_x);
  self.owner.spreadDefault_y = self.owner.spreadDefault_y - (self.owner.spreadDefault_y * self.spreadDefault_y);
  self.owner.spreadDefault_z = self.owner.spreadDefault_z - (self.owner.spreadDefault_z * self.spreadDefault_z);
  
  lock = self.owner.w_firetime;
  lock = lock - (lock * self.wepFireOffset_z);
  if(lock < 0){
    lock = 0.01;
  }
  self.wepFireOffsetCache = self.wepFireOffset;
  self.owner.w_firetime = lock;
};

void() target_module_remove_={
  self.owner.w_firetime = self.w_firetime;
  self.owner.spreadDefault = self.wepFireOffset;
  self.owner.accuracyMod = self.owner.accuracyMod - self.accuracyMod;
};
#endif
