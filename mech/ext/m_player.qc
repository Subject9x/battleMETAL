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
  
  if(self.p_class != P_OBS){
    //power up sequence
    if(time < self.power_timer){
      self.movetype = MOVETYPE_NONE;
      return;
    }
    else{
      self.power_timer = -2;
    }
    if(self.power_timer == -2){
      self.movetype = MOVETYPE_WALK;
      self.power_timer = -1;
      self.stat_plr_stt = PLAYER_IDLE;
    }
    
    server_updateTargetInfo();
    if(time >= self.was_hit){
      self.stat_hit_dirs =  self.stat_hit_dirs - (self.stat_hit_dirs & STAT_HIT_LF);
      self.stat_hit_dirs =  self.stat_hit_dirs - (self.stat_hit_dirs & STAT_HIT_RT);
      self.stat_hit_dirs =  self.stat_hit_dirs - (self.stat_hit_dirs & STAT_HIT_BK);
    }
    else{
      self.stat_hit_dirs =  self.hitdir_buffer;
    }
  }
  
	if (self.button2){
		PlayerJump();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';    
};

void() PlayerPostThink = {
 
  if(self.ui_box_time > 0){
    self.ui_box_time  = self.ui_box_time - 1;
  }
 
	if (self.view_ofs == '0 0 0'){
		return;		// intermission or finale
  }
    
	if (self.deadflag >= DEAD_DYING){
    return;
  }
  
  if(self.p_class != P_OBS){
    if(time < self.power_timer){
      return;
    }
  }
  
// do weapon stuff
  self.stat_plr_ang = anglemod(self.v_angle_y);
  //STAT UPDATE   
  if(self.p_class == P_MECH){
    makevectors(self.v_angle);
    traceline(self.origin, self.origin + (v_forward * 5000), FALSE,self);
    self.stat_ret_dist = 5000 * trace_fraction;
    self.stat_plr_camx = self.e_cam.c_ofs_x;
    self.stat_plr_camy = self.e_cam.c_ofs_y; 
    self.stat_plr_camz = self.e_cam.c_ofs_z;
    self.stat_en = (self.en_cur / self.en_max)*100;
    self.stat_sh = (self.sh_cur / self.sh_max)*100;
    self.stat_legs_hp = csqc_updateCompStat(self.e_legs);
    self.stat_ctor_hp = csqc_updateCompStat(self);
    self.stat_ltor_hp = csqc_updateCompStat(self.e_tor_l);
    self.stat_rtor_hp = csqc_updateCompStat(self.e_tor_r);
    self.stat_larm_hp = csqc_updateCompStat(self.e_arm_l);
    self.stat_rarm_hp = csqc_updateCompStat(self.e_arm_r);
    if((self.stat_lck_stt & LOCK_TARG)){
      if(!(self.enemy.stat_lck_stt & LOCK_PLYR)){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt | LOCK_PLYR;
      }
    }
    client_updateWeaponReloads();
    ctrl_update_mechplayer();
    local vector radar;
    radar = server_updateRadarInfo();
  }

  self.stat_plr_ptc = self.v_angle_x;
    
  if(self.p_class != P_OBS){
    local entity wep_chain;
    wep_chain = self.w_slot;
    while(wep_chain){
      ctrl_wpn_think(wep_chain);
      wep_chain = wep_chain.w_slot;
    }
  }

	if(self.impulse){
		ImpulseCommands ();
  }
// check for attack
  playerAttack();
	/*if (self.button0){
    playerAttack();
	}*/

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
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
    
  if(self.p_class == P_MECH){
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
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	
  if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;
  
	self.angles_x = 0;
	self.angles_z = 0;
  self.avelocity = '0 0 0';
  
  if(self.p_class != P_OBS){
    mech_clearWeaponGroups();
    if(self.p_class == P_MECH){
      self.p_class = P_OBS; //edge case spot-welding
      mech_player_die();
      return;
    }
  }
};

void() PlayerDead={
	self.nextthink = -1;
	self.deadflag = DEAD_DEAD;
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
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	
  self.deadflag = DEAD_NO;
  player_unmakeMech();
  player_makeObserver();
  spawnpoint_Random();
  self.movetype = MOVETYPE_FLY;
  self.flags = self.flags | FL_FLY;
  
  //respawn();
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