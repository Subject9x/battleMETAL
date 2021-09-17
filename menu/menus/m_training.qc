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
  localcmd("deathmatch 0\n");
  localcmd("teamplay 0\n");
  localcmd("coop 0\n");
  localcmd("cd stop\n");
  localcmd("maxplayers 1\n");
  localcmd(strcat("map ", mapName,"\n")); 
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
  
  menu_parent_setup(VIEW_ORG + '0 96', '272 256');
  
  train_title = lbl_text(MENU_ORG + menu_parent_center_width(5), '16 16', "TUTORIALS", '1 1 1', VIEW_CTX, M_TRAINING, 1, UI_FLAG_SIZE_IMG);
  
  train_move_btn = btn_text_callback(MENU_ORG + menu_parent_center_width(125), '16 16', ">Movement<", VIEW_CTX, M_TRAINING, click_train_move, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  train_move_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  train_shoot_btn = btn_text_callback(MENU_ORG + menu_parent_center_width(150), '16 16', ">Shooting<", VIEW_CTX, M_TRAINING, click_train_shoot, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  train_shoot_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  train_brieft_btn = btn_text_callback(MENU_ORG + menu_parent_center_width(175), '16 16', ">Briefing and Arming<", VIEW_CTX, M_TRAINING, click_train_brief, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  train_brieft_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  train_back_btn = btn_text_callback(MENU_ORG + '40 225', '16 16', "BACK", VIEW_CTX, M_TRAINING, click_train_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  train_back_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
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
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_TRAINING);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    gui_wrapText(MENU_ORG + '20 45', '265 300', "The following maps are tutorials to teach you how to play battleMETAL. It is STRONGLY recommended that you play these tutorials before your first time playing the main campaign.", '14 14', '1 1 0.1', 1);
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