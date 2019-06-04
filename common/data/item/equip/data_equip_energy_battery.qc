/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Energy Battery
      Increases Unit's Energy maximum
      
*/
void() energy_battery_upgrade_;
void() energy_battery_remove_;

void() data_ini_equip_energy_battery_={

  self.data_idx = UID_ITEM_energy_battery;  
  self.w_name = "Energy Battery";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.2;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.w_attack = energy_battery_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_enbat.md3";
  self.i_techlvl = 2;
  self.i_size = 3;
  
  self.unit_wep1 = energy_battery_remove_;
  
  self.w_isburst = FALSE;
};

void() energy_battery_upgrade_={
  self.en_max = self.owner.en_max;
  self.owner.en_max = self.owner.en_max + (self.owner.en_max * self.en_rate);
};

void() energy_battery_remove_={
  self.owner.en_max = self.en_max;
};
