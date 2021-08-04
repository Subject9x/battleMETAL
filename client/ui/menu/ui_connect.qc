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
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, UI_NAVBAR_DISCONNECT_SIZE, TRUE)){
    ui_navbutton_disconnect_click();
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, UI_NAVBAR_CONNECT_SIZE, TRUE)){
    ui_navbutton_connect_click();
  }
  if( ENT_SERVER_INFO.missionStatus <= MISSION_STATUS_ACTIVE ){
    if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_TEAM_ORG, UI_NAVBAR_TEAM_SIZE, TRUE)){
      ui_navbutton_team_click();
    }  
  }
};

//void() menu_connectListener_onDrag;

void() menu_connectListener_onHover={
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, UI_NAVBAR_DISCONNECT_SIZE, FALSE)){
    UI_NAVBAR_DISCONNECT_HOVER = TRUE;
    return;
  }
  else{
    UI_NAVBAR_DISCONNECT_HOVER = FALSE;
  }
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, UI_NAVBAR_CONNECT_SIZE, FALSE)){
    UI_NAVBAR_CONNECT_HOVER = TRUE;
  }
  else{
    UI_NAVBAR_CONNECT_HOVER = FALSE;
  }
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_TEAM_ORG, UI_NAVBAR_TEAM_SIZE, FALSE)){
    UI_NAVBAR_TEAM_HOVER = TRUE;
  }
  else{
    UI_NAVBAR_TEAM_HOVER = FALSE;
  }
};

//void() menu_connectListener_onKeyUp;

void() menu_connect_drawFrame={
  local vector topleftroot;
  local vector satMapOrg;
  local vector rulesOrg;

  //background panel
  topleftroot = VIEW_ORG;
  
  drawfill(topleftroot, VIEW_MAX, '0.33 0.33 0.33', 1, 0 );
  //nav bar
  menu_connect_draw_bar( VIEW_ORG + '9.984 7.488' );
  
  if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
    menu_connect_render_teamdm( topleftroot );
    return;
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
    menu_connect_render_dm(topleftroot);
    return;
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
    menu_connect_render_coop( topleftroot );
  }
};

/*
  Navbar for entire menu, top of screen.
*/
void( vector menuOrg ) menu_connect_draw_bar={
  local vector enterOfs;
  local vector switchOfs;
  
  enterOfs_x = VIEW_MAX_x - 138;
  enterOfs_y = menuOrg_y;
  
  ui_navbutton_disconnect_draw( menuOrg );
  if( ENT_SERVER_INFO.missionStatus <= MISSION_STATUS_ACTIVE ){
    ui_navbutton_connect_draw( enterOfs );
    if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
      switchOfs_x = VIEW_CTR_x - ( UI_NAVBAR_TEAM_SIZE_x / 2 );
      switchOfs_y = menuOrg_y;
      ui_navbutton_team_draw( switchOfs );
    }
  }
};


void( vector menuOrg ) menu_connect_draw_objectives={
  local vector labelOrg;
  local float labelLen;
  
  drawpic(menuOrg, UI_DEF_BOX_512, '420 183', '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Team Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + 210 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "- Team Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_objectives_row={
  //TODO
};


/*
  Generic methods
*/
void( vector titleOfs, string titleTeam, float showScore ) menu_connect_draw_scorebar={
  local vector menuLabelOfs;
  local float menuLabelLen;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    menuLabelLen = stringwidth(titleTeam, 0, '12 12 0');
    menuLabelOfs_x = titleOfs_x + ( uiParentSize_x / 2 ) - ( menuLabelLen / 2 );
    menuLabelOfs_y = titleOfs_y + 4;
    
    drawstring(menuLabelOfs, titleTeam, '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(titleOfs + '6 14', "[Name]", '12 12', CLR_DEF_WHITE, 1, 0);
    drawstring(titleOfs + '160 14', "[Ping]", '12 12', CLR_DEF_WHITE, 1, 0);
    if( showScore ){
      drawstring(titleOfs + '200 14', "[Score]", '12 12', CLR_DEF_WHITE, 1, 0);
      drawstring(titleOfs + '240 14', "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
    }
    else{
      drawstring(titleOfs + '200 14', "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
    }
  drawfont = FONT_NUM_ROBOT_REGULAR;
};
/*
  Takes the MSN_MAPPIC from the mission file and draws it here for reference.
*/
void( vector menuOrg, vector satMapSize) menu_connect_draw_satmap={
  if( MSN_MAPPIC != "" ){
    drawpic( menuOrg, UI_DEF_BOX_512, satMapSize, CLR_DEF_WHITE, 1, 0);
    drawpic( menuOrg + (satMapSize*0.013), MSN_MAPPIC, (satMapSize*0.97), CLR_DEF_WHITE, 1, 0);
  }
};
