/*
battleMETAL
Author: Peter Roohr
Date: 08/06/2021
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

//API - split down by key - then context filter

/*
  0 : exit chat
  1 : new chat

*/
void(float event) input_key_chat_event={
  if( event == 0 ){
    //exit chat
    return;
  }
  if( event == 1 ){
    //new chat
    
    return;
  }

};



void() input_key_toggle_score={
  //INPUT - HUD - SHOW SCORES
  if(HUD_SCORES_ON){
    HUD_SCORES_ON = FALSE;
  }
  else{
    HUD_SCORES_ON = TRUE;
  }
};

void() input_key_impulse_hud_tacmap={
  //INPUT - HUD - TACTICAL MAP
  if( MSN_MAPPIC != "" ){
    if(HUD_TACMAP_ON){
      HUD_TACMAP_ON = FALSE;
    }
    else{
      HUD_TACMAP_ON = TRUE;
      if( UI_OBJECTIVE_ACTIVE ){
        UI_OBJECTIVE_ACTIVE = FALSE;
      }
    }
  }
};

void() input_key_impulse_hud_objectives={
  //INPUT - HUD - OBJECTIVES DISPLAY
  if(UI_OBJECTIVE_ACTIVE){
    UI_OBJECTIVE_ACTIVE = FALSE;
  }
  else{
    UI_OBJECTIVE_ACTIVE = TRUE;
    if( HUD_TACMAP_ON ){
      HUD_TACMAP_ON = FALSE;
    }
  }
};

void() input_key_impulse_hud_zoom={
  //INPUT - HUD - ZOOM WINDOW
  //good lord....
  HUD_ZOOM_ACTIVE = TRUE;
};

void() input_key_impulse_hud_radar_toggle={
  //INPUT - HUD - TOGGLE RADAR MODE
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
};


void() input_key_impulse_hud_chase_toggle={
  //INPUT - HUD - set chase_active
  if( HUD_EXTERNAL_CAM_ACTIVE == TRUE ){
    HUD_EXTERNAL_CAM_ACTIVE = FALSE;
    localcmd("chase_active 0\n");
    if(hudStruts != world ){
      hudStruts.drawmask = MASK_ENGINE;
    }
    if(hudConsole != world ){
      hudConsole.drawmask = MASK_ENGINE;
    }
    ui_data_load_hud( MECH_DATA_ID );
  }
  else{
    if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
      return;
    }
    ui_data_load_hud( 0 );
    
    HUD_EXTERNAL_CAM_ACTIVE = TRUE;
    localcmd("chase_active 1\n");
    if(hudStruts != world ){
      hudStruts.drawmask = 0;
    }
    if(hudConsole != world ){
      hudConsole.drawmask = 0;
    }
  }
  
};

    /*else if( strstrofs(findkeysforcommand("impulse 7", 0), ftos(scanx),0) != -1 ){
      //INPUT - player wants target
      return FALSE; //we pass the event to the server for correct player aiming.
    }
    else if(scanx == K_K){
      cons_logAFloat("VIEW_OBS_ID", VIEW_OBS_ID); //debug
      if( VIEW_OBS_ID == 2 ){
        VIEW_OBS_ID = 1;
      }
      return TRUE;
    }
    else if(scanx == K_L ){
      cons_logAFloat("VIEW_OBS_ID", VIEW_OBS_ID); //debug
      if(VIEW_OBS_ID == 1){
        VIEW_OBS_ID = 2;
      }
      return TRUE;
    }*/