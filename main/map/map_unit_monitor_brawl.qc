/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: MONITOR
  TYPE: METAL
  SIZE: HEAVY
  --------------------------------
*/
void() unit_monitor_survest_brawler={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_rotary_plasma;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.next_wepn6 = UID_ITEM_adv_reload;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_flak;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.next_wepn6 = UID_ITEM_missile_laserguide;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_shield_emitter;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_rotary_plasma;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

void() unit_monitor_militar_brawler={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_electro_repeater;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_missile_activeradar;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_emp;
      self.next_wepn6 = UID_ITEM_electro_repeater;
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_missile_activeradar;
      self.next_wepn9 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_particle_cannon;
      self.next_wepn6 = UID_ITEM_snub_artillery;
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_missile_activeradar;
      self.next_wepn9 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_electro_repeater;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

void() unit_monitor_psc_brawler={
  self.faction = FACTION_PSC;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_particle_cannon;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_recharge_capacitor;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_flak;
      self.next_wepn5 = UID_ITEM_particle_cannon;
      self.next_wepn6 = UID_ITEM_particle_cannon;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_recharge_capacitor;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_flak;
      self.next_wepn5 = UID_ITEM_particle_cannon;
      self.next_wepn6 = UID_ITEM_particle_cannon;
      self.next_wepn7 = UID_ITEM_recharge_capacitor;
      self.next_wepn8 = UID_ITEM_recharge_capacitor;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_particle_cannon;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_recharge_capacitor;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------ZAPPER  --------------------------------
void() unit_monitor_militar_zapper={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
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
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_energy_battery;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_emp;
      self.next_wepn6 = UID_ITEM_emp;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_energy_battery;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_emp;
      self.next_wepn6 = UID_ITEM_emp;
      self.next_wepn7 = UID_ITEM_recharge_capacitor;
      self.next_wepn8 = UID_ITEM_energy_battery;
      self.next_wepn9 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_adv_reload;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------GUNNER  --------------------------------
void() unit_monitor_militar_gunner={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_flak;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_snub_artillery;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_electro_repeater;
      self.next_wepn6 = UID_ITEM_particle_cannon;
      self.next_wepn7 = UID_ITEM_snub_artillery;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_electro_repeater;
      self.next_wepn6 = UID_ITEM_electro_repeater;
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_snub_artillery;
      self.next_wepn9 = UID_ITEM_snub_artillery;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};


//-------------------LOBBER  --------------------------------
void() unit_monitor_survest_lobber={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_rocket_launcher;
      self.next_wepn6 = UID_ITEM_rocket_launcher;
      self.next_wepn7 = UID_ITEM_adv_reload;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.next_wepn6 = UID_ITEM_missile_laserguide;
      self.next_wepn7 = UID_ITEM_adv_reload;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.next_wepn6 = UID_ITEM_missile_laserguide;
      self.next_wepn7 = UID_ITEM_missile_laserguide;
      self.next_wepn8 = UID_ITEM_rocket_launcher;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_rocket_launcher;
      self.next_wepn6 = UID_ITEM_rocket_launcher;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};