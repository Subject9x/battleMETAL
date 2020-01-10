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
  menu_clear_items(M_STATE);
  m_main_f();
  localsound("sound/misc/menu2.wav");
};

void() click_saveslot={
  menu_clear_items(M_STATE);
  m_newg_f();
  cvar_set("saveslot", ftos(self.data_bind));
};

void() m_newsave_i={
  newsave_title = lbl_img('10 100', '1 1 0', IMG_NEWSAVE_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_NEWSAVE, 1, (UI_FLAG_SIZE_IMG) );
  newsave_back = btn_img_callback('10 155 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_NEWSAVE, click_newsave_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  local vector start;
  start = '10 172';
  
  local float itr;
  local float actual;
  itr = 0;
  actual = 0;
  
  if(GAME_SAVES[itr] != ""){
    while (itr < GAME_SAVES_MAX ){
      local entity list;
      local vector next;
      next = start;
      next_y = next_y + (itr * 20);
      list = btn_text_callback(next, '14 14 0', GAME_SAVES_DRAWNAME[itr], 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
      list.data_bind = itr; //databind
      itr = itr + 1;
    }
  }
};

void() m_newsave_f={
  DRAW_MOUSE = true;
  M_STATE = M_NEWSAVE;
  setkeydest(KEY_MENU);
  menu_scan_saves();
  m_newsave_i();
};

void() m_newsave_d={

  gui_renderString("Clicking a SaveSlot will OVERRIDE that save.", gui_percentToPixelRawVec('10 138'), CLR_DEF_WHITE, '14 14 0', 1, 0);

  local entity widget;
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
