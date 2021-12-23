/*
battleMETAL
Author: Peter Roohr
Date: 04/11/2020
Overview: 
  End of Round score screen for DM / TDM / Coop(?) games
  also shown when player dies.
*/

//pseudo interface
void() menu_scoreListener_onClick={
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, UI_NAVBAR_DISCONNECT_SIZE, TRUE)){
    ui_navbutton_disconnect_click();
    return;
  }
  
  //the 'ready up' system, never implemented, and probably too complex.
  /*if( cvar("gamemode") == GAMEMODE_COOP ){
    if(menu_checkMouseInBounds(cursorpos, MENU_SCORE_READY_ORG, '128 24', TRUE)){
      //ui_navbutton_coop_ready_click();
      return;
    }
  }*/
};

//void() menu_scoreListener_onDrag={};

void() menu_scoreListener_onHover={
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, UI_NAVBAR_DISCONNECT_SIZE, FALSE)){
    UI_NAVBAR_DISCONNECT_HOVER = TRUE;
    return;
  }
  else{
    UI_NAVBAR_DISCONNECT_HOVER = FALSE;
  }
};

//void() menu_scoreListener_onKeyUp={};

void() menu_score_drawFrame={
  local vector topleftroot;
  local vector botrightroot;
  //local vector rulesOrg;
  
  topleftroot = UI_ORG;
  botrightroot = UI_MAX;
  
  drawfill(VIEW_ORG, VIEW_MAX, '0.15 0.15 0.15', 1, 0);
  
  //Navbar
  menu_score_draw_bar( UI_ORG );
  
  if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
    menu_score_coop_nav( topleftroot );
    
    menu_connect_draw_chat( topleftroot+ '256 32', '368 144', '0.35 0.35 0.55', 1);
    
    menu_score_coop_players( topleftroot + '0 32' );
    
    menu_score_coop_server_info( topleftroot + '0 128' );
    
    menu_score_coop_mission_info( topleftroot + '256 176' );
    menu_score_coop_status( topleftroot + '256 176' );
    
    menu_score_coop_client_stats(topleftroot + '0 256');
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
    //nav bar
    menu_score_tdm_nav(topleftroot);
    
    //chat - TDM
    menu_connect_draw_chat( topleftroot+ '240 32', '384 144', '0.35 0.35 0.55', 1);
    
    //mission info - TDM
    menu_score_tdm_server_info( topleftroot + '0 32' );
    //server flags - TEAM DM
    menu_connect_draw_rules_team( topleftroot + '24 128' );
    //objectives stats - TEAM DM
    menu_score_tdm_objectives( topleftroot + '240 176' );
    //player stats
    menu_score_tdm_client_info( topleftroot + '0 208' );
    //player list
    menu_connect_draw_players_team( topleftroot + '0 304' );
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
    menu_score_dm_nav(topleftroot);
    //mission info - DM
    menu_serverinfo_basic(topleftroot + '0 32');
    
    //server flags - DM
    menu_connect_draw_rules_dm( topleftroot + '240 32' );
    
    //chat - dm
    menu_connect_draw_chat( topleftroot + '353 32', '262 144', '0.35 0.35 0.55', 1);
    
    //Server About - DM
    menu_connect_draw_about_dm( topleftroot + '320 182' );
    
    //player list - DM
    menu_draw_players_basic( topleftroot + '0 182' );
    
    //player stats - DM
    menu_score_dm_client_info( topleftroot + '320 325' );
    return; 
  }
};
//------------------

//DEATHMATCH SCORE SCREEN
void( vector menuOrg ) menu_score_dm_nav={  
  local float t, sec;
  local string text;
  local vector labelOrg;
  local vector nextMapMeterOrg;
  
  t = SERVER_SCORE_TIME_DM - (servertime - MENU_respawn_cool_start); 
  sec = t - floor( t / 60 ) * 60 ;
  sec = rint(sec);
  text = sprintf("%02d", sec);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    labelOrg = menuOrg + '315 7';
    drawstring( labelOrg, "Next Round in:", '14 14', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring( labelOrg + '90 -1',text, '16 16', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  nextMapMeterOrg = menuOrg + '445 0';
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_DM - sec) / SERVER_SCORE_TIME_DM) * 100, nextMapMeterOrg, '175 32', CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_dm_client_info={
  local vector labelOrg;
  local float labelLen;
  local vector fontsStyle;
  local string mechName;

  gui_renderPatch9_1_32(menuOrg, '160 96', CLR_UI_PSC_BRIEF * 0.8, 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("Player Stats", 0, '10 10');
    labelOrg_x = menuOrg_x + 75 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "Player Stats", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + '22 14', "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '12 12' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + '10 28', "Your Deaths :", ftos(CLIENT_deaths), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '12 12' );
  
  //Best survival time
  gui_labelKeyPair( menuOrg + '20 42', "Best Time :", ui_calculate_time_string(CLIENT_best_time), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Best Surviving Mech
  if( CLIENT_best_mech > 0 ){
    mechName = MECH_DATA_NAMES[CLIENT_best_mech];
  }
  else{
    mechName = "<none>";
  }
  gui_labelKeyPair( menuOrg + '18 58', "Best Mech :", MECH_DATA_NAMES[CLIENT_best_mech], CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Total Damage output
  gui_labelKeyPair( menuOrg + '4 72', "Total Damage :", ftos(CLIENT_dmg_total), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
};

//-----------------------

//TEAM DEATHMATCH SCORE SCREEN
void( vector menuOrg ) menu_score_tdm_nav={
  local float t, sec;
  local string text;
  local vector labelOrg;
  local vector nextMapMeterOrg;
  
  t = SERVER_SCORE_TIME_DM - (servertime - MENU_respawn_cool_start); 
  sec = t - floor( t / 60 ) * 60 ;
  sec = rint(sec);
  text = sprintf("%02d", sec);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    labelOrg = menuOrg + '335 6';
    drawstring( labelOrg, "Next Round in:", '14 14', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring( labelOrg + '90 -0',text, '16 16', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  nextMapMeterOrg = menuOrg + '445 0';
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_DM - sec) / SERVER_SCORE_TIME_DM) * 100, nextMapMeterOrg, '175 32', CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_tdm_server_info={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string scoreLimit;
  
  gui_renderPatch9_1_32(menuOrg, '208 176', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + '10 4';
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + '10 14', "Mode :", "Team Deathmatch", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + '0.5 28', "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Map filename
  //gui_labelKeyPair( leftAnchor + '14.5 42', "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + '0 42', "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Frag Limit
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "[NONE]";
  }
  gui_labelKeyPair( leftAnchor + '2 56', "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Time Limit
  gui_labelKeyPair( leftAnchor + '2 70', "Time :", ui_calculate_time_string(SV_ENDTIME), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');  
  
  //Game Status
  gui_labelKeyPair( leftAnchor + '2 84', "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );

};

void( vector menuOrg ) menu_score_tdm_objectives={
  local vector labelOrg;
  local float labelLen;
  
  gui_renderPatch9_1_32(menuOrg, '384 128', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Team Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + 210 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "- Team Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_score_tdm_client_info={
  local vector labelOrg;
  local float labelLen;
  
  local string imgPath;
  local vector backColor;
  local vector fontsStyle;
  local string mechName;
  
  if( CLIENT_faction == FACTION_SURVEST ){
    backColor = CLR_UI_PSC_BRIEF;
    imgPath = "gfx/ui/ui_icon_survest.png";
  }
  else{
    backColor = CLR_UI_PSC_BRIEF;
    imgPath = "gfx/ui/ui_icon_militar.png";
  }
  
  
  gui_renderPatch9_1_32(menuOrg, '208 80', backColor * 0.8, 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Player Stats -", 0, '10 10');
    labelOrg_x = menuOrg_x + 104 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "- Player Stats -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + '24 14', "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '10 10' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + '12 25', "Your Deaths :", ftos(CLIENT_deaths), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '10 10' );
  
  //Best survival time
  gui_labelKeyPair( menuOrg + '22 36', "Best Time :", ui_calculate_time_string(CLIENT_best_time), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Best Surviving Mech
  if( CLIENT_best_mech > 0 ){
    mechName = MECH_DATA_NAMES[CLIENT_best_mech];
  }
  else{
    mechName = "<none>";
  }
  gui_labelKeyPair( menuOrg + '20 47', "Best Mech :", MECH_DATA_NAMES[CLIENT_best_mech], CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Total Damage output
  gui_labelKeyPair( menuOrg + '6 58', "Total Damage :", ftos(CLIENT_dmg_total), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  drawpic( menuOrg + '148 10', imgPath, '64 64', '0.75 0.75 0.75', 1, 0);
};
//-----------------------


//COOP SCORE SCREEN
void( vector menuOrg ) menu_score_coop_nav={
  //local vector playerReadyOrg;
  //local vector playerReadyLblOrg;
  local vector nextMapMeterOrg;
  local float t, sec;
  local string text;
  
  /*
  MENU_SCORE_READY_ORG = playerReadyOrg = menuOrg + '275 0';
  drawpic( playerReadyOrg, UI_DEF_BOX_256_BTN, '128 24', CLR_DEF_ARM_OK * 0.85, 1, 0 );
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    playerReadyLblOrg_x = playerReadyOrg_x + 64 - (stringwidth("<Ready Up>", 0, '14 14') / 2);
    playerReadyLblOrg_y = playerReadyOrg_y + 5;
    drawstring( playerReadyLblOrg, "<Ready Up>", '14 14', CLR_DEF_ARM_OK * 1.25, 1, 0 );
  drawfont = drawfont_prev;
  */
  
  t = SERVER_SCORE_TIME_COOP - (servertime - MENU_respawn_cool_start); 
  sec = t - floor( t / 60 ) * 60 ;
  sec = rint(sec);
  text = sprintf("%02d", sec);
  
  nextMapMeterOrg = menuOrg + '445 0';
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_COOP - sec) / SERVER_SCORE_TIME_COOP) * 100, nextMapMeterOrg, '175 32', CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_coop_server_info={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string serverStatus;
  local string serverTime;
  
  gui_renderPatch9_1_32(menuOrg, '244 128', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  //commented out sections are intentional
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + '8 4';
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + '8 14', "Mode :", "Cooperative", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + '1.25 28', "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Map filename
  //gui_labelKeyPair( leftAnchor + '12.25 42', "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + '0 42', "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Frag Limit
  /*local string scoreLimit;
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + '2 70', "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );*/
  
  serverStatus = ui_label_mission_status();
  
  //Time Limit
  if( serverStatus == "Complete" ){
    serverTime =  ui_calculate_time_string(SV_TIMELIMIT);
  }
  else{
    serverTime = ui_calculate_time_string(SV_ENDTIME);
  }
  gui_labelKeyPair( leftAnchor + '10.5 70', "Time :", serverTime, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');
  
  //Game Status
  gui_labelKeyPair( leftAnchor + '5.5 56', "Server :", serverStatus, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
};

/*
  background and anchor for objectives list
*/ 
void( vector menuOrg ) menu_score_coop_mission_info={
  local vector labelOrg;
  local float labelLen;
  local vector statusColor;
  
  gui_renderPatch9_1_32(menuOrg, '376 304', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  if( MENU_DEBRIEF_status == MISSION_RESULT_WIN ){
    statusColor = CLR_DEF_ARM_OK;
  }
  else{
    statusColor = CLR_DEF_ARM_ONEQ;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth(MENU_DEBRIEF_data_mission_status, 0, '14 14');
    labelOrg_x = menuOrg_x + 210 - (labelLen/2);
    labelOrg_y = menuOrg_y + 4;
    drawstring( labelOrg, MENU_DEBRIEF_data_mission_status, '14 14', statusColor, 1, 0);
  drawfont = drawfont_prev;
  
};

/*
  render objectives list
*/
void( vector menuOrg ) menu_score_coop_status={
  local vector labelOrg;
  local float labelLen;

  local vector lofs;
  local float lst_idx, eol, line_rtn;
  local vector objectiveOffset;
  local string desc;
  local string text;
  
  local string objectiveStatusLabel;
  local float objectiveStatus;
  local vector objectiveColor;
  local vector objectiveStatusOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + 210 - (labelLen/2);
    labelOrg_y = menuOrg_y + 20;
    drawstring( labelOrg, "- Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  lofs = menuOrg + '8 35';
  lst_idx = 1;
  line_rtn = 0;
  objectiveOffset_x = lofs_x + 2;
  objectiveOffset_y = lofs_y + line_rtn + 3;
  eol = TRUE;
  while(eol){
    objectiveStatus = OBJECTIVES[lst_idx];
    
    if( objectiveStatus == OBJECTIVE_WIN ){
      objectiveStatusLabel = "Complete";
      objectiveColor = CLR_DEF_ARM_OK;
    }
    else if( objectiveStatus == OBJECTIVE_ACTIVE ){
      objectiveStatusLabel = "Incomplete";
      objectiveColor = CLR_DEF_TXT_NONSELECT - '0.1 0.1 0.1';
    }
    else if( objectiveStatus == OBJECTIVE_FAIL ){
      objectiveStatusLabel = "Failed";
      objectiveColor = CLR_DEF_ARM_ONEQ;
    }
    else{
      objectiveStatusLabel = "In Progress";
      objectiveColor = CLR_DEF_ARM_THREEQ;
    }
    
    desc = MSN_OBJ_DESC[lst_idx];
    text = strcat( ftos(lst_idx),") ", desc);
    line_rtn = gui_wrapText(objectiveOffset, '320 150', text, '12 12 0', CLR_DEF_TXT_NONSELECT, 1);
    
    objectiveStatusOrg_x = menuOrg_x + 335;
    objectiveStatusOrg_x = objectiveStatusOrg_x - (stringwidth(objectiveStatusLabel,0,'14 14') / 2); 
    objectiveStatusOrg_y = objectiveOffset_y;
    drawstring( objectiveStatusOrg, objectiveStatusLabel, '14 14 0', objectiveColor, 1,0);
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + 12;
  }
  drawfont = drawfont_prev;
};
    
void( vector menuOrg ) menu_score_coop_players={
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float playerRowItr;
  local float itr;
  
  uiParentSize = '244 96';
  
  gui_renderPatch9_1_32(menuOrg, uiParentSize, CLR_UI_PSC_BRIEF * 0.9, 1, DRAWFLAG_NORMAL);
 
  menu_connect_draw_scorebar( menuOrg, "- Players -", FALSE);
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = menuOrg_x + 2;
  listOfs_y = menuOrg_y + 14;

  itr = 0;
  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] != 0 ){
      player = findfloat(world, clientLocalId, SCOREBOARD[itr]);
      listRowOfs_x = menuOrg_x + 8;
      listRowOfs_y = listOfs_y + ( playerRowItr * 16 );
      menu_player_row_basic( listRowOfs, playerRowItr, player, FALSE );
      playerRowItr = playerRowItr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};
  
void( vector menuOrg ) menu_score_coop_client_stats={
  local vector labelOrg;
  local float labelLen;
  
  local vector fontsStyle;
  
  gui_renderPatch9_1_32(menuOrg, '150 112','0.95 0.95 0.95', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Mission Stats -", 0, '10 10');
    labelOrg_x = menuOrg_x + 75 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "- Mission Stats -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + '20 14', "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '12 12' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + '8 28', "Your Deaths :", ftos(CLIENT_deaths), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '12 12' );
  
  //Team Score
  gui_labelKeyPair( menuOrg + '18 42', "Total Kills :", ftos(MENU_DEBRIEF_total_kills), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Team Losses
  gui_labelKeyPair( menuOrg + '31 58', "Losses :", ftos(MENU_DEBRIEF_total_losses), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Elapsed Time
  gui_labelKeyPair( menuOrg + '4 72', "Time Elapsed :", ui_calculate_time_string(SV_ENDTIME), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
};
//-----------------------

void( vector menuOrg ) menu_score_draw_bar={
  ui_navbutton_disconnect_draw( menuOrg );
};