/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Shield Capacitor
      Increases Unit's MAX shield capacity
*/
void() shield_capacitor_upgrade_;
void() shield_capacitor_remove_;

void() data_ini_equip_shield_capacitor_={

  self.data_idx = UID_ITEM_shield_capacitor;  
  self.w_name = "Shield Capacitor";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.15;  // percent multiplier to unit's sh_max
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.w_attack = shield_capacitor_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_scap.md3";
  self.i_techlvl = 3;
  self.i_size = 2;
  
  self.unit_wep1 = shield_capacitor_remove_;
  
  self.w_isburst = FALSE;
};

void() shield_capacitor_upgrade_={
  self.en_max = self.owner.sh_max;
  
  self.owner.sh_max  = self.owner.sh_max + (self.owner.sh_max  * self.en_rate);
};

void() shield_capacitor_remove_={
  self.owner.sh_max  = self.en_max;
};
