/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: function extensions to world.qc
*/

void() mh_world_ini={ 
  registercvar("mechdev", "0");
  registercvar("campaign", "0"); 
  registercvar("saveslot", "0");
  registercvar("gamemode", "0");
  registercvar("gametype", "0");
  
  
  cvar_set("gamemode", ftos(GAMEMODE_CAMPAIGN));
  if( coop ){
    cvar_set("gamemode", ftos(GAMEMODE_COOP));
  }
  if( deathmatch ){
    cvar_set("gamemode", ftos(GAMEMODE_DM));
  }
  
  //oh my
  addstat(STAT_PLR_ORG_X, AS_FLOAT, stat_cofs_x);
  addstat(STAT_PLR_ORG_Y, AS_FLOAT, stat_cofs_y);
  addstat(STAT_PLR_ORG_Z, AS_FLOAT, stat_cofs_z);
  addstat(STAT_PLR_STT, AS_INT, stat_plr_stt);
  addstat(STAT_PLR_DIDX, AS_INT, data_idx);
  addstat(STAT_PLR_DTYPE, AS_INT, data_type);
  addstat(STAT_PLR_VECSIZE, AS_INT, vec_size);
  addstat(STAT_PLR_RADMOD, AS_INT, stat_rdr_mode);
  addstat(STAT_LCK_STT, AS_INT, stat_lck_stt);
  addstat(STAT_PLR_HITDIR, AS_INT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_INT, stat_ret_dist);
  
  //Target stats
  addstat(STAT_TRG_ENT_ID, AS_INT, stat_trg_ent_id);
  addstat(STAT_TRG_VECSIZE, AS_INT, stat_trg_vsize);
  addstat(STAT_TRG_SHIELD, AS_FLOAT, stat_trg_sh);
  addstat(STAT_TRG_DATATYPE, AS_INT, stat_trg_dat);
  addstat(STAT_TRG_DATAIDX, AS_INT, stat_trg_dataidx);
  addstat(STAT_TRG_FACTION, AS_INT, stat_trg_faction);
  addstat(STAT_TRG_ORG_X, AS_FLOAT, stat_trg_org_x);
  addstat(STAT_TRG_ORG_Y, AS_FLOAT, stat_trg_org_y);
  addstat(STAT_TRG_ORG_Z, AS_FLOAT, stat_trg_org_z);
  
  addstat(STAT_TRG_LG_HP, AS_FLOAT, stat_trg_lg_hp);
  addstat(STAT_TRG_CT_HP, AS_FLOAT, stat_trg_ct_hp);
  addstat(STAT_TRG_LT_HP, AS_FLOAT, stat_trg_lt_hp);
  addstat(STAT_TRG_RT_HP, AS_FLOAT, stat_trg_rt_hp);
  addstat(STAT_TRG_LA_HP, AS_FLOAT, stat_trg_la_hp);
  addstat(STAT_TRG_RA_HP, AS_FLOAT, stat_trg_ra_hp);  
  
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
 
  addstat(STAT_NAV_DIR, AS_INT, stat_nav_dir);
  
  addstat(STAT_SPR_X, AS_FLOAT, stat_spr_x);
  addstat(STAT_SPR_Y, AS_FLOAT, stat_spr_y);
  
  
  addstat(STAT_LVL_RES, AS_INT, i_reserve);
  
  addstat(STAT_WEP1_REL, AS_FLOAT, stat_w1_rel);
  addstat(STAT_WEP2_REL, AS_FLOAT, stat_w2_rel);
  addstat(STAT_WEP3_REL, AS_FLOAT, stat_w3_rel);
  addstat(STAT_WEP4_REL, AS_FLOAT, stat_w4_rel);
  addstat(STAT_WEP5_REL, AS_FLOAT, stat_w5_rel);
  addstat(STAT_WEP6_REL, AS_FLOAT, stat_w6_rel);
  addstat(STAT_WEP7_REL, AS_FLOAT, stat_w7_rel);
  addstat(STAT_WEP8_REL, AS_FLOAT, stat_w8_rel);
  addstat(STAT_WEP9_REL, AS_FLOAT, stat_w9_rel);
 
  addstat(UI_BOX_POSX, AS_INT, ui_box_pos_x);
  addstat(UI_BOX_POSY, AS_INT, ui_box_pos_y);
  
  addstat(UI_BOX_SZEX, AS_INT, ui_box_sz_x);
  addstat(UI_BOX_SZEY, AS_INT, ui_box_sz_y);
  
  addstat(UI_BOX_CLRX, AS_INT, ui_box_clr_x);
  addstat(UI_BOX_CLRY, AS_INT, ui_box_clr_y);
  addstat(UI_BOX_CLRZ, AS_INT, ui_box_clr_z);
  
  addstat(UI_BOX_TIME, AS_INT, ui_box_time);
  
  addstat(STAT_PLR_ANG_X, AS_FLOAT, stat_plr_ang_x);
  addstat(STAT_PLR_ANG_Y, AS_FLOAT, stat_plr_ang_y);
  addstat(STAT_PLR_ANG_Z, AS_FLOAT, stat_plr_ang_z);
  
  addstat(STAT_PLR_REP, AS_FLOAT, stat_plr_rep);
};

void(float build_id) data_iniBuilding={
  if(build_id == ID_BLD_H_TURRET){
    build_vehicle_unit(data_tur_ini);
  }
  else{
    cons_logAFloat("Error: failed to build building with id", build_id);
    remove(self);
  }
};

/*
  SCOPE: self = weapon in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/27/2017
*/
void(float vecsize, float mech_id) data_iniMech={
  if(vecsize == 1){
    if(mech_id == ID_MCH_BALAKET){
      build_mech_unit(data_otl_ini);
    }
  }
  else if(vecsize == 2){
    if(mech_id == ID_MCH_MATOK){
      build_mech_unit(data_mtk_ini);
    }
  }
  else if(vecsize == 3){
    if(mech_id == ID_MCH_MONITOR){
      build_mech_unit(data_mnt_ini);
    }
  }
  else{
    cons_logAFloat("Error: failed to build mech with id", mech_id);
    remove(self);
  }
};

/*
  SCOPE: self = vehicle in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/27/2017
*/
void(float vecsize, float vec_id) data_iniVehc={
  if(vecsize == 1){
    if(vec_id == ID_VEC_TANK){
      build_vehicle_unit(data_TNK_ini);
    }
  }
  else{
    cons_logAFloat("Error: failed to build vehicle with id", vec_id);
    remove(self);
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
    case ID_PRJ_FLAK:
      data_prj_flak_ini();
      return;
    case ID_PRJ_ION:
      data_prj_ion_ini();
      return;
    case ID_PRJ_SWRM:
      data_prj_swrm_ini();
      return;
    case ID_PRJ_ABT:
      data_prj_abt_ini();
      return;
    case ID_PRJ_ABT_CLST:
      data_prj_abt_clst_ini();
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
    case ID_WEP_ABT:
      data_abt_ini();
      return;
  }
};

entity(float id, float dat_type) mh_world_findData={
  local entity data_chain;
  data_chain = findchain(classname, "data");
  while(data_chain){
    local float idx;
    idx = data_chain.data_idx;
    if(data_chain.data_type == dat_type){
      if(id == idx){
        return data_chain;
      }
    }
    data_chain = data_chain.chain;
  }
  return data_chain;
};

entity(float sz, float id) m_findMechData={
  local entity data_chain;
  data_chain = findchain(classname, "data");
  while(data_chain){
    if(data_chain.data_type == DATA_MECH){
      local float idx, weight;
      idx = data_chain.data_idx;
      weight = data_chain.vec_size;
      if(sz == weight && id == idx){
        return data_chain;
      }
    }
    data_chain = data_chain.chain;
  }
  return data_chain;
};

void(float fwd, float side, float bck, string accel, string roll) mh_world_updateClientSpeed={
  stuffcmd(self, strcat("cl_forwardspeed ", ftos(fwd), "\n"));
  stuffcmd(self, strcat("cl_sidespeed ", ftos(side), "\n"));
  stuffcmd(self, strcat("cl_backspeed ", ftos(bck), "\n"));
  stuffcmd(self, strcat("cl_movespeedkey ", accel, "\n"));
  stuffcmd(self, strcat("cl_rollangle ", roll, "\n"));
};

void(string bob, string cycle, string up) mh_world_updateClientViewBob={
  stuffcmd(self, "cl_bob ");
  stuffcmd(self, bob); //0.02
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobcycle ");
  stuffcmd(self, cycle); //0.6
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobup ");
  stuffcmd(self, up); //0.5
  stuffcmd(self, "\n");
};
void(string bobmodel, string side, string bmod_speed) mh_world_updateClientModelBob={
  stuffcmd(self, "cl_bobmodel ");
  stuffcmd(self, bobmodel); //1
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobmodel_side ");
  stuffcmd(self, side); //	0.05
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobmodel_speed ");
  stuffcmd(self, bmod_speed); //	7
  stuffcmd(self, "\n");
};

void(string p_max, string p_min) mh_world_updateClientViewPitch={
  stuffcmd(self, "in_pitch_max ");
  stuffcmd(self, p_max);
  stuffcmd(self, "\n");
  stuffcmd(self, "in_pitch_min ");
  stuffcmd(self, p_min);
  stuffcmd(self, "\n");
};