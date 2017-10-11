/*
mech Mod
Author: Subject9x
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
  util_setCollider(DAMAGE_NO, SOLID_SLIDEBOX, MOVETYPE_FLY);
  setmodel(self, "q3mdl/testball.md3");
  self.scale = 0.005;
  self.weaponmodel = "";
  util_setBoundBox('-1 -1 -1', '1 1 1');
  mh_world_updateClientSpeed(300, 300, 300, "0","0");
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
  local entity dat;
  dat = m_findMechData(self.vec_size, self.nextVecChoice);
  self.p_class = P_MECH;
  self.data_idx = dat.data_idx;
  self.power_timer = time + 5;
  self.stat_plr_stt = PLAYER_SPAWN;
  buildVehicle(dat);
  if((self.flags & FL_CLIENT)){
    mh_world_updateClientSpeed(self.m_fspeed, self.m_sspeed, self.m_bspeed, ftos(self.m_maccel), self.m_rollangle);
    mh_world_updateClientViewBob(self.m_bob, self.m_bcycle, self.m_bup);
    mh_world_updateClientModelBob(self.m_bmodel, self.m_bside, self.m_bobspd);
    self.stat_plr_stt = PLAYER_SPAWN;
   //1/27/2017
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self.e_cam);
  }
  droptofloor();
};

void() player_unmakeMech={
  self.p_class = P_OBS;
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
  self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & (LOCK_TARG | LOCK_PLYR));
  mech_clearWeaponState();
  mech_clearWeaponGroups();
  mech_cleanupMech();
};