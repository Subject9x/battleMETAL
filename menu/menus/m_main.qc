/*
mech Mod
Author: Peter Roohr
Date: 4/11/2018
Overview: definition file for a menu ui
basically I'm mimicking the DP source architecture on this one cause there's no documentation
on how to use menu.dat. 
*/

//Main Menu Globals
entity main_title;
entity main_camp;
entity main_multi;
entity main_options;
entity main_help;
entity main_credits;
entity main_quit;

//Main Menu Constants
string IMG_MAIN_TITLE  = "gfx/menu/main_title.png";
string IMG_MAIN_CAMP   = "gfx/menu/main_camp.png";
string IMG_MAIN_MULTI  = "gfx/menu/main_multi.png";
string IMG_MAIN_OPT    = "gfx/menu/main_opt.png";
string IMG_MAIN_HELP    = "gfx/menu/main_help.png";
string IMG_MAIN_QUIT   = "gfx/menu/main_quit.png";

//Main callbacks
void() click_main_camp = {
  M_STATE = M_SINGLE;
  cons_logAFloat("click_main_camp->M_STATE", M_STATE);  //DEBUG
};

// ini functions
void() m_main_i={
  main_title = lbl_img('10 100', '1 1 0', IMG_MAIN_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_MAIN, 1, (UI_FLAG_SIZE_IMG) );
  main_camp = btn_img_callback('10 132 0', '1 1 0', IMG_MAIN_CAMP, "", (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_camp, '1 1 1', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_multi = btn_img_callback('10 151 0', '1 1 0', IMG_MAIN_MULTI, "", (VIEW_CTX | VIEW_CTY), M_MAIN, btn_noclick, '1 1 1', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_options = btn_img_callback('10 170 0', '1 1 0', IMG_MAIN_OPT, "", (VIEW_CTX | VIEW_CTY), M_MAIN, btn_noclick, '1 1 1', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_help = btn_img_callback('10 189 0', '1 1 0', IMG_MAIN_HELP, "", (VIEW_CTX | VIEW_CTY), M_MAIN, btn_noclick, '1 1 1', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_quit = btn_img_callback('10 208 0', '1 1 0', IMG_MAIN_QUIT, "", (VIEW_CTX | VIEW_CTY), M_MAIN, btn_noclick, '1 1 1', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_main_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_MAIN;
  setkeydest(KEY_MENU);
  m_main_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_main_d={

  local entity widget;
  widget = findchainfloat(menuId, M_MAIN);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_main_k={
  cons_logAFloat("m_main_k.key", key);  //DEBUG
  cons_logAFloat("m_main_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      DRAW_MOUSE = FALSE;
      M_STATE = M_NONE;
      setkeydest(KEY_GAME);
      break;
    case K_MOUSE1:
      MOUSE_TARGET.isclick(MOUSE_TARGET);
      break;
  }
};