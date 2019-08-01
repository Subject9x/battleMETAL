/*
battleMETAL
Author: Peter Roohr
Date: 4/17/2018
Overview: options root menu
*/

//options root Globals
entity options_title;
entity options_controls;
entity options_graphics;
entity options_audio;
entity options_gameplay;
entity options_back;

//options root Constants
string IMG_OPTION_TITLE = "gfx/menu/options/options_title.png";
string IMG_OPTION_CONTROLS = "gfx/menu/options/options_controls.png";
string IMG_OPTION_GRAPHICS = "gfx/menu/options/options_graphics.png";
string IMG_OPTION_AUDIO = "gfx/menu/options/options_audio.png";
string IMG_OPTION_GAMEPLAY = "gfx/menu/options/options_gameplay.png";

//options root callbacks
void() click_options_controls={
  menu_clear_items(M_STATE);
  m_controls_f();
};

void() click_options_graphics={
  menu_clear_items(M_STATE);
  m_graphics_f();
};

void() click_options_audio={
  menu_clear_items(M_STATE);
  m_audio_f();
};

void() click_options_gameplay={
  menu_clear_items(M_STATE);
  m_gameplay_f();
};

void() click_options_back={
  menu_clear_items(M_STATE);
  m_main_f();
};

// ini function, called by '_f' function as a setup func
void() m_options_i={
  options_title = lbl_img('10 100', '1 1 0', IMG_OPTION_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS, 1, (UI_FLAG_SIZE_IMG) );
  options_controls = btn_img_callback('10 132 0', '1 1 0', IMG_OPTION_CONTROLS, (VIEW_CTX | VIEW_CTY), M_OPTIONS, click_options_controls, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  options_graphics = btn_img_callback('10 151 0', '1 1 0', IMG_OPTION_GRAPHICS, (VIEW_CTX | VIEW_CTY), M_OPTIONS, click_options_graphics, '1 1 1', CLR_DEF_GREEN,1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  options_audio = btn_img_callback('10 170 0', '1 1 0', IMG_OPTION_AUDIO, (VIEW_CTX | VIEW_CTY), M_OPTIONS, click_options_audio, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  options_gameplay = btn_img_callback('10 189 0', '1 1 0', IMG_OPTION_GAMEPLAY, (VIEW_CTX | VIEW_CTY), M_OPTIONS, click_options_gameplay, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  options_back = btn_img_callback('10 230 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_OPTIONS, click_options_back, '1 1 1',CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_options_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS;
  setkeydest(KEY_MENU);
  m_options_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_options_d={
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_options_k={
  //cons_logAFloat("m_join_k.key", key);  //DEBUG
  //cons_logAFloat("m_join_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};