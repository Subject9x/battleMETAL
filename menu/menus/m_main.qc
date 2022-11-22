/*
battleMETAL
Author: Peter Roohr
Date: 4/11/2018
mod: 07/30/2019
Overview: 
  definition file for a menu ui.
  
  basically I'm mimicking the DP source architecture on this one cause there's no documentation
on how to use menu.dat. 
*/


entity main_title;
entity main_label;
entity main_leave;
entity main_camp;
entity main_training;
entity main_options;
entity main_multi;
entity main_help;
entity main_credits;
entity main_quit;

entity main_player_options; //link to player options during network play

//Main Menu Constants
string IMG_MULTI_PLAYERSETUP   = "gfx/menu/multi/multi_playersetup.png";
string IMG_MAIN_TITLE  = "gfx/menu/main/main_title.png";
string IMG_MAIN_PAUSE  = "gfx/pause.png";
string IMG_MAIN_LBL    = "gfx/menu/main/main_label.png";

string IMG_MAIN_LEAVE = "gfx/menu/quit_mission.png";

string IMG_TITLE;
//string IMG_QUIT;

//Main callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_main_camp={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
};

void() click_main_train={
  menu_clear_items(M_STATE);
  M_STATE = M_TRAINING;
  m_train_f();
};

void() click_main_multi={
  menu_clear_items(M_STATE);
  M_STATE = M_MULTI;
  m_multi_f();
};

void() click_main_quit={
  menu_clear_items(M_STATE);
  localcmd("quit\n");
};

void() click_main_options={
  menu_clear_items(M_STATE);
  M_STATE = M_OPTIONS;
  m_options_f();
};

void() click_main_help={
  menu_clear_items(M_STATE);
  M_STATE = M_HELP;
  m_help_f();
};

void() click_main_credits={
  menu_clear_items(M_STATE);
  M_STATE = M_CREDITS;
  m_credits_f();
};

void() click_main_leave={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  MAIN_MISSION = FALSE;
  m_main_f();
  cvar_set("sv_public", "-2");
  cvar_set("deathmatch", "0");
  cvar_set("teamplay", "0");
  cvar_set("coop", "0");
  cvar_set("sv_serverflags", "0");  //accounts for player-hosted servers rather than using dedicated hosting.
  localcmd("maxplayers 1;\n");
  localcmd("disconnect;\n");
  localcmd("togglemenu;\n");
  localcmd("cd play 2;\n");
  cvar_set("cl_newgameplus", "0");
};

void() click_main_player_setup={
  menu_clear_items(M_STATE);
  m_setup_f();
};

// ini functions
void() m_main_i={
  local vector orgOptions;
  local vector orgHelp;
  local vector orgQuit;
  local float mainTitleFlag;
  
  if( VIEW_ACT == '0 0 0'){
    VIEW_ACT = [cvar("vid_width"), cvar("vid_height"), 0];
  }
  gui_set_screen_size(VIEW_ACT_x, VIEW_ACT_y);  //ugh
  
  if( MAIN_MISSION ){
    menu_parent_setup(VIEW_ORG + '0 80', '208 192');
    
    IMG_TITLE = IMG_MAIN_PAUSE;
    mainTitleFlag = UI_FLAG_SIZE_IMG;
    
    main_label = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1', IMG_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, mainTitleFlag );
    
    main_player_options = btn_text_callback(MENU_ORG + menu_parent_center_width(45), '16 16', "PLAYER SETUP", VIEW_CTX, M_MAIN, click_main_player_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_player_options.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    orgOptions = MENU_ORG + menu_parent_center_width(64);
    
    orgHelp = MENU_ORG + menu_parent_center_width(83);
    
    main_leave = btn_text_callback(MENU_ORG + menu_parent_center_width(121), '16 16', "LEAVE", VIEW_CTX, M_MAIN, click_main_leave, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_leave.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    orgQuit = MENU_ORG + menu_parent_center_width(159);
  }
  else{
    menu_parent_setup(VIEW_ORG + '0 40', '208 256');
    
    IMG_TITLE = IMG_MAIN_LBL;
    mainTitleFlag = UI_FLAG_SIZE_IMG;
    main_title = lbl_img(MENU_ORG + menu_parent_center_width(10), '1 1 0', IMG_MAIN_TITLE, '1.5 0.75 0.35', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG );
    
    main_label = lbl_img(MENU_ORG + menu_parent_center_width(60), '1 1', IMG_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, mainTitleFlag );
    
    main_training = btn_text_callback(MENU_ORG + menu_parent_center_width(92), '16 16', "TRAINING", VIEW_CTX, M_MAIN, click_main_train, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_training.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    main_camp = btn_text_callback(MENU_ORG + menu_parent_center_width(111), '16 16', "CAMPAIGN", VIEW_CTX, M_MAIN, click_main_camp, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_camp.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    main_multi = btn_text_callback(MENU_ORG + menu_parent_center_width(130), '16 16', "MULTIPLAYER", VIEW_CTX, M_MAIN, click_main_multi, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_multi.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    orgOptions = MENU_ORG + menu_parent_center_width(149);
    orgHelp = MENU_ORG + menu_parent_center_width(169);
    
    main_credits = btn_text_callback(MENU_ORG + menu_parent_center_width(189), '16 16', "CREDITS", VIEW_CTX, M_MAIN, click_main_credits, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_credits.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    orgQuit = MENU_ORG + menu_parent_center_width(209);
    
  }
  
  
  main_options = btn_text_callback(orgOptions, '16 16', "OPTIONS", VIEW_CTX, M_MAIN, click_main_options, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_options.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  main_help = btn_text_callback(orgHelp, '16 16', "HELP", VIEW_CTX, M_MAIN, click_main_help, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_help.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  main_quit = btn_text_callback(orgQuit, '16 16', "QUIT", VIEW_CTX, M_MAIN, click_main_quit, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_quit.fontId = FONT_NUM_XOLONIUM_BOLD;
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
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
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
  //cons_logAFloat("m_main_k.key", key);  //DEBUG
  //cons_logAFloat("m_main_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      menu_clear_items(M_STATE);
      menu_exit_togame();
      break;
  }
};