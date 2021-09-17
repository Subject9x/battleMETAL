/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview: 
  multiplayer top menu
*/

//Multiplayer Globals
entity multi_title;
entity multi_playersetup;
entity multi_hostgame;
entity multi_joingame;
entity multi_back;

//MultiplayerConstants
string IMG_MULTI_TITLE   = "gfx/menu/multi/multi_title.png";

//Multiplayer callbacks
void() click_multi_back={
  menu_clear_items(M_STATE);
  m_main_f();
  localsound("sound/misc/menu2.wav");
};

void() click_multi_setup={
  menu_clear_items(M_STATE);
  m_setup_f();
};

void() click_multi_host={
  menu_clear_items(M_STATE);
  m_host_f();
};

void() click_multi_join={
  menu_clear_items(M_STATE);
  m_join_f();
};

// ini function, called by '_f' function as a setup func
void() m_multi_i={

  menu_parent_setup(VIEW_ORG + '0 70', '288 160');

  multi_title = lbl_img( MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_MULTI_TITLE, '1 1 1', VIEW_CTX , M_MULTI, 1, UI_FLAG_SIZE_IMG );
  
  multi_playersetup = btn_text_callback(MENU_ORG + menu_parent_center_width(45), '16 16', "PLAYER SETUP", VIEW_CTX, M_MULTI, click_multi_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  multi_playersetup.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  multi_hostgame = btn_text_callback(MENU_ORG + menu_parent_center_width(64), '16 16', "HOST GAME", VIEW_CTX, M_MULTI, click_multi_host, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0',1, UI_FLAG_SIZE_IMG);
  multi_hostgame.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  multi_joingame = btn_text_callback(MENU_ORG + menu_parent_center_width(83), '16 16', "JOIN GAME", VIEW_CTX, M_MULTI, click_multi_join, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  multi_joingame.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  multi_back = btn_text_callback(MENU_ORG + menu_parent_center_width(128), '16 16', "BACK", VIEW_CTX, M_MULTI, click_multi_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  multi_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_multi_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_MULTI;
  setkeydest(KEY_MENU);
  m_multi_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_multi_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_MULTI);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_multi_k={
  //cons_logAFloat("m_multi_k.key", key);  //DEBUG
  //cons_logAFloat("m_multi_k.ascii", ascii);  //DEBUG   
  
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