/*
battleMETAL
Author: Peter Roohr
Date: 01/11/2021
Overview:
  Rules/Server Info entity, shared by client and server, handy for syncro of server 
*/

#ifdef SSQC
entity() world_ini_serverInfo_ent={
  local entity eServerInfo;
  eServerInfo = spawn();
  eServerInfo.classname = "world_rules";
  eServerInfo.effects = eServerInfo.effects | EF_NODEPTHTEST;
  eServerInfo.solid = SOLID_NOT;
  eServerInfo.movetype = MOVETYPE_NONE;
  eServerInfo.data_type = DATA_MAP_RULES;
  eServerInfo.alpha = 0.01;
  eServerInfo.scale = 0.01;
  
  setmodel(eServerInfo, "models/testball.md3");
  setsize(eServerInfo, '-1 -1 -1', '1 1 1');
  setorigin(eServerInfo, world.origin);
  eServerInfo.alpha = 0.01;
  eServerInfo.scale = 0.01;
  
  eServerInfo.serverFlags = serverflags;
  eServerInfo.SendEntity = world_rules_sendEntity;
  eServerInfo.SendFlags = eServerInfo.SendFlags | SENDFLAG_UPDATE_FULL;
  
  eServerInfo.sounds = world.sounds;
  
  eServerInfo.think = world_server_rules_frame;
  eServerInfo.nextthink = time + 0.01;
  return eServerInfo;
};

void() world_server_rules_frame={
  
  if( self.gameType != cvar("gamemode") ){
    self.gameType = cvar("gamemode");
    self.SendFlags = self.SendFlags | SENDFLAG_GAMETYPE;
  }
  
  if( self.ruleFraglimit != cvar("fraglimit") ){
    self.ruleFraglimit = cvar("fraglimit");
    self.SendFlags = self.SendFlags | SENDFLAG_RULE_LIMIT_FRAG;
  }
  
  if( self.ruleTimelimit != cvar("timelimit") ){
    self.ruleTimelimit = cvar("timelimit");
    self.SendFlags = self.SendFlags | SENDFLAG_RULE_LIMIT_TIME;
  }
  
  if( self.serverFlags != serverflags ){
    self.serverFlags = 0 | serverflags;
    self.SendFlags = self.SendFlags | SENDFLAG_SERVERFLAGS;
  }
  
  self.think = world_server_rules_frame;
  self.nextthink = time + 0.1;
};

float( entity to, float changedFlags ) world_rules_sendEntity={
  
  //SendEnt header
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteLong( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_MAP_RULES );
  //==================================================
  
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteString( MSG_ENTITY, cvar_string("hostname") );
    WriteString( MSG_ENTITY, cvar_string("sv_about"));
    WriteLong( MSG_ENTITY, self.serverFlags );
    WriteByte( MSG_ENTITY, self.gameType );
    
    WriteCoord( MSG_ENTITY, self.minimapMins_x);
    WriteCoord( MSG_ENTITY, self.minimapMins_y);
    WriteCoord( MSG_ENTITY, self.minimapMins_z);
    
    WriteCoord( MSG_ENTITY, self.minimapMaxs_x);
    WriteCoord( MSG_ENTITY, self.minimapMaxs_y);
    WriteCoord( MSG_ENTITY, self.minimapMaxs_z);
    
    WriteCoord( MSG_ENTITY, self.uiViewBoxOrg_x);
    WriteCoord( MSG_ENTITY, self.uiViewBoxOrg_y);
    WriteCoord( MSG_ENTITY, self.uiViewBoxOrg_z);
    
    WriteByte( MSG_ENTITY, self.sounds );
  }

  if( (changedFlags & SENDFLAG_GAMETYPE) ){
    WriteByte( MSG_ENTITY, self.gameType );
  }
  
  if( (changedFlags & SENDFLAG_STARTTIME) ){
    WriteLong( MSG_ENTITY, self.timeStart );
  }
  
  if( (changedFlags & SENDFLAG_SERVERFLAGS) ){
    WriteLong( MSG_ENTITY, self.serverFlags );
  }
  
  if( (changedFlags & SENDFLAG_MISSION_STATUS) ){
    WriteByte( MSG_ENTITY, self.missionStatus );
  }
  
  if( (changedFlags & SENDFLAG_MISSION_RESULT) ){
    WriteByte( MSG_ENTITY, self.missionResult );
  }
  
  if( (changedFlags & SENDFLAG_RULE_LIMIT_FRAG) ){
    if( self.gameType == GAMEMODE_DM || self.gameType == GAMEMODE_TEAMDM ){
      WriteShort( MSG_ENTITY, self.ruleFraglimit );
    }
  }
  
  if( (changedFlags & SENDFLAG_RULE_LIMIT_TIME) ){
    if( self.gameType == GAMEMODE_DM || self.gameType == GAMEMODE_TEAMDM ){
      WriteLong( MSG_ENTITY, self.ruleTimelimit );
    }
  }
  
  if( (changedFlags & SENDFLAG_MAP_NEXT) ){
    WriteString( MSG_ENTITY, self.nextMap );
  }
  
  if( (changedFlags & SENDFLAG_SAVESLOT) ){
    WriteByte( MSG_ENTITY, self.saveSlot );
  }
  
  if( (changedFlags & SENDFLAG_WORLDTYPE) ){
    WriteByte( MSG_ENTITY, self.worldtype );
  }
  
  if( (changedFlags & SENDFLAG_ENDROUND) ){
     //time the round ended.
     //CSQC tracks as the global servertime
  }
  
  //TDM team totals changed
  if( self.gameType == GAMEMODE_TEAMDM){
    if( (changedFlags & SENDFLAG_FACTION) ){
      WriteByte( MSG_ENTITY, TEAM_SURVEST_TOTAL);
      WriteByte( MSG_ENTITY, TEAM_MILITAR_TOTAL);
    }
  }
  
  return TRUE;
};

void() world_server_setRules={
  

};
#endif

#ifdef CSQC
void( float isNew, float changeFlags) world_rules_readEntity={
  local string tempHostName;
  local string tempAbout;
  local string tempNextMap;
  local float prevGameMode;
  
  /*local float nextGameType;
  local float nextStartTime;
  local float nextServerFlags;
  local float nextMissionStatus;
  local float nextMissionResult;
  local float nextRuleFrag;
  local float nextRuleTime;*/
  
  prevGameMode = self.gameType;
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    tempHostName = ReadString();
    tempAbout = ReadString();
    cacheGlobalString(self.netname, tempHostName)
    cacheGlobalString(self.svAbout, tempAbout)
    //have to doubly make sure serverflags and gameType are sent because .ignoreSave is riding on this.
    self.serverFlags = ReadLong();
    self.gameType = ReadByte();
    self.minimapMins = te_read_vector();
    self.minimapMaxs = te_read_vector();
    self.uiViewBoxOrg = te_read_vector();
    self.sounds = ReadByte();
    
  }

  ENT_SERVER_INFO = self;
  if( isNew ){
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    setmodel(self, "models/testball.md3");
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
    self.scale = 0.01;
    self.alpha = 0.01;
  }
  //SendEnt header
  //==================================================
  if( (changeFlags & SENDFLAG_GAMETYPE) ){
    self.gameType = ReadByte();
    cvar_set("gamemode", ftos(self.gameType));
  }
  if( (changeFlags & SENDFLAG_STARTTIME) ){
    self.timeStart = ReadLong();
  }
  if( (changeFlags & SENDFLAG_SERVERFLAGS) ){
    self.serverFlags = ReadLong();
    cvar_set("sv_serverflags", ftos(self.serverFlags));
  }
  if( (changeFlags & SENDFLAG_MISSION_STATUS) ){
    self.missionStatusPrev = self.missionStatus;
    self.missionStatus = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_MISSION_RESULT) ){
    self.missionResult = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_RULE_LIMIT_FRAG) ){
    if( self.gameType == GAMEMODE_DM || self.gameType == GAMEMODE_TEAMDM ){
      self.ruleFraglimit = ReadShort();
    }
  }
  
  if( (changeFlags & SENDFLAG_RULE_LIMIT_TIME) ){
    if( self.gameType == GAMEMODE_DM || self.gameType == GAMEMODE_TEAMDM ){
      self.ruleTimelimit = ReadLong();
    }
  }
  if( (changeFlags & SENDFLAG_MAP_NEXT) ){
    tempNextMap = ReadString();
    cacheGlobalString( self.nextMap, tempNextMap);
    cacheGlobalString( SV_NEXTMAP, tempNextMap)
  }
  
  if( (changeFlags & SENDFLAG_SAVESLOT) ){
    self.saveSlot = ReadByte();
  }
  if( (changeFlags & SENDFLAG_WORLDTYPE) ){
    self.worldtype = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_ENDROUND) ){
    self.endRoundTime = servertime;//time the round ended.
  }
  
  //TDM team totals changed
  if( self.gameType == GAMEMODE_TEAMDM){
    if( (changeFlags & SENDFLAG_FACTION) ){
      TEAM_SURVEST_TOTAL = ReadByte();
      TEAM_MILITAR_TOTAL = ReadByte();
    }
  }
  
  SV_WORLDTYPE = self.worldtype;
  
  if( self.missionStatus == MISSION_STATUS_OVER ){
    self.timeEnd = servertime;
  }
  
  if( self.gameType == GAMEMODE_CAMPAIGN ){
    cvar_set("saveslot", ftos(self.saveSlot));
  }
  if( self.gameType == GAMEMODE_DM || self.gameType == GAMEMODE_TEAMDM ){
    SV_FRAGLIMIT = self.ruleFraglimit;
    SV_TIMELIMIT = self.ruleTimelimit;
  }

  if( (self.serverFlags & SVFLAG_SIMMOVE) ){
    cvar_set("sv_gameplayfix_mech_speed", ftos(fabs(rint(SV_MECH_SPEED_RETRO))));
  }
  else{
    cvar_set("sv_gameplayfix_mech_speed", ftos(fabs(rint(SV_MECH_SPEED_METAL))));
  }
};
#endif