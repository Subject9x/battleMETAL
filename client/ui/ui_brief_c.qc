/*
mech Mod
Author: Subject9x
Date: 3/26/2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_briefDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG + '2 12';
  drawpic(topleftroot, UI_DEF_BOX_512, (VIEW_MAX - '4 24'), '1 1 1', HUD_ALPHA, 0);
  menu_briefMissionInfo(topleftroot);
  menu_briefMissionText(topleftroot);
  menu_briefMapPanel(topleftroot);
  if(INFO_SWITCH){
    menu_briefObjectivePanel(topleftroot);
  }
  else{
    menu_briefIntelPanel(topleftroot);
  }
  menu_objIntelSwitchPanel(topleftroot);
};

//hook for input system
void() menu_briefListener={
  objIntelSwitchListener();

};

//Listener hooks calle by menu_briefListener
void() navpointListener={
  local float lst_idx;
  lst_idx = 0;
  while(lst_idx <= NAVPOINTS_CNT){
    
    lst_idx = lst_idx + 1;
  }  

};

void() objIntelSwitchListener={
  if(menu_checkMouseInBounds(cursorpos, OBJ_BTN_ORG, OBJ_BTN_SZ)){
    INFO_SWITCH = TRUE;
  }
  else if(menu_checkMouseInBounds(cursorpos, INT_BTN_ORG, INT_BTN_SZ)){ 
    INFO_SWITCH = FALSE;
  }
};


//panels
void(vector ofs) menu_briefMissionInfo={
  drawpic(ofs + '10 42', UI_DEF_BOX_256, '242 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION INFO]", 0, '8 8 0');
  tpos = ofs + '121 44';
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "[MISSION INFO]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission name
  drawstring(ofs+'14 56', strcat("[NAME]:            ", MSN_NAME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //mission type
  drawstring(ofs+'14 64', strcat("[TYPE]:            ",MSN_TYPE), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  //reserves
  drawstring(ofs+'14 72', strcat("[RESOURCE POINTS]: ", ftos(AVAILABLE_RESERVE)), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //sector
  drawstring(ofs+'14 80', strcat("[SECTOR]:          ", MSN_SECTOR), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //location
  drawstring(ofs+'14 88', strcat("[LOCATION]:        ", MSN_LOCATION ), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //local time
  drawstring(ofs+'14 96', strcat("[LOCAL TIME]:      ", MSN_LOCALTIME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_briefMissionText={
  local vector bpos;
  bpos = ofs + '10 112';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '242 256', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION BRIEF]", 0, '8 8 0');
  tpos = bpos + '121 4';
  tpos_x = tpos_x - tlen/2;
  drawstring(tpos, "[MISSION BRIEF]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  local float argc, lne_idx;
  local vector fpos;
  fpos = bpos + '10 20';
  argc = tokenizebyseparator(MSN_BRIEF, ";");
  lne_idx = 0;
  while(lne_idx != -1){
    local string line;
    local float llen;
    line = argv(lne_idx);
    drawstring(fpos, line, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(line ==""){
      lne_idx = -1;
    }
    else{
      lne_idx = lne_idx + 1;
      fpos_y = fpos_y + 8;
    }
  }
};

void(vector ofs) menu_briefMapPanel={
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - 66);
  mpos_y = ofs_y + 44;
  drawpic(mpos, UI_DEF_BOX_256, '375 225', '1 1 1', HUD_ALPHA, 0);
  
  local vector iofs;
  iofs = mpos + '64 6';
  
  drawpic(iofs, "maps/t_train0_over.png", '212 212', '1 1 1', HUD_ALPHA, 0);
  
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
      nofs = gui_mapCoordToImgCoord(map_size, cprc, nav.origin, '212 212 0');
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs = iofs+nofs;
      nofs_x = nofs_x - (nlen/2);
      nofs_y = nofs_y - 3;
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    }
    nav = nav.chain;
  }
};

void(vector ofs) menu_objIntelSwitchPanel={
  local vector bpos, tpos, isz;
  local float tlen, idraw, odraw;
  if(INFO_SWITCH){
    idraw = FALSE;
    odraw = TRUE;
  }
  else{
    idraw = TRUE;
    odraw = FALSE;
  }
  bpos = VIEW_CTR + '-48 40';
  tlen = stringwidth("[OBJECTIVES]", 0 ,'8 8 0');
  tpos = bpos;
  tpos_x = (bpos_x + 48) - (tlen/2);
  tpos_y = (bpos_y + 16) - 8;
  isz_x = tlen + 12;
  isz_y = 16;
  OBJ_BTN_ORG = bpos + '-6 4';
  OBJ_BTN_SZ = isz;

  gui_renderTintImage(odraw, bpos + '-6 4', UI_DEF_BOX_256, isz, CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  gui_renderHighlightString("[OBJECTIVES]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', odraw, '8 8 0', HUD_ALPHA, 0) ;
  
  local vector ipos, iisz, itpos;
  local float ilen;  
  ipos = bpos;
  ipos_x = ipos_x + isz_x;
  ilen = stringwidth("[INTEL]", 0 ,'8 8 0');
  itpos = ipos;
  itpos_y = itpos_y + 8;
  iisz_x = ilen + 12;
  iisz_y = 16;
  INT_BTN_ORG = ipos + '-6 4';
  INT_BTN_SZ = isz;
  gui_renderTintImage(idraw, ipos + '-6 4', UI_DEF_BOX_256, iisz, CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  gui_renderHighlightString("[INTEL]", itpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', idraw, '8 8 0', HUD_ALPHA, 0) ;  
};

void(vector ofs) menu_briefObjectivePanel={
  local vector bpos,tpos, lofs;
  local float tlen, lst_idx;
  local entity obj;
    
  tlen = stringwidth("[OBJECTIVES]", 0 , '8 8 0');
  bpos = VIEW_CTR + '-66 40';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '375 182', '1 1 1', HUD_ALPHA, 0);
  
  lofs = bpos + '12 24';
  obj = findchain(classname, "data");
  lst_idx = 0;
  while(obj){
    if(obj.data_type == DATA_OBJT){
      local vector oofs;
      oofs = lofs;
      oofs_y = oofs_y + (lst_idx *12);
      local string desc;
      desc = MSN_OBJ_DESC[obj.nav_name];
      drawstring(oofs, strcat("[", ftos(obj.nav_name),"]:", desc), '6 6 0', '1 1 1', HUD_ALPHA,0);  
      lst_idx = lst_idx + 1;
    }
    obj = obj.chain;
  }
};

void(vector ofs) menu_briefIntelPanel={
  local vector bpos;
  local string intel;
  bpos = VIEW_CTR + '-66 40';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '375 182', '1 1 1', HUD_ALPHA, 0);
  intel = MSN_INTEL;
  
  local float argc, lne_idx;
  local vector fpos;
  fpos = bpos + '12 22';
  argc = tokenizebyseparator(MSN_INTEL, ";");
  lne_idx = 0;
  while(lne_idx != -1){
    local string line;
    local float llen;
    line = argv(lne_idx);
    drawstring(fpos, line, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(line ==""){
      lne_idx = -1;
    }
    else{
      lne_idx = lne_idx + 1;
      fpos_y = fpos_y + 8;
    }
  }
};