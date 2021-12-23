/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    High Strength Shield Emitters
      Increases Unit's shieldRate, ie shield recharge buff
*/
#ifdef SSQC
void() shield_emitter_upgrade_;
void() shield_emitter_remove_;
#endif

void() data_ini_equip_shield_emitter_={

  self.data_idx = UID_ITEM_shield_emitter;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.75;  // percent multiplier to unit's shieldRate
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;
  
  self.techLevel = 2;
  self.equipSize = MSC3;
  
  #ifdef CSQC  
    self.w_name = "Heavy Shield Emitter";
    self.model = "q3mdl/weapons/e_hsem.md3";  
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "HSEM";
    self.description = "+ Increases <Shield recharge> by 75%. + Energy cost <unaffected>.";
    self.icon = "gfx/ui/wep_icons/eqp_hsem.png";
  #endif
  
  #ifdef SSQC
    self.item_remove_upgrade = shield_emitter_upgrade_;
    self.item_run_upgrade = shield_emitter_upgrade_;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
  #endif
  
};

#ifdef SSQC
void() shield_emitter_upgrade_={
  self.owner.shieldRateMod = self.owner.shieldRateMod + 0.75;
  self.energyMax = self.owner.shieldRate;
};

void() shield_emitter_remove_={
  self.owner.shieldRateMod = self.owner.shieldRateMod  - 0.75;
  self.owner.shieldRate = self.energyMax;
};
#endif