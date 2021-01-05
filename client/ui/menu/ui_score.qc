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
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), TRUE)){
    ui_navbutton_disconnect_click();
    return;
  }
  
  //the 'ready up' system, never implemented, and probably too complex.
  /*if( cvar("gamemode") == GAMEMODE_COOP ){
    if(menu_checkMouseInBounds(cursorpos, MENU_SCORE_READY_ORG, gui_percentToPixelRawVec('128 24'), TRUE)){
      //ui_navbutton_coop_ready_click();
      return;
    }
  }*/
};

//void() menu_scoreListener_onDrag={};

void() menu_scoreListener_onHover={
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), FALSE)){
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
  local vector rulesOrg;
  
  topleftroot = VIEW_ORG;
  botrightroot = VIEW_MAX;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '0.85 0.85 0.85', 1, 0);
  
  //Navbar
  menu_score_draw_bar( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
  
  if( SV_GAMETYPE == GAMEMODE_COOP ){
    menu_score_coop_nav( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
    
    menu_score_coop_server_info( topleftroot + gui_percentToPixelRawVec('32 32') );
    
    menu_score_coop_mission_info( topleftroot + gui_percentToPixelRawVec('254 32') );
    
    menu_score_coop_status( topleftroot + gui_percentToPixelRawVec('254 32') );
    
    menu_score_coop_players( topleftroot + gui_percentToPixelRawVec('10 120') );
    
    menu_score_coop_client_stats(topleftroot + gui_percentToPixelRawVec('56 220'));
  }
  else if( SV_GAMETYPE == GAMEMODE_TEAMDM ){
    //nav bar
    menu_score_tdm_nav(  VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') ) ;
    //mission info - TDM
    menu_score_tdm_server_info( topleftroot + gui_percentToPixelRawVec('10 32') );
    //server flags - TEAM DM
    menu_connect_draw_rules_team( topleftroot + gui_percentToPixelRawVec('24 128') );
    //objectives stats - TEAM DM
    menu_score_tdm_objectives( topleftroot + gui_percentToPixelRawVec('195 32') );
    //player stats
    menu_score_tdm_client_info( topleftroot + gui_percentToPixelRawVec('10 200') );
    //player list
    menu_connect_draw_players_team( topleftroot + gui_percentToPixelRawVec('10 282') );
  }
  else if( SV_GAMETYPE == GAMEMODE_DM ){
    menu_score_dm_nav( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
    //mission info - DM
    menu_serverinfo_basic(topleftroot + gui_percentToPixelRawVec('10 32'));
    
    //server flags - DM
    rulesOrg_x = VIEW_CTR_x;
    rulesOrg_y = VIEW_ORG_y;
    menu_connect_draw_rules_dm( rulesOrg + gui_percentToPixelRawVec('-85 32') );
    
    //Server About - DM
    menu_connect_draw_about_dm( rulesOrg + gui_percentToPixelRawVec('20 32') );
    
    //player list - DM
    menu_draw_players_basic( topleftroot + gui_percentToPixelRawVec('10 182') );
    
    //player stats - DM
    menu_score_dm_client_info( topleftroot + gui_percentToPixelRawVec('320 182') );
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
    labelOrg = menuOrg + gui_percentToPixelRawVec('315 7');
    drawstring( labelOrg, "Next Round in:", '14 14', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring( labelOrg + gui_percentToPixelRawVec('90 -1'),text, '16 16', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  nextMapMeterOrg = menuOrg + gui_percentToPixelRawVec('445 0');
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_DM - sec) / SERVER_SCORE_TIME_DM) * 100, nextMapMeterOrg, gui_percentToPixelRawVec('175 32'), CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_dm_client_info={
  local vector labelOrg;
  local float labelLen;
  local vector fontsStyle;
  local string mechName;

  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('150 90'), CLR_UI_PSC_BRIEF * 0.8, 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Player Stats -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(75) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
    drawstring( labelOrg, "- Player Stats -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('22 14'), "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '12 12' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('10 28'), "Your Deaths :", ftos(getstati(STAT_PLAYER_DEATHS)), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '12 12' );
  
  //Best survival time
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('20 42'), "Best Time :", ui_calculate_time_string(CLIENT_best_time), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Best Surviving Mech
  if( CLIENT_best_mech > 0 ){
    mechName = MECH_DATA_NAMES[CLIENT_best_mech];
  }
  else{
    mechName = "<none>";
  }
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('18 58'), "Best Mech :", MECH_DATA_NAMES[CLIENT_best_mech], CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Total Damage output
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('4 72'), "Total Damage :", ftos(CLIENT_dmg_total), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
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
    labelOrg = menuOrg + gui_percentToPixelRawVec('335 6');
    drawstring( labelOrg, "Next Round in:", '14 14', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring( labelOrg + gui_percentToPixelRawVec('90 -0'),text, '16 16', CLR_DEF_TXT_HIGHLIGHT, 1, 0 );
  drawfont = drawfont_prev;
  
  nextMapMeterOrg = menuOrg + gui_percentToPixelRawVec('445 0');
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_DM - sec) / SERVER_SCORE_TIME_DM) * 100, nextMapMeterOrg, gui_percentToPixelRawVec('175 32'), CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_tdm_server_info={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string scoreLimit;
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('185 168'), '0.65 0.65 0.65', 1, 0);
  
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + gui_percentToPixelRawVec('10 4');
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('10 14'), "Mode :", "Team Deathmatch", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0.5 28'), "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Map filename
  //gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('14.5 42'), "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0 42'), "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Frag Limit
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "[NONE]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 56'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Time Limit
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 70'), "Time :", ui_calculate_time_string(SV_ENDTIME), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');  
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 84'), "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );

};

void( vector menuOrg ) menu_score_tdm_objectives={
  local vector labelOrg;
  local float labelLen;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('435 250'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Team Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
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
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('185 80'), backColor * 0.8, 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Player Stats -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(75) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
    drawstring( labelOrg, "- Player Stats -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('22 14'), "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '10 10' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('10 25'), "Your Deaths :", ftos(getstati(STAT_PLAYER_DEATHS)), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '10 10' );
  
  //Best survival time
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('20 36'), "Best Time :", ui_calculate_time_string(CLIENT_best_time), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Best Surviving Mech
  if( CLIENT_best_mech > 0 ){
    mechName = MECH_DATA_NAMES[CLIENT_best_mech];
  }
  else{
    mechName = "<none>";
  }
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('18 47'), "Best Mech :", MECH_DATA_NAMES[CLIENT_best_mech], CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Total Damage output
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('4 58'), "Total Damage :", ftos(CLIENT_dmg_total), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  drawpic( menuOrg + gui_percentToPixelRawVec('110 2'), imgPath, gui_percentToPixelRawVec('64 64'), '0.75 0.75 0.75', 1, 0);
};
//-----------------------


//COOP SCORE SCREEN
void( vector menuOrg ) menu_score_coop_nav={
  local vector playerReadyOrg;
  local vector playerReadyLblOrg;
  local vector nextMapMeterOrg;
  local float t, sec;
  local string text;
  
  /*
  MENU_SCORE_READY_ORG = playerReadyOrg = menuOrg + gui_percentToPixelRawVec('275 0');
  drawpic( playerReadyOrg, UI_DEF_BOX_256_BTN, gui_percentToPixelRawVec('128 24'), CLR_DEF_ARM_OK * 0.85, 1, 0 );
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    playerReadyLblOrg_x = playerReadyOrg_x + gui_percentXRaw(64) - gui_percentXRaw(stringwidth("<Ready Up>", 0, '14 14') / 2);
    playerReadyLblOrg_y = playerReadyOrg_y + gui_percentYRaw(5);
    drawstring( playerReadyLblOrg, "<Ready Up>", '14 14', CLR_DEF_ARM_OK * 1.25, 1, 0 );
  drawfont = drawfont_prev;
  */
  
  t = SERVER_SCORE_TIME_COOP - (servertime - MENU_respawn_cool_start); 
  sec = t - floor( t / 60 ) * 60 ;
  sec = rint(sec);
  text = sprintf("%02d", sec);
  
  nextMapMeterOrg = menuOrg + gui_percentToPixelRawVec('445 0');
  
  gui_renderMeter( ( (SERVER_SCORE_TIME_COOP - sec) / SERVER_SCORE_TIME_COOP) * 100, nextMapMeterOrg, gui_percentToPixelRawVec('175 32'), CLR_DEF_GRAY_H * 0.67, CLR_DEF_IIF_FRIEND_BLD, 1, 0, AXIS_H, FALSE);
};

void( vector menuOrg ) menu_score_coop_server_info={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string serverStatus;
  local string serverTime;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('200 90'), '0.65 0.65 0.65', 1, 0);
  
  //commented out sections are intentional
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + gui_percentToPixelRawVec('6 4');
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('8 14'), "Mode :", "Cooperative", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('1.25 28'), "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Map filename
  //gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('12.25 42'), "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0 42'), "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Frag Limit
  /*local string scoreLimit;
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 70'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );*/
  
  serverStatus = ui_label_mission_status();
  
  //Time Limit
  if( serverStatus == "Complete" ){
    serverTime =  ui_calculate_time_string(SV_TIMELIMIT);
  }
  else{
    serverTime = ui_calculate_time_string(SV_ENDTIME);
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('10.5 70'), "Time :", serverTime, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('5.5 56'), "Server :", serverStatus, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
};

void( vector menuOrg ) menu_score_coop_mission_info={
  local vector labelOrg;
  local float labelLen;
  local vector statusColor;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('376 373'), '0.65 0.65 0.65', 1, 0);
  
  if( MENU_DEBRIEF_status == MISSION_RESULT_WIN ){
    statusColor = CLR_DEF_ARM_OK;
  }
  else{
    statusColor = CLR_DEF_ARM_ONEQ;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth(MENU_DEBRIEF_data_mission_status, 0, '14 14');
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(4);
    drawstring( labelOrg, MENU_DEBRIEF_data_mission_status, '14 14', statusColor, 1, 0);
  drawfont = drawfont_prev;
  
};

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
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(20);
    drawstring( labelOrg, "- Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  lofs = menuOrg + gui_percentToPixelRawVec('8 35');
  lst_idx = 1;
  line_rtn = 0;
  objectiveOffset_x = lofs_x + gui_percentXRaw(2);
  objectiveOffset_y = lofs_y + line_rtn + gui_percentYRaw(3);
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
    line_rtn = gui_wrapText(objectiveOffset, '300 150', text, '12 12 0', CLR_DEF_TXT_NONSELECT, 1);
    
    objectiveStatusOrg_x = menuOrg_x + gui_percentXRaw(335);
    objectiveStatusOrg_x = objectiveStatusOrg_x - gui_percentXRaw(stringwidth(objectiveStatusLabel,0,'14 14') / 2); 
    objectiveStatusOrg_y = objectiveOffset_y;
    drawstring( objectiveStatusOrg, objectiveStatusLabel, '14 14 0', objectiveColor, 1,0);
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + gui_percentYRaw(12);
  }
  drawfont = drawfont_prev;
};
    
void( vector menuOrg ) menu_score_coop_players={
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float playerRowItr;
  local float itr;
  
  uiParentSize = '244 100';
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(uiParentSize), CLR_UI_PSC_BRIEF * 0.9, 1, 0);

  menu_connect_draw_scorebar( menuOrg, "- Players -", FALSE);
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(2);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);

  itr = 0;
  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] != 0 ){
      player = findfloat(world, entId, SCOREBOARD[itr]);
      listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
      listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
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
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('150 90'), '0.95 0.95 0.95', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Mission Stats -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(75) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
    drawstring( labelOrg, "- Mission Stats -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  
  //Player Score
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('20 14'), "Your Kills :", getplayerkeyvalue(player_localnum, "frags"), CLR_DEF_GREEN, CLR_DEF_ARM_OK, fontsStyle, '12 12' );
  
  //Player Death
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('8 28'), "Your Deaths :", ftos(getstati(STAT_PLAYER_DEATHS)), CLR_DEF_TXT_NONSELECT, CLR_DEF_ARM_THREEQ, fontsStyle, '12 12' );
  
  //Team Score
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('18 42'), "Total Kills :", ftos(MENU_DEBRIEF_total_kills), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Team Losses
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('31 58'), "Losses :", ftos(MENU_DEBRIEF_total_losses), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Elapsed Time
  gui_labelKeyPair( menuOrg + gui_percentToPixelRawVec('4 72'), "Time Elapsed :", ui_calculate_time_string(SV_ENDTIME), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
};
//-----------------------

void( vector menuOrg ) menu_score_draw_bar={
  ui_navbutton_disconnect_draw( menuOrg );
};