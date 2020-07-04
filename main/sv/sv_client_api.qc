/*
Quake 1**
Author: iD software
Overview:

  Client.qc
  I split the client and player code up because 
  there isn't really a reason both need to be in the same file
  and having to modifiy a 1k line file is a pain in the rear.

** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/

/*
  very important; parse every client call starting with 'cmd'
*/
void(string str) SV_ParseClientCommand={
  local float argc;
  argc = tokenize(str);
  if(argv(0) == "m"){
    client_ParseMechCommand(str, argc);
  }
  else if( argv(0) == "loadgame"){
    savefile_load(FALSE);
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
  if( GAMETYPE == GAMEMODE_COOP ){
    bprint(self.netname);
    bprint(" has arrived to help!\n");
  }
  else if( GAMETYPE == GAMEMODE_DM ){
    bprint(self.netname);
    bprint(" has entered the combat zone.\n");
  }
  else if( GAMETYPE == GAMEMODE_TEAMDM ){
    bprint(" Unkown contact has entered the AO.\n");
  }
  if( MISSION_STATUS == MISSION_STATUS_READY ){
    MISSION_STATUS = MISSION_STATUS_ACTIVE;
  }
  
  self.weaponmodel = "";
  self.viewzoom = 1;
  self.nextVecChoice = 0;
  self.vec_size = 0;
  self.data_idx = 0;
  self.data_type = DATA_POBS;
  self.currentWeaponGroup = self.currentWeaponGroup;
  self.faction = FACTION_ALL; //default
  self.energy = 0;
  self.energyMax = 0;
  self.energyRate = 0;
  self.shield = 0;
  self.shieldMax = 0;
  self.shieldRate = 0;
  self.stat_client_energy = 0;
  self.stat_client_shield = 0;
  
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
  
  self.stat_w1_id = 0;
  self.stat_w2_id = 0;
  self.stat_w3_id = 0;
  self.stat_w4_id = 0;
  self.stat_w5_id = 0;
  self.stat_w6_id = 0;
  self.stat_w7_id = 0;
  self.stat_w8_id = 0;
  self.stat_w9_id = 0;
  
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.aState = 0;  //used to track selected weapon group WHEN player uses fire-single-group mode
  self.state_2 = 0; //unknown what this used to be 
  
  self.stat_trg_dataidx = -1;
  self.stat_target_shield = -1;
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

  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  
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
  self.playerState = PLAYER_CONNECT;  //so we can detect a first-connect state.
  self.i_reserve = world.i_reserve;
  self.enemy = world; //explicit assignment here
  self.stat_player_weapons_state = 0;
  self.stat_plr_rep = -1;
  self.stat_target_name = "";
  self.stat_target_orgx = 0;
  self.stat_target_orgy = 0;
  self.stat_target_orgz = 0;

  if( world.animaticOnly ) {
    client_playTrack(world.sounds, TRUE);  //play desired music for animatic
  }
  else{
    client_playTrack(3, TRUE);  //entering hangar menu
  }
  
  client_push_player_info();
  client_data();
  
  if (intermission_running){
    ExitIntermission();
  }
  client_sendServerInfo();
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_WATER | DPCONTENTS_SLIME | DPCONTENTS_LAVA | DPCONTENTS_SKY | DPCONTENTS_BODY | DPCONTENTS_PLAYERCLIP);
};

/*
===========
PutClientInServer

responsible for configuring the player and spawning them into the level.

note: This is also called after a player respawns too...

============
*/
void() PutClientInServer = {
  local entity spot;
  
  self.flags = FL_CLIENT;
  self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.effects = 0;
  
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  //DecodeLevelParms ();  //TODO - going to reactivate these soon.
	self.attack_finished = time;  
  self.deadflag = DEAD_NO;  //re-rack
  
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
  self.view_ofs = '0 0 1';

  sv_select_info_start();

  //GAME MODE BLOCK
  switch(GAMETYPE){
    case GAMEMODE_CAMPAIGN:
      PutClientInServer_Campaign();
      break;
    
    case GAMEMODE_COOP:
      PutClientInServer_Coop();
      break;
      
    case GAMEMODE_DM:
      PutClientInServer_Deathmatch();
      break;
     
    case GAMEMODE_TEAMDM:
      PutClientInServer_TeamDeathmatch();
      break;
  }
  //Client connected to a round that's ending.
  if( MISSION_STATUS > MISSION_STATUS_ACTIVE ){
    if( GAMETYPE != GAMEMODE_CAMPAIGN ){
      self.playerState = PLAYER_INTERMSN;
    }
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
  
  if ( (intermission_running) && ( GAMETYPE != GAMEMODE_CAMPAIGN ) )  // not allowed during intermission
		return;

  //if player is an observer and their next class is still observer
  //don't let them suicide
  if(self.data_type == DATA_POBS){
    return;
  }
  
  bprint (self.netname);
  bprint (" cowardly self-destructs!\n");
  
  self.frags = self.frags - 2;
  if( self.frags < 0 ){
    self.frags = 0;
  }
  
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_VELOCITY | SENDFLAG_TURRET);
  self.health = 0;
  self.th_die();
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
    ctrl_mech_die_player();
    player_unmakeMech();
    ctrl_unit_cleanup_player();
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
  remove(self.clientData);
};

//better to split these out for clarity
/*
  PutClientInServer_Campaign
    GAMEMODE_COOP
*/
void() PutClientInServer_Campaign={

  /*PutClientInServer Logic
    2) configure faction
    3) send eqipment selections
    4) config client th_ funcs
  */
  
  //handle one-time server connect functions.
  if( self.playerState == PLAYER_CONNECT ){
    client_sendMissionFileName();
    client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);     
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    self.faction = FACTION_PSC; //campaign default
    self.th_die = PlayerDie;
  }
  client_push_mapobjects(); //refreshes map object data for everyone
  
 if( world.model == "maps/o1m1.bsp"){
    //pre-populate default save file
    savefile_load( FALSE );
    if( FLAG_NEWGAME == TRUE ){
      savefile_load( FALSE );
    }
  }
  if( world.animaticOnly == FALSE ){
    if( world.itemOverrideFile != "" ){
      savefile_load( TRUE );
    }
    else{
      savefile_load( FALSE );
    }
  }
  
  self.movetype = MOVETYPE_NONE;
  self.flags = self.flags - (self.flags & FL_FLY);
  if( world.animaticOnly ){
    self.playerState = PLAYER_INTERMSN;
  }
  //if( cvar("developer") ){
  // self.playerState = PLAYER_ACTIVE;
  //}
};


/*
  PutClientInServer_Coop
    GAMEMODE_COOP
*/
void() PutClientInServer_Coop={
  /*PutClientInServer Logic
    2) configure faction
    3) send eqipment selections
    4) config client th_ funcs
  */
  
  //handle one-time server connect functions.
  if( self.playerState == PLAYER_CONNECT ){
    client_sendMissionFileName();
    client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);     
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    self.faction = FACTION_PSC; //campaign default
  }
  client_push_mapobjects(); //refreshes map object data for everyone

  self.th_die = PlayerDieNetwork;
  mapfile_coop_load();
  
  //if( cvar("developer") ){
  // self.playerState = PLAYER_ACTIVE;
  //}
};


/*
  PutClientInServer_Deathmatch
    GAMEMODE_COOP
    TEAMPLAY = FALSE
*/
void() PutClientInServer_Deathmatch={
  /*PutClientInServer Logic
    2) configure faction
    3) send eqipment selections
    4) config client th_ funcs
  */
  
  //handle one-time server connect functions.
  if( self.playerState == PLAYER_CONNECT ){
    client_sendMissionFileName();
    client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    self.faction = FACTION_ALL; //deathmatch has no real teams.

  }
  client_push_mapobjects(); //refreshes map object data for everyone
  self.th_die = PlayerDieNetwork;  
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_MOVE | SENDFLAG_TURRET | SENDFLAG_VELOCITY);
  
  //if( cvar("developer") ){
  // self.playerState = PLAYER_ACTIVE;
  //}
};


/*
  PutClientInServer_TeamDeathmatch
    GAMEMODE_COOP
    TEAMPLAY = TRUE
*/
void() PutClientInServer_TeamDeathmatch={
  /*PutClientInServer Logic
    2) configure faction
    3) send eqipment selections
    4) config client th_ funcs
  */
  
  //handle one-time server connect functions.
  if( self.playerState == PLAYER_CONNECT ){
    client_sendMissionFileName();
    client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);     
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    if( TEAM_SURVEST_TOTAL < 9 ){
      self.faction = FACTION_SURVEST;
      TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
    }
    else{
      self.faction = FACTION_MILITAR;
      TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
    }
  }
  client_push_mapobjects(); //refreshes map object data for everyone
  self.th_die = PlayerDieNetwork;
    
  //if( cvar("developer") ){
  // self.playerState = PLAYER_ACTIVE;
  //}
};

void() sv_client_respawn={ 
  if( GAMETYPE == GAMEMODE_COOP ){
		// get the spawn parms as they were at level start
		//setspawnparms (self);
    if(self.data_type == DATA_MECH ){
      player_makeObserver();
    }
    self.playerState = PLAYER_SPAWN;
		// respawn		
		PutClientInServer ();
    return;
	}
	if ( GAMETYPE == GAMEMODE_DM || GAMETYPE == GAMEMODE_TEAMDM ){
		// set default spawn parms
		//SetNewParms ();
    if(self.data_type == DATA_MECH ){
      player_makeObserver();
    }
    self.playerState = PLAYER_SPAWN;
		// respawn		
		PutClientInServer ();
    return;
  }
  
  // restart the entire server
  localcmd ("restart\n");
};

void() sv_client_spawnpoint_select={
  local entity spot;

  if(self.goalentity){
    if( coop ){
      spot = spawnpoint_coop();
    }
    else{
      spot = self.goalentity;
    }
  }
  else{
    spot = SelectSpawnPoint();
  }
  
  //remote deploy point functionality
  if( spot.classname == "map_deploy_point_remote" ){
    self.origin = self.oldorigin = spot.view_ofs + '0 0 12';
  }
  else{
    self.origin = self.oldorigin = spot.origin + '0 0 12';
  }
  
  self.angles = spot.angles;
  
  //haha, cache angles for powerup sequence.
  self.wind_x = 0;
  self.wind_y = self.angles_y;
  self.wind_z = self.angles_z;
  
	self.fixangle = TRUE;
  self.trigOnSpawn = spot.trigOnSpawn;
  self.trigOnDeath = spot.trigOnDeath;
  self.trigOnAttack = spot.trigOnAttack;
  self.trigOnDamage = spot.trigOnDamage;
  self.trigOnPanic = spot.trigOnPanic;
  self.trigOnTarget = spot.trigOnTarget;
};

/*
  Send Ent Fun
*/
void() client_data={
  local entity data;
  data = spawn();
  setmodel(data, "q3mdl/testball.md3");
  setsize(data, '-1 -1 -1', '1 1 1');
  setorigin(data, world.origin);
  data.owner = self;
  data.alpha = 0.01;
  data.scale = 0.01;
  data.effects = data.effects | EF_NODEPTHTEST;
  data.origin = world.origin;
  data.data_type = self.data_type;
  data.flags = self.flags;
  data.radar_range = self.radar_range;
  data.stat_rdr_mode = self.stat_rdr_mode;
  data.stat_client_shield = self.stat_client_shield;
  data.SendEntity = send_client_data;
  data.SendFlags = data.SendFlags | SENDFLAG_NEWENT;
  data.vec_size = self.vec_size;
  self.clientData = data;
};

/*
  Send ClientData SendEnt()
  cliet/network/receive_player.qc
*/
float( float isNew, float changeFlags ) send_client_data={
  local entity player;
  player = self.owner;
  self.view_ofs = player.origin;
  
  if( player.deadflag == DEAD_NO ){
    self.data_type = player.data_type;
    self.radar_range = player.radar_range;
    self.stat_rdr_mode = player.stat_rdr_mode;
    self.stat_client_shield = player.stat_client_shield;
    self.vec_size = player.vec_size;
    self.damageValue = player.damageValue;
    self.data_idx = player.data_idx; 
  }
  else{
    self.data_type = DATA_POBS;
    self.radar_range = 0;
    self.stat_rdr_mode = 0;
    self.stat_client_shield = 0;
    self.vec_size = 0;
    self.damageValue = 0;
    self.data_idx = 0; 
    self.w_group = 0;
  }
  WriteByte( MSG_ENTITY, SENDTYPE_PLAYER );
  WriteByte( MSG_ENTITY, changeFlags );
  WriteShort( MSG_ENTITY, self.owner.ping );
  
  /*
    EVENT - per-frame update
  */
  if( (changeFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.view_ofs_x );
    WriteCoord( MSG_ENTITY, self.view_ofs_y );
    WriteCoord( MSG_ENTITY, self.view_ofs_z );
    
    WriteLong( MSG_ENTITY, player.flags );
    WriteLong( MSG_ENTITY, self.radar_range );
    WriteByte( MSG_ENTITY, self.stat_rdr_mode );
    WriteShort( MSG_ENTITY, self.stat_client_shield );
    
    WriteAngle( MSG_ENTITY, player.v_angle_x);
    WriteAngle( MSG_ENTITY, player.v_angle_y);
    WriteAngle( MSG_ENTITY, player.v_angle_z);
  }
  
  /*
    EVENT - player target info change
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    WriteLong( MSG_ENTITY, num_for_edict(player.enemy) );
  }
  
  /*
    EVENT - player info change 
  */
  if( (changeFlags & SENDFLAG_TURRET) ){
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, player.faction );
    WriteByte( MSG_ENTITY, self.vec_size );
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  /*
    EVENT - pieces of player mech is blown off
  */
  if( (changeFlags & SENDFLAG_CRIT) ){
    WriteShort( MSG_ENTITY, self.damageValue );
  }
  /*
    EVENT - pieces of player mech are low on health and burning
  */
  if( (changeFlags & SENDFLAG_BURN) ){
    WriteByte( MSG_ENTITY, self.burnBits );
  }
  /*
    EVENT - DEAD
  */
  if( (changeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, player.deadflag );
    WriteByte( MSG_ENTITY, MISSION_STATUS );
  }
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(player) );
    WriteByte( MSG_ENTITY, self.data_type );
    WriteCoord( MSG_ENTITY, player.origin_x );
    WriteCoord( MSG_ENTITY, player.origin_y );
    WriteCoord( MSG_ENTITY, player.origin_z );
    WriteByte( MSG_ENTITY, player.faction );
    WriteLong( MSG_ENTITY, player.flags );
  }
  /*
    EVENT - second data rider used for non-critical stuff
  */
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    WriteByte( MSG_ENTITY, (player.particleCube == world));
  }
  return TRUE;
};
