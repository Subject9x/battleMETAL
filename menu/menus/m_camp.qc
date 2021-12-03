/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview: singleplayer menu
*/

//Main Menu Globals
entity camp_title;
entity camp_new;
entity camp_load;
//entity camp_save;
entity camp_back;

//Main Menu Constants
string IMG_CAMP_TITLE   = "gfx/menu/single/camp_label.png";

//button callbacks
void() click_camp_new ={
  menu_clear_items(M_STATE);
  m_newsave_f();
};

void() click_camp_load = {
  menu_clear_items(M_STATE);
  m_load_f();
};

/*void() click_camp_save={
  menu_clear_items(M_STATE);
  m_save_f();
};*/

void() click_camp_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};


// ini function, called by '_f' function as a setup func
void() m_camp_i={
  
  menu_parent_setup(VIEW_ORG + '0 80', '208 224');
  
  campaign_loadfiles();
  
  camp_title = lbl_img( MENU_ORG + menu_parent_center_width(10), '1 1 0', IMG_CAMP_TITLE, '1 1 1', VIEW_CTX, M_SINGLE, 1, UI_FLAG_SIZE_IMG );
  
  camp_new = btn_text_callback(MENU_ORG + menu_parent_center_width(52), '16 16', "NEW GAME", VIEW_CTX, M_SINGLE, click_camp_new, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  camp_new.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  camp_load = btn_text_callback(MENU_ORG + menu_parent_center_width(71), '16 16', "LOAD", VIEW_CTX, M_SINGLE, click_camp_load, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0',1,  UI_FLAG_SIZE_IMG);
  camp_load.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  camp_back = btn_text_callback(MENU_ORG + menu_parent_center_width(109), '16 16', "BACK", VIEW_CTX, M_SINGLE, click_camp_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  camp_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_camp_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_SINGLE;
  setkeydest(KEY_MENU);
  m_camp_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_camp_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_SINGLE);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_camp_k={
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