/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: MATOK
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_matok_survest_sniper={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_matok_militar_sniper={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_missile_laserguide;
      self.next_wepn4 = UID_ITEM_missile_laserguide;
      self.next_wepn5 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_electro_repeater;
      self.next_wepn5 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_missile_laserguide;
      self.next_wepn4 = UID_ITEM_missile_laserguide;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_matok_psc_sniper={
  self.faction = FACTION_PSC;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_adv_reload;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_emp;
      self.next_wepn5 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_adv_reload;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_particle_cannon;
      self.next_wepn5 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_adv_reload;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_particle_cannon;
      self.next_wepn5 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      self.next_wepn1 = UID_ITEM_adv_reload;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------ZAPPER  --------------------------------
void() unit_matok_militar_zapper={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_EMPTY;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_emp;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_EMPTY;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_emp;
      self.next_wepn4 = UID_ITEM_emp;
      self.next_wepn5 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_EMPTY;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_matok_survest_zapper={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.next_wepn5 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};
