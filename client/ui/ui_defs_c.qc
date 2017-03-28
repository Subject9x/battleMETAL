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
  menu_navBar((VIEW_ORG+'2 12'));
  drawpic(mpos, "gfx/ui/ui_cursor.png",  i_sz, '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_navBar={
  local vector nvpos;
  nvpos = ofs + '10 8';
  
  gui_renderTintImage(MENU_BRIEF_ACTIVE, nvpos, UI_DEF_BOX_256, '96 24', CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  local vector tpos;
  tpos = nvpos;
  tpos_x = (nvpos_x + 48) - (stringwidth("[BRIEFING]", 0 ,'8 8 0')/2);
  tpos_y = (nvpos_y + 16) - 8;
  gui_renderHighlightString("[BRIEFING]", tpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', MENU_BRIEF_ACTIVE, '8 8 0', HUD_ALPHA, 0) ;
  
  gui_renderTintImage(MENU_HANGAR_ACTIVE, nvpos+'96 0', UI_DEF_BOX_256, '96 24', CLR_DEF_WEP_INRANGE, HUD_ALPHA, 0) ;
  local vector hpos;
  hpos = nvpos + '96 0';
  hpos_x = (hpos_x + 48) - (stringwidth("[HANGAR]", 0 ,'8 8 0')/2);
  hpos_y = (hpos_y + 16) - 8;
  gui_renderHighlightString("[HANGAR]", hpos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', MENU_HANGAR_ACTIVE, '8 8 0', HUD_ALPHA, 0) ;
  
  gui_DrawRect(VIEW_MAX - '88 24', '64 16', '6 4', '1 1 1');
  drawstring(VIEW_MAX - '88 24', "[ACCEPT]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void() menu_mainListener={
  navBarListener();
};

void() navBarListener={
  if(menu_checkMouseInBounds(cursorpos, '20 28', '94 24')){
    MENU_BRIEF_ACTIVE = TRUE;
    MENU_HANGAR_ACTIVE = FALSE;
  }
  else if(menu_checkMouseInBounds(cursorpos, '124 28', '94 24')){
    MENU_BRIEF_ACTIVE = FALSE;
    MENU_HANGAR_ACTIVE = TRUE;
  }
};