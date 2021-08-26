/*
battleMETAL
Author: Peter Roohr
Date: 3/26/2017
    mod 04/09/2017
    mod 03/05/2019
    mod 06/19/2019
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_deployDrawFrame={
  local vector topleftroot;
  
  topleftroot = UI_ORG;
  
  drawfill(VIEW_ORG, VIEW_MAX, CLR_DEF_UI_DEPLOY * 0.25, 1, 0 );
  
  menu_navBar_drawFrame(topleftroot);
  
  menu_deploy_missionInfoPanel(topleftroot + '0 32');
  menu_deploy_mapOverviewPanel(topleftroot + '235 32');
  menu_deploy_navInfoPanel(topleftroot + '0 113');
  menu_deploy_mechInfoPanel(topleftroot + '0 193');
  menu_deploy_mapKeyPanel(topleftroot+ '0 306');
};

//hook for input system
void() menu_deployListener_onClick={
  menu_navbBar_listener();
  
  if( !(ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR) ){
    navListSelectListener();
  }
};

void() menu_deployListener_onDrag={
};

void() menu_deployListener_onHover={

  if( menu_checkMouseInBounds( cursorpos, DEPLOY_HELP_NAV_MAP, '12 12', FALSE) ){
    toolTip.data_idx = MENU_DEPLOY_ACTIVE;
    toolTip.mins = '256 64';
    toolTip.description = "This is the Deployment map. Here you can see all possible <Deploy> points and <NAV> markers. The currently selected <Deploy> point is highlighted in green.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds( cursorpos, DEPLOY_HELP_NAV_PICK, '12 12', FALSE) ){
    toolTip.data_idx = MENU_DEPLOY_ACTIVE;
    toolTip.mins = '256 64';
    toolTip.description = "<Deploy> points are where you will start the mission. Clicking <| and |> will select different <Deploy> points on the map.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  
  toolTip.data_idx = FALSE;
};

//Listener hooks calle by menu_briefListener
//  DEPRECATED
void() navSelectListener={
  local entity nav;
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_MAP_ORG, '380 380', TRUE) ){
    nav = findchainfloat(data_type, DATA_DEPL);
    for( nav = findchainfloat(data_type, DATA_DEPL); nav != world; nav = nav.chain){
      if( !nav.isActive || nav.faction != CLIENT_faction ){
        continue;
      }
      if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.uequipSize, TRUE)){
        CLIENT_MENU_nav_pnt = nav.nav_name;
      }
      else{
        CLIENT_MENU_nav_pnt = -1;
      }
    }
    if(CLIENT_MENU_nav_pnt > 0){
      if( !(LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      cl_send_infostring( INFO_FLAG_SPAWN );
    }
    else{
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
      cl_setspawnpoint( 0 );
      cl_send_infostring( INFO_FLAG_SPAWN );
    }
  }
};

void() navListSelectListener={
  local entity deploy;
  local entity found;
  local float check;
  check = FALSE;
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_BUTTON_NAV_NEXT_ORG, '20 44', TRUE) ){
    for( deploy = CLIENT_MENU_deploy.nextPoint; deploy != world; deploy = deploy.nextPoint ){
      if( found.data_idx ){
        continue;
      }
      if( deploy.isActive ){
        found = deploy;
      }
    }
    if( found ){
      CLIENT_MENU_deploy = found;
      CLIENT_MENU_nav_pnt = CLIENT_MENU_deploy.data_idx;
    }
  }
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_BUTTON_NAV_PREV_ORG, '20 44', TRUE) ){
    for( deploy = CLIENT_MENU_deploy.prevPoint; deploy != world; deploy = deploy.prevPoint ){
      if( found.data_idx ){
        continue;
      }
      if( deploy.isActive ){
        found = deploy;
      }
    }
    if( found ){
      CLIENT_MENU_deploy = found;
      CLIENT_MENU_nav_pnt = CLIENT_MENU_deploy.data_idx;
    }
  }
  //click filter to register clicks in the above 2 buttons only.
  if( check ){
    if(CLIENT_MENU_nav_pnt > 0){
      if( !(LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      cl_send_infostring( INFO_FLAG_SPAWN );
    }
    else{
      if( (LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
      }
    }
  }
};


//panels
void(vector ofs) menu_deploy_missionInfoPanel={
  local float panelLabelLen;
  local vector panelOfs;
  local vector pabelLabelOrg;
  local vector namePos;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  panelOfs = ofs;
 
  gui_renderPatch9_1_32(panelOfs, '215 90', CLR_DEF_UI_DEPLOY, 1, DRAWFLAG_NORMAL);
 
  panelLabelLen = stringwidth("-Misson Status-", 0, '10 10');
  pabelLabelOrg = panelOfs + '105 4';
  pabelLabelOrg_x = pabelLabelOrg_x - ( panelLabelLen / 2 );
  drawstring(pabelLabelOrg, "-Misson Status-", '10 10', '1 1 1', 1, 0);
  
  //mission name
  drawstring(panelOfs + '6 19', "Name:", '10 10', CLR_DEF_GRAY_H, 1, 0);
  namePos = panelOfs + '32 18';
  drawstring(namePos, MSN_NAME, '12 12', '1 1 1', 1, 0);
  
  //mission type
  drawstring(panelOfs + '6 36', "Type:", '10 10', CLR_DEF_GRAY_H, 1, 0); 
  drawstring(panelOfs + '32 34', MSN_TYPE, '12 12', '1 1 1', 1, 0); 
  
  drawfont = drawfont_prev;
 
  //reserves
  //drawstring(panelOfs+0.0109, 0.08, "[RESOURCE POINTS]:", '6 6 0', CLR_DEF_GRAY_H, 1, 0);
  //drawstring(panelOfs, ftos(AVAILABLE_RESERVE), '8 8 0', '1 1 1', 1, 0);
  
  //sector
  //drawstring(ofs+'14 80', strcat("[SECTOR]:          ", MSN_SECTOR), '6 6 0', CLR_DEF_GRAY_H, 1, 0);
  
  //location
  //drawstring(ofs+'14 88', strcat("[LOCATION]:        ", MSN_LOCATION ), '6 6 0', CLR_DEF_GRAY_H, 1, 0);
  
  //local time
  //drawstring(ofs+'14 96', strcat("[LOCAL TIME]:      ", MSN_LOCALTIME), '6 6 0', CLR_DEF_GRAY_H, 1, 0);
};

void(vector ofs) menu_deploy_navInfoPanel={
  local float panelLabelLen;
  local vector panelLabelOrg;
  local vector panelOrg;
  
  //current spawn point
  local string deployLabel;
  local float deployLabelLen;
  local vector deployLabelOrg;
  
  local vector deployColor;
  local vector helpOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  panelOrg = ofs;
  
  gui_renderPatch9_1_32(panelOrg, '215 90', CLR_DEF_UI_DEPLOY, 1, DRAWFLAG_NORMAL);
  
  if( (ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR) ){
    deployLabel = "RANDOM";
    deployColor = CLR_DEF_WHITE;
  }
  else{
    panelLabelLen = stringwidth("-Select Drop Point-", 0, '10 10');
    panelLabelOrg = panelOrg + '107.5 2';
    panelLabelOrg_x = panelLabelOrg_x - ( panelLabelLen / 2 );
    drawstring(panelLabelOrg, "-Select Drop Point-", '10 10', '1 1 1', 1, 0);
    
    drawstring(panelOrg + '200 12', "Next", '10 10', CLR_DEF_ARM_HALF, 1, 0);
    drawpic(panelOrg + '198 20', UI_BTN_ARR_RIGHT, '20 44', '1 1 1', 1, 0);
    DEPLOY_BUTTON_NAV_NEXT_ORG = panelOrg + '198 20';
    
    drawstring(panelOrg + '8 12', "Prev", '10 10', CLR_DEF_ARM_HALF, 1, 0);
    drawpic(panelOrg + '6 20', UI_BTN_ARR_LEFT, '20 44', '1 1 1', 1, 0);
    DEPLOY_BUTTON_NAV_PREV_ORG = panelOrg + '6 20';
    if(CLIENT_MENU_nav_pnt > -1){
      deployLabel = strcat("Point [",ftos(CLIENT_MENU_nav_pnt),"]");
      deployColor = CLR_DEF_GREEN;
    }
    else{
      deployLabel = "!- SELECT -!";
      deployColor = CLR_DEF_RED;
    }
  }
  deployLabelLen = stringwidth( deployLabel, 0, '14 14' );
  deployLabelOrg = panelOrg;
  deployLabelOrg_x = deployLabelOrg_x + 105.5 - ( deployLabelLen / 2 );
  deployLabelOrg_y = deployLabelOrg_y + 35;
  drawstring( deployLabelOrg, deployLabel, '16 16', deployColor, 1, 0);
   
  drawfont = drawfont_prev;
    
  helpOrg = panelOrg + '0 -2';
  helpOrg_x = helpOrg_x + 211 - 12;
  DEPLOY_HELP_NAV_PICK = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_deploy_mechInfoPanel={
  local float tlen;
  local vector panelOfs;
  local vector panelLabelOrg;
  local vector spos;
  local vector t_color;
  
  local string type;
 
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
 
  panelOfs = ofs;
  
  gui_renderPatch9_1_32(panelOfs, '215 112', CLR_DEF_UI_DEPLOY, 1, DRAWFLAG_NORMAL);
  
  tlen = stringwidth("Chosen Metal", 0, '10 10');
  panelLabelOrg = panelOfs + '107.5 4';
  panelLabelOrg_x = panelLabelOrg_x - ( tlen / 2 );
  drawstring(panelLabelOrg, "Chosen Metal", '10 10', '1 1 1', 1, 0);
  
  if(CLIENT_MENU_sel_mech > 0){
    // MECH SIZE
    switch( MECH_DATA_SIZE ){
      case 1:
        type = "Light";
        t_color = CLR_DEF_ARM_ONEQ * 2;
        break;
      case 2:
        type = "Medium";
        t_color = CLR_DEF_ARM_HALF;
        break;
      case 3:
        type = "Heavy";
        t_color = CLR_DEF_ARM_OK;
        break;
    }
    spos = panelOfs + '4 20';
    drawstring(spos+ '6 0', "Name:", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(spos + '40 -4', MECH_DATA_NAMES[CLIENT_MENU_sel_mech], '12 12', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawstring(spos + '6 14', "Type: ", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(spos + '40 14', type, '12 12', t_color, 1, 0);
    
    local string cfg;
    cfg = NAVNAMES[CFG_INDEX];
    
    drawstring(spos + '6 28', "Loadout:", '10 10', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(spos + '51 26', cfg, '12 12', CLR_DEF_ARM_OK, 1, 0);
    
    local entity wepSlot;
    local vector wepOrg;
    wepOrg = spos + '6 38';
    wepSlot = UI_HANGAR_DATA_mech.w_slot;
    while( wepSlot ){
      if( wepSlot.icon != "" ){
        if(wepSlot.data_idx == UID_ITEM_EMPTY){
          drawpic(wepOrg, wepSlot.icon, '24 24', CLR_DEF_ARM_ONEQ * 2, 1, DRAWFLAG_NORMAL);
        }
        else{
          drawpic(wepOrg, wepSlot.icon, '24 24', CLR_DEF_WHITE, 1, DRAWFLAG_NORMAL);
        }
        
        
        wepOrg_x = wepOrg_x + 26;
        if( wepOrg_x > (ofs_x + 130)){
          wepOrg_x = spos_x + 6;
          wepOrg_y = spos_y + 38 + 26;
        }
      }
      wepSlot = wepSlot.w_slot;
    }
    
    drawfont = drawfont_prev;
    //drawstring(spos + gui_percentToPixel(0, 0.0166), "[COST] ", '6 6 0', '1 1 1', 1, 0);
    //drawstring(spos + gui_percentToPixel(0.0375, 0.0166),  "0", '6 6 0', t_color, 1, 0);
    //drawstring(spos + gui_percentToPixel(0, 0.025), "[FACTION] ", '6 6 0', '1 1 1', 1, 0);
    //drawstring(spos + gui_percentToPixel(0.0437, 0.025),  "0", '6 6 0', t_color, 1, 0);
  }
};

void(vector ofs) menu_deploy_mapOverviewPanel={
  local vector mpos, iofs, map_size, unavailableOrg;
  local vector renderColor;
  local float itr, unavailableLen;
  local entity mapKey;
  local vector nofs, tofs;
  local entity nav;
  local float nlen;
  local entity deploy;
  local vector lineOrg;
  local vector helpOrg;
  local entity player;
  local vector friend_org;
  local vector nameOrg;
  local float nameLen;
  local string playerName;
  
  itr = 0;
  mpos = ofs;
  
  iofs = mpos;
  DEPLOY_MAP_ORG = iofs;
  
  if( MSN_MAPPIC != "" ){
    drawpic(iofs, MSN_MAPPIC, '380 380', '1 1 1', 1, 0);
  }
  else{
    unavailableLen = stringwidth( "!- Satellite Data unavailable -!", 0 ,'16 16');
    unavailableOrg = iofs;
    unavailableOrg_x = unavailableOrg_x + (380 / 2) - ( unavailableLen / 2 );
    unavailableOrg_y = unavailableOrg_y + (380 / 2) -  8 ;
    gui_wrapText(unavailableOrg, '210 32', "!- Satellite Data unavailable -!", '16 16', '1 0 0', 1);
  }
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  mapKey = mapKeyObject;
  for( mapKey = mapKeyObject; mapKey != world; mapKey = mapKey.w_slot ){
    nofs = gui_mapCoordToImgCoord(world.mins, map_size, mapKey.origin, iofs, '380 380');
    switch( mapKey.data_type ){
      case DATA_MAP_DMG:
        drawpic( nofs - '5 5', UI_DEF_BOX_64, '10 10', CLR_DEF_RED * 1.15, 0.67, 0);
        break;
      case DATA_BLD:
        gui_renderTintImage2((CLIENT_faction == mapKey.faction), nofs - '8 8', HUD_RAD_PIP_BLD, '16 16', CLR_DEF_IIF_FRIEND_BLD, CLR_DEF_IFF_ENEMY_BLD + '0.15 0.15 0.15', 1, 0);
        break;
    }
  }
  
  renderColor = CLR_DEF_GREEN - '0.1 0.1 0.1';
  
  //Render Nav points
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction && nav.faction != FACTION_ALL ){
      continue;
    }
    
    tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, nav.origin, iofs, '380 380');
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    nlen = stringwidth(nav.vec_name, 0, '12 12');
    nofs_x = nofs_x - ( (nlen/2) );
    nofs_y = nofs_y - 18;
    gui_renderTintImage(TRUE, tofs - '8 8', UI_DEF_NAVPOINT, '16 16', renderColor, 1, 0) ;
    
    drawstring(nofs, nav.vec_name, '12 12', renderColor, 1, 0);
    
    drawfont = drawfont_prev;
  }
  
  //Render Deploy points
  if( !CLIENT_MENU_deploy  ){
    CLIENT_MENU_deploy = DEPLOYPOINT;
    CLIENT_MENU_nav_pnt = CLIENT_MENU_deploy.data_idx;
  }
  for( deploy = DEPLOYPOINT; deploy != world; deploy = deploy.partNext ){
    if( deploy.faction != FACTION_ALL ){
      if( deploy.faction != CLIENT_faction ){
        continue;
      }
    }
    if( deploy.isActive == FALSE ){
      continue;
    }
    tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, deploy.origin, iofs, '380 380');
    
    if( (ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR) ){
      drawpic(nofs, UI_DEF_DEPLOYPOINT, '16 16', CLR_DEF_ARM_HALF, 1, 0) ;
    }
    else{
      if( CLIENT_MENU_deploy.data_idx == deploy.data_idx ){
        gui_renderTintImage(TRUE, nofs - '6 6', UI_DEF_REC_64, '28 28', CLR_DEF_GREEN, 0.85, 0);
        CLIENT_MENU_nav_ui_org = tofs;
        ui_renderSprite_DeployPoint( tofs, '16 16', CLR_DEF_GREEN, 1 ) ;
      }
      else{
        drawpic(nofs, UI_DEF_DEPLOYPOINT, '16 16', CLR_DEF_ARM_THREEQ * 1.5 , 1, 0) ;
      }
    }
    lineOrg = mpos + '5 110';
    drawline(1, lineOrg + '0 1', CLIENT_MENU_nav_ui_org + '0 1', '0.85 0.85 0', 0.75, 0);
    drawline(1, lineOrg + '0 2', CLIENT_MENU_nav_ui_org + '0 2', '0.85 0.85 0', 0.75, 0);
    drawline(1, lineOrg + '0 3', CLIENT_MENU_nav_ui_org + '0 3', '0.85 0.85 0', 0.75, 0);
    drawline(1, lineOrg + '0 4', CLIENT_MENU_nav_ui_org + '0 4', '0.85 0.85 0', 0.75, 0);
  }
  
  helpOrg = Vector2(mpos_x + 380 - 12,  mpos_y);
  DEPLOY_HELP_NAV_MAP = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
  
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
    if(player.faction == FACTION_ALL){
      continue;
    }
    friend_org = gui_mapCoordToImgCoord(world.mins, map_size, player.origin, iofs, '380 380');
    drawpic(friend_org, HUD_RAD_PIP_MCH, '12 12', CLR_DEF_IIF_FRIEND, 1, 0);
    
    nameOrg = friend_org + '0 -18';
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    playerName = getplayerkeyvalue(player.clientLocalNum, "name");
    nameLen = stringwidth( playerName, 0, '14 14');
    nameOrg_x = nameOrg_x - ( nameLen / 2 );
    drawstring( nameOrg, playerName, '14 14', CLR_DEF_IIF_FRIEND, 1, 0);
    
    drawfont = drawfont_prev;
  }
};

void(vector ofs) menu_deploy_mapKeyPanel={
  local vector panelOrg;
  local vector panelLabelOrg;
  local float panelLabelLen;
  local vector deployIconOrg;
  local vector deployLabelOrg;
  local vector navpointIconOrg;
  local vector navpointLabelOrg;
  local vector baseFriendIconOrg;
  local vector baseFriendLabelOrg;
  local vector baseEnemyIconOrg;
  local vector baseEnemyLabelOrg;
  local vector hazardIconOrg;
  local vector hazardLabelOrg;
  
  panelOrg = ofs;
  
  gui_renderPatch9_1_32(panelOrg, '215 128', CLR_DEF_UI_DEPLOY, 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  panelLabelLen = stringwidth( "-Map Icons-", 0, '10 10');
  panelLabelOrg = panelOrg;
  panelLabelOrg_x = panelLabelOrg_x + 107.5 - (panelLabelLen / 2);
  panelLabelOrg_y = panelLabelOrg_y + 4;
  drawstring( panelLabelOrg, "-Map Icons-", '10 10', CLR_DEF_WHITE, 1, 0);

  deployIconOrg = panelOrg + '8 16';
  drawpic( deployIconOrg, UI_DEF_DEPLOYPOINT, '16 16', CLR_DEF_ARM_HALF, 1, 0) ;
  deployLabelOrg = deployIconOrg + '24 1';
  drawstring( deployLabelOrg, "Deploy Point", '14 14', '0.85 0.85 0.85', 1, 0);
  
  navpointIconOrg = deployIconOrg + '0 20';
  drawpic( navpointIconOrg, UI_DEF_NAVPOINT, '16 16', CLR_DEF_ARM_OK, 1, 0) ;
  navpointLabelOrg = navpointIconOrg + '24 1';
  drawstring( navpointLabelOrg, "Assigned Nav Point", '14 14', '0.85 0.85 0.85', 1, 0);
  
  baseFriendIconOrg = navpointIconOrg + '0 20';
  drawpic( baseFriendIconOrg, HUD_RAD_PIP_BLD, '16 16', CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  baseFriendLabelOrg = baseFriendIconOrg + '24 1';
  drawstring( baseFriendLabelOrg, "Allied Base", '14 14', '0.85 0.85 0.85', 1, 0);
  
  baseEnemyIconOrg = baseFriendIconOrg + '0 20';
  drawpic( baseEnemyIconOrg, HUD_RAD_PIP_BLD, '16 16', CLR_DEF_IFF_ENEMY_BLD, 1, 0) ;
  baseEnemyLabelOrg = baseEnemyIconOrg + '24 1';
  drawstring( baseEnemyLabelOrg, "Possible Enemy Base", '14 14', '0.85 0.85 0.85', 1, 0);
  
  hazardIconOrg = baseEnemyIconOrg + '0 20';
  drawpic( hazardIconOrg, UI_DEF_REC_64, '16 16', CLR_DEF_RED * 2, 1, 0) ;
  hazardLabelOrg = hazardIconOrg + '24 1';
  drawstring( hazardLabelOrg, "Environment Hazard", '14 14', '0.85 0.85 0.85', 1, 0);

  drawfont = drawfont_prev;
};