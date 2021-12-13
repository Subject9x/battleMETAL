/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  the entry function for the CSQC / client menu system.
  this code also handles menu bar (top buttons) input and it details
  the transition between menus.
*/

/*
  Primary menu rendering function, called by client_main.
  renders the NavBar at the top, along with the chosen menu sub function
*/
void() menu_handleFrame={
  local vector mpos;
  
  cursorpos = getmousepos();
  
  cursorImageSize = draw_getimagesize(UI_CURSOR_IMG);
  cursorImageSize =  gui_scaleSize(cursorImageSize, VIEW_SCALE/1.25);
  
  mpos_x = cursorpos_x - 2;
  mpos_y = cursorpos_y - 4;
  
  handle_input_drag();
  handle_input_hover();
  
  switch( CLIENT_MENU_menu_choice ){
    case MENU_HANGAR_ACTIVE:
      menu_hangarDrawFrame(); 
      break;
    case MENU_BRIEF_ACTIVE:
      menu_briefDrawFrame();
      break;
    case MENU_ARMING_ACTIVE:
      menu_arming_drawFrame();
      break;
    case MENU_DEPLOY_ACTIVE:
      menu_deployDrawFrame();
      break;
    case MENU_DEBRIEF_ACTIVE:
      menu_debrief_drawFrame();
      break;
    case MENU_CONNECT_ACTIVE:
      menu_connect_drawFrame();
      break;
    case MENU_SCORE_ACTIVE:
      menu_score_drawFrame();
      break;
    case MENU_REBIND_ACTIVE:
      menu_rebind_drawFrame();
      break;
  }

  if( toolTip.data_idx > FALSE ){
    gui_toolTipMessage(toolTip.description, toolTip.mins, toolTip.maxs, UI_DEF_BOX_512, '12 0', toolTip.angles, '0.85 0.85 0.85', 1 ); 
  }
  drawpic(mpos, UI_CURSOR_IMG, cursorImageSize, '1 1 1', 1, 0);
};

/*
  When Player clicks the mouse button, this runs a check to see if the mouse coords area
  within the function coords. If they are, return TRUE.
*/
float(vector mpos, vector org, vector sz, float playClickSound) menu_checkMouseInBounds={
  local vector areaSize;
  
  areaSize = org+sz;
  if( ((mpos_x > org_x) && (mpos_x < areaSize_x)) && ((mpos_y > org_y) && (mpos_y < areaSize_y)) ){
    if( playClickSound ){
      pointsound(pmove_org, "sound/misc/menu1.wav", 1, ATTN_NORM); //maybe not the best place for this.
    }
    return TRUE;
  }
  return FALSE;
};

/*
  calculates the screen-area of a list, determines if the mouse is within the bounds of one of these
  and returns the index number of the item if any'
*/
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener={
  local float listIndex, toSender;
  local vector listOffset;
  local float selectCheck;
  if( menu_checkMouseInBounds(cursorpos, org, list_size, FALSE) ){
    
    listIndex = 1;
    toSender = 0;
    
    while(listIndex <= max_items){
      listOffset_x = org_x;
      listOffset_y = org_y + (listIndex * row_size_y);
      
      selectCheck = menu_checkMouseInBounds(cursorpos, listOffset, row_size, FALSE);
   
      if( selectCheck ){
        gui_DrawRect(listOffset, listOffset + row_size, '2 2', '1 1 1');
        toSender = listIndex;
      }
      listIndex = listIndex + 1;
    }
    return toSender;
  }
  else{
    return 0;
  }
};

/*
  Default nav bar, but any menu can implment its own to customize this;
    just make sure the custom nav bar gets a custom onClick() func to match.
*/
void(vector ofs) menu_navBar_drawFrame={
  local vector nvpos;
  local vector launchPos;
  local vector arrowOrg;
    
  nvpos = ofs + '4 4';
  
  launchPos_x = UI_MAX_x - 138;
  launchPos_y = nvpos_y;
  
  ui_navbutton_brief_draw( nvpos );
  
  arrowOrg = nvpos;
  arrowOrg_y = arrowOrg_y + 4;
  arrowOrg_x = arrowOrg_x + (UI_NAVBAR_BRIEF_SIZE_x + 4);
  
  //drawpic( arrowOrg, HUD_TRG_PIP_R, UI_NAVAR_ARR_SIZE, '0.75 0.75 0.75', 1, 0);
  drawpic( arrowOrg, HUD_TRG_PIP_R, UI_NAVAR_ARR_SIZE, '0.75 0.75 0.75', 1, 0);
  
  ui_navbutton_hangar_draw( nvpos + '96 0' ) ;
  
  arrowOrg_x = arrowOrg_x + 96;
  drawpic( arrowOrg, HUD_TRG_PIP_R, UI_NAVAR_ARR_SIZE, '0.75 0.75 0.75', 1, 0);
  
  ui_navbutton_arming_draw( nvpos + '192 0' ) ;
  
  arrowOrg_x = arrowOrg_x + 96;
  drawpic( arrowOrg, HUD_TRG_PIP_R, UI_NAVAR_ARR_SIZE, '0.75 0.75 0.75', 1, 0);
  
  ui_navbutton_deploy_draw( nvpos + '288 0') ;
  
  if(  ENT_SERVER_INFO.gameType != GAMEMODE_CAMPAIGN ){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_MEDIUM;
       drawstring(nvpos + '420 -1', "Time Left:", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawfont = FONT_NUM_ROBOT_REGULAR;
       drawstring(nvpos + '420 11', ui_calculate_game_time_string(), '14 14', CLR_DEF_WHITE, 1, 0);
    drawfont = drawfont_prev;
  }
  ui_navbutton_launch_draw( launchPos ) ;
  
};

void() menu_mainListener={
  //stop briefing if its playing
  if(ANM_FILE_STATUS == 1){
    cl_exit_animatic();
  }
};

void() menu_navbBar_listener={

  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_BRIEF_ORG, UI_NAVBAR_BRIEF_SIZE, TRUE)){
    ui_navbutton_brief_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_HANGAR_ORG, UI_NAVBAR_HANGAR_SIZE, TRUE)){
    ui_navbutton_hangar_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_ARMING_ORG, UI_NAVBAR_ARMING_SIZE, TRUE)){
    ui_navbutton_arming_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DEPLOY_ORG, UI_NAVBAR_DEPLOY_SIZE, TRUE)){
    ui_navbutton_deploy_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_LAUNCH_ORG, UI_NAVBAR_LAUNCH_SIZE, FALSE)){
    ui_navbutton_launch_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, UI_NAVBAR_CONNECT_SIZE, TRUE)){
    ui_navbutton_connect_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_INFO_ORG, UI_NAVBAR_INFO_SIZE, TRUE)){
    ui_navbutton_info_click();
  }
};

void() mechAcceptButtonListener={

  if( menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ, FALSE) ){

  }
};

void( float fact ) menu_update_colors={
  switch( fact ){
    case FACTION_PSC:
      CLR_DEF_UI_BRIEF = CLR_UI_PSC_BRIEF;
      CLR_DEF_UI_HANGAR = CLR_UI_PSC_HANGAR;
      CLR_DEF_UI_ARMING = CLR_UI_PSC_ARMING;
      CLR_DEF_UI_DEPLOY = CLR_UI_PSC_DEPLOY;
      break;
    case FACTION_SURVEST:
      CLR_DEF_UI_BRIEF = CLR_UI_SRV_BRIEF;
      CLR_DEF_UI_HANGAR = CLR_UI_SRV_HANGAR;
      CLR_DEF_UI_ARMING = CLR_UI_SRV_ARMING;
      CLR_DEF_UI_DEPLOY = CLR_UI_SRV_DEPLOY;
      break;
    case FACTION_MILITAR:
      CLR_DEF_UI_BRIEF = CLR_UI_MIL_BRIEF;
      CLR_DEF_UI_HANGAR = CLR_UI_MIL_HANGAR;
      CLR_DEF_UI_ARMING = CLR_UI_MIL_ARMING;
      CLR_DEF_UI_DEPLOY = CLR_UI_MIL_DEPLOY;
      break;
    default:
      CLR_DEF_UI_BRIEF = CLR_UI_DM_BRIEF;
      CLR_DEF_UI_HANGAR = CLR_UI_DM_HANGAR;
      CLR_DEF_UI_ARMING = CLR_UI_DM_ARMING;
      CLR_DEF_UI_DEPLOY = CLR_UI_DM_DEPLOY;
      break;
  }
};

void( float menuId ) menu_enter={
  MENU_ACTIVE = TRUE;
  CLIENT_MENU_menu_choice = menuId;
  setcursormode( 1 );
};

void() menu_exit={
  MENU_ACTIVE = FALSE;
  CLIENT_MENU_menu_choice = 0;
  setcursormode( 0 );
};

float() menu_connect_choice={
  local float choice;
  switch( ENT_SERVER_INFO.gameType ){
    case GAMEMODE_CAMPAIGN:
      choice = MENU_BRIEF_ACTIVE;
      INFO_SWITCH = 1;
      break;
    default:
      choice = MENU_CONNECT_ACTIVE;
      break;
  }
  return choice;
};

// connect_dm and score_dm ui.
void( vector menuOrg ) menu_serverinfo_basic={
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string serverStatus;
  local string scoreLimit;
  
  local vector statusColor;
  
  gui_renderPatch9_1_32(menuOrg, '225 150', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  // Server Name
  leftAnchor =  menuOrg + '5 5';
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", ENT_SERVER_INFO.netname, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '14 14' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + '10 14', "Mode :", "Deathmatch", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + '0.5 28', "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Map filename
  gui_labelKeyPair( leftAnchor + '14.5 42', "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + '0 56', "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Frag Limit
  if( ENT_SERVER_INFO.ruleFraglimit > 0 ){
    scoreLimit = ftos(ENT_SERVER_INFO.ruleFraglimit);
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + '8 70', "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  serverStatus = ui_label_mission_status();
  //Time Limit
  if( serverStatus == "Complete" ){
    gui_labelKeyPair( leftAnchor + '12 84', "Time :", ui_calculate_time_string(ENT_SERVER_INFO.ruleTimelimit), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12');  
  }
  else{
    gui_labelKeyPair( leftAnchor + '12 84', "Time :", ui_calculate_game_time_string(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12');  
  }

  //Game Status
  statusColor = '1 1 1';
  if( serverStatus == "Ready" ){
    statusColor = CLR_DEF_UI_ARMING;
  }
  else if(serverStatus == "In Progress" ){
    statusColor = CLR_DEF_ARM_OK;
  }
  else if( serverStatus == "Complete" ){
    statusColor = CLR_DEF_ARM_THREEQ;
  }
  gui_labelKeyPair( leftAnchor + '6 98', "Server :", serverStatus, CLR_DEF_TXT_NONSELECT, statusColor, fontsStyle, '12 12' );
}; 

//arranges player rows for dm
void( vector menuOrg ) menu_draw_players_basic={
  
  local entity player;
  local vector menuLabelOfs;
  local vector listOfs;
  local vector listRowOfs;
  local vector fontColor;  
  local float playerRowItr;
  local float itr;
  local string nameCheck;
  
  menuLabelOfs = '0 0';
  listOfs = '0 0';
  fontColor = '1 1 1';
  
  gui_renderPatch9_1_32(menuOrg, UI_CONNECT_DMLIST_SIZE, '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);

  uiParentSize_x = ceil(UI_CONNECT_DMLIST_SIZE_x / 16) * 16;
  uiParentSize_y= ceil(UI_CONNECT_DMLIST_SIZE_y / 16) * 16;
  menu_connect_draw_scorebar ( menuOrg, "- Players -", TRUE );

  listOfs_x = listRowOfs_x = menuOrg_x + 8;
  listOfs_y = menuOrg_y + 16;
  playerRowItr = 1;
  
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(SCOREBOARD[itr], "name");
      if( nameCheck != "" ){
        player = findfloat(world, clientLocalId, SCOREBOARD[itr]+1);
        listRowOfs_y = listOfs_y + ( playerRowItr * 16 );
        menu_player_row_basic( listRowOfs, playerRowItr, player, TRUE );
        playerRowItr = playerRowItr + 1;
      }
    }
  }
  
  drawfont = drawfont_prev;
};

//draws player score rows
void( vector rowOfs, float itr, entity playerRow, float showScore) menu_player_row_basic={
  local vector fontSize;
  local vector rowColor; 
  
  local vector playerNameOfs;
  local vector playerPingOfs;
  local vector playerStatusOfs;
  local vector playerScoreOfs;
  
  local float playerNameLen;
  local string playerName;
    
  local float pingLen;
  local vector pingColor;
  local float pingVal;
  
  local vector statusColor;
  local float statusLen;
  local string playerStatus;
  local float scoreLen;
  
  if( playerRow.clientLocalId == player_localentnum ){
    fontSize = '12 12 0';
    rowColor = CLR_DEF_GREEN;
  }
  else{
    fontSize = '10 10 0';
    rowColor = CLR_DEF_WHITE * 0.75;
  }
  
  drawstring(rowOfs, strcat(ftos(itr),")"), fontSize, rowColor, 1, 0);
  
  playerNameOfs = rowOfs + '14 0';
  playerName = getplayerkeyvalue(playerRow.clientLocalNum, "name");
  if( playerName != "" ){
    playerNameLen = strlen(playerName);
    if( playerNameLen > 28 ){
      playerName = substring(playerName, 0, 28);
    }
    drawstring(playerNameOfs, playerName, fontSize, rowColor, 1, 0);
  }
  
  pingVal = stof(getplayerkeyvalue(playerRow.clientLocalNum, "ping"));
  if( pingVal <= 50 ){
    pingColor = CLR_DEF_IIF_FRIEND_BLD;
  }
  else if( pingVal <= 100 ){
    pingColor = CLR_DEF_ARM_THREEQ;
  }
  else{
    pingColor = CLR_DEF_RED;
  }
  pingLen = stringwidth( ftos(pingVal), 0, fontSize );
  playerPingOfs = playerNameOfs + '150 0';
  playerPingOfs_x = playerPingOfs_x - (pingLen / 2);
  drawstring(playerPingOfs,ftos(pingVal), fontSize, pingColor, 1, 0);
  
  if( showScore ){
    playerScoreOfs = playerPingOfs + '45 0';
    scoreLen = stringwidth(ftos(playerRow.kills), 0, fontSize);
    playerScoreOfs_x = playerScoreOfs_x - (scoreLen / 2);
    drawstring(playerScoreOfs, ftos(playerRow.kills), fontSize, rowColor, 1, 0);
  }else{
    playerScoreOfs = playerPingOfs;
  }
  
  playerStatusOfs = playerScoreOfs + '49 0';
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOSTATUS) && (ENT_SERVER_INFO.gameType != GAMEMODE_COOP) ){
    playerStatus = "<hidden>";
    statusColor = CLR_DEF_ARM_THREEQ;
  }
  else{
    if( playerRow.deadflag == DEAD_DEAD ){
      playerStatus = "Dead";
      statusColor = CLR_DEF_RED * 0.9;
    }
    else{
      if( playerRow.data_type == DATA_POBS || playerRow.data_type == 0 ){
        playerStatus = "In Menu";
        statusColor = CLR_DEF_ARM_THREEQ * 0.9;
      }
      else{
        playerStatus = "Deployed";
        statusColor = CLR_DEF_IIF_FRIEND_BLD * 0.9;
      }
    }
  }
  statusLen = stringwidth(playerStatus, 0, fontSize);
  playerStatusOfs_x = playerStatusOfs_x - (statusLen / 2);
  drawstring(playerStatusOfs, playerStatus, fontSize, statusColor, 1, 0);
}; 