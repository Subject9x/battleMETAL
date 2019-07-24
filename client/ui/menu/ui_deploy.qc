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
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_DEPLOY, 1, 0);
  menu_deploy_missionInfoPanel(topleftroot + gui_percentToPixelRawVec('0 32'));
  menu_deploy_mapOverviewPanel(topleftroot + gui_percentToPixelRawVec('0 32'));
  menu_deploy_mechInfoPanel(topleftroot);
  menu_deploy_navInfoPanel(topleftroot);
  menu_deploy_mapKeyPanel(topleftroot);
};

//hook for input system
void() menu_deployListener_onClick={
  //navSelectListener();
  navListSelectListener();
};

void() menu_deployListener_onDrag={
};

void() menu_deployListener_onHover={

  if( menu_checkMouseInBounds( cursorpos, DEPLOY_HELP_NAV_MAP, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_DEPLOY_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('256 64 0');
    toolTip.description = "This is the Deployment map. Here you can see all possible <Deploy> points and <NAV> markers. The currently selected <Deploy> point is highlighted in green.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
    if( menu_checkMouseInBounds( cursorpos, DEPLOY_HELP_NAV_PICK, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_DEPLOY_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('256 64 0');
    toolTip.description = "<Deploy> points are where you will start the mission. Clicking <| and |> will select different <Deploy> points on the map.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  toolTip.data_idx = FALSE;
};

//Listener hooks calle by menu_briefListener
void() navSelectListener={
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_MAP_ORG, gui_percentToPixelRawVec('380 380'), TRUE) ){
    local entity nav;
    nav = findchainfloat(data_type, DATA_DEPL);
    while(nav){
      if(nav.isActive){
        if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.ui_size, TRUE)){
          CLIENT_MENU_nav_pnt = nav.nav_name;
        }
        else{
          CLIENT_MENU_nav_pnt = -1;
        }
      }
      nav = nav.chain;
    }
    if(CLIENT_MENU_nav_pnt > 0){
      if( !(LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
    }
    else{
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
    }
  }
};

void() navListSelectListener={
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_BUTTON_NAV_NEXT_ORG, gui_percentToPixelRawVec('20 44'), TRUE) ){
    DEPLOY_POINT_ID = DEPLOY_POINT_ID + 1;
    if(DEPLOY_POINT_ID > DEPLOY_POINT_END){
      DEPLOY_POINT_ID = 0;
    }
    CLIENT_MENU_nav_pnt = DEPLOY_IDS[DEPLOY_POINT_ID];
  }
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_BUTTON_NAV_PREV_ORG, gui_percentToPixelRawVec('20 44'), TRUE) ){
    DEPLOY_POINT_ID = DEPLOY_POINT_ID - 1;
    if( DEPLOY_POINT_ID < 0 ){
      DEPLOY_POINT_ID = DEPLOY_POINT_END;
    }
    CLIENT_MENU_nav_pnt = DEPLOY_IDS[DEPLOY_POINT_ID];
  }
  if(CLIENT_MENU_nav_pnt > -1){
    if( !(LAUNCH_VALIDATION & VALID_NODE) ){
      LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
    }
  }
  else{
    if( (LAUNCH_VALIDATION & VALID_NODE) ){
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
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
  
  panelOfs = ofs + gui_percentToPixelRawVec('10 0');
  
  drawpic(panelOfs, UI_DEF_BOX_256, gui_percentToPixelRawVec('215 90'), CLR_DEF_UI_DEPLOY, 1, 0);
 
  panelLabelLen = stringwidth("-Misson Status-", 0, '10 10 0');
  pabelLabelOrg = panelOfs + gui_percentToPixelRawVec('105 4');
  pabelLabelOrg_x = pabelLabelOrg_x - gui_percentXRaw( panelLabelLen / 2 );
  drawstring(pabelLabelOrg, "-Misson Status-", '10 10 0', '1 1 1', 1, 0);
  
  //mission name
  drawstring(panelOfs + gui_percentToPixelRawVec('6 19'), "Name:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  namePos = panelOfs + gui_percentToPixelRawVec('32 18');
  drawstring(namePos, MSN_NAME, '12 10 0', '1 1 1', 1, 0);
  
  //mission type
  drawstring(panelOfs + gui_percentToPixelRawVec('6 36'), "Type:", '10 8 0', CLR_DEF_GRAY_H, 1, 0); 
  drawstring(panelOfs + gui_percentToPixelRawVec('32 34'), MSN_TYPE, '12 10 0', '1 1 1', 1, 0); 
  
  drawfont = drawfont_prev;
 
  //reserves
  //drawstring(panelOfs+gui_percentToPixel(0.0109, 0.08), "[RESOURCE POINTS]:", '6 6 0', CLR_DEF_GRAY_H, 1, 0);
  //drawstring(panelOfs+gui_percentToPixelRawVec('0 0'), ftos(AVAILABLE_RESERVE), '8 8 0', '1 1 1', 1, 0);
  
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

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  panelOrg = ofs + gui_percentToPixelRawVec('10 122');

  drawpic(panelOrg, UI_DEF_BOX_256, gui_percentToPixelRawVec('215 90'), CLR_DEF_UI_DEPLOY, 1, 0);

  panelLabelLen = stringwidth("-Select Drop Point-", 0, '10 10 0');
  panelLabelOrg = panelOrg + gui_percentToPixelRawVec('107.5 2');
  panelLabelOrg_x = panelLabelOrg_x - gui_percentXRaw( panelLabelLen / 2 );
  drawstring(panelLabelOrg, "-Select Drop Point-", '10 10 0', '1 1 1', 1, 0);

  drawstring(panelOrg + gui_percentToPixelRawVec('190 12'), "Next", '10 10 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(panelOrg + gui_percentToPixelRawVec('188 20'), HUD_TRG_PIP_R, gui_percentToPixelRawVec('20 44'), '1 1 1', 1, 0);
  DEPLOY_BUTTON_NAV_NEXT_ORG = panelOrg + gui_percentToPixelRawVec('188 20');
  
  drawstring(panelOrg + gui_percentToPixelRawVec('8 12'), "Prev", '10 10 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(panelOrg + gui_percentToPixelRawVec('6 20'), HUD_TRG_PIP_L, gui_percentToPixelRawVec('20 44'), '1 1 1', 1, 0);
  DEPLOY_BUTTON_NAV_PREV_ORG = panelOrg + gui_percentToPixelRawVec('6 20');

  //current spawn point
  local string deployLabel;
  local float deployLabelLen;
  local vector deployLabelOrg;
  
  local vector deployColor;
  if(CLIENT_MENU_nav_pnt > -1){
    deployLabel = gui_getNavName(CLIENT_MENU_nav_pnt);
    deployColor = CLR_DEF_GREEN;
  }
  else{
    deployLabel = "!- SELECT -!";
    deployColor = CLR_DEF_RED;
  }
  deployLabelLen = stringwidth( deployLabel, 0, '14 14 0' );
  deployLabelOrg = panelOrg;
  deployLabelOrg_x = deployLabelOrg_x + gui_percentXRaw(105.5) - gui_percentXRaw( deployLabelLen / 2 );
  deployLabelOrg_y = deployLabelOrg_y + gui_percentYRaw( 35 );
  drawstring( deployLabelOrg, deployLabel, '16 16', deployColor, 1, 0);
   
  drawfont = drawfont_prev;
    
  local vector helpOrg;
  helpOrg = panelOrg + gui_percentToPixelRawVec('0 -2');
  helpOrg_x = helpOrg_x + gui_percentXRaw(211) - gui_percentXRaw(12);
  DEPLOY_HELP_NAV_PICK = helpOrg;
  drawpic( helpOrg, UI_HELP_IMG, gui_percentToPixelRawVec('12 12'), '1 1 1', 1, 0);
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
 
  panelOfs = ofs + gui_percentToPixelRawVec('10 212');
 
  drawpic(panelOfs, UI_DEF_BOX_256, gui_percentToPixelRawVec('215 70'), CLR_DEF_UI_DEPLOY, 1, 0);

  tlen = stringwidth("-Chosen Metal-", 0, '10 10 0');
  panelLabelOrg = panelOfs + gui_percentToPixelRawVec('107.5 4');
  panelLabelOrg_x = panelLabelOrg_x - gui_percentXRaw( tlen / 2 );
  drawstring(panelLabelOrg, "-Chosen Metal-", '10 10 0', '1 1 1', 1, 0);
  
  if(CLIENT_MENU_sel_mech > 0){
    // MECH SIZE
    switch( MECH_DATA_SIZE ){
      case 1:
        type = "Light";
        t_color = CLR_DEF_ARM_ONEQ;
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
    spos = panelOfs + gui_percentToPixelRawVec('4 20');
    drawstring(spos+ gui_percentToPixelRawVec('6 0'), "Name:", '10 8 0', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(spos + gui_percentToPixelRawVec('40 -4'), MECH_DATA_NAMES[CLIENT_MENU_sel_mech], '12 12 0', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawstring(spos + gui_percentToPixelRawVec('6 14'), "Type: ", '10 8 0', CLR_DEF_TXT_NONSELECT, 1, 0);
    drawstring(spos + gui_percentToPixelRawVec('40 14'), type, '12 10 0', t_color, 1, 0);
    
    drawfont = drawfont_prev;
    //drawstring(spos + gui_percentToPixel(0, 0.0166), "[COST] ", '6 6 0', '1 1 1', 1, 0);
    //drawstring(spos + gui_percentToPixel(0.0375, 0.0166),  "0", '6 6 0', t_color, 1, 0);
    //drawstring(spos + gui_percentToPixel(0, 0.025), "[FACTION] ", '6 6 0', '1 1 1', 1, 0);
    //drawstring(spos + gui_percentToPixel(0.0437, 0.025),  "0", '6 6 0', t_color, 1, 0);
  }
};

void(vector ofs) menu_deploy_mapOverviewPanel={
  local vector mpos, iofs, map_size, unavailableOrg;
  local float itr, unavailableLen;
  
  itr = 0;
  mpos_x = mpos_x + (VIEW_CTR_x - gui_percentXRaw(96));
  mpos_y = ofs_y;
  drawpic(mpos, UI_DEF_BOX_256, gui_percentToPixelRawVec('405 405'), CLR_DEF_UI_DEPLOY, 1, 0);
  
  iofs = mpos + gui_percentToPixelRawVec('12 12');
  DEPLOY_MAP_ORG = iofs;
  
  if( MSN_MAPPIC != "" ){
    drawpic(iofs, MSN_MAPPIC, gui_percentToPixelRawVec('380 380'), '1 1 1', 1, 0);
  }
  else{
    unavailableLen = stringwidth( "!- Satellite Data unavailable -!", 0 ,'16 16 0');
    unavailableOrg = iofs;
    unavailableOrg_x = unavailableOrg_x + gui_percentXRaw(380 / 2) - gui_percentXRaw( unavailableLen / 2 );
    unavailableOrg_y = unavailableOrg_y + gui_percentYRaw(380 / 2) - gui_percentYRaw( 8 );
    gui_wrapText(unavailableOrg, '210 32', "!- Satellite Data unavailable -!", '16 16 0', '1 0 0', 1);
  }
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  
  while( itr <= 32 ){
    local vector navorg, nofs, tofs;
    local float nactive, nlen;
    local string navname;
    
    if( itr <= 21 ){
      nactive = NAVNAMES_ACTIVE[itr];
      
      if( nactive != FALSE ){
        navorg = NAVNAMES_ORG[itr];
        navname = NAVNAMES[itr];
      
        tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, navorg, iofs, gui_percentToPixelRawVec('380 380'));
        
        nlen = stringwidth(navname, 0, '6 6 0');
        nofs_x = nofs_x - gui_percentXRaw((nlen/2));
        nofs_y = nofs_y - gui_percentYRaw(16);
        gui_renderTintImage(TRUE, tofs + gui_percentToPixelRawVec('-6 -6'), UI_DEF_NAVPOINT, '12 12', CLR_DEF_WHITE, 1, 0) ;
        drawstring(nofs, navname, '6 6 0', '1 1 1', 1, 0);
      }
    }
    local vector deployColor;
    nactive = DEPLOY_POINTS_ACTIVE[itr];
    if( nactive != FALSE ){
      navorg = DEPLOY_POINTS_ORG[itr]; 
      tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, navorg, iofs, gui_percentToPixelRawVec('380 380'));
      if( nactive ){
        deployColor = CLR_DEF_ARM_OK;
      }
      else{
        deployColor = CLR_DEF_ARM_HALF;
      }
      if(CLIENT_MENU_nav_pnt == itr){
        gui_renderTintImage(TRUE, nofs - gui_percentToPixelRawVec('6 6'), UI_DEF_REC_64, gui_percentToPixelRawVec('28 28'), CLR_DEF_GREEN, 0.85, 0);
        CLIENT_MENU_nav_ui_org = tofs;
        ui_renderSprite_DeployPoint( tofs, '16 16', CLR_DEF_GREEN, 1 ) ;
      }
      else{
        gui_renderTintImage2((CLIENT_MENU_nav_pnt == itr), nofs, UI_DEF_DEPLOYPOINT, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_OK, CLR_DEF_ARM_HALF, 1, 0) ;
      }
      local vector lineOrg;
      lineOrg = mpos + gui_percentToPixelRawVec('5 110');
      drawline(1, lineOrg + gui_percentToPixelRawVec('0 1'), CLIENT_MENU_nav_ui_org + gui_percentToPixelRawVec('0 1'), '0.85 0.85 0', 0.75, 0);
      drawline(1, lineOrg + gui_percentToPixelRawVec('0 2'), CLIENT_MENU_nav_ui_org + gui_percentToPixelRawVec('0 2'), '0.85 0.85 0', 0.75, 0);
      drawline(1, lineOrg + gui_percentToPixelRawVec('0 3'), CLIENT_MENU_nav_ui_org + gui_percentToPixelRawVec('0 3'), '0.85 0.85 0', 0.75, 0);
      drawline(1, lineOrg + gui_percentToPixelRawVec('0 4'), CLIENT_MENU_nav_ui_org + gui_percentToPixelRawVec('0 4'), '0.85 0.85 0', 0.75, 0);
    }
    itr = itr + 1;
  }

  local vector helpOrg;
  helpOrg = mpos;
  helpOrg_x = helpOrg_x + gui_percentXRaw(405) - gui_percentXRaw(12);
  DEPLOY_HELP_NAV_MAP = helpOrg;
  drawpic( helpOrg, UI_HELP_IMG, gui_percentToPixelRawVec('12 12'), '1 1 1', 1, 0);

  if( (cvar("coop")) || (cvar("deathmatch")) ){
    local entity player;
    player = findchainflags(flags, FL_CLIENT);
    while(player){
      if(player.data_type == DATA_MECH){
        if(player.faction == CLIENT_faction){
          local vector friend_org;
          friend_org = gui_mapCoordToImgCoord(world.mins, map_size, player.origin, iofs, gui_percentToPixelRawVec('380 380'));
          drawpic(friend_org, HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('12 12'), CLR_DEF_IIF_FRIEND, 1, 0);
        }
      }
      player = player.chain;
    }
  }
};

void(vector ofs) menu_deploy_mapKeyPanel={
  local vector panelOrg;
  
  panelOrg = ofs + gui_percentToPixelRawVec('10 282');
  drawpic(panelOrg, UI_DEF_BOX_256, gui_percentToPixelRawVec('215 120'), CLR_DEF_UI_DEPLOY, 1, 0); 

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  local vector panelLabelOrg;
  local float panelLabelLen;
  panelLabelLen = stringwidth( "-Map Icons-", 0, '10 8 0');
  panelLabelOrg = panelOrg;
  panelLabelOrg_x = panelLabelOrg_x + gui_percentXRaw(107.5) - gui_percentXRaw(panelLabelLen / 2);
  panelLabelOrg_y = panelLabelOrg_y + gui_percentYRaw(4);
  drawstring( panelLabelOrg, "-Map Icons-", '10 10 0', CLR_DEF_WHITE, 1, 0);

  local vector deployIconOrg;
  local vector deployLabelOrg;
  deployIconOrg = panelOrg + gui_percentToPixelRawVec('8 16');
  drawpic( deployIconOrg, UI_DEF_DEPLOYPOINT, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_HALF, 1, 0) ;
  deployLabelOrg = deployIconOrg + gui_percentToPixelRawVec('24 1');
  drawstring( deployLabelOrg, "Deploy Point", '14 14', '0.85 0.85 0.85', 1, 0);
  
  local vector navpointIconOrg;
  local vector navpointLabelOrg;
  navpointIconOrg = deployIconOrg + gui_percentToPixelRawVec('0 20');
  drawpic( navpointIconOrg, UI_DEF_NAVPOINT, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_OK, 1, 0) ;
  navpointLabelOrg = navpointIconOrg + gui_percentToPixelRawVec('24 1');
  drawstring( navpointLabelOrg, "Assigned Nav Point", '14 14', '0.85 0.85 0.85', 1, 0);
  
  local vector baseFriendIconOrg;
  local vector baseFriendLabelOrg;
  baseFriendIconOrg = navpointIconOrg + gui_percentToPixelRawVec('0 20');
  drawpic( baseFriendIconOrg, HUD_RAD_PIP_BLD, gui_percentToPixelRawVec('16 16'), CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  baseFriendLabelOrg = baseFriendIconOrg + gui_percentToPixelRawVec('24 1');
  drawstring( baseFriendLabelOrg, "Allied Base", '14 14', '0.85 0.85 0.85', 1, 0);
  
  local vector baseEnemyIconOrg;
  local vector baseEnemyLabelOrg;
  baseEnemyIconOrg = baseFriendIconOrg + gui_percentToPixelRawVec('0 20');
  drawpic( baseEnemyIconOrg, HUD_RAD_PIP_BLD, gui_percentToPixelRawVec('16 16'), CLR_DEF_IFF_ENEMY_BLD, 1, 0) ;
  baseEnemyLabelOrg = baseEnemyIconOrg + gui_percentToPixelRawVec('24 1');
  drawstring( baseEnemyLabelOrg, "Possible Enemy Base", '14 14', '0.85 0.85 0.85', 1, 0);
  
  local vector hazardIconOrg;
  local vector hazardLabelOrg;
  hazardIconOrg = baseEnemyIconOrg + gui_percentToPixelRawVec('0 20');
  drawpic( hazardIconOrg, UI_DEF_REC_64, gui_percentToPixelRawVec('16 16'), CLR_DEF_WHITE, 1, 0) ;
  hazardLabelOrg = hazardIconOrg + gui_percentToPixelRawVec('24 1');
  drawstring( hazardLabelOrg, "Environment Hazard", '14 14', '0.85 0.85 0.85', 1, 0);

  drawfont = drawfont_prev;
};