/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    High Strength Shield Emitters
      Increases Unit's shieldRate, ie shield recharge buff
*/
#ifndef CSQC
void() shield_emitter_upgrade_;
void() shield_emitter_remove_;
#endif

void() data_ini_equip_shield_emitter_={

  self.data_idx = UID_ITEM_shield_emitter;  
  self.w_name = "Heavy Shield Emitter";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.5;  // percent multiplier to unit's shieldRate
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;
  
  self.techLevel = 2;
  self.i_size = 2;
  
  #ifdef CSQC
  self.abbrev = "HSEM";
  self.description = "+ Increases <Shield recharge> by 50%.";
  self.icon = "gfx/ui/wep_icons/eqp_hsem.png";
  #endif
  
  #ifndef CSQC
  self.unit_wep1 = shield_capacitor_remove_;
  self.w_attack = shield_emitter_upgrade_;
  self.think = SUB_Null;
  self.w_isburst = FALSE;
  self.model = "q3mdl/weapons/e_hsem.md3";
  #endif
  
};

#ifndef CSQC
void() shield_emitter_upgrade_={

  self.energyMax = self.owner.shieldRate;
  self.owner.shieldRate  = self.owner.shieldRate + (self.owner.shieldRate  * self.energyRate);
};

void() shield_emitter_remove_={
  self.owner.shieldRate = self.energyMax;
};
#endif