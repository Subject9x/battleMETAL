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
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rocket_launcher;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.next_wepn3 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rocket_launcher;
      self.next_wepn3 = UID_ITEM_heatsink;
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
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_missile_activeradar;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
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
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.next_wepn3 = UID_ITEM_heatsink;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};
