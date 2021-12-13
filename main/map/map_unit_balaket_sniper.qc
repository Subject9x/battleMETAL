/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: BALAKET
  TYPE: METAL
  SIZE: LIGHT
  --------------------------------
*/
void() unit_balaket_survest_sniper={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech   
  self.nextVecChoice = UID_MECH_balaket;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      self.next_wepn3 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_balaket_militar_sniper={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech   
  self.nextVecChoice = UID_MECH_balaket;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};
