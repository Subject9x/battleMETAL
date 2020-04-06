/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  the entry function for the CSQC / client menu system.
  this code also handles menu bar (top buttons) input and it details
  the transition between menus.
*/

/*
  Primary menu rendering function, called by client_main.
  renders the NavBar at the top, along with the chosen menu sub function
*/
void() menu_handleFrame={
  local vector mpos; 
  cursorpos = getmousepos();
  
  //UI Theming
  if( CLIENT_faction == 1 ){
    CLR_DEF_UI_BRIEF = CLR_UI_PSC_BRIEF;
    CLR_DEF_UI_HANGAR = CLR_UI_PSC_HANGAR;
    CLR_DEF_UI_ARMING = CLR_UI_PSC_ARMING;
    CLR_DEF_UI_DEPLOY = CLR_UI_PSC_DEPLOY;
  }
  else if( CLIENT_faction == 2 ){
    CLR_DEF_UI_BRIEF = CLR_UI_AUTH_BRIEF;
    CLR_DEF_UI_HANGAR = CLR_UI_AUTH_HANGAR;
    CLR_DEF_UI_ARMING = CLR_UI_AUTH_ARMING;
    CLR_DEF_UI_DEPLOY = CLR_UI_AUTH_DEPLOY;
  }

  cursorImageSize = draw_getimagesize(UI_CURSOR_IMG);
  cursorImageSize = gui_percentToPixelRawVec( gui_scaleSize(cursorImageSize, VIEW_SCALE/1.25) );
  
  mpos_x = cursorpos_x - gui_percentXRaw(2);
  mpos_y = cursorpos_y - gui_percentXRaw(4);
  
  handle_input_drag();
  handle_input_hover();
  
  switch( CLIENT_MENU_menu_choice ){
    case MENU_HANGAR_ACTIVE:
      menu_hangarDrawFrame(); 
      break;
    case MENU_BRIEF_ACTIVE:
      menu_briefDrawFrame();
      break;
    case MENU_ARMING_ACTIVE:
      menu_arming_drawFrame();
      break;
    case MENU_DEPLOY_ACTIVE:
      menu_deployDrawFrame();
      break;
    case MENU_DEBRIEF_ACTIVE:
      menu_debrief_drawFrame();
      break;
    case MENU_CONNECT_ACTIVE:
      menu_connect_drawFrame();
      break;
  }

  if( toolTip.data_idx > FALSE ){
    gui_toolTipMessage(toolTip.description, toolTip.mins, toolTip.maxs, UI_DEF_BOX_512, gui_percentToPixelRawVec('12 0'), toolTip.angles, '0.85 0.85 0.85', 1 ); 
  }
  drawpic(mpos, UI_CURSOR_IMG, cursorImageSize, '1 1 1', 1, 0);
};

/*
  When Player clicks the mouse button, this runs a check to see if the mouse coords area
  within the function coords. If they are, return TRUE.
*/
float(vector mpos, vector org, vector sz, float playClickSound) menu_checkMouseInBounds={

  local vector areaSize;
  areaSize = org+sz;
  if( ((mpos_x > org_x) && (mpos_x < areaSize_x)) && ((mpos_y > org_y) && (mpos_y < areaSize_y)) ){
	if( playClickSound ){
		pointsound(pmove_org, "sound/misc/menu1.wav", 1, ATTN_NORM); //maybe not the best place for this.
	}
    return TRUE;
  }
  return FALSE;
};

/*
  calculates the screen-area of a list, determines if the mouse is within the bounds of one of these
  and returns the index number of the item if any'
*/
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener={
  if( menu_checkMouseInBounds(cursorpos, org, list_size, FALSE) ){
    local float listIndex, toSender;
    local vector listOffset;
    local float selectCheck;
    
	listIndex = 1;
    toSender = 0;
	
    while(listIndex <= max_items){
      listOffset_x = org_x;
      listOffset_y = org_y + (listIndex * row_size_y);
      
      selectCheck = menu_checkMouseInBounds(cursorpos, listOffset, row_size, FALSE);
   
      if( selectCheck ){
        gui_DrawRect(listOffset, listOffset + row_size, '2 2', '1 1 1');
        toSender = listIndex;
      }
      listIndex = listIndex + 1;
    }
    return toSender;
  }
  else{
    return 0;
  }
};

/*
  Default nav bar, but any menu can implment its own to customize this;
    just make sure the custom nav bar gets a custom onClick() func to match.
*/
void(vector ofs) menu_navBar_drawFrame={
  local vector nvpos
  local vector launchPos;
  
  nvpos = ofs + gui_percentToPixelRawVec('9.984 7.488');
  
  launchPos_x = VIEW_MAX_x - gui_percentXRaw(138);
  launchPos_y = nvpos_y;
  
  ui_navbutton_brief_draw( nvpos );
  ui_navbutton_hangar_draw( nvpos + gui_percentToPixelRawVec('96 0') ) ;
  ui_navbutton_arming_draw( nvpos + gui_percentToPixelRawVec('192 0') ) ;
  ui_navbutton_deploy_draw( nvpos + gui_percentToPixelRawVec('288 0')) ;
  ui_navbutton_launch_draw( launchPos ) ;
  
};

void() menu_mainListener={
  //stop briefing if its playing
  if(ANM_FILE_STATUS == 1){
    cl_exit_animatic();
  }
};

void() menu_navbBar_listener={

  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_BRIEF_ORG, gui_percentToPixelRawVec(UI_NAVBAR_BRIEF_SIZE), TRUE)){
    ui_navbutton_brief_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_HANGAR_ORG, gui_percentToPixelRawVec(UI_NAVBAR_HANGAR_SIZE), TRUE)){
    ui_navbutton_hangar_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_ARMING_ORG, gui_percentToPixelRawVec(UI_NAVBAR_ARMING_SIZE), TRUE)){
    ui_navbutton_arming_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DEPLOY_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DEPLOY_SIZE), TRUE)){
    ui_navbutton_deploy_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_LAUNCH_ORG, UI_NAVBAR_LAUNCH_SIZE, FALSE)){
    ui_navbutton_launch_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_CONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_CONNECT_SIZE), TRUE)){
    ui_navbutton_connect_click();
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_INFO_ORG, gui_percentToPixelRawVec(UI_NAVBAR_INFO_SIZE), TRUE)){
    ui_navbutton_info_click();
  }
};

void() mechAcceptButtonListener={

  if( menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ, FALSE) ){

  }
};

void( float menuId ) menu_enter={
  MENU_ACTIVE = TRUE;
  CLIENT_MENU_menu_choice = menuId;
  setcursormode( 1 );
  setpause( 1 );
};

void() menu_exit={
  MENU_ACTIVE = FALSE;
  setcursormode( 0 );
  setpause( 0 );
};

float() menu_connect_choice={
  local float choice;
  //cons_logAFloat("gamemode", cvar("gamemode")); //DEBUG
  switch( cvar("gamemode") ){
    case GAMEMODE_CAMPAIGN:
      choice = MENU_BRIEF_ACTIVE;
      //cons_logAFloat("MENU_BRIEF_ACTIVE", MENU_BRIEF_ACTIVE); //DEBUG
      break;
    case GAMEMODE_COOP:
      //todo
      choice = MENU_BRIEF_ACTIVE;
      //cons_logAFloat("MENU_BRIEF_ACTIVE", MENU_BRIEF_ACTIVE); //DEBUG
      break;
    default:
      choice = MENU_CONNECT_ACTIVE;     
      //cons_logAFloat("MENU_CONNECT_ACTIVE", MENU_CONNECT_ACTIVE); //DEBUG
      break;
  }
  return choice;
};