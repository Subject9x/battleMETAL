/*
battleMETAL 
Author: Peter Roohr
Date: 11/13/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: HEAVY
  TYPE: TURRET
  SIZE: LARGE
  --------------------------------
*/

//-------------------ZAPPER  --------------------------------
void() building_turret_heavy_survest_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};

void() building_turret_heavy_militar_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_psc_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};

//-------------------GUNNER  --------------------------------
void() building_turret_heavy_survest_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_militar_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_psc_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    default:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};