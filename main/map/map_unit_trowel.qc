/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: TROWEL
  TYPE: TANK
  SIZE: HEAVY
  --------------------------------
*/
//-------------------LOBBER--------------------------------
void() unit_trowel_militar_lobber={
  
  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_missile_activeradar;
      self.next_wepn5 = UID_ITEM_light_laser;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_missile_activeradar;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_missile_activeradar;
      self.next_wepn4 = UID_ITEM_missile_activeradar;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_missile_activeradar;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_trowel_survest_lobber={

  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_light_laser;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_light_laser;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rocket_launcher;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

//-------------------GUNNER  --------------------------------
void() unit_trowel_militar_gunner={
  
  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_energy_battery;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.next_wepn3 = UID_ITEM_energy_battery;
      self.next_wepn4 = UID_ITEM_recharge_capacitor;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_energy_battery;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_trowel_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  //
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_turbo_charger;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_energy_battery;
      self.next_wepn5 = UID_ITEM_light_laser;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_light_autocannon;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_energy_battery;
      self.next_wepn5 = UID_ITEM_light_laser;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_flak;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_turbo_charger;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};