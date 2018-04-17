/*
mech Mod
Author: Peter Roohr
Date: 4/14/2018
Overview: multiplayer top menu
*/

//Multiplayer Globals
entity multi_title;
entity multi_playersetup;
entity multi_hostgame;
entity multi_joingame;
entity multi_back;

//MultiplayerConstants
string IMG_MULTI_TITLE   = "gfx/menu/multi/multi_title.png";
string IMG_MULTI_PLAYERSETUP   = "gfx/menu/multi/multi_playersetup.png";
string IMG_MULTI_HOSTGAME   = "gfx/menu/multi/multi_hostgame.png";
string IMG_MULTI_JOINGAME   = "gfx/menu/multi/multi_joingame.png";

//Multiplayer callbacks
void() click_multi_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  localsound("sound/misc/menu2.wav");
};

void() click_multi_setup={
  menu_clear_items(M_STATE);
  M_STATE = M_SETUP;
  m_setup_f();
};

void() click_multi_host={
  menu_clear_items(M_STATE);
  M_STATE = M_HOST;
  m_host_f();
};

void() click_multi_join={
  menu_clear_items(M_STATE);
  M_STATE = M_JOIN;
  m_join_f();
};

// ini function, called by '_f' function as a setup func
void() m_multi_i={
  multi_title = lbl_img('10 100', '1 1 0', IMG_MULTI_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_MULTI, 1, (UI_FLAG_SIZE_IMG) );
  multi_playersetup = btn_img_callback('10 132 0', '1 1 0', IMG_MULTI_PLAYERSETUP, (VIEW_CTX | VIEW_CTY), M_MULTI, click_multi_setup, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  multi_hostgame = btn_img_callback('10 151 0', '1 1 0', IMG_MULTI_HOSTGAME, (VIEW_CTX | VIEW_CTY), M_MULTI, click_multi_host, '1 1 1', '0 1 0',1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  multi_joingame = btn_img_callback('10 170 0', '1 1 0', IMG_MULTI_JOINGAME, (VIEW_CTX | VIEW_CTY), M_MULTI, click_multi_join, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  multi_back = btn_img_callback('10 230 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_MULTI, click_multi_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
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
  cons_logAFloat("m_multi_k.key", key);  //DEBUG
  cons_logAFloat("m_multi_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      //note how this is different than m_main_k, here we just want to go 'up' one
      //menu and not leave the menu system
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      break;
    case K_MOUSE1:
      m_sys_doclick();
      break;
  }
};