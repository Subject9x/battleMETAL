/*
battleMETAL 
Author: Peter Roohr
Date: 11/13/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: MISSILE
  TYPE: TURRET
  SIZE: MEDIUM
  --------------------------------
*/

//-------------------LOBBER  --------------------------------
void() building_turret_missile_survest_lobber={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_large_sensors, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_large_sensors, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_missile_militar_lobber={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_large_sensors, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_missile_psc_lobber={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 1:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};
