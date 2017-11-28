/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
     mod 3/10/2017
Overview: header for player type factory
*/

void() player_spawnAsObserver={

};


void() player_makeObserver={
  self.p_class = P_OBS;
  self.view_ofs = '0 0 1';
  self.flags = self.flags | FL_FLY;
  util_setHealthArmor(1,1,1,0);
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_FLY);
  setmodel(self, "q3mdl/testball.md3");
  self.scale = 0.005;
  self.weaponmodel = "";
  util_setBoundBox('-1 -1 -1', '1 1 1');
  mh_world_updateClientSpeed(400, 400, 400, "3","0");
  mh_world_updateClientViewBob("0", "0", "0");
  mh_world_updateClientModelBob("0", "0", "0");
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
};

void() player_unmakeObserver={
  if((self.flags & FL_FLY)){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
  self.scale = 1;
};

void() player_makeVec={

  
};

void() player_makeMech={
  self.p_class = P_MECH;
  self.data_idx = self.nextVecChoice;
  self.power_timer = time + 3;
  self.stat_plr_stt = PLAYER_START;

  data_iniMech(self.vec_size, self.nextVecChoice);
  //self.touch = touch_mech; shhhhh, not yet
  if((self.flags & FL_CLIENT)){
    mh_world_updateClientSpeed(self.m_fspeed, self.m_sspeed, self.m_bspeed, ftos(self.m_maccel), self.m_rollangle);
    mh_world_updateClientViewBob(self.m_bob, self.m_bcycle, self.m_bup);
    mh_world_updateClientModelBob(self.m_bmodel, self.m_bside, self.m_bobspd);
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self.e_cam);
    //self.e_cam.SendEntity = send_mech;
    //self.e_cam.SendFlags = 1;
  }
  droptofloor();
};

void() player_unmakeMech={
  self.p_class = P_OBS;
  self.vec_size = 0;
  self.data_idx = 0;
  self.stat_trg_vid = -1;
  self.stat_trg_sh = -1;
  self.stat_trg_dat = -1;
  self.stat_trg_face = -1;
  self.next_wepn1 = -1;
  self.next_wepn2 = -1;
  self.next_wepn3 = -1;
  self.next_wepn4 = -1;
  self.next_wepn5 = -1;
  self.next_wepn6 = -1;
  self.next_wepn7 = -1;
  self.next_wepn8 = -1;
  self.next_wepn9 = -1;
  self.stat_lck_stt = 0;
  self.stat_trg_vsize = -1;
  self.stat_trg_pclass = -1;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_plr_stt = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  self.stat_plr_ptc = 0;
  self.stat_plr_ang = 0;
  mech_clearWeaponGroups();
};

float() player_customizeMechForClient={
  if((other.flags & FL_CLIENT)){
    util_setModel(self.c_model, 0);
    setsize(self, self.c_bbx_n, self.c_bbx_x);
    return TRUE;
  }
  if(self.model != "q3mdl/testball.md3"){
    util_setModel("q3mdl/testball.md3", 0);
    setsize(self, self.c_bbx_n, self.c_bbx_x);
    return FALSE;
  }
  return FALSE;
};