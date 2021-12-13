/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 07/02/2019
Overview: 
  Extension functions to world.qc 
  these functions are here for their abstraction level.
*/

void() world_metal_ini={
  
  DEPLOY_ID_COUNT = 0;
  
  sv_world_load_items();
  
  registercvar("saveslot", "0", CF_SERVER | CF_SERVER_FROM_CLIENT);
  registercvar("gamemode", "1", CF_SERVER | CF_SERVER_FROM_CLIENT);
  registercvar("sv_serverflags", "0", CF_ARCHIVE | CF_SERVER | CF_SERVER_FROM_CLIENT);
  registercvar("sv_about", "Default About Message", CF_ARCHIVE | CF_SERVER | CF_SERVER_FROM_CLIENT);
  
  if( cvar("coop") ){
    GAMETYPE = GAMEMODE_COOP;
    AI_RATE = AI_RATE_NET;
    NODEGRAPH_queue_timeout = NODEGRAPH_QUEUE_TIMEOUT_NET;
    NODEGRAPH_MAX_REQUEST = NODEGRAPH_MAX_REQUEST_NET;
  }
  else if( cvar("deathmatch") ){
    if( cvar("teamplay") ){
      GAMETYPE = GAMEMODE_TEAMDM;
      TEAM_SURVEST_TOTAL = 0;
      TEAM_MILITAR_TOTAL = 0;
    }
    else{
      GAMETYPE = GAMEMODE_DM;
    }
    AI_RATE = AI_RATE_NET;
    NODEGRAPH_queue_timeout = NODEGRAPH_QUEUE_TIMEOUT_NET;
    NODEGRAPH_MAX_REQUEST = NODEGRAPH_MAX_REQUEST_NET;
  }
  else{
    GAMETYPE = GAMEMODE_CAMPAIGN;
    AI_RATE = AI_RATE_LOCAL;
    NODEGRAPH_queue_timeout = NODEGRAPH_QUEUE_TIMEOUT_LOCAL;
    NODEGRAPH_MAX_REQUEST = NODEGRAPH_MAX_REQUEST_LOCAL;
  }
  cvar_set("gamemode", ftos(GAMETYPE));
  
  //Mission unit stat totals
  MISSION_STATUS = 0;
  MISSION_TOTAL_PSC = 0;
  MISSION_TOTAL_SURVEST = 0;
  MISSION_TOTAL_MILITAR = 0;

  MISSION_LOSSES_PSC = 0;
  MISSION_LOSSES_SURVEST = 0;
  MISSION_LOSSES_MILITAR = 0;

  serverflags = cvar("sv_serverflags");
  if(world.itemOverride){
    serverflags = serverflags | SVFLAG_ITEMOVER;
  }
  if( world.ignoreSave || world.animaticOnly ){
    serverflags = serverflags | SVFLAG_NOSAVE;
  }
  ENT_SERVER_INFO = world_ini_serverInfo_ent();
  
  world_ini_serverinfo();

  //kept in numerical order for easy reference.
  addstat(STAT_RAM, AS_INT, ramUp);
  
  addstat(STAT_TARGET_HIT_PARTS, AS_FLOAT, statTargetHitParts);
  
  addstat(STAT_PLAYER_STATE, AS_FLOAT, playerState);
  
  addstat(STAT_PLR_HITDIR, AS_FLOAT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_FLOAT, stat_ret_dist);
  
  addstat(STAT_TARGET_HP_TORSOCENTER, AS_INT, stat_target_hp_torsoCenter);
  addstat(STAT_TARGET_HP_TORSOLEFT, AS_INT, stat_target_hp_torsoLeft);
  addstat(STAT_TARGET_HP_TORSORIGHT, AS_INT, stat_target_hp_torsoRight);
  addstat(STAT_TARGET_HP_ARMLEFT, AS_INT, stat_target_hp_armLeft);
  addstat(STAT_TARGET_HP_ARMRIGHT, AS_INT, stat_target_hp_armRight);
  addstat(STAT_TARGET_HP_LEGS, AS_INT, stat_target_hp_legs);
    
  addstat(STAT_CLIENT_HP_TORSOCENTER, AS_INT, stat_client_hp_torsoCenter);
  addstat(STAT_CLIENT_HP_TORSOLEFT, AS_INT, stat_client_hp_torsoLeft);
  addstat(STAT_CLIENT_HP_TORSORIGHT, AS_INT, stat_client_hp_torsoRight);
  addstat(STAT_CLIENT_HP_ARMLEFT, AS_INT, stat_client_hp_armLeft);
  addstat(STAT_CLIENT_HP_ARMRIGHT, AS_INT, stat_client_hp_armRight);
  addstat(STAT_CLIENT_HP_LEGS, AS_INT, stat_client_hp_legs);
  
  addstat(STAT_WEAPON_RELOAD_1, AS_FLOAT, statWeaponReload1);
  addstat(STAT_WEAPON_RELOAD_2, AS_FLOAT, statWeaponReload2);
  addstat(STAT_WEAPON_RELOAD_3, AS_FLOAT, statWeaponReload3);
  addstat(STAT_WEAPON_RELOAD_4, AS_FLOAT, statWeaponReload4);
  addstat(STAT_WEAPON_RELOAD_5, AS_FLOAT, statWeaponReload5);
  addstat(STAT_WEAPON_RELOAD_6, AS_FLOAT, statWeaponReload6);
  addstat(STAT_WEAPON_RELOAD_7, AS_FLOAT, statWeaponReload7);
  addstat(STAT_WEAPON_RELOAD_8, AS_FLOAT, statWeaponReload8);
  addstat(STAT_WEAPON_RELOAD_9, AS_FLOAT, statWeaponReload9);
  
  addstat(STAT_RAM_VALUE, AS_INT, ramTracker);
  //addstat(STAT_LCK_STT, AS_FLOAT, targLockState); //2.0.0: lock-on not timer-based anymore
  
  addstat(STAT_PLR_REP, AS_FLOAT, stat_plr_rep);
  
  //setup wind settings
  if( !world.wind ){
    WINDDIR = '-15 90 3';
  }else{
    WINDDIR = world.wind;
  }
  
  WeatherDominator = spawn();
  setsize(WeatherDominator, '-1 -1 -1', '1 1 1');
  setorigin(WeatherDominator, world.origin);
  WeatherDominator.movetype = MOVETYPE_NONE;
  WeatherDominator.solid = SOLID_NOT;
  WeatherDominator.wind = WeatherDominator.ai_angleLimits = WINDDIR;
  //sets variance limits for wind so it doesn't wrap-around its rotation.
  WeatherDominator.wind_x = anglemod( WeatherDominator.wind_x - 10);
  WeatherDominator.wind_y = anglemod( WeatherDominator.wind_y - 35);
  WeatherDominator.wind_z = WeatherDominator.wind_z - 2;
  WeatherDominator.ai_angleLimits_x = anglemod( WeatherDominator.ai_angleLimits_x + 10);
  WeatherDominator.ai_angleLimits_y = anglemod( WeatherDominator.ai_angleLimits_y + 35);
  WeatherDominator.ai_angleLimits_z = WeatherDominator.ai_angleLimits_z + 2;
  WeatherDominator.think = WeatherDominator_think;
  WeatherDominator.nextthink = time + (random() * 0.085);
  
  MAP_UNLOCK_MECHS = world.unlockMechs;
  MAP_UNLOCK_EQUIP = world.unlockEquip;
  
  nodegraph_edgelinker = spawn();
  nodegraph_edgelinker.classname = strzone("nodegraph_edgelinker");
  setmodel(nodegraph_edgelinker, "q3mdl/testball.md3");
  setsize(nodegraph_edgelinker, nodegraph_edgelinker.mins, nodegraph_edgelinker.maxs);
  setorigin(nodegraph_edgelinker, world.origin);
  
  world_get_maplist();
  
  world_nodegraph_import();
};

/*
  SERVER feature - current states of server that's sent to all players when they connect.
*/
void() world_ini_serverinfo={
  ENT_SERVER_INFO.gameType = GAMETYPE;
  ENT_SERVER_INFO.timeStart = time;
  ENT_SERVER_INFO.timeEnd = time + (cvar("timelimit") * 60);
  ENT_SERVER_INFO.serverFlags = serverflags;
  ENT_SERVER_INFO.worldtype = world.worldtype;
  ENT_SERVER_INFO.missionStatus = MISSION_STATUS_READY;
  ENT_SERVER_INFO.missionResult = 0;
  ENT_SERVER_INFO.nextMap = strzone(sv_nextmap);
  ENT_SERVER_INFO.svAbout = strzone(strcat("svabout ", cvar_string("sv_about"), "\n"));
  
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
  
  if( ENT_SERVER_INFO.gameType == GAMEMODE_DM || ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
    if( cvar("fraglimit") > 0 ){
      ENT_SERVER_INFO.ruleFraglimit = cvar("fraglimit");
      ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_FRAG;
    }
    if( cvar("timelimit") > 0 ){
      ENT_SERVER_INFO.ruleTimelimit = cvar("timelimit");
      ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_TIME;
    }
  }
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    ENT_SERVER_INFO.saveSlot = cvar("saveslot");
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_SAVESLOT;
  }
  
  ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_STARTTIME;
  
  ENT_SERVER_INFO.endRound = 0;
};

/*
  finds the closest fog settings for the unit in question.
*/
void() world_get_fog={
  local entity this, theFog, found;
  local float radi;
  local float dist;
  local float front;
  
  this = self;
  theFog = findchain(classname, "map_change_fog");
  radi = 10000;
  
  while( theFog ){
    front = FALSE;
    dist = vlen( theFog.origin - self.origin );
    if( dist < radi ){
      self = theFog;
        front = ai_check_targ_infront( this, 0.5, FALSE ); 
      self = this;
      if( front ){
        radi = dist;
        found = theFog;
      }
    }
    theFog = theFog.chain;
  }
  
  if( !found ){
    found = world;
  }
  
  self.fog_density = found.fog_density;
  self.fog_alpha = found.fog_alpha;
  self.fog_dist = found.fog_dist;
  self.fade = found.fade;
};

/*
  Put all weather control effects here.
  1) Handles WINDDIR variance.
*/
void() WeatherDominator_think={
  //wind shifter
  local float randPitch, randYaw, randSpeed;
  randPitch = 10 + (random() * 10);
  randYaw = 17 + (crandom() * 17);
  randSpeed = 1 + (crandom() * 2);
  randPitch = anglemod( WINDDIR_x + randPitch );
  randYaw = anglemod( WINDDIR_y + randYaw );
  randSpeed = randSpeed;
  if( randPitch < WeatherDominator.wind_x ){
    randPitch = WeatherDominator.wind_x;
  }
  if( WINDDIR_x > WeatherDominator.ai_angleLimits_x ){
    WINDDIR_x = WeatherDominator.ai_angleLimits_x;
  }
  if( randYaw < WeatherDominator.wind_x ){
    randYaw = WeatherDominator.wind_x;
  }
  if( randYaw > WeatherDominator.ai_angleLimits_y ){
    randYaw = WeatherDominator.ai_angleLimits_y;
  }
  if( randSpeed < WeatherDominator.wind_z ){
    randSpeed = WeatherDominator.wind_z;
  }
  if( randSpeed > WeatherDominator.ai_angleLimits_z ){
    randSpeed = WeatherDominator.ai_angleLimits_z;
  }
  WINDDIR_x = randPitch;
  WINDDIR_y = randYaw;
  WINDDIR_z = randSpeed;
  
  WeatherDominator.think = WeatherDominator_think;
  WeatherDominator.nextthink = time + 0.05;
};

/*
  Darkplaces extension, added for completeness.
    when progs exits, not on errors though!
*/
void() SV_Shutdown={
  if( strlen(SERVER_INFO) > 0 ){
    strunzone(SERVER_INFO);
  }
};

/*
  Darkplaces extension, added for completeness.
    when a savegame is loaded, this function is called
*/
void() RestoreGame={
  //I wish there was time to rebuild this feature - I didn't know it existed until recently.
  //I've adjusted darkMETAL engine to work more closely with this, but alas.
  // wishlist:
    // + rebuild player client data on restart
    // -> ALL vehicle data sent to client.
    // -> restore any child ents like Repair Bay's repairNode.
    // -> relink any ai_nodes.
};

/*
  SV_RULES - Deathmatch Server
*/
void() sv_rules_dm={
  local entity player;

  //Game FragLimit hit
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    if( ENT_SERVER_INFO.ruleFraglimit != FALSE ){
      for( player = nextent(world); player != world; player = nextent(player)){
        if( !(player.flags & FL_CLIENT) ){
          continue;
        }
        if( player.frags >= ENT_SERVER_INFO.ruleFraglimit ){
          ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
          ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_FRAG | SENDFLAG_MISSION_STATUS;
        }
      }
      
      if( ENT_SERVER_INFO.missionStatus ==  MISSION_STATUS_OVER ){
      }
    }
  }
  //Game TimeLimit hit
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    if( ENT_SERVER_INFO.timeEnd > FALSE ){
      if( time >= ENT_SERVER_INFO.timeEnd ){
        ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
        ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_TIME | SENDFLAG_MISSION_STATUS;
      }
    }
  }
  //Objective hit
  //Limited Lives, no one left
};

/*
  SV_RULES - Team Deathmatch Server
*/
void() sv_rules_tdm={
  local entity player;
  local float teamTotalMil;
  local float teamTotalSrv;
  local float presetKillLimit;
  
  presetKillLimit = FALSE;
  //Game FragLimit hit
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    if( ENT_SERVER_INFO.ruleFraglimit != FALSE ){
      for( player = nextent(world); player != world; player = nextent(player)){
        if( !(player.flags & FL_CLIENT) ){
          continue;
        }
        if( player.faction == FACTION_MILITAR ){
          teamTotalMil = teamTotalMil + player.frags;
        }
        else if( player.faction == FACTION_SURVEST ){
          teamTotalSrv = teamTotalSrv + player.frags;
        }
        if( player.frags >= ENT_SERVER_INFO.ruleFraglimit ){
          presetKillLimit = TRUE;
        }
      }
      if( presetKillLimit ){
        ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
        ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_FRAG | SENDFLAG_MISSION_STATUS;
        return;
      }
      else{
        if( teamTotalMil >= ENT_SERVER_INFO.ruleFraglimit || teamTotalSrv >= ENT_SERVER_INFO.ruleFraglimit ){
          ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
          ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_FRAG | SENDFLAG_MISSION_STATUS;
          return;
        }
      }
      
      if( ENT_SERVER_INFO.missionStatus ==  MISSION_STATUS_OVER ){
      }
    }
  }
  
  //Game TimeLimit hit  
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    if( ENT_SERVER_INFO.timeEnd > FALSE ){
      if( time >= ENT_SERVER_INFO.timeEnd ){
        ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
        ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_RULE_LIMIT_TIME | SENDFLAG_MISSION_STATUS;
      }
    }
  }
  
  //Objective hit
  
  
  //Limited Lives, no one left
  
};

/*
  SV_RULES - Coop Mission
*/
void() sv_rules_coop={
  
};

/*
  SV_RULES - Campaign Mission
*/
void() sv_rules_camp={
  
};

/*
  CHECK SERVER GAME RULES
    ports -> CheckRules()
*/
void() sv_checkRules={
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    switch( ENT_SERVER_INFO.gameType ){
      case GAMEMODE_CAMPAIGN:
        sv_rules_camp();
        break;
      case GAMEMODE_COOP:
        sv_rules_coop();
        break;
      case GAMEMODE_TEAMDM:
        sv_rules_tdm();
        break;
      default:
        sv_rules_dm();
        break;
    }
    return;
  }
  else{
  //server has hit its rules checks, start gameover stuff here.
    sv_endServer();
  }
};


/*
  Ends Round for all players
*/
void() sv_endServer={
  local entity player;
  local entity this;
  local entity spot;
  local float sendPlayerState;
  
  local float mapCount;
  local float itr;
  
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_OVER ){
    //send game over data
        //TODO
    //Setup end-timer 1 - gives enough time to alert players of end mission, and prepare for score screen.   
    ENT_SERVER_INFO.missionStatus = MISSION_STATUS_ENDING;
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
    if( (ENT_SERVER_INFO.gameType == GAMEMODE_COOP) || (ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN) ){
      ENT_SERVER_INFO.endRoundTime = time + 8;
    }
    else{
      ENT_SERVER_INFO.endRoundTime = time + 5;
    }
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_ENDTIME;
    for( player = nextent(world); player.classname == "player"; player = nextent(player)){
      if( !(player.flags & FL_CLIENT) ){
        continue;
      }
      if( player.data_type == DATA_MECH ){
        player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_EFLAGS;
      }
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN || ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
        client_send_campaign_end_data( player );
      }
      else{
          //FL_NOSHOOT here so that players don't wrack up extra kills after the shot-buzzer sounds.
         player.flags = player.flags | FL_NOSHOOT;
         client_send_dm_end_data( player ); 
      }
    }
    return;
  }
  
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ENDING ){
    if( time > ENT_SERVER_INFO.endRoundTime ){
      spot = find(world, classname, "info_player_start");
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
        sendPlayerState = PLAYER_DEBRIEF;
      }
      else{
        sendPlayerState = PLAYER_INTERMSN;
      }
      for( player = nextent(world); player.classname == "player"; player = nextent(player)){
        if( !(player.flags & FL_CLIENT) ){
          continue;
        }
        this = self;
        self = player;
          if( (self.data_type == DATA_MECH) && (self.playerState > PLAYER_ANIM_STOP) ){
            ctrl_unit_clean_wgroups();
            client_push_player_info();
            ctrl_unit_cleanup_player();
            player_unmakeMech();
            player_makeObserver();
          }
          self.playerState = sendPlayerState;
          self.deadflag = DEAD_DEAD;
          setorigin( self, spot.origin );
        self = this;
      }
      ENT_SERVER_INFO.missionStatus = MISSION_STATUS_DONE;
      ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_STATUS;
      
      //only cycle maps if non-campaign/co-op
      if( ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN && ENT_SERVER_INFO.gameType != GAMEMODE_COOP){
        //treats WORLD_MAP_LIST like a pseudo-array (Strings are just arrays, right?)
        if( sv_nextmap != "" || strlen(sv_nextmap) > 0 ){
          strunzone(sv_nextmap);
          ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MAP_NEXT;
        }
        mapCount = tokenizebyseparator(WORLD_MAP_LIST, " ");
        if( mapCount > 1 ){
          for( itr = 1; itr < mapCount; itr = itr + 1 ){
            if( argv(itr) == mapname ){
              if( itr == (mapCount - 1) ){
                sv_nextmap = argv(1);
              }
              else{
                sv_nextmap = argv(itr + 1);
              }
              break;
            }
          }
        }
        else{
          sv_nextmap = argv(0) ;
        }
        sv_nextmap = strzone(sv_nextmap);
      }
      
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
        ENT_SERVER_INFO.endRoundTime = time + 2;
      }
      else{
        if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
          ENT_SERVER_INFO.endRoundTime = time + SERVER_SCORE_TIME_COOP;
        }
        else{
          ENT_SERVER_INFO.endRoundTime = time + SERVER_SCORE_TIME_DM;
        }
      }
      ENT_SERVER_INFO.endRound = TRUE;
    }
    return;
  }
  
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_DONE ){
    if( ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN ){
      if( time > ENT_SERVER_INFO.endRoundTime ){
        if( ENT_SERVER_INFO.endRound == TRUE ){
          ENT_SERVER_INFO.endRound = FALSE;
          if( sv_nextmap != "" ){
            changelevel(sv_nextmap);
          }
          else{
            changelevel(mapname);
          }
        }
      }
    }
    return;
  }
};


/*
  Populate item availability.
  Loads items from map_script files
  COOP - coop.sav
  DM - dm.sav
  TDM
    - team1.sav
    - team2.sav
*/
void() sv_world_load_items={
  switch( ENT_SERVER_INFO.gameType ){
    case GAMEMODE_COOP:
      mapfile_coop_load();
      break;
    case GAMEMODE_DM:
      mapfile_dm_load();
      break;
    case GAMEMODE_TEAMDM:
      mapfile_team_load();
      break;
  }
};

/*
  Real-time Light entity exporter functionality.
    RTLights file data can now be bound to maps at the map-editor layer.
    new entity - "realtimelights" can be found in misc.qc
    new console command.
    
    This writes an .rtlights file based on mapname, and written to /data/maps/rtexport/
      mostly because fopen() can't access higher level folders.
  
*/
void( float overrideFlag ) world_export_realtimelights={
  local string fileName;
  local float fileExists;
  local float developer;
  local entity lights;
  
  developer = cvar("developer");
  fileName = strcat("maps/", mapname, ".rtlights");
  if( developer ){
    cons_logAString("[INFO]-world_export_realtimelights()|[fileName]", fileName);  //DEBUG
  }
 
  fileExists = fopen(fileName, FILE_WRITE);
 
  //overrideFlag was false but file exists! so don't overwrite
  if( (fileExists == TRUE) && !overrideFlag ){
    if( developer ){
      cons_logAString("[WARN]-world_export_realtimelights()|", " Failed to write rtlights file, overrideFlag = FALSE but file already exists!");  //DEBUG
    }
    fclose(fileExists);
    return;
  }
  
  //if file doesnt exists
  lights = findchain(classname, "realtimelights_light");
  if( lights ){
    while(lights){
      world_export_realtimelights_write( lights, fileExists );
      lights = lights.chain;
    }
    if( developer ){
      cons_logAString("[INFO]-world_export_realtimelights()", "Write complete.");  //DEBUG
    }
  }
  else{
    if( developer ){
      cons_logAString("[WARN]-world_export_realtimelights()", "No {realtimelights_light} entities found in map file.");  //DEBUG
    }
  }
  fclose(fileExists);
};

void( entity lightEnt, float fileData ) world_export_realtimelights_write={
  local string lightData;
  
  if( lightEnt.rtlShadows == FALSE){
    fputs(fileData, "!");
  }    
  lightData = strcat( lightData, ftos(lightEnt.origin_x), " ", ftos(lightEnt.origin_y), " ", ftos(lightEnt.origin_z));
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlRadius) );
  lightData = strcat( lightData, " ", ftos(lightEnt.color_x)," ", ftos(lightEnt.color_y)," ", ftos(lightEnt.color_z) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlStyle) );
  lightData = strcat( lightData, " \"", lightEnt.vec_name,"\" " );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlCorona) );
  lightData = strcat( lightData, " ", ftos(lightEnt.angles_x), " ", ftos(lightEnt.angles_y), " ", ftos(lightEnt.angles_z) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlCoronaSize) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlAmbient) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlDiffuse) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlSpecular) );
  lightData = strcat( lightData, " ", ftos(lightEnt.rtlMode));
  if( lightData != "" ){
    fputs(fileData, lightData);
  }
  fputs(fileData, "\n");  //INFO - .rtlights files ALWAYS end with a \n
  
  if( cvar("developer") ){
    cons_log2Strings("[INFO]-{Writing RTLight Data} ", "-line-", "origin", vtos(lightEnt.origin)); //DEBUG
  }
};


/*
  so, rolling with PFLAGS_FULLDYNAMIC, these things appear to be quite expensive, I'd recommend using them in a limited 
  fashion. Maybe no more than a handful of lights per entity you want to attach them to, and definetly make sure they're
  removed with their parent ent.
*/
void( vector org, entity parent, float id, vector colr, float stile, float pFlags, vector angl, float skinNum, float lightRadius) world_dlight_make={
  local entity newLight;
  newLight = spawn();
  newLight.classname = "dynamicLight";
  newLight.owner = parent;
  newLight.color = colr;
  newLight.style = stile;
  newLight.pflags = pFlags;
  newLight.angles = angl;
  newLight.skin = skinNum;
  newLight.light_lev = lightRadius;
  newLight.data_idx = id;
  setsize( newLight, '0 0 0', '0 0 0');
  setorigin( newLight, org );
};

void( entity parent ) world_dlight_remove={
  local entity chaine;
  
  for( chaine = nextent(world); chaine.owner == parent; chaine = nextent(chaine) ){
    if( chaine.classname != "dynamicLight" ){
      continue;
    }
    chaine.think = SUB_Remove;
    chaine.nextthink = time + 0.1;
  }
};

/*
  send negative values to ignore changes, otherwise, 0 as a value will be used!
*/
void( entity parent, float lightId, vector newColor, float newRadius, float newStyle, vector newAngl) world_dlight_update={
  local entity myLight;
  
  for( myLight = findchainentity( owner, parent ); myLight != world; myLight = myLight.chain){
    if( lightId == -1 && myLight.data_idx == lightId ){
      if( newColor != '-1 -1 -1' ){
        myLight.color = newColor;
      }
      if( newRadius != -1 ){
        myLight.light_lev = newRadius;
      }
      if( newStyle != -1 ){
        myLight.style = newStyle;
      }
      if( newAngl != '-1 -1 -1' ){
        myLight.angles = newAngl;
      }
    }
  }
};

/**
  Nodegraph suite of functions and support.
*/

void() world_nodegraph_export_edgelinker_th={
  local float fileExists;
  local entity nodes;
  
  cons_logAString("[INFO]-world_export_nodegraph() edgelinker run ", ftos(self.count));  //DEBUG
  
  
  self.owner = NODEGRAPH_EXPORT_NODE[self.count];
  
  self.delay = 0; //reset edge id counter
  world_nodegraph_export_write_node(self.owner, fileExists );
  
  self.count = self.count + 1;
  if( self.count == self.wait ){
    cons_logAString("[INFO]-world_export_nodegraph()", "Write complete.");  //DEBUG
    fclose(self.data_idx);
    strunzone(self.classname);
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    
    //unfreeze and let AI act normally;
    for(nodes = nextent(world); nodes != world; nodes = nextent(nodes) ){
      if( nodes.data_type == DATA_MECH || nodes.data_type == DATA_VEHC ){
        nodes.spawnflags = nodes.spawnflags - (nodes.spawnflags & DEBUG_MODE);
        nodes.solid = SOLID_SLIDEBOX;
        nodes.movetype = MOVETYPE_STEP;
      }
    }
    return;
  }

  self.think = world_nodegraph_export_edgelinker_th;
  self.nextthink = time + 0.33;
};

void( float overrideFlag ) world_nodegraph_export_data={
  local string fileName;
  local float fileExists;
  local float developer;
  local entity nodes;
  local float nodeItr;
  local float nodeTotal;
  
  developer = cvar("developer");
  fileName = strcat(mapname, ".nodes");
  if( developer ){
    cons_logAString("[INFO]-world_export_nodegraph()|[", fileName);  //DEBUG
  }
 
  fileExists = fopen(fileName, FILE_WRITE);
  
  //overrideFlag was false but file exists! so don't overwrite
  if( (fileExists == TRUE) && !overrideFlag ){
    if( developer ){
      cons_logAString("[WARN]-world_export_nodegraph()|", " Failed to write nodes file, overrideFlag = FALSE but file already exists!");  //DEBUG
    }
    return;
  }
  
  //batch nodes
  for(nodes = nextent(world); nodes != world; nodes = nextent(nodes) ){
    if( nodes.classname != "ai_node_path" )
      continue;
    NODEGRAPH_EXPORT_NODE[nodeItr] = nodes;
    nodeItr = nodeItr + 1;
  }
  nodeTotal = nodeItr;
  
  //process
  if( NODEGRAPH_EXPORT_NODE[0] == world ){
    cons_logAString("[WARN]-world_export_nodegraph()", "No {ai_node_path} entities found in map file.");  //DEBUG
  }
  else{
    for(nodes = nextent(world); nodes != world; nodes = nextent(nodes) ){
      //edge links need to account for buildings but not moving units, instead we freeze and make them non-solid.
      if( nodes.data_type == DATA_MECH || nodes.data_type == DATA_VEHC ){
        nodes.spawnflags = nodes.spawnflags | DEBUG_MODE;
        nodes.solid = SOLID_NOT;
        nodes.movetype = MOVETYPE_NONE;
      }
    }
  
    nodegraph_edgelinker.data_idx = fileExists;
    nodegraph_edgelinker.count = 0;
    nodegraph_edgelinker.wait = nodeTotal;
    nodegraph_edgelinker.think = world_nodegraph_export_edgelinker_th;
    nodegraph_edgelinker.nextthink = time + 0.075;
    cons_logAString("[INFO]-world_export_nodegraph() total nodes ", ftos(nodeTotal));  //DEBUG
  }
};

/*
  attempts to link 2 nodes together and set edge data.
    RULES
      1) check direct LoS
        hit on SOLID_BSP, SOLID_BBOX, BOTCLIP
      2) 
*/
float( entity node, entity targNode ) world_nodegraph_export_edgelink={
  local vector edgeAngle;
  local float edgeLen;
  local float edgeLenquant;
  local float edgeLenItr;
  
  local vector edgeSegA;
  local vector edgeSegB;
  
  local vector trEdgeApos;
  //local float trEdgeAContents;
  
  local vector trEdgeBpos;
  //local float trEdgeBContents;
  
  local vector trEdgeAngl;
  
  local float edgeCheck;
  
  traceline( node.origin, targNode.origin, FALSE, node );
  
  if( trace_fraction == 1.0 ){
    edgeAngle = vectoangles(targNode.origin - node.origin);
    if( edgeAngle_x < NODEGRAPH_EDGE_ANGLE_MAX ){
      edgeAngle_x = 360 - edgeAngle_x;  //fixes a pitch-angle problem where sometimes the angle was inverted!
    }
    if( edgeAngle_x > NODEGRAPH_EDGE_ANGLE_MIN && edgeAngle_x < NODEGRAPH_EDGE_ANGLE_MAX){
      //rule out steep inclines right away.
      //cons_logAString(ftos(node.data_idx), strcat("fail ", ftos(targNode.data_idx), " pitch ", ftos(edgeAngle_x)));//debug
      return FALSE;
    }
    self.dphitcontentsmask =  self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY);
    //clear Los, get more granular.
    edgeLen = vlen(targNode.origin - node.origin);
    edgeLenquant = ceil(edgeLen / NODEGRAPH_EDGE_GRID);
    //now run the terrain poller
    edgeSegA = node.origin;
    makevectors(edgeAngle);
    edgeCheck = TRUE;
    for(edgeLenItr = 0; edgeLenItr < edgeLenquant; edgeLenItr = edgeLenItr + 1){
      if( !edgeCheck )
        continue;
      edgeSegB = edgeSegA + (v_forward * NODEGRAPH_EDGE_GRID);
      
      traceline(edgeSegA, edgeSegA + (v_up * -512), TRUE, node);
      trEdgeApos = trace_endpos;
      //trEdgeAContents = trace_dphitcontents;
      
      traceline(edgeSegB, edgeSegB + (v_up * -512), TRUE, node);
      trEdgeBpos = trace_endpos;
      //trEdgeBContents = trace_dphitcontents;
      //trailparticles(world, particleeffectnum("TE_LAS_RAIL"), edgeSegA, trEdgeApos);  //debug
      //trailparticles(world, particleeffectnum("TE_LAS_RAIL"), edgeSegB, trEdgeBpos);  //debug
      
      trEdgeAngl = vectoangles(trEdgeBpos - trEdgeApos);
      /*if(node.data_idx == NODEGRAPH_DBG_ID1 && targNode.data_idx == NODEGRAPH_DBG_ID2){
        trailparticles(world, particleeffectnum("TE_ESR_RAIL"), node.origin, targNode.origin);  //debug
        trailparticles(world, particleeffectnum("TE_REPAIR_RAIL"), edgeSegA, trEdgeApos);  //debug
        trailparticles(world, particleeffectnum("TE_REPAIR_RAIL"), edgeSegB, trEdgeBpos);  //debug
        trailparticles(world, particleeffectnum("TE_LAS_RAIL"), trEdgeApos, trEdgeBpos);  //debug
        cons_logAFloat("trEdgeAngl_x", trEdgeAngl_x);  //debug
      }*/
      
      if( trEdgeAngl_x > NODEGRAPH_EDGE_ANGLE_MIN && trEdgeAngl_x < NODEGRAPH_EDGE_ANGLE_MAX){
        //cons_logAString(ftos(node.data_idx), strcat("fail ", ftos(targNode.data_idx), " pitch ", ftos(trEdgeAngl_x), "| seg ", ftos(edgeLenItr)));//debug
        edgeCheck = FALSE;
      }
      //holding off on this change for a second.
      //if( (trEdgeAContents & (DPCONTENTS_LAVA | DPCONTENTS_SKY | DPCONTENTS_LIQUIDSMASK | DPCONTENTS_WATER | DPCONTENTS_BODY)) || (trEdgeBContents & (DPCONTENTS_LAVA | DPCONTENTS_SKY | DPCONTENTS_LIQUIDSMASK | DPCONTENTS_WATER | DPCONTENTS_BODY)) ){
      //  edgeCheck = FALSE;
      //}
      edgeSegA = edgeSegB;
    }
    self.dphitcontentsmask = rint(0);
    return edgeCheck;
  }
  else{
    //no proper Los based on 
    //self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY);
    //cons_logAString(ftos(node.data_idx), strcat(ftos(targNode.data_idx), " fail trace fraction ", ftos(trace_fraction)));//debug
    self.dphitcontentsmask = rint(0);
    return FALSE;
  }
};

/*
  prep edge cache for distance sorting
*/
void(entity thatNode) world_nodegraph_edge_empty_cache={
  local float eitr;
  local entity ecache;
  local vector ivec;
  
  local vector noZOrgA, noZOrgb;
  
  NODEGRAPH_edge_counter = 0;
  eitr = 0;
  while(eitr < NODE_ID_EXPORT_COUNT){
    ecache = NODEGRAPH_EXPORT_NODE[eitr];
    ivec_x = thatNode.data_idx;
    ivec_y = ecache.data_idx;
    
    noZOrgA_x = thatNode.origin_x;
    noZOrgA_y = thatNode.origin_y;
    
    noZOrgb_x = ecache.origin_x;
    noZOrgb_y = ecache.origin_y;
    
    ivec_z = vlen(noZOrgb - noZOrgA);
    NODEGRAPH_EXPORT_EDGE[eitr] = ivec;
    eitr = eitr + 1;
  }
};

void( entity iEdgNode, float weight ) world_nodegraph_edge_check_len={
  local float i, j;
  local float len1, len2;
  local vector eKey, eKey2;
  local vector ivec;
  //local vector ecache;  //for debug
  local float iFlag;
  
  for( i=1; i <= NODE_ID_EXPORT_COUNT - 1; i=i+1){
    eKey = NODEGRAPH_EXPORT_EDGE[i];
    j = i - 1;
    
    len1 = eKey_z;
    
    iFlag = FALSE;
    
    for(j = i - 1; j >= 0; j = j - 1){
    //while( ((j >= 0) && (len2 < len1)) ){
      eKey2 = NODEGRAPH_EXPORT_EDGE[j];
      len2 = eKey2_z;
      if( len2 > len1 ){
        ivec = NODEGRAPH_EXPORT_EDGE[j];
        NODEGRAPH_EXPORT_EDGE[j+1] = ivec;
        iFlag = TRUE;
      }
      else{
        break;
      }
      //j = j - 1;
    }
    if(iFlag){
      NODEGRAPH_EXPORT_EDGE[j + 1] = eKey;
    }
  }
  //dprint("SORTED NODE BY DIST\n");  //debug
  //for( i=0; i < NODE_ID_EXPORT_COUNT; i=i+1){
    //ecache = NODEGRAPH_EXPORT_EDGE[i];
    //dprint(sprintf("node[%u]- EDGE(%u)-WEIGHT{ %f }\n", ecache_x,ecache_y, ecache_z)); //debug
  //}
  //dprint("=============================\n");  //debug
};

void(entity node, float fileData ) world_nodegraph_export_write_node={
  
  local entity edgeNode;
  local float edgeMax;
  local float minDist;
  local float checkDist;
  local vector iEdge;
  
  local string strLineData;
  local string strEdgeData;
 
  strLineData = "";
  
  //actually, line number mostly matches the ID's because they're exported in order
  //strLineData = strcat(strLineData, ftos(node.data_idx), " ");
  
  strLineData = strcat(strLineData, ftos(node.origin_x), " ");
  
  strLineData = strcat(strLineData, ftos(node.origin_y), " ");
  
  strLineData = strcat(strLineData, ftos(node.origin_z), " ");
  
  world_nodegraph_edge_empty_cache(node);
  world_nodegraph_edge_check_len(node, 512);
  
  strEdgeData = " ";
  
  minDist = 0;
  edgeMax = 0;
  for(self.delay = 0; self.delay < self.wait; self.delay = self.delay + 1 ){
    iEdge = NODEGRAPH_EXPORT_EDGE[self.delay];
    if( edgeMax >= 6)
      break;
    if( iEdge_y == node.data_idx )
      continue;
    edgeNode = NODEGRAPH_EXPORT_NODE[iEdge_y];
    if( !world_nodegraph_export_edgelink(node, edgeNode) )
      continue;
    checkDist = iEdge_z;
    if( checkDist > 512 )
      continue;
    
    edgeMax = edgeMax + 1;
    //cons_logAString(ftos(node.data_idx), strcat("linked for ", ftos(edgeNode.data_idx)));//debug
    
    strLineData = strcat(strLineData,ftos(iEdge_y), " ",sprintf("%0.3f",iEdge_z));
    
    //clean formatting
    iEdge = NODEGRAPH_EXPORT_EDGE[self.delay + 1];
    if( edgeMax < 6 && iEdge_y != node.data_idx){
      strLineData = strcat(strLineData, " ");
    }
  }
  if( edgeMax == 0 ){
    //fputs(fileData, "NO EDGES FOUND");
  }
  strLineData = strcat(strLineData, "\n");
  fputs(fileData, strLineData);
};

/*
  Called by world
*/
void() world_nodegraph_import={
  local float checkNodeItr;
  
  //node_t check; //for debug
  
  checkNodeItr = 0;
  //prepare the data
  while( checkNodeItr < NODEGRAPH_MAX ){
    NODE_check = NODEGRAPH_DATA[checkNodeItr];
    NODE_check.id = -1;
    checkNodeItr = checkNodeItr + 1;
  }
  
  checkNodeItr = 0;
  
  //load the actual file
  NODE_ID_COUNT = world_nodegraph_read_file();
  if( cvar("developer") ){
    dprint("VERIFY NODEGRAPH ARRAY SIZE (NODE_ID_COUNT): ", ftos(NODE_ID_COUNT), "\n"); //debug
  }
  if( NODE_ID_COUNT > 0 ){
    NODEGRAPH_LOADED = TRUE;
    if( cvar("developer") ){
      //just a double back check that data was loaded proper.
      //dprint("NODEGHRAPH LOADED ", ftos(NODEGRAPH_LOADED), "\n"); //debug
      
      
     // for(checkNodeItr = 0; checkNodeItr < NODE_ID_COUNT; checkNodeItr = checkNodeItr + 1){
        //check = NODEGRAPH_DATA[checkNodeItr];
        //if(check.id > -1){
          //dprint("NODE START---------------------------\n"); //debug
          //dprint(strcat(ftos(check.id),"\n")); //debug
          //dprint(strcat(vtos(check.orig),"\n")); //debug
          //dprint(strcat("(",ftos(check.nodes[0]),"-",ftos(check.edge[0]),")")); //debug
          //dprint(strcat("(",ftos(check.nodes[1]),"-",ftos(check.edge[1]),")")); //debug
          //dprint(strcat("(",ftos(check.nodes[2]),"-",ftos(check.edge[2]),")")); //debug
          //dprint(strcat("(",ftos(check.nodes[3]),"-",ftos(check.edge[3]),")")); //debug
          //dprint(strcat("(",ftos(check.nodes[4]),"-",ftos(check.edge[4]),")")); //debug
          //dprint(strcat("(",ftos(check.nodes[5]),"-",ftos(check.edge[5]),")")); //debug
         // dprint("\nEDGE END---------------------------\n"); //debug
        //}
      //}
    }
  }
};

/*
  The specific function to read "data/<map>/.node"
*/
float() world_nodegraph_read_file={
  local float fileHandle;
  local string fileName;
  local string fileLine;
  local float nodeCounter;
  
  local float tknTotal;
  local float tknCount;
  local float nodeDataId;
  local vector nodeDataOrg;
  
  local string tknEdgeId;
  
  local float edgeItr;
  local float edgeDataId;
  local float edgeDataLen;
  
  fileName = strcat("maps/",mapname,"/",mapname,".nodes");
  fileHandle = fopen(fileName, FILE_READ);
  
  if( cvar("developer") ){
    dprint(strcat("NODEGHRAPH FILE=", fileName,"\n"));  //debug
  }
  
  if( fileHandle > -1 ){
    nodeCounter = 0;
    fileLine = fgets(fileHandle);
    while( fileLine != ""){
      if( nodeCounter >= NODEGRAPH_MAX ){
        break;
      }
      
      tknTotal = rint(0);
      tknTotal = tokenizebyseparator(fileLine, " ");
      tknCount = 0;
      if( tknTotal >= 3 ){
        //valid node, just possibly no edge data.
        
        //node id is only considered in engine,
        //the order of nodes exported is also set by engine.
        //hopefully no one scrambled the .nodes file.
        nodeDataId = nodeCounter;
        
        //populate origin
        nodeDataOrg_x = stof(argv(tknCount));
        tknCount = tknCount + 1;
        
        nodeDataOrg_y = stof(argv(tknCount));
        tknCount = tknCount + 1;
        
        nodeDataOrg_z = stof(argv(tknCount));
        tknCount = tknCount + 1;
        
        nodegraph_read_new_node(nodeDataId, nodeDataOrg);
        
        //edge data
        edgeItr = 0;
        edgeDataId = 0;
        
        edgeDataLen = 0;
        while( edgeItr < 6 ){
          if(tknCount < tknTotal){
            tknEdgeId = argv(tknCount);
            edgeDataId = stof(tknEdgeId);
            tknCount = tknCount + 1;
            
            edgeDataLen =  stof(argv(tknCount));
            tknCount = tknCount + 1;
          }
          else{
            edgeDataId = -1;
            edgeDataLen = 0;
          }
          nodegraph_read_edge( nodeDataId, edgeItr, edgeDataId, edgeDataLen );
          edgeItr = edgeItr + 1;
        }
        
        nodeCounter = nodeCounter + 1;
      }
      fileLine = fgets(fileHandle);
    }
    fclose(fileHandle);
  }
  return nodeCounter;
};

void( float start, float end ) world_nodegraph_test_graph={
  if( NODEGRAPH_LOADED ){
    node_t nodeStart;
    node_t nodeEnd;
    
    nodeStart = NODEGRAPH_DATA[start];

    nodeEnd = NODEGRAPH_DATA[end];
    if( cvar("developer") ){
      dprint(strcat("NODEGHRAPH DEBUG(",ftos(start),")-(", ftos(end),")\n"));  //debug
      dprint(sprintf("NODEGHRAPH DEBUG[%s](%s) - [%s](%s)\n", ftos(nodeStart.id), vtos(nodeStart.orig), ftos(nodeEnd.id), vtos(nodeEnd.orig)));//debug
    }
    nodegraph_debug_graph(nodeStart.orig, nodeEnd.orig);
  }
  else{
    if( cvar("developer") ){
      dprint("NODEGHRAPH not loaded!\n"); //debug
    }
  }
};



/*
  fires a chosen target entity if it exists
*/
void( string targName ) world_debug_targ={

  local entity t;
  local entity c;
  local entity oslf;
  
  local float fire;
  
  fire = FALSE;
  
  c = find(world, classname, "player");
  
  for( t = nextent(world); t != world; t = nextent(t) ){
    if( t.targetname != targName ){
      if( t.classname == targName ){
        fire = TRUE;
      }
      else{
        continue; 
      }
    }
    else{
      fire = TRUE;
    }
    if( fire ){
      if( t.classname == "nav_rho" ){
        if( t.touch ){
          other = c;
          oslf = self;
          self = t;
            self.touch();
          self = oslf;
        }
      }
      else if( t.classname == "trigger_once" || t.classname == "trigger_multi" ){
        if( t.target ){
          other = c;
          oslf = self;
          self = t;
            self.use();
          self = oslf;
        }
      }
    }
  }

};

/*
  used with server flag (ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR)
  gathers all the deathmatch nodes.
*/
entity() world_deathmatch_random_spawn={
  local entity nodeHead;
  local entity node;
  local entity baddies;
  local float proxCount;
  local float runTotal;
  local entity theNode;
  local entity rando;
  local float nodeDice;
  local float emptyNodes;
  
  runTotal = 16;  //total players possible in ANY server config
  rando = world;
  emptyNodes = 0;
  for(node = nextent(world); node != world; node = nextent(node) ){
    if(node.classname != "map_deploy_point"){
      continue;
    }
    if(node.faction != FACTION_ALL){
      continue;
    }
    proxCount = 0;
    baddies = nextent(world);
    while( baddies != world ){
      if( (baddies.flags & FL_CLIENT) ){
        if( baddies.data_type == DATA_MECH ){
          if( baddies != self ){
            traceline(node.origin, baddies.origin, FALSE, node);
            if(trace_fraction == 1.0){
              proxCount = proxCount + 1;
            }
            else{
              if(vlen(baddies.origin - node.origin) <= AI_RANGE_S){
                proxCount = proxCount + 1;
              }
            }
          }
        }
      }
      baddies = nextent(baddies);
    }
    if(proxCount <= runTotal){
      runTotal = proxCount;
      theNode = node;
      if( proxCount == 0){
        emptyNodes = emptyNodes + 1;
        if( rando != world ){
          rando.partNext = node;
          node.partPrev = rando;
          rando = node;
        }
        else{
          //first time find
          nodeHead = rando = node;
          nodeHead.partPrev = world;
        }
      }
    }
  }
  if( emptyNodes == 0 ){
    return theNode;
  }
  
  nodeDice = 0.9;
  rando = nodeHead;
  while( rando != world ){
    if( rando.classname == "map_deploy_point" ){
      if( random() > 0.5 ) {
        return rando;
      }
      else{
        if( random() > nodeDice ){
          return rando;
        }
        else{
          nodeDice = nodeDice - 0.15; //creates math certainty to pick any node.
        }
      }
    }
    rando = rando.partNext;
  }
  return rando;
};

//TDM/DM network games use this list.
//string WORLD_MAP_LIST;
void() world_get_maplist={
  local string handOff;
  local float fileHandle;
  local string ln;
  
  if( WORLD_MAP_LIST != "" || strlen(WORLD_MAP_LIST) > 0){
    handOff = WORLD_MAP_LIST;
    strunzone(handOff);
    WORLD_MAP_LIST = "";
  }
  
  fileHandle = fopen("sv_maplist.txt", FILE_READ);
  
  if(fileHandle != -1){
    ln = fgets(fileHandle);
    while(ln != "" || strlen(ln) > 0){ 
      if( substring(ln,0, 2) != "//" ){
        WORLD_MAP_LIST = strcat(WORLD_MAP_LIST, " ", ln);
      }
      ln = fgets(fileHandle);
    } 
    fclose(fileHandle);
  }
  
  WORLD_MAP_LIST = strzone(WORLD_MAP_LIST);
  
  if( cvar("developer") ){
    dprint("WORLD_MAP_LIST ", WORLD_MAP_LIST, "\n"); //debug
  }
};