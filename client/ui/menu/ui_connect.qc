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



/*
string CHAT_LINES[20];  //20 is a hard max, but use CHAT_LINE_TOTAL to set a smaller number of lines.
float CHAT_LINE_TOTAL;
float CHAT_LINE_COUNT;
float CHAT_DECAY_TIME;  //how long before bumping a chat off the end.
*/
//sets chat settings per-menu, run once when entering a _connect menu!
void(float modeGame) menu_chat_config={
  local float i;
  local string temp;
  
  if( modeGame ){
    CHAT_LINE_FONT_SIZE = '8 8';
    CHAT_LINE_TOTAL = 5;
    CHAT_LINE_COUNT = 0;
    CHAT_DECAY_TIME = 50;
    CHAT_LINE_TRUNC = 73;
    CHAT_INP_MAX = 65;
  }
  else{
    if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
      CHAT_LINE_FONT_SIZE = '10 10';
      CHAT_LINE_TOTAL = 10;
      CHAT_LINE_COUNT = 0;
      CHAT_DECAY_TIME = 30;
      CHAT_LINE_TRUNC = 105;
      CHAT_INP_MAX = 100;
    }
    
    else if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
      CHAT_LINE_FONT_SIZE = '10 10';
      CHAT_LINE_TOTAL = 10;
      CHAT_LINE_COUNT = 0;
      CHAT_DECAY_TIME = 50;
      CHAT_LINE_TRUNC = 73;
      CHAT_INP_MAX = 65;
    }
    
    else if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
      CHAT_LINE_FONT_SIZE = '10 10';
      CHAT_LINE_TOTAL = 10;
      CHAT_LINE_COUNT = 0;
      CHAT_DECAY_TIME = 50;
      CHAT_LINE_TRUNC = 105;
      CHAT_INP_MAX = 100;
    }
  }
  
  for(i=0; i < CHAT_LINE_TOTAL; i = i + 1){
    if( CHAT_LINES[i+1] != "" ){
      freeGlobalString(CHAT_LINES[i])
      temp = substring(CHAT_LINES[i+1], 0, strlen(CHAT_LINES[i+1]));
      CHAT_LINES[i] = strzone(temp);
    }
  }
  if( CHAT_LINE_TOTAL != 20 ){
    for(i=CHAT_LINE_TOTAL; i < 20; i = i + 1){
      if( CHAT_LINES[i+1] != "" ){
        freeGlobalString(CHAT_LINES[i])
      }
    }
  }
};


/*
  Client has received a new chat line, check to see if there's space in teh queue

  CHAT_LINES array is organized with newest at the bottom
    CHAT_MSG_USER = "user";
    CHAT_MSG_BODY = "val";
    CHAT_MSG_TYPE = "type";

  //chat message types
    CHAT_TYPE_MSG1  = "msg1";
    CHAT_TYPE_MSG2  = "msg2";
    CHAT_TYPE_SERVR  = "sv";

*/
void(string msgType, string userName, string newChat) menu_chat_receive_new={
  local float i;
  local string lineRef;
  local string temp;
  
  newChat = substring( newChat, 0, strlen(newChat) - 1);  //removes \n terminator
  
  lineRef = infoadd(lineRef, CHAT_MSG_TYPE, msgType);
  lineRef = infoadd(lineRef, CHAT_MSG_USER, userName);
  lineRef = infoadd(lineRef, CHAT_MSG_BODY, substring(newChat, 0, min(strlen(newChat), CHAT_LINE_TRUNC)));
  
  if( CHAT_LINE_COUNT == 0 ){
    CHAT_LINES[0] = strzone(lineRef);
    CHAT_LINE_COUNT = CHAT_LINE_COUNT + 1;
    return;
  }
  
  
  //at least 1 message in the pipe
  if( CHAT_LINE_COUNT < CHAT_LINE_TOTAL) {
    CHAT_LINES[CHAT_LINE_COUNT] = strzone(lineRef);
    CHAT_LINE_COUNT = CHAT_LINE_COUNT + 1;
    return;
  }
  
  
  //we're at capacity, bump off the oldest.
  for(i=0; i < CHAT_LINE_TOTAL; i = i + 1){
    if( CHAT_LINES[i+1] != "" ){
      freeGlobalString(CHAT_LINES[i])
      temp = substring(CHAT_LINES[i+1], 0, strlen(CHAT_LINES[i+1]));
      CHAT_LINES[i] = strzone(temp);
    }
  }
  if( CHAT_LINES[i-1] != "" ){
    freeGlobalString(CHAT_LINES[i-1])
  }
  
  CHAT_LINES[i-1] = strzone(lineRef);
};

//float CHAT_DECAY_TIME;  //how long before bumping a chat off the end.
void() menu_chat_update_tick={
  local string lineRef;
  local float i;
  
  //we're at capacity, bump off the oldest.
  for(i=0; i < CHAT_LINE_TOTAL; i = i + 1){
    if( CHAT_LINES[i+1] != "" ){
      freeGlobalString(CHAT_LINES[i])
      lineRef = substring(CHAT_LINES[i+1], 0, strlen(CHAT_LINES[i+1]));
      CHAT_LINES[i] = strzone(lineRef);
    }
    else{
      CHAT_LINES[i] = "";
    }
  }
  CHAT_LINE_COUNT = CHAT_LINE_COUNT - 1;

}; 
//unless menu_chat_receive_new() was called, timeout the message queue
void(vector chatOrg, vector chatSize, float chatLines ) menu_chat_render_frame={
  local float i;
  local vector lineOfs;
  local string line;
  local string userName;
  local string msg;
  local vector msgColor;
  
  if(time > CHAT_DECAY_MARK ){
    CHAT_DECAY_MARK = time + CHAT_DECAY_TIME;
    menu_chat_update_tick();
  }
  
  lineOfs = chatOrg + '8 8';
  
  for(i=0; i <= CHAT_LINE_COUNT; i = i + 1){
    line = CHAT_LINES[i];
    if( line != "" ){
      if( CHAT_LINE_TRUNC != 0 ){
        line = substring(line, 0, min(strlen(line), CHAT_LINE_TRUNC));
      }
      userName = strcat(infoget(line, CHAT_MSG_USER), ":");
      msg = infoget(line, CHAT_MSG_BODY);
      drawfont_prev = drawfont;
      drawfont = FONT_NUM_ROBOT_MEDIUM;
      
      if( infoget(line, CHAT_MSG_TYPE) == CHAT_TYPE_MSG1 ){
        msgColor = CLR_DEF_TXT_NONSELECT;
      }
      else if( infoget(line, CHAT_MSG_TYPE) == CHAT_TYPE_MSG2 ){
        msgColor = CLR_DEF_ARM_OK;
      }
      else if( infoget(line, CHAT_MSG_TYPE) == CHAT_TYPE_SERVR ){
        msgColor = CLR_DEF_YELLOW;
      }
      
      drawstring(lineOfs + Vector2(0, i * (CHAT_LINE_FONT_SIZE_y + 2)), userName, CHAT_LINE_FONT_SIZE, msgColor * 1.25, 1, 0);
      
      drawfont = FONT_NUM_ROBOT_REGULAR;
      drawstring(lineOfs + Vector2(stringwidth(userName, 0, CHAT_LINE_FONT_SIZE) + CHAT_LINE_FONT_SIZE_x * 0.4, i * (CHAT_LINE_FONT_SIZE_y + 2)), msg, CHAT_LINE_FONT_SIZE, msgColor, 1, 0);
      
      drawfont = drawfont_prev;
    }
  }
  if( CLIENT_player_state == PLAYER_ACTIVE ){
    if( CHAT_INP_ON ){
      menu_chat_render_input( lineOfs + Vector2(0, CHAT_LINE_COUNT * (CHAT_LINE_FONT_SIZE_y + 2)) );
    }
  }
  else{
    menu_chat_render_input( lineOfs + Vector2(0, CHAT_LINE_TOTAL * (CHAT_LINE_FONT_SIZE_y + 2)) );
  }
};


void(vector chatOrg ) menu_chat_render_input={
  local vector textOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
  gui_renderHighlightString( "say:", chatOrg, CLR_DEF_ARM_OK, CLR_DEF_TXT_NONSELECT, CHAT_INP_ON_TEAM, CHAT_LINE_FONT_SIZE, 1, 0); 
  
  if( CHAT_INP_ON ){
    textOrg = Vector2( chatOrg_x + stringwidth("say: ", 0, CHAT_LINE_FONT_SIZE), chatOrg_y);
    
    if( strlen(CHAT_INP_VAL) > 0 ){
      drawstring(textOrg, CHAT_INP_VAL, CHAT_LINE_FONT_SIZE, CLR_DEF_WHITE, 1, 0);
    }
    
    if( time > CHAT_CUR_TIC ){
      CHAT_CUR_TIC = time + 0.5;
      drawstring(textOrg + Vector2(stringwidth(CHAT_INP_VAL, 0, CHAT_LINE_FONT_SIZE), 0), "_", CHAT_LINE_FONT_SIZE, CLR_DEF_WHITE, 1, 0);
    }
  }
  
}

void() menu_chat_cleanup={
  local float i;
  for(i = 0; i < CHAT_LINE_TOTAL; i = i + 1){
    if( CHAT_LINES[i] != "" ){
      freeGlobalString( CHAT_LINES[i] )
    }
  }
};


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

  //anchor to aspect-corrected offset
  topleftroot = UI_ORG;
  
  //background panel
  drawfill(VIEW_ORG, VIEW_MAX, '0.1 0.1 0.1', 1, 0 );
  
  //nav bar
  menu_connect_draw_bar( topleftroot + '0 5');
  
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
  
  enterOfs_x = UI_MAX_x - 138;
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
  
  gui_renderPatch9_1_32(menuOrg, '384 128', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("Team Objectives", 0, '10 10');
    labelOrg_x = menuOrg_x + 192 - (labelLen/2);
    labelOrg_y = menuOrg_y + 2;
    drawstring( labelOrg, "Team Objectives", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
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
    drawstring(titleOfs + '6 16', "[Name]", '12 12', CLR_DEF_WHITE, 1, 0);
    drawstring(titleOfs + '160 16', "[Ping]", '12 12', CLR_DEF_WHITE, 1, 0);
    if( showScore ){
      drawstring(titleOfs + '200 16', "[Score]", '12 12', CLR_DEF_WHITE, 1, 0);
      drawstring(titleOfs + '240 16', "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
    }
    else{
      drawstring(titleOfs + '200 16', "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
    }
  drawfont = FONT_NUM_ROBOT_REGULAR;
};
/*
  Takes the MSN_MAPPIC from the mission file and draws it here for reference.
*/
void( vector menuOrg, vector satMapSize) menu_connect_draw_satmap={
  local vector imgOrg;
  local vector newSize;
  local vector imgSize;
  
  if( MSN_MAPPIC != "" ){
    gui_renderBorder9_1_32(menuOrg, satMapSize, CLR_DEF_WHITE, 1, DRAWFLAG_NORMAL);
    
    imgSize = draw_getimagesize(MSN_MAPPIC);
    
    newSize_x = satMapSize_x * 0.85;
    newSize_y = (imgSize_x / imgSize_y) * newSize_x;
    
    imgOrg = menuOrg + ((satMapSize - '8 8') * 0.5) - (newSize * 0.5);
    
    drawpic(imgOrg, MSN_MAPPIC, newSize, CLR_DEF_WHITE, 1, 0);
  }
};

void( vector menuOrg, vector menuSize, vector menuColor, float alpha) menu_connect_draw_chat={
  
  gui_renderBorder9_1_32(menuOrg, menuSize, menuColor, alpha, DRAWFLAG_NORMAL);
  menu_chat_render_frame(menuOrg, menuSize, 20 );
};