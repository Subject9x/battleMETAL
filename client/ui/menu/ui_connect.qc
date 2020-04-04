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
};

//void() menu_connectListener_onDrag;

void() menu_connectListener_onHover={
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), TRUE)){
    UI_NAVBAR_DISCONNECT_HOVER = TRUE;
    return;
  }
  else{
    UI_NAVBAR_DISCONNECT_HOVER = FALSE;
  }
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_CONNECT_SIZE), TRUE)){
    UI_NAVBAR_CONNECT_HOVER = TRUE;
  }
  else{
    UI_NAVBAR_CONNECT_HOVER = FALSE;
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
  
  //player list
    //name - score 
    //TDM - mech type - score
  menu_connect_draw_players( topleftroot + gui_percentToPixelRawVec('10 32') );
};

void( vector menuOrg ) menu_connect_draw_bar={
  local vector enterOfs;
  
  enterOfs_x = VIEW_MAX_x - gui_percentXRaw(138);
  enterOfs_y = menuOrg_y;
  
  ui_navbutton_disconnect_draw( menuOrg );
  ui_navbutton_connect_draw( enterOfs );
};

void( vector menuOrg ) menu_connect_draw_mission_info={

};

void( vector menuOrg ) menu_connect_draw_players={
  local entity player;
  
  local vector menuLabelOfs;
  local vector listOfs;
  local vector listRowOfs;
  
  local vector fontColor;
  
  local float menuLabelLen;
  
  local float playerRowItr;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('200 220'), '1 1 1', 1, 0);

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    menuLabelLen = stringwidth("- PLAYERS -", 0, '14 14 0');
    menuLabelOfs_x = menuOrg_x + gui_percentXRaw( 100 ) - gui_percentXRaw( menuLabelLen / 2 );
    menuLabelOfs_y = menuOrg_y + gui_percentYRaw(4);
    drawstring(menuLabelOfs, "- PLAYERS -", '14 14', CLR_DEF_WHITE, 1, 0);
  
  listOfs = menuOrg + gui_percentToPixelRawVec('0 14');
  
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  playerRowItr = 1;
  for( player = scoreHead; player != world; player = player.scoreNext ){
    listRowOfs_y = menuOrg_y + ( playerRowItr * gui_percentYRaw(14) );
    menu_connect_draw_player_row( listRowOfs, playerRowItr, player );
    playerRowItr = playerRowItr + 1;
  }
  
  drawfont = drawfont_prev;
};

void( vector rowOfs, float itr, entity playerRow ) menu_connect_draw_player_row={
  local vector fontSize;
  local vector rowColor; 
  
  local vector playerNameOfs;
  local vector playerStatusOfs;
  local vector playerScoreOfs;
  
  local float playerNameLen;
  local string playerName;
  
  if( playerRow.entId == player_localentnum ){
    fontSize = '12 12 0';
    rowColor = CLR_DEF_WHITE;
  }
  else{
    fontSize = '10 10 0';
    rowColor = CLR_DEF_WHITE * 0.75;
  }
  
  drawstring(rowOfs, strcat(ftos(itr),")"), fontSize, rowColor, 1, 0);
  
  playerName = playerRow.netname;
  playerNameLen = strlen(playerRow.netname);
  if( playerNameLen > 24 ){
    playerName = substring(playerName, 0, 24);
  }
  
  
  playerNameOfs = rowOfs + gui_percentToPixelRawVec('0 14');
  drawstring(rowOfs + gui_percentToPixelRawVec('12 0'), playerName, fontSize, rowColor, 1, 0);
  
  playerStatusOfs = rowOfs + gui_percentToPixelRawVec('0 14');
  
  
  playerScoreOfs = rowOfs + gui_percentToPixelRawVec('0 14');
  
};
