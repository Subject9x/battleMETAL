/*
battleMETAL 
Author: Peter Roohr

  Client qc
  I split the client and player code up because 
  there isn't really a reason both need to be in the same file
  and having to modifiy a 1k line file is a pain in the rear
  
*/


/*
  very important; parse every client call starting with 'cmd'
*/
void(string str) SV_ParseClientCommand={
  local float argc;
  argc = tokenize(str);
  if(argv(0) == "mech"){
    client_ParseMechCommand(str, argc);
  }
  else if( argv(0) == "savegame"){
    savefile_save();
  }
  else if( argv(0) == "loadgame"){
    savefile_load();
  }
  else{
    clientcommand(self, str);
  }
};

/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect = {
  
  bprint(self.netname);
  bprint(" has deployed to the combat zone\n");
  self.weaponmodel = "";
  self.viewzoom = 1;
  self.nextVecChoice = 0;
  self.vec_size = 0;
  self.data_idx = 0;
  self.data_type = DATA_POBS;
  self.currentWeaponGroup = self.currentWeaponGroup;
  self.faction = FACTION_PSC; //default
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
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
  self.w_group4 = 0;
  self.w_group5 = 0;
  self.state_1 = 0;
  self.state_2 = 0;
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  
  self.stat_trg_dataidx = -1;
  self.stat_trg_sh = -1;
  self.stat_trg_ddflg = -1;
  self.stat_trg_dist = -1;
  self.stat_trg_face = -1;
  self.stat_trg_faction = -1;
  
  self.radar_range = 0;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.w_proj = 0; //used to track enemy hit time
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  self.stat_rdr_rng = 0;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  
  self.next_wepn1 = -1;
  self.next_wepn2 = -1;
  self.next_wepn3 = -1;
  self.next_wepn4 = -1;
  self.next_wepn5 = -1;
  self.next_wepn6 = -1;
  self.next_wepn7 = -1;
  self.next_wepn8 = -1;
  self.next_wepn9 = -1;
  self.repair_request = 0;
  self.stat_plr_stt = PLAYER_CONNECT;
  self.i_reserve = world.i_reserve;
  self.enemy = world; //explicit assignment here
  
  self.stat_plr_rep = -1;
  
  client_playTrack(6, TRUE);  //entering hangar menu
  
  CLIENTS = CLIENTS + 1;  //book keeping for multiplayer
  self.client_num = CLIENTS;  //book keeping for multiplayer
  self.stat_plr_stt = PLAYER_SPAWN;
  
  client_push_player_info();
  
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
  local float gamemode;
  local entity spot;
  
  self.flags = FL_CLIENT;
  self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.effects = 0;
  
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  //DecodeLevelParms ();
	self.attack_finished = time;
	self.th_die = PlayerDie;
  self.deadflag = DEAD_NO;
  
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
  self.view_ofs = '0 0 1';
  
  if( !cvar("developer") ){
    if( coop ){
      spot = spawnpoint_coop();
    }
  }

  spot  = SelectSpawnPoint();
  
  self.faction = spot.faction;
  if( self.faction < 1 ){
    self.faction = FACTION_PSC;  //default to 1 to satisfy game code
  }
	self.origin = self.oldorigin = spot.origin + '0 0 1';	// 1998-07-21 Respawning where player died fix by Robert Field
  self.angles = spot.angles;
  
  gamemode = cvar("gamemode");
  
  client_sendMissionFileName();
  client_sendGameMode(gamemode);

  switch(gamemode){
    case GAMEMODE_CAMPAIGN:
      if(world.model == "maps/start.bsp"){
        //pre-populate default save file
        savefile_default();
      }
      savefile_load();
      break;
    case GAMEMODE_COOP:
      mapfile_coop_load();
      break;
    case GAMEMODE_DM:
      mapfile_pvp_load(self.faction);
      break;
  }

  
  if(self.data_type == DATA_POBS){
    player_makeObserver();
    
    client_push_mapobjects();
    client_sendAvailableLightMechs(SAVE_MECHS_LIGHT);
    client_sendAvailableMediumMechs(SAVE_MECHS_MEDIM);
    client_sendAvailableHeavyMechs(SAVE_MECHS_HEAVY);
    client_sendAvailableItems(SAVE_ITEMS_ALL);
    client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);
    
    if(!coop && !deathmatch){
      self.movetype = MOVETYPE_NONE;
      self.flags = self.flags - (self.flags & FL_FLY);
      client_update_moveSpeed(0, 0, 0, "0","0");
      client_update_viewBob("0", "0", "0");
      client_update_modelBob("0", "0", "0");
      self.stat_plr_stt = PLAYER_IN_MENU;
    }
    else{
      self.stat_plr_stt = PLAYER_ACTIVE;
    }
    self.power_timer = 0;
  }
  else if(self.data_type == DATA_MECH){
    self.trigOnSpawn = spot.trigOnSpawn;
    self.trigOnDeath = spot.trigOnDeath;
    self.trigOnAttack = spot.trigOnAttack;
    self.trigOnDamage = spot.trigOnDamage;
    self.trigOnPanic = spot.trigOnPanic;
    self.trigOnTarget = spot.trigOnTarget;
    player_makeMech();
    self.count4 = 0;
  }

  if (deathmatch || coop)
	{
		makevectors(self.angles);
	}
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
  
  if ( (intermission_running) && ( (coop) || (deathmatch) ) )  // not allowed during intermission
		return;

  //if player is an observer and their next class is still observer
  //don't let them suicide
  if(self.data_type == DATA_POBS){
    return;
  }
  
  bprint (self.netname);
  if(self.data_type != DATA_POBS){
    	bprint (" cowardly ejects!\n");
  }

  if(self.data_type == DATA_MECH){
    self.data_type = DATA_POBS;
    //self.frame = $ctorstand1;
    mech_clearWeaponGroups();
    local entity wep;
    wep = self.w_slot;
    while(wep){
      ctrl_weapon_clearState(wep, wep.state_1, wep.state_2);
      wep = wep.w_slot;
    }
    mech_cleanupMech();
  }
  self.solid = SOLID_CORPSE;
  self.alpha = 0;
  setsize(self, '-3 -3 -3', '3 3 3');
  self.movetype = MOVETYPE_TOSS;
  self.deadflag = DEAD_DEAD;
  self.nextthink = -1;
  //only deduct frags of player is going from !observer to another !observer
  if(self.data_type != DATA_POBS){
    self.frags = self.frags - 2;
  }
	respawn ();
};

/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect = {
  if(gameover){
    return;
  }
  bprint (self.netname);
	bprint (" has fled the field of battle!\n");

  if(self.data_type == DATA_MECH){
    mech_player_die();
    player_unmakeMech();
    mech_cleanupMech();
  }
  //update client numbers
  CLIENTS = CLIENTS - 1;
  local entity client;
  client = findchainflags(flags, FL_CLIENT);
  while(client){
    local float clnum;
    clnum = client.client_num;
    if(clnum > self.client_num){
      client.client_num = client.client_num - 1;
    }
    client = client.chain;
  }
};

