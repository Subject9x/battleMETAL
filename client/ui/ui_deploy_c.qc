/*
mech Mod
Author: Peter Roohr
Date: 3/26/2017
    mod 4/9//2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_deployDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_DEPLOY, HUD_ALPHA, 0);
  menu_deploy_mechInfoPanel(topleftroot);
  menu_deploy_missionInfoPanel(topleftroot);
  menu_deploy_navInfoPanel(topleftroot);
  menu_deploy_mapOverviewPanel(topleftroot);
};

//hook for input system
void() menu_deployListener={
  navSelectListener();
  navListSelectListener();
};

//Listener hooks calle by menu_briefListener
void() navSelectListener={
  if ( menu_checkMouseInBounds(cursorpos, DEPLOY_MAP_ORG, gui_percentToPixelRawVec('380 380')) ){
    local entity nav;
    local float check;
    nav = findchainfloat(data_type, DATA_DEPL);
    check = 1;
    while(nav){
      if(nav.isActive){
        if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.ui_size)){
          self.plr_nav_pnt = nav.nav_name;
        }
        else{
          self.plr_nav_pnt = -1;
        }
      }
      check = check + 1;
      nav = nav.chain;
    }
    if(self.plr_nav_pnt > 0){
      if( !(LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
    }
    else{
      if( (LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
      }
    }
  }
};

void() navListSelectListener={
  if ( menu_checkMouseInBounds(cursorpos, VIEW_ORG + gui_percentToPixelRawVec('188 135'), gui_percentToPixelRawVec('20 44')) ){
    DEPLOY_POINT_ID = DEPLOY_POINT_ID + 1;
    if(DEPLOY_POINT_ID > DEPLOY_POINT_END){
      DEPLOY_POINT_ID = 0;
    }
    self.plr_nav_pnt = DEPLOY_IDS[DEPLOY_POINT_ID];
  }
  if ( menu_checkMouseInBounds(cursorpos, VIEW_ORG + gui_percentToPixelRawVec('15 135'), gui_percentToPixelRawVec('20 44')) ){
    
    DEPLOY_POINT_ID = DEPLOY_POINT_ID - 1;
    if(DEPLOY_POINT_ID < 0){
      DEPLOY_POINT_ID = DEPLOY_POINT_END;
    }
    self.plr_nav_pnt = DEPLOY_IDS[DEPLOY_POINT_ID];
  }
  if(self.plr_nav_pnt > 0){
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
  drawpic(ofs + gui_percentToPixel(0.008, 0.044), UI_DEF_BOX_256, gui_percentToPixel(0.1648, 0.0729), CLR_DEF_UI_DEPLOY, HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION STATUS]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0902, 0.048);
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "[MISSION STATUS]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission name
  drawstring(ofs+gui_percentToPixel(0.0109, 0.06), strcat("[NAME]:            ", MSN_NAME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //mission type
  drawstring(ofs+gui_percentToPixel(0.0109, 0.07), strcat("[TYPE]:            ", MSN_TYPE), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  //reserves
  drawstring(ofs+gui_percentToPixel(0.0109, 0.08), strcat("[RESOURCE POINTS]: ", ftos(AVAILABLE_RESERVE)), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //sector
  //drawstring(ofs+'14 80', strcat("[SECTOR]:          ", MSN_SECTOR), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //location
  //drawstring(ofs+'14 88', strcat("[LOCATION]:        ", MSN_LOCATION ), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ////local time
  //drawstring(ofs+'14 96', strcat("[LOCAL TIME]:      ", MSN_LOCALTIME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_deploy_navInfoPanel={
  drawpic(ofs + gui_percentToPixelRawVec('10 113'), UI_DEF_BOX_256, gui_percentToPixelRawVec('211 70'), CLR_DEF_UI_DEPLOY, HUD_ALPHA, 0);
  local float tlen;
  local vector tpos, icosize, icopos1, icopos2;
  tlen = stringwidth("[SELECTED DROP POINT]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0902, 0.12);
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "[SELECTED DROP POINT]", '8 8 0', '1 1 1', HUD_ALPHA, 0);

  drawstring(ofs + gui_percentToPixelRawVec('180 125'), "[Next]", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  drawpic(ofs + gui_percentToPixelRawVec('188 135'), HUD_TRG_PIP_R, gui_percentToPixelRawVec('20 44'), '1 1 1', HUD_ALPHA, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('15 125'), "[Prev]", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  drawpic(ofs + gui_percentToPixelRawVec('15 135'), HUD_TRG_PIP_L, gui_percentToPixelRawVec('20 44'), '1 1 1', HUD_ALPHA, 0);
 
  //current spawn point
  local string navlbl;
  local vector hclr;
  if(self.plr_nav_pnt > 0){
    navlbl = gui_getNavName(self.plr_nav_pnt);
    hclr = CLR_DEF_GREEN;
  }
  else{
    navlbl = "RANDOM!";
    hclr = CLR_DEF_RED;
  } 
  drawstring(ofs + gui_percentToPixelRawVec('69 131'), "[CURRENT]", '9 9', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixelRawVec('82 150'), navlbl, '12 12', hclr, HUD_ALPHA, 0);
};

void(vector ofs) menu_deploy_mechInfoPanel={
  drawpic(ofs + gui_percentToPixel(0.008, 0.19), UI_DEF_BOX_256, gui_percentToPixel(0.1648, 0.0729), CLR_DEF_UI_DEPLOY, HUD_ALPHA, 0);
  local float tlen;
  local vector tpos, spos, t_color;
  local string type;
  
  tlen = stringwidth("[SELECTED METAL]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0902, 0.1916);
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "[SELECTED METAL]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  spos = ofs + gui_percentToPixel(0.0125, 0.1531);
  if(self.plr_sel_mech > 0){
    drawstring(spos, strcat("[NAME] ", MECH_DATA_NAME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    // MECH SIZE
    if(MECH_DATA_SIZE == 1){
      type = "Light";
      t_color = STATUS_AOK;
    }
    else if(MECH_DATA_SIZE == 2){
      type = "Medium";
      t_color = STATUS_DMG;
    }
    else if(MECH_DATA_SIZE == 3){
      type = "Heavy";
      t_color = STATUS_REL;
    }
    drawstring(spos + gui_percentToPixel(0, 0.0083), "[TYPE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0.0375, 0.0083),  type, '6 6 0', t_color, HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0, 0.0166), "[COST] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0.0375, 0.0166),  "0", '6 6 0', t_color, HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0, 0.025), "[FACTION] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0.0437, 0.025),  "0", '6 6 0', t_color, HUD_ALPHA, 0);
  }
  else{
    drawstring(spos, "NO METAL SELECTED!", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0, 0.0083), "SELECT ONE FROM THE HANGAR BEFORE", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    drawstring(spos + gui_percentToPixel(0, 0.0166), "DEPLOYMENT!", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
};

void(vector ofs) menu_deploy_mapOverviewPanel={
  local vector mpos, iofs, map_size;
  local float itr;
  
  itr = 0;
  mpos_x = mpos_x + (VIEW_CTR_x - gui_percentXRaw(96));
  mpos_y = ofs_y + gui_percentYRaw(44);
  drawpic(mpos, UI_DEF_BOX_256, gui_percentToPixel(0.3164, 0.4218), CLR_DEF_UI_DEPLOY, HUD_ALPHA, 0);
  
  iofs = mpos + gui_percentToPixelRawVec('12 12');
  DEPLOY_MAP_ORG = iofs;
  
  if(MSN_MAPPIC != ""){
    drawpic(iofs, MSN_MAPPIC, gui_percentToPixelRawVec('380 380'), '1 1 1', HUD_ALPHA, 0);
  }
  else{
    drawstring(iofs + gui_percentToPixelRawVec('25 25'), "Satellite Data unavailable", '12 12', '1 0 0', HUD_ALPHA, 0);
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
      
        tofs = nofs = gui_mapCoordToImgCoord(map_size, navorg, iofs, gui_percentToPixelRawVec('380 380'));
        
        nlen = stringwidth(navname, 0, '6 6 0');
        nofs_x = nofs_x - gui_percentXRaw((nlen/2));
        nofs_y = nofs_y - gui_percentYRaw(16);
        gui_renderTintImage(TRUE, tofs + gui_percentToPixelRawVec('-6 -6'), UI_DEF_NAVPOINT, '12 12', CLR_DEF_WHITE, 1, 0) ;
        drawstring(nofs, navname, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      }
    }
    local vector nclr;
    nactive = DEPLOY_POINTS_ACTIVE[itr];
    if( nactive != FALSE ){    
      navorg = DEPLOY_POINTS_ORG[itr]; 
      tofs = nofs = gui_mapCoordToImgCoord(map_size, navorg, iofs, gui_percentToPixelRawVec('380 380'));
      if( nactive ){
        nclr = CLR_DEF_ARM_OK;
      }
      else{
        nclr = CLR_DEF_ARM_HALF;
      }
      if(self.plr_nav_pnt == itr){
        gui_renderTintImage(TRUE, nofs - gui_percentToPixelRawVec('6 6'), UI_DEF_REC_64, gui_percentToPixelRawVec('28 28'), CLR_DEF_GREEN, 0.85, 0);
      }
      gui_renderTintImage2((self.plr_nav_pnt == itr), nofs, UI_DEF_DEPLOYPOINT, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_OK, CLR_DEF_ARM_HALF, 1, 0) ;
    }

    itr = itr + 1;
  }

  
  
  if( (cvar("coop")) || (cvar("deathmatch")) ){
    local entity player;
    player = findchainflags(flags, FL_CLIENT);
    while(player){
      if(player.data_type == DATA_MECH){
        if(player.i_faction == self.i_faction){
          local vector friend_org;
          friend_org = gui_mapCoordToImgCoord(map_size, player.origin, iofs, gui_percentToPixelRawVec('380 380'));
          drawpic(friend_org, HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('12 12'), CLR_DEF_IIF_FRIEND, HUD_ALPHA, 0);
        }
      }
      player = player.chain;
    }
  }
};