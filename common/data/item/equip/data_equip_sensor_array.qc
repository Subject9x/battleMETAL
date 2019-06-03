/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Large Sensor Array
      30% increase in Unit's max radar range.
      
*/
void() sensor_array_upgrade_;
void() sensor_array_remove_;

void() data_ini_equip_sensor_array_={

  self.data_idx = 18;  
  self.w_name = "Large Sensor Array";
  
  self.w_clipsize = 1;
  self.rl_rate = 0;
  self.rl_max = 0;
  self.en_rate = 0.3;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.p_damage = 0;
  self.p_dmgtype = (DMG_MSC);
  
  self.w_attack = sensor_array_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_lsar.md3";
  self.i_techlvl = 1;
  self.i_size = 1;
  
  self.unit_wep1 = sensor_array_remove_;
  
  self.w_isburst = FALSE;
};

void() sensor_array_upgrade_={
  self.en_max = self.owner.radar_range;
  
  self.owner.radar_range  = self.owner.radar_range  + (self.owner.radar_range  * self.en_rate);
};

void() sensor_array_remove_={
  self.owner.radar_range  = self.en_max;
};
