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
  self.stat_player_weapons_state = 0;
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
  //<chuckle> oh we'll get here soon
};

//creates the 3D hud boxes for the player
//TODO - move me to clientside.
void() player_setup_hudconsole={
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
  self.hud_ent = newmis;
};

float() customize_part_for_client ={
  local vector chunkOfs;
  if( self.owner != other ){
    return FALSE;
  }
  makevectors(other.angles);
  chunkOfs = other.origin + (v_right * self.compOffset_x) + (v_up * self.compOffset_y) + (v_forward *(self.compOffset_z - fabs(other.cockpit.compOffset_z)));
  setorigin(self, chunkOfs);
  return TRUE;
};

float() customize_wep_for_client={
  local vector chunkOfs;
  makevectors(self.owner.angles);
  chunkOfs = self.owner.origin + (v_right * self.compOffset_x) + (v_up * self.compOffset_y) + (v_forward * (self.compOffset_z - self.owner.cockpit.compOffset_z * 1.5));
  self.wepFireOffset_z = self.wepFireOffsetCache_z - self.owner.cockpit.compOffset_z;
  self.compAltOffset_z = self.compAltOffsetCache_z - self.owner.cockpit.compOffset_z;
  setorigin(self, chunkOfs);
  return TRUE;
};


void( entity wepThing, entity wepPointer ) player_set_hud_weapon={
  local entity newHudPart, ownerSelf;
  local vector ofs;
  ownerSelf = self;
  newHudPart = spawn();
  self = newHudPart;
  
  macro_set_collider(DAMAGE_NO, SOLID_NOT, MOVETYPE_FOLLOW)
  setsize(self, '-1 -1 -1','1 1 1');
  macro_set_model(wepThing.model, 0, 0)  
  makevectors(self.owner.angles);
  ofs = self.owner.origin + (v_right * wepThing.compOffset_x) + (v_up * (wepThing.compOffset_y * -2)) + (v_forward * (wepThing.compOffset_z - self.owner.cockpit.compOffset_z));
  setorigin(self, ofs);
  self.punchangle = ownerSelf.angles;
  self.view_ofs = self.origin - ownerSelf.origin;
  self.angles = ownerSelf.angles;
  self.v_angle = self.angles - ownerSelf.angles; 

  self.viewmodelforclient = ownerSelf;
  self.owner = ownerSelf;
  self.alpha = 1;
  
  self = ownerSelf;
  
  wepThing.nodrawtoclient = ownerSelf;
  wepPointer.hudWeapon = newHudPart;
  wepPointer = newHudPart;
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
  
  client_playTrack(world.sounds, TRUE);  //exiting hangar menu
 
  player_setup_hudconsole();
  //configure player mech bits visibility
  local entity wep, hudWepStart;
  hudWepStart = self;
  if( GAMETYPE == GAMEMODE_CAMPAIGN ){
    //non-network games can have more fun with player view
    self.torsoCenter.exteriormodeltoclient = self;
    self.torsoCenter.customizeentityforclient = customize_part_for_client;
    self.torsoLeft.customizeentityforclient = customize_part_for_client;
    self.torsoRight.customizeentityforclient = customize_part_for_client;
    self.armLeft.customizeentityforclient = customize_part_for_client;
    self.armRight.customizeentityforclient = customize_part_for_client;
    self.legs.customizeentityforclient = customize_part_for_client;
    
    for( wep = self.w_slot; wep != world; wep = wep.w_slot){
      wep.customizeentityforclient = customize_wep_for_client;
    }
  }
  else{
    //network games are too laggy to allow a player to see their own mech parts sadly
    self.torsoCenter.exteriormodeltoclient = self;
    self.torsoLeft.exteriormodeltoclient = self;
    self.torsoRight.exteriormodeltoclient = self;
    self.armLeft.exteriormodeltoclient = self;
    self.armRight.exteriormodeltoclient = self;
    self.legs.exteriormodeltoclient = self;
    
    for( wep = self.w_slot; wep != world; wep = wep.w_slot){
      wep.exteriormodeltoclient = self;
      player_set_hud_weapon( wep, hudWepStart);
    }
  }
  
  self.hud_mode = cvar("cl_hud_sway");
  util_updateViewBob();
  
  self.view_ofs = '0 0 0';
  self.view_ofs_z = self.cockpit.compOffset_y;  //set player view offset to where the cockpit ent is.
  self.stat_rdr_mode = 1; //start with active radar
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

  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_rdr_mode = FALSE;
  self.stat_rdr_rng = 0;
  self.energy = 0;
  self.shield = 0;
  self.enemy = world;
  
  self.weaponmodel = "";
  self.weaponframe = 0;
  self.hud_ent.modelindex = 0;
  self.hud_ent.effects = EF_NODRAW;
  self.hud_ent.think = SUB_Remove;
  self.hud_ent.nextthink = time + 0.01;
  
  if( self.particleCube != world){
    self.particleCube.think = SUB_Remove;
    self.particleCube.nextthink = time + 0.01;
  }
  ctrl_unit_clean_wgroups();
};