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
  registercvar("mechdev", "0", 1);
  registercvar("campaign", "0", 0); 
  registercvar("saveslot", "0", 1);
  registercvar("gamemode", "0", 0);
  registercvar("gametype", "0", 0);
  registercvar("cl_hud_alpha", "1", 1);
  registercvar("cl_hud_color", "0", 1);
  
  cvar_set("gamemode", ftos(GAMEMODcockpitPAIGN));
  if( coop && cvar("maxplayers") > 1){
    cvar_set("gamemode", ftos(GAMEMODE_COOP));
  }
  if( deathmatch && cvar("maxplayers") > 1){
    cvar_set("gamemode", ftos(GAMEMODE_DM));
  }

  //oh my
  addstat( STAT_PLR_NAME, AS_STRING, netname);
  addstat(STAT_PLR_ORG_X, AS_FLOAT, stat_cofs_x);
  addstat(STAT_PLR_ORG_Y, AS_FLOAT, stat_cofs_y);
  addstat(STAT_PLR_ORG_Z, AS_FLOAT, stat_cofs_z);
  addstat(STAT_PLR_DIDX, AS_INT, data_idx);
  addstat(STAT_PLR_DTYPE, AS_INT, data_type);
  addstat(STAT_PLR_RADMOD, AS_INT, stat_rdr_mode);
  addstat(STAT_LCK_STT, AS_INT, stat_lck_stt);
  addstat(STAT_PLR_HITDIR, AS_INT, stat_hit_dirs);
  addstat(STAT_PLR_RETDIST, AS_INT, stat_ret_dist);
  
  //Target stats
  addstat(STAT_TRG_ENT_ID, AS_INT, stat_trg_ent_id);
  addstat(STAT_TRG_DATATYPE, AS_INT, stat_trg_dat);
  addstat(STAT_TRG_DATAIDX, AS_INT, stat_trg_dataidx);
  addstat(STAT_TRG_FACTION, AS_INT, stat_trg_faction);
  
  addstat(STAT_CAM_ORG_X, AS_FLOAT, stat_plr_camx);
  addstat(STAT_CAM_ORG_Y, AS_FLOAT, stat_plr_camy);
  addstat(STAT_CAM_ORG_Z, AS_FLOAT, stat_plr_camz);
  
  addstat(STAT_WEP1_ID, AS_INT, stat_w1_id);
  addstat(STAT_WEP2_ID, AS_INT, stat_w2_id);
  addstat(STAT_WEP3_ID, AS_INT, stat_w3_id);
  addstat(STAT_WEP4_ID, AS_INT, stat_w4_id);
  addstat(STAT_WEP5_ID, AS_INT, stat_w5_id);
  addstat(STAT_WEP6_ID, AS_INT, stat_w6_id);
  addstat(STAT_WEP7_ID, AS_INT, stat_w7_id);
  addstat(STAT_WEP8_ID, AS_INT, stat_w8_id);
  addstat(STAT_WEP9_ID, AS_INT, stat_w9_id);
  
  addstat(STAT_TRG_DDFLG, AS_INT, stat_trg_ddflg);
  addstat(STAT_TRG_DIST, AS_INT, stat_trg_dist);
  addstat(STAT_TRG_FACE, AS_INT, stat_trg_face);
  
  addstat(STAT_ACCURACY, AS_FLOAT, accuracy);
 
  addstat(STAT_PLR_ANG_X, AS_FLOAT, stat_plr_ang_x);
  addstat(STAT_PLR_ANG_Y, AS_FLOAT, stat_plr_ang_y);
  addstat(STAT_PLR_ANG_Z, AS_FLOAT, stat_plr_ang_z);
  
  addstat(STAT_PLR_REP, AS_INT, stat_plr_rep);
  addstat(STAT_RAD_SWEEP, AS_FLOAT, radar_time);

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
  used for adjusting line of sight based on target's fog settings.
  the code keeps fog settings at the entity level
*/
float( entity t ) world_calc_fog={
  return FALSE; //TODO - clarify
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
  Real-time Light entity exporter functionality.
    RTLights file data can now be bound to maps at the map-editor layer.
    new entity - "realtime_light" can be found in misc.qc
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
  fileName = strcat("maps/rtexport/", mapname, ".rtlights");
  if( developer ){
    cons_logAString("world_export_realtimelights()|[fileName]", fileName);  //DEBUG
  }
 
  fileExists = fopen(fileName, FILE_WRITE);
 
  //overrideFlag was false but file exists! so don't overwrite
  if( (fileExists == TRUE) && !overrideFlag ){
    if( developer ){
      cons_logAString("world_export_realtimelights()|", "[WARN]: Failed to write rtlights file, overrideFlag = FALSE but file already exists!");  //DEBUG
    }
    fclose(fileExists);
    return;
  }
  
  //if file doesnt exists
  lights = findchain(classname, "realtime_light");
  if( lights ){
    while(lights){
      world_export_realtimelights_write( lights, fileExists );
      lights = lights.chain;
    }
    if( developer ){
      cons_logAString("world_export_realtimelights()", "[INFO]: Write complete.");  //DEBUG
    }
  }
  else{
    if( developer ){
      cons_logAString("world_export_realtimelights()", "[WARN]: No {realtime_light} entities found in map file.");  //DEBUG
    }
  }
  fclose(fileExists);
};

void( entity light, float fileData ) world_export_realtimelights_write={
  local string lightData;
  lightData = "";
  if( light.rtlShadows == TRUE){
    lightData = strcat(lightData, "!"); 
  }    
  lightData = strcat( lightData, ftos(light.origin_x), " ", ftos(light.origin_y), " ", ftos(light.origin_z));
  lightData = strcat( lightData, " ", ftos(light.rtlLight) );
  lightData = strcat( lightData, " ", ftos(light.color_x)," ", ftos(light.color_y)," ", ftos(light.color_z) );
  lightData = strcat( lightData, " ", ftos(light.rtlStyle) );
  lightData = strcat( lightData, " \"", light.vec_name,"\" " );
  lightData = strcat( lightData, " ", ftos(light.rtlCorona) );
  lightData = strcat( lightData, " ", ftos(light.angles_x), " ", ftos(light.angles_y), " ", ftos(light.angles_z) );
  lightData = strcat( lightData, " ", ftos(light.rtlCoronaSize) );
  lightData = strcat( lightData, " ", ftos(light.rtlAmbient) );
  lightData = strcat( lightData, " ", ftos(light.rtlDiffuse) );
  lightData = strcat( lightData, " ", ftos(light.rtlSpecular) );
  lightData = strcat( lightData, " ", ftos(light.rtlMode), "\n");
  
  if( cvar("developer") ){
    cons_logAString("[Writing RTLight Data]", lightData); //DEBUG
  }
  fputs(fileData, lightData);

};
