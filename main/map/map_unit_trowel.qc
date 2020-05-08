/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: TROWEL
  TYPE: TANK
  SIZE: HEAVY
  --------------------------------
*/
//-------------------LOBBER--------------------------------
void() unit_trowel_militar_lobber={
  
  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_ion_coil, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_snub_artillery, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_trowel_survest_lobber={

  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_missile_activeradar, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_ion_coil, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

//-------------------GUNNER  --------------------------------
void() unit_trowel_militar_gunner={
  
  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_particle_cannon, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_particle_cannon, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_snub_artillery, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};

void() unit_trowel_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_trowel;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_tank_skirmish)
};