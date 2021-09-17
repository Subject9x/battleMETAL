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
  
  //guard against widescreen high vid_condwidth
  topleftroot = UI_ORG;
  
  drawfill(VIEW_ORG, VIEW_MAX, CLR_DEF_UI_BRIEF * 0.25, 1, 0 );
  menu_navBar_drawFrame(topleftroot);
  
  menu_briefMissionInfo( topleftroot + '2 32' );
  
  menu_briefPlaySound( topleftroot );
  menu_briefMapPanel( topleftroot );
  menu_brief_text_window( topleftroot + '2 113' );
  
  switch(INFO_SWITCH){
    default:
      menu_briefObjectivePanel( topleftroot + '6 138' );
      break;
    case 2:
      menu_briefIntelPanel( topleftroot + '6 138' );
      break;
    case 3:
      menu_briefMissionText( topleftroot + '8 138' );
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

  if( menu_checkMouseInBounds(cursorpos, BRIEF_MAP_HELP_ORG, '12 12', FALSE) ){
     toolTip.data_idx = MENU_BRIEF_ACTIVE;
     toolTip.mins = '164 48';
     toolTip.description = "The -Map Panel- displays (Nav) markers and <Drop Points> for the mission.";
     toolTip.angles = '0.92 0.92 0.92';
     toolTip.maxs = '12 12';
     toolTip.alpha = 1;
     return;
  }
  if( menu_checkMouseInBounds(cursorpos, BRIEF_MISSION_HELP_ORG, '12 12', FALSE) ){
     toolTip.data_idx = MENU_BRIEF_ACTIVE;
     toolTip.mins = '164 48';
     toolTip.description = "This panel displays the basic information for the mission.";
     toolTip.angles = '0.92 0.92 0.92';
     toolTip.maxs = '12 12';
     toolTip.alpha = 1;
     return;
  }
  
  if( (menu_checkMouseInBounds(cursorpos, BRIEF_OBJECTIVE_HELP_ORG, '12 12', FALSE)) && (INFO_SWITCH==1) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = '196 32';
    toolTip.description = "These are the [Objectives] required to complete the mission.";
    toolTip.angles = '0.92 0.92 0.92';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  
  if( (menu_checkMouseInBounds(cursorpos, BRIEF_OBJECTIVE_HELP_ORG, '12 12', FALSE)) && (INFO_SWITCH==2) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = '196 48';
    toolTip.description = "[Intel] provides a little bit of foresight into what you might face in the mission or which weapons/equipment might work best.";
    toolTip.angles = '0.92 0.92 0.92';
    toolTip.maxs = '12 12';
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
  if(menu_checkMouseInBounds(cursorpos, VIEW_ORG + '10 100', '243 32', TRUE)){
    if( (MSN_ANIM != "") && (time > MSN_SFX_COUNT) ){
      anm_parseFile(MSN_ANIM);
      MSN_SFX_COUNT = time + anm_total_runtime();
    }
  }
};

//panels
void(vector ofs) menu_briefMissionInfo={
  local vector fontSizeSmall, fontSizeMedium;
  
  fontSizeSmall = '10 10';
  fontSizeMedium = '12 12';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderPatch9_1_32(ofs, '256 80',  CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, DRAWFLAG_NORMAL);
  
  local float tlen;
  local vector tpos;
  tlen = stringwidth("MISSION INFO", 0, '14 14 0');
  tpos = ofs + '121 2';
  tpos_x = tpos_x - (tlen/2);
  drawstring(tpos, "MISSION INFO", '14 14', '1 1 1', 1, 0);
  
  //mission name
  drawstring( ofs + '7 14', "Name", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + '50 14', MSN_NAME, fontSizeMedium, '1 1 1', 1, 0);
  //mission type
  drawstring( ofs + '7 26', "Type", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0); 
  drawstring( ofs + '50 26', MSN_TYPE,fontSizeMedium, '1 1 1', 1, 0); 
  //reserves - one of the original ideas was to let the player respawn in fresh mechs with possibly new equipment...but I couldn't get that to 
    //work in Quake's jank-ass player lifecycle....
  //drawstring( ofs + '7 34', "Reserves:", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  //drawstring( ofs + '42 34', strcat(ftos(AVAILABLE_RESERVE), "/", MSN_RESERVETOTAL), '10 8 0', '1 1 1', 1, 0);
  //sector
  drawstring( ofs+ '7 38', "Sector", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs+ '50 38', MSN_SECTOR, fontSizeMedium, '1 1 1', 1, 0);
  //location
  drawstring( ofs + '7 50', "Location", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + '50 50', MSN_LOCATION, fontSizeMedium, '1 1 1', 1, 0);
  //local time
  drawstring( ofs + '7 62', "Local time", fontSizeSmall, CLR_DEF_TXT_NONSELECT, 1, 0);
  drawstring( ofs + '50 62', MSN_LOCALTIME, fontSizeMedium, '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = ofs;
  helpOrg_x = helpOrg_x + 256;
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
  spos = ofs + '340 75';
  drawpic(spos, UI_DEF_BOX_256, '243 32', color, 1, 0);
  
  local float tlen;
  local vector tpos;
  tlen = stringwidth(label, 0, '14 12 0');
  tpos = spos;
  tpos_x = tpos_x + ( 243 / 2 );
  tpos_y = tpos_y + ( 32 / 2 );
  
  tpos_x = tpos_x - ( tlen / 2 );
  tpos_y = tpos_y - 6;
  drawstring(tpos, label, '14 12 0', color, 1, 0);
  
  drawfont = drawfont_prev;
};

/*
  Panel - Objectives / Intel Parent panel
    draws background of objectives / intel.
    renders button bar for the panel.
*/

//shoulda been like this the whole time.
vector(vector ofs, float infoSwitch, string txt, vector btnSize) menu_brief_text_window_btn={
  
  local vector fontSize, fontSizeSmall, fontSizeMedium;
  local vector tpos;
  local float tlen;
  
  fontSizeSmall = '8 8 0';
  fontSizeMedium = '10 10 0';
  fontSize = fontSizeSmall;
  
  if( INFO_SWITCH == infoSwitch ){
    fontSize = fontSizeMedium;
  }
  
  tlen = stringwidth(txt, 0, fontSize);
  tpos_x = (ofs_x + (btnSize_x / 2)) - ( tlen / 2 );
  tpos_y = (ofs_y + (btnSize_y/2)) - ( fontSize_y / 2 );
  
  gui_renderTintImage((INFO_SWITCH==infoSwitch),ofs, UI_DEF_BOX_256_BTN, btnSize, CLR_DEF_IIF_FRIEND_BLD + '0.25 0.25 0.25', 1, 0) ;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  gui_renderHighlightString(txt, tpos, CLR_DEF_IIF_FRIEND_BLD + '0.33 0.33 0.33', '0.75 0.75 0.75', (INFO_SWITCH==infoSwitch), fontSize, 1, 0) ;
  drawfont = drawfont_prev;
  
  return ofs;
};

void(vector ofs) menu_brief_text_window={
  local vector bpos;
  
  bpos = ofs;
  gui_renderPatch9_1_32(bpos, '270 368',  CLR_DEF_UI_BRIEF + '0.2 0.2 0.2', 1, DRAWFLAG_NORMAL);
  
  OBJ_BTN_SZ = INT_BTN_SZ = BRF_BTN_SZ = '64 16';
  
  OBJ_BTN_ORG = menu_brief_text_window_btn(bpos + Vector2(32, 5), 1, "OBJECTIVES", OBJ_BTN_SZ);
  
  INT_BTN_ORG = menu_brief_text_window_btn(OBJ_BTN_ORG + Vector2(7 + OBJ_BTN_SZ_x, 0), 2, "INTEL", OBJ_BTN_SZ);
  
  BRF_BTN_ORG = menu_brief_text_window_btn(INT_BTN_ORG + Vector2(7 + OBJ_BTN_SZ_x, 0), 3, "SITUATION", OBJ_BTN_SZ);
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
  mpos = Vector2(VIEW_CTR_x - 40, ofs_y + 107); 
 
  iofs = mpos + '4 3';
  
  if(MSN_MAPPIC != ""){
    s = precache_pic(MSN_MAPPIC, 0);
    if(s != ""){
      MSN_MAPPIC = s;
    }
  }
  if(MSN_MAPPIC != ""){
    drawpic(iofs, MSN_MAPPIC, ui_msize_in, '1 1 1', 1, 0);
  }
  else{
    gui_wrapText(iofs + Vector2(ui_msize_in_x / 4.75, ui_msize_in_y / 3) , '210 32', "Satellite Data: unavailable", '16 16', '1 0 0', 1);
  }
  
  map_size = Vector2( (world.mins_x*-1) + world.maxs_x, (world.mins_y*-1) + world.maxs_y );

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
    tofs = nofs = gui_mapCoordToImgCoord(world.mins, map_size, nav.origin, iofs, ui_msize_in);
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      
    nlen = stringwidth(nav.vec_name, 0, '12 12 0');
    nofs_x = nofs_x - (nlen/2);
    nofs_y = nofs_y - 18;
    gui_renderTintImage(TRUE, tofs - '8 8', UI_DEF_NAVPOINT, '16 16', renderColor, 1, 0) ;
      
    drawstring(nofs, nav.vec_name, '12 12', renderColor + '0.4 0.4 0.4', 1, 0);
      
    drawfont = drawfont_prev;
  }
  
  local vector helpOrg;
  helpOrg = mpos;
  helpOrg_x = (helpOrg_x + ui_msize_x) - 12;
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
  local entity eObj;
  local vector objColor;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  lofs = ofs;
  lst_idx = 1;
  line_rtn = 0;
  
  objectiveOffset = Vector2(lofs_x + 2, lofs_y + line_rtn + 3);
  
  eol = TRUE;
  while(eol){
    desc = MSN_OBJ_DESC[lst_idx];
    text = strcat( ftos(lst_idx),") ", desc);
    eObj = data_objective_find( lst_idx );
    
    objColor = CLR_DEF_TXT_GRAY_SMOOTH;
    if( eObj ){
      if( eObj.aState == 2 ){
        objColor = CLR_UI_OBJT_SECOND;
      }
      if(  eObj.aState == 3 ){
        objColor = CLR_UI_OBJT_THIRD;
      }
    }
    
    line_rtn = gui_wrapText(objectiveOffset, '265 332', text, '12 12', objColor, 1);
    
    if(MSN_OBJ_DESC[(lst_idx+1)] == ""){
      eol = FALSE;
    }
    lst_idx = lst_idx + 1;
    objectiveOffset_y = objectiveOffset_y + line_rtn + 12;
  }
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = lofs;
  helpOrg_x = helpOrg_x + 255 - 12; 
  helpOrg_y = helpOrg_y - 24;
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
  
  fpos = ofs;
  gui_wrapText(fpos, '255 332', MSN_INTEL, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = fpos;
  helpOrg_x = helpOrg_x + 255 - 12; 
  helpOrg_y = helpOrg_y - 24; 
  BRIEF_INTEL_HELP_ORG = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_briefMissionText={
  local vector fpos;

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  fpos = ofs;
  gui_wrapText(fpos, '265 345', MSN_BRIEF, '10 10', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  
  drawfont = drawfont_prev;
};