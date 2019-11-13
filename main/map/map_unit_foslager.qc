/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: FOSLAGER
  TYPE: TANK
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_foslager_h={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};

void() unit_foslager_m={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_rotary_plasma, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};

//-------------------ZAPPER  --------------------------------
void() unit_foslager_survest_zapper={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_recharge_capacitor, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_recharge_capacitor, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};

void() unit_foslager_militar_zapper={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};

//-------------------GUNNER  --------------------------------
void() unit_foslager_survest_gunner={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};

void() unit_foslager_militar_gunner={

  self.nextVecChoice = UID_VEHICLE_foslager;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_light_autocannon, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  self.think = ai_tank_skirmish;
  self.nextthink = time + 0.05;
};