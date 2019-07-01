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
  client_update_moveSpeed(200, 200, 200, "3","0");
  client_update_viewBob("0", "0", "0");
  client_update_modelBob("0", "0", "0");
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  self.stat_plr_stt = PLAYER_IN_MENU;
};

void() player_unmakeObserver={
  if( (self.flags & FL_FLY) ){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
  self.scale = 1;
  self.view_ofs = '0 0 1';
};

void() player_makeVec={

  
};

void() player_makeMech={
  
  self.data_idx = self.nextVecChoice;
  
  initialize_data_mech_( self.nextVecChoice );
  
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = self.radar_range;

  msg_entity = self;
  WriteByte(MSG_ONE, SVC_SETVIEWPORT);
  WriteEntity(MSG_ONE, self.e_cam);
  
  droptofloor();
  
  self.currentWeaponGroup = self.w_group1;  
  
  if( cvar("developer") ){
    self.power_timer = time + POWERUP_DEBUG;
  }
  else{
    self.power_timer = time + 7;
  }
  self.power_timer_segment = time + 0.007;
  self.stat_plr_stt = PLAYER_POWERUP_BEGIN;
  
  client_push_player_info();
  client_update_moveSpeed(self.data_speed_forward, self.data_speed_strafe, self.data_speed_backward, ftos(self.data_speed_accel), self.hud_rollangle);
  client_update_viewBob(self.hud_bob, self.hud_bob_cycle, self.hud_bob_up);
  client_update_modelBob(self.hud_bob_model, self.hud_bob_side, self.hud_bob_speed);
  client_update_viewPitch( self.pitchMin, self.pitchMax );
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
  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_plr_stt = PLAYER_IN_MENU;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  self.stat_ctor_hp = 0;
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = 0;
  self.energy = 0;
  self.shield = 0;
  self.enemy = world;
  mech_clearWeaponGroups();
};