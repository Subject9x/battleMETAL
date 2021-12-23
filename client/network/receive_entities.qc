/*
battleMETAL
Author: Peter Roohr
Date: 3/13/2018
Overview: 
  + impl of all reception of sendent calls, got 
  + tired of trying to scroll through them all in csmain.
  + self scope for all is the ent being received
*/

/*
  Most of the Client's data is piped through the addstat() channels.
  This function is called towards the top of client_main.CSQC_Update_View() to
  ensure that the most recent data is being pulled before operating on it.
  
  get_info() takes the previous frame's data for comparison
*/
void() client_get_info={  
  //WARNING:
  //SVC_SETVIEW changes local_playerentum to Camera's Ent ID!
  //client = entitybyindex( getstati(STAT_PLR_ENT_ID) );
  
  CLIENT_player_state_prev = CLIENT_player_state;
  CLIENT_player_deadflag_prev = CLIENT_player_deadflag;
  
  if( CLIENT_data_type == DATA_MECH ){
    CLIENT_health_center_prev = CLIENT_health_center;
    CLIENT_health_legs_prev = CLIENT_health_legs;
    CLIENT_health_torso_left_prev = CLIENT_health_torso_left;
    CLIENT_health_torso_right_prev = CLIENT_health_torso_right;
    CLIENT_health_arm_left_prev = CLIENT_health_arm_left;
    CLIENT_health_arm_right_prev = CLIENT_health_arm_right;
  }
};

/*
  Reads off addstat() data into Client_* vars.
*/
void() receive_ent_bindData={
  local string name;
  local float prevFaction;
  local entity deploy;
  local entity previous;
  
  name = cvar_string("_cl_name");
  
  CLIENT_player_state = getstati( STAT_PLAYER_STATE );
  
  prevFaction = CLIENT_faction;
  CLIENT_faction = rint(stof(getplayerkeyvalue(player_localentnum - 1, "colors")));
  if( prevFaction != CLIENT_faction ){
    menu_update_colors( CLIENT_faction );
    cl_set_faction( CLIENT_faction );
    //rebuild nav points
    for( deploy = DEPLOYPOINT; deploy != world; deploy = deploy.partNext ){
      if( deploy.faction == CLIENT_faction || deploy.faction == FACTION_ALL ){
        if( !previous.data_idx ){
          FACTION_DEPLOY = deploy; // first point
          previous = deploy;
        }
        else{
          previous.nextPoint = deploy;
          deploy.prevPoint = previous;
          previous = deploy;
        }
      }
    }
  }
  
  if( CLIENT_data_type == DATA_MECH ){
    if( name != CLIENT_netname){
      cacheGlobalString(CLIENT_netname, name )
    }
    
    //CLIENT_stat_lock_state = getstati(STAT_LCK_STT); //2.0.0: lock-on not timer-based anymore
    //CLIENT_stat_rdr_mode = getstati(STAT_PLR_RADMOD);
    CLIENT_stat_hit_parts = getstati(STAT_TARGET_HIT_PARTS);
    CLIENT_stat_hit_dirs = getstati(STAT_PLR_HITDIR);
    CLIENT_stat_ret_dist = getstati(STAT_PLR_RETDIST);
    
    CLIENT_health_center = getstatf(STAT_CLIENT_HP_TORSOCENTER); 
    CLIENT_health_legs = getstatf(STAT_CLIENT_HP_LEGS); 
    CLIENT_health_torso_left = getstatf(STAT_CLIENT_HP_TORSOLEFT); 
    CLIENT_health_torso_right = getstatf(STAT_CLIENT_HP_TORSORIGHT); 
    CLIENT_health_arm_left = getstatf(STAT_CLIENT_HP_ARMLEFT); 
    CLIENT_health_arm_right = getstatf(STAT_CLIENT_HP_ARMRIGHT);
    
    //Last Frame Target info cache
    CLIENT_target_health_prev = CLIENT_stat_trg_ct_hp;
    
    CLIENT_target_datatype_prev = CLIENT_target_datatype;
    
    CLIENT_stat_trg_ct_hp = getstatf(STAT_TARGET_HP_TORSOCENTER);
    CLIENT_stat_trg_lt_hp = getstatf(STAT_TARGET_HP_TORSOLEFT); 
    CLIENT_stat_trg_rt_hp = getstatf(STAT_TARGET_HP_TORSORIGHT); 
    CLIENT_stat_trg_la_hp = getstatf(STAT_TARGET_HP_ARMLEFT);
    CLIENT_stat_trg_ra_hp = getstatf(STAT_TARGET_HP_ARMRIGHT);
    CLIENT_stat_trg_lg_hp = getstatf(STAT_TARGET_HP_LEGS);
    
    //Critical hits
    if( CLIENT_player_state == PLAYER_ACTIVE ){
      if( CLIENT_health_torso_left <= 0 && CLIENT_health_torso_left_prev > 0 ){
        hud_event_enqueue(HUD_EVENT_CRITICAL_TORSO_LEFT, 1);
      }
      if( CLIENT_health_torso_right <= 0 && CLIENT_health_torso_right_prev > 0 ){
        hud_event_enqueue(HUD_EVENT_CRITICAL_TORSO_RIGHT, 1);
      }
      if( CLIENT_health_arm_left <= 0 && CLIENT_health_arm_left_prev > 0 ){
        hud_event_enqueue(HUD_EVENT_CRITICAL_ARM_LEFT, 1);
      }
      if( CLIENT_health_arm_right <= 0 && CLIENT_health_arm_right_prev > 0 ){
        hud_event_enqueue(HUD_EVENT_CRITICAL_ARM_RIGHT, 1);
      }
      if( CLIENT_health_legs <= 0 && CLIENT_health_legs_prev > 0 ){
        hud_event_enqueue(HUD_EVENT_CRITICAL_LEGS, 1);
      }
      if( CLIENT_health_legs > 0 && CLIENT_health_legs_prev <= 0 ){
        //repair event
      }
    }
    if( !(CLIENT_flags_prev & FL_NOSHOOT) && (CLIENT_flags & FL_NOSHOOT) ){
      hud_event_enqueue( HUD_EVENT_WEAPONS_OFF, 1) ;
    }
    if( (CLIENT_flags_prev & FL_NOSHOOT) && !(CLIENT_flags & FL_NOSHOOT) ){
      hud_event_enqueue( HUD_EVENT_WEAPONS_ON, 1) ;
    }
    
    // hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
    CLIENT_repair_value = getstati(STAT_PLR_REP);
    //Client targeting data
    CLIENT_stat_trg_ent_id_prev = CLIENT_stat_trg_ent_id;
    if( CLIENT_target_ent != world ){
      CLIENT_stat_trg_ent_id = num_for_edict(CLIENT_target_ent);
      CLIENT_stat_trg_ddflg_prev = CLIENT_stat_trg_ddflg;
      CLIENT_stat_trg_ddflg = CLIENT_target_ent.deadflag;
      if(CLIENT_stat_trg_ddflg > DEAD_NO ){
        CLIENT_target_ent = world;
        CLIENT_stat_trg_ent_id = 0;
        CLIENT_stat_trg_dataidx = 0;
        CLIENT_stat_trg_face = -1;
        return;
      }
      CLIENT_stat_trg_ent_id = CLIENT_target_ent.entId;
      CLIENT_stat_trg_dataidx = CLIENT_target_ent.data_idx;
      
      CLIENT_stat_trg_face = util_checkPointAngleImpl(CLIENT_target_ent.origin, pmove_org, input_angles) ;
      
      CLIENT_target_datatype_prev = CLIENT_target_datatype;
      CLIENT_target_datatype = CLIENT_target_ent.data_type;
      CLIENT_target_faction = CLIENT_target_ent.faction;
      CLIENT_target_origin = CLIENT_target_ent.origin;
      CLIENT_target_vecsize = CLIENT_target_ent.vec_size;
      CLIENT_target_shield = CLIENT_target_ent.shield;
      if( CLIENT_target_shield <= 0 ){
        CLIENT_target_shield = 0;
      }
      CLIENT_target_dist_prev = CLIENT_target_dist;
      CLIENT_target_dist = vlen(CLIENT_target_ent.origin - pmove_org);
      CLIENT_target_size = CLIENT_target_ent.maxs;
    }
    else{
      CLIENT_stat_trg_ent_id = 0;
      CLIENT_stat_trg_dataidx = 0;
      CLIENT_target_origin = '0 0 0';
      CLIENT_target_faction = 0;
      CLIENT_target_shield = 0;
      CLIENT_target_vecsize = 0;
    }
    
  }
};

/*
  State controller for Client's playerState as picked up from Server
  also Server Mission Status and Results
*/
void() client_state_events={
  local float timeVal;
  
  //SERVER EVENTS
  
  if( ENT_SERVER_INFO.missionStatusPrev != ENT_SERVER_INFO.missionStatus ){
    //Server Event - end of map
    if( (ENT_SERVER_INFO.missionStatusPrev != MISSION_STATUS_OVER) && (ENT_SERVER_INFO.missionStatus == MISSION_STATUS_OVER) ){
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
        if( ENT_SERVER_INFO.missionResult == MISSION_RESULT_WIN ){
          hud_event_enqueue( HUD_EVENT_MISSION_COMPLETE, 1 );
        }
        else{
          hud_event_enqueue( HUD_EVENT_MISSION_FAILED, 1 );
        }
      }
    }
  }
  
  //CLIENT EVENTS
  if( CLIENT_player_state != CLIENT_player_state_prev ){
    //Player has just connected to server
    if( (CLIENT_player_state_prev == 0) && (CLIENT_player_state == PLAYER_CONNECT) ){
      localcmd(strcat("stopsound", "\n"));
      cl_set_hud_vars_obs();
      return;
    }
  
    //EVENT - CLIENT FIRST TIME CONNECT---
    if( (CLIENT_player_state_prev == PLAYER_CONNECT) && (CLIENT_player_state == PLAYER_SPAWN) ){
      if( cvar("developer") ){
        dprint(sprintf("EVENT - CLIENT FIRST TIME CONNECT--- ENT_SERVER_INFO.gameType = %s\n", ftos(ENT_SERVER_INFO.gameType))); //debug
      }
      //mission file load check
      if(MSN_FILEFOUND){
        if(MSN_LOADED == FALSE){
          msn_parsefile();
          MSN_LOADED = TRUE;
        }
      }
      if( !MENU_ACTIVE ){
        menu_update_colors( CLIENT_faction );
        menu_enter( menu_connect_choice() );
        menu_chat_config(FALSE);
      }
      return;
    }
    //------------------------------------
    
    
    //EVENT - CLIENT END OF DM/TDM
    if( (CLIENT_player_state_prev == PLAYER_CONNECT) && (CLIENT_player_state == PLAYER_MENU) ){
      setcursormode( 0 );
      menu_exit();
      localcmd("togglemenu\n");
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT ENTERS MECH---
    if( (CLIENT_player_state_prev == PLAYER_SPAWN) && (CLIENT_player_state == PLAYER_POWERUP_BEGIN) ){
      if( MECH_DATA_ID != CLIENT_data_idx ){
        ui_data_load_mech(MECH_DATA_ID);
      }
      hud_event_clear();
      hud_event_enqueue( HUD_EVENT_POWERUP, 1);
      SV_PLAYERTIME = servertime;
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT DEATH----------------
    if( (CLIENT_player_state_prev != PLAYER_DEAD) && (CLIENT_player_state == PLAYER_DEAD) ){
      CLIENT_deaths = CLIENT_deaths + 1;
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
        if( ENT_SERVER_INFO.missionStatus == MISSION_RESULT_WIN ){
          te_mission_win();
        }
        else{
          te_mission_lose();
        }
        SV_ENDTIME = servertime;
      }
      else{
        timeVal = servertime - CLIENT_spawn_time;
        if( timeVal > CLIENT_best_time ){
          CLIENT_best_time = timeVal;
          CLIENT_best_mech = MECH_DATA_ID;
        }
      }
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT CAMPAIGN DEBRIEF DEATH
    if( (CLIENT_player_state_prev == PLAYER_DEAD) && (CLIENT_player_state == PLAYER_DEBRIEF) ){
      menu_enter( MENU_DEBRIEF_ACTIVE );
      menu_chat_config( FALSE );
      MENU_DEBRIEF_time_elapsed = -1;
      ui_set_mission_status( ENT_SERVER_INFO.missionResult );
      MENU_respawn_cool = servertime + SERVER_RESPAWN_COOL_CAMP;
      MENU_respawn_cool_start = servertime;
      MENU_button_delay = MENU_respawn_cool;
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT CAMPAIGN DEBRIEF MISSION END
    if( (CLIENT_player_state_prev != PLAYER_DEBRIEF) && (CLIENT_player_state == PLAYER_DEBRIEF) ){
      menu_enter( MENU_DEBRIEF_ACTIVE );
      menu_chat_config( FALSE );
      MENU_DEBRIEF_time_elapsed = -1;
      ui_set_mission_status( ENT_SERVER_INFO.missionResult );
      MENU_respawn_cool = servertime + SERVER_RESPAWN_COOL_CAMP;
      MENU_respawn_cool_start = servertime;
      MENU_button_delay = MENU_respawn_cool;
      SV_ENDTIME = servertime;
      if( ENT_SERVER_INFO.missionResult == MISSION_RESULT_WIN ){
        msn_unlock_stuff();
        menu_debrief_sort_unlocks();
      }
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT NET RESPAWN
    if( (CLIENT_player_state_prev == PLAYER_DEAD) && (CLIENT_player_state == PLAYER_REDEPLOY) ){
      CLIENT_MENU_deploy = world;
      menu_enter( MENU_CONNECT_ACTIVE );
      menu_chat_config(FALSE);
      MENU_button_delay = servertime + 1;
      if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
        MENU_respawn_cool = servertime + SERVER_RESPAWN_COOL_COOP;
      }
      else{
        MENU_respawn_cool = servertime + SERVER_RESPAWN_COOL_DM;
      }
      MENU_respawn_cool_start = servertime;
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT END OF DM/TDM
    if( (CLIENT_player_state_prev != PLAYER_INTERMSN) && (CLIENT_player_state == PLAYER_INTERMSN) ){
      if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
        setcursormode( 0 );
        menu_exit();
        return;
      }
      menu_enter( MENU_SCORE_ACTIVE );
      menu_chat_config(FALSE);
      if(  ENT_SERVER_INFO.gameType == GAMEMODE_COOP  ){
        MENU_DEBRIEF_time_elapsed = -1;
        ui_set_mission_status( ENT_SERVER_INFO.missionResult );
        MENU_respawn_cool_start = servertime + SERVER_SCORE_TIME_COOP;
      }
      else{
        MENU_respawn_cool = servertime + SERVER_SCORE_TIME_DM;
      }
      MENU_respawn_cool = servertime + 15;
      MENU_respawn_cool_start = servertime;
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT connect during end of round
    if( (CLIENT_player_state_prev != PLAYER_SPAWN) && (CLIENT_player_state == PLAYER_INTERMSN) ){
      menu_enter( MENU_SCORE_ACTIVE );
      menu_chat_config(FALSE);
      //MENU_button_delay = servertime + 1;
      MENU_respawn_cool = servertime + 15;
      MENU_respawn_cool_start = servertime;
    }
    //------------------------------------
  }
//==============================================
};


/*
  SVQC: Map_HUD_Highlight entity
  this recieves a temp ent message from the server to highlight a part of the player's HUD,
  usually bound to an existing HUD widget via partTypeId.
*/
void() client_get_hud_highlight={
  local entity hfx;
  local float t;
  local float fnd;
  
  hfx = spawn();
  hfx.drawmask = MASK_ENGINE;
  hfx.data_idx = -3;  //more hacks
  hfx.classname = "UI_HIGHLIGHT"; //constant-in-code so no worry about zoning the value.
  
  hfx.drawcolor1 = te_read_vector();
  t = ReadShort();
  hfx.partTypeId = ReadByte();
  hfx.partParentId = 0;
  
  fnd = 0;
  while( fnd < 32 ){
    if( UI_DATA_UIDS[fnd] == hfx.partTypeId ){
      if( hfx.partParentId == 0 ){
        hfx.partParentId = fnd;
      }
    }
    fnd = fnd + 1;
  }
  hfx.drawsize = te_read_vector();  //we still send a prospective size because some HUD elements don't have a defined size?
  
  if( hfx.partTypeId == 0 || !hfx.partTypeId ){
    hfx.origin = te_read_vector();
  }
  
  hfx.drawme = time + (t / 3);
};

/*
  SVQC: TE_MSN_Boundary
    not really used in the original game, however, if a modder wants arbirary map limits,
      this is a means to notify the player they're reaching the boundary.
*/
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
  HUD_WARN_ENV_ON = TRUE;
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
  local vector backpanelOrg, backpanelSize;
  local float backSize;
  
  //state controller
  switch( MISSION_NAME_STATE ){
    case 1:
      MISSION_NAME_COLOR_x = gui_colorFadeTo( CLR_DEF_TXT_HIGHLIGHT_x, MISSION_NAME_COLOR_x, 0.004 );
      MISSION_NAME_COLOR_y = gui_colorFadeTo( CLR_DEF_TXT_HIGHLIGHT_y, MISSION_NAME_COLOR_y, 0.004 );
      MISSION_NAME_COLOR_z = gui_colorFadeTo( CLR_DEF_TXT_HIGHLIGHT_z, MISSION_NAME_COLOR_z, 0.004 );
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
      freeGlobalString(MISSION_NAME)
      drawfont = drawfont_prev;
      return;
  }
  if( MISSION_NAME_ALPHA > 1 ){
    MISSION_NAME_ALPHA = 1;
  }
  else if( MISSION_NAME_ALPHA < 0 ){
    MISSION_NAME_ALPHA = 0;
  }
  backpanelSize = '34 34 0';
  backpanelOrg = MISSION_NAME_ORG - '2 2';

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_DYSTOPIAN;

    backSize = stringwidth(MISSION_NAME, 0, '18 18') / 2 ;
    backpanelOrg_x = VIEW_CTR_x - backSize;
    backpanelOrg_y = VIEW_CTR_y - 66;
    drawstring( backpanelOrg, MISSION_NAME, '18 18', '0 0 0', MISSION_NAME_ALPHA - 0.25, 0);
    
    drawstring( MISSION_NAME_ORG, MISSION_NAME, '16 16', MISSION_NAME_COLOR, MISSION_NAME_ALPHA, 0);
  drawfont = drawfont_prev;
};

/*
  server Mapping = client_sendMissionName();
  receive map's mission name, and diplay it while the player boots up.
*/
void( string name ) client_event_mission_name={
  local string missionName;
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
    missionName = substring( name, 0, noNewLine);
    cacheGlobalString(MISSION_NAME, missionName )
    
    nameLen = stringwidth(MISSION_NAME, 0, '16 16 0');
    nameLen = nameLen / 2 ;
    
    newOrg_x = VIEW_CTR_x - nameLen;
    newOrg_y = VIEW_CTR_y - 64;
    MISSION_NAME_ORG = newOrg;
  drawfont = drawfont_prev;
};

void(string infoMessage, vector infoColor, float infoLifetime, vector fontSize) client_event_info_box={
  local float infoBoxY;
  
  HUD_INFO_MARK = time + infoLifetime;
  if( HUD_INFO_ON != TRUE ){
    HUD_INFO_ON = TRUE;
    freeGlobalString(HUD_INFO_MSG)
    cacheGlobalString(HUD_INFO_MSG, infoMessage )
  }
  else{
    if( HUD_INFO_MSG != infoMessage ){
      //already on, override message
      freeGlobalString(HUD_INFO_MSG)
      cacheGlobalString(HUD_INFO_MSG, infoMessage )
    }
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  HUD_INFO_SIZE_x = 256;
  
  HUD_INFO_ORG_x = VIEW_MAX_x - HUD_INFO_SIZE_x;
  HUD_INFO_ORG_y = VIEW_ORG_y + 128;
  
  infoBoxY = gui_wrapText_getHeight(HUD_INFO_ORG + '8 8', HUD_INFO_SIZE - '16 16', HUD_INFO_MSG, fontSize);
  HUD_INFO_SIZE_y = infoBoxY;
  
  drawfont = drawfont_prev;
  
};

/*
  server Mapping = client_send_campaign_end_data();
  
  receives end-of-mission player data, usually 
  for either player death, or player campaign / coop end.
*/
void() client_campaign_end_data={
  MENU_DEBRIEF_total_kills = ReadLong();
  MENU_DEBRIEF_total_losses = ReadLong();
  MENU_DEBRIEF_total_monsters = ReadLong();
  MENU_DEBRIEF_total_allies = ReadLong();
};

/*
  server Mapping = client_send_dm_end_data();

  Client-specific data captured over a DM/TDM match 
  and sent at end-of-round.
*/
void() client_dm_end_data={
  CLIENT_dmg_total = ReadLong();
};

/*
  server Mapping = client_sendEndMission();
  
  receives end-mission data from server,
  launches MENU_DEBRIEF screen.  
*/
void( float missonSuccessCheck, float pscTotal, float survestTotal, float militarTotal, float totalLosses ) client_event_debrief_active={
  MISSION_TIME_END = servertime;
  MENU_DEBRIEF_time_elapsed = (MISSION_TIME_END - MISSION_TIME_START);
  MENU_DEBRIEF_time_elapsed = MENU_DEBRIEF_time_elapsed / 100;
  //MENU_DEBRIEF_time_elapsed = MENU_DEBRIEF_time_elapsed / 60;
  
  MENU_DEBRIEF_total_kills = stof(getplayerkeyvalue(player_localnum, "frags"));
  MENU_DEBRIEF_total_monsters = survestTotal + militarTotal;
  MENU_DEBRIEF_total_allies = pscTotal;
  
  MENU_DEBRIEF_status = missonSuccessCheck;
  
  MENU_DEBRIEF_total_losses = totalLosses;
  
  menu_enter( MENU_DEBRIEF_ACTIVE);
  CLIENT_player_state = PLAYER_BRIEF;
};

/*
  Converts trace_plane_normal into useable angles, 
  sourced: moddb tutorial.
*/
vector() util_trace_norm_angle={
  local vector norm;
  local vector normAng;
  norm = trace_plane_normal;
  norm_x = 0 - norm_x;
  norm_y = 0 - norm_y;
  normAng = vectoangles(norm);
  return normAng;
};
