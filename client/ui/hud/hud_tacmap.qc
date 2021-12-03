/*
battleMETAL
Author: Peter Roohr
Date: 4/1/2020
  Tactical map feature - covers player's whole view, but shows the satellite map with relevant
  data
*/

/*
  Render - HUD tactical map frame
*/
void() hud_render_tactical_map={
  local vector mapOrg, mapImgSize;
  local float unavailableLen;
  local vector unavailableOrg;
  local vector map_size;
  
  local entity mapKey;
  local vector keyOrg;
  local vector renderColor;
  local entity nav;
  local vector navOfs;
  local vector navImgOfs;
  local float nlen;
  local string navname;
  local entity player;
  local vector target_org;
  local vector friend_org;
  local string playerName;
  local vector nameOrg;
  local float nameLen;
  local string pipType;
  local float arrowAng;
  local vector playerMapOrg;
  
  // render satellite view
  mapOrg = VIEW_ORG + '2 48';
  mapImgSize = '175 175';
  
  if( MSN_MAPPIC != "" ){
    drawpic(mapOrg, MSN_MAPPIC, mapImgSize, '1 1 1', HUD_ALPHA, 0);
    //drawrotpic(mapOrg, MSN_MAPPIC, mapImgSize, mapOrg + (mapImgSize * 0.5), input_angles_y, '1 1 1', HUD_ALPHA, 0); -> TODO - get this working.
  }
  else{
    unavailableLen = stringwidth( "!- Satellite Data unavailable -!", 0 ,'16 16 0');
    unavailableOrg = mapOrg;
    unavailableOrg_x = unavailableOrg_x + (380 / 2) - ( unavailableLen / 2 );
    unavailableOrg_y = unavailableOrg_y + (380 / 2) - 8;
    gui_wrapText(unavailableOrg, '210 32', "!- Satellite Data unavailable -!", '16 16 0', '1 0 0', 1);
  }
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  mapKey = mapKeyObject;
  for( mapKey = mapKeyObject; mapKey != world; mapKey = mapKey.w_slot ){
    keyOrg = gui_mapCoordToImgCoord(world.mins, map_size, mapKey.origin, mapOrg, mapImgSize);
    switch( mapKey.data_type ){
      case DATA_MAP_DMG:
        drawpic( keyOrg - '2 2', UI_DEF_BOX_64, '4 4', CLR_DEF_RED * 1.15, 0.85, 0);
        break;
      case DATA_BLD:
        gui_renderTintImage2((CLIENT_faction == mapKey.faction), keyOrg - '4 4', HUD_RAD_PIP_BLD, '8 8', CLR_DEF_IIF_FRIEND_BLD, CLR_DEF_IFF_ENEMY_BLD + '0.15 0.15 0.15', 1, 0);
        break;
    }
  }
  
  //Render Nav points
  renderColor = CLR_DEF_GREEN - '0.1 0.1 0.1';
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction && nav.faction != FACTION_ALL ){
      continue;
    }
    navImgOfs = navOfs = gui_mapCoordToImgCoord(world.mins, map_size, nav.origin, mapOrg, mapImgSize);
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    navname = NAVNAMES[nav.data_idx];
    nlen = stringwidth(navname, 0, '8 8 0');
    navOfs_x = navOfs_x - (nlen/2);
    navOfs_y = navOfs_y - 11;
    gui_renderTintImage(TRUE, navImgOfs - '5 5', UI_DEF_NAVPOINT, '10 10', renderColor, 1, 0) ;
    
    drawstring(navOfs, navname, '8 8 0', renderColor, 1, 0);
    
    drawfont = drawfont_prev;
  }
  
  //render allies
  for( player = nextent(world); player != world; player = nextent(player) ){
    if( !(player.flags & FL_CLIENT) ){
      continue;
    }
    if(player.data_type != DATA_MECH){
      continue;
    }
    if(player.faction != CLIENT_faction){
      continue;
    }
    //PLAYER TAC MAP INFO
    if( player.clientLocalId == player_localentnum ){
      drawpic(gui_mapCoordToImgCoord(world.mins, map_size, pmove_org, mapOrg, mapImgSize) - '5 5', HUD_RAD_PIP_MCH, '10 10', CLR_DEF_IIF_FRIEND_BLD * 1.25, 1, 0);
      if( CLIENT_stat_trg_ent_id <= 0 ){continue;}
      if( CLIENT_stat_trg_ddflg > DEAD_NO ){continue;}
      if(player.enemy == world){continue;}
      target_org = gui_mapCoordToImgCoord(world.mins, map_size, player.enemy.origin, mapOrg, mapImgSize);
      if( CLIENT_target_datatype == DATA_MECH ){
        pipType = HUD_RAD_PIP_MCH;
      }
      else if( CLIENT_target_datatype == DATA_VEHC ){
        pipType = HUD_RAD_PIP_VEC;
      }
      else if( CLIENT_target_datatype == DATA_BLD ){
        pipType = HUD_RAD_PIP_BLD;
      }
      drawpic(target_org - '5 5', pipType, '10 10', CLR_DEF_IFF_ENEMY, 1, 0);
    }
    else{
      //FRIENDLIES TAC MAP INFO
      if( player.faction != FACTION_ALL ){
        friend_org = gui_mapCoordToImgCoord(world.mins, map_size, player.origin, mapOrg, mapImgSize);
        gui_renderTintImage2(FALSE, friend_org - '5 5', HUD_RAD_PIP_MCH, '10 10', CLR_DEF_IIF_FRIEND, CLR_DEF_IIF_FRIEND_BLD * 1.25, 1, 0 );
        
        nameOrg = friend_org + '0 -10';
        
        drawfont_prev = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
        
        playerName = getplayerkeyvalue(player.clientLocalNum, "name");
        nameLen = stringwidth( playerName, 0, '10 10 0');
        nameOrg_x = nameOrg_x - ( nameLen / 2 );
        drawstring( nameOrg, playerName, '10 10 0', CLR_DEF_IIF_FRIEND_BLD, 1, 0);
        
        drawfont = drawfont_prev;
        if( player.targetEntId <= 0 ){continue;}
        if( player.enemy.deadflag != DEAD_NO ){continue;}
        
        target_org = gui_mapCoordToImgCoord(world.mins, map_size, player.enemy.origin, mapOrg, mapImgSize);
        drawpic(target_org - '5 5', HUD_RAD_PIP_MCH, '10 10', CLR_DEF_IFF_ENEMY, 1, 0);
      }
    }
  }
  
  //render player pointer
  //arrow = gui_angleToArrow(input_angles_y - 90);
  arrowAng = anglemod( 90 - input_angles_y);
  makevectors(input_angles);
  playerMapOrg = gui_mapCoordToImgCoord(world.mins, map_size, pmove_org, mapOrg, mapImgSize);
  drawrotpic(playerMapOrg, "gfx/hud/map_up.png", '12 12', '6 6', arrowAng, '0.25 1 2', 1, 0);
};

void() hud_render_scoreboard={
  local vector panelOrg;
  //local float gameMode;
  
  panelOrg_x = VIEW_MAX_x - 150;
  panelOrg_y = VIEW_ORG_y + 2;

  //gameMode = cvar("gamemode");
  if( ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM ){
    hud_render_scoreboard_tdm( panelOrg );
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
    hud_render_scoreboard_dm( panelOrg );
  }
  else if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
    hud_render_scoreboard_dm( panelOrg );
  }
}; 

void( vector rowOfs, float itr, entity playerRow ) hud_render_score_row={
  local vector fontSize;
  local vector rowColor; 
  
  local vector playerNameOfs;
  local vector playerScoreOfs;
  
  local float playerNameLen;
  local string playerName;
  local float scoreLen;
  
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOSTATUS) ){
    rowColor = CLR_DEF_WHITE;
    if( playerRow.clientLocalId == player_localentnum ){
      fontSize = '10 10 0';
    }
    else{
      fontSize = '8 8 0';
    }
  }
  else{
    if( playerRow.clientLocalId == player_localentnum ){
      fontSize = '10 10 0';
      rowColor = CLR_DEF_GREEN;
    }
    else{
      fontSize = '8 8 0';
      rowColor = CLR_DEF_WHITE * 0.75;
      if( playerRow.deadflag > DEAD_NO ){
        rowColor = CLR_DEF_RED * 0.9;
      }
      else{
        if( playerRow.data_type == DATA_POBS || playerRow.data_type == 0 ){
          rowColor = CLR_DEF_ARM_THREEQ * 0.9;
        }
        else{
          rowColor = CLR_DEF_IIF_FRIEND_BLD * 0.9;
        }
      }
    }
  }
  
  drawstring(rowOfs, strcat(ftos(itr),")"), fontSize, rowColor, 1, 0);
  
  playerName = getplayerkeyvalue(playerRow.clientLocalNum, "name");
  playerNameOfs = rowOfs + '14 0';
  if( playerName != "" ){
    playerNameLen = strlen(playerName);
    if( playerNameLen > 24 ){
      playerName = substring(playerName, 0, 24);
    }
    drawstring(playerNameOfs, playerName, fontSize, rowColor, 1, 0);
  }
  
  playerScoreOfs = playerNameOfs + '120 0';
  playerRow.kills = stof(getplayerkeyvalue(playerRow.clientLocalNum, "frags"));
  scoreLen = stringwidth(getplayerkeyvalue(playerRow.clientLocalNum, "frags"), 0, fontSize);
  playerScoreOfs_x = playerScoreOfs_x - (scoreLen / 2);
  drawstring(playerScoreOfs, getplayerkeyvalue(playerRow.clientLocalNum, "frags"), fontSize, rowColor, 1, 0);
};

void( vector panelOfs ) hud_render_scoreboard_dm={
  local vector panelSize;
  
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float playerRowItr;
  local float itr;
  
  local string nameCheck;
  
  panelSize_x = 150;
  panelSize_y = HUD_SCORE_HEIGHT;
  
  gui_renderPatch9_1_32(panelOfs, panelSize, CLR_DEF_WHITE * 0.75, HUD_ALPHA * 1.15, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = panelOfs_x + 2;
  listOfs_y = panelOfs_y + 2;
  playerRowItr = 0;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(SCOREBOARD[itr], "name");
      if( nameCheck != "" || nameCheck ){
        player = findfloat(world, clientLocalId, SCOREBOARD[itr] + 1);
        listRowOfs_y = listOfs_y + ( playerRowItr * 12 );
        hud_render_score_row( listRowOfs, playerRowItr + 1, player );
        playerRowItr = playerRowItr + 1;
      }
    }
  }
  HUD_SCORE_HEIGHT =  playerRowItr * 14;
  drawfont = drawfont_prev;
};

void( vector panelOfs ) hud_render_scoreboard_tdm={
  local vector panelMOfs;
  local vector panelSurvestSize;
  local vector panelMilitarSize;
  
  local entity player;
  
  local vector listOfs;
  local vector listRowOfs;
  
  local float teamCount1, teamCount2;
  
  local float playerRowItr;
  local float itr;
  local string nameCheck;
  
  if( HUD_SCORE_SURVEST_HEIGHT > 0){
    panelSurvestSize_x = panelMilitarSize_x = 150;
    panelSurvestSize_y = HUD_SCORE_SURVEST_HEIGHT;
    gui_renderPatch9_1_32(panelOfs, panelSurvestSize, CLR_UI_PSC_BRIEF * 0.9, max(HUD_ALPHA, 0.8), 0);
  }
  
  if( HUD_SCORE_MILITAR_HEIGHT > 0 ){
    panelMOfs_x = panelOfs_x;
    panelMOfs_y = panelOfs_y + panelSurvestSize_y;
    panelMilitarSize_y = HUD_SCORE_MILITAR_HEIGHT;
    gui_renderPatch9_1_32(panelMOfs, panelMilitarSize, CLR_UI_MIL_BRIEF, max(HUD_ALPHA, 0.8), 0);
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  listOfs = '0 0';
  listOfs_x = listRowOfs_x = panelOfs_x + 2;
  listOfs_y = panelOfs_y + 2;
  playerRowItr = 0;
  teamCount1 = 0;
  teamCount2 = 0;
  for( itr = 0; itr < SCOREBOARDMAX; itr = itr + 1){
    if( SCOREBOARD[itr] > -1 ){
      nameCheck = getplayerkeyvalue(SCOREBOARD[itr], "name");
      if( nameCheck != "" || nameCheck ){
        player = findfloat(world, clientLocalId, SCOREBOARD[itr] + 1);
        if( player.faction == FACTION_SURVEST ){
          listRowOfs_y = listOfs_y + ( teamCount1 * 12 );
          playerRowItr = teamCount1;
          teamCount1 = teamCount1 + 1;
        }
        else if(player.faction == FACTION_MILITAR){
          listRowOfs_y = panelMOfs_y + ( teamCount2 * 12 );
          playerRowItr = teamCount2;
          teamCount2 = teamCount2 + 1;
        }
        listRowOfs_x = panelOfs_x + 2;
        hud_render_score_row( listRowOfs, playerRowItr + 1, player );
      }
    }
  }
  HUD_SCORE_SURVEST_HEIGHT = teamCount1 * 12;
  HUD_SCORE_MILITAR_HEIGHT = teamCount2 * 12;
  drawfont = drawfont_prev;
};