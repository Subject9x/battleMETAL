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
  local float targShield;
  local float myShield;
  
  //self.ammo_rockets = self.flags;
  if(self.data_type == DATA_MECH){
    self.stat_client_energy = (self.energy / self.energyMax) * 100;
    
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      if( time <= self.shieldHitRegen ) {
        myShield = self.shieldHitRegen - self.shieldHitRegenStart;
        myShield = (time - self.shieldHitRegenStart) / myShield;
        myShield =  100 - (myShield * 100) + 100;
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
    }
    
    self.stat_client_hp_torsoCenter = csqc_updateCompStat(self);
    
    if( (self.unitModFlags & MOD_HAS_TOR_L) ){
      self.stat_client_hp_torsoLeft = csqc_updateCompStat(self.torsoLeft);
    }
    if( (self.unitModFlags & MOD_HAS_TOR_R) ){
      self.stat_client_hp_torsoRight = csqc_updateCompStat(self.torsoRight);
    }
    
    if( (self.unitModFlags & MOD_HAS_ARM_L) ){
      self.stat_client_hp_armLeft = csqc_updateCompStat(self.armLeft);
    }
    
    if( (self.unitModFlags & MOD_HAS_ARM_R) ){
      self.stat_client_hp_armRight = csqc_updateCompStat(self.armRight);
    }
    
    self.stat_client_hp_legs = csqc_updateCompStat(self.legs);
    
    if( self.targetEntId != 0 ){
      //this is silly but precludes forcing the csqc to know the target's max shields
      if( (self.enemy.unitModFlags & MOD_HAS_SHIELD) ){
        if( time <= self.enemy.shieldHitRegen ) {
          targShield = self.enemy.shieldHitRegen - self.enemy.shieldHitRegenStart;
          targShield = (time - self.enemy.shieldHitRegenStart) / targShield;
          targShield =  100 - (targShield * 100) + 100;
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
      }
      self.stat_target_hp_torsoCenter = csqc_updateCompStat(self.enemy);
      if( (self.enemy.unitModFlags & MOD_HAS_TOR_L) ){
        self.stat_target_hp_torsoLeft = csqc_updateCompStat(self.enemy.torsoLeft);
      }
      if( (self.enemy.unitModFlags & MOD_HAS_TOR_R) ){
        self.stat_target_hp_torsoRight = csqc_updateCompStat(self.enemy.torsoRight);
      }
      if( (self.enemy.unitModFlags & MOD_HAS_ARM_L) ){
        self.stat_target_hp_armLeft = csqc_updateCompStat(self.enemy.armLeft);
      }
      if( (self.enemy.unitModFlags & MOD_HAS_ARM_R) ){
        self.stat_target_hp_armRight = csqc_updateCompStat(self.enemy.armRight);
      }
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
    
    WriteCoord( MSG_ONE, this.color_x );
    WriteCoord( MSG_ONE, this.color_y );
    WriteCoord( MSG_ONE, this.color_z );
    
    WriteShort( MSG_ONE, this.data_lifetime );
    WriteByte( MSG_ONE, this.partTypeId );
    
    WriteCoord( MSG_ONE, this.compOffset_x );
    WriteCoord( MSG_ONE, this.compOffset_y );
    WriteCoord( MSG_ONE, this.compOffset_z );
      
    if( this.partTypeId == 0 || !this.partTypeId ){
      WriteCoord( MSG_ONE, this.movedir_x );
      WriteCoord( MSG_ONE, this.movedir_y );
      WriteCoord( MSG_ONE, this.movedir_z );
    }
  self = this;
};

void( entity targetClient ) client_send_boundary_warning={
  msg_entity = targetClient;
  WriteByte( MSG_ONE, SVC_TEMPENTITY);
  WriteByte( MSG_ONE, TE_MSN_BOUND);
  WriteByte( MSG_ONE, self.isActive );
  WriteAngle( MSG_ONE, self.ai_dir );
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
  Client Info-string processing.
  This is called by SV_ParseClientCommand()
    where the found cmdCall == "client"
  
  WARN: only ever call this from SV_ParseClientCommand()
    because [SELF] MUST be scoped to an actual client!
  
  this function expects the String S to be of the following format
  "client <infostring values>"
    and it MUST conform to the format found in /common/data/data_values_game.qc!
*/
void(string cmdString) client_parse_clientInfoString={
  local float changeFlags;
  local string dataString;
  local float nextFaction;
  
  tokenize(cmdString);
  
  dataString = argv(1);
  
  changeFlags = rint(stof(infoget(dataString, KEY_FLAGS)));
  //FACTION UPDATE
  if( (changeFlags & INFO_FLAG_FACTION) ){
    nextFaction = rint(stof( infoget(dataString, KEY_FACTION) ));
    if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
      if( nextFaction != self.faction ){
        //SURVEST -> MILITAR
        if( nextFaction == FACTION_SURVEST ){
          if( TEAM_SURVEST_TOTAL <= 7 ){
            TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
            TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL - 1;
          }
        }
        //MILITAR -> SURVEST
        else if( nextFaction == FACTION_MILITAR ){
          if( TEAM_MILITAR_TOTAL <= 7 ){
            TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL - 1;
            TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
          }
        }
        ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_FACTION;
      }
    }
    self.faction = nextFaction;
    self.clientcolors = nextFaction;
    client_update_faction();
  }
  //MECH ID UPDATE
  if( (changeFlags & INFO_FLAG_MECH) ){
    self.nextVecChoice = stof(infoget(dataString, KEY_MECH));
  }
  //DEPLOY ID UPDATE
  if( (changeFlags & INFO_FLAG_DEPLOY) ){
    //set deploy point
    client_setNavPoint( rint(stof(infoget(dataString, KEY_DEPLOY))) );
  }
  //COLORS UPDATE
  if( (changeFlags & INFO_FLAG_COLOR) ){
    self.unitColorCT = rint(stof(infoget(dataString, KEY_COLOR1)));
    self.unitColorLT = rint(stof(infoget(dataString, KEY_COLOR2)));
    self.unitColorRT = rint(stof(infoget(dataString, KEY_COLOR3)));
    self.unitColorLA = rint(stof(infoget(dataString, KEY_COLOR4)));
    self.unitColorRA = rint(stof(infoget(dataString, KEY_COLOR5)));
    self.unitColorLG = rint(stof(infoget(dataString, KEY_COLOR6)));
    self.new_color = TRUE;
  }
  //WEAPON GROUPS UPDATE
  if( (changeFlags & INFO_FLAG_GROUPS) ){
    self.w_group1 = rint(stof(infoget(dataString, KEY_GROUP1)));
    self.w_group2 = rint(stof(infoget(dataString, KEY_GROUP2)));
    self.w_group3 = rint(stof(infoget(dataString, KEY_GROUP3)));
    self.w_group4 = rint(stof(infoget(dataString, KEY_GROUP4)));
  }
  //WEAPON ID SPECIFICS
  if( (changeFlags & WEAPON1) ){
    self.next_wepn1 = rint(stof(infoget(dataString, KEY_WEPN1)));
  }
  if( (changeFlags & WEAPON2) ){
    self.next_wepn2 = rint(stof(infoget(dataString, KEY_WEPN2)));
  }
  if( (changeFlags & WEAPON3) ){
    self.next_wepn3 = rint(stof(infoget(dataString, KEY_WEPN3)));
  }
  if( (changeFlags & WEAPON4) ){
    self.next_wepn4 = rint(stof(infoget(dataString, KEY_WEPN4)));
  }
  if( (changeFlags & WEAPON5) ){
    self.next_wepn5 = rint(stof(infoget(dataString, KEY_WEPN5)));
  }
  if( (changeFlags & WEAPON6) ){
    self.next_wepn6 = rint(stof(infoget(dataString, KEY_WEPN6)));
  }
  if( (changeFlags & WEAPON7) ){
    self.next_wepn7 = rint(stof(infoget(dataString, KEY_WEPN7)));
  }
  if( (changeFlags & WEAPON8) ){
    self.next_wepn8 = rint(stof(infoget(dataString, KEY_WEPN8)));
  }
  if( (changeFlags & WEAPON9) ){
    self.next_wepn9 = rint(stof(infoget(dataString, KEY_WEPN9)));
  }
  //SPAWN COMMAND
  if( (changeFlags & INFO_FLAG_SPAWN) ){
    // replace -> if( cmdCall == "sp" ){
    if(self.nextVecChoice > 0) {
      if(self.data_type == DATA_POBS){
        player_unmakeObserver();
        if( self.playerState == PLAYER_SPAWN ){
          PutClientInServer();
        }
        sv_client_spawnpoint_select();
        player_makeMech();
        client_playTrack( self, world.sounds, TRUE );
        if( self.client_num < 1){
          CLIENTS = CLIENTS + 1;  //book keeping for multiplayer
          self.client_num = CLIENTS;  //book keeping for multiplayer
        }
      }
    }
    else{
      //packet drop?
      player_makeObserver();
      self.playerState = PLAYER_SPAWN;
      self.th_die();
    }
  }
};

void() client_update_faction={
  local float newSkinNum;
  
  if( self.skin > 3){
    //Deathmach randomizer;
    self.skin = min(ceil(random()*3),4);
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

/*
  Sends Ini config if it exists
  string schema
    mech id
    wgroups - must have all, even if 0
    weapon id 1-9
    
*/
void() client_sendIniConfig={
  local string cmd;
  if( !world.iniConfig ){
    return;
  }

  cmd = strcat("m ini ", world.iniConfig, "\n");
  stuffcmd(self, cmd);

};

void(string cmd, float tokens) client_setMission={
  //Single player
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    self.playerState = PLAYER_ACTIVE;
    self.view_ofs = '0 0 1';
    if( stof(argv(1)) == MISSION_RESULT_WIN ){ 
      //mission successful, next map
      savefile_changemap(sv_nextmap); //TODO - fix me
      if( sv_nextmap == "" || strlen(sv_nextmap) == 0 || strstrofs(sv_nextmap, "menu", 0) != -1){
        stuffcmd(self, "disconnect;togglemenu;\n");
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
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    //Co-op respawn
    if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
      sv_client_respawn();
      return;
    }
    //DM/TDM respawn
    if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM || ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
      sv_client_respawn();
      return;
    }
  }
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

void( float playerId, float playerCritBits ) client_send_critical_hit={
  WriteByte( MSG_ALL, SVC_TEMPENTITY );
  WriteByte( MSG_ALL, TE_PLAYER_CRIT );
  WriteByte( MSG_ALL, playerId );
  WriteLong( MSG_ALL, playerCritBits );
};

void( entity client, float menuFlag ) client_send_menu_flag={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_ISMENU );
  WriteByte( MSG_ONE, menuFlag );
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
  
  itr = 2;
  bitCount = 1;
  for( totalWeps = 1; totalWeps < stof(argv(1)); totalWeps = totalWeps + 1){
    new_id = stof(argv(itr));
    switch(totalWeps){
      case 1:
        self.next_wepn1 = new_id;
        break;
      case 2:
        self.next_wepn2 = new_id;
        break;
      case 3:
        self.next_wepn3 = new_id;
        break;
      case 4:
        self.next_wepn4 = new_id;
        break;
      case 5:
        self.next_wepn5 = new_id;
        break;
      case 6:
        self.next_wepn6 = new_id;
        break;
      case 7:
        self.next_wepn7 = new_id;
        break;
      case 8:
        self.next_wepn8 = new_id;
        break;
      case 9:
        self.next_wepn9 = new_id;
        break;
    }
    itr = itr + 1;
    bitCount = floor(bitCount * 2);
  }
};

void(entity client, float track, float loopFlag) client_playTrack={
  msg_entity = client;  
  WriteByte(MSG_ONE, SVC_CDTRACK);
  WriteByte(MSG_ONE, track);
  WriteByte(MSG_ONE, loopFlag);
};

void() client_sendMissionFileName={
  local string cmd, msnFile;
  
  if( world.missionFile != "" || strlen(world.missionFile) > 0 ){
    msnFile = world.missionFile;
  }
  else{
    msnFile = mapname;
  }
  
  cmd = strcat("m msn ", msnFile, "\n");
  stuffcmd(self, cmd);
};

void(string fileName) client_sendAnimaticFileName={
  local string cmd;
  cmd = strcat("m anm ", fileName, "\n");
  stuffcmd(self, cmd);
};

void(float wantNavId) client_setNavPoint={
  local float nav_id;
  local entity nav;
  
  nav_id = wantNavId;
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
void(entity client, float worldFog, float fogDense, vector fogColor, float fogAlpha, vector fogDist, float fogFade) client_sendFog={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_FOG_SET );
  
  WriteByte( MSG_ONE, worldFog);
  
  WriteCoord( MSG_ONE, fogColor_x );
  WriteCoord( MSG_ONE, fogColor_y );
  WriteCoord( MSG_ONE, fogColor_z );
  
  
  WriteCoord( MSG_ONE, fogDist_x );
  WriteCoord( MSG_ONE, fogDist_y );
  WriteCoord( MSG_ONE, fogDist_z );
  
  WriteCoord( MSG_ONE, fogAlpha );
  WriteCoord( MSG_ONE, fogDense );
  WriteCoord( MSG_ONE, fogFade );
  
};


void(entity client, entity cube) client_sendParticleCube={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_PARTICLE_CUBE );
  
  WriteByte( MSG_ONE, cube.data_idx );
  
  WriteCoord( MSG_ONE, cube.compOffset_x );
  WriteCoord( MSG_ONE, cube.compOffset_y );
  WriteCoord( MSG_ONE, min(client.mins_z, cube.compOffset_z) );
  
  WriteCoord( MSG_ONE, cube.compAltOffset_x );
  WriteCoord( MSG_ONE, cube.compAltOffset_y );
  WriteCoord( MSG_ONE, cube.compAltOffset_z );
  
  WriteCoord( MSG_ONE, cube.velocity_x );
  WriteCoord( MSG_ONE, cube.velocity_y );
  WriteCoord( MSG_ONE, cube.velocity_z );
  
  WriteShort( MSG_ONE, cube.count );
  WriteShort( MSG_ONE, cube.count1 );
  WriteShort( MSG_ONE, cube.jump_flag );
  WriteShort( MSG_ONE, cube.count2 );
  WriteShort( MSG_ONE, time + cube.count3 );
  
  WriteLong( MSG_ONE, cube.spawnflags );
};

/*
  scope agnostic means of sending CD track changes to the client
*/
void(entity client, float trackNum, float entFlags) client_sendMusic={
  client_playTrack( client, trackNum, (entFlags & 2) );
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
      WriteShort( MSG_ALL, MISSION_LOSSES_PSC );
      break;
    case FACTION_SURVEST:
      WriteShort( MSG_ALL, MISSION_LOSSES_SURVEST );
      break;
    case FACTION_MILITAR:
      WriteShort( MSG_ALL, MISSION_LOSSES_MILITAR );
      break;
    default:
      WriteShort( MSG_ALL, 0 );
      break;
  }
};

//same thing as above but only on client connect.
void(entity client) client_send_server_info_connect={
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_GAMETYPE;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_STARTTIME;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_ENDTIME;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_SERVERFLAGS;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_SERVERFLAGS;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_RESULT;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MAP_NEXT;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_SAVESLOT;
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_WORLDTYPE;

  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
  
  if( ENT_SERVER_INFO.gameType == GAMEMODE_DM || ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
    if( ENT_SERVER_INFO.ruleFraglimit > 0 ){
      ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_FRAG;
    }
    if( ENT_SERVER_INFO.ruleTimelimit > 0 ){
      ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_TIME;
    }
  }
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_SAVESLOT;
  }
  ENT_SERVER_INFO.endRound = 0;
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
		if (spot){
			return spot;
    }
	}
  
  spot = find (world, classname, "info_player_start");
  
	if (!spot){
		error ("PutClientInServer: no info_player_start on level");
  }
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
  
  switch( ENT_SERVER_INFO.gameType ){
    case GAMEMODE_COOP:
      spot = find(spot, classname, "info_player_coop");
      break;
      
    case GAMEMODE_DM:
      spot = find(spot, classname, "info_player_deathmatch");
      break;
      
    case GAMEMODE_TEAMDM:
      spot = find(spot, classname, "info_player_deathmatch");
      break;
    default:
      spot = find(spot, classname, "info_player_start");
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

float(entity piece) csqc_updateCompStat={
  local float perc;
  perc = 0;
  if( piece && piece.health > 0 ){
    perc = (piece.health / piece.max_health)*100;
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