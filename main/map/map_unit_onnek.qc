/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: ONNEK
  TYPE: TANK DESTROYER
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_onnek_h={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;

  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_m={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_particle_cannon, UID_ITEM_recharge_capacitor, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------ZAPPER  --------------------------------
void() unit_onnek_militar_zapper={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_recharge_capacitor, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_zapper={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_recharge_capacitor, UID_ITEM_ion_coil, UID_ITEM_ion_coil, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_recharge_capacitor, UID_ITEM_ion_coil, UID_ITEM_ion_coil, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------GUNNER  --------------------------------
void() unit_onnek_militar_gunner={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_snub_artillery, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

//-------------------LOBBER --------------------------------
void() unit_onnek_militar_lobber={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_snub_artillery, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};

void() unit_onnek_survest_lobber={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      //skill- 2
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      //skill- 3
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_missile_laserguide, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      //skill- 0/1
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  macro_ai_setup(ai_vec_dest)
};