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

  self.data_idx = 20;  
  self.w_name = "Recharge Capacitor";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.2;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.w_attack = recharge_capacitor_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_recap.md3";
  self.i_techlvl = 3;
  self.i_size = 3;
  
  self.unit_wep1 = recharge_capacitor_remove_;
  
  self.w_isburst = FALSE;
};

void() recharge_capacitor_upgrade_={
  self.en_max = self.owner.en_rate;
  
  self.owner.en_rate = self.owner.en_rate + (self.owner.en_rate * self.en_rate);
};

void() recharge_capacitor_remove_={
  self.owner.en_rate = self.en_max;
};
