/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
*/

//-------------------ZAPPER  --------------------------------
void() unit_monitor_survest_zapper={  
  self.faction = FACTION_SURVEST;
  self.flags = self.flags | FL_TURRET;  //enforced for a mech
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
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_emp;
      self.next_wepn6 = UID_ITEM_emp;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_energy_battery;
      self.next_wepn9 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_ion_coil;
      self.next_wepn6 = UID_ITEM_ion_coil;
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_ion_coil;
      self.next_wepn9 = UID_ITEM_ion_coil;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_light_laser;
      self.next_wepn6 = UID_ITEM_light_laser;
      self.next_wepn7 = UID_ITEM_energy_battery;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------GUNNER  --------------------------------
void() unit_monitor_survest_gunner={  
  self.faction = FACTION_SURVEST;
  self.flags = self.flags | FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_flak;
      self.next_wepn6 = UID_ITEM_flak;
      self.next_wepn7 = UID_ITEM_flak;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_rotary_plasma;
      self.next_wepn6 = UID_ITEM_rotary_plasma;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_adv_reload;
      self.next_wepn9 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_rotary_plasma;
      self.next_wepn6 = UID_ITEM_rotary_plasma;
      self.next_wepn7 = UID_ITEM_adv_reload;
      self.next_wepn8 = UID_ITEM_rotary_plasma;
      self.next_wepn9 = UID_ITEM_rotary_plasma;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_flak;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.next_wepn6 = UID_ITEM_light_autocannon;
      self.next_wepn7 = UID_ITEM_EMPTY;
      self.next_wepn8 = UID_ITEM_EMPTY;
      self.next_wepn9 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------LOBBER  --------------------------------
void() unit_monitor_militar_lobber={  
  self.faction = FACTION_MILITAR;
  self.flags = self.flags | FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.next_wepn6 = UID_ITEM_missile_activeradar;
      self.next_wepn7 = UID_ITEM_missile_activeradar;
      self.next_wepn8 = UID_ITEM_shield_capacitor;
      self.next_wepn9 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.next_wepn6 = UID_ITEM_missile_activeradar;
      self.next_wepn7 = UID_ITEM_missile_activeradar;
      self.next_wepn8 = UID_ITEM_heatsink;
      self.next_wepn9 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.next_wepn6 = UID_ITEM_missile_activeradar;
      self.next_wepn7 = UID_ITEM_adv_reload;
      self.next_wepn8 = UID_ITEM_missile_activeradar;
      self.next_wepn9 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.next_wepn6 = UID_ITEM_missile_activeradar;
      self.next_wepn7 = UID_ITEM_shield_emitter;
      self.next_wepn8 = UID_ITEM_shield_capacitor;
      self.next_wepn9 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};
