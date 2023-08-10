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
  
  setmodel(self, "models/testball.md3");
  setsize(self, '-4 -4 -4', '4 4 4');
  self.scale = 0.005;
  self.view_ofs = '0 0 1';
  self.damageValue = 0;
  self.data_speed_forward = 1000;
  self.data_speed_strafe = 1000;
  self.data_speed_backward = 1000;
  self.data_speed_accel = 2;
  self.SendFlags =  self.SendFlags | SENDFLAG_NEWUNIT | SENDFLAG_EFLAGS;
  self.canTarget = FALSE;
};

void() player_unmakeObserver={
  if( (self.flags & FL_FLY) ){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
  self.SendFlags = self.SendFlags | SENDFLAG_EFLAGS;
};

void() player_makeVec={
  //<chuckle> oh we'll get here soon
};


void() player_makeMech={
  local entity hudWepStart;
  
  self.data_idx = self.nextVecChoice;
  
  initialize_data_mech_( self.nextVecChoice );
  self.touch = ctrl_player_mech_touch;
  
  
  self.currentWeaponGroup = self.w_group1;
  
  if( cvar("developer") || (!(serverflags & SVFLAG_POWERUP) && (ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN)) ){
    self.power_timer = time + POWERUP_DEBUG;
  }
  else{
    self.power_timer = time + self.startupDelay;
  }
  //self.power_timer_segment = time + (self.startupDelay / 100 ); not sure why this was needed
  self.playerState = PLAYER_POWERUP_BEGIN;
  self.last_color = FALSE;
  self.new_color = FALSE;
  self.enemy = world;
  
  client_push_player_info();
  
  //client_playTrack(self, world.sounds, TRUE);  //exiting hangar menu
 
  //player_setup_hudconsole();
  //configure player mech bits visibility
  hudWepStart = self;
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    switch(cvar("skill")){
      case 1:
        self.energyMax = self.energyMax * 1.25;
        self.energyRate = self.energyRate * 1.1;
        break;
      case 2:
        self.energyMax = self.energyMax * 1.15;
        self.energyRate = self.energyRate * 1.0;
        break;
      case 3:
        self.energyMax = self.energyMax * 0.85;
        self.energyRate = self.energyRate * 0.9;
        break;
      default:
        break;
    }
  }
  
  self.view_ofs = '0 0 0';
  self.view_ofs_z = self.cameraOffset_y;  //set player view offset to where the cockpit ent is.
  self.stat_rdr_mode = TRUE; //start with active radar
  self.stat_rdr_rng = self.radar_range * 2;
  self.damageValue = 0;
  self.critBits = 0;
  self.canTarget = TRUE;
  if( self.data_speed_decel == 0){
    self.data_speed_decel = cvar("sv_stopspeed");
  }
  
  droptofloor();

  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
  self.targetEntId = 0;
  self.new_color = TRUE;
  self.effects = self.effects | EF_NODEPTHTEST;
  self.SendFlags = self.SendFlags | (SENDFLAG_VELOCITY | SENDFLAG_MOVE | SENDFLAG_TURRET | SENDFLAG_NEWUNIT | SENDFLAG_EFLAGS | SENDFLAG_COLORS | SENDFLAG_CAMERA | SENDFLAG_FACTION | SENDFLAG_RADAR | SENDFLAG_TARGET);
};

void() player_unmakeMech={
  self.viewzoom = 1;
  self.nextVecChoice = 0;
  self.vec_size = 0;
  self.data_idx = 0;
  self.currentWeaponGroup = 0;
  self.energy = 0;
  self.energyMax = 0;
  self.energyRate = 0;
  self.shield = 0;
  self.shieldMax = 0;
  self.shieldRate = 0;
  self.stat_client_energy = 1;
  self.stat_client_shield = 1;
  
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.aState = 0;  //used to track selected weapon group WHEN player uses fire-single-group mode
  
  self.stat_trg_dataidx = 0;
  self.stat_target_shield = 0;
  self.stat_trg_ddflg = 0;
  self.stat_trg_dist = 0;
  self.stat_trg_face = 0;
  self.stat_trg_faction = 0;
  
  self.radar_range = 0;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.timer_hittarg = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  self.stat_rdr_rng = 0;

  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  //self.targLockState = LOCK_NONE; //2.0.0: lock-on not timer-based anymore
  
  self.next_wepn1 = 0;
  self.next_wepn2 = 0;
  self.next_wepn3 = 0;
  self.next_wepn4 = 0;
  self.next_wepn5 = 0;
  self.next_wepn6 = 0;
  self.next_wepn7 = 0;
  self.next_wepn8 = 0;
  self.next_wepn9 = 0;
  
  self.ramTracker = 1;
  self.ramUp = 1;
  self.ramUpMax = 1;
  self.repair_request = 0;
  self.enemy = world; //explicit assignment here
  self.stat_plr_rep = 0;
  self.stat_target_name = "";
  self.critBits = 0;
  self.damageValue = 0;
  
  if( self.particleCube != world){
    remove(self.particleCube);
  }
  ctrl_unit_clean_wgroups();
};