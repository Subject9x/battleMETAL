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
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};
