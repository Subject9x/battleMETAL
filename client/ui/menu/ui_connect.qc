/*
battleMETAL
Author: Peter Roohr
Date: 04/02/2020
Overview: 
  This menu is shown to DM / TDM players on connect.
  Display
    DM 
      + total players list
      + player scores
      + time limit left
      + map name
      
    TDM
      + total players split into 2 lists
      + player scores
      + team score
      + map name
*/

void() menu_connectListener_onClick={

  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), TRUE)){
    ui_navbutton_disconnect_click();
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_CONNECT_SIZE), TRUE)){
    ui_navbutton_connect_click();
  }  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_TEAM_ORG, gui_percentToPixelRawVec(UI_NAVBAR_TEAM_SIZE), TRUE)){
    ui_navbutton_team_click();
  }
};

//void() menu_connectListener_onDrag;

void() menu_connectListener_onHover={
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), FALSE)){
    UI_NAVBAR_DISCONNECT_HOVER = TRUE;
    return;
  }
  else{
    UI_NAVBAR_DISCONNECT_HOVER = FALSE;
  }
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_CONNECT_SIZE), FALSE)){
    UI_NAVBAR_CONNECT_HOVER = TRUE;
  }
  else{
    UI_NAVBAR_CONNECT_HOVER = FALSE;
  }
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_TEAM_ORG, gui_percentToPixelRawVec(UI_NAVBAR_TEAM_SIZE), FALSE)){
    UI_NAVBAR_TEAM_HOVER = TRUE;
  }
  else{
    UI_NAVBAR_TEAM_HOVER = FALSE;
  }
  

};

//void() menu_connectListener_onKeyUp;

void() menu_connect_drawFrame={
  local vector topleftroot;
  
  //background panel
  topleftroot = VIEW_ORG;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '0.85 0.85 0.85', 1, 0);
  
  //nav bar
    //DM - Disconnect || ENTER
  menu_connect_draw_bar( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
    //TDM - Disconnect || Switch Team || ENTER
  
  //mission info
    //Map | time remaining | score
  menu_connect_draw_satmap( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
  //player list
    //name - score 
    //TDM - mech type - score
  if( cvar("gamemode") == GAMEMODE_TEAMDM ){
    menu_connect_draw_players_team( topleftroot + gui_percentToPixelRawVec('10 282') ); 
  }
  else if( cvar("gamemode") == GAMEMODE_DM ){  
    menu_connect_draw_players_dm( topleftroot + gui_percentToPixelRawVec('10 182') );
  }
};

void( vector menuOrg ) menu_connect_draw_bar={
  local vector enterOfs;
  local vector switchOfs;
  
  enterOfs_x = VIEW_MAX_x - gui_percentXRaw(138);
  enterOfs_y = menuOrg_y;
  
  ui_navbutton_disconnect_draw( menuOrg );
  ui_navbutton_connect_draw( enterOfs );
  
  if( cvar("gamemode") == GAMEMODE_TEAMDM ){
    switchOfs_x = VIEW_CTR_x - gui_percentXRaw( UI_NAVBAR_TEAM_SIZE_x / 2 );
    switchOfs_y = menuOrg_y;
    
    ui_navbutton_team_draw( switchOfs );
  }
};

void( vector menuOrg ) menu_connect_draw_mission_info={

};

void( vector rowOfs, float itr, entity playerRow ) menu_connect_draw_player_row={
  local vector fontSize;
  local vector rowColor; 
  
  local vector playerNameOfs;
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
  if( playerRow.netname != "" ){
    playerName = playerRow.netname;
    playerNameLen = strlen(playerRow.netname);
    if( playerNameLen > 24 ){
      playerName = substring(playerName, 0, 24);
    }
    drawstring(playerNameOfs, playerName, fontSize, rowColor, 1, 0);
  }
  
  local float scoreLen;
  playerScoreOfs = playerNameOfs + gui_percentToPixelRawVec('210 0');
  scoreLen = stringwidth(ftos(playerRow.kills), 0, fontSize);
  playerScoreOfs_x = playerScoreOfs_x - gui_percentXRaw(scoreLen / 2);
  drawstring(playerScoreOfs, ftos(playerRow.kills), fontSize, rowColor, 1, 0);
  
  local vector statusColor;
  local float statusLen;
  local string playerStatus;
  playerStatusOfs = playerScoreOfs + gui_percentToPixelRawVec('48 0');
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
  statusLen = stringwidth(playerStatus, 0, fontSize);
  playerStatusOfs_x = playerStatusOfs_x - gui_percentXRaw(statusLen / 2);
  drawstring(playerStatusOfs, playerStatus, fontSize, statusColor, 1, 0);
};

void( vector menuOrg ) menu_connect_draw_players_dm={
  local entity player;
  
  local vector menuLabelOfs;
  local vector listOfs;
  local vector listRowOfs;
  
  local vector fontColor;
  
  local float menuLabelLen;
  
  local float playerRowItr;
  local float itr;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_DMLIST_SIZE), '0.65 0.65 0.65', 1, 0);

  menu_connect_draw_scorebar ( menuOrg, "- Players -" );

  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);
  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] != 0 ){
      player = findfloat(world, entId, SCOREBOARD[itr]);
      listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
      menu_connect_draw_player_row( listRowOfs, playerRowItr, player );
      playerRowItr = playerRowItr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_players_team={
  local entity player;
  
  local vector menuLabelOfs;
  local vector listOfs;
  local vector listRowOfs;
  
  local vector fontColor;
  
  local float menuLabelLen;
  
  local float teamCount1;
  local float teamCount2;
  local float playerRowItr;
  local float itr;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_TEAMLIST_SIZE), CLR_UI_PSC_BRIEF * 0.9, 1, 0);
  drawpic(menuOrg + gui_percentToPixelRawVec('310 0'), UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_TEAMLIST_SIZE), CLR_UI_AUTH_BRIEF, 1, 0);

  menu_connect_draw_scorebar( menuOrg, "- Survest -" );
  menu_connect_draw_scorebar( menuOrg + gui_percentToPixelRawVec('310 0'), "- Militar -" );
  
  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);
  
  teamCount1 = 1;
  teamCount2 = 1;
  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] != 0 ){
      player = findfloat(world, entId, SCOREBOARD[itr]);
      if( player.faction == FACTION_SURVEST ){
        listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
        playerRowItr = teamCount1;
        teamCount1 = teamCount1 + 1;
      }
      else if(player.faction == FACTION_MILITAR){
        listRowOfs_x = menuOrg_x + gui_percentXRaw(318);
        playerRowItr = teamCount2;
        teamCount2 = teamCount2 + 1;
      }
      listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
      menu_connect_draw_player_row( listRowOfs, playerRowItr, player );
    }
  }
  
  drawfont = drawfont_prev;
};

void( vector titleOfs, string titleTeam ) menu_connect_draw_scorebar={
  local vector menuLabelOfs;
  local float menuLabelLen;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    menuLabelLen = stringwidth(titleTeam, 0, '12 12 0');
    menuLabelOfs_x = titleOfs_x + gui_percentXRaw( UI_CONNECT_DMLIST_SIZE_x / 2 ) - gui_percentXRaw( menuLabelLen / 2 );
    menuLabelOfs_y = titleOfs_y + gui_percentYRaw(4);
    drawstring(menuLabelOfs, titleTeam, '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  
  drawstring(titleOfs + gui_percentToPixelRawVec('6 14'), "[Name]", '12 12', CLR_DEF_WHITE, 1, 0);
  drawstring(titleOfs + gui_percentToPixelRawVec('220 14'), "[Score]", '12 12', CLR_DEF_WHITE, 1, 0);
  drawstring(titleOfs + gui_percentToPixelRawVec('260 14'), "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
  
  drawfont = FONT_NUM_ROBOT_REGULAR;
};

void( vector menuOrg ) menu_connect_draw_satmap={
  local vector panelOrg;
  panelOrg = menuOrg;
  panelOrg_x = VIEW_MAX_x - gui_percentXRaw(310);
  panelOrg_y = menuOrg_y + gui_percentYRaw(24);
  drawpic( panelOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('300 300'), CLR_DEF_WHITE, 1, 0);
  drawpic( panelOrg + gui_percentToPixelRawVec('4 4'), MSN_MAPPIC, gui_percentToPixelRawVec('292 292'), CLR_DEF_WHITE, 1, 0);
};
