/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: MONITOR
  TYPE: METAL
  SIZE: HEAVY
  --------------------------------
*/
void() unit_monitor_brawl_h={
  self.faction = FACTION_SURVEST;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_electro_repeater,UID_ITEM_emp,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_snub_artillery,UID_ITEM_snub_artillery,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_rocket_launcher,UID_ITEM_missile_activeradar,UID_ITEM_rocket_launcher);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_skirmish;
  self.nextthink = time + 0.05;
};

void() unit_monitor_brawl_m={
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_emp, UID_ITEM_electro_repeater, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser, UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_energy_battery, UID_ITEM_energy_battery, UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_rocket_launcher, UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_skirmish;
  self.nextthink = time + 0.05;
};

void() unit_monitor_brawl_p={
  self.faction = FACTION_PSC;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_emp, UID_ITEM_electro_repeater, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser, UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_energy_battery, UID_ITEM_energy_battery, UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_rocket_launcher, UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_skirmish;
  self.nextthink = time + 0.05;
};