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
  cursorImageSize = gui_percentToPixelRawVec( gui_scaleSize(cursorImageSize, VIEW_SCALE/1.25) );
  
  mpos_x = cursorpos_x - gui_percentXRaw(2);
  mpos_y = cursorpos_y - gui_percentXRaw(4);
  
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
  }

  if( toolTip.data_idx > FALSE ){
    gui_toolTipMessage(toolTip.description, toolTip.mins, toolTip.maxs, UI_DEF_BOX_512, gui_percentToPixelRawVec('12 0'), toolTip.angles, '0.85 0.85 0.85', 1 ); 
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
  if( menu_checkMouseInBounds(cursorpos, org, list_size, FALSE) ){
    local float listIndex, toSender;
    local vector listOffset;
    local float selectCheck;
    
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
  
  nvpos = ofs + gui_percentToPixelRawVec('9.984 7.488');
  
  launchPos_x = VIEW_MAX_x - gui_percentXRaw(138);
  launchPos_y = nvpos_y;
  
  ui_navbutton_brief_draw( nvpos );
  ui_navbutton_hangar_draw( nvpos + gui_percentToPixelRawVec('96 0') ) ;
  ui_navbutton_arming_draw( nvpos + gui_percentToPixelRawVec('192 0') ) ;
  ui_navbutton_deploy_draw( nvpos + gui_percentToPixelRawVec('288 0')) ;
  ui_navbutton_launch_draw( launchPos ) ;
  
};

void() menu_mainListener={
  //stop briefing if its playing
  if(ANM_FILE_STATUS == 1){
    cl_exit_animatic();
  }
};

void() menu_navbBar_listener={

  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_BRIEF_ORG, gui_percentToPixelRawVec(UI_NAVBAR_BRIEF_SIZE), TRUE)){
    ui_navbutton_brief_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_HANGAR_ORG, gui_percentToPixelRawVec(UI_NAVBAR_HANGAR_SIZE), TRUE)){
    ui_navbutton_hangar_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_ARMING_ORG, gui_percentToPixelRawVec(UI_NAVBAR_ARMING_SIZE), TRUE)){
    ui_navbutton_arming_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DEPLOY_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DEPLOY_SIZE), TRUE)){
    ui_navbutton_deploy_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_LAUNCH_ORG, UI_NAVBAR_LAUNCH_SIZE, FALSE)){
    ui_navbutton_launch_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_CONNECT_SIZE), TRUE)){
    ui_navbutton_connect_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_INFO_ORG, gui_percentToPixelRawVec(UI_NAVBAR_INFO_SIZE), TRUE)){
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
  switch( SV_GAMETYPE ){
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
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  local string serverStatus;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('225 150'), '0.65 0.65 0.65', 1, 0);
  
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + gui_percentToPixelRawVec('4 4');
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '14 14' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('10 18'), "Mode :", "Deathmatch", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Max Players
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0.5 36'), "Players :", ftos(maxclients), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Map filename
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('14.5 54'), "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0 72'), "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Frag Limit
  local string scoreLimit;
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('8 90'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  serverStatus = ui_label_mission_status();
  //Time Limit
  if( serverStatus == "Complete" ){
    gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('12 108'), "Time :", ui_calculate_time_string(SV_TIMELIMIT), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12');  
  }
  else{
    gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('12 108'), "Time :", ui_calculate_game_time_string(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12');  
  }
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('6 126'), "Server :", serverStatus, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
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
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_DMLIST_SIZE), '0.65 0.65 0.65', 1, 0);

  uiParentSize = UI_CONNECT_DMLIST_SIZE;
  menu_connect_draw_scorebar ( menuOrg, "- Players -", TRUE );

  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);
  playerRowItr = 1;
  
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(SCOREBOARD[itr], "name");
      if( nameCheck != "" || nameCheck){
        player = findfloat(world, entId, SCOREBOARD[itr]+1);
        listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
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
  
  if( playerRow.entId == player_localentnum ){
    fontSize = '12 12 0';
    rowColor = CLR_DEF_GREEN;
  }
  else{
    fontSize = '10 10 0';
    rowColor = CLR_DEF_WHITE * 0.75;
  }
  
  drawstring(rowOfs, strcat(ftos(itr),")"), fontSize, rowColor, 1, 0);
  
  local float playerNameLen;
  local string playerName;
  playerNameOfs = rowOfs + gui_percentToPixelRawVec('14 0');
  playerName = getplayerkeyvalue(playerRow.clientLocalId, "name");
  if( playerName != "" ){
    playerNameLen = strlen(playerName);
    if( playerNameLen > 28 ){
      playerName = substring(playerName, 0, 28);
    }
    drawstring(playerNameOfs, playerName, fontSize, rowColor, 1, 0);
  }
  
  local float pingLen;
  local vector pingColor;
  local float pingVal;
  //local entity ent;
  //ent = entitybyindex(playerRow.entId);
  pingVal = stof(getplayerkeyvalue(playerRow.clientLocalId, "ping"));
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
  playerPingOfs = playerNameOfs + gui_percentToPixelRawVec('150 0');
  playerPingOfs_x = playerPingOfs_x - gui_percentXRaw(pingLen / 2);
  drawstring(playerPingOfs,ftos(pingVal), fontSize, pingColor, 1, 0);
  
  if( showScore ){
    local float scoreLen;
    playerScoreOfs = playerPingOfs + gui_percentToPixelRawVec('45 0');
    scoreLen = stringwidth(ftos(playerRow.kills), 0, fontSize);
    playerScoreOfs_x = playerScoreOfs_x - gui_percentXRaw(scoreLen / 2);
    drawstring(playerScoreOfs, ftos(playerRow.kills), fontSize, rowColor, 1, 0);
  }else{
    playerScoreOfs = playerPingOfs;
  }
  
  local vector statusColor;
  local float statusLen;
  local string playerStatus;
  playerStatusOfs = playerScoreOfs + gui_percentToPixelRawVec('49 0');
  if( (SV_SERVERFLAGS & SVFLAG_NOSTATUS) && (SV_GAMETYPE != GAMEMODE_COOP) ){
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
  playerStatusOfs_x = playerStatusOfs_x - gui_percentXRaw(statusLen / 2);
  drawstring(playerStatusOfs, playerStatus, fontSize, statusColor, 1, 0);
}; 