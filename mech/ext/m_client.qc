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
  
  self.p_class = P_MECH;
  self.p_class_next = P_MECH;
  self.nextVecChoice = 2;
  self.data_idx = 0;
  self.currentWeaponGroup = self.currentWeaponGroup;
  self.faction = 1;
  self.stat_eid = num_for_edict(self);
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
  self.stat_cofs_x = 0;
  self.stat_cofs_y = 0;
  self.stat_cofs_z = 0;
  self.stat_w1_id = -1;
  self.stat_w2_id = -1;
  self.stat_w3_id = -1;
  self.stat_w4_id = -1;
  self.stat_w5_id = -1;
  self.stat_w6_id = -1;
  self.stat_w7_id = -1;
  self.stat_w8_id = -1;
  self.stat_w9_id = -1;
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  
  self.stat_trg_vid = -1;
  self.stat_trg_sh = -1;
  self.stat_trg_am = -1;
  self.stat_trg_dat = -1;
  self.stat_trg_face = -1;
  
  self.radar_range = 800;
  self.radar_front = 0;
  self.radar_rear = 0;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  
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

	self.attack_finished = time;
	//self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;

// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	self.view_ofs = '0 0 1';
	
  if(self.p_class == P_OBS){
    mh_makeObserver(self);
  }
  else if(self.p_class == P_MECH){
    mh_makeMech(self);
  }
 
	if (deathmatch || coop)
	{
		makevectors(self.angles);
	}
  
  dummyConnect();
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
  if(self.p_class != P_OBS){
    	bprint (" cowardly ejects!\n");
  }else{
  
  }


  if(self.p_class == P_MECH){
    mech_player_die();
    
  }
  self.frame = $ctorstand1;
	self.solid = SOLID_CORPSE;
  setsize(self, '-3 -3 -3', '3 3 3');
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
  self.nextthink = -1;
  self.currentWeaponGroup = self.currentWeaponGroup - 
                              ((self.currentWeaponGroup & self.w_group1) |
                              (self.currentWeaponGroup & self.w_group2) | 
                              (self.currentWeaponGroup & self.w_group3));
  self.w_group1 = self.w_group1 - self.w_group1;
  self.w_group2 = self.w_group2 - self.w_group2;
  self.w_group3 = self.w_group2 - self.w_group3;
  local entity wep;
  wep = self.w_slot;
  while(wep){
    ctrl_weapon_clearState(wep, wep.state_1, wep.state_2);
    wep = wep.w_slot;
  }
  
  if(self.p_class == P_MECH){
    cleanup_mech();
  }

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
  
  if(self.p_class == P_MECH){
    mech_player_die();
    cleanup_mech();
  }
};

