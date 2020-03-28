/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Large Sensor Array
      30% increase in Unit's max radar range.
      
*/
#ifndef CSQC
void() sensor_array_upgrade_;
void() sensor_array_remove_;
#endif

void() data_ini_equip_sensor_array_={

  self.data_idx = UID_ITEM_large_sensors;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.3;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
  
  self.techLevel = 1;
  self.equipSize = MSC1;
  
  #ifdef CSQC
    self.w_name = "Large Sensor Array";
    self.model = "q3mdl/weapons/e_lsar.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "LSAR";
    self.description = "+ Increases <Radar Range> by 30%.";
    self.icon = "gfx/ui/wep_icons/eqp_lsar.png";
  #endif
  
  #ifndef
    self.item_remove_upgrade = sensor_array_remove_;
    self.w_attack = sensor_array_upgrade_;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
    self.model = "q3mdl/weapons/e_lsar.md3";
  #endif
};

#ifndef CSQC
void() sensor_array_upgrade_={
  self.energyMax = self.owner.radar_range;
  self.owner.radar_range  = self.owner.radar_range  + (self.owner.radar_range  * self.energyRate);
  self.owner.doRadarSweep = radarSweepAdv;
};

void() sensor_array_remove_={
  self.owner.radar_range  = self.energyMax;
  self.owner.doRadarSweep = radarSweepBasic;
};
#endif