/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Equipemnt
    Large Sensor Array
      30% increase in Unit's max radar range.
      
*/
#ifdef SSQC
void() heatsink_upgrade_;
void() heatsink_remove_;
#endif

void() data_ini_equip_heatsink_={

  self.data_idx = UID_ITEM_heatsink;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.5;  // percent multiplier to unit's radar range
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;
  
  self.techLevel = 1;
  self.equipSize = MSC1;
  
  #ifdef CSQC
    self.w_name = "Heatsinks";
    self.model = "q3mdl/weapons/e_htsnk.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "HTSNK";
    self.description = "| Reduce Energy cost by 15% for + EMP. + Ion Coil. + Particle Cannon.";
    self.icon = "gfx/ui/wep_icons/eqp_htsnk.png";
  #endif
  
  #ifdef SSQC
    self.item_remove_upgrade = heatsink_remove_;
    self.item_run_upgrade = heatsink_upgrade_;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
  #endif
};

#ifdef SSQC
void() heatsink_upgrade_={
  local float hid;
  local entity wep;
  wep = self.owner.w_slot;
  for(hid = 0; hid < self.owner.hardpoint_cnt; hid = hid + 1){
    if( wep.data_idx == UID_ITEM_emp || wep.data_idx == UID_ITEM_particle_cannon || wep.data_idx == UID_ITEM_ion_coil ){
      wep.energyRateCache = wep.energyRate;
      wep.energyRate = wep.energyRate - (wep.energyRateCache * 0.15); //use energyRateCache to make they can be stacked properly
    }
    wep = wep.w_slot;
  }
};

void() heatsink_remove_={
  local float hid;
  local entity wep;
  wep = self.owner.w_slot;
  for(hid = 0; hid < self.owner.hardpoint_cnt; hid = hid + 1){
    if( wep.data_idx == UID_ITEM_emp || wep.data_idx == UID_ITEM_particle_cannon || wep.data_idx == UID_ITEM_ion_coil ){
      wep.energyRate = wep.energyRateCache;
    }
    wep = wep.w_slot;
  }
};
#endif