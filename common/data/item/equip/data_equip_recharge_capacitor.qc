/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Recharge Capacitor
      Increases Unit's Energy recharge speed.
      
*/
#ifdef SSQC
void() recharge_capacitor_upgrade_;
void() recharge_capacitor_remove_;
#endif

void() data_ini_equip_recharge_capacitor_={

  self.data_idx = UID_ITEM_recharge_capacitor;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.75;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
  
  self.techLevel = 3;
  self.equipSize = MSC3;

  #ifdef CSQC
    self.w_name = "Recharge Capacitor";
    self.model = "q3mdl/weapons/e_recap.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "RECAP";
    self.description = "+ Increases <Energy recharge> rate by 75%.";
    self.icon = "gfx/ui/wep_icons/eqp_recap.png";
  #endif
  
  #ifdef SSQC
    self.item_run_upgrade = recharge_capacitor_upgrade_;
    self.think = SUB_Null;
    self.item_remove_upgrade = recharge_capacitor_remove_;
    self.w_isburst = FALSE;
  #endif
};

void() recharge_capacitor_upgrade_={
  self.energyMax = self.owner.energyRate;
  
  self.owner.energyRate = self.owner.energyRate + (self.owner.energyRate * self.energyRate);
};

void() recharge_capacitor_remove_={
  self.owner.energyRate = self.energyMax;
};
