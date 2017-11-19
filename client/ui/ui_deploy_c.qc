/*
mech Mod
Author: Subject9x
Date: 3/26/2017
    mod 4/9//2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_deployDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '1 1 1', HUD_ALPHA, 0);
  menu_deploy_mechInfoPanel(topleftroot);
  menu_deploy_missionInfoPanel(topleftroot);
  menu_deploy_navInfoPanel(topleftroot);
  menu_deploy_mapOverviewPanel(topleftroot);
};

//hook for input system
void() menu_deployListener={
  navSelectListener();
};

//Listener hooks calle by menu_briefListener
void() navSelectListener={
  local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      if(nav.isActive == TRUE){
        if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.ui_size)){
          PLAYER_HELPER.plr_nav_pnt = nav.nav_name;
        }
      }
    }
    nav = nav.chain;
  }
};


//panels
void(vector ofs) menu_deploy_missionInfoPanel={
  drawpic(ofs + gui_percentToPixel(0.008, 0.044), UI_DEF_BOX_256, gui_percentToPixel(0.1648, 0.0729), '1 1 1', HUD_ALPHA, 0);
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
  drawpic(ofs + gui_percentToPixel(0.008, 0.118), UI_DEF_BOX_256, gui_percentToPixel(0.165, 0.073), '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[SELECTED DROP POINT]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0902, 0.12);
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "[SELECTED DROP POINT]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //nav help
  drawstring(ofs+gui_percentToPixel(0.025, 0.1312), "Click a Nav Point on the map ->", '6 6 0', CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  //current spawn point
  local string navlbl;
  if(PLAYER_HELPER.plr_nav_pnt > 0){
    navlbl = gui_getNavName(PLAYER_HELPER.plr_nav_pnt);
  }
  else{
    navlbl = "RANDOM!";
  }  
  drawstring(ofs+gui_percentToPixel(0.0125, 0.1437), strcat("[CURRENT]:            ", navlbl), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_deploy_mechInfoPanel={
  drawpic(ofs + gui_percentToPixel(0.008, 0.19), UI_DEF_BOX_256, gui_percentToPixel(0.1648, 0.0729), '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos, spos, t_color;
  local string type;
  local entity dat;
  
  tlen = stringwidth("[SELECTED METAL]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0902, 0.1916);
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "[SELECTED METAL]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  spos = ofs + gui_percentToPixel(0.0125, 0.1531);
  if(PLAYER_HELPER.plr_sel_mech > 0){
    dat = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
    drawstring(spos, strcat("[NAME] ", dat.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    // MECH SIZE
    if(dat.vec_size == 1){
      type = "Light";
      t_color = STATUS_AOK;
    }
    else if(dat.vec_size == 2){
      type = "Medium";
      t_color = STATUS_DMG;
    }
    else if(dat.vec_size == 3){
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
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - gui_percentX(0.0757));
  mpos_y = ofs_y + gui_percentY(0.0458);
  drawpic(mpos, UI_DEF_BOX_256, gui_percentToPixel(0.3164, 0.4218), '1 1 1', HUD_ALPHA, 0);
  
  local vector iofs;
  iofs = mpos + gui_percentToPixel(0.0093, 0.0125);

    if(MSN_MAPPIC != ""){
    drawpic(iofs, MSN_MAPPIC, gui_percentToPixelRawVec('380 380'), '1 1 1', HUD_ALPHA, 0);
  }
  else{
    drawstring(iofs + gui_percentToPixelRawVec('25 25'), "Satellite Data unavailable", '14 14', '1 0 0', HUD_ALPHA, 0);
  }
  local vector map_size;
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      local vector nofs;
      nofs = gui_mapCoordToImgCoord(map_size, nav.origin, iofs, gui_percentToPixelRawVec('380 380'));
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs_x = nofs_x - gui_percentXRaw((nlen/2));
      nofs_y = nofs_y - gui_percentY(0.0031);
      nav.ui_org = nofs; 
      nav.ui_size_x = nav.ui_size_x + gui_percentXRaw(nlen);
      nav.ui_size_y = nav.ui_size_y + gui_percentY(0.0062);
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      local vector hsz;
      hsz_x = nlen + gui_percentXRaw(6);
      hsz_y = gui_percentYRaw(12);
      gui_DrawHighlightRect((PLAYER_HELPER.plr_nav_pnt == nav.nav_name), nofs + gui_percentToPixelRawVec('-3 -3'), hsz, '4 4', CLR_DEF_ARM_OK, '2 2', CLR_DEF_ARM_DED);
    
    }
    nav = nav.chain;
  }
  /*local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      local vector nofs;
      nofs = gui_mapCoordToImgCoord(map_size, cprc, nav.origin, gui_percentToPixel(0.2976, 0.3968));
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs = iofs+nofs;
      nofs_x = nofs_x - (nlen/2);
      nofs_y = nofs_y - gui_percentYRaw(3);
      nav.ui_org = nofs; 
      nav.ui_size_x = nav.ui_size_x + gui_percentXRaw(nlen);
      nav.ui_size_y = nav.ui_size_y + gui_percentY(0.0062);
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      local vector hsz;
      hsz_x = nlen + gui_percentXRaw(6);
      hsz_y = gui_percentY(12);
      gui_DrawHighlightRect((PLAYER_HELPER.plr_nav_pnt == nav.nav_name), nofs+ gui_percentToPixelRawVec('-3 -3'), hsz, '4 4', CLR_DEF_ARM_OK, '2 2', CLR_DEF_ARM_DED);
    }
    nav = nav.chain;
  }*/
};