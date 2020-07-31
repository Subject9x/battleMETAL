/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 9/11/2018 - rebuilt
Overview: client utility methods, pulled from client.qc
*/

/*
  primary info function set to CSQC. 
  This pushes client data to the owner, every PostPlayerThink() call.
*/
void() client_push_player_info={
  local entity wep;
  local float wepItr;
  local float targShield;
  local float myShield;
  
  self.ammo_rockets = self.flags;
  if(self.data_type == DATA_MECH){
    self.stat_client_energy = (self.energy / self.energyMax) * 100;
    
    if( time <= self.shieldHitRegen ) {
      myShield = self.shieldHitRegen - self.shieldHitRegenStart;
      myShield = (time - self.shieldHitRegenStart) / myShield;
      myShield =  -100 - (myShield * -100);
    }
    else{
      myShield = self.shield;
      if( myShield <= 0 ){
        myShield = 0;
      }
      else{
        myShield = (self.shield / self.shieldMax) * 100;
      }
    }
    self.stat_client_shield = myShield;
    
    self.stat_client_hp_torsoCenter = csqc_updateCompStat(self);
    self.stat_client_hp_torsoLeft = csqc_updateCompStat(self.torsoLeft);
    self.stat_client_hp_torsoRight = csqc_updateCompStat(self.torsoRight);
    self.stat_client_hp_armLeft = csqc_updateCompStat(self.armLeft);
    self.stat_client_hp_armRight = csqc_updateCompStat(self.armRight);
    self.stat_client_hp_legs = csqc_updateCompStat(self.legs);
    
    wepItr = 1;
    for( wep = self.w_slot; wep != world; wep = wep.w_slot){
      //why can't we iterate over entity fields again?
      switch(wepItr){
        case 1:
          self.stat_w1_rel = wep.reloadValue;
          break;
        case 2:
          self.stat_w2_rel = wep.reloadValue;
          break;
        case 3:
          self.stat_w3_rel = wep.reloadValue;
          break;
        case 4:
          self.stat_w4_rel = wep.reloadValue;
          break;
        case 5:
          self.stat_w5_rel = wep.reloadValue;
          break;
        case 6:
          self.stat_w6_rel = wep.reloadValue;
          break;
        case 7:
          self.stat_w7_rel = wep.reloadValue;
          break;
        case 8:
          self.stat_w8_rel = wep.reloadValue;
          break;
        case 9:
          self.stat_w9_rel = wep.reloadValue;
          break;
      }
      wepItr = wepItr + 1;
    }
    
    if( self.stat_trg_ent_id != 0 ){
      //this is silly but precludes forcing the csqc to know the target's max shields
      if( time <= self.enemy.shieldHitRegen ) {
        targShield = self.enemy.shieldHitRegen - self.enemy.shieldHitRegenStart;
        targShield = (time - self.enemy.shieldHitRegenStart) / targShield;
        targShield =  -100 - (targShield * -100);
      }
      else{
        targShield = self.enemy.shield;
        if( targShield <= 0 ){
          targShield = 0;
        }
        else{
          targShield = (self.enemy.shield / self.enemy.shieldMax) * 100;
        }
      }
      
      self.stat_target_shield = targShield;
      self.stat_target_hp_torsoCenter = csqc_updateCompStat(self.enemy);
      self.stat_target_hp_torsoLeft = csqc_updateCompStat(self.enemy.torsoLeft);
      self.stat_target_hp_torsoRight = csqc_updateCompStat(self.enemy.torsoRight);
      self.stat_target_hp_armLeft = csqc_updateCompStat(self.enemy.armLeft);
      self.stat_target_hp_armRight = csqc_updateCompStat(self.enemy.armRight);
      self.stat_target_hp_legs = csqc_updateCompStat(self.enemy.legs);
    }
    else{
      self.stat_target_hp_torsoCenter = 0;
      self.stat_target_hp_torsoLeft = 0;
      self.stat_target_hp_torsoRight = 0;
      self.stat_target_hp_armLeft = 0;
      self.stat_target_hp_armRight = 0;
      self.stat_target_hp_legs = 0;
    }
  }
};

/*
  sends just player state and stuff
*/
void() client_push_player_info_thin={
  self.ammo_rockets = self.flags;
}
void( entity targetClient ) server_push_player_info={
  local entity this;
  this = self;
  self = targetClient;
    client_push_player_info();
  self = this;
};

void( entity targetClient ) client_push_hud_highlight={
  local entity this;
  this = self;
  self = targetClient;
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_UI_BOX );
    WriteCoord( MSG_ONE, this.movedir_x );
    WriteCoord( MSG_ONE, this.movedir_y );
    WriteCoord( MSG_ONE, this.movedir_z );
    
    WriteCoord( MSG_ONE, this.compOffset_x );
    WriteCoord( MSG_ONE, this.compOffset_y );
    WriteCoord( MSG_ONE, this.compOffset_z );
    
    WriteCoord( MSG_ONE, this.color_x );
    WriteCoord( MSG_ONE, this.color_y );
    WriteCoord( MSG_ONE, this.color_z );

    WriteShort( MSG_ONE, this.data_lifetime );
  
  self = this;
}; 


//TODO - refactor
void( entity targetClient ) client_send_boundary_warning={
  local entity this;
  
  this = self;
  self = targetClient;
  msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY);
    WriteByte( MSG_ONE, TE_MSN_BOUND);
    WriteByte( MSG_ONE, this.isActive );
    WriteAngle( MSG_ONE, this.ai_dir );
  self = this;
};

/*
  used by ClientConnect when client signs on.
  pushes map object info to client.
*/
void() client_push_mapobjects={
  local entity obj;
  
  for(obj = findchainflags( flags, FL_NODE ); obj != world; obj = obj.chain){
    switch( obj.data_type ){
      case DATA_DEPL:
        obj.SendFlags = obj.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
        break;
      case DATA_NAVP:
        obj.SendFlags = obj.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
        break;
      case DATA_OBJT:
        obj.SendFlags = obj.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
        break;
    }
  }
};

/*
  client sends string 'cmd m foo'
  where foo is the command, first parm must be 'm'
  
  so - 'cmd m foo'
*/
void(string str, float tokens) client_ParseMechCommand={
  local float prevFaction;
  
  if(argv(1) == "sw"){
    if(self.deadflag >= DEAD_NO){
      client_setWeapon(str, tokens);
    }
    return;
  }
  
  if(argv(1) == "sm"){
    self.vec_size = stof(argv(2));
    self.nextVecChoice = stof(argv(3));
    self.colormod_x = stof(argv(4));
    self.colormod_y = stof(argv(5));
    self.colormod_z = stof(argv(6));
    return;
  }
  
  if(argv(1) == "sp"){
    if(self.data_type == DATA_POBS){
      player_unmakeObserver();
      if( self.playerState == PLAYER_SPAWN ){
        PutClientInServer();
      }
      sv_client_spawnpoint_select();
      player_makeMech();
      client_playTrack( world.sounds, TRUE );
      if( self.client_num < 1){
        CLIENTS = CLIENTS + 1;  //book keeping for multiplayer
        self.client_num = CLIENTS;  //book keeping for multiplayer
      }
    }
    return;
  }
  
  if(argv(1) == "sg"){
    client_setWeaponGroup(str, tokens);
    return;
  }
  
  //
  if(argv(1) == "sn"){
    client_setNavPoint(str, tokens);
    return;
  }
  
  //changes player's .faction var
  if(argv(1) == "fac"){
    prevFaction = self.faction;
    self.faction = stof( argv(2) );
    if( GAMETYPE == GAMEMODE_TEAMDM ){
      if( prevFaction != self.faction ){
        if( self.faction == FACTION_MILITAR ){
          if( TEAM_MILITAR_TOTAL < 9 ){
            TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL - 1;
            TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
          }
          else{
            self.faction = prevFaction;
          }
        }
        else if( self.faction == FACTION_SURVEST ){
          if( TEAM_SURVEST_TOTAL < 9 ){
            TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
            TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL - 1;
          }
          else{
            self.faction = prevFaction;
          }
        }
      }
    }
    
    client_update_faction();
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TURRET;
    return;
  }
  
  if(argv(1) == "nxm"){
    client_setMission(str, tokens);
    return;
  }
  
  if( argv(1) == "setmode" ){
    cvar_set("gamemode", argv(2) );
    return;
  }
  
  //player wants to skip an animatic
  if( argv(1) == "exan" ){
    self.count2 = 0;
    self.velocity = '0 0 0';
    self.avelocity = '0 0 0';
    if( self.animId != world ){
      if( self.animId.target != "" ){
        local entity trigTarg;
        trigTarg = find(world, targetname, self.animId.target );
        if( trigTarg ){
          if( trigTarg.use ){
            local entity notTrig;
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
  
  if( argv(1) == "rtexport" ){
    world_export_realtimelights( stof(argv(2)) );
    return;
  }
};  

void() client_update_faction={
  local float newSkinNum;
  
  if( self.skin > 3){
    //Deathmach randomizer;
    self.skin = min(rint(random()*3),0);
  }
  newSkinNum = self.faction - 1;
  self.skin = newSkinNum;
  
  if( self.torsoCenter ){
    self.torsoCenter.skin = newSkinNum;
  }  
  if( self.torsoLeft){
    self.torsoLeft.skin = newSkinNum;
  }  
  if( self.torsoRight ){
    self.torsoRight.skin = newSkinNum;
  }  
  if( self.armLeft ){
    self.armLeft.skin = newSkinNum;
  }  
  if( self.armRight ){
    self.armRight.skin = newSkinNum;
  }  
  if( self.legs ){
    self.legs.skin = newSkinNum;
  }
};

void(string cmd, float tokens) client_setMission={
  //Single player
  if( GAMETYPE == GAMEMODE_CAMPAIGN ){
    self.playerState = PLAYER_ACTIVE;
    self.view_ofs = '0 0 1';
    if( stof(argv(2)) == MISSION_RESULT_WIN ){ 
      //mission successful, next map
      savefile_changemap(sv_nextmap); //TODO - fix me
      if( sv_nextmap == "" ){
        stuffcmd(self, "disconnect;togglemenu;cd play 2;demos;\n");
        return;
      }
      changelevel (sv_nextmap);  //possibly altered by map_objective objects.
    }
    else{
      //mission failed
      changelevel (mapname);
    }
    return;
  }
  
  // Network games
  // -Mission is on-going
  if( MISSION_STATUS == MISSION_STATUS_ACTIVE ){
    //Co-op respawn
    if( GAMETYPE == GAMEMODE_COOP ){
      sv_client_respawn();
      return;
    }
    //DM/TDM respawn
    if( GAMETYPE == GAMEMODE_TEAMDM || GAMETYPE == GAMEMODE_DM ){
      sv_client_respawn();
      return;
    }
  }
};

/*
  Client set's their weapon groups on the server
*/
void(string cmd, float tokens) client_setWeaponGroup={
  self.w_group1 = stof(argv(2));
  self.w_group2 = stof(argv(3));
  self.w_group3 = stof(argv(4));
  self.w_group4 = stof(argv(5));
};

/*
  Sends an AI voice sample to play for a specific client
  limiter = total copies of 'voiceMessage' that can sit in the voice queue.
*/
void( entity client, float voiceGroup, float voiceId, float limiter) client_send_ai_voice={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY);
  WriteByte( MSG_ONE, TE_AI_VOICE );
  WriteByte( MSG_ONE, voiceGroup);
  WriteByte( MSG_ONE, voiceId);
  WriteByte( MSG_ONE, limiter );
  WriteLong( MSG_ONE, num_for_edict(self) );
};

/*
  Sends an AI voice sample to play to ALL Clients
  limiter = total copies of 'voiceMessage' that can sit in the voice queue.
*/
void( float voiceGroup, float voiceId, float limiter) client_send_ai_voice_all={
  WriteByte( MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte( MSG_BROADCAST, TE_AI_VOICE );
  WriteByte( MSG_BROADCAST, voiceGroup);
  WriteByte( MSG_BROADCAST, voiceId);
  WriteByte( MSG_BROADCAST, limiter );
  WriteLong( MSG_BROADCAST, num_for_edict(self) );
};

void(entity client, float weaponsOnOff) client_send_event_repairs={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_REPAIRS_ON );
  WriteByte( MSG_ONE, weaponsOnOff );
};

void(entity client, string theMessage, float messageLifetime) client_send_info_message={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MSG_INFO );
  WriteString( MSG_ONE, theMessage );
  WriteLong( MSG_ONE, messageLifetime );
};


/*
commmand string: cmd mech setwep X Y
  X = WEAPON bitflag id
  Y = weapon data_idx id
*/
void(string cmd, float tokens) client_setWeapon={
  local float itr, new_id;
  local float totalWeps;
  local float bitCount;
  local entity oself;
  
  itr = 3;
  bitCount = 1;
  for( totalWeps = 1; totalWeps < stof(argv(2)); totalWeps = totalWeps + 1){
    new_id = stof(argv(itr));
    switch(totalWeps){
      case 1:
        self.next_wepn1 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 2:
        self.next_wepn2 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 3:
        self.next_wepn3 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 4:
        self.next_wepn4 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 5:
        self.next_wepn5 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 6:
        self.next_wepn6 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 7:
        self.next_wepn7 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 8:
        self.next_wepn8 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
      case 9:
        self.next_wepn9 = new_id;
        self.stat_player_weapons_state = self.stat_player_weapons_state | bitCount;
        break;
    }
    itr = itr + 1;
    bitCount = floor(bitCount * 2);
  }
};

void(float track, float loop) client_playTrack={
  local string cmd;
  cmd = "cd ";
  if( loop ){
    cmd = strcat(cmd, "loop ");
  }
  else{
    cmd = strcat(cmd, "play ");
  }
  cmd = strcat(cmd, ftos(track), "\n");
  stuffcmd(self, cmd);
};

void() client_sendServerInfo={
  stuffcmd(self, SERVER_INFO);
};

void() client_sendMissionFileName={
  local string cmd, msnFile;
  
  msnFile = mapname;
  if( world.missionFile != "" ){
    msnFile = world.missionFile;
  }
  
  cmd = strcat("m msn ", msnFile, "\n");
  stuffcmd(self, cmd);
};

void(string fileName) client_sendAnimaticFileName={
  local string cmd;
  cmd = strcat("m anm ", fileName, "\n");
  stuffcmd(self, cmd);
};

void(string cmd, float tokens) client_setNavPoint={
  local float nav_id;
  local entity nav;
  nav_id = stof(argv(2));
  for( nav = findchainfloat(data_type, DATA_DEPL); nav != world; nav = nav.chain){
    if(!nav.isActive){
      continue;
    }
    if(nav.faction != self.faction){
      if( nav.faction != FACTION_ALL ){
        continue; 
      }
    }
    if(nav.data_idx != nav_id){
      continue;
    }
    self.goalentity = nav;
  }
};

/*
  scope agnostic means of sending 'fog' settings and cmd to the client
*/
void(entity client, float fogDense, vector fogColor, float fogAlpha, vector fogDist, float fogFade) client_sendFog={
  local string fogCmd;
  
  fogCmd = "fog ";
  fogCmd = strcat( fogCmd, ftos(fogDense), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_x), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_y), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_z), " " );
  fogCmd = strcat( fogCmd, ftos(fogAlpha), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_x), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_y), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_z), " " );
  fogCmd = strcat( fogCmd, ftos(fogFade), "\n" );
  stuffcmd( client, fogCmd );
};

/*
  scope agnostic means of sending CD track changes to the client
*/
void(entity client, float trackNum, float entFlags) client_sendMusic={

  otemp = self;
  self = client;
    client_playTrack( trackNum, (entFlags & 2) );
  self = otemp;
};

/*
  client Mapping = client_event_debrief_active();
  CAMPAIGN / COOP ONLY
  sends the 'conclusion' data from a mission to the client
*/
void(entity client, float missionSuccessCheck) client_sendEndMission={
  WriteByte( MSG_ALL, SVC_TEMPENTITY );
  WriteByte( MSG_ALL, TE_MISSION_END );
  WriteByte( MSG_ALL, missionSuccessCheck );
  WriteShort( MSG_ALL, MISSION_TOTAL_PSC );
  WriteShort( MSG_ALL, MISSION_TOTAL_SURVEST );
  WriteShort( MSG_ALL, MISSION_TOTAL_MILITAR );
  switch( client.faction ){
    case FACTION_PSC:
      WriteShort( MSG_ONE, MISSION_LOSSES_PSC );
      break;
    case FACTION_SURVEST:
      WriteShort( MSG_ONE, MISSION_LOSSES_SURVEST );
      break;
    case FACTION_MILITAR:
      WriteShort( MSG_ONE, MISSION_LOSSES_MILITAR );
      break;
    default:
      WriteShort( MSG_ONE, 0 );
      break;
  }
};
/*
  Send important world data, useful for timed updates like Campaign and Coop.
*/
void() client_send_server_info_update={
  WriteByte( MSG_ALL, SVC_TEMPENTITY );
  WriteByte( MSG_ALL, TE_SERVERINFO );
  WriteByte( MSG_ALL, MISSION_STATUS );
  WriteLong( MSG_ALL, STARTTIME );
  WriteLong( MSG_ALL, serverflags );
  WriteByte( MSG_ALL, MISSION_RESULT );
  WriteString( MSG_ALL, sv_nextmap );
};

/*
  CAMPAIGN / COOP  death/end-mission updates.
  
*/
void( entity client ) client_send_campaign_end_data={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_CLIENT_INFO );
  WriteLong( MSG_ONE, client.botKills );
  WriteLong( MSG_ONE, client.missionLosses );
  switch(client.faction){
    default :
      WriteLong( MSG_ONE, MISSION_TOTAL_SURVEST + MISSION_TOTAL_MILITAR );
      WriteLong( MSG_ONE, MISSION_TOTAL_PSC );
      break;
    case FACTION_SURVEST:
      WriteLong( MSG_ONE, MISSION_TOTAL_PSC + MISSION_TOTAL_MILITAR );
      WriteLong( MSG_ONE, MISSION_TOTAL_SURVEST );
      break;
    case FACTION_MILITAR:
      WriteLong( MSG_ONE, MISSION_TOTAL_SURVEST + MISSION_TOTAL_PSC );
      WriteLong( MSG_ONE, MISSION_TOTAL_MILITAR );
      break;
  }  
};

/*
  Sends client-specific data for post-DM/TDM matches.
*/
void( entity client ) client_send_dm_end_data={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_CLIENT_INFO_DM );
  WriteLong( MSG_ONE, client.playerDMdamage );
};


entity() spawnpoint_coop={
  local entity locus;
  locus = findchainfloat(data_type, DATA_INFO_COOP);
  while(locus){
    if(locus.faction == self.faction){
      if(locus.target == self.goalentity.targetname){
        if(locus.data_idx == self.client_num){
          self.goalentity = locus;
        }
      }
    }
    locus = locus.chain;
  }
  return self.goalentity;
};

entity() SelectSpawnPoint={
  local	entity spot;
	local	entity thing;
	local	float  pcount;
	
// testinfo_player_start is only found in regioned levels

  spot = find (world, classname, "testinfo_player_start");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point
  if (deathmatch)
	{
    if(self.data_type != DATA_POBS){
      spot = lastspawn;
      while (1)
      {
        spot = find(spot, classname, "info_player_deathmatch");
        if (spot != world)
        {
          if (spot == lastspawn)
            return lastspawn;
          pcount = 0;
          thing = findradius(spot.origin, 32);
          while(thing)
          {
            if (thing.classname == "player")
              pcount = pcount + 1;
            thing = thing.chain;
          }
          if (pcount == 0)
          {
            lastspawn = spot;
            return spot;
          }
        }
      }
    }
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
  
  spot = find (world, classname, "info_player_start");
  
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");

	return spot;
};

/*
  SELECT INFO_START 
    overrides SelectSpawnPoint();
  
  battleMETAL doesn't put the player into the action at any of the original info_ node entities.
  Instead, the game sends that decision to the client for handling.
  
  scope: self = client
*/
void() sv_select_info_start={
  local entity spot;
  
  switch( GAMETYPE ){
    case GAMEMODE_CAMPAIGN:
      spot = find(spot, classname, "info_player_start");
      break;
      
    case GAMEMODE_COOP:
      spot = find(spot, classname, "info_player_coop");
      break;
      
    case GAMEMODE_DM:
      spot = find(spot, classname, "info_player_deathmatch");
      break;
      
    case GAMEMODE_TEAMDM:
      spot = find(spot, classname, "info_player_deathmatch");
      break;
  }
  if( spot ){
    self.angles = spot.angles;
    setorigin(self, spot.origin);
    
  }
  else{
    error ("PutClientInServer()->sv_select_info_start(): no info_player_start on level");
  }
};

void() spawnpoint_Random={
  local entity spot;
  
  if(self.goalentity){
    spot = self.goalentity;
  }
  else{
    spot = SelectSpawnPoint();
  }
  
  self.origin = self.oldorigin = spot.origin + '0 0 12';
  
  self.angles = spot.angles;
	self.fixangle = TRUE;	
};

void() legacy_PlayerDie={
	//self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	//self.invisible_finished = 0;
	//self.invincible_finished = 0;
	//self.super_damage_finished = 0;
	//self.radsuit_finished = 0;
};

void() client_updateWeaponReloads={
  local entity e;
  local float idx;
  idx = 1;
  e = self.w_slot;
  while(e){
    local float delta, wid;
    delta = e.reloadValue;
    wid = e.data_idx;
    switch(idx){
      case 1: 
        self.stat_w1_id = wid;
        break;
      case 2:
        self.stat_w2_id = wid;
        break;
      case 3:
        self.stat_w3_id = wid;
        break;
      case 4:
        self.stat_w4_id = wid;
        break;
      case 5:
        self.stat_w5_id = wid;
        break;
      case 6:
        self.stat_w6_id = wid;
        break;
      case 7:
        self.stat_w7_id = wid;
        break;
      case 8:
        self.stat_w8_id = wid;
        break;
      case 9:
        self.stat_w9_id = wid;
        break;
    }
    idx = idx + 1;
    e = e.w_slot;
  }
};

float(entity piece) csqc_updateCompStat={
  local float perc;
  perc = 0;
  if( piece && piece.health > 0 ){
    perc = (piece.health / piece.max_health)*100;
    return perc;
  }
  return perc;
};

/*
  Send wreckage entity to client, 
  should cut down on workload of server, right?
*/

void( float particleEffectId, vector particleOrg, vector particleVel, float particleCount ) client_send_particle={
  WriteByte( MSG_BROADCAST, SVC_TEMPENTITY );
  WriteByte( MSG_BROADCAST, TE_VFX_POINT );
  WriteShort( MSG_BROADCAST, particleEffectId );
  WriteCoord(MSG_BROADCAST, particleOrg_x);
  WriteCoord(MSG_BROADCAST, particleOrg_y);
  WriteCoord(MSG_BROADCAST, particleOrg_z);
  WriteCoord(MSG_BROADCAST, particleVel_x);
  WriteCoord(MSG_BROADCAST, particleVel_y);
  WriteCoord(MSG_BROADCAST, particleVel_z);
  WriteShort(MSG_BROADCAST, particleCount);
};

void( float entityId, float particleEffectId, vector particleOrg, vector particleEnd ) client_send_particle_rail={
  WriteByte( MSG_BROADCAST, SVC_TEMPENTITY );
  WriteByte( MSG_BROADCAST, TE_VFX_RAIL );
  WriteShort( MSG_BROADCAST, particleEffectId );
  WriteCoord(MSG_BROADCAST, particleOrg_x);
  WriteCoord(MSG_BROADCAST, particleOrg_y);
  WriteCoord(MSG_BROADCAST, particleOrg_z);
  WriteCoord(MSG_BROADCAST, particleEnd_x);
  WriteCoord(MSG_BROADCAST, particleEnd_y);
  WriteCoord(MSG_BROADCAST, particleEnd_z);
};

void( float wepId, vector flashOrg, vector flashVel, float impType ) client_send_muzzle_flash={
  WriteByte( MSG_BROADCAST, SVC_TEMPENTITY );
  WriteByte( MSG_BROADCAST, TE_MUZZLE_FLASH );
  WriteByte( MSG_BROADCAST, wepId );
  WriteCoord(MSG_BROADCAST, flashOrg_x);
  WriteCoord(MSG_BROADCAST, flashOrg_y);
  WriteCoord(MSG_BROADCAST, flashOrg_z);
  WriteCoord(MSG_BROADCAST, flashVel_x);
  WriteCoord(MSG_BROADCAST, flashVel_y);
  WriteCoord(MSG_BROADCAST, flashVel_z);
  WriteByte( MSG_BROADCAST, impType);
};


/*
  Losses is mostly just a campaign fluff text thing, gives player perspective.
*/
void() client_update_losses={
  switch(self.faction){
    case FACTION_MILITAR:
      self.missionLosses = MISSION_LOSSES_MILITAR;
      break;
    case FACTION_PSC:
      self.missionLosses = MISSION_LOSSES_PSC;
      break;
    case FACTION_SURVEST:
      self.missionLosses = MISSION_LOSSES_SURVEST;
      break;
  }
};