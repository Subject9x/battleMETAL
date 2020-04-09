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
  menu_connect_draw_bar( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
  
  if( cvar("gamemode") == GAMEMODE_TEAMDM ){
    //server info - TEAM DM
    menu_connect_draw_about_team( topleftroot + gui_percentToPixelRawVec('10 32') );
    //mission info - TDM
    menu_connect_draw_mission_info_team( topleftroot + gui_percentToPixelRawVec('10 100') );
    //server flags - TEAM DM
    menu_connect_draw_rules_team( topleftroot + gui_percentToPixelRawVec('16 213') );
    //objectives stats - TEAM DM
    menu_connect_draw_objectives( topleftroot + gui_percentToPixelRawVec('210 100') );
    //player list
    menu_connect_draw_players_team( topleftroot + gui_percentToPixelRawVec('10 282') );
  }
  else if( cvar("gamemode") == GAMEMODE_DM ){  
    //mission info - DM
    menu_connect_draw_satmap( VIEW_ORG + gui_percentToPixelRawVec('9.984 182') );
    menu_connect_draw_mission_info_dm(topleftroot + gui_percentToPixelRawVec('10 32'));
    //server flags - DM
    local vector rulesOrg;
    rulesOrg_x = VIEW_CTR_x;
    rulesOrg_y = VIEW_ORG_y;
    menu_connect_draw_rules_dm( rulesOrg + gui_percentToPixelRawVec('-85 32') );
    //Server About - DM
    menu_connect_draw_about_dm( rulesOrg + gui_percentToPixelRawVec('20 32') );
    //player list - DM
    menu_connect_draw_players_dm( topleftroot + gui_percentToPixelRawVec('10 182') );
  }
  else if( cvar("gamemode") == GAMEMODE_COOP ){
    //mission info - COOP
    menu_connect_draw_mission_info_coop( topleftroot + gui_percentToPixelRawVec('10 32') );
    
    //player list
    menu_connect_draw_players_coop( topleftroot + gui_percentToPixelRawVec('10 182') );
  }
};

/*
  Navbar for entire menu, top of screen.
*/
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

/*
  DEATHMATCH INFO PANELS
*/
void( vector menuOrg ) menu_connect_draw_mission_info_dm={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
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
  if( SV_FRAGLIMIT > 0 ){
    scoreLimit = ftos(SV_FRAGLIMIT);
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('8 90'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
  //Time Limit
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('12 108'), "Time :", ui_calculate_game_time_string(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12');  
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('6 126'), "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
};

void( vector menuOrg ) menu_connect_draw_rules_dm={
  local vector labelOrg;
  local float labelLen;
  local vector leftAnchor;
  local vector ruleRow;
  local vector fontsStyle;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('105 150'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
  labelLen = stringwidth("- Server Rules -", 0, '10 10');
  labelOrg = menuOrg;
  labelOrg_x = menuOrg_x + gui_percentXRaw(48) - gui_percentXRaw(labelLen / 2);
  labelOrg_y = menuOrg_y + gui_percentYRaw(4);
  drawstring(labelOrg, "- Server Rules -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  
  leftAnchor = menuOrg + gui_percentToPixelRawVec('8 20');
  ruleRow = leftAnchor;
  
  if( SV_SERVERFLAGS == 0 ){
    drawstring( ruleRow, "None", '12 12', CLR_DEF_WHITE, 1, 0);
  }
  
  if( (SV_SERVERFLAGS & SVFLAG_SPAWNFAR) ){
    drawstring( ruleRow, "Spawn Farthest", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOPOWERUP) ){
    drawstring( ruleRow, "No Power Up", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_CHEATS) ){
    drawstring( ruleRow, "Cheats Allowed", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_FIREON) ){
    drawstring( ruleRow, "Friendly Fire", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOLIVES) ){
    drawstring( ruleRow, "One-life Only", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOMAP) ){
    drawstring( ruleRow, "Limited TacMap", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_NORADAR) ){
    drawstring( ruleRow, "Passive Radar Only", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOSTATUS) ){
    drawstring( ruleRow, "Hide Player Status", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(14);
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_about_dm={
  local vector labelOrg;
  local float labelLen;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('290 150'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- About -", 0, '10 10');
    labelOrg = menuOrg;
    labelOrg_x = menuOrg_x + gui_percentXRaw(145) - gui_percentXRaw(labelLen / 2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(4);
    drawstring(labelOrg, "- About -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring(menuOrg + gui_percentToPixelRawVec('6 18'), "< coming soon - space for custom server text >", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
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

/*
  TEAM DEATH MATCH PANELS
*/
void( vector menuOrg ) menu_connect_draw_mission_info_team={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('200 183'), '0.65 0.65 0.65', 1, 0);
  
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
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('14.5 42'), "Map :", MAP_NAME, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Mission Name
  if( MSN_NAME != "" ){
    serverMsnName = MSN_NAME;
  }
  else{
    serverMsnName = "[Classified]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('0 56'), "Mission :", serverMsnName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Frag Limit
  local string scoreLimit;
  if( SV_FRAGLIMIT > 0 ){
    scoreLimit = ftos(SV_FRAGLIMIT);
  }
  else{
    scoreLimit = "[NONE]";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 70'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
  
  //Time Limit
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 84'), "Time :", ui_calculate_game_time_string(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');  
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 98'), "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
};

void( vector menuOrg ) menu_connect_draw_rules_team={
  local vector labelOrg;
  local float labelLen;
  local vector leftAnchor;
  local vector ruleRow;
  local vector fontsStyle;
  
  local float listCount;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
  labelLen = stringwidth("- Server Rules -", 0, '12 12');
  labelOrg = menuOrg;
  labelOrg_x = menuOrg_x + gui_percentXRaw(85) - gui_percentXRaw(labelLen / 2);
  labelOrg_y = menuOrg_y + gui_percentYRaw(4);
  drawstring(labelOrg, "- Server Rules -", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  
  leftAnchor = menuOrg + gui_percentToPixelRawVec('0 20');
  ruleRow = leftAnchor;
  
  if( SV_SERVERFLAGS == 0 ){
    drawstring( ruleRow, "None", '12 12', CLR_DEF_WHITE, 1, 0);
  }
  listCount = 0;
  if( (SV_SERVERFLAGS & SVFLAG_SPAWNFAR) ){
    drawstring( ruleRow, "Spawn Farthest", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOPOWERUP) ){
    drawstring( ruleRow, "No Power Up", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_CHEATS) ){
    drawstring( ruleRow, "Cheats Allowed", '10 10', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_FIREON) ){
    drawstring( ruleRow, "Friendly Fire", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOLIVES) ){
    drawstring( ruleRow, "One-life Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOMAP) ){
    drawstring( ruleRow, "Limited TacMap", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 4 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NORADAR) ){
    drawstring( ruleRow, "Passive Radar Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 4 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOSTATUS) ){
    drawstring( ruleRow, "Hide Player Status", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 4 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_about_team={
  local vector labelOrg;
  local float labelLen;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('620 68'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- About -", 0, '10 10');
    labelOrg = menuOrg;
    labelOrg_x = menuOrg_x + gui_percentXRaw(310) - gui_percentXRaw(labelLen / 2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(4);
    drawstring(labelOrg, "- About -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring(menuOrg + gui_percentToPixelRawVec('250 18'), "< coming soon - space for custom server text >", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_objectives={
  local vector labelOrg;
  local float labelLen;
  local entity objective;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('420 183'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Team Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
    drawstring( labelOrg, "- Team Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_objectives_row={

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


void( vector menuOrg ) menu_connect_draw_mission_info_coop={
  local string serverName;
  local string serverMsnName;
  
  local vector fontsStyle;
  local vector leftAnchor;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('620 250'), '0.65 0.65 0.65', 1, 0);
  
  // Server Name
  if( cvar_string("hostname") != "" || cvar_string("hostname") != "UNNAMED" ){
    serverName = cvar_string("hostname");
  }
  
  leftAnchor =  menuOrg + gui_percentToPixelRawVec('10 4');
  
  fontsStyle_x = FONT_NUM_ROBOT_MEDIUM;
  fontsStyle_y = FONT_NUM_ROBOT_REGULAR;
  gui_labelKeyPair( leftAnchor, "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '14 14' );
  
  //Server Game Mode
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('10 18'), "Mode :", "Coop", CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
  
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
  
  //gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 36'), "Server :", serverName, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '12 12' );
};

void( vector menuOrg ) menu_connect_draw_players_coop={

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

/*
  Draw player server data as a row, used by almost every menu that needs player rows.
*/
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
  if( (SV_SERVERFLAGS & SVFLAG_NOSTATUS) ){
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

/*
  Takes the MSN_MAPPIC from the mission file and draws it here for reference.
*/
void( vector menuOrg ) menu_connect_draw_satmap={
  local vector panelOrg;
  if( MSN_MAPPIC != "" ){
    panelOrg = menuOrg;
    panelOrg_x = VIEW_MAX_x - gui_percentXRaw(300);
    panelOrg_y = menuOrg_y;
    drawpic( panelOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('290 290'), CLR_DEF_WHITE, 1, 0);
    drawpic( panelOrg + gui_percentToPixelRawVec('4 4'), MSN_MAPPIC, gui_percentToPixelRawVec('282 282'), CLR_DEF_WHITE, 1, 0);
  }
};
