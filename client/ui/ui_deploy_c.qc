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
  topleftroot = VIEW_ORG + '2 12';
  drawpic(topleftroot, UI_DEF_BOX_512, (VIEW_MAX - '4 24'), '1 1 1', HUD_ALPHA, 0);
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
      if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.ui_size)){
        PLAYER_HELPER.plr_nav_pnt = nav.nav_name;
      }
    }
    nav = nav.chain;
  }
  
  
};


//panels
void(vector ofs) menu_deploy_missionInfoPanel={
  drawpic(ofs + '10 42', UI_DEF_BOX_256, '211 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION STATUS]", 0, '8 8 0');
  tpos = ofs + '115.5 44';
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "[MISSION STATUS]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission name
  drawstring(ofs+'14 56', strcat("[NAME]:            ", MSN_NAME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //mission type
  drawstring(ofs+'14 64', strcat("[TYPE]:            ", MSN_TYPE), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  //reserves
  drawstring(ofs+'14 72', strcat("[RESOURCE POINTS]: ", ftos(AVAILABLE_RESERVE)), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //sector
  //drawstring(ofs+'14 80', strcat("[SECTOR]:          ", MSN_SECTOR), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //location
  //drawstring(ofs+'14 88', strcat("[LOCATION]:        ", MSN_LOCATION ), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ////local time
  //drawstring(ofs+'14 96', strcat("[LOCAL TIME]:      ", MSN_LOCALTIME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_deploy_navInfoPanel={
  drawpic(ofs + '10 112', UI_DEF_BOX_256, '211 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[SELECTED DROP POINT]", 0, '8 8 0');
  tpos = ofs + '115.5 114';
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "[SELECTED DROP POINT]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //nav help
  drawstring(ofs+'16 126', "Click a Nav Point on the map ->", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //current spawn point
  local string navlbl;
  if(PLAYER_HELPER.plr_nav_pnt > 0){
    navlbl = gui_getNavName(PLAYER_HELPER.plr_nav_pnt);
  }
  else{
    navlbl = "RANDOM!";
  }  
  drawstring(ofs+'16 138', strcat("[CURRENT]:            ", navlbl), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  //reserves
  //drawstring(ofs+'14 72', strcat("[RESOURCE POINTS]: ", ftos(AVAILABLE_RESERVE)), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
};

void(vector ofs) menu_deploy_mechInfoPanel={
  drawpic(ofs + '10 182', UI_DEF_BOX_256, '211 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos, spos, t_color;
  local string type;
  local entity dat;
  
  tlen = stringwidth("[SELECTED METAL]", 0, '8 8 0');
  tpos = ofs + '115.5 184';
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "[SELECTED METAL]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  spos = ofs + '16 196';
  if(PLAYER_HELPER.plr_sel_mech >0){
    dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
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
    drawstring(spos + '0 8', "[TYPE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + '48 8',  type, '6 6 0', t_color, HUD_ALPHA, 0);
    drawstring(spos + '0 16', "[COST] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + '48 16',  "0", '6 6 0', t_color, HUD_ALPHA, 0);
    drawstring(spos + '0 24', "[FACTION] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(spos + '56 24',  "0", '6 6 0', t_color, HUD_ALPHA, 0);
  }
  else{
    drawstring(spos, "NO METAL SELECTED!", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    drawstring(spos + '0 8', "SELECT ONE FROM THE HANGAR BEFORE", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    drawstring(spos + '0 16', "DEPLOYMENT!", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
};

void(vector ofs) menu_deploy_mapOverviewPanel={
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - 97);
  mpos_y = ofs_y + 44;
  drawpic(mpos, UI_DEF_BOX_256, '405 405', '1 1 1', HUD_ALPHA, 0);
  
  local vector iofs;
  iofs = mpos + '12 12';
  
  drawpic(iofs, "maps/t_train0_over.png", '381 381', '1 1 1', HUD_ALPHA, 0);
  
  
  local vector map_size, cprc;
  map_size_x = (world.mins_x*-1) + world.maxs_x;
  map_size_y = (world.mins_y*-1) + world.maxs_y;

  cprc_x = ((world.mins_x*-1)/map_size_x);
  cprc_y = ((world.mins_y*-1)/map_size_y);
  
  local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      local vector nofs;
      nofs = gui_mapCoordToImgCoord(map_size, cprc, nav.origin, '381 381 0');
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs = iofs+nofs;
      nofs_x = nofs_x - (nlen/2);
      nofs_y = nofs_y - 3;
      nav.ui_org = nofs; 
      nav.ui_size_x = nav.ui_size_x + nlen;
      nav.ui_size_y = nav.ui_size_y + 6;
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      local vector hsz;
      hsz_x = nlen+6;
      hsz_y = 12;
      gui_DrawHighlightRect((PLAYER_HELPER.plr_nav_pnt == nav.nav_name), nofs+'-3 -3', hsz, '4 4', CLR_DEF_ARM_OK, '2 2', CLR_DEF_ARM_DED);
    }
    nav = nav.chain;
  }
};