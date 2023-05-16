/*
battleMETAL
Author: Peter Roohr
Date: 5/15/2023
Overview: wiki menu
*/

//Main Menu Globals
entity wiki_title;
entity wiki_back;

//Main Menu Constants

//button callbacks
void() click_wiki_new ={
  menu_clear_items(M_STATE);
  m_newsave_f();
};

void() click_wiki_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};


// ini function, called by '_f' function as a setup func
void() m_wiki_i={
  
  menu_parent_setup(VIEW_ORG + '0 80', '208 224');
  
  wiki_title = lbl_text(MENU_ORG + menu_parent_center_width(10), '14 14 0', "ARCHIVES", CLR_DEF_TXT_CANTSELECT, 0, M_WIKI, 1, 0) ;
  
  wiki_back = btn_text_callback(MENU_ORG + menu_parent_center_width(109), '16 16', "BACK", VIEW_CTX, M_WIKI, click_wiki_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  wiki_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_wiki_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_WIKI;
  setkeydest(KEY_MENU);
  m_camp_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_wiki_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_WIKI);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_wiki_k={
  //cons_logAFloat("m_camp_k.key", key);  //DEBUG
  //cons_logAFloat("m_camp_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      //note how this is different than m_main_k, here we just want to go 'up' one
      //menu and not leave the menu system
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_main_f();
      break;
  }
};