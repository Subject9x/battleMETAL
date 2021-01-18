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
  eServerInfo.classname = strzone("world_rules");
  eServerInfo.effects = eServerInfo.effects | EF_NODEPTHTEST;
  eServerInfo.solid = SOLID_NOT;
  eServerInfo.movetype = MOVETYPE_NONE;
  eServerInfo.data_type = DATA_MAP_RULES;
  eServerInfo.alpha = 0.01;
  eServerInfo.scale = 0.01;
  
  setmodel(eServerInfo, "q3mdl/testball.md3");
  setsize(eServerInfo, VEC_HULL_MIN, VEC_HULL_MAX);
  setorigin(eServerInfo, world.origin);
  
  eServerInfo.SendEntity = world_rules_sendEntity;
  eServerInfo.SendFlags = eServerInfo.SendFlags | SENDFLAG_NEWENT;
  eServerInfo.think = world_server_rules_frame;
  eServerInfo.nextthink = time + 0.1;
  return eServerInfo;
};

void() world_server_rules_frame={
  
  self.think = world_server_rules_frame;
  self.nextthink = time + 0.1;
};

float( float isNew, float changedFlags ) world_rules_sendEntity={
  
  //SendEnt header
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteCoord( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_MAP_RULES );
  //==================================================
  if( (changedFlags & SENDFLAG_GAMETYPE) ){
    WriteByte( MSG_ENTITY, self.gameType );
  }
  
  if( (changedFlags & SENDFLAG_STARTTIME) ){
    WriteCoord( MSG_ENTITY, self.timeStart );
  }
  
  if( (changedFlags & SENDFLAG_SERVERFLAGS) ){
    WriteCoord( MSG_ENTITY, self.serverFlags );
  }
  
  if( (changedFlags & SENDFLAG_MISSION_STATUS) ){
    WriteByte( MSG_ENTITY, self.missionStatus );
  }
  
  if( (changedFlags & SENDFLAG_MISSION_RESULT) ){
    WriteByte( MSG_ENTITY, self.missionResult );
  }
  
  if( (changedFlags & SENDFLAG_RULE_LIMIT_FRAG) ){
    //STAT_FRAGLIMIT
  }
  
  if( (changedFlags & SENDFLAG_NEWENT) ){
    WriteString( MSG_ENTITY, cvar_string("hostname") );
    WriteString( MSG_ENTITY, cvar_string("sv_about"));
  }
  
  if( (changedFlags & SENDFLAG_RULE_LIMIT_TIME) ){
    //STAT_TIMELIMIT
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
  return TRUE;
};

void() world_server_setRules={
  

};
#endif

#ifdef CSQC
entity() world_ini_serverInfo={

};
void( float isNew, float changeFlags) world_rules_readEntity={
  local string tempHostName;
  local string tempAbout;
  local string tempNextMap;
  local float nextGameType;
  local float nextStartTime;
  local float nextServerFlags;
  local float nextMissionStatus;
  local float nextMissionResult;
  local float nextRuleFrag;
  local float nextRuleTime;
  
  if( isNew ){
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    setmodel(self, "q3mdl/testball.md3");
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
    ENT_SERVER_INFO = self;
  }
  //SendEnt header
  //==================================================
  if( (changeFlags & SENDFLAG_GAMETYPE) ){
    self.gameType = ReadByte();
  }
  if( (changeFlags & SENDFLAG_STARTTIME) ){
    self.timeStart = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_SERVERFLAGS) ){
    self.serverFlags = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_MISSION_STATUS) ){
    self.missionStatusPrev = self.missionStatus;
    self.missionStatus = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_MISSION_RESULT) ){
    self.missionResult = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_RULE_LIMIT_FRAG) ){
    if( self.gameType != GAMEMODE_CAMPAIGN && self.gameType != GAMEMODE_COOP ){
      self.ruleFraglimit = getstatf(STAT_FRAGLIMIT);
    }
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    tempHostName = ReadString();
    tempAbout = ReadString();
    cacheGlobalString(self.netname, tempHostName)
    cacheGlobalString(self.svAbout, tempAbout)
  }
  
  if( (changeFlags & SENDFLAG_RULE_LIMIT_TIME) ){
    if( self.gameType != GAMEMODE_CAMPAIGN && self.gameType != GAMEMODE_COOP ){
      self.ruleTimelimit = getstatf(STAT_TIMELIMIT);
    }
  }
  if( (changeFlags & SENDFLAG_MAP_NEXT) ){
    tempNextMap = ReadString();
    if( strlen(self.nextMap) > 0 && strlen(tempNextMap) > 0){
      strunzone(self.nextMap);
      strunzone(SV_NEXTMAP);
    }
    self.nextMap = strzone(tempNextMap);
    SV_NEXTMAP = strzone(self.nextMap);
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
  
  //cvar_set("gamemode", ftos(self.gameType));
  if(CLIENT_player_state == PLAYER_CONNECT ){
    cl_set_savepath(self.gameType, (self.serverFlags & SVFLAG_ITEMOVER) );
  }
};
#endif