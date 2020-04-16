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
    
    CLIENT_weapon_state = getstati(STAT_PLAYER_WEAPONS_STATE);
    
    CLIENT_stat_w1_rel = getstatf(STAT_CLIENT_WEAPON1_RELOAD);
    CLIENT_stat_w2_rel = getstatf(STAT_CLIENT_WEAPON2_RELOAD);
    CLIENT_stat_w3_rel = getstatf(STAT_CLIENT_WEAPON3_RELOAD);
    CLIENT_stat_w4_rel = getstatf(STAT_CLIENT_WEAPON4_RELOAD);
    CLIENT_stat_w5_rel = getstatf(STAT_CLIENT_WEAPON5_RELOAD);
    CLIENT_stat_w6_rel = getstatf(STAT_CLIENT_WEAPON6_RELOAD);
    CLIENT_stat_w7_rel = getstatf(STAT_CLIENT_WEAPON7_RELOAD);
    CLIENT_stat_w8_rel = getstatf(STAT_CLIENT_WEAPON8_RELOAD);
    CLIENT_stat_w9_rel = getstatf(STAT_CLIENT_WEAPON9_RELOAD);
  }
};

/*
  Reads off addstat() data into Client_* vars.
*/
void() receive_ent_bindData={
  local string name;
  
  name = cvar_string("_cl_name");

  CLIENT_flags = getstati( STAT_ROCKETS );
  CLIENT_faction = getstati( STAT_PLAYER_FACTION );
  CLIENT_player_state = getstati( STAT_PLAYER_STATE );
  CLIENT_player_deadflag = getstati(STAT_PLAYER_DEADFLAG);
  CLIENT_data_type = getstati(STAT_PLAYER_DATA_TYPE);
  CLIENT_data_idx = getstati(STAT_PLR_DATA_IDX);

  if( CLIENT_data_type == DATA_MECH ){
    if( name != CLIENT_netname){
      if( CLIENT_netname != ""){
        strunzone( CLIENT_netname );
      }
      CLIENT_netname = strzone( name );
    }

    if( getstatf(STAT_CLIENT_ENERGY) > 0 ){
      CLIENT_energy = getstatf(STAT_CLIENT_ENERGY);
    }
    else{
      CLIENT_energy = 0;
    }
    if( getstatf(STAT_CLIENT_ENERGY) > 0 ){
      CLIENT_shield = getstatf(STAT_CLIENT_SHIELD);
    }
    else{
      CLIENT_shield = 0;
    }
    
    CLIENT_stat_lock_state = getstati(STAT_LCK_STT);
    CLIENT_stat_rdr_mode = getstati(STAT_PLR_RADMOD);
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
    CLIENT_target_dist_prev = CLIENT_target_dist;
    CLIENT_stat_trg_ddflg_prev = CLIENT_stat_trg_ddflg;
    
    CLIENT_stat_trg_ent_id_prev = CLIENT_stat_trg_ent_id;
    CLIENT_stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
    CLIENT_target_origin_x = getstatf(STAT_TARGET_ORIGINX);
    CLIENT_target_origin_y = getstatf(STAT_TARGET_ORIGINY);
    CLIENT_target_origin_z = getstatf(STAT_TARGET_ORIGINZ);
    CLIENT_target_shield = getstatf(STAT_TARGET_SHIELDS);
    CLIENT_target_dist = getstati(STAT_TRG_DIST);
    CLIENT_target_vecsize = getstati(STAT_TARGET_SIZE);

    CLIENT_stat_trg_dataidx = getstati(STAT_TRG_DATAIDX);
    CLIENT_stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
    CLIENT_stat_trg_face = getstati(STAT_TRG_FACE);
    CLIENT_target_datatype = getstati(STAT_TRG_DATATYPE);
    CLIENT_target_faction = getstati(STAT_TRG_FACTION);
    CLIENT_stat_trg_ddflg = getstati(STAT_TRG_DDFLG);
    
    CLIENT_stat_trg_ct_hp = getstatf(STAT_TARGET_HP_TORSOCENTER);
    CLIENT_stat_trg_lt_hp = getstatf(STAT_TARGET_HP_TORSOLEFT); 
    CLIENT_stat_trg_rt_hp = getstatf(STAT_TARGET_HP_TORSORIGHT); 
    CLIENT_stat_trg_la_hp = getstatf(STAT_TARGET_HP_ARMLEFT);
    CLIENT_stat_trg_ra_hp = getstatf(STAT_TARGET_HP_ARMRIGHT);
    CLIENT_stat_trg_lg_hp = getstatf(STAT_TARGET_HP_LEGS);
    
    //Critical hits
    if( CLIENT_player_state == PLAYER_ACTIVE || CLIENT_player_state == PLAYER_SPRINT_ON ){
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

    if( CLIENT_stat_trg_ent_id_prev != 0 && CLIENT_stat_trg_ent_id == -1 ){
      //target is lost
      if( CLIENT_stat_trg_ddflg_prev > DEAD_NO ){
        hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
      }
    }
    
    // hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
    CLIENT_repair_value = getstati(STAT_PLR_REP);
    
    CLIENT_stat_trg_ent_id_prev = CLIENT_stat_trg_ent_id;
  }
};

/*
  State controller for Client's playerState as picked up from Server
*/
void() client_state_events={
  if( CLIENT_player_state != CLIENT_player_state_prev ){
      cons_log2Float("CLIENT_player_state ", CLIENT_player_state_prev, "--->", CLIENT_player_state);  //debug
    //Player has just connected to server
    if( (CLIENT_player_state_prev == 0) && (CLIENT_player_state == PLAYER_CONNECT) ){
      cons_logAFloat("PLAYER_CONNECT", 1);  //debug
      localcmd(strcat("stopsound", "\n"));
      cl_set_hud_vars_obs();
      return;
    }
  
    //EVENT - CLIENT FIRST TIME CONNECT---
    if( (CLIENT_player_state_prev == PLAYER_CONNECT) && (CLIENT_player_state == PLAYER_SPAWN) ){
      cons_logAFloat("PLAYER_SPAWN", 1);  //debug
      //mission file load check
      if(MSN_FILEFOUND){
        if(MSN_LOADED == FALSE){
          msn_parsefile();
          MSN_LOADED = TRUE;
        }
      }
      if( !MENU_ACTIVE ){
        menu_enter( menu_connect_choice() );
      }
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT ENTERS MECH---
    if( (CLIENT_player_state_prev == PLAYER_SPAWN) && (CLIENT_player_state == PLAYER_POWERUP_BEGIN) ){
      cons_logAFloat("PLAYER_POWERUP_BEGIN", 1);  //debug
      if( MECH_DATA_ID != CLIENT_data_idx ){
        ui_data_load_mech(CLIENT_data_idx);
      }
      hud_event_clear();
      hud_event_enqueue( HUD_EVENT_POWERUP, 1);
      SV_PLAYERTIME = servertime;
      menu_exit();
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT DEATH----------------
    if( (CLIENT_player_state_prev != PLAYER_DEAD) && (CLIENT_player_state == PLAYER_DEAD) ){
      cons_logAFloat("PLAYER_DEAD", 1);  //debug
      if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
        if( SV_MISSIONSTATUS == MISSION_STATUS_WIN ){
          te_mission_win();
        }
        else{
          te_mission_lose();
        }
        SV_ENDTIMELIMIT = servertime;
      }
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT CAMPAIGN DEBRIEF DEATH
    if( (CLIENT_player_state_prev == PLAYER_DEAD) && (CLIENT_player_state == PLAYER_DEBRIEF) ){
      cons_logAFloat("PLAYER_DEBRIEF", 1);  //debug
      menu_enter( MENU_DEBRIEF_ACTIVE );
      MENU_button_delay = servertime + 2;
      
      if( SV_MISSIONSTATUS == MISSION_STATUS_WIN ){
        MENU_DEBRIEF_data_mission_status = "- Mission Successful -";
      }
      else{
        MENU_DEBRIEF_data_mission_status = "!- Mission Failed -!";
      }
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT NET RESPAWN
    if( (CLIENT_player_state_prev == PLAYER_DEAD) && (CLIENT_player_state == PLAYER_REDEPLOY) ){
      cons_logAFloat("PLAYER_REDEPLOY", 1);  //debug
      menu_enter( MENU_CONNECT_ACTIVE );
      MENU_button_delay = servertime + 1;
      MENU_respawn_cool = servertime + 15;
      MENU_respawn_cool_start = servertime;
      return;
    }
    //------------------------------------
    
    //EVENT - CLIENT END OF DM/TDM
    if( (CLIENT_player_state_prev != PLAYER_INTERMSN) && (CLIENT_player_state == PLAYER_INTERMSN) ){
      cons_logAFloat("PLAYER_INTERMSN", 1);  //debug
      menu_enter( MENU_SCORE_ACTIVE );
      if( cvar("gamemode") == GAMEMODE_DM ){
        
      }
      MENU_button_delay = servertime + 1;
      //MENU_respawn_cool = servertime + 15;
      //MENU_respawn_cool_start = servertime;
    }
    //------------------------------------
    
    //EVENT - CLIENT connect during end of round
    if( (CLIENT_player_state_prev != PLAYER_SPAWN) && (CLIENT_player_state == PLAYER_INTERMSN) ){
      cons_logAFloat("PLAYER_INTERMSN", 1);  //debug
      menu_enter( MENU_SCORE_ACTIVE );
      if( cvar("gamemode") == GAMEMODE_DM ){
        
      }
      MENU_button_delay = servertime + 1;
      //MENU_respawn_cool = servertime + 15;
      //MENU_respawn_cool_start = servertime;
    }
    //------------------------------------
  }
//==============================================
};



void() client_get_hud_highlight={
  local entity hfx;
  local float t;
  
  hfx = spawn();
  hfx.data_idx = -3;  //more hacks
  hfx.origin = te_read_vector();
  hfx.drawsize = te_read_vector();
  hfx.drawcolor1 = te_read_vector();
  t = ReadShort();
  hfx.drawme = time + (t / 3);
  
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
  
  drawstring( MISSION_NAME_ORG, MISSION_NAME, '32 32 0', '1 1 1', MISSION_NAME_ALPHA, 0);
  drawstring( MISSION_NAME_ORG, MISSION_NAME, '32 32 0', MISSION_NAME_COLOR, MISSION_NAME_ALPHA, 0);
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
    nameLen = stringwidth(MISSION_NAME, 0, '32 32 0');
    nameLen = gui_percentXRaw( nameLen / 2 );
    newOrg_x = VIEW_CTR_x - nameLen;
    newOrg_y = VIEW_CTR_y - gui_percentYRaw( 96 );
    MISSION_NAME_ORG = newOrg;
  drawfont = drawfont_prev;
};

void(string infoMessage, vector infoColor, float infoLifetime, vector fontSize) client_event_info_box={
  local float infoBoxY;
  local string replace;
  
  HUD_INFO_MARK = time + infoLifetime;
  if( HUD_INFO_ON != TRUE ){
    HUD_INFO_ON = TRUE;
    HUD_INFO_MSG = strzone( infoMessage );
  }
  else{
    if( HUD_INFO_MSG != infoMessage ){
      //already on, override message
      replace = HUD_INFO_MSG;
      HUD_INFO_MSG = strzone( infoMessage );
      strunzone(replace);
    }
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  infoBoxY = gui_wrapText(VIEW_ORG, gui_percentToPixelRawVec('256 256'), HUD_INFO_MSG, fontSize, infoColor, 1) ;
  HUD_INFO_SIZE_x = gui_percentXRaw( 256 );
  HUD_INFO_SIZE_y = infoBoxY;
  
  HUD_INFO_ORG_x = VIEW_CTR_x - (HUD_INFO_SIZE_x / 2);
  HUD_INFO_ORG_y = VIEW_CTR_y - (HUD_INFO_SIZE_y / 2);
  
  drawfont = drawfont_prev;
  
};

/*
  server Mapping = client_send_server_info_update()
  
*/
void() client_get_serverinfo={
  SV_MISSIONSTATUS = ReadByte();
  SV_STARTTIME = ReadLong();
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
  
  if( MENU_DEBRIEF_status > 0 ){
    MENU_DEBRIEF_data_mission_status = "- Mission Successful -";
  }
  else{
    MENU_DEBRIEF_data_mission_status = "!- Mission Failed -!";
  }
  
  menu_enter( MENU_DEBRIEF_ACTIVE);
  CLIENT_player_state = PLAYER_BRIEF;
};
