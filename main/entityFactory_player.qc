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
  self.view_ofs = '0 0 1';
  self.damageValue = 0;
  self.clientData.SendFlags =  self.clientData.SendFlags | SENDFLAG_NEWUNIT;
  self.canTarget = FALSE;
};

void() player_unmakeObserver={
  if( (self.flags & FL_FLY) ){
    self.flags = self.flags - (self.flags & FL_FLY);
  }
  self.movetype = MOVETYPE_WALK;
};

void() player_makeVec={
  //<chuckle> oh we'll get here soon
};

float() customize_part_for_client={
  local vector chunkOfs;
  if( self.owner != other ){
    return FALSE;
  }
  makevectors(other.angles);
  chunkOfs = other.origin + (v_right * self.compOffset_x) + (v_up * self.compOffset_y) + (v_forward * (self.compOffset_z - fabs(other.cockpit.compOffset_z * 2.5)));
  setorigin(self, chunkOfs);
  
  return TRUE;
};

void() player_makeMech={
  local entity hudWepStart;
  
  self.data_idx = self.nextVecChoice;
  
  initialize_data_mech_( self.nextVecChoice );
  self.touch = ctrl_player_mech_touch;
  
  droptofloor();
  
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
  
  client_playTrack(self, world.sounds, TRUE);  //exiting hangar menu
 
  //player_setup_hudconsole();
  //configure player mech bits visibility
  hudWepStart = self;
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    switch(cvar("skill")){
      case 1:
        self.energyMax = self.energyMax * 1.5;
        self.energyRate = self.energyRate * 1.1;
        break;
      case 2:
        self.energyMax = self.energyMax * 1.25;
        self.energyRate = self.energyRate * 1.05;
        break;
      case 3:
        self.energyMax = self.energyMax * 0.9;
        self.energyRate = self.energyRate * 0.95;
        break;
      default:
        self.energyMax = self.energyMax * 1;
        break;
    }
  }
  self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torsoLeft.effects = self.torsoLeft.effects | EF_NODRAW;
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torsoRight.effects = self.torsoRight.effects | EF_NODRAW;
  }
  
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armLeft.effects = self.armLeft.effects | EF_NODRAW;
  }
  
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armRight.effects = self.armRight.effects | EF_NODRAW;
  }
  
  self.legs.effects = self.legs.effects | EF_NODRAW;
  
  self.view_ofs = '0 0 0';
  self.view_ofs_z = self.cockpit.compOffset_y;  //set player view offset to where the cockpit ent is.
  self.stat_rdr_mode = TRUE; //start with active radar
  self.stat_rdr_rng = self.radar_range * 2;
  self.damageValue = 0;
  self.critBits = 0;
  self.canTarget = TRUE;
  
  self.clientData.effects = self.clientData.effects | EF_NODEPTHTEST;
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_NEWUNIT | SENDFLAG_TURRET | SENDFLAG_MOVE | SENDFLAG_EFLAGS | SENDFLAG_COLORS | SENDFLAG_CAMERA | SENDFLAG_TARGET | SENDFLAG_FACTION);
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
  
  self.stat_target_hp_torsoCenter = 0;
  self.stat_target_hp_torsoLeft = 0;
  self.stat_target_hp_torsoRight = 0;
  self.stat_target_hp_armLeft = 0;
  self.stat_target_hp_armRight = 0;
  self.stat_target_hp_legs = 0;

  self.stat_client_hp_torsoCenter = 1;
  self.stat_client_hp_torsoLeft = 1;
  self.stat_client_hp_torsoRight = 1;
  self.stat_client_hp_armLeft = 1;
  self.stat_client_hp_armRight = 1;
  self.stat_client_hp_legs = 1;
  
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
  self.w_proj = 0; //used to track enemy hit time
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