/*
  Client qc
  I split the client and player code up because 
  there isn't realy a reason both need to be in the same file
  and having to modifiy a 1k line file is a pain in the rear
*/
/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect = {
  
  bprint(self.netname);
  bprint(" has deployed to the combat zone\n");
  
  self.p_class = P_OBS;
  self.p_class_next = P_OBS;
  self.nextVecChoice = 0;
  self.data_idx = 0;
  self.currentWeaponGroup = 1;
  self.stat_eid = num_for_edict(self);
  //energy / shield stats
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  self.stat_legs_hp = 0;
  self.stat_legs_am = 0;
  self.stat_ctor_hp = 0;
  self.stat_ctor_am = 0;
  self.stat_ltor_hp = 0;
  self.stat_ltor_am = 0;
  self.stat_rtor_hp = 0;
  self.stat_rtor_am = 0;
  self.stat_larm_hp = 0;
  self.stat_larm_am = 0;
  self.stat_rarm_hp = 0;
  self.stat_rarm_am = 0;
  
  if (intermission_running){
    ExitIntermission();
  }
};

/*
===========
PutClientInServer

responsible for configuring the player and spawning them into the level
============
*/
void() PutClientInServer = {
  local entity spot;
  
  self.flags = FL_CLIENT;
  self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
  
  spot  = SelectSpawnPoint();
  
	self.origin = self.oldorigin = spot.origin + '0 0 24';	// 1998-07-21 Respawning where player died fix by Robert Field
  self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  DecodeLevelParms ();
	
	//W_SetCurrentAmmo ();

	self.attack_finished = time;
	//self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;

// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

// oh, this is a hack!
	//setmodel (self, "progs/eyes.mdl");
	//modelindex_eyes = self.modelindex;

	//setmodel (self, "progs/player.mdl");
	//modelindex_player = self.modelindex;

	//setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 1';
	
  if(self.p_class == P_OBS){
    mh_makeObserver(self);
  }
  else if(self.p_class == P_MECH){
    mh_makeMech(self);
    //self.SENDDATA = TRUE;
    csqc_SendMechData(self, ENT_PLR, FLAG_INI_MCH);//FLAG_INI_MCH);
  }
  

	//player_stand1 ();
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		//spawn_tfog (self.origin + v_forward*20);
	}

	//spawn_tdeath (self.origin, self);
};

/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill = {

  if(self.deadflag){
    return;
  }
  
  if ((intermission_running)&&((coop)||(deathmatch)))  // not allowed during intermission
		return;

  //if player is an observer and their next class is still observer
  //don't let them suicide
  if(self.p_class == P_OBS){
    if(self.p_class_next == P_OBS){
      return;
    }
  }
  
  bprint (self.netname);
	bprint (" cowardly ejects!\n");

  if(self.p_class == P_MECH){
    mech_player_die();
    cleanup_mech();
  }
  self.frame = $ctorstand1;
	self.solid = SOLID_CORPSE;
  setsize(self, '-3 -3 -3', '3 3 3');
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
  self.nextthink = -1;

  //only deduct frags of player is going from !observer to another !observer
  if(self.p_class != P_OBS){
    if(self.p_class_next != P_OBS){
      self.frags = self.frags - 2;
    }
  }
  
  self.p_class = self.p_class_next;
  
	respawn ();
};

/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect = {
  local entity oself;
  oself = self;
  //q1 func
  if(gameover){
    return;
  }
  bprint (self.netname);
	bprint (" has fled the field of battle!\n");
	//bprint (ftos(self.frags));
	//bprint (" frags\n");
  
  if(self.p_class == P_MECH){
    mech_player_die();
    cleanup_mech();
  }
};

