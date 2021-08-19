/*
battleMETAL
Author: Peter Roohr
Date: 09/18/2020
Overview: 
  UI - connect screen for deathmatch.
  
  pulled out to its own file for serious readability, sorry I didn't do this sooner.
  
*/


void( vector rootTop ) menu_connect_render_dm={
  
  
  //mission info - DM
  menu_serverinfo_basic(rootTop + '0 32');
  
  //server flags - DM
  menu_connect_draw_rules_dm( rootTop + '240 32' );
  
  //chat - dm
  menu_connect_draw_chat( rootTop + '353 32', '262 144', '0.35 0.35 0.55', 1);
  
  //Server About - DM
  menu_connect_draw_about_dm( rootTop + '320 182' );
  
  //player list - DM
  menu_draw_players_basic( rootTop + '0 182' );
  
  //satmapinfo - DM
  menu_connect_draw_satmap( rootTop + '330 326', '175 175' );

};

/*
  DEATHMATCH INFO PANELS
*/

void( vector menuOrg ) menu_connect_draw_chat_dm={

  gui_renderPatch9_1_32(menuOrg, '105 150', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);

};

void( vector menuOrg ) menu_connect_draw_rules_dm={
  local vector labelOrg;
  local float labelLen;
  local vector leftAnchor;
  local vector ruleRow;
  
  gui_renderPatch9_1_32(menuOrg, '105 150', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
  labelLen = stringwidth("- Server Rules -", 0, '10 10');
  labelOrg = menuOrg;
  labelOrg_x = menuOrg_x + 56 - (labelLen / 2);
  labelOrg_y = menuOrg_y + 4;
  drawstring(labelOrg, "- Server Rules -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  
  leftAnchor = menuOrg + '8 20';
  ruleRow = leftAnchor;
  
  if( ENT_SERVER_INFO.serverFlags == 0 ){
    drawstring( ruleRow, "None", '12 12', CLR_DEF_WHITE, 1, 0);
  }
  
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR) ){
    drawstring( ruleRow, "Spawn Farthest", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_POWERUP) ){
    drawstring( ruleRow, "Freeze on Power-up", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_CHEATS) ){
    drawstring( ruleRow, "Cheats Allowed", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FIREON) ){
    drawstring( ruleRow, "Friendly Fire", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  //if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOLIVES) ){
  //  drawstring( ruleRow, "One-life Only", '12 12', CLR_DEF_WHITE, 1, 0);
  //  ruleRow_y = ruleRow_y + 14;
  //}
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOMAP) ){
    drawstring( ruleRow, "Limited TacMap", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NORADAR) ){
    drawstring( ruleRow, "Passive Radar Only", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOSTATUS) ){
    drawstring( ruleRow, "Hide Player Status", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
    drawstring( ruleRow, "No External Cam", '12 12', CLR_DEF_WHITE, 1, 0);
    ruleRow_y = ruleRow_y + 14;
  }
  drawfont = drawfont_prev;
};

void( vector menuOrg ) menu_connect_draw_about_dm={
  local vector labelOrg;
  local float labelLen;
  
  gui_renderPatch9_1_32(menuOrg, '278 150', '0.65 0.65 0.65', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    labelLen = stringwidth("- About -", 0, '10 10');
    labelOrg = menuOrg;
    labelOrg_x = menuOrg_x + 145 - (labelLen / 2);
    labelOrg_y = menuOrg_y + 4;
    drawstring(labelOrg, "- About -", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
  drawfont = drawfont_prev;
  
  if( strlen(ENT_SERVER_INFO.svAbout) > 0 ){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_MEDIUM;
      gui_wrapText(menuOrg + '6 16', '278 135', ENT_SERVER_INFO.svAbout, '10 10', CLR_DEF_TXT_GRAY_SMOOTH, 1);
    drawfont = drawfont_prev;
  }
};