/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    High Strength Shield Emitters
      Increases Unit's sh_rate, ie shield recharge buff
*/
void() shield_emitter_upgrade_;
void() shield_emitter_remove_;

void() data_ini_equip_shield_emitter_={

  self.data_idx = UID_ITEM_shield_emitter;  
  self.w_name = "Heavy Shield Emitter";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.5;  // percent multiplier to unit's sh_rate
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.w_attack = shield_emitter_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_hsem.md3";
  self.i_techlvl = 2;
  self.i_size = 2;
  
  self.unit_wep1 = shield_capacitor_remove_;
  
  self.w_isburst = FALSE;
};

void() shield_emitter_upgrade_={
  self.en_max = self.owner.sh_rate;
  
  self.owner.sh_rate  = self.owner.sh_rate + (self.owner.sh_rate  * self.en_rate);
};

void() shield_emitter_remove_={
  self.owner.sh_rate  = self.en_max;
};
