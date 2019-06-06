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

  self.data_idx = UID_ITEM_large_sensors;  
  self.w_name = "Large Sensor Array";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.3;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
  
  self.w_attack = sensor_array_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_lsar.md3";
  self.techLevel = 1;
  self.i_size = 1;
  
  self.unit_wep1 = sensor_array_remove_;
  
  self.w_isburst = FALSE;
  
  self.abbrev = "LSAR";
  self.description = "Increases RADAR RANGE by 30%.~";
  self.icon = "gfx/ui/wep_icons/eqp_lsar.png";
};

void() sensor_array_upgrade_={
  self.energyMax = self.owner.radar_range;
  
  self.owner.radar_range  = self.owner.radar_range  + (self.owner.radar_range  * self.energyRate);
};

void() sensor_array_remove_={
  self.owner.radar_range  = self.energyMax;
};
