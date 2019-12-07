/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
*/
void() unit_monitor_sniper_m={  
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_particle_cannon,UID_ITEM_particle_cannon,UID_ITEM_target_module,UID_ITEM_energy_battery,UID_ITEM_shield_emitter);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_missile_laserguide,UID_ITEM_missile_laserguide,UID_ITEM_energy_battery,UID_ITEM_target_module,UID_ITEM_shield_emitter);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_particle_cannon,UID_ITEM_quantum_rifle,UID_ITEM_missile_activeradar,UID_ITEM_energy_battery,UID_ITEM_target_module);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------ZAPPER  --------------------------------
void() unit_monitor_survest_zapper={  
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_ion_coil,UID_ITEM_EMPTY,UID_ITEM_energy_battery,UID_ITEM_large_sensors);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_EMPTY,UID_ITEM_light_laser,UID_ITEM_EMPTY,UID_ITEM_light_laser,UID_ITEM_emp,UID_ITEM_emp,UID_ITEM_EMPTY,UID_ITEM_energy_battery,UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_EMPTY,UID_ITEM_light_laser,UID_ITEM_EMPTY,UID_ITEM_light_laser,UID_ITEM_emp,UID_ITEM_emp,UID_ITEM_EMPTY,UID_ITEM_energy_battery,UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------GUNNER  --------------------------------
void() unit_monitor_survest_gunner={  
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_EMPTY,UID_ITEM_shield_emitter,UID_ITEM_shield_capacitor);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_EMPTY,UID_ITEM_shield_emitter,UID_ITEM_shield_capacitor);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

//-------------------LOBBER  --------------------------------
void() unit_monitor_militar_lobber={  
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons(UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_target_module,UID_ITEM_missile_activeradar,UID_ITEM_missile_activeradar);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_target_module,UID_ITEM_missile_activeradar,UID_ITEM_missile_activeradar);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_light_autocannon,UID_ITEM_EMPTY,UID_ITEM_EMPTY,UID_ITEM_target_module,UID_ITEM_missile_activeradar,UID_ITEM_missile_activeradar);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};
