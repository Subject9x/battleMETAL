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
void() unit_sorcerer_h={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
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
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  self.think = ai_vec_dest;
  self.nextthink = time + 0.05;
};

void() unit_sorcerer_m={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_swarm, UID_ITEM_missile_swarm, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  self.think = ai_vec_dest;
  self.nextthink = time + 0.05;
};

//-------------------LOBBER  --------------------------------
void() unit_sorcerer_survest_lobber={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
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
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  self.think = ai_vec_dest;
  self.nextthink = time + 0.05;
};

void() unit_sorcerer_militar_lobber={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  self.think = ai_vec_dest;
  self.nextthink = time + 0.05;
};
