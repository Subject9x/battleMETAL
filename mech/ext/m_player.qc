/*
  player qc
*/
void() PlayerPreThink = {
  //local	float	mspeed, aspeed;
	//local	float	r;
  //local entity oself;

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}
  
	if (self.view_ofs == '0 0 0'){
  	return;		// intermission or finale
  }
  
	makevectors (self.v_angle);		// is this still used

	//CheckRules ();
	//WaterMove ();

	//if (self.waterlevel == 2)
		//CheckWaterJump ();

  
	if (self.deadflag >= DEAD_DEAD){
		PlayerDeathThink ();
		return;
	}

	if (self.deadflag == DEAD_DYING){
    return;	// dying, so do nothing
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
    if( self.stat_plr_stt == PLAYER_SPRINT_ON){
      self.stat_plr_stt = PLAYER_ACTIVE;
      client_update_moveSpeed(self.m_fspeed, self.m_sspeed, self.m_bspeed, ftos(self.m_maccel), self.m_rollangle);
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
  switch(self.stat_plr_stt){
    case PLAYER_ANIM_STOP:
      if( time >= self.count2){
        self.stat_plr_stt = self.count1;
        self.movetype = self.count3;
      }
      break;
  }
  
  if (self.view_ofs == '0 0 0'){
		return;		// intermission or finale
  }
    
	if (self.deadflag >= DEAD_DYING){
    return;
  }

  if(self.data_type != DATA_POBS){
    //power up sequence
    if(time < self.power_timer){
      if(self.movetype != MOVETYPE_NONE){
        self.movetype = MOVETYPE_NONE;
      }
    }
    if(time > self.power_timer_segment){
      self.stat_plr_stt = PLAYER_POWERUP_END;
    }
    if(time > self.power_timer){
      if(self.stat_plr_stt == PLAYER_POWERUP_END){
        self.power_timer = 0;
        self.movetype = MOVETYPE_WALK;
        self.stat_plr_stt = PLAYER_ACTIVE;
      }
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

  server_make_sweep();
  self.stat_cofs_x = self.origin_x;
  self.stat_cofs_y = self.origin_y;
  self.stat_cofs_z = self.origin_z;
  
  //Update Target information
  server_updateTargetInfo();
  
// do weapon stuff
  //STAT UPDATE   
  if(self.data_type == DATA_MECH){
    makevectors(self.v_angle);
    traceline(self.origin, self.origin + (v_forward * 5000), FALSE,self);
    self.stat_ret_dist = (5000 * trace_fraction);
    self.stat_plr_camx = self.e_cam.c_ofs_x;
    self.stat_plr_camy = self.e_cam.c_ofs_y; 
    self.stat_plr_camz = self.e_cam.c_ofs_z;
    //TODO notify target of lock
    /*if((self.stat_lck_stt & LOCK_TARG)){
      if(self.enemy != world){
        if(!(self.enemy.stat_lck_stt & LOCK_PLYR)){
          self.enemy.stat_lck_stt = self.enemy.stat_lck_stt | LOCK_PLYR;
        }
      }
    }*/
    client_updateWeaponReloads();
    ctrl_update_mechplayer();
    
    local entity wep_chain;
    wep_chain = self.w_slot;
    while(wep_chain){
      ctrl_wpn_think(wep_chain);
      wep_chain = wep_chain.w_slot;
    }
    
    //pay cost for sprinting
    if( self.stat_plr_stt == PLAYER_SPRINT_ON){
      if( self.en_cur > 0){
        self.en_cur = self.en_cur - (self.en_rate - self.m_maccel);
      }
    }
    
    //REPAIR BAY
    self.repair_request = FALSE;
    if(self.repair_request){
      if(util_getMechHpAverage(self) == 1){
        self.repair_request = FALSE;
      }
    }
  }
  
	if( self.impulse ){
		ImpulseCommands ();
  }
    
  ButtonCommands();
  
  //DEBUG / DEV ONLY!
  local vector v;
  if(cvar("mechdev") == TRUE){
    if(self.button0){
      makevectors(self.v_angle);
      traceline(self.origin, self.origin + (v_forward * 10000), TRUE, self);
      self.c_ofs = trace_endpos;
      te_beam_esr(self.origin + (v_up * -4), trace_endpos);
    }
    self.stat_cofs_x = self.origin_x;
    self.stat_cofs_y = self.origin_y;
    self.stat_cofs_z = self.origin_z;
    self.stat_plr_ang_x = trace_endpos_x;
    self.stat_plr_ang_y = trace_endpos_y;
    self.stat_plr_ang_z = trace_endpos_z;
  }
  
  //========================================  

// check for attack
  playerAttack();
  
  client_push_player_info();
 
// check to see if player landed and play landing sound	
	/*if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		//if (self.watertype == CONTENT_WATER)
			//sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		//else
    if (self.jump_flag < -650)
		{
			//T_Damage (self, world, world, 5); 
			//sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			//sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;
  */
  
  if(self.data_type == DATA_MECH){
    self.stat_plr_camx = self.e_cam.c_ofs_x;
    self.stat_plr_camy = self.e_cam.c_ofs_y; 
    self.stat_plr_camz = self.e_cam.c_ofs_z;
  }
};


void() PlayerDie={
  //local float f;
	if (self.deadflag)
	{
		bprint("warning: PlayerDie called twice\n");
		return;
	}
  
  //legacy stuff
  legacy_PlayerDie();

	self.effects = 0;
  
	self.view_ofs = '0 0 1';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_CORPSE;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	
  if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;
  
	self.angles_x = 0;
	self.angles_z = 0;
  self.avelocity = '0 0 0';
  if(self.data_type != DATA_POBS){
    mech_clearWeaponGroups();
    if(self.data_type == DATA_MECH){
      mech_player_die();
    }
  }
};

void() PlayerDead={
	self.nextthink = -1;
	self.deadflag = DEAD_DEAD;
  self.data_type = DATA_POBS;
};

void() PlayerDeathThink={
	local float		forward;
	if ((self.flags & FL_ONGROUND)){
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
  }

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD){
		if (self.button2 || self.button0 || self.button3 || self.button4 || self.button5 || self.button6 || self.button7)
			return;
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
  mech_cleanupMech();
  player_makeObserver();
  spawnpoint_select();
  self.movetype = MOVETYPE_FLY;
  self.flags = self.flags | FL_FLY;
  respawn();
};

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