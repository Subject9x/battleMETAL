/*
battleMETAL
Author: Peter Roohr
Date: 09/18/2020
Overview: 
  UI - connect screen for team deathmatch.
  
  pulled out to its own file for serious readability, sorry I didn't do this sooner.
  
*/

void( vector rootTop ) menu_connect_render_teamdm={  
  //server info - TEAM DM
  menu_connect_draw_about_team( rootTop + gui_percentToPixelRawVec('10 32') );
  //mission info - TDM
  menu_connect_draw_mission_info_team( rootTop + gui_percentToPixelRawVec('10 100') );
  //server flags - TEAM DM
  menu_connect_draw_rules_team( rootTop + gui_percentToPixelRawVec('16 213') );
  //objectives stats - TEAM DM
  menu_connect_draw_objectives( rootTop + gui_percentToPixelRawVec('210 100') );
  //player list
  menu_connect_draw_players_team( rootTop + gui_percentToPixelRawVec('10 282') );
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
  if( (SV_SERVERFLAGS & SVFLAG_POWERUP) ){
    drawstring( ruleRow, "Freeze on Power-up", '10 10', CLR_DEF_WHITE, 1, 0);
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
  /*if( (SV_SERVERFLAGS & SVFLAG_NOLIVES) ){
    drawstring( ruleRow, "One-life Only", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 3 ){
      ruleRow_x = ruleRow_x + gui_percentXRaw(64);
      ruleRow_y = ruleRow_y - gui_percentYRaw(listCount * 12);
    }
    else{
      ruleRow_y = ruleRow_y + gui_percentYRaw(12);
    }
    listCount = listCount + 1;
  }*/
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
  if( (SV_SERVERFLAGS & SVFLAG_FPSONLY) ){
    drawstring( ruleRow, "No External Cam", '10 10', CLR_DEF_WHITE, 1, 0);
    if( listCount == 4 ){
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

void( vector menuOrg ) menu_connect_draw_players_team={
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float teamCount1;
  local float teamCount2;
  local float playerRowItr;
  local float itr;
  
  local string nameCheck;
  local float colorsCheck;
  
  drawpic(menuOrg, UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_TEAMLIST_SIZE), CLR_UI_PSC_BRIEF * 0.9, 1, 0);
  drawpic(menuOrg + gui_percentToPixelRawVec('310 0'), UI_DEF_BOX_512, gui_percentToPixelRawVec(UI_CONNECT_TEAMLIST_SIZE), CLR_UI_MIL_BRIEF, 1, 0);

  drawpic( menuOrg + gui_percentToPixelRawVec('100 48'), "gfx/ui/ui_icon_survest.png", gui_percentToPixelRawVec('110 100'), '0.85 0.85 0.85', 0.33, 0);
  drawpic( menuOrg + gui_percentToPixelRawVec('394 38'), "gfx/ui/ui_icon_militar.png", gui_percentToPixelRawVec('128 128'), '0.85 0.85 0.85', 0.33, 0);

  uiParentSize = UI_CONNECT_TEAMLIST_SIZE;
  menu_connect_draw_scorebar( menuOrg, "- Survest -", TRUE );
  menu_connect_draw_scorebar( menuOrg + gui_percentToPixelRawVec('310 0'), "- Militar -", TRUE );
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
  listOfs_y = menuOrg_y + gui_percentYRaw(14);
  
  teamCount1 = 1;
  teamCount2 = 1;
  playerRowItr = 1;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(SCOREBOARD[itr], "name");
      if( nameCheck != "" || nameCheck ){
        colorsCheck = stof(getplayerkeyvalue(SCOREBOARD[itr], "colors")); //faction detection hack
        player = findfloat(world, entId, SCOREBOARD[itr]+1);
        if( colorsCheck == FACTION_SURVEST ){
          listRowOfs_x = menuOrg_x + gui_percentXRaw(8);
          playerRowItr = teamCount1;
          teamCount1 = teamCount1 + 1;
        }
        else if(colorsCheck == FACTION_MILITAR){
          listRowOfs_x = menuOrg_x + gui_percentXRaw(318);
          playerRowItr = teamCount2;
          teamCount2 = teamCount2 + 1;
        }
        listRowOfs_y = listOfs_y + ( playerRowItr * gui_percentYRaw(16) );
        menu_player_row_basic( listRowOfs, playerRowItr, player, TRUE );
      }
    }
  }
  
  drawfont = drawfont_prev;
};