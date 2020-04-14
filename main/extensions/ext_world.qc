/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 07/02/2019
Overview: 
  Extension functions to world.qc 
  these functions are here for their abstraction level.
*/

void() mh_world_ini={
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
  registercvar("saveslot", "0", 1);
  registercvar("gamemode", "0", 0);
  registercvar("cl_hud_alpha", "1", 1);
  registercvar("cl_hud_color", "0", 1);
  registercvar("cl_hud_sway", "0", 1);
  
  //Mission unit stat totals
  MISSION_STATUS = MISSION_STATUS_READY;
  MISSION_TOTAL_PSC = 0;
  MISSION_TOTAL_SURVEST = 0;
  MISSION_TOTAL_MILITAR = 0;

  MISSION_LOSSES_PSC = 0;
  MISSION_LOSSES_SURVEST = 0;
  MISSION_LOSSES_MILITAR = 0;

  serverflags = 255;  //DEBUG

  STARTTIME = time;
  ENDTIME = time + (cvar("timelimit") * 60);

  world_ini_serverinfo();

  //kept in numerical order for easy reference.
  addstat(STAT_PLAYER_DEADFLAG, AS_INT, deadflag);
  addstat(STAT_ACCURACY, AS_FLOAT, accuracy);
  
  addstat(STAT_RAM, AS_FLOAT, ramUp);
  
  addstat(STAT_CLIENT_ENERGY, AS_FLOAT, stat_client_energy);
  addstat(STAT_CLIENT_SHIELD, AS_FLOAT, stat_client_shield);
  
  addstat(STAT_RAM_MAX, AS_FLOAT, ramUpMax);
  addstat(STAT_PLAYER_STATE, AS_INT, playerState);
  addstat(STAT_PLAYER_WEAPONS_STATE, AS_INT, stat_player_weapons_state);
  addstat(STAT_PLAYER_FACTION, AS_INT, faction);
  
  addstat(STAT_PLAYER_DATA_TYPE, AS_INT, data_type);
  addstat(STAT_PLR_DATA_IDX, AS_INT, data_idx);
  addstat(STAT_PLR_RADMOD, AS_INT, stat_rdr_mode);
  addstat(STAT_PLR_HITDIR, AS_INT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_INT, stat_ret_dist);
  
  addstat(STAT_TRG_ENT_ID, AS_INT, stat_trg_ent_id);
  addstat(STAT_TRG_DATATYPE, AS_INT, stat_trg_dat);
  addstat(STAT_TRG_DATAIDX, AS_INT, stat_trg_dataidx);
  addstat(STAT_TRG_DIST, AS_INT, stat_trg_dist);
  addstat(STAT_TRG_FACE, AS_INT, stat_trg_face);
  addstat(STAT_TRG_FACTION, AS_INT, stat_trg_faction);
    
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
    
  addstat(STAT_TARGET_SHIELDS, AS_FLOAT, stat_target_shield);
  addstat(STAT_TARGET_NAME, AS_STRING, stat_target_name);
  addstat(STAT_TARGET_NAME, AS_STRING, stat_target_name);
    
  addstat(STAT_TARGET_ORIGINX, AS_FLOAT, stat_target_orgx);
  addstat(STAT_TARGET_ORIGINY, AS_FLOAT, stat_target_orgy);
  addstat(STAT_TARGET_ORIGINZ, AS_FLOAT, stat_target_orgz);
  addstat(STAT_TARGET_SIZE, AS_INT, stat_target_size);
    
  addstat(STAT_RAM_VALUE, AS_FLOAT, ramTracker);
  addstat(STAT_LCK_STT, AS_INT, stat_lck_stt);
  
  addstat(STAT_TRG_DDFLG, AS_INT, stat_trg_ddflg);
  
  addstat(STAT_CLIENT_WEAPON1_RELOAD, AS_FLOAT, stat_w1_rel);
  addstat(STAT_CLIENT_WEAPON2_RELOAD, AS_FLOAT, stat_w2_rel);
  addstat(STAT_CLIENT_WEAPON3_RELOAD, AS_FLOAT, stat_w3_rel);
  addstat(STAT_CLIENT_WEAPON4_RELOAD, AS_FLOAT, stat_w4_rel);
  addstat(STAT_CLIENT_WEAPON5_RELOAD, AS_FLOAT, stat_w5_rel);
  addstat(STAT_CLIENT_WEAPON6_RELOAD, AS_FLOAT, stat_w6_rel);
  addstat(STAT_CLIENT_WEAPON7_RELOAD, AS_FLOAT, stat_w7_rel);
  addstat(STAT_CLIENT_WEAPON8_RELOAD, AS_FLOAT, stat_w8_rel);
  addstat(STAT_CLIENT_WEAPON9_RELOAD, AS_FLOAT, stat_w9_rel);

  addstat(STAT_RAD_SWEEP, AS_FLOAT, radar_time);
  addstat(ADDSTAT_TARGETSIZE_X, AS_FLOAT, addStat_targetSize_x);
  addstat(ADDSTAT_TARGETSIZE_Y, AS_FLOAT, addStat_targetSize_y);
  addstat(ADDSTAT_TARGETSIZE_Z, AS_FLOAT, addStat_targetSize_z);
  
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
};

void() world_ini_serverinfo={
  local string serverInfo;
  serverInfo = strcat("svinfo ", ftos(STARTTIME), " ");
  serverInfo = strcat(serverInfo, ftos(MISSION_STATUS)," ");
  serverInfo = strcat(serverInfo, ftos(GAMETYPE)," ");
  serverInfo = strcat(serverInfo, ftos(serverflags)," ");
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
  CHECK SERVER GAME RULES
    ports -> CheckRules()
*/
void() sv_checkRules={
  
  if( GAMETYPE == GAMEMODE_CAMPAIGN ){
    
  
    return;
  }
  
  //Game FragLimit hit
  if( self.frags >= cvar("fraglimit") ){

    
  }
  
  //Game TimeLimit hit
  if( time >= ENDTIME ){

  }
  
  //Objective hit
  
  
  //Limited Lives, no one left
  

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

void( entity light, float fileData ) world_export_realtimelights_write={
  local string lightData;
  
  if( light.rtlShadows == FALSE){
    fputs(fileData, "!");
  }    
  lightData = strcat( lightData, ftos(light.origin_x), " ", ftos(light.origin_y), " ", ftos(light.origin_z));
  lightData = strcat( lightData, " ", ftos(light.rtlRadius) );
  lightData = strcat( lightData, " ", ftos(light.color_x)," ", ftos(light.color_y)," ", ftos(light.color_z) );
  lightData = strcat( lightData, " ", ftos(light.rtlStyle) );
  lightData = strcat( lightData, " \"", light.vec_name,"\" " );
  lightData = strcat( lightData, " ", ftos(light.rtlCorona) );
  lightData = strcat( lightData, " ", ftos(light.angles_x), " ", ftos(light.angles_y), " ", ftos(light.angles_z) );
  lightData = strcat( lightData, " ", ftos(light.rtlCoronaSize) );
  lightData = strcat( lightData, " ", ftos(light.rtlAmbient) );
  lightData = strcat( lightData, " ", ftos(light.rtlDiffuse) );
  lightData = strcat( lightData, " ", ftos(light.rtlSpecular) );
  lightData = strcat( lightData, " ", ftos(light.rtlMode));
  if( lightData != "" ){
    fputs(fileData, lightData);
  }
  fputs(fileData, "\n");  //INFO - .rtlights files ALWAYS end with a \n
  
  if( cvar("developer") ){
    cons_log2Strings("[INFO]-{Writing RTLight Data} ", "-line-", "origin", vtos(light.origin)); //DEBUG
  }
};


/*
  so, rolling with PFLAGS_FULLDYNAMIC, these things appear to be quite expensive, I'd recommend using them in a limited 
  fashion. Maybe no more than a handful of lights per entity you want to attach them to, and definetly make sure they're
  removed with their parent ent.
*/
void( vector org, entity parent, float id, vector colr, float stile, float pFlags, vector angl, float skinNum, float lightRadius) world_make_dlight={
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

void( entity parent ) world_remove_dlight={
  local entity chaine;
  local entity ref;
  
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
void( entity parent, float lightId, vector newColor, float newRadius, float newStyle, vector newAngl) world_update_dlight={
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