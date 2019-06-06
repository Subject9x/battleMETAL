/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Recharge Capacitor
      Increases Unit's Energy recharge speed.
      
*/
void() recharge_capacitor_upgrade_;
void() recharge_capacitor_remove_;

void() data_ini_equip_recharge_capacitor_={

  self.data_idx = UID_ITEM_recharge_capacitor;  
  self.w_name = "Recharge Capacitor";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.2;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
  
  self.w_attack = recharge_capacitor_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_recap.md3";
  self.techLevel = 3;
  self.i_size = 3;
  
  self.unit_wep1 = recharge_capacitor_remove_;
  
  self.w_isburst = FALSE;
  
  self.abbrev = "RECAP";
  self.description = "Increases Reactor RECHARGE rate by 20%~";
  self.icon = "gfx/ui/wep_icons/eqp_recap.png";
};

void() recharge_capacitor_upgrade_={
  self.energyMax = self.owner.energyRate;
  
  self.owner.energyRate = self.owner.energyRate + (self.owner.energyRate * self.energyRate);
};

void() recharge_capacitor_remove_={
  self.owner.energyRate = self.energyMax;
};
