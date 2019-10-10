/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
    Implements any 'data' related functions here,
    many depending on common/data/*
*/

/*
  SCOPE: self = mech entity in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/27/2017
*/
void(float mech_id) initialize_data_mech_={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  //guess the mech id's should just be flat
  switch(mech_id){
    case UID_MECH_balaket:
      build_mech_unit( data_ini_balaket_ );
      return;
    case UID_MECH_matok:
      build_mech_unit( data_ini_matok_ );
      return;
    case UID_MECH_monitor:
      build_mech_unit( data_ini_monitor_ );
      return;
    default :
      cons_logAFloat("Error: failed to build mech with id", mech_id);
      remove(self);
      return;
  }
};

/*
  SCOPE: self = vehicle in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/27/2017
*/
void(float vec_id) initialize_data_vehicle_={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(vec_id){
    case UID_VEHICLE_onnek:
      build_vehicle_unit( data_ini_onnek_ );
      return;
    case UID_VEHICLE_foslager:
      build_vehicle_unit( data_ini_foslager_ );
      return;
    case UID_VEHICLE_trowel:
      build_vehicle_unit( data_ini_trowel_ );
      return;
    case UID_VEHICLE_dunerunner:
      build_vehicle_unit( data_ini_dunerunner_ );
      return;
    case UID_VEHICLE_sorcerer:
      build_vehicle_unit( data_ini_sorcerer_ );
      return;
    //case ID_VEC_PSC_VTOL_L:
      //build_vtol_unit( data_PSC_VTOLL_ini );
      //break;
    default :
      cons_logAFloat("Error: failed to build vehicle with id", vec_id);
      remove(self);
      return;
  }
};


/*
  SCOPE: self = turret in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
 
  Turrets really are their own class of unit
*/
void(float vec_id) initialize_data_turret_={  
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(vec_id){
    case UID_TURRET_light_turret:
      build_turret_unit( data_ini_light_turret_ );
      return;
    case UID_TURRET_missile_turret:
      build_turret_unit( data_ini_missile_turret_ );
      return;
    case UID_TURRET_heavy_turret:
      build_turret_unit( data_ini_heavy_turret_ );
      return;
    default:
      cons_logAFloat("Error: failed to build turret with id", vec_id);
      remove(self);
      return;
  }
};


/*
  SCOPE: self = weapon in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/26/2017
*/
void(float wep_id) initialize_data_item_={ 
  switch(wep_id){
    case 0:
      data_ini_empty_weapon_();
      return;
    case UID_ITEM_light_autocannon:
      data_ini_light_atc_();
      return;
    case UID_ITEM_emp:
      data_ini_emp_();
      return;
    case UID_ITEM_light_laser:
      data_ini_light_laser_();
      return;
    case UID_ITEM_rocket_launcher:
      data_ini_rockets_();
      return;
    case UID_ITEM_quantum_rifle:
      data_ini_quantum_();
      return;
    case UID_ITEM_rotary_plasma:
      data_ini_plasma_();
      return;
    case UID_ITEM_particle_cannon:
      data_ini_particle_cannon_();
      return;
    case UID_ITEM_electro_repeater:
      data_ini_electro_repeater_();
      return;
    case UID_ITEM_missile_laserguide:
      data_ini_missile_laserguide_();
      return;
    case UID_ITEM_missile_activeradar:
      data_ini_missile_activeradar_();
      return;
    case UID_ITEM_snub_artillery:
      data_ini_snub_artillery_();
      return;
    case UID_ITEM_flak:
      data_ini_flak_cannon_();
      return;
    case UID_ITEM_ion_coil:
      data_ini_ion_();
      return;
    case UID_ITEM_missile_swarm:
      data_ini_missile_swarm_();
      return;
    case UID_ITEM_target_module:
      data_ini_equip_target_module_();
      return;
    case UID_ITEM_energy_battery:
      data_ini_equip_energy_battery_();
      return;
    case UID_ITEM_shield_emitter:
      data_ini_equip_shield_emitter_();
      return;
    case UID_ITEM_large_sensors:
      data_ini_equip_sensor_array_();
      return;
    case UID_ITEM_shield_capacitor:
      data_ini_equip_shield_capacitor_();
      return;
    case UID_ITEM_recharge_capacitor:
      data_ini_equip_recharge_capacitor_();
      return;
    case UID_ITEM_turbo_charger:
      data_ini_equip_turbo_charger_();
      return;
  }
};