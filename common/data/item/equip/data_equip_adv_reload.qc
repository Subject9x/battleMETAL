/*
battleMETAL
Author: Peter Roohr
Date: 12/12/2021
Overview: 
  Data File - Item - Equipemnt
    Advanced Target Module
      significant upgrade to unit's accuracy variables.
      
*/
#ifdef SSQC
void() adv_reload_upgrade_;
void() adv_reload_remove_;
#endif

void() data_ini_equip_adv_reload_={

  self.data_idx = UID_ITEM_adv_reload; 
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  self.energyRate = 0.75;
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;

  self.techLevel = 1;
  self.equipSize = MSC1;
  
  #ifdef CSQC   
    self.w_name = "Adv. Ballistic Reload";
    self.model = "q3mdl/weapons/e_abr.md3";
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "ABR";
    self.description = "| Decrease reload time by 15% for + Snub Field Artilery. + Quantum Rifle. + Missile-Active Radar. + Missile-Swarm";
    self.icon = "gfx/ui/wep_icons/eqp_abr.png";
  #endif
  
  #ifdef SSQC
    self.item_run_upgrade = adv_reload_upgrade_;
    self.item_remove_upgrade = adv_reload_remove_;
    self.think = SUB_Null;
    self.w_isburst = FALSE;
  #endif

};

#ifdef SSQC
void() adv_reload_upgrade_={
  local float hid;
  local entity wep;
  wep = self.owner.w_slot;
  for(hid = 0; hid < self.owner.hardpoint_cnt; hid = hid + 1){
    if( wep.data_idx == UID_ITEM_missile_activeradar || wep.data_idx == UID_ITEM_quantum_rifle || wep.data_idx == UID_ITEM_missile_swarm ||  wep.data_idx == UID_ITEM_snub_artillery ){
      wep.reloadMaxCache = wep.reloadMax ;
      wep.reloadMax = wep.reloadMax - (wep.reloadMaxCache * 0.15);  //use reloadMaxCache to make sure they can be stacked properly.
    }
    wep = wep.w_slot;
  }
};

void() adv_reload_remove_={
  local float hid;
  local entity wep;
  wep = self.owner.w_slot;
  for(hid = 0; hid < self.owner.hardpoint_cnt; hid = hid + 1){
    if( wep.data_idx == UID_ITEM_missile_activeradar || wep.data_idx == UID_ITEM_quantum_rifle || wep.data_idx == UID_ITEM_missile_swarm ||  wep.data_idx == UID_ITEM_snub_artillery ){
      wep.reloadMax = wep.reloadMaxCache;
    }
    wep = wep.w_slot;
  }
};
#endif
