/*
battleMETAL
Author: Peter Roohr
Date: 12/07/2021
Overview: 
  concatenating CSQC and SVQC data_systems into a single file (CSQC extensions will chain off of this later.)
  
  it never made sense to have these two be copies of each other.
  
  implements functions in /common/data/data_header.qc
  
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
      dprint(strcat("main.data_system.initialize_data_mech_()-Error: failed to build mech with id", ftos(mech_id),"\n"));
      #ifdef SSQC
        remove(self);
      #endif
      return;
  }
  data_validate_mod_flags(self);
  #ifdef SSQC
  build_mech_unit();
  #endif
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
      dprint(strcat("Error: failed to build vehicle with id", ftos(vec_id)),"\n");
      #ifdef SSQC
        remove(self);
      #endif
      return;
  }
  #ifdef SSQC
    build_vehicle_unit();
  #endif
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
      #ifdef SSQC
        remove(self);
      #endif
      return;
  }
  #ifdef SSQC
    build_turret_unit();
  #endif
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
    case UID_ITEM_adv_reload:
      data_ini_equip_adv_reload_();
      return;
    case UID_ITEM_energy_battery:
      data_ini_equip_energy_battery_();
      return;
    case UID_ITEM_shield_emitter:
      data_ini_equip_shield_emitter_();
      return;
    case UID_ITEM_heatsink:
      data_ini_equip_heatsink_();
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

