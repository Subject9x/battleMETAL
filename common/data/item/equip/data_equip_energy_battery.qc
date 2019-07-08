/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Energy Battery
      Increases Unit's Energy maximum
      
*/
#ifndef CSQC
void() energy_battery_upgrade_;
void() energy_battery_remove_;
#endif

void() data_ini_equip_energy_battery_={

  self.data_idx = UID_ITEM_energy_battery;  
  self.w_name = "Energy Battery";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.2;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
 
  self.techLevel = 2;
  self.i_size = 3;
  
  #ifdef CSQC
  self.abbrev = "ENBAT";
  self.description = "Increases TOTAL MECH ENERGY by 25%.~";
  self.icon = "gfx/ui/wep_icons/eqp_enbat.png";
  #endif
  
  #ifndef CSQC
  self.w_attack = energy_battery_upgrade_;
  self.think = SUB_Null;
  self.unit_wep1 = energy_battery_remove_;
  self.model = "q3mdl/weapons/e_enbat.md3";
  self.w_isburst = FALSE;
  #endif
};

#ifndef CSQC
void() energy_battery_upgrade_={
  self.energyMax = self.owner.energyMax;
  self.owner.energyMax = self.owner.energyMax + (self.owner.energyMax * self.energyRate);
};

void() energy_battery_remove_={
  self.owner.energyMax = self.energyMax;
};
#endif