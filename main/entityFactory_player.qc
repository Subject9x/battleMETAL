/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
     mod 3/10/2017
Overview: header for player type factory
*/

void() player_makeObserver={
  self.data_type = DATA_POBS;
  self.flags = self.flags | FL_FLY;
  util_setHealthArmor(1,1,1,0);
  macro_set_collider(DAMAGE_NO, SOLID_SLIDEBOX, MOVETYPE_FLY)
  self.weaponmodel = "";
  
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-4 -4 -4', '4 4 4');
  self.scale = 0.005;
  if( cvar("developer") ){
    client_update_moveSpeed(800, 800, 500, "3", 0);
  }
  else{
    client_update_moveSpeed(200, 200, 200, "3", 0);
  }
  client_update_viewBob(0, 0, 0);
  client_update_modelBob(0, 0, 0, 0);
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  self.view_ofs = '0 0 1';
};

void() player_unmakeObserver={
  if( (self.flags & FL_FLY) ){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
  self.scale = 1;
};

void() player_makeVec={

  
};

void() player_makeMech={
  
  self.data_idx = self.nextVecChoice;
  
  initialize_data_mech_( self.nextVecChoice );
  self.touch = ctrl_player_mech_touch;
  
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = self.radar_range;
  
  droptofloor();
  
  self.currentWeaponGroup = self.w_group1;
  
  if( cvar("developer") ){
    self.power_timer = time + POWERUP_DEBUG;
  }
  else{
    self.power_timer = time + self.startupDelay;
  }
  //self.power_timer_segment = time + (self.startupDelay / 100 ); not sure why this was needed
  self.playerState = PLAYER_POWERUP_BEGIN;
  
  client_push_player_info();
  client_update_moveSpeed(self.data_speed_forward, self.data_speed_strafe, self.data_speed_backward, ftos(self.data_speed_accel), self.hud_rollangle);

  
  client_update_viewPitch( self.pitchMin, self.pitchMax );
  client_send_event_powerup( self );
  client_playTrack(world.sounds, TRUE);  //exiting hangar menu
  
  //TODO - refactor/refine - this allows for composited HUD modeling, and EF_NOGUNBOB allows for sub-component HUD parts to not shake.
  newmis = spawn();
  newmis.movetype = MOVETYPE_NONE;
  newmis.solid = SOLID_NOT;
  newmis.viewmodelforclient = self;
  newmis.owner = self;
  newmis.alpha = 1;
  setmodel(newmis, self.hud_model);
  setsize(newmis, '0 0 0', '0 0 0');
  setorigin(newmis, '0 0 0');
  newmis.frame = self.weaponframe;
  self.hud_mode = cvar("cl_hud_sway");
  self.hud_ent = newmis;
  util_updateViewBob();
  
  msg_entity = self;
  WriteByte(MSG_ONE, SVC_SETVIEWPORT);
  WriteEntity(MSG_ONE, self.cockpit);
  self.stat_rdr_mode = 1;
  self.stat_rdr_rng = self.radar_range * 2;
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
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = 0;
  self.energy = 0;
  self.shield = 0;
  self.enemy = world;
  ctrl_unit_clean_wgroups();
};