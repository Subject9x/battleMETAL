/*
Quake 1**
author: iD software.
Overview:
  This is the collection of the Player think() functions originally found in client.qc
  I decided to separate out player_ functions from client_ functions for my own clarity.
  
engine notes; 
  thanks Mankrip
    prethink happens before the physics are updated (which is why it should not be used for camera work, since its position will be modified by the physics afterwards before the frame is rendered).
    .think() and .touch() happens during the entity physics cycle. 
    IIRC think is run after the physics, because .think with .nextthink=time will run in the current frame (which should not be done if you're trying to modify entities other than self, 
      because the next entities in the current frame's cycle can conflict with that. Quake engine entity management lacks atomization).

    postthink happens after the physics and all entities have been updated. 
    It's the ideal place for code that should run on the current frame with no risk of being overridden by the entities' physics (cameras, hitscan weapons, etc).
    
   and thanks, Spoike.
    the player's think functions happens at a (mostly) well defined interval. playerXthink functions happen at some arbitrary controlled-by-engine rate that varies between singleplayer and multiplayer.
    thus the .think is rather handy for controlling animations, while the playerXthink functions are handy for things that must be run more often than a measly 10 times a second.

** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/
/*
===========
PlayerPreThink

called before running player input frame
============
*/
void() PlayerPreThink = {
  self.attackFlag = 0;
  //keep losses up-to-date
  client_update_losses();
  
  if( self.playerState == PLAYER_INTERMSN ){
    if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ENDING ){
      return;
    }
  }
  
	if (self.deadflag == DEAD_DEAD){
		return;
	}
  
	if (self.deadflag >= DEAD_DYING){
    return;	// dying, so do nothing
  }
  
	if (intermission_running){
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}
  
  if( self.playerState == PLAYER_INTERMSN ){
    if(world.animaticOnly){
      return;
    }
  }
  
	if (self.view_ofs == '0 0 0'){
  	return;		// intermission or finale
  }
  
	makevectors (self.v_angle);		// is this still used

	//CheckRules ();  TODO - apparently vanilla QC checks multiplayer rules here - Roohr
	//WaterMove ();

	//if (self.waterlevel == 2)
		//CheckWaterJump ();

  //Player powering up their mech, prevent movement
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
  
  if( (self.unitModFlags & MOD_HAS_RAMSHOCKS)){
    if( !self.button8 ){
      if( self.moveState > 0 ){
        self.moveState = 0;
        if( time > self.ramCharge ){
          self.ramAngle_y = self.v_angle_y;
        }
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

/*
===========
PlayerPostThink

called after running player input frame
============
*/
void() PlayerPostThink = {
  local entity wep_chain;
  local float legDmg, centerTorsoDmg;
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
    if(world.animaticOnly){
      return;
    }
  }
  
  if(time < self.power_timer){
    PlayerPostThink_powerup();
    return;
  }
  if( (self.movement_x || self.movement_y) ){
    self.moveState = MOVE_NORM;
  }
  else{
    self.moveState = MOVE_STAND;
  }
  if( self.impulse ){
    ImpulseCommands ();
  }
  
  ButtonCommands();
  
  if(self.data_type != DATA_POBS){ 
    //power up sequence
    if(time > self.power_timer){
      self.power_timer = 0;
      self.playerState = PLAYER_ACTIVE;
    }
    
    self.stat_hit_dirs = self.hitdir_buffer;
    if(time >= self.w_proj){
      self.stat_hit_dirs = self.stat_hit_dirs  - (self.stat_hit_dirs  & STAT_HIT_TRG);
    }
    if(time >= self.was_hit){
      self.stat_hit_dirs =  self.stat_hit_dirs - (self.stat_hit_dirs & (STAT_HIT_LF | STAT_HIT_RT | STAT_HIT_BK));
      self.hitdir_buffer = 0;
    }
  }
  
  //Update Target information
  sv_updateTargetInfo();
  
// do weapon stuff
  //STAT UPDATE   
  if( self.data_type == DATA_MECH ){
    makevectors(self.v_angle);
    traceline(self.origin, self.origin + (v_forward * self.stat_rdr_rng), FALSE,self);
    self.stat_ret_dist = (self.stat_rdr_rng * trace_fraction);
    
    //TODO notify target of lock
    /*if((self.targLockState & LOCK_TARG)){
      if(self.enemy != world){
        if(!(self.enemy.targLockState & LOCK_PLAYER)){
          self.enemy.targLockState = self.enemy.targLockState | LOCK_PLAYER;
        }
      }
    }*/
    
    ctrl_update_mechplayer();
    
    for( wep_chain = self.w_slot; wep_chain != world; wep_chain = wep_chain.w_slot ){
      if( wep_chain.owner != self ){
        continue;
      }
      ctrl_weapon_think(wep_chain);
      ctrl_weapon_update_player(wep_chain);
    }
    
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
// check for attack
  self.statTargetHitParts = 0;
  playerAttack();
  
  if( time > self.posFadeTimer ){
    self.posFadeTimer = time + POSITION_FADE_TIME;
    self.position3 = self.position2;
    self.position2 = self.position1;
    self.position1 = self.origin;
  }

// check to see if player landed and play landing sound	
  if ((self.jump_flag < self.fall_dist) && (self.flags & FL_ONGROUND) && (self.health > 0)){
    //if (self.watertype == CONTENT_WATER)
      //sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
    //else
    if (self.jump_flag < self.fall_slam){
      if( self.jump_flag < (self.fall_dist * FALL_KILL_MULTIPLIER) ){
        //player fell from great height and is killed outright...whoops
        t_damage( self, world, world, self.legs.health, self.legs.origin, '0 0 0');
        t_damage( self, world, world, self.health, self.origin, '0 0 0');
      }
      else{
        legDmg = self.legs.max_health * (self.fall_dmg * FALL_DAMAGE_FRACTION);
        t_damage( self, world, world, legDmg, self.legs.origin, '0 0 0');
        if( self.legs.health < (self.legs.max_health * 0.33) ){
          centerTorsoDmg = self.torsoCenter.max_health * self.fall_dmg;
          t_damage( self, world, world, centerTorsoDmg, self.origin, '0 0 0');
        }
      }
    }
    else{
      //TODO
      //sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
    }
    self.jump_flag = 0;
  }

  if(  (self.unitModFlags & MOD_HAS_RAMSHOCKS) ){
    if( time > self.ramCool ){
      if( self.moveState > MOVE_NORM ){
        if(self.movement_x > 0 && self.movement_y == 0 ){
          if( self.energy > (self.energyMax * 0.15)){
            if( self.ramUp < self.ramUpMax ){
              self.ramUp = self.ramUp + self.data_speed_accel * MOVE_RAM_SCALAR_UP;
            }   
          }   
        }
        else{
          self.ramUp = self.ramUp - self.data_speed_accel * MOVE_RAM_SCALAR_DN;
        }
      }
      else{
          self.ramUp = self.ramUp - self.data_speed_accel * MOVE_RAM_SCALAR_DN;
      }
      if( self.ramUp < 0 ){
        self.ramUp = 0;
      }
    }
    if( time <= self.ramCharge ){
      self.moveState = MOVE_RAM_CHARGE;
    }
    else if( time <= self.ramCool ){
      self.ramUp = 0;
      self.moveState = MOVE_RAM_COOL;
    }
    else{
      self.ramTracker = (self.ramUp / self.ramUpMax);
      if(self.ramTracker > 1 ){
        self.ramTracker = 1;
      }
    }
  }
  
  //after server processes everything, push data to client
  client_push_player_info();
 
  if (!(self.flags & FL_ONGROUND)){
    self.jump_flag = self.velocity_z;
  }
  
  //network SendFlags 
  if( self.clientData != world ){
    if( self.last_origin != self.origin ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_MOVE;
    }
    if( self.last_angle != self.v_angle ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TURRET;
    }
    if( self.damageValue > 0 ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_CRIT;
    }
    if( self.last_shield != self.stat_client_shield ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_SHIELD;
      self.last_shield = self.stat_client_shield;
    }
    if( self.last_crit != self.critBits ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_CRIT;
      if( !(self.critBits & M_REPAIR) ){
        client_send_critical_hit( num_for_edict(self), self.critBits );
      }
      self.last_crit = self.critBits;
      
    }
    if( self.last_burn != self.burnBits ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_BURN;
      self.last_burn = self.burnBits;
    }
    if( self.last_color != self.new_color ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_COLORS;
      self.new_color = FALSE;
      self.last_color = self.new_color;
    }
    if( self.attackFlag > 0 ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_ATTACK;
    }
  }
  
  //DEBUG / DEV ONLY!
  if( cvar("developer") ){
    //if(self.button3){
      //makevectors(self.v_angle);
      //traceline(self.origin, self.origin + (v_forward * 10000), FALSE, self);
      //self.compOffset = trace_endpos;
      
      //trailparticles(self, particleeffectnum("TE_LAS_RAIL"), self.origin + (v_up * -8), self.origin + (v_forward * 10000)); //debug
      //cons_logAVector("view trace_normal", util_trace_norm_angle()); //debug
    //}
  }
  //========================================  
  
  self.last_origin = self.origin; //used for SENDFLAG_MOVE delta
  self.last_angle = self.v_angle;
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
  for( wep_chain = self.w_slot; wep_chain != world; wep_chain = wep_chain.w_slot ){
    if( wep_chain.owner != self ){
      continue;
    }
    ctrl_weapon_think(wep_chain);
  }

  //DEBUG / DEV ONLY!
  if( cvar("developer") ){
    if(self.button0){
      makevectors(self.v_angle);
      traceline(self.origin, self.origin + (v_forward * 10000), TRUE, self);
      self.compOffset = trace_endpos;
    }
  }

  //after server processes everything, push data to client
  client_push_player_info();
};

/*
===========
PlayerDie - Campaign

self.th_die() 
============
*/
void() PlayerDie={
	if( self.deadflag ){
		bprint("warning: PlayerDie called twice\n");
		return;
	}
  self.playerState = PLAYER_DEAD;
  ctrl_unit_clean_wgroups();
  ctrl_mech_die_player();
  
  client_push_player_info();
  client_push_mapobjects();
  client_send_campaign_end_data( self );
  
  self.damageValue = 0;
  self.critBits = 0;
  self.last_crit = 0;
  self.targetEntId = 0;
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_DEAD | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TARGET);
  
  self.effects = 0;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_CORPSE;
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.movetype = MOVETYPE_TOSS;
  setsize(self, '-4 -4 -4', '4 4 4');
  setorigin(self, self.origin);
  
  if( self.moveState != MOVE_STAND ){
    if (self.velocity_z < 10){
      self.velocity_z = self.velocity_z + (random() * ((4 - self.vec_size) * 150));
    }
  }
  
  self.angles_x = 0;
  self.angles_z = 0;
  self.angles_y = 0;
  self.avelocity = '0 0 0';
  
  self.think = PlayerDieEnd;
  self.nextthink = time + GAME_TIME_TO_DEBRIEF;
};

void() PlayerDieEnd={
  self.movetype = MOVETYPE_NONE;
  
  self.playerState = PLAYER_DEBRIEF;
  ctrl_unit_cleanup_player();
  player_unmakeMech();
  
  self.think = PlayerDead;
  self.nextthink = time + 0.1;
};

/*
===========
PlayerDie - Network Games
============
*/
/*
  Call stack: t_damage() -> killed() -> player.th_die();
    this is called on the frame that a player is actually killed.
*/
void() PlayerDieNetwork={
	if( self.deadflag ){
		bprint("warning: PlayerDie called twice\n");
		return;
	}
  self.playerState = PLAYER_DEAD;
	if(self.data_type == DATA_MECH){
    ctrl_unit_clean_wgroups();
    ctrl_mech_die_player();
  }
  client_push_player_info();
  client_push_mapobjects();
  
  self.effects = 0;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_CORPSE;
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.movetype = MOVETYPE_TOSS;
  setsize(self, '-8 -8 -8', '8 8 8');
  setorigin(self, self.origin);
  
  if( self.moveState != MOVE_STAND ){
    if (self.velocity_z < 10){
      self.velocity_x = self.velocity_x + (crandom() * ((4 - self.vec_size) * 100));
      self.velocity_y = self.velocity_y + (crandom() * ((4 - self.vec_size) * 100));
      self.velocity_z = self.velocity_z + (random() * ((4 - self.vec_size) * 150));
    }
  }
  
  self.angles_x = 0;
  self.angles_z = 0;
  self.angles_y = 0;
  self.avelocity = '0 0 0';
  
  self.damageValue = 0;
  self.critBits = 0;
  self.last_crit = 0;
  self.targetEntId = 0;
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_DEAD | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TARGET);
  
  self.playerDeaths = self.playerDeaths + 1;
  
  self.think = PlayerDieNetworkEnd;
  self.nextthink = time + GAME_TIME_TO_DEBRIEF;
};

/*
  call stack: think()? -> 
    time + GAME_TIME_TO_DEBRIEF
*/
void() PlayerDieNetworkEnd={
  
  ctrl_unit_cleanup_player();
  player_unmakeMech();
  player_makeObserver();
 
  if( self.playerState == PLAYER_INTERMSN ){
    //end of round happened during death.
    self.deadflag = DEAD_DEAD;
    return;
  }
  self.movetype = MOVETYPE_NONE;
  
  if( ENT_SERVER_INFO.missionStatus < MISSION_STATUS_OVER ){
    self.playerState = PLAYER_REDEPLOY;
  }
  else{
    self.playerState = PLAYER_INTERMSN; //short-circuit to intermission
    //on ending server.
  }
  
  self.think = PlayerDead;
  self.nextthink = time + 1;
};


void() PlayerDead={
	self.nextthink = -1;
  if( self.playerState == PLAYER_INTERMSN ){
    //end of round happened during death.
    self.deadflag = DEAD_DEAD;
    return;
  }
  self.playerState = PLAYER_SPAWN;
	self.deadflag = DEAD_DEAD;
};

//called in PlayerPreThink() when self.deadflag == DEAD_DEAD
void() PlayerDeathThink={  
//battleMETAL - player respawn is stage-managed wth clientside menus...
// wait for all buttons released
/*	if (self.deadflag == DEAD_DEAD){
		if (self.button2 || self.button0 || self.button3 || self.button4 || self.button5 || self.button6 || self.button7){
			return;
    }
		self.deadflag = DEAD_RESPAWNABLE;
    cons_logAFloat("SV()->PlayerDeathThink()->self.deadflag = DEAD_RESPAWNABLE", self.deadflag);  //DEBUG
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
  */
	self.deadflag = DEAD_RESPAWNABLE;
};

//UNUSED
void() PlayerJump={
 //local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
  //Quake 1 water detection / SFX disabled for now.
	/*if (self.waterlevel >= 2){
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
	}*/

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