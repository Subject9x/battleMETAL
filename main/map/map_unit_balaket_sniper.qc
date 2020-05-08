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
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_laser, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_flak, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_laser, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
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
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_EMPTY, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_autocannon, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_flak, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_EMPTY, UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};
