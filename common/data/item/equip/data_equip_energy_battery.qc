/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Energy Battery
      Increases Unit's Energy maximum
      
*/
#ifdef SSQC
void() energy_battery_upgrade_;
void() energy_battery_remove_;
#endif

void() data_ini_equip_energy_battery_={

  self.data_idx = UID_ITEM_energy_battery;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.67;  // percent multiplier to unit's Energy Max
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;
 
  self.techLevel = 2;
  self.equipSize = MSC2;
  
  #ifdef CSQC
    self.w_name = "Energy Battery";
    self.model = "q3mdl/weapons/e_enbat.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "ENBAT";
    self.description = "+ Increases <Energy maximum> by 67%.";
    self.icon = "gfx/ui/wep_icons/eqp_enbat.png";
  #endif
  
  #ifdef SSQC
    self.think = SUB_Null;
    self.item_run_upgrade = energy_battery_upgrade_;
    self.item_remove_upgrade = energy_battery_remove_;
    self.w_isburst = FALSE;
  #endif
};

#ifdef SSQC
void() energy_battery_upgrade_={
  self.energyMax = self.owner.energyMax;
  self.owner.energyMax = self.owner.energyMax + (self.owner.energyMax * self.energyRate);
};

void() energy_battery_remove_={
  self.owner.energyMax = self.energyMax;
};
#endif