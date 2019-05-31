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
    case ID_WEP_QRF:
      data_ini_quantum_();
      return;
    case ID_WEP_RPC:
      //data_rplas_ini();
      return;
    case ID_WEP_SFGA:
      //data_sfga_ini();
      return;
    case ID_WEP_PAC:
      //data_pac_ini();
      return;
    case ID_WEP_ESR:
      //data_esr_ini();
      return;
    case ID_WEP_MLGD:
      //data_mlgd_ini();
      return;
    case ID_WEP_MARH:
      //data_marh_ini();
      return;
    case ID_WEP_FLAK:
      //data_flak_ini();
      return;
    case ID_WEP_ION:
      //data_ion_ini();
      return;
    case ID_WEP_SWRM:
      //data_swrm_ini();
      return;
    case ID_EQP_ATGM:
      //data_eqp_atgm_ini();
      return;
    case ID_EQP_ENBAT:
      //data_eqp_enbat_ini();
      return;
    case ID_EQP_RECAP:
      //data_eqp_recap_ini();
      return;
    case ID_EQP_LSAR:
      //data_eqp_lsar_ini();
      return;
    case ID_EQP_HSEM:
      //data_eqp_hsem_ini();
      return;
    case ID_EQP_SCAP:
      //data_eqp_scap_ini();
      return;
  }
};