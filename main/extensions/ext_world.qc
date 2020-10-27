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
  if( cvar("coop") ){
    GAMETYPE = GAMEMODE_COOP;
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
  }
  else{
    GAMETYPE = GAMEMODE_CAMPAIGN;
  } 
  cvar_set("gamemode", ftos(GAMETYPE));

  sv_world_load_items();

  registercvar("campaign", "0", 0); 
  registercvar("saveslot", "0", 0);
  registercvar("gamemode", "0", 0);
  registercvar("cl_hud_alpha", "1", 1);
  registercvar("cl_hud_color", "0", 1);
  //registercvar("cl_hud_sway", "0", 1);
  registercvar("cl_team", "0", 2);
  registercvar("sv_serverflags", "0", 0);
  
  //Mission unit stat totals
  MISSION_STATUS = MISSION_STATUS_READY;
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
  if(world.ignoreSave || world.animaticOnly ){
    serverflags = serverflags | SVFLAG_NOSAVE;
  }
  
  STARTTIME = time;
  if( cvar("timelimit") > FALSE ){
    ENDTIME_LIMIT = time + (cvar("timelimit") * 60);
  }
  else{
    ENDTIME_LIMIT = -1; //no time limit
  }
  ENDROUND = 0;
  
  world_ini_serverinfo();

  //kept in numerical order for easy reference.
  //addstat(STAT_PLAYER_DEADFLAG, AS_INT, deadflag);
  addstat(STAT_ACCURACY, AS_FLOAT, accuracy);
  
  addstat(STAT_RAM, AS_FLOAT, ramUp);
  
  addstat(STAT_PLAYER_STATE, AS_INT, playerState);
  //addstat(STAT_PLAYER_WEAPONS_STATE, AS_INT, stat_player_weapons_state);
  
  addstat(STAT_PLR_RADMOD, AS_INT, stat_rdr_mode);
  addstat(STAT_PLR_HITDIR, AS_INT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_INT, stat_ret_dist);
  
  addstat(STAT_TRG_FACE, AS_INT, stat_trg_face);
  addstat(STAT_PLAYER_DEATHS, AS_INT, playerDeaths);
    
  addstat(STAT_TARGET_HP_TORSOCENTER, AS_FLOAT, stat_target_hp_torsoCenter);
  addstat(STAT_TARGET_HP_TORSOLEFT, AS_FLOAT, stat_target_hp_torsoLeft);
  addstat(STAT_TARGET_HP_TORSORIGHT, AS_FLOAT, stat_target_hp_torsoRight);
  addstat(STAT_TARGET_HP_ARMLEFT, AS_FLOAT, stat_target_hp_armLeft);
  addstat(STAT_TARGET_HP_ARMRIGHT, AS_FLOAT, stat_target_hp_armRight);
  addstat(STAT_TARGET_HP_LEGS, AS_FLOAT, stat_target_hp_legs);
    
  addstat(STAT_CLIENT_HP_TORSOCENTER, AS_FLOAT, stat_client_hp_torsoCenter);
  addstat(STAT_CLIENT_HP_TORSOLEFT, AS_FLOAT, stat_client_hp_torsoLeft);
  addstat(STAT_CLIENT_HP_TORSORIGHT, AS_FLOAT, stat_client_hp_torsoRight);
  addstat(STAT_CLIENT_HP_ARMLEFT, AS_FLOAT, stat_client_hp_armLeft);
  addstat(STAT_CLIENT_HP_ARMRIGHT, AS_FLOAT, stat_client_hp_armRight);
  addstat(STAT_CLIENT_HP_LEGS, AS_FLOAT, stat_client_hp_legs);
  
  addstat(STAT_RAM_VALUE, AS_FLOAT, ramTracker);
  addstat(STAT_LCK_STT, AS_INT, targLockState);
  
  addstat(STAT_PLR_REP, AS_INT, stat_plr_rep);
  
  switch( world.worldtype ){
    case 1:
      TE_STOMP_TYPE = particleeffectnum("TE_STOMP_ICE");
      break;
    case 2:
      TE_STOMP_TYPE = particleeffectnum("TE_STOMP_CITY");
      break;
    case 3:
      TE_STOMP_TYPE = particleeffectnum("TE_STOMP_BADLANDS");
      break;
    case 4:
      TE_STOMP_TYPE = particleeffectnum("TE_STOMP_TUNDRA");
      break;
    default:
      TE_STOMP_TYPE = particleeffectnum("TE_STOMP_SAND");
      break;
  }
  
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
  
  //ini AI globals
  enemy_infront = 1.0;
  enemy_vis = 1.0;
  enemy_range = 1.0;
  enemy_dist = 1.0;
  combat_dist = 1.0;
  combat_roll = 1.0;
  
  nodegraph_edgelinker = spawn();
  nodegraph_edgelinker.classname = strzone("nodegraph_edgelinker");
  setmodel(nodegraph_edgelinker, "q3mdl/testball.md3");
  setsize(nodegraph_edgelinker, nodegraph_edgelinker.mins, nodegraph_edgelinker.maxs);
  setorigin(nodegraph_edgelinker, world.origin);
  
  world_get_maplist();
  if( cvar("developer") ){
    dprint("WORLD_MAP_LIST ", WORLD_MAP_LIST, "\n"); //debug
  }
  
  NODEGRAPH_LOADED = world_nodegraph_read_file();
  if( cvar("developer") ){
    dprint("NODEGHRAPH LOADED ", ftos(NODEGRAPH_LOADED), "\n"); //debug
  }
};

void() world_ini_serverinfo={
  local string serverInfo;
  serverInfo = strcat("svinfo ", ftos(STARTTIME), " ");
  serverInfo = strcat(serverInfo, ftos(MISSION_STATUS)," ");
  serverInfo = strcat(serverInfo, ftos(GAMETYPE)," ");
  serverInfo = strcat(serverInfo, ftos(serverflags)," ");
  serverInfo = strcat(serverInfo, ftos(cvar("timelimit"))," ");
  serverInfo = strcat(serverInfo, ftos(world.worldtype)," ");
  if( GAMETYPE == GAMEMODE_CAMPAIGN ){
    serverInfo = strcat(serverInfo, ftos(cvar("saveslot")),"\n");
  }
  SERVER_INFO = strzone(serverInfo);
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
  if( MISSION_STATUS == MISSION_STATUS_ACTIVE ){
    if( cvar("fraglimit") != FALSE ){
      for( player = nextent(world); player != world; player = nextent(player)){
        if( !(player.flags & FL_CLIENT) ){
          continue;
        }
        if( player.frags >= cvar("fraglimit") ){
          MISSION_STATUS = MISSION_STATUS_OVER;
        }
      }
      
      if( MISSION_STATUS ==  MISSION_STATUS_OVER ){
      }
    }
  }
  //Game TimeLimit hit
  if( MISSION_STATUS == MISSION_STATUS_ACTIVE ){
    if( ENDTIME_LIMIT != -1 ){
      if( time >= ENDTIME_LIMIT ){
        MISSION_STATUS = MISSION_STATUS_OVER;
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

  //Game FragLimit hit
  if( cvar("fraglimit") != FALSE ){
    for( player = nextent(world); player != world; player = nextent(player)){
      if( !(player.flags & FL_CLIENT) ){
        continue;
      }
      if( player.frags >= cvar("fraglimit") ){
        MISSION_STATUS = MISSION_STATUS_OVER;
      }
    }
    
    if( MISSION_STATUS == MISSION_STATUS_OVER ){
    }
    return;
  }
  
  //Game TimeLimit hit  
  if( ENDTIME_LIMIT != -1 ){
    if( time > ENDTIME_LIMIT ){
      MISSION_STATUS = MISSION_STATUS_OVER;
      return;
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
  GAMETYPE = cvar("gamemode");
  if( MISSION_STATUS == MISSION_STATUS_ACTIVE ){
    switch( GAMETYPE ){
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
  
  if( MISSION_STATUS == MISSION_STATUS_OVER ){
    client_send_server_info_update();
    //send game over data
        //TODO
    //Setup end-timer 1 - gives enough time to alert players of end mission, and prepare for score screen.   
    MISSION_STATUS = MISSION_STATUS_ENDING;
    if( (GAMETYPE == GAMEMODE_COOP) || (GAMETYPE == GAMEMODE_CAMPAIGN) ){
      ENDROUND_TIME = time + 8;
    }
    else{
      ENDROUND_TIME = time + 15;
    }
    for( player = nextent(world); player.classname == "player"; player = nextent(player)){
      if( !(player.flags & FL_CLIENT) ){
        continue;
      }
      player.flags = player.flags | FL_NOSHOOT;
      if( GAMETYPE == GAMEMODE_CAMPAIGN || GAMETYPE == GAMEMODE_COOP ){
        client_send_campaign_end_data( player );
      }
      else{
         client_send_dm_end_data( player ); 
      }
    }
    return;
  }
  
  if( MISSION_STATUS == MISSION_STATUS_ENDING ){
    client_send_server_info_update();
    if( time > ENDROUND_TIME ){
      spot = find(world, classname, "info_player_start");
      if( GAMETYPE == GAMEMODE_CAMPAIGN ){
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
      MISSION_STATUS = MISSION_STATUS_DONE;
      
      local float mapCount;
      local float itr;
      local string nextMap;
      mapCount = tokenizebyseparator(WORLD_MAP_LIST, " ");
      for( itr = 0; itr < mapCount; itr = itr + 1 ){
        if( argv(itr) == mapname ){
          if( itr == mapCount ){
            sv_nextmap = argv(0);
          }
          else{
            sv_nextmap = argv(itr + 1);
          }
          sv_nextmap = strzone(sv_nextmap);
          break;
        }
      }
      
      if( GAMETYPE == GAMEMODE_CAMPAIGN ){
        ENDROUND_TIME = time + 2;
      }
      else{
        if( GAMETYPE == GAMEMODE_COOP ){
          ENDROUND_TIME = time + SERVER_SCORE_TIME_COOP;
        }
        else{
          ENDROUND_TIME = time + SERVER_SCORE_TIME_DM;
        }
      }
      ENDROUND = TRUE;
    }
    return;
  }
  
  if( MISSION_STATUS == MISSION_STATUS_DONE ){
    if( GAMETYPE != GAMEMODE_CAMPAIGN ){
      if( time > ENDROUND_TIME ){
        if( ENDROUND == TRUE ){
          ENDROUND = FALSE;
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
  switch( GAMETYPE ){
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
  
  cons_logAString("[INFO]-world_export_nodegraph() edgelinker run ", ftos(self.wait));  //DEBUG
    
  local string fileName;
  local float fileExists;
  
  self.owner = NODEGRAPH_EXPORT_NODE[self.count];
  
  self.delay = 0; //reset edge id counter
  world_nodegraph_export_write_node(self.owner, fileExists );
  
  self.count = self.count + 1;
  if( self.count == self.wait ){
    cons_logAString("[INFO]-world_export_nodegraph()", "Write complete.");  //DEBUG
     fclose(self.data_idx);
    return;
  }

  self.think = world_nodegraph_export_edgelinker_th;
  self.nextthink = time + 1;
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
 
  //fclose(fileExists);
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
    nodegraph_edgelinker.data_idx = fileExists;
    nodegraph_edgelinker.count = 0;
    nodegraph_edgelinker.wait = nodeTotal;
    nodegraph_edgelinker.think = world_nodegraph_export_edgelinker_th;
    nodegraph_edgelinker.nextthink = time + 0.1;
    cons_logAString("[INFO]-world_export_nodegraph() total nodes ", ftos(nodeTotal));  //DEBUG
  }
  //fclose(fileExists); dangerous, deferring to linker entity 
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
  local vector trEdgeBpos;
  
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
      
      traceline(edgeSegB, edgeSegB + (v_up * -512), TRUE, node);
      trEdgeBpos = trace_endpos;
      
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
      edgeSegA = edgeSegB;
    }
    return edgeCheck;
  }
  else{
    //no proper Los based on 
    //self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY);
    //cons_logAString(ftos(node.data_idx), strcat(ftos(targNode.data_idx), " fail trace fraction ", ftos(trace_fraction)));//debug
    return FALSE;
  }
};
void(entity node, float fileData ) world_nodegraph_export_write_node={
  local string nodeData;
  local entity edgeNode;
  local float edgeMax;
  
  fputs(fileData, "{\n");
  fputs(fileData, strcat("\"id\" \"",ftos(node.data_idx),"\"\n"));
  fputs(fileData, "\"origin\" \"");
    fputs(fileData, strcat(ftos(node.origin_x), " "));
    fputs(fileData, strcat(ftos(node.origin_y), " "));
    fputs(fileData, ftos(node.origin_z));
  fputs(fileData, "\"\n");
  fputs(fileData, "\"edges\" \" ");
  
  edgeMax = 0;
  for(self.delay = 0; self.delay < self.wait; self.delay = self.delay + 1 ){
    edgeNode = NODEGRAPH_EXPORT_NODE[self.delay];
    if( edgeMax >= 6)
      break;
    if( edgeNode == node )
      continue;
    if( !world_nodegraph_export_edgelink(node, edgeNode) )
      continue;
    edgeMax = edgeMax + 1;
    //cons_logAString(ftos(node.data_idx), strcat("linked for ", ftos(edgeNode.data_idx)));//debug
    fputs(fileData, strcat(ftos(edgeNode.data_idx), "-", ftos(vlen(edgeNode.origin - node.origin))));
    fputs(fileData, " ");
  }
  if( edgeMax == 0 ){
    fputs(fileData, "NO EDGES FOUND");
  }
  fputs(fileData, "\"\n");
  fputs(fileData, "}\n");
};

/*
  Called by w
*/
void() world_nodegraph_import={
  
};

/*
  The specific function to read "data/<map>/*.node"
*/
float() world_nodegraph_read_file={
  local float fileHandle;
  local string fileName;
  local string fileLine;
  local string line;
  
  local float nodeCounter;
  
  local float tokens;
  local float itr;
  
  local float nodeid;
  local vector org;
  
  local string edgeData;
  
  fileName = strcat(mapname,"/",mapname,".nodes");
  fileHandle = fopen(fileName, FILE_READ);
  
  if( cvar("developer") ){
  
  }
  dprint(strcat("NODEGHRAPH FILE=", fileName,"\n"));  //debug
  
  if( fileHandle > -1 ){
    nodeCounter = 0;
    fileLine = fgets(fileHandle);
    while( fileLine != ""){
      if( nodeCounter >= NODEGRAPH_MAX ){
        break;
      }
      line = fileLine;
      fileLine = fgets(fileHandle);
      if( line == "{" ){
        //node ID
        line = fileLine;
        tokens = tokenizebyseparator(fileLine, "\"", "\"", " \"", "\"\n");
        nodeid = rint(stof(argv(3)));
        
        //node origin
        fileLine = fgets(fileHandle);
        tokens = tokenizebyseparator(fileLine, "\"", "\"", " \"", " ", "\"");
        org_x = stof(argv(3));
        org_y = stof(argv(4));
        org_z = stof(argv(5));
        
        //edge data
        fileLine = fgets(fileHandle);
        tokens = tokenizebyseparator(fileLine, "\"", "\" ", "\"", "\"");
        edgeData = argv(3);
        
        //node edge data for processing.
        world_nodegraph_read_node( nodeCounter, nodeid, '0 0 0', edgeData);
        line = fgets(fileHandle);
      }
      if( line == "}" ){
        nodeCounter = nodeCounter + 1;
        continue;
      }
    }
    fclose(fileHandle);
  }
  return nodeCounter;
};

void( float nodeCounter, float nodeId, vector org, string edgeDat) world_nodegraph_read_node={
  //NODEGHRAPH_DATA[nodeCounter].id = nodeid;
  local string edges;
  local float edgetokens;
  local float edgeItr;
  
  NODEGRAPH_ORIGIN[nodeCounter] = org;
  
  edges = edgeDat;
  edgetokens = tokenizebyseparator(edges, " ", "-");
  for(edgeItr = 0; edgeItr < edgetokens; edgeItr = edgeItr + 1){
   switch(edgeItr){
    default:
      NODEGRAPH_EDGES1[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN1[nodeId] = stof(argv(edgeItr+1));
      break;
    case 1:
      NODEGRAPH_EDGES2[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN2[nodeId] = stof(argv(edgeItr+1));
      break;
    case 2:
      NODEGRAPH_EDGES3[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN3[nodeId] = stof(argv(edgeItr+1));
      break;
    case 3:
      NODEGRAPH_EDGES4[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN4[nodeId] = stof(argv(edgeItr+1));
      break;
    case 4:
      NODEGRAPH_EDGES5[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN5[nodeId] = stof(argv(edgeItr+1));
      break;
    case 5:
      NODEGRAPH_EDGES6[nodeId] = stof(argv(edgeItr));
      NODEGRAPH_EDGES_LEN6[nodeId] = stof(argv(edgeItr+1));
      break;
   }
  }
};

/*
  used with server flag (SV_SERVERFLAGS & SVFLAG_SPAWNFAR)
  gathers all the deathmatch nodes.
*/
entity() world_deathmatch_random_spawn={
  local entity node;
  local entity baddies;
  local float proxCount;
  local float runTotal;
  local entity theNode;
  local entity rando;
  local float allNodes;
  local float nodeId;
  local float emptyNodes;
  runTotal = 16;
  
  for(node = nextent(world); node != world; node = nextent(node) ){
    if(node.classname != "map_deploy_point"){
      continue;
    }
    if(node.faction != FACTION_ALL){
      continue;
    }
    proxCount = 0;
    for(baddies = nextent(world); baddies != world; baddies = nextent(baddies) ){
      if( !(baddies.flags & FL_CLIENT) ){
        continue;
      }
      if( baddies.data_type != DATA_MECH ){
        continue;
      }
      traceline(node.origin, baddies.origin, FALSE, node);
      if(trace_fraction == 1.0){
        proxCount = proxCount + 1;
      }
      else{
        if(vlen(baddies.origin - node.origin) < AI_RANGE_S){
          proxCount = proxCount + 1;
        }
      }
    }
    if(proxCount <= runTotal){
      runTotal = rint(proxCount * 0.85);
      theNode = node;
      if( proxCount == 0){
        emptyNodes = emptyNodes + 1;
      }
    }
    allNodes = allNodes + 1;
  }
  if( theNode && emptyNodes < (allNodes * 0.5) ){
    return theNode;
  }
  
  nodeId = rint(random() * allNodes);
  rando = nextent(world);
  while( rando != world ){
    if( rando.classname == "map_deploy_point" ){
      if(rando.data_idx == nodeId){
        theNode = rando;
      }
    }
    rando = nextent(rando);
  }
  return theNode;
};

//TDM/DM network games use this list.
//string WORLD_MAP_LIST;
void() world_get_maplist={
  local string handOff;
  local float fileHandle;
  local string ln;
  
  if( WORLD_MAP_LIST != "" ){
    handOff = WORLD_MAP_LIST;
    strunzone(handOff);
    WORLD_MAP_LIST = "";
  }
  
  fileHandle = fopen("sv_maplist.txt", FILE_READ);
  
  if(fileHandle != -1){
    ln = fgets(fileHandle);
    while(ln != ""){ 
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