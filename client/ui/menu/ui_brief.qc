/*
battleMETAL
Author: Peter Roohr
Date: 3/26/2017
mod: 6/18/2019
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_briefDrawFrame={
  local vector topleftroot;
  
  topleftroot = VIEW_ORG;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_BRIEF, 1, 0);
  
  menu_navBar_drawFrame(VIEW_ORG);
  
  menu_briefMissionInfo( topleftroot + gui_percentToPixelRawVec('10 32') );
  menu_briefPlaySound( topleftroot );
  menu_briefMapPanel( topleftroot );
  menu_brief_text_window( topleftroot );
  
  switch(INFO_SWITCH){
    default:
      menu_briefObjectivePanel( topleftroot );
      break;
    case 2:
      menu_briefIntelPanel( topleftroot );
      break;
    case 3:
      menu_briefMissionText( topleftroot );
  }
};

//hook for input system
void() menu_briefListener_onClick={
  menu_navbBar_listener();
  objIntelSwitchListener();
  briefSoundListener();
};

void() menu_briefListener_onDrag={
	
};

void() menu_briefListener_onHover={

  if( menu_checkMouseInBounds(cursorpos, BRIEF_MAP_HELP_ORG, gui_percentToPixelRawVec('12 12'), FALSE) ){
     toolTip.data_idx = MENU_BRIEF_ACTIVE;
     toolTip.mins = gui_percentToPixelRawVec('164 48 0');
     toolTip.description = "The -Map Panel- displays (Nav) markers and <Drop Points> for the mission.";
     toolTip.angles = '0.92 0.92 0.92';
     toolTip.maxs = '12 10 0';
     toolTip.alpha = 1;
     return;
  }
  if( menu_checkMouseInBounds(cursorpos, BRIEF_MISSION_HELP_ORG, gui_percentToPixelRawVec('12 12'), FALSE) ){
     toolTip.data_idx = MENU_BRIEF_ACTIVE;
     toolTip.mins = gui_percentToPixelRawVec('164 48 0');
     toolTip.description = "This panel displays the basic information for the mission.";
     toolTip.angles = '0.92 0.92 0.92';
     toolTip.maxs = '12 10 0';
     toolTip.alpha = 1;
     return;
  }
  
  if( (menu_checkMouseInBounds(cursorpos, BRIEF_OBJECTIVE_HELP_ORG, gui_percentToPixelRawVec('12 12'), FALSE)) && (INFO_SWITCH==1) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('196 32 0');
    toolTip.description = "These are the [Objectives] required to complete the mission.";
    toolTip.angles = '0.92 0.92 0.92';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( (menu_checkMouseInBounds(cursorpos, BRIEF_OBJECTIVE_HELP_ORG, gui_percentToPixelRawVec('12 12'), FALSE)) && (INFO_SWITCH==2) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('196 48 0');
    toolTip.description = "[Intel] provides a little bit of foresight into what you might face in the mission or which weapons/equipment might work best.";
    toolTip.angles = '0.92 0.92 0.92';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  toolTip.data_idx = FALSE;
  
};

void() objIntelSwitchListener={
  if(menu_checkMouseInBounds(cursorpos, OBJ_BTN_ORG, OBJ_BTN_SZ, TRUE)){
    INFO_SWITCH = 1;
  }
  else if(menu_checkMouseInBounds(cursorpos, INT_BTN_ORG, INT_BTN_SZ, TRUE)){ 
    INFO_SWITCH = 2;
  }
  else if(menu_checkMouseInBounds(cursorpos, BRF_BTN_ORG, BRF_BTN_SZ, TRUE)){ 
    INFO_SWITCH = 3;
  }
};

void() briefSoundListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_ORG + gui_percentToPixelRawVec('10 100'), gui_percentToPixelRawVec('243 32'), TRUE)){
    if( (MSN_ANIM != "") && (time > MSN_SFX_COUNT) ){
      anm_parseFile(MSN_ANIM);
      MSN_SFX_COUNT = time + anm_total_runtime();
    }
  }
};

//panels
void(vector ofs) menu_briefMissionInfo={
  local vector fontSizeSmall, fontSizeMedium;
  
  fontSizeSmall = '8 8';
  fontSizeMedium = '10 10';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawpic(ofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('243.2 75'), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("-MISSION INFO-", 0, '14 12 0');
  tpos = ofs + gui_percentToPixelRawVec('121 2');
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "-MISSION INFO-", '14 12 0', '1 1 1', 1, 0);
  
  //mission name
  drawstring( ofs + gui_percentToPixelRawVec('7 14'), "Name:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + gui_percentToPixelRawVec('42 14'), MSN_NAME, fontSizeMedium, '1 1 1', 1, 0);
  //mission type
  drawstring( ofs + gui_percentToPixelRawVec('7 24'), "Type:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0); 
  drawstring( ofs + gui_percentToPixelRawVec('42 24'), MSN_TYPE,fontSizeMedium, '1 1 1', 1, 0); 
  //reserves
  drawstring( ofs + gui_percentToPixelRawVec('7 34'), "Reserves:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + gui_percentToPixelRawVec('42 34'), strcat(ftos(AVAILABLE_RESERVE), "/", MSN_RESERVETOTAL), '10 8 0', '1 1 1', 1, 0);
  //sector
  drawstring( ofs+ gui_percentToPixelRawVec('7 44'), "Sector:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs+ gui_percentToPixelRawVec('42 44'), MSN_SECTOR, fontSizeMedium, '1 1 1', 1, 0);
  //location
  drawstring( ofs + gui_percentToPixelRawVec('7 54'), "Location:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + gui_percentToPixelRawVec('42 54'), MSN_LOCATION, fontSizeMedium, '1 1 1', 1, 0);
  //local time
  drawstring( ofs + gui_percentToPixelRawVec('7 64'), "Local time:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + gui_percentToPixelRawVec('42 64'), MSN_LOCALTIME, fontSizeMedium, '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = ofs;
  helpOrg_x = helpOrg_x + gui_percentXRaw(231);
  BRIEF_MISSION_HELP_ORG = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_briefPlaySound={
  local vector spos, color;
  local string label;
  
  if( MSN_ANIM == "" ){
    return;
  }
  
  color = CLR_HUD_ORANGE;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  label = "[PLAY BRIEFING]";
  if( time < MSN_SFX_COUNT ){
    color = '0.25 0.25 0.25';
    label = "-playing-";
  }
  spos = ofs + gui_percentToPixelRawVec('340 75');
  drawpic(spos, UI_DEF_BOX_256, gui_percentToPixelRawVec('243 32'), color, 1, 0);
  
  local float tlen;
  local vector tpos;
  tlen = stringwidth(label, 0, '14 12 0');
  tpos = spos;
  tpos_x = tpos_x + gui_percentXRaw( 243 / 2 );
  tpos_y = tpos_y + gui_percentYRaw( 32 / 2 );
  
  tpos_x = tpos_x - gui_percentXRaw( tlen / 2 );
  tpos_y = tpos_y - gui_percentYRaw( 6 );
  drawstring(tpos, label, '14 12 0', color, 1, 0);
  
  drawfont = drawfont_prev;
};

/*
  Panel - Objectives / Intel Parent panel
    draws background of objectives / intel.
    renders button bar for the panel.
*/
void(vector ofs) menu_brief_text_window={
  local vector bpos;
  
  bpos = ofs + gui_percentToPixelRawVec('10 107');
  drawpic(bpos, UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('270 365'), CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);

  bpos = bpos + gui_percentToPixelRawVec('7 2');
  
  local vector tpos, isz;
  local float tlen;
  local vector fontSize, fontSizeSmall, fontSizeMedium;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  fontSizeSmall = '8 8 0';
  fontSizeMedium = '10 10 0';
  fontSize = fontSizeSmall;
  
  if( INFO_SWITCH == 1 ){
    fontSize = fontSizeMedium;
  }
  
  isz = gui_percentToPixelRawVec('64 16');
  
  tlen = stringwidth("[OBJECTIVES]", 0, fontSize);
  tpos_x = (bpos_x + gui_percentXRaw(32)) - gui_percentXRaw( tlen / 2 );
  tpos_y = (bpos_y + gui_percentYRaw(12)) - gui_percentYRaw( fontSize_y / 2 );
  
  OBJ_BTN_ORG = bpos + gui_percentToPixelRawVec('0 4');
  OBJ_BTN_SZ = isz;

  gui_renderTintImage((INFO_SWITCH==1), bpos + gui_percentToPixelRawVec('0 4'), UI_DEF_BOX_256_BTN, isz, CLR_DEF_IIF_FRIEND_BLD + '0.25 0.25 0.25', 1, 0) ;
  gui_renderHighlightString("[OBJECTIVES]", tpos, CLR_DEF_IIF_FRIEND_BLD + '0.33 0.33 0.33', '0.75 0.75 0.75', (INFO_SWITCH==1), fontSize, 1, 0) ;
  
  if( INFO_SWITCH == 2 ){
    fontSize = fontSizeMedium;
  }else{
    fontSize = fontSizeSmall;
  }
  
  local vector intelPos, intelSize, intelLabelPos;
  local float ilen; 
  
  intelPos = bpos;
  intelPos_x = intelPos_x + isz_x;
  ilen = stringwidth("[INTEL]", 0 , fontSize);
  
  intelLabelPos_x = (intelPos_x + gui_percentXRaw(32)) - gui_percentXRaw( ilen / 2 );
  intelLabelPos_y = (intelPos_y + gui_percentYRaw(12)) - gui_percentXRaw( fontSize_y / 2 );
  
  intelSize = gui_percentToPixelRawVec('64 16');
  
  INT_BTN_ORG = intelPos + gui_percentToPixelRawVec('-6 4');
  INT_BTN_SZ = intelSize;
  gui_renderTintImage((INFO_SWITCH==2), intelPos + gui_percentToPixelRawVec('0 4'), UI_DEF_BOX_256_BTN, intelSize, CLR_DEF_IIF_FRIEND_BLD + '0.25 0.25 0.25', 1, 0) ;
  gui_renderHighlightString("[INTEL]", intelLabelPos, CLR_DEF_IIF_FRIEND_BLD + '0.33 0.33 0.33', '0.75 0.75 0.75', (INFO_SWITCH==2), fontSize, 1, 0) ;
  
  if( INFO_SWITCH == 3 ){
    fontSize = fontSizeMedium;
  }else{
    fontSize = fontSizeSmall;
  }
  
  local vector briefPos, briefSize, briefLabelPos;
  local float blen; 
  
  briefPos = intelPos;
  briefPos_x = briefPos_x + isz_x;
  blen = stringwidth("[SITUATION]", 0 , fontSize);
  
  briefLabelPos_x = (briefPos_x + gui_percentXRaw(32)) - gui_percentXRaw( blen / 2 );
  briefLabelPos_y = (briefPos_y + gui_percentYRaw(12)) - gui_percentXRaw( fontSize_y / 2 );
  
  briefSize = gui_percentToPixelRawVec('64 16');
  
  BRF_BTN_ORG = briefPos + gui_percentToPixelRawVec('-6 4');
  BRF_BTN_SZ = briefSize;
  gui_renderTintImage((INFO_SWITCH==3), briefPos + gui_percentToPixelRawVec('0 4'), UI_DEF_BOX_256_BTN, briefSize, CLR_DEF_IIF_FRIEND_BLD + '0.25 0.25 0.25', 1, 0) ;
  gui_renderHighlightString("[SITUATION]", briefLabelPos, CLR_DEF_IIF_FRIEND_BLD + '0.33 0.33 0.33', '0.75 0.75 0.75', (INFO_SWITCH==3), fontSize, 1, 0) ;
  
  drawfont = drawfont_prev;
};

/*
  Panel - Mission Briefing
    maps to the 'brief' value in the .msn file.
    renders briefing text in text-wrapping block.
*/
void(vector ofs) menu_briefMapPanel={
  local vector mpos, ui_msize, ui_msize_in;
  local vector iofs, map_size;
  local vector renderColor;
  local float itr;
  local string s;
  
  itr = 0;
  
  ui_msize = '350 350';
  ui_msize_in = ui_msize - '8 6';
  ui_msize = gui_percentToPixelRawVec(ui_msize);
  mpos_x = (VIEW_CTR_x - gui_percentXRaw(40));  //@325
  mpos_y = ofs_y + gui_percentYRaw(107);
  
  drawpic(mpos, UI_DEF_BOX_512, ui_msize, CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, 0);
 
  iofs = mpos + gui_percentToPixelRawVec('4 3');
  
  if(MSN_MAPPIC != ""){
    s = precache_pic(MSN_MAPPIC, 0);
    if(s != ""){
      MSN_MAPPIC = s;
    }
  }
  if(MSN_MAPPIC != ""){
    drawpic(iofs, MSN_MAPPIC, gui_percentToPixelRawVec(ui_msize_in), '1 1 1', 1, 0);
  }
  else{
    gui_wrapText(iofs + gui_percentToPixelRaw(ui_msize_in_x / 4.75, ui_msize_in_y / 3) , '210 32', "Satellite Data: unavailable", '16 14 0', '1 0 0', 1);
  }

  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);

  renderColor  = CLR_DEF_GREEN - '0.1 0.1 0.1';

  local entity nav;
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    local vector nofs, tofs;
    local float nlen;
    
    if( nav.faction != FACTION_ALL ){
      if( nav.faction != CLIENT_faction ){
        continue;
      }
    }
    
    if( nav.isActive == FALSE ){
      continue;
    }
    tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, nav.origin, iofs, gui_percentToPixelRawVec(ui_msize_in));
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      
    nlen = stringwidth(nav.vec_name, 0, '12 12 0');
    nofs_x = nofs_x - gui_percentXRaw((nlen/2));
    nofs_y = nofs_y - gui_percentYRaw(18);
    gui_renderTintImage(TRUE, tofs - gui_percentToPixelRawVec('8 8'), UI_DEF_NAVPOINT, '16 16', renderColor, 1, 0) ;
      
    drawstring(nofs, nav.vec_name, '12 12 0', renderColor + '0.4 0.4 0.4', 1, 0);
      
    drawfont = drawfont_prev;
  }
  
  //draw compass
  local vector compass;
  compass = iofs;
  compass_y = compass_y + gui_percentYRaw(ui_msize_in_y) - gui_percentYRaw(128);
  drawpic(compass, UI_COMPASS, gui_percentToPixelRawVec('128 128'), '0.75 1.1 1.1', 0.4, 0);
  
  local vector helpOrg;
  helpOrg = mpos;
  helpOrg_x = (helpOrg_x + ui_msize_x) - gui_percentXRaw(12);
  BRIEF_MAP_HELP_ORG = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
  
};

/*
  Panel - Objectives
  maps to the 'obj' values in the .msn file.
  lists objectives in numbered order based on MSN_OBJ_DESC[] array order.
*/
void(vector ofs) menu_briefObjectivePanel={
  local vector lofs;
  local float lst_idx, eol, line_rtn;
  local vector objectiveOffset;
  local string desc;
  local string text;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  lofs = ofs + gui_percentToPixelRawVec('18 133');
  lst_idx = 1;
  line_rtn = 0;
  objectiveOffset_x = lofs_x + gui_percentXRaw(2);
  objectiveOffset_y = lofs_y + line_rtn + gui_percentYRaw(3);
  eol = TRUE;
  while(eol){
    desc = MSN_OBJ_DESC[lst_idx];
    text = strcat( ftos(lst_idx),") ", desc);
    line_rtn = gui_wrapText(objectiveOffset, '265 332', text, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + gui_percentYRaw(12);
  }
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = lofs;
  helpOrg_x = helpOrg_x + gui_percentXRaw(255) - gui_percentXRaw(12); 
  helpOrg_y = helpOrg_y - gui_percentYRaw(24); 
  BRIEF_OBJECTIVE_HELP_ORG = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

/*
  Panel - Intel
  maps to the 'intel' value in the .msn file.
*/
void(vector ofs) menu_briefIntelPanel={
  local vector fpos;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  fpos = ofs + gui_percentToPixelRawVec('22 133');
  gui_wrapText(fpos, '255 332', MSN_INTEL, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = fpos;
  helpOrg_x = helpOrg_x + gui_percentXRaw(255) - gui_percentXRaw(12); 
  helpOrg_y = helpOrg_y - gui_percentYRaw(24); 
  BRIEF_INTEL_HELP_ORG = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_briefMissionText={
  local vector fpos;

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  fpos = ofs + gui_percentToPixelRawVec('24 133');
  gui_wrapText(fpos, '245 332', MSN_BRIEF, '11 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  
  drawfont = drawfont_prev;
};