/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: function extensions to world.qc
*/

void() mh_world_ini={ 
  registercvar("mechdev", "0", 1);
  registercvar("campaign", "0", 0); 
  registercvar("saveslot", "0", 1);
  registercvar("gamemode", "0", 0);
  registercvar("gametype", "0", 0);
  registercvar("cl_hud_alpha", "1", 1);
  registercvar("cl_hud_color", "0", 1);
  
  cvar_set("gamemode", ftos(GAMEMODE_CAMPAIGN));
  if( coop ){
    cvar_set("gamemode", ftos(GAMEMODE_COOP));
  }
  if( deathmatch ){
    cvar_set("gamemode", ftos(GAMEMODE_DM));
  }

  //oh my
  addstat( STAT_PLR_NAME, AS_STRING, netname);
  addstat(STAT_PLR_ORG_X, AS_FLOAT, stat_cofs_x);
  addstat(STAT_PLR_ORG_Y, AS_FLOAT, stat_cofs_y);
  addstat(STAT_PLR_ORG_Z, AS_FLOAT, stat_cofs_z);
  addstat(STAT_PLR_DIDX, AS_INT, data_idx);
  addstat(STAT_PLR_DTYPE, AS_INT, data_type);
  addstat(STAT_PLR_RADMOD, AS_INT, stat_rdr_mode);
  addstat(STAT_LCK_STT, AS_INT, stat_lck_stt);
  addstat(STAT_PLR_HITDIR, AS_INT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_INT, stat_ret_dist);
  
  //Target stats
  addstat(STAT_TRG_ENT_ID, AS_INT, stat_trg_ent_id);
  addstat(STAT_TRG_DATATYPE, AS_INT, stat_trg_dat);
  addstat(STAT_TRG_DATAIDX, AS_INT, stat_trg_dataidx);
  addstat(STAT_TRG_FACTION, AS_INT, stat_trg_faction);
  
  addstat(STAT_CAM_ORG_X, AS_FLOAT, stat_plr_camx);
  addstat(STAT_CAM_ORG_Y, AS_FLOAT, stat_plr_camy);
  addstat(STAT_CAM_ORG_Z, AS_FLOAT, stat_plr_camz);
  
  addstat(STAT_WEP1_ID, AS_INT, stat_w1_id);
  addstat(STAT_WEP2_ID, AS_INT, stat_w2_id);
  addstat(STAT_WEP3_ID, AS_INT, stat_w3_id);
  addstat(STAT_WEP4_ID, AS_INT, stat_w4_id);
  addstat(STAT_WEP5_ID, AS_INT, stat_w5_id);
  addstat(STAT_WEP6_ID, AS_INT, stat_w6_id);
  addstat(STAT_WEP7_ID, AS_INT, stat_w7_id);
  addstat(STAT_WEP8_ID, AS_INT, stat_w8_id);
  addstat(STAT_WEP9_ID, AS_INT, stat_w9_id);
  
  addstat(STAT_TRG_DDFLG, AS_INT, stat_trg_ddflg);
  addstat(STAT_TRG_DIST, AS_INT, stat_trg_dist);
  addstat(STAT_TRG_FACE, AS_INT, stat_trg_face);
  
  addstat(STAT_ACCURACY, AS_FLOAT, accuracy);
 
  addstat(STAT_PLR_ANG_X, AS_FLOAT, stat_plr_ang_x);
  addstat(STAT_PLR_ANG_Y, AS_FLOAT, stat_plr_ang_y);
  addstat(STAT_PLR_ANG_Z, AS_FLOAT, stat_plr_ang_z);
  
  addstat(STAT_PLR_REP, AS_INT, stat_plr_rep);
  addstat(STAT_RAD_SWEEP, AS_FLOAT, radar_time);
};

/*
  SCOPE: self = weapon in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/27/2017
*/
void(float mech_id) data_iniMech={
  //guess the mech id's should just be flat
  switch(mech_id){
    case ID_MCH_BALAKET:
      build_mech_unit(data_otl_ini);
      break;
    case ID_MCH_MATOK:
      build_mech_unit(data_mtk_ini);
      break;
    case ID_MCH_MONITOR:
      build_mech_unit(data_mnt_ini);
      break;
    default :
      cons_logAFloat("Error: failed to build mech with id", mech_id);
      remove(self);
      break;
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
  switch(vec_id){
    case ID_VEC_HS_TRUCK_C:
      build_vehicle_unit( data_HS_TruckA_ini );
      break;
    case ID_VEC_HS_TRUCK_H:
      build_vehicle_unit( data_HS_TruckB_ini );
      break;
    case ID_VEC_HS_TRUCK_CS:
      build_vehicle_unit( data_HS_TruckC_ini );
      break;
    case ID_VEC_HS_DOZER:
      build_vehicle_unit( data_HS_Dozer_ini );
      break;
    case ID_VEC_HS_LOADR:
      build_vehicle_unit( data_HS_Loader_ini );
      break;
    case ID_VEC_HS_EXCAT:
      build_vehicle_unit( data_HS_Excat_ini );
      break;
    case ID_VEC_onnek:
      build_vehicle_unit( data_onnek_ini );
      break;
    case ID_VEC_foslager:
      build_vehicle_unit( data_foslager_ini );
      break;
    case ID_VEC_TROWEL:
      build_vehicle_unit( data_TROWEL_ini );
      break;
    case ID_VEC_dunerunner:
      build_vehicle_unit( data_dunerunner_ini );
      break;
    case ID_VEC_sorcerer:
      build_vehicle_unit( data_sorcerer_ini );
      break;
    case ID_VEC_PSC_VTOL_L:
      build_vtol_unit( data_PSC_VTOLL_ini );
      break;
    default :
      cons_logAFloat("Error: failed to build vehicle with id", vec_id);
      remove(self);
      break;
  }
};

/*
  SCOPE: self = turret in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
 
  Turrets really are their own class of unit
*/
void(float vec_id) data_iniTurret={
  switch(vec_id){
    case ID_TUR_HLITE:
      build_turret_unit(data_tur_hlite_ini);
      return;
    default:
      cons_logAFloat("Error: failed to build turret with id", vec_id);
      remove(self);
      return;
  }
};

/*
  SCOPE: self = projectile in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/26/2017
*/
void(float prj_id) data_iniProjectile={
  switch(prj_id){
    case ID_PRJ_EMP:
      data_prj_emp_ini();
      return;
    case ID_PRJ_MIS:
      data_prj_mis_ini();
      return;
    case ID_PRJ_MLGD:
      data_prj_mlgd_ini();
      return;
    case ID_PRJ_MARH:
      data_prj_marh_ini();
      return;
    case ID_PRJ_RPLAS:
      data_prj_rplas_ini();
      return;
    case ID_PRJ_QRFL:
      data_prj_qrfl_ini();
      return;
    case ID_PRJ_SFGA:
      data_prj_sfga_ini();
      return;
    case ID_PRJ_ION:
      data_prj_ion_ini();
      return;
    case ID_PRJ_SWRM:
      data_prj_swrm_ini();
      return;
  }
  cons_logAFloat("Error: failed to find projectile of ", prj_id);
  remove(self);
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
    case ID_WEP_LATC:
      data_latc_ini();
      return;
    case ID_WEP_EMP:
      data_emp_ini();
      return;
    case ID_WEP_LAS:
      data_las_ini();
      return;
    case ID_WEP_MIS:
      data_mis_ini();
      return;
    case ID_WEP_QRF:
      data_qrfl_ini();
      return;
    case ID_WEP_RPC:
      data_rplas_ini();
      return;
    case ID_WEP_SFGA:
      data_sfga_ini();
      return;
    case ID_WEP_PAC:
      data_pac_ini();
      return;
    case ID_WEP_ESR:
      data_esr_ini();
      return;
    case ID_WEP_MLGD:
      data_mlgd_ini();
      return;
    case ID_WEP_MARH:
      data_marh_ini();
      return;
    case ID_WEP_FLAK:
      data_flak_ini();
      return;
    case ID_WEP_ION:
      data_ion_ini();
      return;
    case ID_WEP_SWRM:
      data_swrm_ini();
      return;
    case ID_EQP_ATGM:
      data_eqp_atgm_ini();
      return;
    case ID_EQP_ENBAT:
      data_eqp_enbat_ini();
      return;
    case ID_EQP_RECAP:
      data_eqp_recap_ini();
      return;
    case ID_EQP_LSAR:
      data_eqp_lsar_ini();
      return;
    case ID_EQP_HSEM:
      data_eqp_hsem_ini();
      return;
    case ID_EQP_SCAP:
      data_eqp_scap_ini();
      return;
  }
};
