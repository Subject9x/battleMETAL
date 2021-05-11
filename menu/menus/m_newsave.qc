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
  
  newsave_title = lbl_img('10 100', '1 1 0', IMG_NEWSAVE_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_NEWSAVE, 1, (UI_FLAG_SIZE_IMG) );
  newsave_back = btn_img_callback('10 155 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_NEWSAVE, click_newsave_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  start = '10 172';
  
  itr = 0;
  actual = 0;
  
  while (itr < GAME_SAVES_MAX ){
    next = start;
    next_y = next_y + (itr * 20);
    
    if( GAME_SAVES_DRAWNAME[itr] == "" ){
      name = "- NEW SAVE SLOT -";
    }
    else{
      name = GAME_SAVES_DRAWNAME[itr];
    }
    
    list = btn_text_callback(next, '14 14 0', name, 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    list.data_bind = itr; //databind
    itr = itr + 1;
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
  local entity widget;

  gui_renderString("Clicking a SaveSlot will OVERRIDE that save.", gui_percentToPixelRawVec('10 138'), CLR_DEF_WHITE, '14 14 0', 1, 0);

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
