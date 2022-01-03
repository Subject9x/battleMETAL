/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  Called by 
    client_main.CSQC_InputEvent();
  
  This catch-all function handles all custom mod input events.
*/

float(float inputEventType, float scanx, float chary, float devid) handle_input_keydown={


};

/*
  CHAT_INP_ON == TRUE
    intercept keystrokes to process player chat.
*/
float(float inputEventType, float scanx, float chary, float devid) handle_input_chat={
  local string newText;
  
  //Player submits chat line to server
  if( scanx == K_ENTER ){
    if( strlen(CHAT_INP_VAL) != 0 ){
      if( CHAT_INP_ON_TEAM ){
        newText = sprintf("%s %s %s\n", CS_PRINT, SAY_MSG2, CHAT_INP_VAL );
      }
      else{
        newText = sprintf("%s %s %s\n", CS_PRINT, SAY_MSG1, CHAT_INP_VAL );
      }
      localcmd(strcat("cmd ", newText));
    }
    CHAT_INP_ON = FALSE;
    CHAT_INP_ON_TEAM = FALSE;
    //freeGlobalString(CHAT_INP_VAL)
    CHAT_INP_SEND = TRUE;
    return TRUE;
  }
  //handle backspace event
  if( scanx == K_BACKSPACE && strlen(CHAT_INP_VAL) != 0){
    newText = substring(CHAT_INP_VAL, 0, strlen(CHAT_INP_VAL) - 1);
    freeGlobalString(CHAT_INP_VAL)
    cacheGlobalString( CHAT_INP_VAL, newText)
    return TRUE;
  }
  //prevent line max overflow
  if( strlen(CHAT_INP_VAL) > CHAT_INP_MAX){
    return TRUE;
  }
  newText = substring(CHAT_INP_VAL, 0, strlen(CHAT_INP_VAL));
  freeGlobalString(CHAT_INP_VAL)
  
  //space in chat line
  if( scanx == K_SPACE ){
    newText = strcat(newText, " ");
  }
  else{
    if( textfilter_validate( scanx, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_UPP) ) ){
      newText = strcat(newText, keynumtostring(chary));
    }
  }
  cacheGlobalString( CHAT_INP_VAL, newText)
  return TRUE;
};



/*
  Client_state == PLAYER_MECH
*/
float(float inputEventType, float scanx, float chary, float devid) handle_mech_input={

};

/*
  MENU_ACTIVE
*/
float(float inputEventType, float scanx, float chary, float devid) handle_menu_input={

};

/*
  Main input function
  
  PRVM_G_FLOAT(OFS_PARM0) = eventtype;
  PRVM_G_FLOAT(OFS_PARM1) = x; // key or x
  PRVM_G_FLOAT(OFS_PARM2) = y; // ascii or y
  
  (taken from original CSQC comments)
  typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
  typ 1 = keyup (keysym, may have unicode character but generally not)
  typ 2 = mousemove (scanx, charY) if inputmode is off
  typ 3 = mousepos (scanx, charY) if inputmode is on
  return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
*/
float(float inputEventType, float scanx, float chary, float devid) handle_input={
//INPUT IMMEDIATES / OVERRIDES
  if(inputEventType == INPUT_EVENT_KEYDOWN){
    //console override-----
    if( (scanx == K_TIL) || (scanx == K_APOS) || (scanx == K_ESCAPE) ){
      if( CHAT_INP_ON ){
        CHAT_INP_ON = FALSE;
        return FALSE;
      }
      return FALSE; 
    }
    //=====================
    //CHAT TOGGLE
    if( strstrofs(findkeysforcommand("messagemode", 0), ftos(scanx),0) != -1 || strstrofs(findkeysforcommand("messagemode2", 0), ftos(scanx),0) != -1 ){
      if( CHAT_INP_ON == FALSE){
        CHAT_INP_ON = TRUE;
        if(strstrofs(findkeysforcommand("messagemode2", 0), ftos(scanx),0) != -1){
          CHAT_INP_ON_TEAM = TRUE;
        }
        return TRUE;
      }
    }
    if( CHAT_INP_ON ){
      return handle_input_chat(inputEventType, scanx, chary, devid);
    }
  }
  
//player mech powerup prevents input events
  if( (CLIENT_player_state == PLAYER_POWERUP_BEGIN) && inputEventType != INPUT_EVENT_MOUSE_POS ){
    return TRUE;
  }
//=====================
  
//Stops animatic playback by pressing space bar
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN ){
    //not sure if skipping cut-scenes during co-op games is even possible.
    if( ANM_FILE_STATUS == 1 ){
      if( inputEventType == INPUT_EVENT_KEYUP ){
        if( scanx == K_SPACE || scanx == K_MOUSE1){
           anm_new_frame(time);
          return TRUE;
        }
      }
    }
  }
//=====================
  
//Main input block here

  //keyboard input
  if(inputEventType == INPUT_EVENT_KEYDOWN){
    //PLAYER :: OBSERVER-------------------------------------------
    if(CLIENT_data_type == DATA_POBS){
      if( scanx == K_TAB ){
        if( (CLIENT_player_state != PLAYER_INTERMSN) && MENU_ACTIVE ){
          if( CLIENT_MENU_menu_choice != MENU_DEBRIEF_ACTIVE ){
            if( cvar("developer") ){
              menu_exit();
            }
          }
        }
        else{
          if( CLIENT_player_state != PLAYER_INTERMSN ){
            cons_logAFloat("CLIENT_player_state != PLAYER_INTERMSN", 1);  //DEBUG
            menu_enter( CLIENT_MENU_menu_choice );
          }else{
            menu_exit();
          }
        }
        return TRUE;
      }
    }
    //---------------------------------------------------------------
    //PLAYER :: MECH PLAY-------------------------------------------
    if(CLIENT_data_type == DATA_MECH){
      if( scanx == K_TAB){
        input_key_toggle_score();
        return TRUE;
      }
      if(scanx == K_SHIFT){
        //INPUT - MOVEMENT - SPRINT carve-out
        //pass to engine to engage sprint
        return FALSE;
      }
      
      if( strstrofs(findkeysforcommand("impulse 12", 0), ftos(scanx),0) != -1 ){
        input_key_impulse_hud_tacmap();
        return TRUE;
      }
      
      if( strstrofs(findkeysforcommand("impulse 25", 0), ftos(scanx),0) != -1 ){
        input_key_impulse_hud_objectives();
        return TRUE;
      }
      
      if( strstrofs(findkeysforcommand("+button9", 0), ftos(scanx),0) != -1 ){
        input_key_impulse_hud_zoom();
        return FALSE;
      }
      
      if( strstrofs(findkeysforcommand("impulse 8", 0), ftos(scanx),0) != -1 ){
        input_key_impulse_hud_radar_toggle();
        return FALSE;
      }
      
      if( strstrofs(findkeysforcommand("impulse 30", 0), ftos(scanx),0) != -1 ){
        input_key_impulse_hud_chase_toggle();
        return FALSE; //we pass the event to the server for correct player aiming.
      }
      if( strstrofs(findkeysforcommand("impulse 10", 0), ftos(scanx),0) != -1 ){
        //INPUT - HUD - Toggle Group Fire
        hud_event_enqueue( HUD_EVENT_FIREMODE_GROUP, 1) ;
        return FALSE;
      }
      if( strstrofs(findkeysforcommand("impulse 11", 0), ftos(scanx),0) != -1 ){
        //INPUT - HUD - Toggle Chain Fire
        hud_event_enqueue( HUD_EVENT_FIREMODE_CHAIN, 1) ;
        return FALSE;
      }
      if( strstrofs(findkeysforcommand("impulse 31", 0), ftos(scanx),0) != -1 ){
        //INPUT - MENU - firegroup rebind
        if( CLIENT_player_state == PLAYER_ACTIVE ){
          if( CLIENT_MENU_menu_choice == 0 && !MENU_ACTIVE){
            menu_enter( MENU_REBIND_ACTIVE );
            REBIND_SEND_TIME = time + REBIND_SEND_TIME_MIN;
          }
          else{
            menu_exit();
            //spam guard
            if( time > REBIND_SEND_TIME ){
              cl_setweapongroup( CLIENT_MENU_nex_grp1, CLIENT_MENU_nex_grp2, CLIENT_MENU_nex_grp3, CLIENT_MENU_nex_grp4 );
              cl_send_infostring( INFO_FLAG_GROUPS );
            }
          }
        }
        return TRUE;
      }
    }
    //---------------------------------------------------------------
  }
  
  
  //EVENT - MOUSE CURSOR MOVEMENT---------------------------------
  if(inputEventType == INPUT_EVENT_MOUSE_POS){
    if(MENU_ACTIVE){
      cursorpos_x = cursorpos_x + scanx;
      cursorpos_y = cursorpos_y + chary;
      if(cursorpos_x < 0){
        cursorpos_x = 0;
      }
      else if(cursorpos_x > VIEW_MAX_x){
        cursorpos_x = VIEW_MAX_x;
      }
      
      if(cursorpos_y < VIEW_ORG_y){
        cursorpos_y = VIEW_ORG_y;
      }
      else if(cursorpos_y > VIEW_MAX_y){
        cursorpos_y = VIEW_MAX_y;
      }
      return TRUE;
    }
    else{
      return FALSE;
    }
  }
  //-------------------------------------------------------------
  
  //Mouse input
  if( inputEventType == INPUT_EVENT_KEYDOWN ){
    if(scanx == K_MOUSE1){
      INPUT_mouse_state_prev = INPUT_mouse_state;
      INPUT_mouse_state = MOUSE_DOWN;
      
      if( MENU_ACTIVE ){
        switch( CLIENT_MENU_menu_choice ){
          case MENU_HANGAR_ACTIVE:
            menu_hangarListener_onClick();
            break;
          case MENU_BRIEF_ACTIVE:
            menu_briefListener_onClick();
            break;
          case MENU_ARMING_ACTIVE:
            menu_armingListener_onClick();
            break;
          case MENU_DEPLOY_ACTIVE:
            menu_deployListener_onClick();
            break;
          case MENU_DEBRIEF_ACTIVE:
            menu_debriefListener_onClick();
            break;
          case MENU_CONNECT_ACTIVE:
            menu_connectListener_onClick();
            break;
          case MENU_SCORE_ACTIVE:
            menu_scoreListener_onClick();
            break;
          case MENU_REBIND_ACTIVE:
            menu_rebindListener_onClick();
            break;
        }
        return TRUE;
      }
    }
    return FALSE;
  }
  
  if( inputEventType == INPUT_EVENT_KEYUP ){
    if( CHAT_INP_ON ) {
      return TRUE;
    }
    if( scanx == K_MOUSE1 ){
      INPUT_mouse_state_prev = INPUT_mouse_state;
      INPUT_mouse_state = MOUSE_UP;
      MOUSE_drag_timer = 0;
      if(MENU_ACTIVE){
        switch( CLIENT_MENU_menu_choice ){
          //case MENU_HANGAR_ACTIVE:
            //menu_hangarListener_onKeyUp();
            //break;
          //case MENU_BRIEF_ACTIVE:
            //menu_briefListener_onKeyUp();
            //break;
          case MENU_ARMING_ACTIVE:
            menu_armingListener_onKeyUp();
            break;
          //case MENU_DEPLOY_ACTIVE:
            //menu_deployListener_onKeyUp();
            //break;
        }
        if( CLIENT_MENU_menu_choice != MENU_DEBRIEF_ACTIVE && CLIENT_MENU_menu_choice != MENU_CONNECT_ACTIVE ){
          menu_mainListener();
        }
        return TRUE;
      }
    }
    if( strstrofs(findkeysforcommand("+button9", 0), ftos(scanx),0) != -1 ){
      //good lord....
      HUD_ZOOM_ACTIVE = FALSE;
      return FALSE;
    }
    return FALSE;
  }
   
  if(MENU_ACTIVE){
    //always consume CSQC menu input when they're active, otherwise random input will be propagated to server!
    return TRUE;
  }
  return FALSE;
};

/*
  Called every CSQC update frame.
  When player is 'dragging' the mouse 
*/
void() handle_input_drag={
  if( INPUT_mouse_state == MOUSE_DOWN ){
    if( MOUSE_drag_timer < MOUSE_drag_max ){
      MOUSE_drag_timer = MOUSE_drag_timer + MOUSE_drag_rate;
    }
    if( MOUSE_drag_timer >= MOUSE_drag_max){
      INPUT_mouse_state_prev = MOUSE_DOWN;
      INPUT_mouse_state = MOUSE_DRAG;
      switch( CLIENT_MENU_menu_choice ){
        case MENU_HANGAR_ACTIVE:
          menu_hangarListener_onDrag();
          break;
        case MENU_BRIEF_ACTIVE:
          menu_briefListener_onDrag();
          break;
        case MENU_ARMING_ACTIVE:
          menu_armingListener_onDrag();
          break;
        case MENU_DEPLOY_ACTIVE:
          menu_deployListener_onDrag();
          break;
      }
    } 
  }
};

/*
  Called when mouse is moved.
  Used here to primarily drive tooltip functionality.
  Parameter names altered slightly for call-stack purposes.
*/
void() handle_input_hover={
  if( INPUT_mouse_state == MOUSE_UP ){
    switch( CLIENT_MENU_menu_choice ){
      case MENU_BRIEF_ACTIVE:
        menu_briefListener_onHover();
        break;
      case MENU_HANGAR_ACTIVE:
        menu_hangarListener_onHover();
        break;
      case MENU_ARMING_ACTIVE:
        menu_armingListener_onHover();
        break;
      case MENU_DEPLOY_ACTIVE:
        menu_deployListener_onHover();
        break;
      case MENU_DEBRIEF_ACTIVE:
        menu_debriefListener_onHover();
        break;
      case MENU_CONNECT_ACTIVE:
        menu_connectListener_onHover();
        break;
      case MENU_SCORE_ACTIVE:
        menu_scoreListener_onHover();
        break;
    } 
  }
};