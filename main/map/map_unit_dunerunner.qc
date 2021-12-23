/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: DUNERUNNER
  TYPE: GEV
  SIZE: SMALL
  --------------------------------
*/
void() unit_dunerunner_h={
  
  self.nextVecChoice = UID_VEHICLE_dunerunner;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      break;
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_rotary_plasma;
      self.next_wepn2 = UID_ITEM_light_laser;
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_rocket_launcher;
      self.next_wepn2 = UID_ITEM_rotary_plasma;
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      break;
  }
  macro_ai_setup(ai_gev)
};

void() unit_dunerunner_m={
  
  self.nextVecChoice = UID_VEHICLE_dunerunner;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_ion_coil;
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_light_laser;
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      break;
  }
  macro_ai_setup(ai_gev)
};