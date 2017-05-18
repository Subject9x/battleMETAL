/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview:  class file for ui system
*/

/*
  mouse bounds check - 
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

void() menu_handleFrame={

  local vector mpos, i_sz;
  
  i_sz = draw_getimagesize("gfx/ui/ui_cursor.png");
  i_sz = gui_scaleSize(i_sz, VIEW_SCALE/1.25);
  
  mpos_x = cursorpos_x - 2;
  mpos_y = cursorpos_y - 4;

  if(MENU_HANGAR_ACTIVE){
    menu_hangarDrawFrame(); 
  }
  else if(MENU_BRIEF_ACTIVE){
    menu_briefDrawFrame();
  }
  else if(MENU_DEPLOY_ACTIVE){
    menu_deployDrawFrame();
  }
  //menu_navBar((VIEW_ORG+'2 12'));
  menu_navBar(VIEW_ORG);
  drawpic(mpos, "gfx/ui/ui_cursor.png",  i_sz, '1 1 1', HUD_ALPHA, 0);
  drawstring(VIEW_ORG+'2 2', vtos(cursorpos), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    
};


void() mechAcceptButtonListener={
  if(menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ)){
    if(PLAYER_HELPER.plr_sel_mech > 0){
      cl_setspawnpoint(PLAYER_HELPER.plr_nav_pnt);
      cl_setmech(PLAYER_HELPER.plr_sel_mech);
      local float lst_idx, bit;
      lst_idx = 1;
      bit = 1;
      while(lst_idx <= HARDPOINT_CNT){
        cl_setweapon(bit, HARDPOINTS[lst_idx]);
        bit = bit * 2;
        lst_idx = lst_idx + 1;
      }
      cl_setweapongroup(1, PLAYER_HELPER.plr_nex_grp1);
      cl_setweapongroup(2, PLAYER_HELPER.plr_nex_grp2);
      cl_setweapongroup(3, PLAYER_HELPER.plr_nex_grp3);
      cl_setweapongroup(4, PLAYER_HELPER.plr_nex_grp4);
      cl_setweapongroup(5, PLAYER_HELPER.plr_nex_grp5);
      cl_spawnmech();
      MENU_ACTIVE = FALSE;
      setcursormode(0);
    }
  }
};

void(vector ofs) menu_navBar={
  local vector nvpos, hpos, tpos, dpos, rpos, lpos, isz;
  local float strwid;
  nvpos = ofs + gui_percentToPixel(0.0078, 0.0078);
  
  gui_renderTintImage(MENU_BRIEF_ACTIVE, nvpos, UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  tpos = nvpos;
  strwid = stringwidth("[BRIEFING]", 0 ,'8 8 0')/2;
  tpos_x = (nvpos_x + gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  tpos_y = nvpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[BRIEFING]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', MENU_BRIEF_ACTIVE, '8 8 0', HUD_ALPHA, 0) ;
  
  gui_renderTintImage(MENU_HANGAR_ACTIVE, (nvpos+gui_percentToPixel(0.075, 0)), UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  hpos = nvpos + gui_percentToPixel(0.075, 0);
  strwid = stringwidth("[HANGAR]", 0 ,'8 8 0')/2;
  hpos_x = (hpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  hpos_y = hpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[HANGAR]", hpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', MENU_HANGAR_ACTIVE, '8 8 0', HUD_ALPHA, 0) ;
  
  gui_renderTintImage(MENU_DEPLOY_ACTIVE, (nvpos+gui_percentToPixel(0.15, 0)),UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  dpos = nvpos + gui_percentToPixel(0.15, 0);
  strwid = stringwidth("[DEPLOYMENT]", 0 ,'8 8 0')/2;
  dpos_x = (dpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  dpos_y = dpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[DEPLOYMENT]", dpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', MENU_DEPLOY_ACTIVE, '8 8 0', HUD_ALPHA, 0) ;

  rpos = nvpos;
  rpos_x = VIEW_MAX_x - gui_percentX(0.1);
  lpos = rpos;
  lpos_x = (lpos_x + gui_percentX(0.05)) - (stringwidth(">>[LAUNCH]>>", 0 ,'8 8 0')/2);
  lpos_y = (lpos_y + gui_percentX(0.0045));//16) - 8;
  isz_x = gui_percentXRaw(stringwidth(">>[!LAUNCH!]>>", 0 ,'8 8 0')) + gui_percentX(0.0093);
  isz_y = gui_percentY(0.025);
  gui_renderTintImage2(MENU_LAUNCH_ROLLOVER, rpos + gui_percentToPixel(0.005, 0), UI_DEF_BOX_256, isz, CLR_DEF_WEP_INRANGE, CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  gui_renderHighlightString(">>[LAUNCH]>>",lpos, CLR_DEF_WEP_INRANGE, CLR_DEF_ARM_THREEQ, MENU_LAUNCH_ROLLOVER, '8 8 0', HUD_ALPHA, 0) ;
  MENU_BTN_LAUNCH_ORG = rpos + gui_percentToPixel(0.005, 0);
  MENU_BTN_LAUNCH_SZ = isz;
};

void() menu_mainListener={
  navBarListener();
  mechAcceptButtonListener();
};

void() navBarListener={
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.0097, 0.0109), gui_percentToPixel(0.075, 0.025))){
    MENU_BRIEF_ACTIVE = TRUE;
    MENU_HANGAR_ACTIVE = FALSE;
    MENU_DEPLOY_ACTIVE = FALSE;
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixel(0.0843, 0.0109), gui_percentToPixel(0.075, 0.025))){
    MENU_BRIEF_ACTIVE = FALSE;
    MENU_HANGAR_ACTIVE = TRUE;
    MENU_DEPLOY_ACTIVE = FALSE;
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixel(0.159, 0.0109), gui_percentToPixel(0.075, 0.025))){
    MENU_BRIEF_ACTIVE = FALSE;
    MENU_HANGAR_ACTIVE = FALSE;
    MENU_DEPLOY_ACTIVE = TRUE;
  }
};


void(entity nav) ui_renderNav={
  local vector apos, tofs, iofs, i_sz;
  i_sz = draw_getimagesize(UI_DEF_NAVPOINT);
  apos = cs_project(nav.origin);
  tofs = apos;
  if (apos_z >= 0) {
    tofs_x -= stringwidth(nav.w_name, TRUE, '6 6') * 0.5; //align horizontally to centre
    tofs_y -= 6 * 0.5; //align vertically again
    tofs_z = 0; //shut up dp.
    apos_z = 0; //shut up dp.
    iofs = apos;
    i_sz_x = i_sz_x / 4;
    i_sz_y = i_sz_y / 4;
    iofs_x = iofs_x - (i_sz_x/2);
    iofs_y = iofs_y - (i_sz_y/2);
    gui_renderTintImage(TRUE, iofs, UI_DEF_NAVPOINT, i_sz, CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
    drawstring(tofs, nav.w_name, '6 6', CLR_DEF_WEP_INRANGE, 1, 0);
  }
};

void(float wid, vector org, float selected) ui_renderHardPointGraphic={
  local entity wep;
  gui_renderTintImage(selected, org, UI_DEF_BOX_256, '24 24', CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  if(wid > 0 ){
    wep = m_findData(wid, DATA_WEPN);
    drawpic( org +'1 1', wep.w_icon,  '22 22', '1 1 1', HUD_ALPHA, 0);
  }
};

void(float num, vector org) ui_renderHardPointNumber={
  drawstring(org, ftos(num), '10 8', CLR_DEF_WHITE, 0.85, 1);
};