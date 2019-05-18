/*
battleMETAL
Author: Peter Roohr
Date: 3/26/2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_briefDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_BRIEF, 1, 0);
  menu_briefMissionInfo(topleftroot+gui_percentToPixel(0.0082, 0.0395));
  menu_briefPlaySound(topleftroot);
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
  briefSoundListener();
};

//Listener hooks called by menu_briefListener
void() navpointListener={
  local float lst_idx;
  lst_idx = 0;
  while(lst_idx <= 21){
    
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

void() briefSoundListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_ORG + gui_percentToPixelRawVec('10 100'), gui_percentToPixelRawVec('243 32'))){
    if( (MSN_ANIM != "") && (time > MSN_SFX_COUNT) ){
      anm_parseFile(MSN_ANIM);
      MSN_SFX_COUNT = time + anm_total_runtime();
    }
  }
};

//panels
void(vector ofs) menu_briefMissionInfo={
  //10 42
  drawpic(ofs, UI_DEF_BOX_256, gui_percentToPixel(0.19, 0.065), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION INFO]", 0, '8 8 0');
  tpos = ofs + gui_percentToPixel(0.0945, 0.002);
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "[MISSION INFO]", '8 8 0', '1 1 1', 1, 0);
  
  //mission name
  drawstring(ofs+gui_percentToPixelRawVec('5 12'), strcat("[NAME]:       ", MSN_NAME), '6 6 0', '1 1 1', 1, 0);
  //mission type
  drawstring(ofs+gui_percentToPixelRawVec('5 20'), strcat("[TYPE]:       ",MSN_TYPE), '6 6 0', '1 1 1', 1, 0); 
  //reserves
  drawstring(ofs+gui_percentToPixelRawVec('5 28'), strcat("[RESERVES]:   ", ftos(AVAILABLE_RESERVE), "//", MSN_RESERVETOTAL), '6 6 0', '1 1 1', 1, 0);
  //sector
  drawstring(ofs+gui_percentToPixelRawVec('5 36'), strcat("[SECTOR]      ", MSN_SECTOR), '6 6 0', '1 1 1', 1, 0);
  //location
  drawstring(ofs+gui_percentToPixelRawVec('5 44'), strcat("[LOCATION]:   ", MSN_LOCATION ), '6 6 0', '1 1 1', 1, 0);
  //local time
  drawstring(ofs+gui_percentToPixelRawVec('5 52'), strcat("[LOCAL TIME]: ", MSN_LOCALTIME), '6 6 0', '1 1 1', 1, 0);
};


void(vector ofs) menu_briefPlaySound={
  local vector spos, color;
  color = CLR_DEF_WEP_INRANGE;
  if( (MSN_ANIM == "") || (time < MSN_SFX_COUNT) ){
    color = '0.25 0.25 0.25';
  }
  spos = ofs + gui_percentToPixelRawVec('10 100');
  drawpic(spos, UI_DEF_BOX_256, gui_percentToPixelRawVec('243 32'), color, 1, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("|>PLAY BRIEFING<|", 0, '8 8 0');
  tpos = spos + gui_percentToPixelRawVec('120 10');
  tpos_x = tpos_x - gui_percentXRaw((tlen/2));
  drawstring(tpos, "|>PLAY BRIEFING<|", '8 8 0', color, 1, 0);
};

void(vector ofs) menu_briefMissionText={
  local vector bpos, tpos, fpos;
  local float tlen;
  bpos = ofs + gui_percentToPixelRawVec('10 132');
  drawpic(bpos, UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('243 340'), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
  
  tlen = stringwidth("[MISSION BRIEF]", 0, '8 8 0');
  tpos = bpos + gui_percentToPixelRawVec('120 5');
  tpos_x = tpos_x - gui_percentXRaw(tlen / 2);
  drawstring(tpos, "[MISSION BRIEF]", '8 8 0', '1 1 1', 1, 0);

  fpos = bpos + gui_percentToPixelRawVec('2 20');
  gui_wrapText(fpos, '230 300', MSN_BRIEF, '7 8 0', '1 1 1', 1);
};

void(vector ofs) menu_briefMapPanel={
  local vector mpos, ui_msize, ui_msize_in;
  local vector iofs, map_size;
  local float itr;
  
  itr = 0;
  
  ui_msize = '325 245';
  ui_msize_in = ui_msize - '8 6';
  mpos_x = mpos_x + (VIEW_CTR_x - gui_percentXRaw(16));
  mpos_y = ofs_y + gui_percentYRaw(48);
  
  drawpic(mpos, UI_DEF_BOX_512, gui_percentToPixelRawVec(ui_msize), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
 
  iofs = mpos + gui_percentToPixelRawVec('4 3');
  
  if(MSN_MAPPIC != ""){
    local string s;
    s = precache_pic(MSN_MAPPIC, 0);
    if(s != ""){
      MSN_MAPPIC = s;
    }
  }
  if(MSN_MAPPIC != ""){
    drawpic(iofs, MSN_MAPPIC, gui_percentToPixelRawVec(ui_msize_in), '1 1 1', 1, 0);
  }
  else{
    gui_wrapText(iofs + gui_percentToPixelRaw(ui_msize_in_x / 4.75, ui_msize_in_y / 3) , '210 32', "Satellite Data |  unavailable", '12 12 0', '1 0 0', 1);
  }

  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);

  while( itr <= 21 ){
    local vector navorg, nofs, tofs;
    local float nactive, nlen;
    local string navname;
    nactive = NAVNAMES_ACTIVE[itr];
    
    if( nactive != FALSE ){
      navorg = NAVNAMES_ORG[itr];
      navname = NAVNAMES[itr];
    
      tofs = nofs = gui_mapCoordToImgCoord(map_size, navorg, iofs, gui_percentToPixelRawVec(ui_msize_in));
      
      nlen = stringwidth(navname, 0, '6 6 0');
      nofs_x = nofs_x - gui_percentXRaw((nlen/2));
      nofs_y = nofs_y - gui_percentYRaw(16);
      drawstring(nofs, navname, '6 6 0', '1 1 1', 1, 0);
      gui_renderTintImage(TRUE, tofs + gui_percentToPixelRawVec('-6 -6'), UI_DEF_NAVPOINT, '12 12', CLR_DEF_WHITE, 1, 0) ;
    }
    itr = itr + 1;
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
  bpos = VIEW_CTR + gui_percentToPixelRawVec('-56 40');
  tlen = stringwidth("[OBJECTIVES]", 0 ,'8 8 0');
  tpos = bpos;
  tpos_x = (bpos_x + gui_percentX(0.035)) - gui_percentXRaw((tlen/2));
  tpos_y = bpos_y + gui_percentY(0.0083);
  isz_x = tlen + gui_percentX(0.0093);
  isz_y = gui_percentY(0.0166);
  OBJ_BTN_ORG = bpos + gui_percentToPixel(0, 0.0041);
  OBJ_BTN_SZ = isz;

  gui_renderTintImage(odraw, bpos + gui_percentToPixel(0, 0.0041), UI_DEF_BOX_256, isz, CLR_DEF_WEP_INRANGE, 1, 0) ;
  gui_renderHighlightString("[OBJECTIVES]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', odraw, '8 8 0', 1, 0) ;
  
  local vector ipos, iisz, itpos;
  local float ilen;  
  ipos = bpos;
  ipos_x = ipos_x + isz_x;
  ilen = stringwidth("[INTEL]", 0 ,'8 8 0');
  itpos = ipos;
  itpos_y = itpos_y + gui_percentY(0.0083);
  iisz_x = ilen + gui_percentX(0.0093);
  iisz_y = gui_percentY(0.0166);
  INT_BTN_ORG = ipos + gui_percentToPixel(-0.0046, 0.0041);
  INT_BTN_SZ = isz;
  gui_renderTintImage(idraw, ipos + gui_percentToPixel(-0.0046, 0.0041), UI_DEF_BOX_256, iisz, CLR_DEF_WEP_INRANGE, 1, 0) ;
  gui_renderHighlightString("[INTEL]", itpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', idraw, '8 8 0', 1, 0) ;  
};

void(vector ofs) menu_briefObjectivePanel={
  local vector bpos,tpos, lofs;
  local float tlen, lst_idx, eol, line_rtn;
    
  tlen = stringwidth("[OBJECTIVES]", 0 , '8 8 0');
  bpos = VIEW_CTR + gui_percentToPixelRawVec('-66 40');
  drawpic(bpos, UI_DEF_BOX_256, gui_percentToPixelRawVec('377.6 192'), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
  
  lofs = bpos + gui_percentToPixelRawVec('6 16');
  eol = TRUE;
  lst_idx = 1;
  line_rtn = 0;
  while(eol){
    local vector oofs;
    oofs = lofs;
    oofs_y = oofs_y + gui_percentYRaw(line_rtn) + ( (lst_idx - 1) * gui_percentXRaw(4));
    local string desc;
    desc = MSN_OBJ_DESC[lst_idx];
    line_rtn = gui_wrapText(oofs, '300 300', strcat("[", ftos(lst_idx),"]: ", desc, " \n \n "), '8 8 0', '1 1 1', 1);
    if(MSN_OBJ_DESC[(lst_idx+1)] ==""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
  }
};

void(vector ofs) menu_briefIntelPanel={
  local vector bpos;
  local string intel;
  local vector fpos;
  
  bpos = VIEW_CTR + gui_percentToPixelRawVec('-66 40');
  drawpic(bpos, UI_DEF_BOX_256, gui_percentToPixelRawVec('377.6 192'), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
  
  fpos = bpos + gui_percentToPixelRawVec('12 22');
  gui_wrapText(fpos, '300 300', MSN_INTEL, '7 8 0', '1 1 1', 1);
};