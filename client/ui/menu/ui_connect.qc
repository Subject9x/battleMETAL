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
  local vector satMapOrg;
  local vector rulesOrg;

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
    return;
  }
  else if( cvar("gamemode") == GAMEMODE_DM ){  
    //satmapinfo - DM
    satMapOrg_x = VIEW_MAX_x - gui_percentXRaw(300);
    satMapOrg_y = VIEW_ORG_y + gui_percentYRaw(182);
    menu_connect_draw_satmap( satMapOrg,  '290 290' );
    
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
    return;
  }
  else if( cvar("gamemode") == GAMEMODE_COOP ){
    //mission info - COOP
    menu_connect_draw_mission_info_coop( topleftroot + gui_percentToPixelRawVec('10 32') );
    
    //server flags - COOP
    menu_connect_draw_coop_rules(  topleftroot + gui_percentToPixelRawVec('20 142')  );
    
    //server info - COOP
    menu_connet_draw_coop_about( topleftroot + gui_percentToPixelRawVec('210 32') );
    
    //objectives stats - COOP
    menu_connect_draw_objectives_coop( topleftroot + gui_percentToPixelRawVec('210 100') );
    
    //player list - COOP
    menu_connect_draw_players_coop( topleftroot + gui_percentToPixelRawVec('10 282') );
    
    //satmap - COOP;
    menu_connect_draw_satmap( VIEW_MAX + gui_percentToPixelRawVec('-210 -197'), '190 190' );
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
  if( SV_MISSIONSTATUS <= MISSION_STATUS_ACTIVE ){
    ui_navbutton_connect_draw( enterOfs );
  }
  
  if( cvar("gamemode") == GAMEMODE_TEAMDM ){
    switchOfs_x = VIEW_CTR_x - gui_percentXRaw( UI_NAVBAR_TEAM_SIZE_x / 2 );
    switchOfs_y = menuOrg_y;
    ui_navbutton_team_draw( switchOfs );
  }
};

/*
  DEATHMATCH INFO PANELS
*/
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
    drawstring(menuOrg + gui_percentToPixelRawVec('6 18'), "< work in progress >", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
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
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
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
    drawstring(menuOrg + gui_percentToPixelRawVec('250 18'), "< work in progress >", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
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
  //TODO
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
      menu_player_row_basic( listRowOfs, playerRowItr, player );
    }
  }
  
  drawfont = drawfont_prev;
};


/*
  COOP INFO PANELS
*/
void( vector menuOrg ) menu_connect_draw_mission_info_coop={
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
  /*local string scoreLimit;
  if( getstatf(STAT_FRAGLIMIT) > 0 ){
    scoreLimit = ftos(getstatf(STAT_FRAGLIMIT));
  }
  else{
    scoreLimit = "No Limit";
  }
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 70'), "Score :", scoreLimit, CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );*/
  
  //Time Limit
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 70'), "Time :", ui_calculate_game_time_string(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10');  
  
  //Game Status
  gui_labelKeyPair( leftAnchor + gui_percentToPixelRawVec('2 84'), "Server :", ui_label_mission_status(), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontsStyle, '10 10' );
};

void( vector menuOrg ) menu_connet_draw_coop_about={
  local vector labelOrg;
  local float labelLen;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('420 68'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- About -", 0, '10 10');
    labelOrg = menuOrg;
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen / 2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(4);
    drawstring(labelOrg, "- About -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    drawstring(menuOrg + gui_percentToPixelRawVec('125 18'), "< work in progress >", '12 12', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_coop_rules={  
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
  
  leftAnchor = menuOrg + gui_percentToPixelRawVec('10 20');
  ruleRow = leftAnchor;
  
  if( SV_SERVERFLAGS == 0 ){
    drawstring( ruleRow, "None", '12 12', CLR_DEF_WHITE, 1, 0);
  }
  listCount = 0;
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
    ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOLIVES) ){
    drawstring( ruleRow, "One-life Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(85);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NOMAP) ){
    drawstring( ruleRow, "Limited TacMap", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(85);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  if( (SV_SERVERFLAGS & SVFLAG_NORADAR) ){
    drawstring( ruleRow, "Passive Radar Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(85);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_objectives_coop={
  local vector labelOrg;
  local float labelLen;
  local entity objective;

  local vector bpos, lofs;
  local float lst_idx, eol, line_rtn;
  local vector objectiveOffset;
  local string desc;
  local string text;
  
  local string objectiveStatusLabel;
  local float objectiveStatus;
  local vector objectiveColor;
  local vector objectiveStatusOrg;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec('420 183'), '0.65 0.65 0.65', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- Team Objectives -", 0, '10 10');
    labelOrg_x = menuOrg_x + gui_percentXRaw(210) - gui_percentXRaw(labelLen/2);
    labelOrg_y = menuOrg_y + gui_percentYRaw(2);
    drawstring( labelOrg, "- Team Objectives -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  bpos = menuOrg;

  lofs = bpos + gui_percentToPixelRawVec('12 24');
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
    line_rtn = gui_wrapText(objectiveOffset, '350 150', text, '12 10 0', CLR_DEF_TXT_NONSELECT, 1);
    
    objectiveStatusOrg_x = menuOrg_x + gui_percentXRaw(375);
    objectiveStatusOrg_x = objectiveStatusOrg_x - gui_percentXRaw(stringwidth(objectiveStatusLabel,0,'14 14') / 2); 
    objectiveStatusOrg_y = objectiveOffset_y;
    drawstring( objectiveStatusOrg, objectiveStatusLabel, '14 14 0', objectiveColor, 1);
    
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + gui_percentYRaw(12);
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_players_coop={
  local entity player;
  
  local vector menuLabelOfs;
  local vector listOfs;
  local vector listRowOfs;
  
  local vector fontColor;
  
  local float menuLabelLen;
  
  local float playerRowItr;
  local float itr;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_TEAMLIST_SIZE), CLR_UI_PSC_BRIEF * 0.9, 1, 0);

  menu_connect_draw_scorebar( menuOrg, "- Players -" );
  
  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);

  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] != 0 ){
      player = findfloat(world, entId, SCOREBOARD[itr]);
      listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
      listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
      menu_player_row_basic( listRowOfs, playerRowItr, player );
      playerRowItr = playerRowItr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};

/*
  Generic methods
*/
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
    drawstring(titleOfs + gui_percentToPixelRawVec('180 14'), "[Ping]", '12 12', CLR_DEF_WHITE, 1, 0);
    drawstring(titleOfs + gui_percentToPixelRawVec('220 14'), "[Score]", '12 12', CLR_DEF_WHITE, 1, 0);
    drawstring(titleOfs + gui_percentToPixelRawVec('260 14'), "[Status]", '12 12', CLR_DEF_WHITE, 1, 0);
  
  drawfont = FONT_NUM_ROBOT_REGULAR;
};
/*
  Takes the MSN_MAPPIC from the mission file and draws it here for reference.
*/
void( vector menuOrg, vector satMapSize) menu_connect_draw_satmap={
  if( MSN_MAPPIC != "" ){
    drawpic( menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(satMapSize), CLR_DEF_WHITE, 1, 0);
    drawpic( menuOrg + gui_percentToPixelRawVec(satMapSize*0.013), MSN_MAPPIC, gui_percentToPixelRawVec(satMapSize*0.97), CLR_DEF_WHITE, 1, 0);
  }
};
