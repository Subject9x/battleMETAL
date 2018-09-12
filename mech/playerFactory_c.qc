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
  self.data_type = DATA_POBS;
  self.view_ofs = '0 0 1';
  self.flags = self.flags | FL_FLY;
  util_setHealthArmor(1,1,1,0);
  util_setCollider(DAMAGE_NO, SOLID_TRIGGER, MOVETYPE_FLY);
  self.weaponmodel = "";
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-4 -4 -4', '4 4 4');
  self.scale = 0.005;
  mh_world_updateClientSpeed(200, 200, 200, "3","0");
  mh_world_updateClientViewBob("0", "0", "0");
  mh_world_updateClientModelBob("0", "0", "0");
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  self.stat_plr_stt = PLAYER_IN_MENU;
};

void() player_unmakeObserver={
  if((self.flags & FL_FLY)){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
  self.scale = 1;
  self.view_ofs = '0 0 1';
};

void() player_makeVec={

  
};

void() player_makeMech={
  self.data_type = DATA_MECH;
  self.data_idx = self.nextVecChoice;
  self.power_timer = time + 7;
  self.power_timer_segment = time + 0.007;
  data_iniMech(self.nextVecChoice);
  //self.touch = touch_mech; shhhhh, not yet
  if( (self.flags & FL_CLIENT) ){
    mh_world_updateClientSpeed(self.m_fspeed, self.m_sspeed, self.m_bspeed, ftos(self.m_maccel), self.m_rollangle);
    mh_world_updateClientViewBob(self.m_bob, self.m_bcycle, self.m_bup);
    mh_world_updateClientModelBob(self.m_bmodel, self.m_bside, self.m_bobspd);
     
    //test
    /*newmis = spawn();
    newmis.movetype = MOVETYPE_FOLLOW;
    newmis.solid = SOLID_NOT;
    setmodel(newmis, self.weaponmodel);
    setsize(newmis, '-1 -1 -1', '1 1 1');
    setorigin(newmis, self.e_cam.origin);
    
    newmis.drawonlytoclient = self;
    newmis.owner = self.e_cam;
     
    newmis.aiment = self;
    newmis.owner = self;
    newmis.punchangle = self.angles;
    newmis.view_ofs = newmis.origin - self.origin;
    newmis.angles = self.angles;
    newmis.v_angle = newmis.angles - self.angles;
     

    newmis.frame = self.weaponframe; */
    //test===============    
    
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self.e_cam);
    
    client_push_player_info();
  }
  droptofloor();
  self.currentWeaponGroup = self.w_group1;
  self.stat_plr_stt = PLAYER_POWERUP_BEGIN;
};

void() player_unmakeMech={
  self.data_type = DATA_POBS;
  self.vec_size = 0;
  self.data_idx = 0;
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
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_plr_stt = PLAYER_IN_MENU;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  self.stat_ctor_hp = 0;
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = 0;
  self.en_cur = 0;
  self.sh_cur = 0;
  self.enemy = world;
  mech_clearWeaponGroups();
};