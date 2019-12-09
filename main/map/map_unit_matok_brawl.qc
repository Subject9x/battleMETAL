/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.

  UNIT: MATOK
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_matok_brawl_h={ 
  self.faction = FACTION_SURVEST; 
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_missile_laserguide, UID_ITEM_rocket_launcher, UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};
void() unit_matok_brawl_m={  
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(  UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_rotary_plasma, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_electro_repeater, UID_ITEM_ion_coil, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------ZAPPER  --------------------------------

//-------------------GUNNER  --------------------------------
void() unit_matok_militar_gunner={  
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};
void() unit_matok_survest_gunner={ 
  self.faction = FACTION_SURVEST; 
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_shield_emitter, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_shield_emitter, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_shield_emitter, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};

//-------------------LOBBER  --------------------------------
void() unit_matok_survest_lobber={ 
  self.faction = FACTION_SURVEST; 
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    default:
      ai_ini_weapons( UID_ITEM_EMPTY, UID_ITEM_large_sensors, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  macro_ai_setup(ai_mech_skirmish)
};