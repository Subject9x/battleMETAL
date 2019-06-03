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
void(float mech_id) data_iniMech={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  //guess the mech id's should just be flat
  switch(mech_id){
    case 1:
      build_mech_unit(data_ini_balaket_);
      return;
    case 2:
      build_mech_unit(data_ini_matok_);
      return;
    case 3:
      build_mech_unit(data_ini_monitor_);
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
void(float vec_id) data_iniVehc={
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(vec_id){
    case 9:
      build_vehicle_unit( data_ini_onnek_ );
      return;
    case 7:
      build_vehicle_unit( data_ini_foslager_ );
      return;
    case 8:
      build_vehicle_unit( data_ini_trowel_ );
      return;
    case 11:
      build_vehicle_unit( data_ini_dunerunner_ );
      return;
    case 10:
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
  SCOPE: self = weapon in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/26/2017
*/
void(float wep_id) data_iniWep={ 
  switch(wep_id){
    case 1:
      data_ini_light_atc_();
      return;
    case 2:
      data_ini_emp_();
      return;
    case 3:
      data_ini_light_laser_();
      return;
    case 4:
      data_ini_rockets_();
      return;
    case 5:
      data_ini_quantum_();
      return;
    case 6:
      data_ini_plasma_();
      return;
    case 7:
      data_ini_particle_cannon_();
      return;
    case 8:
      data_ini_electro_repeater_();
      return;
    case 9:
      data_ini_missile_laserguide_();
      return;
    case 10:
      data_ini_missile_activeradar_();
      return;
    case 11:
      data_ini_snub_artillery_();
      return;
    case 12:
      data_ini_flak_cannon_();
      return;
    case 13:
      data_ini_ion_();
      return;
    case 14:
      data_ini_missile_swarm_();
      return;
    case 15:
      data_ini_equip_target_module_();
      return;
    case 16:
      data_ini_equip_energy_battery_();
      return;
    case 17:
      data_ini_equip_shield_emitter_();
      return;
    case 18:
      data_ini_equip_sensor_array_();
      return;
    case 19:
      data_ini_equip_shield_capacitor_();
      return;
    case 20:
      data_ini_equip_recharge_capacitor_();
      return;
  }
};