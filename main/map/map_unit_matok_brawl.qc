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
void() unit_matok_survest_brawler={ 
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
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};
void() unit_matok_militar_brawler={  
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
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_ion_coil;
      self.next_wepn5 = UID_ITEM_shield_emitter;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_particle_cannon;
      self.next_wepn5 = UID_ITEM_turbo_charger;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------ZAPPER  --------------------------------

//-------------------GUNNER  --------------------------------
void() unit_matok_militar_gunner={  
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
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_electro_repeater;
      self.next_wepn5 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_particle_cannon;
      self.next_wepn5 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_adv_reload;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_particle_cannon;
      self.next_wepn4 = UID_ITEM_particle_cannon;
      self.next_wepn5 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_electro_repeater;
      self.next_wepn4 = UID_ITEM_electro_repeater;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};
void() unit_matok_survest_gunner={ 
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
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.next_wepn5 = UID_ITEM_shield_emitter;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_rotary_plasma;
      self.next_wepn4 = UID_ITEM_rotary_plasma;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------LOBBER  --------------------------------
void() unit_matok_survest_lobber={ 
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
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rocket_launcher;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.next_wepn5 = UID_ITEM_rocket_launcher;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rocket_launcher;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};