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
  
  self.w_clipsize = 0;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0;
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = 0;

  self.techLevel = 1;
  self.equipSize = MSC1;
  
  #ifdef CSQC  
    self.w_name = "-EMPTY-";
    self.model = "q3mdl/testball.md3";
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
    self.alpha = 0.01;
    self.scale = 0.01;
    self.drawmask = 0;
  #endif
  
  #ifdef SSQC  
    self.spreadDefault = '0 0 0';
    self.w_attack = SUB_Null;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
    self.burstRate = 1;
    self.wepFireOffset = self.wepFireOffsetCache = '0 0 0 ';
    self.scale = 0.01;
    self.alpha = 0.01;
  #endif
};