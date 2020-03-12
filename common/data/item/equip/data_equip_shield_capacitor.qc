/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Shield Capacitor
      Increases Unit's MAX shield capacity
*/
#ifndef CSQC
void() shield_capacitor_upgrade_;
void() shield_capacitor_remove_;
#endif

void() data_ini_equip_shield_capacitor_={

  self.data_idx = UID_ITEM_shield_capacitor; 
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.25;  //percent multiplier to unit's shieldMax
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);

  self.techLevel = 3;
  self.equipSize = 2;
  
  #ifdef CSQC   
    self.w_name = "Shield Capacitor";
    self.model = "q3mdl/weapons/e_scap.md3";  
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "SCAP";
    self.description = "+ Increases <Shield Maximum> by 25%.";
    self.icon = "gfx/ui/wep_icons/eqp_lscap.png";
  #endif
  
  #ifndef CSQC
    self.item_remove_upgrade = shield_capacitor_remove_;
    self.w_attack = shield_capacitor_upgrade_;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
    self.model = "q3mdl/weapons/e_scap.md3";
  #endif
};

#ifndef CSQC
void() shield_capacitor_upgrade_={
  self.energyMax = self.owner.shieldMax;
  
  self.owner.shieldMax  = self.owner.shieldMax + (self.owner.shieldMax  * self.energyRate);
};

void() shield_capacitor_remove_={
  self.owner.shieldMax  = self.energyMax;
};
#endif