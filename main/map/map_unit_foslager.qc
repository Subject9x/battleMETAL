/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: FOSLAGER
  TYPE: TANK
  SIZE: MEDIUM
  --------------------------------
*/
//-------------------ZAPPER  --------------------------------
void() unit_foslager_survest_zapper={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_SURVEST;
   
  self.flags = FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_flak;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_foslager_militar_zapper={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_MILITAR;
   
  self.flags = FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  self.spreadDefault = ACCURACY_SKIRMISH;
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_adv_reload;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

//-------------------GUNNER  --------------------------------
void() unit_foslager_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_SURVEST;
   
  self.flags = FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_flak;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_foslager_militar_gunner={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_MILITAR;
   
  self.flags = FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_flak;
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_light_laser;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};