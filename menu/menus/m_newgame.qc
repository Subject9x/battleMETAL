/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
  menu definition file
  NEW GAME MENU
*/

//Main Menu Globals
entity new_title;
entity new_novice;
entity new_regular;
entity new_veteran;
entity new_elite;
entity new_back;

//Main Menu Constants
string IMG_NEW_TITLE  = "gfx/menu/newgame/new_title.png";
string IMG_NEW_NOVICE  = "gfx/menu/newgame/new_novice.png";
string IMG_NEW_REGULAR  = "gfx/menu/newgame/new_regular.png";
string IMG_NEW_VETERAN = "gfx/menu/newgame/new_veteran.png";
string IMG_NEW_ELITE  = "gfx/menu/newgame/new_elite.png";

//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_newg_back={
  menu_clear_items(M_STATE);
  m_camp_f();
  localsound("sound/misc/menu2.wav");
};

void() click_newg_launch={
  menu_clear_items(M_STATE);
  cmd("deathmatch 0\n");
  cmd("coop 0\n");
  cmd("cd stop\n");
  menu_exit_togame();
  cmd("map", " o1m1\n");
};

void() click_newg_novice={
  cvar_set("skill", "0");
  click_newg_launch();
};

void() click_newg_regular={
  cvar_set("skill", "1");
  click_newg_launch();
};

void() click_newg_veteran={
  cvar_set("skill", "2");
  click_newg_launch();
};

void() click_newg_elite={
  cvar_set("skill", "3");
  click_newg_launch();
};

// ini functions
void() m_newg_i={
  new_title = lbl_img('10 100', '1 1 0', IMG_NEW_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_NEWGAME, 1, (UI_FLAG_SIZE_IMG) );
  new_novice = btn_img_callback('10 132 0', '1 1 0', IMG_NEW_NOVICE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_novice, '1 1 1', CLR_DEF_BLUE, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_regular = btn_img_callback('10 151 0', '1 1 0', IMG_NEW_REGULAR, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_regular, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_veteran = btn_img_callback('10 170 0', '1 1 0', IMG_NEW_VETERAN, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_veteran, '1 1 1', CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_elite = btn_img_callback('10 189 0', '1 1 0', IMG_NEW_ELITE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_elite, '1 1 1', CLR_DEF_RED, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_back = btn_img_callback('10 230 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_newg_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_NEWGAME;
  setkeydest(KEY_MENU);
  m_newg_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_newg_d={

  local entity widget;
  widget = findchainfloat(menuId, M_NEWGAME);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_newg_k={
  //cons_logAFloat("m_newg_k.key", key);  //DEBUG
  //cons_logAFloat("m_newg_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};