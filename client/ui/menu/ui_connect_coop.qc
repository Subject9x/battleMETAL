/*
battleMETAL
Author: Peter Roohr
Date: 09/18/2020
Overview: 
  UI - connect screen for coop.
  
  pulled out to its own file for serious readability, sorry I didn't do this sooner.
  
*/
void( vector rootTop ) menu_connect_render_coop={
  
  //chat - COOP
  menu_connect_draw_chat( rootTop + '256 32', '368 144', '0.35 0.35 0.55', 1);
  
  //server info - COOP
  menu_connet_draw_coop_about( rootTop + '256 176' );
  
  //objectives stats - COOP
  menu_connect_draw_objectives_coop( rootTop + '256 240' );
  
  //player list - COOP
  menu_connect_draw_players_coop( rootTop + '0 32' );
  
  //mission info - COOP
  menu_connect_draw_mission_info_coop( rootTop + '0 128' );
  
  //server flags - COOP
  menu_connect_draw_coop_rules(  rootTop + '42 220' );
  
  //satmap - COOP;
  menu_connect_draw_satmap( rootTop + '22 288', '192 192' );
};

/*
  COOP INFO PANELS
*/
void( vector menuOrg ) menu_connect_draw_mission_info_coop={
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string serverStatus;
  local string serverTime;
  
  gui_renderPatch9_1_32(menuOrg, '244 173', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  // Server Name
  leftAnchor =  menuOrg + '6 4';
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", ENT_SERVER_INFO.netname, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + '8 14', "Mode :", "Cooperative", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + '1.25 28', "Players :", strcat(ftos(maxclients),"/4"), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Map filename
  gui_labelKeyPair( leftAnchor + '12.25 42', "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + '0 56', "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
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
    serverTime = ui_calculate_time_string(ENT_SERVER_INFO.ruleTimelimit);
  }
  else{
    serverTime = ui_calculate_game_time_string();
  }
  gui_labelKeyPair( leftAnchor + '10.5 70', "Time :", serverTime, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');
  
  //Game Status
  gui_labelKeyPair( leftAnchor + '5.5 84', "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
};

void( vector menuOrg ) menu_connet_draw_coop_about={
  local vector labelOrg;
  local float labelLen;
  
  gui_renderPatch9_1_32(menuOrg,  '376 64', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- About -", 0, '10 10');
    labelOrg = menuOrg;
    labelOrg_x = menuOrg_x + 188 - (labelLen / 2);
    labelOrg_y = menuOrg_y + 4;
    drawstring(labelOrg, "- About -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  if( strlen(ENT_SERVER_INFO.svAbout) > 0 ){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_MEDIUM;
      gui_wrapText(menuOrg + '6 16', '368 128', ENT_SERVER_INFO.svAbout, '10 10', CLR_DEF_TXT_GRAY_SMOOTH, 1);
    drawfont = drawfont_prev;
  }
};

void( vector menuOrg ) menu_connect_draw_coop_rules={  
  local vector labelOrg;
  local float labelLen;
  local vector leftAnchor;
  local vector ruleRow;
  
  local float listCount;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
  labelLen = stringwidth("- Server Rules -", 0, '12 12');
  labelOrg = menuOrg;
  labelOrg_x = menuOrg_x + 85 - (labelLen / 2);
  labelOrg_y = menuOrg_y + 4;
  drawstring(labelOrg, "- Server Rules -", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  
  leftAnchor = menuOrg + '2 20';
  ruleRow = leftAnchor;
  
  if( ENT_SERVER_INFO.serverFlags == 0 ){
    drawstring( ruleRow + Vector2( 85 - stringwidth("None", 0, '12 12') / 2, -4), "None", '12 12', CLR_DEF_WHITE, 1, 0);
    drawfont = drawfont_prev;
    return;
  }
  listCount = 0;
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_POWERUP) ){
    drawstring( ruleRow, "Freeze on Power-up", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 12;
    listCount = listCount + 1;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_CHEATS) ){
    drawstring( ruleRow, "Cheats Allowed", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 12;
    listCount = listCount + 1;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FIREON) ){
    drawstring( ruleRow, "Friendly Fire", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 12;
    listCount = listCount + 1;
  }
  /*if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOLIVES) ){
    drawstring( ruleRow, "One-life Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + 85;
      ruleRow_y = ruleRow_y - (listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + 12;
    }
    listCount = listCount + 1;
  }*/
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOMAP) ){
    drawstring( ruleRow, "Limited TacMap", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + 85;
      ruleRow_y = ruleRow_y - (listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + 12;
    }
    listCount = listCount + 1;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NORADAR) ){
    drawstring( ruleRow, "Passive Radar Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + 85;
      ruleRow_y = ruleRow_y - (listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + 12;
    }
    listCount = listCount + 1;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
    drawstring( ruleRow, "No External Cam", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + 85;
      ruleRow_y = ruleRow_y - (listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + 12;
    }
    listCount = listCount + 1;
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_objectives_coop={
  local vector labelOrg;
  local float labelLen;

  local vector bpos, lofs;
  local float lst_idx, eol, line_rtn;
  local vector objectiveOffset;
  local string desc;
  local string text;
  
  local string objectiveStatusLabel;
  local float objectiveStatus;
  local vector objectiveColor;
  local vector objectiveStatusOrg;
  
  gui_renderPatch9_1_32(menuOrg,  '376 240', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Mission Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + 210 - (labelLen/2);
    labelOrg_y = menuOrg_y + 6;
    drawstring( labelOrg, "- Mission Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  bpos = menuOrg;

  lofs = bpos + '8 24';
  lst_idx = 1;
  line_rtn = 0;
  objectiveOffset_x = lofs_x;
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
    line_rtn = gui_wrapText(objectiveOffset, '300 150', text, '12 12 0', CLR_DEF_TXT_NONSELECT, 1);
    
    objectiveStatusOrg_x = menuOrg_x + 335;
    objectiveStatusOrg_x = objectiveStatusOrg_x - (stringwidth(objectiveStatusLabel,0,'14 14') / 2); 
    objectiveStatusOrg_y = objectiveOffset_y;
    drawstring( objectiveStatusOrg, objectiveStatusLabel, '14 14 0', objectiveColor, 1, 0);
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + 12;
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_players_coop={
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float playerRowItr;
  local float itr;
  local string nameCheck;
  
  uiParentSize = '244 100';
  
  gui_renderPatch9_1_32(menuOrg, uiParentSize, CLR_UI_PSC_BRIEF * 0.9, 1, DRAWFLAG_NORMAL);

  menu_connect_draw_scorebar( menuOrg, "- Players -", FALSE);
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = menuOrg_x + 8;
  listOfs_y = menuOrg_y + 16;

  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(itr, "name");
      if( nameCheck != "" || nameCheck ){
        player = findfloat(world, clientLocalId, SCOREBOARD[itr] + 1);
        listRowOfs_x = menuOrg_x + 8;
        listRowOfs_y = listOfs_y + ( playerRowItr * 16 );
        menu_player_row_basic( listRowOfs, playerRowItr, player, FALSE );
        playerRowItr = playerRowItr + 1;
      }
    }
  }
  drawfont = drawfont_prev;
};