/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  Called by 
    client_main.CSQC_InputEvent();
  
  This catch-all function handles all custom mod input events.
  
  (taken from original CSQC comments)
  typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
  typ 1 = keyup (keysym, may have unicode character but generally not)
  typ 2 = mousemove (scanX, charY) if inputmode is off
  typ 3 = mousepos (scanX, charY) if inputmode is on
  return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
*/

float(float inputEventType, float scanx, float chary, float devid) handle_input={
  CLIENT_player_state = getstati(STAT_ARMOR);
  
//console override-----
  if(inputEventType == INPUT_EVENT_KEYDOWN){
    if( (scanx == K_TIL) || (scanx == K_APOS) || (scanx == K_ESCAPE) ){
      return FALSE; 
    }
  }
//=====================
  
//player mech powerup prevents input events
  if( (CLIENT_player_state == PLAYER_POWERUP_BEGIN) ){
    return TRUE;
  }
//=====================
  
//Stops animatic playback by pressing space bar
  if( ANM_FILE_STATUS == 1 ){
    if( scanx == K_SPACE ){
      cl_exit_animatic();
    }
  }
//=====================
  
//Main input block here

  //keyboard input
  if(inputEventType == INPUT_EVENT_KEYDOWN){
    if( (scanx == K_TAB) && (CLIENT_data_type == DATA_POBS) ){
      if( (CLIENT_player_state != PLAYER_INTERMSN) && MENU_ACTIVE ){
        if( CLIENT_MENU_menu_choice != MENU_DEBRIEF_ACTIVE ){
          MENU_ACTIVE = FALSE;
          CLIENT_MENU_menu_choice = 0;
          setcursormode( 0 );
          setpause( 0 );
        }
      }
      else{
        if( CLIENT_player_state != PLAYER_INTERMSN ){
          MENU_ACTIVE = TRUE;
          CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
          setcursormode( 1 );
          setpause( 1 );
        }
      }
      return TRUE;
    }
    else if(scanx == K_C){
      if(UI_OBJECTIVE_ACTIVE){
        UI_OBJECTIVE_ACTIVE = FALSE;
      }
      else{
        UI_OBJECTIVE_ACTIVE = TRUE;
      }
      return TRUE;
    }
    else if(scanx == K_SHIFT){
      return FALSE;
    }
    else if( strstrofs(findkeysforcommand("+button9", 0), ftos(scanx),0) != -1 ){
      //good lord....
      HUD_ZOOM_ACTIVE = TRUE;
      return FALSE;
    }
    else if( strstrofs(findkeysforcommand("impulse 8", 0), ftos(scanx),0) != -1 ){
      //Toggle Radar
      CLIENT_stat_rdr_mode = !CLIENT_stat_rdr_mode;
      if(CLIENT_stat_rdr_mode_prev != CLIENT_stat_rdr_mode){
        CLIENT_stat_rdr_mode_prev = CLIENT_stat_rdr_mode;
        if(CLIENT_stat_rdr_mode){
          hud_event_enqueue(HUD_EVENT_RADAR_ACTIVE, 1); 
          CLIENT_radar_range = CLIENT_radar_range * 2;
        }
        else{
          hud_event_enqueue(HUD_EVENT_RADAR_PASSIVE, 1); 
          CLIENT_radar_range = CLIENT_radar_range / 2;
        }
      }
      //return false here to make sure player choice gets up to server.
      return FALSE;
    }
    else if( strstrofs(findkeysforcommand("impulse 10", 0), ftos(scanx),0) != -1 ){
      //Toggle Group Fire
      hud_event_enqueue( HUD_EVENT_FIREMODE_GROUP, 1) ;
      return FALSE;
    }
    else if( strstrofs(findkeysforcommand("impulse 11", 0), ftos(scanx),0) != -1 ){
      //Toggle Chain Fire
      hud_event_enqueue( HUD_EVENT_FIREMODE_CHAIN, 1) ;
      return FALSE;
    }
  }
  else if(inputEventType == INPUT_EVENT_MOUSE_POS){
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
        }
        return TRUE;
      }
    }
    return FALSE;
  }
  else if( inputEventType == INPUT_EVENT_KEYUP ){
    if( scanx == K_MOUSE1 ){
      INPUT_mouse_state_prev = INPUT_mouse_state;
      INPUT_mouse_state = MOUSE_UP;
      MOUSE_drag_timer = 0;      
      if(MENU_ACTIVE){
        switch( CLIENT_MENU_menu_choice ){
          case MENU_HANGAR_ACTIVE:
            //menu_hangarListener_onKeyUp();
            break;
          case MENU_BRIEF_ACTIVE:
            //menu_briefListener_onKeyUp();
            break;
          case MENU_ARMING_ACTIVE:
            menu_armingListener_onKeyUp();
            break;
          case MENU_DEPLOY_ACTIVE:
            //menu_deployListener_onKeyUp();
            break;
        }
        if( CLIENT_MENU_menu_choice != MENU_DEBRIEF_ACTIVE ){
          menu_mainListener();
        }
        return TRUE;
      }
    }
    else if( strstrofs(findkeysforcommand("+button9", 0), ftos(scanx),0) != -1 ){
      //good lord....
      HUD_ZOOM_ACTIVE = FALSE;
      return FALSE;
    }
    
    return FALSE;
  } 
   
  if(MENU_ACTIVE){
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
    } 
  }
};