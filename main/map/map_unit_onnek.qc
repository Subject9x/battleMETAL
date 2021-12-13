/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: ONNEK
  TYPE: TANK DESTROYER
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_onnek_h={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_quantum_rifle;
      self.next_wepn2 = UID_ITEM_quantum_rifle;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_m={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------ZAPPER  --------------------------------
void() unit_onnek_militar_zapper={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_adv_reload;
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_recharge_capacitor;
      self.next_wepn4 = UID_ITEM_adv_reload;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_emp;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_recharge_capacitor;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_EMPTY;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_zapper={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_adv_reload;
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.next_wepn3 = UID_ITEM_ion_coil;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_ion_coil;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------GUNNER  --------------------------------
void() unit_onnek_militar_gunner={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_flak;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.next_wepn4 = UID_ITEM_heatsink;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_flak;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_adv_reload;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_electro_repeater;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_flak;
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------LOBBER --------------------------------
void() unit_onnek_militar_lobber={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_flak;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_snub_artillery;
      self.next_wepn3 = UID_ITEM_snub_artillery;
      self.next_wepn4 = UID_ITEM_flak;
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_EMPTY;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_lobber={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_light_laser;
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};