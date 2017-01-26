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
  addstat(STAT_CAM_ORG_X, AS_FLOAT, stat_cofs_x);
  addstat(STAT_CAM_ORG_Y, AS_FLOAT, stat_cofs_y);
  addstat(STAT_CAM_ORG_Z, AS_FLOAT, stat_cofs_z);
  
  addstat(STAT_WEP1_ID, AS_INT,stat_w1_id);
  addstat(STAT_WEP1_GR, AS_INT,stat_w1_gr);
  addstat(STAT_WEP1_ST, AS_INT,stat_w1_st);
  addstat(STAT_WEP2_ID, AS_INT,stat_w2_id);
  addstat(STAT_WEP2_GR, AS_INT,stat_w2_gr);
  addstat(STAT_WEP2_ST, AS_INT,stat_w2_st);
  addstat(STAT_WEP3_ID, AS_INT,stat_w3_id);
  addstat(STAT_WEP3_GR, AS_INT,stat_w3_gr);
  addstat(STAT_WEP3_ST, AS_INT,stat_w3_st);
  addstat(STAT_WEP4_ID, AS_INT,stat_w4_id);
  addstat(STAT_WEP4_GR, AS_INT,stat_w4_gr);
  addstat(STAT_WEP4_ST, AS_INT,stat_w4_st);
  addstat(STAT_WEP5_ID, AS_INT,stat_w5_id);
  addstat(STAT_WEP5_GR, AS_INT,stat_w5_gr);
  addstat(STAT_WEP5_ST, AS_INT,stat_w5_st);
  addstat(STAT_WEP6_ID, AS_INT,stat_w6_id);
  addstat(STAT_WEP6_GR, AS_INT,stat_w6_gr);
  addstat(STAT_WEP6_ST, AS_INT,stat_w6_st);
  addstat(STAT_WEP7_ID, AS_INT,stat_w7_id);
  addstat(STAT_WEP7_GR, AS_INT,stat_w7_gr);
  addstat(STAT_WEP7_ST, AS_INT,stat_w7_st);
  addstat(STAT_WEP8_ID, AS_INT,stat_w8_id);
  addstat(STAT_WEP8_GR, AS_INT,stat_w8_gr);
  addstat(STAT_WEP8_ST, AS_INT,stat_w8_st);
  addstat(STAT_WEP9_ID, AS_INT,stat_w9_id);
  addstat(STAT_WEP9_GR, AS_INT,stat_w9_gr);
  addstat(STAT_WEP9_ST, AS_INT,stat_w9_st);
  
  addstat(STAT_WEP_GRP, AS_INT, currentWeaponGroup);
  
  addstat(STAT_TRG_VID, AS_INT, stat_trg_vid);
  addstat(STAT_TRG_SH, AS_FLOAT, stat_trg_sh);
  addstat(STAT_TRG_AM, AS_FLOAT, stat_trg_am);
  
  mh_world_iniData();
};

void() mh_world_iniData={
  //projectile data
  data_prj_latc();
  data_prj_emp();
  data_prj_mis();

  //weapon data
  data_wep_latc();
  data_wep_emp();
  data_wep_mis();
  data_wep_las();

  //mech data
  data_mech_otl();
  data_mech_mtk();
};

entity(float id, string dat_type) mh_world_findData={
  local entity found, data_chain;
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