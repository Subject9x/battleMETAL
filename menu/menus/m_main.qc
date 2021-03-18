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

//Main Menu Globals
entity main_title;
entity main_label;
entity main_leave;
entity main_camp;
entity main_backto;
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
string IMG_MAIN_CAMP   = "gfx/menu/main/main_camp.png";
string IMG_MAIN_TRAIN  = "gfx/menu/main/main_train.png";
string IMG_MAIN_MULTI  = "gfx/menu/main/main_multi.png";
string IMG_MAIN_OPT    = "gfx/menu/main/main_opt.png";
string IMG_MAIN_HELP   = "gfx/menu/main/main_help.png";
string IMG_MAIN_CREDITS   = "gfx/menu/main/main_credits.png";
string IMG_MAIN_QUIT   = "gfx/menu/main/main_quit.png";

string IMG_MAIN_LEAVE = "gfx/menu/quit_mission.png";
string IMG_MAIN_EXIT = "gfx/menu/exit_game.png";

string IMG_TITLE;
string IMG_QUIT;

//Main callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_main_camp={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
};

void() click_main_train={
  cvar_set("cl_ismenu","0");
  cvar_set("skill", "1");
  cvar_set("sv_public", "-2");
  cvar_set("deathmatch", "0");
  cvar_set("coop", "0");
  cvar_set("teamplay", "0");
  cmd("maxplayers 1;\n");
  
  menu_clear_items(M_STATE);
  menu_exit_togame();
  
  cmd("map training_only\n");
};

void() click_main_multi={
  menu_clear_items(M_STATE);
  M_STATE = M_MULTI;
  m_multi_f();
};

void() click_main_quit={
  menu_clear_items(M_STATE);
  cmd("quit\n");
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
  cmd("maxplayers 1;\n");
  cmd("disconnect;map cin_menu;\n");
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
  local vector labelSize;
  local float mainTitleFlag;
  
  if( MAIN_MISSION ){
    IMG_TITLE = IMG_MAIN_PAUSE;
    labelSize = '160 24 0';
    mainTitleFlag = 0;
    main_player_options = btn_img_callback('10 132 0', '1 1 0', IMG_MULTI_PLAYERSETUP, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_player_setup, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    orgOptions = '10 151 0';
    orgHelp = '10 170 0';
    main_leave = btn_img_callback('10 189 0', '1 1 0', IMG_MAIN_LEAVE, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_leave, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    IMG_QUIT = IMG_MAIN_EXIT;
    orgQuit = '10 206 0';
  }
  else{
    IMG_TITLE = IMG_MAIN_LBL;
    labelSize = '1 1 0';
    mainTitleFlag = UI_FLAG_SIZE_IMG;
    main_title = lbl_img('10 50', '1 1 0', IMG_MAIN_TITLE, '1.5 0.75 0.35', (VIEW_CTX | VIEW_CTY), M_MAIN, 1, (UI_FLAG_SIZE_IMG) );
    main_camp = btn_img_callback('10 132 0', '1 1 0', IMG_MAIN_CAMP, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_camp, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_training = btn_img_callback('10 151 0', '1 1 0', IMG_MAIN_TRAIN, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_train, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_multi = btn_img_callback('10 170 0', '1 1 0', IMG_MAIN_MULTI, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_multi, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    
    orgOptions = '10 189 0';
    orgHelp = '10 209 0';
    
    main_credits = btn_img_callback('10 229 0', '1 1 0', IMG_MAIN_CREDITS, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_credits, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    IMG_QUIT = IMG_MAIN_QUIT;
    orgQuit = '10 249 0';
    
  }
  
  main_label = lbl_img('10 100', labelSize, IMG_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_MAIN, 1, mainTitleFlag );
  main_options = btn_img_callback(orgOptions, '1 1 0', IMG_MAIN_OPT, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_options, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_help = btn_img_callback(orgHelp, '1 1 0', IMG_MAIN_HELP, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_help, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_quit = btn_img_callback(orgQuit, '1 1 0', IMG_QUIT, (VIEW_CTX | VIEW_CTY), M_MAIN, click_main_quit, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
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
  //cons_logAFloat("m_main_k.key", key);  //DEBUG
  //cons_logAFloat("m_main_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      if(cvar("cl_ismenu") == FALSE ){
        menu_clear_items(M_STATE);
        menu_exit_togame();
      }
      break;
  }
};