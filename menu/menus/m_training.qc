/*
battleMETAL
Author: Peter Roohr
Date: 5/22/2021
Overview: training menu
*/

//Training Menu globals
entity train_title;
entity train_move_btn;
entity train_shoot_btn;
entity train_brieft_btn;

entity train_back_btn;

//funcs
void( string mapName ) train_click_launch={
  menu_clear_items(M_STATE);
  menu_exit_togame();
  cmd("deathmatch 0\n");
  cmd("teamplay 0\n");
  cmd("coop 0\n");
  cmd("cd stop\n");
  cmd("maxplayers 1\n");
  cvar_set("cl_ismenu","0");
  cmd(strcat("map ", mapName,"\n")); 
};

void() click_train_back={
  menu_clear_items(M_STATE);
  m_main_f();
  localsound("sound/misc/menu2.wav");
};


//callbacks
void() click_train_move={
  train_click_launch( "training_move" );
};

void() click_train_shoot={

  train_click_launch( "training_shoot" );
};

void() click_train_brief={

  train_click_launch( "train1" );
};

// ini function, called by '_f' function as a setup func
void() m_train_i={
  train_title = lbl_text('10 100 0', '16 16 0', "TUTORIALS", '1 1 1', (VIEW_LFT | VIEW_TOP), M_TRAINING, 1, 0);
  
  train_move_btn = btn_text_callback('10 189', '14 14 0', "Movement", 0, M_TRAINING, click_train_move, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  train_shoot_btn = btn_text_callback('10 208', '14 14 0', "Shooting", 0, M_TRAINING, click_train_shoot, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  train_brieft_btn = btn_text_callback('10 227', '14 14 0', "Briefing and Arming", 0, M_TRAINING, click_train_brief, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  
  train_back_btn = btn_img_callback('10 265', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_TRAINING, click_train_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG)); 
};


/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_train_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_TRAINING;
  setkeydest(KEY_MENU);
  m_train_i();
};


/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_train_d={
  local entity widget;
  widget = findchainfloat(menuId, M_TRAINING);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    gui_wrapText(gui_percentToPixelRawVec('10 132 0'), gui_percentToPixelRawVec('500 300 0'), "The following maps are tutorials to teach you how to play battleMETAL. It is STRONGLY recommended that you play these tutorials before your first time playing the main campaign.", '14 14', '1 1 0.1', 1);
  drawfont = drawfont_prev;
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_train_k={
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