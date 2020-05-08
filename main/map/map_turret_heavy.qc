/*
battleMETAL 
Author: Peter Roohr
Date: 11/13/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: HEAVY
  TYPE: TURRET
  SIZE: LARGE
  --------------------------------
*/

//-------------------ZAPPER  --------------------------------
void() building_turret_heavy_survest_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};

void() building_turret_heavy_militar_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_ion_coil, UID_ITEM_energy_battery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_emp, UID_ITEM_energy_battery, UID_ITEM_recharge_capacitor, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_recharge_capacitor, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_psc_zapper={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_emp, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_emp, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_ion_coil, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};

//-------------------GUNNER  --------------------------------
void() building_turret_heavy_survest_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_militar_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 1:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_light_laser, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};
void() building_turret_heavy_psc_gunner={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 1:
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_snub_artillery, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  building_turret_ini();
};