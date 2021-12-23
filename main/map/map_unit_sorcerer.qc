/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: SORCERER
  TYPE: TANK MISSILE
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_sorcerer_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_SURVEST;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  self.next_wepn1 = UID_ITEM_rotary_plasma;
  self.next_wepn2 = UID_ITEM_rotary_plasma;
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_sorcerer_militar_gunner={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  self.next_wepn1 = UID_ITEM_electro_repeater;
  self.next_wepn2 = UID_ITEM_electro_repeater;
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------LOBBER  --------------------------------
void() unit_sorcerer_survest_lobber={
  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_SURVEST;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  self.next_wepn1 = UID_ITEM_rocket_launcher;
  self.next_wepn2 = UID_ITEM_rocket_launcher;
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_sorcerer_militar_lobber={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_MILITAR;
   
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  self.next_wepn1 = UID_ITEM_missile_activeradar;
  self.next_wepn2 = UID_ITEM_missile_activeradar;
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_vec_dest)
};
