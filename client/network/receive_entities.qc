/*
battleMETAL
Author: Peter Roohr
Date: 3/13/2018
Overview: 
  + impl of all reception of sendent calls, got 
  + tired of trying to scroll through them all in csmain.
  + self scope for all is the ent being received
*/

void( float wep, float delt ) client_get_weapon_delta;

void() client_get_info={
  local float localDataType;
  local float wep;
  local float weaponBit;
  local float weaponDelta;
  //WARNING:
  //SVC_SETVIEW changes local_playerentum to Camera's Ent ID!
  //client = entitybyindex( getstati(STAT_PLR_ENT_ID) );
  CLIENT_player_deadflag = ReadByte();
  CLIENT_entorg  = te_read_vector();
  CLIENT_radar_range  = ReadLong(); 
  CLIENT_data_type = getstati(STAT_PLR_DTYPE);
  
  localDataType = ReadByte();
  if( localDataType == DATA_MECH ){
    CLIENT_energy = ReadShort();
    CLIENT_shield = ReadShort();
    
    CLIENT_hp_ctor = ReadByte(); 
    CLIENT_hp_leg = ReadByte(); 
    CLIENT_hp_stor = ReadByte(); 
    CLIENT_hp_stor2 = ReadByte(); 
    CLIENT_hp_arm = ReadByte(); 
    CLIENT_hp_arm2 = ReadByte();
    
    CLIENT_hardpoint_cnt = ReadByte();
    wep = 0;
    CLIENT_weapon_state = 0;
    while( wep <= CLIENT_hardpoint_cnt ){
      wep = wep + 1;
      weaponDelta = ReadByte();
      client_get_weapon_delta( wep, weaponDelta );
    }

    CLIENT_weapon_state = ReadShort();

    
    CLIENT_stat_trg_ent_id = ReadByte();
    if( CLIENT_stat_trg_ent_id != 0 ){
      CLIENT_target_origin = te_read_vector();
      CLIENT_target_shield = ReadByte();
      CLIENT_stat_trg_ct_hp = ReadByte();
      CLIENT_stat_trg_lg_hp = ReadByte();
      CLIENT_stat_trg_lt_hp = ReadByte(); 
      CLIENT_stat_trg_rt_hp = ReadByte(); 
      CLIENT_stat_trg_la_hp = ReadByte();
      CLIENT_stat_trg_ra_hp = ReadByte();
      CLIENT_target_vecsize = ReadShort();
      if( CLIENT_w_icon != "" ){
        strunzone( CLIENT_w_icon );
      }
      CLIENT_w_icon = strzone( ReadString() );
    }
  }
};

void( float wep, float delt ) client_get_weapon_delta={
  switch( wep ){
    case 1:
      CLIENT_stat_w1_rel = delt;
      break;
    case 2:
      CLIENT_stat_w2_rel = delt;
      break;
    case 3:
      CLIENT_stat_w3_rel = delt;
      break;
    case 4:
      CLIENT_stat_w4_rel = delt;
      break;
    case 5:
      CLIENT_stat_w5_rel = delt;
      break;
    case 6:
      CLIENT_stat_w6_rel = delt;
      break;
    case 7:
      CLIENT_stat_w7_rel = delt;
      break;
    case 8:
      CLIENT_stat_w8_rel = delt;
      break;
    case 9:
      CLIENT_stat_w9_rel = delt;
      break;
  }
};

/*
  Handles a Radar Blip TE pushed from the server to a specific client
  blips fade out over a given amount of time 
*/
void() client_get_contact={
  local entity blip;
  
  blip = spawn();
  
  setorigin( blip, te_read_vector() );
  blip.radar_range = ReadLong();
  blip.data_type = ReadByte();
  blip.faction = ReadByte();
  
  blip.data_idx = -2; //hack
  //Radar 1 - settings
  //blip.energy = time + 6;
  //blip.hardpoint_cnt = 1; //alpha fade
  //blip.radar_time = 0.001;
  
  //Radar 2 - settings
  blip.energy = time + 3;
  blip.hardpoint_cnt = 1; //alpha fade
  blip.radar_time = 0.0025;
  
};

void() client_get_hud_highlight={
  local entity hfx;

  hfx = spawn();
  hfx.data_idx = -3;  //more hacks
  hfx.origin = te_read_vector();
  hfx.drawsize = te_read_vector();
  hfx.drawcolor1 = te_read_vector();
  hfx.drawme = time + ReadShort();
  
};

void() receive_ent_bindData={
  local string name;
  
  name = getstats( STAT_PLR_NAME );
  
  CLIENT_flags = getstati( STAT_ROCKETS );
  
  if( name != CLIENT_netname){
    if( CLIENT_netname != ""){
      strunzone( CLIENT_netname );
    }
    CLIENT_netname = strzone( name );
  }
  
  CLIENT_player_state = getstati( STAT_ARMOR );

  CLIENT_data_type = getstati(STAT_PLR_DTYPE);
  CLIENT_data_idx = getstati(STAT_PLR_DIDX);
  CLIENT_faction = getstati( STAT_CELLS );
  CLIENT_stat_lock_state = getstati(STAT_LCK_STT);
  CLIENT_stat_rdr_mode = getstati(STAT_PLR_RADMOD);
  CLIENT_stat_hit_dirs = getstati(STAT_PLR_HITDIR);
  CLIENT_stat_ret_dist = getstati(STAT_PLR_RETDIST);

  CLIENT_stat_trg_dataidx = getstati(STAT_TRG_DATAIDX);
  CLIENT_stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
  CLIENT_stat_trg_face = getstati(STAT_TRG_FACE);
       
  CLIENT_target_datatype = getstati(STAT_TRG_DATATYPE);
  CLIENT_target_faction = getstati(STAT_TRG_FACTION);
  //CLIENT_target_shield; 
  //CLIENT_stat_trg_ddflg;
    
  CLIENT_stat_w1_id = getstati(STAT_WEP1_ID);
  CLIENT_stat_w2_id = getstati(STAT_WEP2_ID);
  CLIENT_stat_w3_id = getstati(STAT_WEP3_ID);
  CLIENT_stat_w4_id = getstati(STAT_WEP4_ID);
  CLIENT_stat_w5_id = getstati(STAT_WEP5_ID);
  CLIENT_stat_w6_id = getstati(STAT_WEP6_ID);
  CLIENT_stat_w7_id = getstati(STAT_WEP7_ID);
  CLIENT_stat_w8_id = getstati(STAT_WEP8_ID);
  CLIENT_stat_w9_id = getstati(STAT_WEP9_ID);
};

void() client_event_navpoint={
  local float navid, prevState, nexState;
  
  navid = ReadByte();
  prevState = NAVNAMES_ACTIVE[navid];
  nexState = ReadByte();
  NAVNAMES_ORG[navid] = te_read_vector();
  
  if( (prevState == TRUE) && (nexState == 2) ){
    //previous state was 'active unvisit' and next state is 'active and visit'
    //play sound
    te_nav_reach();
  }
  if( (prevState == 2) && (nexState == 1) ){
    //previous state was 'active and visit' and next state is 'active unvisit'
    //ignore state change for this client
    return;
  }
  NAVNAMES_ACTIVE[navid] = nexState;
};

void() client_event_deploypoint={
  local float depid;
  
  depid = ReadByte();
  DEPLOY_POINTS_ACTIVE[depid] = ReadByte();
  DEPLOY_POINTS_ORG[depid] = te_read_vector();
};

void() client_event_objective={
  local float objid, prevState, nexState, type;
  
  objid = ReadByte();
  prevState = OBJECTIVES[objid];
  nexState = ReadByte();
  type = ReadByte();
  
  if( (prevState > FALSE) ){
    if( prevState == TRUE ){
      if( nexState == -1 ){
        te_objective_failed();
      }
      if( nexState == 2 ){
       te_objective_complete( type );
      }
    }
  }
  
  OBJECTIVES[objid] = nexState;
};

void() client_event_boundary={
  HUD_WARN_ON = ReadByte();
  HUD_WARN_DIR = ReadAngle();
  if( HUD_WARN_ON ){
    if( time > HUD_WARN_MARK ){
      HUD_WARN_MARK = time + HUD_WARN_TIME;
    }
  }
};

void() client_event_environment={
  HUD_WARN_ENV_ON = ReadByte();
  HUD_WARN_ENV_TYPES = ReadByte();
  if( HUD_WARN_ENV_ON ){
    if( time > HUD_WARN_ENV_MARK ){
      HUD_WARN_ENV_MARK = time + HUD_WARN_ENV_TIME;
      
    }
  }
};
/*
  handles mission name if active
*/
void() client_event_mission_name_frame={
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_DYSTOPIAN;
  
  //state controller
  switch( MISSION_NAME_STATE ){
    case 1:
      MISSION_NAME_COLOR_x = gui_colorFadeTo( CLR_DEF_WHITE_x, MISSION_NAME_COLOR_x, 0.004 );
      MISSION_NAME_COLOR_y = gui_colorFadeTo( CLR_DEF_WHITE_y, MISSION_NAME_COLOR_y, 0.004 );
      MISSION_NAME_COLOR_z = gui_colorFadeTo( CLR_DEF_WHITE_z, MISSION_NAME_COLOR_z, 0.004 );
      if( time > MISSION_NAME_TIME_RATE ){
        MISSION_NAME_ALPHA = MISSION_NAME_ALPHA + 0.01;
        MISSION_NAME_TIME_RATE = time + 0.05;
      }
      if( time > MISSION_NAME_START ){
        MISSION_NAME_START = time + (MISSION_NAME_TIME * 1.5);
        MISSION_NAME_STATE = MISSION_NAME_STATE + 1;
      }
      break;
    case 2:
      if( time > MISSION_NAME_START ){
        MISSION_NAME_STATE = MISSION_NAME_STATE + 1;
        MISSION_NAME_START = time + MISSION_NAME_TIME;
      }
      break;
    case 3:
      MISSION_NAME_COLOR_x = gui_colorFadeTo( CLR_DEF_RED_x, MISSION_NAME_COLOR_x, 0.006 );
      MISSION_NAME_COLOR_y = gui_colorFadeTo( CLR_DEF_RED_y, MISSION_NAME_COLOR_y, 0.006 );
      MISSION_NAME_COLOR_z = gui_colorFadeTo( CLR_DEF_RED_z, MISSION_NAME_COLOR_z, 0.006 );
      if( time > MISSION_NAME_TIME_RATE ){
        MISSION_NAME_ALPHA = MISSION_NAME_ALPHA - 0.01;
        MISSION_NAME_TIME_RATE = time + 0.05;
      }
      if( time > MISSION_NAME_START ){
        MISSION_NAME_STATE = FALSE;
      }
      break;
    default:
      MISSION_NAME_ON = FALSE;
      strunzone(MISSION_NAME);
      drawfont = drawfont_prev;
      return;
  }
  if( MISSION_NAME_ALPHA > 1 ){
    MISSION_NAME_ALPHA = 1;
  }
  else if( MISSION_NAME_ALPHA < 0 ){
    MISSION_NAME_ALPHA = 0;
  }
  
  drawstring( MISSION_NAME_ORG, MISSION_NAME, '24 24 0', '1 1 1', MISSION_NAME_ALPHA, 0);
  drawstring( MISSION_NAME_ORG, MISSION_NAME, '24 24 0', MISSION_NAME_COLOR, MISSION_NAME_ALPHA, 0);
  drawfont = drawfont_prev;
};

/*
  server Mapping = client_sendMissionName();
  receive map's mission name, and diplay it while the player boots up.
*/
void( string name ) client_event_mission_name={
  local vector newOrg;
  local float noNewLine;
  local float nameLen;
  
  MISSION_NAME_ON = TRUE;
  MISSION_NAME_START = time + MISSION_NAME_TIME;
  MISSION_NAME_STATE = 1;
  MISSION_NAME_ALPHA = 0;
  MISSION_NAME_COLOR = CLR_DEF_RED;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_DYSTOPIAN;
    noNewLine = strstrofs( name, "\n", 0 );
    MISSION_NAME = substring( name, 0, noNewLine);
    MISSION_NAME = strzone( MISSION_NAME );
    nameLen = stringwidth(MISSION_NAME, 0, '24 24 0');
    nameLen = gui_percentXRaw( nameLen / 2 );
    newOrg_x = VIEW_CTR_x - nameLen;
    newOrg_y = VIEW_CTR_y - gui_percentYRaw( 64 );
    MISSION_NAME_ORG = newOrg;
  drawfont = drawfont_prev;
};

/*
  server Mapping = client_sendEndMission();
  
  receives end-mission data from server,
  launches MENU_DEBRIEF screen.  
*/
void(float missionTime, float clientKills, float missonSuccessCheck, float pscTotal, float survestTotal, float militarTotal, float totalLosses ) client_event_debrief_active={
  
  MENU_DEBRIEF_time_elapsed = CLIENT_start_time - missionTime;
  MENU_DEBRIEF_time_elapsed = MENU_DEBRIEF_time_elapsed / 10;
  MENU_DEBRIEF_time_elapsed = MENU_DEBRIEF_time_elapsed / 60;
  
  MENU_DEBRIEF_total_kills = clientKills;
  MENU_DEBRIEF_total_monsters = survestTotal + militarTotal;
  MENU_DEBRIEF_total_allies = pscTotal;
  
  MENU_DEBRIEF_status = missonSuccessCheck;
  
  MENU_DEBRIEF_total_losses = totalLosses;
  
  if( MENU_DEBRIEF_status ){
    MENU_DEBRIEF_data_mission_status = "- Mission Successful -";
  }
  else{
    MENU_DEBRIEF_data_mission_status = "!- Mission Failed -!";
  }
  
  MENU_ACTIVE = 1;
  CLIENT_MENU_menu_choice = MENU_DEBRIEF_ACTIVE;
  setpause( 1 );
  setcursormode( 1 );
  //start cd track
};

void() client_event_targ_kill={
  
};

void() client_map_cdtrack={

};
