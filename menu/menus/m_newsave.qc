/*
battleMETAL
Author: Peter Roohr
Date: 12/19/2019
Overview: new campaign, pick save slot
*/

//New Game Save Slot globals
string IMG_NEWSAVE_TITLE  = "gfx/menu/newgame/new_title.png";
entity newsave_title;
entity newsave_back;

//button callbacks

void() click_newsave_back={
  localsound("sound/misc/menu2.wav");
  cvar_set("cl_newgameplus", "0");
  menu_clear_items(M_STATE);
  m_camp_f();
};

void() click_saveslot={
  cvar_set("saveslot", ftos(self.data_bind));
  menu_clear_items(M_STATE);
  m_newg_f();
};

void() m_newsave_i={
  local vector start;
  local float itr;
  local float actual;
  local entity list;
  local vector next;
  local string name;
  local vector backOrg;
  
  menu_parent_setup(VIEW_ORG + '0 70', '346 304');
  
  newsave_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_NEWSAVE_TITLE, '1 1 1', VIEW_CTX, M_NEWSAVE, 1, UI_FLAG_SIZE_IMG );
  
  start = MENU_ORG + '10 65';
  
  itr = 0;
  actual = 0;
  
  while (itr < GAME_SAVES_MAX ){
    next = start;
    next_x = next_x + 16;
    next_y = next_y + (itr * 20);
    
    if( GAME_SAVES_DRAWNAME[itr] == "" ){
      name = "- NEW SAVE SLOT -";
      list = btn_text_callback(next, '14 14', name, 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
      list.fontId = FONT_NUM_ROBOT_LIGHT;
    }
    else{
      name = GAME_SAVES_DRAWNAME[itr];
      list = btn_text_callback(next, '14 14', name, 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_SIZE_IMG);
      list.fontId = FONT_NUM_XOLONIUM_BOLD;
    }
    
    list.data_bind = itr; //databind
    itr = itr + 1;
  }
  backOrg = MENU_ORG + '40 0';
  backOrg_y = next_y + 36;
  newsave_back = btn_text_callback(backOrg, '16 16', "BACK", VIEW_CTX, M_NEWSAVE, click_newsave_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  newsave_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

void() m_newsave_f={
  DRAW_MOUSE = true;
  M_STATE = M_NEWSAVE;
  setkeydest(KEY_MENU);
  menu_scan_saves();
  m_newsave_i();
};

void() m_newsave_d={
  local entity widget;

  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);

  gui_renderString("Clicking a SaveSlot will OVERRIDE that save.", MENU_ORG + '10 45', CLR_DEF_ARM_THREEQ, '14 14 0', 1, 0);

  widget = findchainfloat(menuId, M_NEWSAVE);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

void(float ky, float ascii) m_newsave_k={
  switch(ky){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};
