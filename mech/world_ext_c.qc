/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: function extensions to world.qc
*/

void() mh_world_ini={

  addstat(STAT_ENTITY_ID, AS_INT, stat_eid);
  addstat(STAT_PCLASS, AS_INT, p_class);
  
  addstat(STAT_ENERGY, AS_INT, stat_en);
  addstat(STAT_SHIELD, AS_INT, stat_sh);
  
  addstat(STAT_CAM_ORG_X, AS_FLOAT, stat_plr_camx);
  addstat(STAT_CAM_ORG_Y, AS_FLOAT, stat_plr_camy);
  addstat(STAT_CAM_ORG_Z, AS_FLOAT, stat_plr_camz);
  
  addstat(STAT_LEG_HP, AS_FLOAT, stat_legs_hp);
  addstat(STAT_LEG_AM, AS_FLOAT, stat_legs_am);  
  addstat(STAT_CTOR_HP, AS_FLOAT, stat_ctor_hp);
  addstat(STAT_CTOR_AM, AS_FLOAT, stat_ctor_am);  
  addstat(STAT_LTOR_HP, AS_FLOAT, stat_ltor_hp);
  addstat(STAT_LTOR_AM, AS_FLOAT, stat_ltor_am); 
  addstat(STAT_RTOR_HP, AS_FLOAT, stat_rtor_hp);
  addstat(STAT_RTOR_AM, AS_FLOAT, stat_rtor_am);  
  addstat(STAT_LARM_HP, AS_FLOAT, stat_larm_hp);
  addstat(STAT_LARM_AM, AS_FLOAT, stat_larm_am);  
  addstat(STAT_RARM_HP, AS_FLOAT, stat_rarm_hp);
  addstat(STAT_RARM_AM, AS_FLOAT, stat_rarm_am);
  addstat(STAT_VID, AS_INT, data_idx);
  
  addstat(STAT_WEP1_ID, AS_INT,stat_w1_id);
  addstat(STAT_WEP2_ID, AS_INT,stat_w2_id);
  addstat(STAT_WEP3_ID, AS_INT,stat_w3_id);
  addstat(STAT_WEP4_ID, AS_INT,stat_w4_id);
  addstat(STAT_WEP5_ID, AS_INT,stat_w5_id);
  addstat(STAT_WEP6_ID, AS_INT,stat_w6_id);
  addstat(STAT_WEP7_ID, AS_INT,stat_w7_id);
  addstat(STAT_WEP8_ID, AS_INT,stat_w8_id);
  addstat(STAT_WEP9_ID, AS_INT,stat_w9_id);
  
  addstat(STAT_WEP_GRP, AS_INT, currentWeaponGroup);
  addstat(STAT_WEP_STT, AS_INT, stat_wep_state);
  addstat(STAT_WEP_REL, AS_INT, stat_wep_rel);
  
  addstat(STAT_TRG_VID, AS_INT, stat_trg_vid);
  addstat(STAT_TRG_DDFLG, AS_INT, stat_trg_ddflg);
  addstat(STAT_TRG_SH, AS_FLOAT, stat_trg_sh);
  addstat(STAT_TRG_AM, AS_INT, stat_trg_am);
  addstat(STAT_TRG_DAT, AS_INT, stat_trg_dat);
  addstat(STAT_TRG_DIST, AS_INT, stat_trg_dist);
  addstat(STAT_TRG_FACE, AS_INT, stat_trg_face);
  addstat(STAT_TRG_ORGX, AS_FLOAT, stat_trg_orgx);
  addstat(STAT_TRG_ORGY, AS_FLOAT, stat_trg_orgy);
  addstat(STAT_TRG_ORGZ, AS_FLOAT, stat_trg_orgz);
 
  addstat(STAT_TRG_LEG_HP, AS_FLOAT, stat_trg_lg_hp);
  addstat(STAT_TRG_CTOR_HP, AS_FLOAT, stat_trg_ct_hp);
  addstat(STAT_TRG_LTOR_HP, AS_FLOAT, stat_trg_lt_hp);
  addstat(STAT_TRG_RTOR_HP, AS_FLOAT, stat_trg_rt_hp);
  addstat(STAT_TRG_LARM_HP, AS_FLOAT, stat_trg_la_hp);
  addstat(STAT_TRG_RARM_HP, AS_FLOAT, stat_trg_ra_hp);
 
 
  addstat(STAT_RDR_FRNT, AS_FLOAT, radar_front);
  addstat(STAT_RDR_BACK, AS_FLOAT, radar_rear);
  addstat(STAT_HIT_DIR, AS_FLOAT, stat_hit_dirs);
  addstat(STAT_RDR_MODE, AS_INT, stat_rdr_mode);
  addstat(STAT_NAV_DIR, AS_INT, stat_nav_dir);
  
  addstat(STAT_SPR_X, AS_FLOAT, stat_spr_x);
  addstat(STAT_SPR_Y, AS_FLOAT, stat_spr_y);
  
  addstat(STAT_PLR_STT, AS_INT, stat_plr_stt);
  addstat(STAT_LCK_STT, AS_INT, stat_lck_stt);
  addstat(STAT_PLR_PTC, AS_INT, stat_plr_ptc);
  addstat(STAT_PLR_ANG, AS_INT, stat_plr_ang);
  
  addstat(STAT_LVL_RES, AS_INT, i_reserve);
  
  mh_world_iniData();
};

void() mh_world_iniData={

  
  //projectile data
  data_prj_latc();
  data_prj_emp();
  data_prj_mis();
  data_prj_mlgd();
  data_prj_marh();
  data_prj_rplas();
  data_prj_qrfl();
  
  //weapon data
  data_wep_latc();
  data_wep_emp();
  data_wep_mis();
  data_wep_las();
  data_wep_mlgd();
  data_wep_marh();
  data_wep_qrfl();
  data_wep_esr();
  data_wep_pac();
  data_wep_rplas();
  
  //mech data
  data_mech_otl();
  data_mech_mtk();
  data_mech_hvd();
  
  //buildings;
  data_h_power();
  data_h_radar();
  data_h_shield();
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

void(float fwd, float side, float bck, string accel, string roll) mh_world_updateClientSpeed={
  stuffcmd(self, "cl_forwardspeed ");
  stuffcmd(self, ftos(fwd)); //400
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_sidespeed ");
  stuffcmd(self, ftos(side)); //350
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_backspeed ");
  stuffcmd(self, ftos(bck)); //400
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_movement_accelerate ");
  stuffcmd(self, accel); //10
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_rollangle ");
  stuffcmd(self, roll);
  stuffcmd(self, "\n"); //2
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