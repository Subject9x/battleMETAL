/*
battleMETAL
Author: Peter Roohr
Date:  09/29/2019
Overview: 
  Data File - Item
    Empty weapon, null functions.
*/
void() data_ini_empty_weapon_={

  self.data_idx = UID_ITEM_NULL;  
  self.w_name = "-EMPTY-";
  
  self.w_clipsize = 0;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0;
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = 0;

  self.techLevel = 1;
  self.equipSize = 1;
  
  #ifdef CSQC  
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.damageType = 0;
    self.techLevel = -1;
    self.abbrev = "NON";
    self.description = "+ this weapon slot is Empty.";
    self.icon = "gfx/ui/wep_icons/eqp_empty.png";
  #endif
  
  #ifndef CSQC  
  self.spreadDefault = '0 0 0';
  self.w_attack = SUB_Null;
  self.think = SUB_Null;
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0 0 ';
  self.fire_sound = "";
  self.model = "";
  #endif
};