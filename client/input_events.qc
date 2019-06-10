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
  CLIENT_player_state = getstatf(STAT_PLR_STT);
  
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
        if(MENU_ACTIVE){
          MENU_ACTIVE = FALSE;
          CLIENT_MENU_menu_choice = 0;
          setcursormode(0);
        }
        else{
          MENU_ACTIVE = TRUE;
          CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
          setcursormode(1);
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
  }
  else if(inputEventType == INPUT_EVENT_MOUSE_MOVE){
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
	  //mouse drag-and-drop logic
	  INPUT_mouse_state_prev = INPUT_mouse_state;
	  if( (time > MOUSE_drag_timer) && (INPUT_mouse_state != MOUSE_DRAG) ){
		MOUSE_drag_timer = time + MOUSE_drag_trigger;
		INPUT_mouse_state = MOUSE_DOWN;
	  }
	  if( (time == MOUSE_drag_timer) && (INPUT_mouse_state != MOUSE_DRAG) ){
		INPUT_mouse_state = MOUSE_DRAG;
	  }
	  
	  if(MENU_ACTIVE){
		switch( CLIENT_MENU_menu_choice ){
		  case MENU_HANGAR_ACTIVE:
			menu_hangarListener();
			break;
		  case MENU_BRIEF_ACTIVE:
			menu_briefListener();
			break;
		  case MENU_ARMING_ACTIVE:
			menu_arming_listener();
			break;
		  case MENU_DEPLOY_ACTIVE:
			menu_deployListener();
			break;
		}
		menu_mainListener();
		return TRUE;
	  }
	  else{
		return FALSE;
	  }
	}
  }
  else if( inputEventType == INPUT_EVENT_KEYUP ){
	if( scanx == K_MOUSE1 ){
	  INPUT_mouse_state_prev = INPUT_mouse_state;
	  INPUT_mouse_state == MOUSE_UP;
	  //
	  if(MENU_ACTIVE){
		switch( CLIENT_MENU_menu_choice ){
		  case MENU_HANGAR_ACTIVE:
			menu_hangarListener();
			break;
		  case MENU_BRIEF_ACTIVE:
			menu_briefListener();
			break;
		  case MENU_ARMING_ACTIVE:
			menu_arming_listener();
			break;
		  case MENU_DEPLOY_ACTIVE:
			menu_deployListener();
			break;
		}
		menu_mainListener();
	  }
	}
  }
   
  if(MENU_ACTIVE){
    return TRUE;
  }
  return FALSE;
};
