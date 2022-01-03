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
  local float cmdIdx;
  local string cmdCall;
  local entity trigTarg;
  local entity notTrig;
  local string response;
  
  cmdIdx = strstrofs(str, " ", 0);
  cmdCall = substring( str, 0, cmdIdx );
  
  //Client info string handle
  if( cmdCall == CMD_CLIENT_INFO ){
    client_parse_clientInfoString(str);
    return;
  }
  //Client Chat stuff
  if( cmdCall == CS_PRINT ){
    if( strstrofs(str, SAY_MSG1, 0) != -1 ){
      cmdIdx = strstrofs(str, SAY_MSG1, cmdIdx) + strlen(SAY_MSG1);
      WriteChar(MSG_ALL, SVC_PRINT);
      response = infoadd(response, RSP_SRC, SV_PRINT);
      response = infoadd(response, RSP_TYPE, SAY_MSG1);
      response = infoadd(response, RSP_CID, ftos(num_for_edict(self) ));
      response = infoadd(response, RSP_BODY, substring(str, cmdIdx, strlen(str)-cmdIdx));
      WriteString(MSG_ALL, strcat(response, "\n"));
    }
    else if( strstrofs(str, SAY_MSG2,0)  != -1 ){
      cmdIdx = strstrofs(str, SAY_MSG2, cmdIdx) + strlen(SAY_MSG2);
      WriteChar(MSG_ALL, SVC_PRINT);
      response = infoadd(response, RSP_SRC, SV_PRINT);
      response = infoadd(response, RSP_TYPE, SAY_MSG2);
      response = infoadd(response, RSP_CID, ftos(num_for_edict(self) ));
      response = infoadd(response, RSP_BODY, substring(str, cmdIdx, strlen(str)-cmdIdx));
      WriteString(MSG_ALL, strcat(response, "\n"));
    }
    return;
  }
  //SetNextMission--------------------
  if(cmdCall == "nextmission"){
    argc = tokenize(str);
    client_setMission(str, argc);
    return;
  }
  //Exit Animatic--------------
  if( cmdCall == "exitanim" ){
    self.count2 = 0;
    self.velocity = '0 0 0';
    self.avelocity = '0 0 0';
    if( self.animId != world ){
      if( self.animId.target != "" ){
        trigTarg = find(world, targetname, self.animId.target );
        if( trigTarg ){
          if( trigTarg.use ){
            notTrig = self;
            self = trigTarg;
              trigTarg.use();
            self = notTrig;
          }
        }
      }
    }
    return;
  }
  if( cmdCall == "setmode" ){
    argc = tokenize(str);
    cvar_set("gamemode", argv(1) );
    return;
  }
  
  if( cmdCall == "rtexport" ){
    argc = tokenize(str);
    world_export_realtimelights( stof(argv(1)) );
    return;
  }
  if( cmdCall == "nodexprt" ){
    argc = tokenize(str);
    world_nodegraph_export_data( stof(argv(1)) );
    return;
  }
  if( cmdCall == "dbgnode" ){
    argc = tokenize(str);
    world_nodegraph_test_graph( stof(argv(1)), stof(argv(2)) );
    return;
  }
  if( cmdCall == "dbgedge" ){
    argc = tokenize(str);
    nodegraph_debug_edges(  stof(argv(1)) );
    return;
  }
  if( cmdCall == "dbgtarg" ){
    argc = tokenize(str);
    world_debug_targ( argv(1) );
    return;
  }
  clientcommand(self, str);
};

/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect = {
  local string response;
  if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
    WriteChar(MSG_ALL, SVC_PRINT);
    response = infoadd(response, RSP_SRC, SV_PRINT);
    response = infoadd(response, RSP_TYPE, SV_CL_CONN);
    response = infoadd(response, RSP_BODY, strcat(self.netname, " has arrived to help!"));
    WriteString(MSG_ALL, strcat(response, "\n"));
  }
  else {
    WriteChar(MSG_ALL, SVC_PRINT);
    response = infoadd(response, RSP_SRC, SV_PRINT);
    response = infoadd(response, RSP_TYPE, SV_CL_CONN);
    response = infoadd(response, RSP_BODY, strcat(self.netname, " has entered the combat zone."));
    WriteString(MSG_ALL, strcat(response, "\n"));
  }
  
  
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_READY ){
    ENT_SERVER_INFO.missionStatus = MISSION_STATUS_ACTIVE;
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
  }
  self.entnum = num_for_edict(self);
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
  
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  
  self.statWeaponReload1 = 0;
  self.statWeaponReload2 = 0;
  self.statWeaponReload3 = 0;
  self.statWeaponReload4 = 0;
  self.statWeaponReload5 = 0;
  self.statWeaponReload6 = 0;
  self.statWeaponReload7 = 0;
  self.statWeaponReload8 = 0;
  self.statWeaponReload9 = 0;
  
  self.aState = 0;  //used to track selected weapon group WHEN player uses fire-single-group mode
  
  self.stat_trg_dataidx = -1;
  self.stat_target_shield = -1;
  self.stat_trg_ddflg = -1;
  self.stat_trg_dist = -1;
  self.stat_trg_faction = -1;
  
  self.radar_range = 0;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.w_proj = 0; //used to track enemy hit time
  self.statTargetHitParts = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  self.stat_rdr_rng = 0;

  self.spreadDefault = '0 0 0';
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.targLockState = LOCK_NONE;
  
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
  self.stat_plr_rep = -1;
  self.stat_target_name = "";
  
  self.clientcolors = FACTION_PSC;  //faction tracker for network.
  
  self.attackFlag = 0;
  client_data();
  
  if( world.animaticOnly ) {
    client_playTrack(self, world.sounds, TRUE);  //play desired music for animatic
    if( world.animaticOnly > 1){
      client_send_menu_flag( self, TRUE );
    }
  }
  else{
    client_playTrack(self, 3, TRUE);  //entering hangar menu
  }
  
  client_send_server_info_connect( self );
  client_sendMissionFileName();
  
  client_push_player_info();
  
  if (intermission_running){
    ExitIntermission();
  }
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_WATER | DPCONTENTS_SLIME | DPCONTENTS_LAVA | DPCONTENTS_SKY | DPCONTENTS_BODY | DPCONTENTS_PLAYERCLIP);
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_NEWENT;
};

/*
===========
PutClientInServer

responsible for configuring the player and spawning them into the level.

note: This is also called after a player respawns too...

============
*/
void() PutClientInServer = {
  
  self.flags = FL_CLIENT;
  self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.effects = 0;
  self.health = 100;
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  //DecodeLevelParms ();  //TODO - going to reactivate these soon.
	self.attack_finished = time;  
  self.deadflag = DEAD_NO;  //re-rack
  
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
  self.view_ofs = '0 0 1';
  
  sv_select_info_start();
  client_sendFog(self, TRUE, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);
  
  //GAME MODE BLOCK
  switch(ENT_SERVER_INFO.gameType){
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
  if( ENT_SERVER_INFO.missionStatus > MISSION_STATUS_ACTIVE ){
    if( ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN ){
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
  
  if ( (intermission_running) && ( ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN ) )  // not allowed during intermission
		return;

  //if player is an observer and their next class is still observer
  //don't let them suicide
  if(self.data_type == DATA_POBS){
    return;
  }
  local string response;
  WriteChar(MSG_ALL, SVC_PRINT);
  response = infoadd(response, RSP_SRC, SV_PRINT);
  response = infoadd(response, RSP_TYPE, SV_CL_KSELF);
  response = infoadd(response, RSP_BODY, strcat(self.netname, " cowardly self-destructs!"));
  WriteString(MSG_ALL, strcat(response, "\n"));
  
  self.frags = self.frags - 2;
  if( self.frags < 0 ){
    self.frags = 0;
  }
  
  self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS ;
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
  local entity client;
  local float clnum;
  local string response;
  
  if(gameover){
    return;
  }
  
  WriteChar(MSG_ALL, SVC_PRINT);
  response = infoadd(response, RSP_SRC, SV_PRINT);
  response = infoadd(response, RSP_TYPE, SV_CL_DSCON);
  response = infoadd(response, RSP_BODY, strcat(self.netname, " has fled the field of battle!"));
  WriteString(MSG_ALL, strcat(response, "\n"));
  
  if(self.data_type == DATA_MECH){
    ctrl_mech_die_player();
    player_unmakeMech();
    ctrl_unit_cleanup_player();
  }
  //update client numbers
  CLIENTS = CLIENTS - 1;
  client = findchainflags(flags, FL_CLIENT);
  while(client){
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
    self.power_timer = 0;
    player_makeObserver();
    if(world.animaticOnly > 1){
      self.playerState = PLAYER_MENU;
    }
    else{
      self.playerState = PLAYER_SPAWN;
    }
    
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
    savefile_load( world.itemOverride );
  }
  
  self.movetype = MOVETYPE_NONE;
  self.flags = self.flags - (self.flags & FL_FLY);
  if( world.animaticOnly ){
    self.playerState = PLAYER_INTERMSN;
    if(self.clientData != world ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS;
    }
  }
  
  if( world.iniConfig ){
    self.playerState = PLAYER_SPAWN;
    client_sendIniConfig();
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
    self.power_timer = 0;
    player_makeObserver();
    if(world.animaticOnly > 1){
      self.playerState = PLAYER_MENU;
    }
    else{
      self.playerState = PLAYER_SPAWN;
    }
    self.faction = FACTION_PSC; //campaign default
    self.clientcolors = FACTION_PSC;
  }
  client_push_mapobjects(); //refreshes map object data for everyone

  self.th_die = PlayerDieNetwork;
  mapfile_coop_load();
  
  self.movetype = MOVETYPE_NONE;
  self.flags = self.flags - (self.flags & FL_FLY);
  if( world.animaticOnly ){
    self.playerState = PLAYER_INTERMSN;
    if(self.clientData != world ){
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS;
    }
  }
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
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    self.faction = FACTION_ALL; //deathmatch has no real teams
    self.clientcolors = FACTION_ALL;
  }
  client_push_mapobjects(); //refreshes map object data for everyone
  self.th_die = PlayerDieNetwork;  
  self.clientData.SendFlags = self.clientData.SendFlags | (SENDFLAG_MOVE | SENDFLAG_EFLAGS);
  
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
    self.power_timer = 0;
    player_makeObserver();
    self.playerState = PLAYER_SPAWN;
    if( TEAM_SURVEST_TOTAL <= 7 ){
      TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
      self.clientcolors = FACTION_SURVEST;
      self.faction = FACTION_SURVEST;
    }
    else{
      TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
      self.clientcolors = FACTION_MILITAR;
      self.faction = FACTION_MILITAR;
    }
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_FACTION;
  }
  client_push_mapobjects(); //refreshes map object data for everyone
  self.th_die = PlayerDieNetwork;
};

void() sv_client_respawn={
  
  if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
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
  if ( ENT_SERVER_INFO.gameType == GAMEMODE_DM || ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
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

  if( (serverflags & SVFLAG_SPAWNFAR) ){
    self.goalentity = spot = world_deathmatch_random_spawn();
  }

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


void() client_data_th={
  self.think = client_data_th;
  self.nextthink = time + 0.01;
};

/*
  Send Ent Fun
*/
void() client_data={
  local entity data;
  data = spawn();
  setmodel(data, "q3mdl/testball.md3");
  setsize(data, '-1 -1 -1', '1 1 1');
  setorigin(data, self.origin);
  data.owner = self;
  data.alpha = 0.01;
  data.scale = 0.01;
  data.effects = data.effects | EF_NODEPTHTEST;
  data.origin = self.origin;
  data.data_type = self.data_type;
  data.flags = self.flags;
  data.radar_range = self.radar_range;
  data.stat_rdr_mode = self.stat_rdr_mode;
  data.stat_client_shield = self.stat_client_shield;
  data.shieldHitFlag = self.shieldHitFlag;
  data.SendEntity = send_client_data;
  data.SendFlags = data.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_FACTION);
  data.vec_size = self.vec_size;
  data.think = client_data_th;
  data.nextthink = time + 0.01;
  self.clientData = data;
};

/*
  Send ClientData SendEnt()
  cliet/network/receive_player.qc
*/
float( float isNew, float changeFlags ) send_client_data={
  local entity player;
  local float prevType;
  local float sendCrit;
  
  player = self.owner;
  self.view_ofs = player.origin;
  
  prevType = self.data_type;
  
  sendCrit = 0;
  
  if( player.deadflag == DEAD_NO ){
    self.data_type = player.data_type;
    self.radar_range = player.radar_range;
    self.stat_rdr_mode = player.stat_rdr_mode;
    self.stat_client_shield = player.stat_client_shield;
    self.stat_client_energy = player.stat_client_energy;
    self.vec_size = player.vec_size;
    self.data_idx = player.data_idx;
    self.shieldHitFlag = player.shieldHitFlag;
  }
  else{
    self.data_type = DATA_POBS;
    self.radar_range = 0;
    self.stat_rdr_mode = player.stat_rdr_mode;
    self.stat_client_shield = 0;
    self.vec_size = 0;
    self.data_idx = 0;
    self.w_group = 0;
    self.shieldHitFlag = 0;
  }
  WriteByte( MSG_ENTITY, SENDTYPE_PLAYER );
  WriteCoord( MSG_ENTITY, changeFlags );
  //=============================================
  /*
    EVENT - per-frame update
  */
  if( (changeFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, player.origin_x );
    WriteCoord( MSG_ENTITY, player.origin_y );
    WriteCoord( MSG_ENTITY, player.origin_z );
    WriteByte( MSG_ENTITY, player.moveState );
    WriteShort( MSG_ENTITY, player.legs.angles_y);
    WriteShort( MSG_ENTITY, player.legs.ai_dir);
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, player.v_angle_x);
    WriteAngle( MSG_ENTITY, player.v_angle_y);
  }
  
  if( (changeFlags & SENDFLAG_RADAR) ){
    WriteByte( MSG_ENTITY, self.stat_rdr_mode );
  }
  if( (changeFlags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  if( (changeFlags & SENDFLAG_ENERGY) ){
    WriteByte( MSG_ENTITY, self.stat_client_energy );
  }
  if( (changeFlags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, player.attackFlag);
  }
  if( (changeFlags & SENDFLAG_CAMERA) ){
    WriteByte( MSG_ENTITY, player.chaseActive);
  }
  
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, num_for_edict(player) );
  }
    
  /*
    EVENT - Player takes hit to their shields.
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag); 
  }
  
  if( (changeFlags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, player.faction);
  }
  
  /*
    EVENT - player info change 
  */
  if( (changeFlags & SENDFLAG_NEWUNIT) ){
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, player.next_wepn1);
    WriteByte( MSG_ENTITY, player.next_wepn2);
    WriteByte( MSG_ENTITY, player.next_wepn3);
    WriteByte( MSG_ENTITY, player.next_wepn4);
    WriteByte( MSG_ENTITY, player.next_wepn5);
    WriteByte( MSG_ENTITY, player.next_wepn6);
    WriteByte( MSG_ENTITY, player.next_wepn7);
    WriteByte( MSG_ENTITY, player.next_wepn8);
    WriteByte( MSG_ENTITY, player.next_wepn9);
    WriteCoord( MSG_ENTITY, player.data_speed_forward);
    WriteCoord( MSG_ENTITY, player.data_speed_strafe);
    WriteCoord( MSG_ENTITY, player.data_speed_backward);
    WriteCoord( MSG_ENTITY, player.data_speed_accel);
  }
  
  if( (changeFlags & SENDFLAG_COLORS) ){
    WriteByte( MSG_ENTITY, player.unitColorCT );
    WriteByte( MSG_ENTITY, player.unitColorLT );
    WriteByte( MSG_ENTITY, player.unitColorRT );
    WriteByte( MSG_ENTITY, player.unitColorLA );
    WriteByte( MSG_ENTITY, player.unitColorRA );
    WriteByte( MSG_ENTITY, player.unitColorLG );
  }
  
  /*
    EVENT - pieces of player mech is blown off
  */
  if( (changeFlags & SENDFLAG_CRIT) ){
    //placed here for just-in-time calculation
    // because not all SendFlags might be sent exactly when called, and the code originally was clearing out critBits
    if( player.critBits != 0 ){
      sendCrit = player.critBits;
      if( (player.critBits & M_REPAIR) ){
        player.criticalHits = player.criticalHits - (player.criticalHits & player.critBits);
      }
      else{
        player.criticalHits = player.criticalHits | player.critBits;
      }
      player.critBits = 0;
    }
    WriteShort( MSG_ENTITY, sendCrit );
  }
  /*
    EVENT - pieces of player mech are low on health and burning
  */
  if( (changeFlags & SENDFLAG_BURN) ){
    WriteLong( MSG_ENTITY, player.burnBits );
  }
  /*
    EVENT - DEAD
  */
  if( (changeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, player.deadflag );
    WriteByte( MSG_ENTITY, ENT_SERVER_INFO.missionStatus );
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    //WriteCoord( MSG_ENTITY, player.velocity_x);
    //WriteCoord( MSG_ENTITY, player.velocity_y);
    //WriteCoord( MSG_ENTITY, player.velocity_z);
  }
  
  if( (changeFlags & SENDFLAG_EFLAGS) ){
    WriteCoord( MSG_ENTITY, player.flags );
  }
  
  if( (changeFlags & SENDFLAG_TARGET) ){
    WriteLong( MSG_ENTITY, player.targetEntId ); //->SENDFLAG_TARGET
  }
  
  self.shieldHitFlag = 0;
  return TRUE;
};
