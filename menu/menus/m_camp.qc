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
entity camp_save;
entity camp_back;

//Main Menu Constants
string IMG_CAMP_TITLE   = "gfx/menu/single/camp_label.png";
string IMG_CAMP_NEW     = "gfx/menu/single/camp_new.png";
string IMG_CAMP_LOAD    = "gfx/menu/single/camp_load.png";
string IMG_CAMP_SAVE    = "gfx/menu/save_btn.png";

//button callbacks
void() click_camp_new ={
  menu_clear_items(M_STATE);
  m_newg_f();
};

void() click_camp_load = {
  menu_clear_items(M_STATE);
  m_load_f();
};

void() click_camp_save={
  menu_clear_items(M_STATE);
  m_save_f();
};

void() click_camp_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};


// ini function, called by '_f' function as a setup func
void() m_camp_i={
  camp_title = lbl_img('10 100', '1 1 0', IMG_CAMP_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_SINGLE, 1, (UI_FLAG_SIZE_IMG) );
  camp_new = btn_img_callback('10 132', '1 1 0', IMG_CAMP_NEW, (VIEW_CTX | VIEW_CTY), M_SINGLE, click_camp_new, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  camp_load = btn_img_callback('10 151', '1 1 0', IMG_CAMP_LOAD, (VIEW_CTX | VIEW_CTY), M_SINGLE, click_camp_load, '1 1 1', '0 1 0',1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  camp_save = btn_img_callback('10 174', '1 1 0', IMG_CAMP_SAVE, (VIEW_CTX | VIEW_CTY), M_SINGLE, click_camp_save, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  
  if( isdemo() || (clientstate() != CS_CONNECTED) ){
    camp_save.drawme = FALSE;
  }
  
  camp_back = btn_img_callback('10 200', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_SINGLE, click_camp_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
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