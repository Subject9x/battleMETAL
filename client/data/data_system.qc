/*
battleMETAL
Author: Peter Roohr
Date: 06/05/2019
Overview: 
	A variation on the data_system.qc found in the server code.
	This uses the same function calls and setup, but changes the implementation
	to only copy data into the target entity and that's it.
*/

void(float mech_id) initialize_data_mech_={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  //guess the mech id's should just be flat
  switch(mech_id){
    case UID_MECH_balaket:
      data_ini_balaket_();
      break;
    case UID_MECH_matok:
      data_ini_matok_();
      break;
    case UID_MECH_sapper:
      data_ini_sapper_();
      break;
    case UID_MECH_monitor:
      data_ini_monitor_();
      break;
    case UID_MECH_warden:
      data_ini_warden_();
      break;
    default :
      cons_logAFloat("client.data_system.initialize_data_mech_()-Error: failed to build mech with id", mech_id);
      break;
  }
};

void(float vec_id) initialize_data_vehicle_={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(vec_id){
    case UID_VEHICLE_onnek:
       data_ini_onnek_();
      break;
    case UID_VEHICLE_foslager:
       data_ini_foslager_();
      break;
    case UID_VEHICLE_trowel:
       data_ini_trowel_();
      break;
    case UID_VEHICLE_dunerunner:
       data_ini_dunerunner_();
      break;
    case UID_VEHICLE_sorcerer:
       data_ini_sorcerer_();
      break;
    //case ID_VEC_PSC_VTOL_L:
      //build_vtol_unit( data_PSC_VTOLL_ini );
      //break;
    default :
      cons_logAFloat("Error: failed to build vehicle with id", vec_id);
      return;
  }
};

void(float vec_id) initialize_data_turret_={  
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(vec_id){
    case UID_TURRET_light_turret:
      data_ini_light_turret_();
      break;
    case UID_TURRET_missile_turret:
      data_ini_missile_turret_();
      break;
    case UID_TURRET_heavy_turret:
      data_ini_heavy_turret_();
      break;
    default:
      cons_logAFloat("Error: failed to build turret with id", vec_id);
      return;
  }
};

void(float wep_id) initialize_data_item_={ 
  switch(wep_id){
    case UID_ITEM_light_autocannon:
      data_ini_light_atc_();
      break;
    case UID_ITEM_emp:
      data_ini_emp_();
      break;
    case UID_ITEM_light_laser:
      data_ini_light_laser_();
      break;
    case UID_ITEM_rocket_launcher:
      data_ini_rockets_();
      break;
    case UID_ITEM_quantum_rifle:
      data_ini_quantum_();
      break;
    case UID_ITEM_rotary_plasma:
      data_ini_plasma_();
      break;
    case UID_ITEM_particle_cannon:
      data_ini_particle_cannon_();
      break;
    case UID_ITEM_electro_repeater:
      data_ini_electro_repeater_();
      break;
    case UID_ITEM_missile_laserguide:
      data_ini_missile_laserguide_();
      break;
    case UID_ITEM_missile_activeradar:
      data_ini_missile_activeradar_();
      break;
    case UID_ITEM_snub_artillery:
      data_ini_snub_artillery_();
      break;
    case UID_ITEM_flak:
      data_ini_flak_cannon_();
      break;
    case UID_ITEM_ion_coil:
      data_ini_ion_();
      break;
    case UID_ITEM_missile_swarm:
      data_ini_missile_swarm_();
      break;
    case UID_ITEM_target_module:
      data_ini_equip_target_module_();
      break;
    case UID_ITEM_energy_battery:
      data_ini_equip_energy_battery_();
      break;
    case UID_ITEM_shield_emitter:
      data_ini_equip_shield_emitter_();
      break;
    case UID_ITEM_large_sensors:
      data_ini_equip_sensor_array_();
      break;
    case UID_ITEM_shield_capacitor:
      data_ini_equip_shield_capacitor_();
      break;
    case UID_ITEM_recharge_capacitor:
      data_ini_equip_recharge_capacitor_();
      break;
    case UID_ITEM_turbo_charger:
      data_ini_equip_turbo_charger_();
      break;
    default:
      data_ini_empty_weapon_();
      break;
  }
};

void( entity item, float id ) data_get_client_item_={
  local entity this;
  this = self;
  self = item;
    initialize_data_item_(id);
  self = this;
};

void( entity mech, float id ) data_get_client_mech_={
  local entity this;
  this = self;
  self = mech;
	initialize_data_mech_(id);
  self = this;
};

void( entity vehicle, float id ) data_get_client_vehicle_={
  local entity this;
  this = self;
  vehicle = spawn();
  self = vehicle;
	initialize_data_vehicle_(id);
  self = this;
};

void( entity turret, float id ) data_get_client_turret_={
  local entity this;
  this = self;
  turret = spawn();
  self = turret;
	initialize_data_turret_(id);
  self = this;
	
};

void( entity building, float id ) data_get_client_building_={
  local entity this;
  this = self;
  self = building;
	//initialize_data_build_(id);
  self = this;
};