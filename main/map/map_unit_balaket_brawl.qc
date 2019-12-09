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
void() unit_balaket_brawl_h={
  self.faction = FACTION_SURVEST;
  self.nextVecChoice = UID_MECH_balaket;
  self.flags = FL_TURRET;  //enforced for a mech

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  
  macro_ai_setup(ai_mech_skirmish)
};

void() unit_balaket_brawl_m={
  self.faction = FACTION_MILITAR;
  self.nextVecChoice = UID_MECH_balaket;
  self.flags = FL_TURRET;  //enforced for a mech
    
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  
  macro_ai_setup(ai_mech_skirmish)
};

void() unit_balaket_brawl_p={
  self.faction = FACTION_PSC;
  self.nextVecChoice = UID_MECH_balaket;
  self.flags = FL_TURRET;  //enforced for a mech
  
  ai_promote();
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }  
  macro_ai_setup(ai_mech_skirmish)
};