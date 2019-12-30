/*
battleMETAL
Author: Peter Roohr
Date: 12/20/2019
Overview: 
  Help Menu file
    + getting started
    + options
    + UI explain
      -> Briefing
      -> Hangar
      -> Arming
      -> Deployment
    + 
*/

//m_help GLOBALS
entity help_back;
entity help_starting;
entity help_options;
entity help_menus_briefing;
entity help_menus_hangar;
entity help_menus_arming;
entity help_menus_deploy;

float HELP_MENU_CHOICE;

//m_help CONSTANTS
float HELP_MENU_BRIEF = 1;
float HELP_MENU_HANGAR = 2;
float HELP_MENU_ARMING = 3;
float HELP_MENU_DEPLOY = 4;

//m_help functions
void() click_help_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};

//api

void() m_help_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_HELP;
  setkeydest(KEY_MENU);
  m_help_i();
};

void() m_help_i={
  help_back = btn_img_callback('10 138 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_HELP, click_help_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

void() m_help_d={
  local entity widget;
  for( widget = findchainfloat(menuId, M_HELP); widget != null_entity; widget = widget.chain){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }
    else if( widget.subid == HELP_MENU_CHOICE){
      widget.draw(widget);
    }
  }
};

void(float key, float ascii) m_help_k={
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};