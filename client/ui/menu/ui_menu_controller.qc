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
  }
  menu_navBar_drawFrame(VIEW_ORG);
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

void() mechAcceptButtonListener={
  local entity hardpoint;
  local float bit;
  
  if( menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ, FALSE) ){
    if( (LAUNCH_VALIDATION & VALID_NODE) && (LAUNCH_VALIDATION & VALID_MECH) ){
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      cl_setmech(CLIENT_MENU_sel_size, MECH_DATA_ID);
     
      bit = 1;
      hardpoint = UI_HANGAR_DATA_mech.w_slot;
      while( hardpoint ){
        cl_setweapon(bit, hardpoint.data_idx);
        bit = bit * 2;
        hardpoint = hardpoint.w_slot;
      }
	  
      cl_setweapongroup(1, CLIENT_MENU_nex_grp1);
      cl_setweapongroup(2, CLIENT_MENU_nex_grp2);
      cl_setweapongroup(3, CLIENT_MENU_nex_grp3);
      cl_setweapongroup(4, CLIENT_MENU_nex_grp4);
      cl_setweapongroup(5, CLIENT_MENU_nex_grp5);
      cl_spawnmech();
      MENU_ACTIVE = FALSE;
      setcursormode(0);
      CLIENT_MENU_nav_pnt = -1;
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
      ui_data_load_hud( MECH_DATA_ID );
    }
  }
};

void(vector ofs) menu_navBar_drawFrame={
  local vector nvpos, hpos, tpos, dpos, rpos, lpos, isz, apos;
  local float strwid;
  nvpos = ofs + gui_percentToPixelRawVec('9.984 7.488');
  
  gui_renderTintImage((CLIENT_MENU_menu_choice == MENU_BRIEF_ACTIVE), nvpos, UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, 1, 0) ;
  tpos = nvpos;
  strwid = stringwidth("[BRIEFING]", 0 ,'8 8 0')/2;
  tpos_x = (nvpos_x + gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  tpos_y = nvpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[BRIEFING]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (CLIENT_MENU_menu_choice ==MENU_BRIEF_ACTIVE), '8 8 0', 1, 0) ;
  
  gui_renderTintImage((CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE), (nvpos+gui_percentToPixel(0.075, 0)), UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, 1, 0) ;
  hpos = nvpos + gui_percentToPixel(0.075, 0);
  strwid = stringwidth("[HANGAR]", 0 ,'8 8 0')/2;
  hpos_x = (hpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  hpos_y = hpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[HANGAR]", hpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE), '8 8 0', 1, 0) ;
  
  local vector arming_clr;
  local float arming_flt;
  if(SELECT_MECH != 0){
    arming_clr = '0.75 0.75 0.75';
    arming_flt = (CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE);
    if(arming_flt){
      arming_clr = CLR_DEF_WEP_INRANGE;
    }
  }
  else{
    arming_clr = '0.25 0.25 0.25';
    arming_flt =  TRUE;
  }
  gui_renderTintImage(arming_flt, (nvpos+gui_percentToPixelRawVec('192 0')), UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), arming_clr, 1, 0) ;
  apos = nvpos + gui_percentToPixelRawVec('192 0');
  strwid = stringwidth("[ARMING]", 0 ,'8 8 0')/2;
  apos_x = (apos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  apos_y = apos_y + gui_percentY(0.0086);
  drawstring(apos, "[ARMING]", '8 8 0', arming_clr, 1, 0);
  
  local vector deploy_clr;
  local float deploy_flt;
  if( (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS) ) ){
    deploy_clr = CLR_DEF_WEP_INRANGE;
    deploy_flt = (CLIENT_MENU_menu_choice == MENU_DEPLOY_ACTIVE);
  }
  else{
    deploy_clr =  '0.25 0.25 0.25';
    deploy_flt = TRUE;
  }
  gui_renderTintImage(deploy_flt, (nvpos+gui_percentToPixelRawVec('288 0')),UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), deploy_clr, 1, 0) ;
  dpos = nvpos + gui_percentToPixelRawVec('288 0');
  strwid = stringwidth("[DEPLOYMENT]", 0 ,'8 8 0')/2;
  dpos_x = (dpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  dpos_y = dpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[DEPLOYMENT]", dpos, deploy_clr, '0.75 0.75 0.75', deploy_flt, '8 8 0', 1, 0) ;

  
  local vector launch_clr;
  if( (LAUNCH_VALIDATION & VALID_MECH) && (LAUNCH_VALIDATION & VALID_NODE) ){
    launch_clr = CLR_DEF_WEP_INRANGE;
  }
  else{
    launch_clr = '0.25 0.25 0.25';
  }
  rpos = nvpos;
  rpos_x = VIEW_MAX_x - gui_percentXRaw(138);
  lpos = rpos;
  lpos_x = (lpos_x + gui_percentXRaw(64)) - (stringwidth(">>[LAUNCH]>>", 0 ,'8 8 0')/2);
  lpos_y = (lpos_y + gui_percentYRaw(4.32));
  isz_x = gui_percentXRaw(stringwidth(">>[!LAUNCH!]>>", 0 ,'8 8 0')) + gui_percentX(0.0093);
  isz_y = gui_percentYRaw(24);
  gui_renderTintImage2(MENU_LAUNCH_ROLLOVER, rpos + gui_percentToPixel(0.005, 0), UI_DEF_BOX_256, isz, launch_clr, CLR_DEF_ARM_THREEQ, 1, 0);
  gui_renderHighlightString(">>[LAUNCH]>>",lpos, launch_clr, CLR_DEF_ARM_THREEQ, MENU_LAUNCH_ROLLOVER, '8 8 0', 1, 0) ;
  MENU_BTN_LAUNCH_ORG = rpos + gui_percentToPixel(0.005, 0);
  MENU_BTN_LAUNCH_SZ = isz;
};

void() menu_mainListener={
  //stop briefing if its playing
  if(ANM_FILE_STATUS == 1){
      cl_exit_animatic();
  }
  navBarListener();
  mechAcceptButtonListener();
};

void() navBarListener={
  local float itemUnlockCounter;
  local float itemId;
  
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.0097, 0.0109), gui_percentToPixel(0.075, 0.025), TRUE)){
    if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
      data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
    }
    CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
	
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixel(0.0843, 0.0109), gui_percentToPixel(0.075, 0.025), TRUE)){
    if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
      data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
      if( (LAUNCH_VALIDATION & VALID_MECH) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION& VALID_MECH);
      }
    }
    CLIENT_MENU_menu_choice = MENU_HANGAR_ACTIVE;
    SELECT_MECH = CLIENT_MENU_sel_mech = 0;
    cl_get_mechs_sort();
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('203 10'), gui_percentToPixel(0.075, 0.025), TRUE)){
    if(SELECT_MECH != 0){
      CLIENT_MENU_menu_choice = MENU_ARMING_ACTIVE;
      itemUnlockCounter = 0;
      while( itemUnlockCounter <= UNLOCKED_ITEMS_TOTAL ){
        if( UNLOCKED_ITEMS[itemUnlockCounter] != 0 ){
          itemId = UNLOCKED_ITEMS[itemUnlockCounter];
          //UI_ARMING_DATA_item_list is used as a sort-of pointer for list-style operations
          data_get_client_item_( UI_ARMING_DATA_item_list, itemId );	
		  
          //lists are stateful, so we offload the data we care about to clunky arrays.
          data_WeaponNames[itemId] = UI_ARMING_DATA_item_list.w_name;
          data_WeaponSize[itemId] = UI_ARMING_DATA_item_list.i_size;
          data_WeaponType[itemId] = UI_ARMING_DATA_item_list.damageType;
        }
        itemUnlockCounter = itemUnlockCounter + 1;
      }
    }
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('288 10'), gui_percentToPixel(0.075, 0.025), TRUE)){
    if( (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS) ) ){
      local entity nav;
      local float itr, idx;
      
      if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
        data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
      }
      
      itr = 0;
      idx = 0;
      while( itr < 33 ){
        local float nactive;
        nactive = DEPLOY_POINTS_ACTIVE[itr];
        if( nactive == TRUE ){
          DEPLOY_IDS[idx] = itr;
          idx = idx + 1;
        }
        itr = itr + 1;
      }
      //this does assume there's at least 1 deploy point on the map for the player...
      DEPLOY_POINT_ID = 0;
      DEPLOY_POINT_END = idx - 1;
      CLIENT_MENU_menu_choice = MENU_DEPLOY_ACTIVE;
      CLIENT_MENU_nav_pnt = DEPLOY_IDS[DEPLOY_POINT_ID];
      if( CLIENT_MENU_nav_pnt != -1 ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
    }
  }
};