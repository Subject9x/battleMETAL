/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
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
  
  cvar_set("gamemode", ftos(GAMEMODE_CAMPAIGN));
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
  SCOPE: self = turret in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
 
  Turrets really are their own class of unit
*/
void(float vec_id) data_iniTurret={
  weaponList = self;  //prepare to build unit's weapon list
  switch(vec_id){
    case ID_TUR_HLITE:
      build_turret_unit(data_tur_hlite_ini);
      return;
    default:
      cons_logAFloat("Error: failed to build turret with id", vec_id);
      remove(self);
      return;
  }
};

/*
  SCOPE: self = projectile in question
  calls the appropriate 'ini' function on the 
  ent that is making the call. essentially this
  func holds 'state' for finding the right 'data'
  -Peter Roohr 11/26/2017
*/
void(float prj_id) data_iniProjectile={
  switch(prj_id){
    case ID_PRJ_EMP:
      //data_prj_emp_ini();
      return;
    case ID_PRJ_MIS:
      //data_prj_mis_ini();
      return;
    case ID_PRJ_MLGD:
      //data_prj_mlgd_ini();
      return;
    case ID_PRJ_MARH:
      //data_prj_marh_ini();
      return;
    case ID_PRJ_RPLAS:
      //data_prj_rplas_ini();
      return;
    case ID_PRJ_QRFL:
      //data_prj_qrfl_ini();
      return;
    case ID_PRJ_SFGA:
      //data_prj_sfga_ini();
      return;
    case ID_PRJ_ION:
      //data_prj_ion_ini();
      return;
    case ID_PRJ_SWRM:
      //data_prj_swrm_ini();
      return;
  }
  cons_logAFloat("Error: failed to find projectile of ", prj_id);
  remove(self);
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
