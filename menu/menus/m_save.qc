/*
battleMETAL
Author: Peter Roohr
Date: 4/25/2018
Overview: save campaign menu
*/

//save menu Globals
entity save_title;
entity save_back;
entity save_list;

//save menu Constants
string IMG_SAVE_TITLE   = "gfx/menu/save/save_title.png";

//button callbacks
void() click_save_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
  localsound("sound/misc/menu2.wav");
};

void() click_save_savegame={
  cvar_set("saveslot", ftos(self.data_bind));
  localcmd("savegame", "\n");
  menu_scan_saves();  //update's save-game list
  menu_clear_items(M_STATE);
  menu_exit_togame();
};

// ini function, called by '_f' function as a setup func
void() m_save_i={
  local vector start;
  local float itr;
  local string name;
  local entity list;
  local vector next;
    
  save_title = lbl_img('10 100', '1 1 0', IMG_SAVE_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_SAVE, 1, (UI_FLAG_SIZE_IMG) );
  save_back = btn_text_callback('10 132 0', '16 16', "BACK", 0, M_SAVE, click_load_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  save_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  start = '10 150';
  
  itr = 0;
  
  if(GAME_SAVES_DRAWNAME[itr] == ""){
    name = "--[ NEW SAVE SLOT ]--";
  }
  else{
    name = GAME_SAVES_DRAWNAME[itr];
  }
  save_list = btn_text_callback(start,'8 8 0', name, 0, M_SAVE, click_save_savegame, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  save_list.data_bind = itr; //databind
  itr = itr + 1;
  while (itr < GAME_SAVES_MAX ){
    if(GAME_SAVES_DRAWNAME[itr] == ""){
      name = "--[ NEW SAVE SLOT ]--";
    }
    else{
      name = GAME_SAVES_DRAWNAME[itr];
    }
    next = start;
    next_y = next_y + (itr * 10);
    list = btn_text_callback(next, '8 8 0', name, 0, M_SAVE, click_save_savegame, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    list.data_bind = itr; //databind
    itr = itr + 1;
  }
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_save_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_SAVE;
  setkeydest(KEY_MENU);
  menu_scan_saves();
  m_save_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_save_d={
  local entity widget;
  widget = findchainfloat(menuId, M_SAVE);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_save_k={
  //cons_logAFloat("m_save_k.key", key);  //DEBUG
  //cons_logAFloat("m_save_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};