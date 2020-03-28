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
  else if( argv(0) == "savegame"){
    if( world.ignoreSave == FALSE ){
      savefile_save();
    }
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
  self.playerState = PLAYER_CONNECT;
  self.i_reserve = world.i_reserve;
  self.enemy = world; //explicit assignment here
  self.stat_player_weapons_state = 0;
  self.stat_plr_rep = -1;
  self.stat_target_name = "";
  self.stat_target_orgx = 0;
  self.stat_target_orgy = 0;
  self.stat_target_orgz = 0;

  if( world.animaticOnly == FALSE) {
    client_playTrack(3, TRUE);  //entering hangar menu
  }
  else{
    client_playTrack(world.sounds, TRUE);  //entering hangar menu
  }
  
  self.playerState = PLAYER_SPAWN;
  client_push_player_info();
  client_data();
  
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
	self.effects = 0;
  
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  //DecodeLevelParms ();  //TODO - going to reactivate these soon.
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
  if( self.faction < 1 ){
    self.faction = FACTION_PSC;  //default to 1 to satisfy game code
  }
  else{
    self.faction = spot.faction;
  }
  
	self.origin = self.oldorigin = spot.origin + '0 0 1';	// 1998-07-21 Respawning where player died fix by Robert Field
  self.angles = spot.angles;
  
  if( GAMETYPE == GAMEMODE_CAMPAIGN ){
    client_sendMissionFileName();
    client_sendGameMode(cvar("gamemode"));
    if( world.model == "maps/o1m1.bsp"){
      //pre-populate default save file
      savefile_load( FALSE );
      if( FLAG_NEWGAME == TRUE ){
        savefile_default();
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
    
    client_sendAvailable_Mechs(SAVE_MECHS_LIST);
    client_sendAvailableItems(SAVE_ITEMS_ALL);
  }
  else if ( GAMETYPE == GAMEMODE_COOP ){
    //using client num as lazy connection-check
    if( self.client_num < 1 ){
      client_sendMissionFileName();
      client_sendGameMode(cvar("gamemode"));
    }
  
    self.th_die = PlayerDieNetwork;
    mapfile_coop_load();
  }
  else{
    self.th_die = PlayerDieNetwork;
    mapfile_pvp_load(self.faction);
  }

  switch( self.data_type ){
    case DATA_POBS:
      player_makeObserver();
      
      client_push_mapobjects();
      if( self.client_num < 1 ){
        client_sendFog(self, world.fog_density, world.fog_color, world.fog_alpha, world.fog_dist, world.fade);      
      }
      
      if( GAMETYPE == GAMEMODE_CAMPAIGN ){
        self.movetype = MOVETYPE_NONE;
        self.flags = self.flags - (self.flags & FL_FLY);
        if( world.animaticOnly ){
          self.playerState = PLAYER_INTERMSN;
        }
        else{
          self.playerState = PLAYER_IN_MENU;
        }
      }
      else{
        if( cvar("developer") ){
          self.playerState = PLAYER_ACTIVE;
        }
        else{
          self.playerState = PLAYER_IN_MENU;
        }
      }
      self.power_timer = 0;
      break;
    default:
      self.trigOnSpawn = spot.trigOnSpawn;
      self.trigOnDeath = spot.trigOnDeath;
      self.trigOnAttack = spot.trigOnAttack;
      self.trigOnDamage = spot.trigOnDamage;
      self.trigOnPanic = spot.trigOnPanic;
      self.trigOnTarget = spot.trigOnTarget;
      player_makeMech();
      self.count4 = 0;
      break;
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
    ctrl_unit_clean_wgroups();
    ctrl_unit_cleanup_player();
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
  self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TURRET;
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

/*
  Send Ent Fun
*/
void() client_data={
  local entity data;
  data = spawn();
  setmodel(data, "q3mdl/testball.md3");
  setsize(data, '-1 -1 -1', '1 1 1');
  setorigin(data, data.owner.origin);
  data.owner = self;
  data.effects = data.effects | EF_NODEPTHTEST;
  data.alpha = 0.01;
  data.scale = 0.01;
  data.origin = self.origin;
  data.data_type = self.data_type;
  data.faction = self.faction;
  data.flags = self.flags;
  data.radar_range = self.radar_range;
  data.stat_rdr_mode = self.stat_rdr_mode;
  data.stat_client_shield = self.stat_client_shield;
  data.exteriormodeltoclient = self;
  data.SendEntity = send_client_data;
  data.SendFlags = data.SendFlags | SENDFLAG_NEWENT;
  data.vec_size = self.vec_size;
  self.clientData = data;
};

float( float isNew, float changeFlags ) send_client_data={
  local entity player;
  player = self.owner;
  
  self.origin = player.origin;
  self.data_type = player.data_type;
  self.faction = player.faction;
  self.radar_range = player.radar_range;
  self.stat_rdr_mode = player.stat_rdr_mode;
  self.stat_client_shield = player.stat_client_shield;
  self.vec_size = player.vec_size;
  self.damageValue = player.damageValue;
  self.data_idx = player.data_idx;
  
  WriteByte( MSG_ENTITY, SENDTYPE_PLAYER );
  WriteByte( MSG_ENTITY, changeFlags );
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteLong( MSG_ENTITY, player.flags);
    WriteByte( MSG_ENTITY, self.faction);
    WriteByte( MSG_ENTITY, self.radar_range);
    WriteByte( MSG_ENTITY, self.stat_rdr_mode);
    WriteByte( MSG_ENTITY, self.stat_client_shield);
    WriteAngle( MSG_ENTITY, player.v_angle_x);
    WriteAngle( MSG_ENTITY, player.v_angle_y);
    WriteAngle( MSG_ENTITY, player.v_angle_z);
    WriteByte( MSG_ENTITY, num_for_edict(player.enemy) );
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.faction);
    WriteByte( MSG_ENTITY, self.vec_size);
    WriteByte( MSG_ENTITY, self.data_idx);
  }
  
  if( (changeFlags & SENDFLAG_CRIT) ){
    WriteShort( MSG_ENTITY, self.damageValue );
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    WriteByte( MSG_ENTITY, self.w_group );
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, player.deadflag );
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, num_for_edict(player));
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.vec_size );
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteLong( MSG_ENTITY, self.flags);
    WriteByte( MSG_ENTITY, self.faction);
    WriteByte( MSG_ENTITY, self.radar_range);
    WriteByte( MSG_ENTITY, self.stat_rdr_mode);
    WriteByte( MSG_ENTITY, self.stat_client_shield);
    WriteString( MSG_ENTITY, player.netname );
  }
  
  return TRUE;
};
