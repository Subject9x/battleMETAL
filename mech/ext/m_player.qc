/*
  player qc
*/
void() PlayerPreThink = {
  local	float	mspeed, aspeed;
	local	float	r;
  local entity oself;

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}
  
	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale
    
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
  
  //
  server_updateTargetInfo();
  
  self.stat_hit_dirs = self.hitdir_buffer;
  
  if(self.hitdir_buffer & STAT_HIT_LF){
    self.hitdir_buffer = self.hitdir_buffer - STAT_HIT_LF;
    bprint(strcat("cleared buffer: ",ftos(self.hitdir_buffer), " \n"));
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
  local entity senda;
  local	float	mspeed, aspeed;
	local	float	r;
 
	if (self.view_ofs == '0 0 0'){
		return;		// intermission or finale
  }
    
	if (self.deadflag){
    return;
  }

// do weapon stuff

  //STAT UPDATE  
  if(self.p_class == P_MECH){
    self.stat_en = (self.en_cur / self.en_max)*100;
    self.stat_sh = (self.sh_cur / self.sh_max)*100;
    self.stat_legs_hp = csqc_updateCompStat(self.e_legs);
    self.stat_ctor_hp = csqc_updateCompStat(self);
    self.stat_ltor_hp = csqc_updateCompStat(self.e_tor_l);
    self.stat_rtor_hp = csqc_updateCompStat(self.e_tor_r);
    self.stat_larm_hp = csqc_updateCompStat(self.e_arm_l);
    self.stat_rarm_hp = csqc_updateCompStat(self.e_arm_r);
    ctrl_update_mechplayer();
  }
  
  local vector radar;
  radar = server_updateRadarInfo();
  self.radar_front = radar_x;
  self.radar_rear = radar_y;
  
  if(self.p_class != P_OBS){
    local entity wep_chain;
    wep_chain = self.w_slot;
    while(wep_chain){
      ctrl_weapon_think(wep_chain);
      wep_chain = wep_chain.w_slot;
    }
  }

	if (self.impulse)
		ImpulseCommands ();
    
// check for attack
	if (self.button0){
    playerAttack();
	}

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5); 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;
};


void() PlayerDie={
  local float f;
	if (self.deadflag)
	{
		bprint("warning: PlayerDie called twice\n");
		return;
	}
//	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.effects = 0;	// 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
  
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
  
  if(self.p_class == P_MECH){
    mech_player_die();
    return;
  }
};

void() PlayerDead={
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};


void() PlayerDeathThink={
  local entity	old_self;
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
  
	respawn();
};

void() PlayerJump={
  	local vector start, end;
	
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
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};