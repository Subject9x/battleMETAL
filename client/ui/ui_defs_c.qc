/*
mech Mod
Author: Peter Roohr
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
  
  i_sz = draw_getimagesize(UI_CURSOR_IMG);
  i_sz = gui_percentToPixelRawVec( gui_scaleSize(i_sz, VIEW_SCALE/1.25) );
  
  mpos_x = cursorpos_x - gui_percentXRaw(2);
  mpos_y = cursorpos_y -  gui_percentXRaw(4);
  
  switch( self.plr_menu_choice ){
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
  drawpic(mpos, UI_CURSOR_IMG,  i_sz, '1 1 1', HUD_ALPHA, 0);
  
  //debug info
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 2'), vtos(cursorpos), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 10'), ftos(self.plr_sel_size), '6 6 0', '1 1 1', HUD_ALPHA, 0);  
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 18'), ftos(self.plr_sel_mech), '6 6 0', '1 1 1', HUD_ALPHA, 0);  
};

void() mechAcceptButtonListener={
  if(menu_checkMouseInBounds(cursorpos, MENU_BTN_LAUNCH_ORG, MENU_BTN_LAUNCH_SZ)){
    if( (LAUNCH_VALIDATION & VALID_NODE) && (LAUNCH_VALIDATION & VALID_MECH) ){
      cl_setspawnpoint(self.plr_nav_pnt);
      cl_setmech(self.plr_sel_size, self.plr_sel_mech);
      local float lst_idx, bit;
      lst_idx = 1;
      bit = 1;
      while(lst_idx <= self.hardpoint_cnt){
        cl_setweapon(bit, HARDPOINTS[lst_idx]);
        bit = bit * 2;
        lst_idx = lst_idx + 1;
      }
      cl_setweapongroup(1, self.plr_nex_grp1);
      cl_setweapongroup(2, self.plr_nex_grp2);
      cl_setweapongroup(3, self.plr_nex_grp3);
      cl_setweapongroup(4, self.plr_nex_grp4);
      cl_setweapongroup(5, self.plr_nex_grp5);
      cl_spawnmech();
      MENU_ACTIVE = FALSE;
      setcursormode(0);
      self.plr_nav_pnt = -1;
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
      ui_data_load_hud( self.plr_sel_mech );
    }
  }
};

void(vector ofs) menu_navBar={
  local vector nvpos, hpos, tpos, dpos, rpos, lpos, isz, apos;
  local float strwid;
  nvpos = ofs + gui_percentToPixelRawVec('9.984 7.488');
  
  gui_renderTintImage((self.plr_menu_choice == MENU_BRIEF_ACTIVE), nvpos, UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  tpos = nvpos;
  strwid = stringwidth("[BRIEFING]", 0 ,'8 8 0')/2;
  tpos_x = (nvpos_x + gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  tpos_y = nvpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[BRIEFING]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (self.plr_menu_choice ==MENU_BRIEF_ACTIVE), '8 8 0', HUD_ALPHA, 0) ;
  
  gui_renderTintImage((self.plr_menu_choice == MENU_HANGAR_ACTIVE), (nvpos+gui_percentToPixel(0.075, 0)), UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  hpos = nvpos + gui_percentToPixel(0.075, 0);
  strwid = stringwidth("[HANGAR]", 0 ,'8 8 0')/2;
  hpos_x = (hpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  hpos_y = hpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[HANGAR]", hpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (self.plr_menu_choice == MENU_HANGAR_ACTIVE), '8 8 0', HUD_ALPHA, 0) ;
  
  local vector arming_clr;
  local float arming_flt;
  if(SELECT_MECH != 0){
    arming_clr = '0.75 0.75 0.75';
    arming_flt = (self.plr_menu_choice == MENU_ARMING_ACTIVE);
    if(arming_flt){
      arming_clr = CLR_DEF_WEP_INRANGE;
    }
  }
  else{
    arming_clr = '0.25 0.25 0.25';
    arming_flt =  TRUE;
  }
  gui_renderTintImage(arming_flt, (nvpos+gui_percentToPixelRawVec('192 0')), UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), arming_clr, HUD_ALPHA, 0) ;
  apos = nvpos + gui_percentToPixelRawVec('192 0');
  strwid = stringwidth("[ARMING]", 0 ,'8 8 0')/2;
  apos_x = (apos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  apos_y = apos_y + gui_percentY(0.0086);
  drawstring(apos, "[ARMING]", '8 8 0', arming_clr, HUD_ALPHA, 0);
  
  local vector deploy_clr;
  local float deploy_flt;
  if( (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS) ) ){
    deploy_clr = CLR_DEF_WEP_INRANGE;
    deploy_flt = (self.plr_menu_choice == MENU_DEPLOY_ACTIVE);
  }
  else{
    deploy_clr =  '0.25 0.25 0.25';
    deploy_flt = TRUE;
  }
  gui_renderTintImage(deploy_flt, (nvpos+gui_percentToPixelRawVec('288 0')),UI_DEF_BOX_256, gui_percentToPixel(0.075, 0.025), deploy_clr, HUD_ALPHA, 0) ;
  dpos = nvpos + gui_percentToPixelRawVec('288 0');
  strwid = stringwidth("[DEPLOYMENT]", 0 ,'8 8 0')/2;
  dpos_x = (dpos_x +  gui_percentX(0.0375)) - gui_percentXRaw(strwid);
  dpos_y = dpos_y + gui_percentY(0.0086);
  gui_renderHighlightString("[DEPLOYMENT]", dpos, deploy_clr, '0.75 0.75 0.75', deploy_flt, '8 8 0', HUD_ALPHA, 0) ;

  
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
  gui_renderTintImage2(MENU_LAUNCH_ROLLOVER, rpos + gui_percentToPixel(0.005, 0), UI_DEF_BOX_256, isz, launch_clr, CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  gui_renderHighlightString(">>[LAUNCH]>>",lpos, launch_clr, CLR_DEF_ARM_THREEQ, MENU_LAUNCH_ROLLOVER, '8 8 0', HUD_ALPHA, 0) ;
  MENU_BTN_LAUNCH_ORG = rpos + gui_percentToPixel(0.005, 0);
  MENU_BTN_LAUNCH_SZ = isz;
};

void() menu_mainListener={
  //prevent menu switch during briefing
  if(self.ANM_FILE_STATUS == 1){
    return;
  }
  navBarListener();
  mechAcceptButtonListener();
};

void() navBarListener={
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.0097, 0.0109), gui_percentToPixel(0.075, 0.025))){
    self.plr_menu_choice = MENU_BRIEF_ACTIVE;
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixel(0.0843, 0.0109), gui_percentToPixel(0.075, 0.025))){
    self.plr_menu_choice = MENU_HANGAR_ACTIVE;
    cl_get_mechs_sort();
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('203 10'), gui_percentToPixel(0.075, 0.025))){
    if(SELECT_MECH != 0){
      self.plr_menu_choice = MENU_ARMING_ACTIVE;
    }
  }
  else if(menu_checkMouseInBounds(cursorpos,  gui_percentToPixelRawVec('288 10'), gui_percentToPixel(0.075, 0.025))){
    if( (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS) ) ){
      local entity nav;
      local float itr, idx;
      nav = findchainfloat(data_type, DATA_DEPL);
      itr = 1;
      while(nav){
        if(nav.isActive == TRUE){
          if(nav.i_faction == self.i_faction){
            DEPLOY_IDS[itr] = nav.nav_name;
            itr = itr + 1;
          }  
        }
        nav = nav.chain;
      }
      DEPLOY_POINT_END = itr;
      DEPLOY_POINT_ID = 0;
      self.plr_menu_choice = MENU_DEPLOY_ACTIVE;
    }
  }
};


void(entity nav) ui_renderNav={
  local vector apos, tofs, iofs, i_sz, nofs;
  i_sz = draw_getimagesize(UI_DEF_NAVPOINT);
  nofs = nav.origin;
  nofs_z = nofs_z + gui_percentYRaw(14);
  apos = cs_project(nofs);
  tofs = apos;
  if (apos_z >= 0) {
    tofs_x -= stringwidth(nav.w_name, TRUE, '6 6') * 0.5; //align horizontally to centre
    tofs_y = tofs_y - 14; //align vertically again
    tofs_z = 0; //shut up dp.
    apos_z = 0; //shut up dp.
    iofs = apos;
    i_sz_x = i_sz_x / 4;
    i_sz_y = i_sz_y / 4;
    iofs_x = iofs_x - (i_sz_x/2);
    iofs_y = iofs_y - (i_sz_y/2);
    if(nav.i_faction == self.i_faction){
      if(nav.isActive == TRUE){
        drawstring(tofs, nav.w_name, '6 6', CLR_DEF_WEP_INRANGE, 1, 0);
        gui_renderTintImage(TRUE, iofs, UI_DEF_NAVPOINT, i_sz, CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
      }
      else{
        //DEBUG
       // drawstring(tofs, nav.w_name, '6 6', '0.65 0.65 0.65', 1, 0);
        //gui_renderTintImage(TRUE, iofs, UI_DEF_NAVPOINT, i_sz, '0.65 0.65 0.65', HUD_ALPHA, 0) ;
      }
    }
  }
};

void(entity clnt) ui_renderClientName={
  local vector namepos, nameproj, drawcolor;
  local float namelen,drawcheck, drawdist;
  drawcheck = FALSE;
  drawdist = vlen(pmove_org - clnt.origin);
  if(self.i_faction == clnt.i_faction){
    if(drawdist <= self.radar_range * 2){
      drawcheck = TRUE;
      drawcolor = CLR_DEF_IIF_FRIEND;
    }
  }
  else{
    if(self.stat_rdr_mode){
      if(drawdist <= self.radar_range){
        drawcheck = TRUE;
        drawcolor = CLR_DEF_IFF_ENEMY;
      }
    }
  }
  if( drawcheck ){
    namelen = stringwidth(clnt.netname, 0, '10 10 0');
    namepos = clnt.origin;
    namepos_z = namepos_z + gui_percentYRaw(clnt.vec_size * 18);
    nameproj = cs_project(namepos);
    if (nameproj_z >= 0) {
      //nameproj = gui_percentToPixelRawVec(nameproj);
      nameproj_x = nameproj_x - gui_percentXRaw(namelen / 2);
      nameproj_z = 0;
      drawstring(nameproj, clnt.netname, '10 10 0', drawcolor, HUD_ALPHA, 0);
    }
    namepos = cs_unproject(nameproj);
  }
};

void(float wid, vector org, float selected) ui_renderHardPointGraphic={
  if(wid > 0 ){
    local entity wep;
    local vector iorg;
    if(selected){
      iorg = org - gui_percentToPixelRawVec('2 2');
      gui_renderTintImage(selected, iorg, UI_DEF_BOX_256, gui_percentToPixelRawVec('34 34'), CLR_DEF_RED, HUD_ALPHA, 0);
    }
    if( ITEM_DATA_ICONS[wid] != "" ){
      drawpic( org + gui_percentToPixelRawVec('1 1'), ITEM_DATA_ICONS[wid],  gui_percentToPixelRawVec('28 28'), '1 1 1', HUD_ALPHA, 0);
    }
  }
};

void(vector org, float hpt_num, float types, float sz) ui_renderHardpointRow={
  local vector pofs, iofs, szofs;
  pofs = org + gui_percentToPixelRawVec('8 0');
  pofs_y = org_y + gui_percentYRaw((hpt_num * 20));
  drawstring(pofs + gui_percentToPixelRawVec('0 4'), strcat("[#",ftos(hpt_num),"]"), '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  local float cnt;
  cnt = 0;
  if((types & DMG_ENE)){
    drawpic(pofs + gui_percentToPixelRawVec('85 0'), UI_WEP_ENE, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2', HUD_ALPHA, 0);
  }
  if((types & DMG_BAL)){
    drawpic(pofs + gui_percentToPixelRawVec('100 0'), UI_WEP_BAL, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
  if((types & DMG_EXP)){
    drawpic(pofs + gui_percentToPixelRawVec('120 0'), UI_WEP_EXP, gui_percentToPixelRawVec('16 16'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  }
  if((types & DMG_MSC)){
    drawpic(pofs + gui_percentToPixelRawVec('140 0'), UI_WEP_MSC, gui_percentToPixelRawVec('16 16'), CLR_DEF_RET_GETLOCK, HUD_ALPHA, 0);
  }
  drawstring(pofs + gui_percentToPixelRawVec('225 4'), ftos(sz), '8 8 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
};

void(float num, vector org) ui_renderHardPointNumber={
  drawstring(org, ftos(num), gui_percentToPixelRawVec('12 10'), CLR_DEF_RET_HASLOCK, 1, 0);
};


void() ui_renderHUD_Highlight_frame={
  local entity boxes;
  boxes = findchainfloat( data_idx, -3 );
  while( boxes ){
    local entity rem;
    rem = boxes;
    boxes = boxes.chain;
    ui_renderHUDHighlight( rem );
    if( time > rem.drawme ){
      remove( rem );
    }
  }
};

void( entity box ) ui_renderHUDHighlight={
  local vector bx_pos, bx_sz, bx_clr, l1, l2, l3;
  local float x,y;
  
  x = (0.1/100) * VIEW_MAX_x;
  y = (0.1/100) * VIEW_MAX_y;
  bx_pos_x = VIEW_ORG_x + ( VIEW_MAX_x * box.origin_x );
  bx_pos_y = VIEW_ORG_y + ( VIEW_MAX_y * box.origin_y );      
  bx_sz_x = box.drawsize_x * VIEW_MAX_x;
  bx_sz_y = box.drawsize_y * VIEW_MAX_y;
  
  l1_x = bx_pos_x + x;
  l1_y = bx_pos_y + y;
  l2_x = l1_x + x;
  l2_y = l1_y + y;
  l3_x = l2_x + x;
  l3_y = l2_y + y;
  gui_DrawRect (bx_pos, bx_sz, '2 1', box.drawcolor1);
  gui_DrawRect (l1, bx_sz, '2 1', box.drawcolor1);
  gui_DrawRect (l2, bx_sz, '1 2', box.drawcolor1);
  gui_DrawRect (l3, bx_sz, '2 1', box.drawcolor1);
};