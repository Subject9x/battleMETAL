/*
Quake 1**
author: iD software.
Overview:
  This is the collection of the Player think() functions originally found in client.qc
  I decided to separate out player_ functions from client_ functions for my own clarity.

** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/
void() PlayerPreThink = {
	if (self.deadflag == DEAD_DEAD){
		PlayerDeathThink ();
		return;
	}
	if (self.deadflag >= DEAD_DYING){
    return;	// dying, so do nothing
  }
  
	if (intermission_running){
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}
  
  if(self.view_ofs == '0 0 0'){
    return;
  }
  
  
  if( self.playerState == PLAYER_INTERMSN ){
    client_push_player_info_thin();
  }
  
	if (self.view_ofs == '0 0 0'){
  	return;		// intermission or finale
  }
  
	makevectors (self.v_angle);		// is this still used

	//CheckRules ();
	//WaterMove ();

	//if (self.waterlevel == 2)
		//CheckWaterJump ();

  if(time < self.power_timer){
    PlayerPreThink_powerup();
    return;
  }

	//if (self.button2){
		//PlayerJump();
	//}
	//else
		//self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';
    
  if( !self.button8 ){
    if( self.playerState == PLAYER_SPRINT_ON ){
      self.playerState = PLAYER_ACTIVE;
      client_update_moveSpeed(self.data_speed_forward, self.data_speed_strafe, self.data_speed_backward, ftos(self.data_speed_accel), self.hud_rollangle);
      if( time > self.ramCharge ){
        self.ramAngle_y = self.v_angle_y;
      }
    }
  }
  if( !self.button9 ){
    if( self.viewzoom < 1 ){
      self.viewzoom = self.viewzoom + 0.25;
    }
    else{
      self.viewzoom = 1;
    }
  }
  
};

void() PlayerPostThink = {
  if (self.deadflag >= DEAD_DYING){
    return;
  }
  
  if (intermission_running){
		return;		// intermission or finale
  }
  
  //can't stop mech players with cutscenes, instead use triggered clipping objects
  //in map - roohr
  if( (self.playerState == PLAYER_ANIM_STOP) && (self.data_type == DATA_POBS)){
    if( time >= self.count2){
      self.playerState = self.count1;
      self.movetype = self.count3;
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
    }
  }
  
  if( self.playerState == PLAYER_INTERMSN ){
    client_push_player_info_thin();
  }
  
  if(time < self.power_timer){
    PlayerPostThink_powerup();
    return;
  }
    
  if(self.data_type != DATA_POBS){ 
    local float hudSwayCheck;
    hudSwayCheck = cvar("cl_hud_sway");
    if( self.hud_mode != hudSwayCheck ){
      util_updateViewBob();
    }
    //power up sequence
    if(time > self.power_timer){
      self.power_timer = 0;
      self.playerState = PLAYER_ACTIVE;
    }
    
    self.stat_hit_dirs =  self.hitdir_buffer;
    if(time >= self.w_proj){
      self.stat_hit_dirs = self.stat_hit_dirs  - (self.stat_hit_dirs  & STAT_HIT_TRG);
    }
    if(time >= self.was_hit){
      self.stat_hit_dirs =  self.stat_hit_dirs - (self.stat_hit_dirs & (STAT_HIT_LF | STAT_HIT_RT | STAT_HIT_BK));
    }
  }
  ////
	if( self.impulse ){
		ImpulseCommands ();
  }
  ButtonCommands();
  
  self.stat_cofs_x = self.origin_x;
  self.stat_cofs_y = self.origin_y;
  self.stat_cofs_z = self.origin_z;
  
  //Update Target information
  sv_updateTargetInfo();
  
// do weapon stuff
  //STAT UPDATE   
  if( self.data_type == DATA_MECH ){
    makevectors(self.v_angle);
    traceline(self.origin, self.origin + (v_forward * self.stat_rdr_rng), FALSE,self);
    self.stat_ret_dist = (self.stat_rdr_rng * trace_fraction);
    
    //TODO notify target of lock
    /*if((self.stat_lck_stt & LOCK_TARG)){
      if(self.enemy != world){
        if(!(self.enemy.stat_lck_stt & LOCK_PLAYER)){
          self.enemy.stat_lck_stt = self.enemy.stat_lck_stt | LOCK_PLAYER;
        }
      }
    }*/
    
    ctrl_update_mechplayer();
    
    local entity wep_chain;
    wep_chain = self.w_slot;
    while(wep_chain){
      ctrl_weapon_think(wep_chain);
      wep_chain = wep_chain.w_slot;
    }
    client_updateWeaponReloads();
    
    //REPAIR BAY
    self.repair_request = FALSE;
    if(self.repair_request){
      if(util_getMechHpAverage(self) == 1){
        self.repair_request = FALSE;
      }
    }
    if( self.doRadarSweep ){
      self.doRadarSweep();
    }
  }
  
  //DEBUG / DEV ONLY!
  if( cvar("developer") ){
    if(self.button0){
      makevectors(self.v_angle);
      traceline(self.origin, self.origin + (v_forward * 10000), TRUE, self);
      self.compOffset = trace_endpos;
      //te_beam_esr(self.origin + (v_up * -4), trace_endpos);
    }
    self.stat_cofs_x = self.origin_x;
    self.stat_cofs_y = self.origin_y;
    self.stat_cofs_z = self.origin_z;
  }
  //========================================  

// check for attack
  playerAttack();

// check to see if player landed and play landing sound	
  if ((self.jump_flag < self.fall_dist) && (self.flags & FL_ONGROUND) && (self.health > 0)){
    //if (self.watertype == CONTENT_WATER)
      //sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
    //else
    if (self.jump_flag < self.fall_slam){
      if( self.jump_flag < (self.fall_dist * FALL_KILL_MULTIPLIER) ){
        //player fell from great height and is killed outright...whoops
        t_damage( self, world, world, self.legs.health, 0, self.legs.origin, '0 0 0');
        t_damage( self, world, world, self.health, 0, self.origin, '0 0 0');
      }
      else{
        local float legDmg, centerTorsoDmg;
        legDmg = self.legs.max_health * (self.fall_dmg * FALL_DAMAGE_FRACTION);
        t_damage( self, world, world, legDmg, 0, self.legs.origin, '0 0 0');
        if( self.legs.health < (self.legs.max_health * 0.33) ){
          centerTorsoDmg = self.torsoCenter.max_health * self.fall_dmg;
          t_damage( self, world, world, centerTorsoDmg, 0, self.origin, '0 0 0');
        }
      }
		}
		else{
      //TODO
      //sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
    }
		self.jump_flag = 0;
	}

  if( time > self.ramCool ){
    if( self.playerState == PLAYER_SPRINT_ON ){
      if(self.movement_x > 0 && self.movement_y == 0 ){
        if( self.ramUp < self.ramUpMax ){
          self.ramUp = self.ramUp + (cvar("sys_ticrate") * 3);
        }      
      }
      else{
        self.ramUp = 0;
      }
    }
    else{
      self.ramUp = 0;
    }
  }
  if( time <= self.ramCharge ){
    self.ramTracker = 256;
  }
  else if( time <= self.ramCool ){
    self.ramUp = 0;
    self.ramTracker = 255;
  }
  else{
    self.ramTracker = (self.ramUp / self.ramUpMax) * 100;
    if(self.ramTracker > 100 ){
      self.ramTracker = 100;
    }
  }
  
  
  //after server processes everything, push data to client
  client_push_player_info();
 
	if (!(self.flags & FL_ONGROUND)){
		self.jump_flag = self.velocity_z;
  }

};


void() PlayerPreThink_powerup={
  self.angles = self.wind;
  self.v_angle = self.wind;
  if( (self.flags & FL_ONGROUND) ){
    self.velocity = '0 0 0';
    self.avelocity = '0 0 0';
  }
};

void() PlayerPostThink_powerup={
  self.angles = self.wind;
  self.v_angle = self.wind;
  if( (self.flags & FL_ONGROUND) ){
    self.velocity = '0 0 0';
    self.avelocity = '0 0 0';
  }
  makevectors(self.v_angle);
  traceline(self.origin, self.origin + (v_forward * self.radar_range), FALSE,self);
  self.stat_ret_dist = (self.radar_range * trace_fraction);

  ctrl_update_mechplayer();
  
  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_weapon_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
  client_updateWeaponReloads();

  //DEBUG / DEV ONLY!
  if( cvar("developer") ){
    if(self.button0){
      makevectors(self.v_angle);
      traceline(self.origin, self.origin + (v_forward * 10000), TRUE, self);
      self.compOffset = trace_endpos;
      //te_beam_esr(self.origin + (v_up * -4), trace_endpos);
    }
    self.stat_cofs_x = self.origin_x;
    self.stat_cofs_y = self.origin_y;
    self.stat_cofs_z = self.origin_z;
  }

  //after server processes everything, push data to client
  client_push_player_info();
};


void() PlayerDie={
	if( self.deadflag ){
		bprint("warning: PlayerDie called twice\n");
		return;
	}
	if(self.data_type == DATA_MECH){
    ctrl_unit_clean_wgroups();
    ctrl_mech_die_player();
    client_push_player_info();
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_SETVIEWPORT );
    WriteEntity( MSG_ONE, self );    
  }
  self.effects = 0;
  
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_CORPSE;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
  setsize(self, '-4 -4 -4', '4 4 4');
	setorigin(self, self.origin);
  
  if (self.velocity_z < 10){
    self.velocity_z = self.velocity_z + (random() * ((4 - self.vec_size) * 250));
  }
  
	self.angles_x = 0;
	self.angles_z = 0;
  self.angles_y = 0;
  self.avelocity = '0 0 0';
  
  //update objectives on player death.
  client_push_mapobjects();
  if( MISSION_STATUS ){        
    //only send unlocks if player won mission
    client_sendMissionUnlocks();
    te_mission_win();
  }
  else{
    te_mission_lose();
  }

  self.think = PlayerDieEnd;
  self.nextthink = time + GAME_TIME_TO_DEBRIEF;
};

void() PlayerDieEnd={
  self.movetype = MOVETYPE_NONE;
  self.playerState = PLAYER_INTERMSN;
  client_sendEndMission(self, MISSION_STATUS );
  client_push_player_info();
  local entity start;
  start = find(world, classname, "info_player_start");
  if( start ){
    setorigin( self, start.origin);
  }
  
  self.think = PlayerDead;
  self.nextthink = time + 0.1;
};

void() PlayerDead={
	self.nextthink = -1;
	self.deadflag = DEAD_DEAD;
};

//called in PlayerPreThink() when self.deadflag == DEAD_DEAD
void() PlayerDeathThink={
// wait for all buttons released
	if (self.deadflag == DEAD_DEAD){
		if (self.button2 || self.button0 || self.button3 || self.button4 || self.button5 || self.button6 || self.button7){
			return;
    }
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	if (!self.button2 && !self.button0 && !self.button3 && !self.button4 && !self.button5 && !self.button6 && !self.button7 && !self.button8)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	self.button3 = 0;
	self.button4 = 0;
	self.button5 = 0;
	self.button6 = 0;
	self.button7 = 0;
  self.button8 = 0;
	
  //self.deadflag = DEAD_NO;
  player_unmakeMech();
  ctrl_unit_cleanup_player();
  player_makeObserver();
  if( cvar("deathmatch") || cvar("coop") ){
    spawnpoint_select();
    self.movetype = MOVETYPE_FLY;
    self.flags = self.flags | FL_FLY;
  }

  if( cvar("coop") || cvar("deathmatch") ){
    respawn();
  }
};

//UNUSED
void() PlayerJump={
 //local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2){
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}
		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
// player jumping sound
	//sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 0;
 };
