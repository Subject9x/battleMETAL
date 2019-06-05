/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  the entry function for the CSQC / client menu system.
  
*/

/*
  Primary menu rendering function, called by client_main.
  renders the NavBar at the top, along with the chosen menu sub function
*/
void() menu_handleFrame={
  local vector mpos, i_sz;
  
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

  i_sz = draw_getimagesize(UI_CURSOR_IMG);
  i_sz = gui_percentToPixelRawVec( gui_scaleSize(i_sz, VIEW_SCALE/1.25) );
  
  mpos_x = cursorpos_x - gui_percentXRaw(2);
  mpos_y = cursorpos_y -  gui_percentXRaw(4);
  
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
  menu_navBar(VIEW_ORG);
  drawpic(mpos, UI_CURSOR_IMG,  i_sz, '1 1 1', 1, 0);
  
  //debug info
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 2'), vtos(cursorpos), '6 6 0', '1 1 1', 1, 0);
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 10'), ftos(CLIENT_MENU_sel_size), '6 6 0', '1 1 1', 1, 0);  
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 18'), ftos(CLIENT_MENU_sel_mech), '6 6 0', '1 1 1', 1, 0);  
};

/*
  When Player clicks the mouse button, this runs a check to see if the mouse coords area
  within the function coords. If they are, return TRUE.
*/
float(vector mpos, vector org, vector sz) menu_checkMouseInBounds={

  local vector asz;
  asz = org+sz;
  if(((mpos_x > org_x) && (mpos_x < asz_x))
  && ((mpos_y > org_y) && (mpos_y < asz_y))){
    pointsound(pmove_org, "sound/misc/menu1.wav", 1, ATTN_NORM); //maybe not the best place for this.
    return TRUE;
  }
  return FALSE;
};

/*
  calculates the screen-area of a list, determines if the mouse is within the bounds of one of these
  and returns the index number of the item if any'
*/
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener={
  if(menu_checkMouseInBounds(cursorpos, org, list_size)){
    local vector ofs, mx;
    local entity dat;
    local float lst_idx, toSender;
    lst_idx = 1;
    toSender = 0;
    while(lst_idx <= max_items){
      local vector lofs;
      local float chk;
      lofs_x = org_x;
      lofs_y = org_y + (lst_idx * row_size_y);
      chk = menu_checkMouseInBounds(cursorpos, lofs, row_size);
      gui_DrawRect(lofs, gui_percentToPixel(row_size_x, row_size_y), '0 0 0', '1 1 1');
      if(chk){
        gui_DrawRect(lofs, lofs + row_size, '2 2', '1 1 1');
        toSender = lst_idx;
      }
      lst_idx = lst_idx + 1;
    }
    return toSender;
  }
  else{
    return 0;
  }
};

void() mechAcceptButtonListener={
  local float lst_idx;
  local float bit;
  
  if(menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ)){
    if( (LAUNCH_VALIDATION & VALID_NODE) && (LAUNCH_VALIDATION & VALID_MECH) ){
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      cl_setmech(CLIENT_MENU_sel_size, MECH_DATA_ID);
      
      lst_idx = 1;
      bit = 1;
      while(lst_idx <= MECH_DATA_HPOINTS){
        cl_setweapon(bit, HARDPOINTS[lst_idx]);
        bit = bit * 2;
        lst_idx = lst_idx + 1;
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

void(vector ofs) menu_navBar={
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
  rpos_x = VIEW_MAX_x - gui_percentX(0.1);
  lpos = rpos;
  lpos_x = (lpos_x + gui_percentX(0.05)) - (stringwidth(">>[LAUNCH]>>", 0 ,'8 8 0')/2);
  lpos_y = (lpos_y + gui_percentX(0.0045));
  isz_x = gui_percentXRaw(stringwidth(">>[!LAUNCH!]>>", 0 ,'8 8 0')) + gui_percentX(0.0093);
  isz_y = gui_percentY(0.025);
  gui_renderTintImage2(MENU_LAUNCH_ROLLOVER, rpos + gui_percentToPixel(0.005, 0), UI_DEF_BOX_256, isz, launch_clr, CLR_DEF_ARM_THREEQ, 1, 0);
  gui_renderHighlightString(">>[LAUNCH]>>",lpos, launch_clr, CLR_DEF_ARM_THREEQ, MENU_LAUNCH_ROLLOVER, '8 8 0', 1, 0) ;
  MENU_BTN_LAUNCH_ORG = rpos + gui_percentToPixel(0.005, 0);
  MENU_BTN_LAUNCH_SZ = isz;
};

void() menu_mainListener={
  //prevent menu switch during briefing
  if(ANM_FILE_STATUS == 1){
    return;
  }
  navBarListener();
  mechAcceptButtonListener();
};

void() navBarListener={
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.0097, 0.0109), gui_percentToPixel(0.075, 0.025))){
    if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
      data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
    }
    CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixel(0.0843, 0.0109), gui_percentToPixel(0.075, 0.025))){
    if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
      data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
    }
    CLIENT_MENU_menu_choice = MENU_HANGAR_ACTIVE;
    cl_get_mechs_sort();
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('203 10'), gui_percentToPixel(0.075, 0.025))){
    if(SELECT_MECH != 0){
      CLIENT_MENU_menu_choice = MENU_ARMING_ACTIVE;
    }
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('288 10'), gui_percentToPixel(0.075, 0.025))){
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