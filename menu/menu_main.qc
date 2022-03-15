/*
  author: Peter Roohr
  date: 11/26/2017
      mod - 04/11/2018
  
  overview: what is a menu.dat? time to explore and find out
  comparing to darkplaces c-code was fun :|
  I have it somewhat documented now
*/

/*
  Quake C api hook - initialize menu here
*/
void() m_init={
  dynamic_precache();
  
  localcmd("disconnect;togglemenu;cd play 2;\n");
  registercvar("gamemode", "0", CF_CLIENT | CF_SERVER | CF_CLIENT_FROM_SERVER | CF_SERVER_FROM_CLIENT);
  registercvar("saveslot", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_hud_alpha", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_hud_color", "0", CF_CLIENT | CF_ARCHIVE);
  //registercvar("cl_hud_sway", "0", 1);
  registercvar("cl_team", "1", CF_CLIENT);
  registercvar("sv_serverflags", "0", CF_SERVER);
  
  registercvar("cl_net_fav1", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_net_fav2", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_net_fav3", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_net_fav4", "0", CF_CLIENT | CF_ARCHIVE);
  
  //registercvar("cl_color_mil", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  //registercvar("cl_color_srv", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  //registercvar("cl_color_psc", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  
  registercvar("cl_newgameplus","0", CF_CLIENT | CF_ARCHIVE);
  
  cvar_set("r_framedatasize", "16");  //FIXME - issue in engine
  
  
  ui_colors_set_player_list();
  menu_setup_mainservers();
  
  VIEW_SCALE = 0.35;
  if(clientstate() == CS_DISCONNECTED){
    m_toggle(1);
  }
  MOUSE_TARGET = null_entity;
  TEXTFIELD_TARGET = null_entity;
  KEYBIND_TARGET = null_entity;
  UI_INPUT_ACTIVE = FALSE;
  UI_KEYBIND_ACTIVE = FALSE;
  SUB_MENU = FALSE;
    
  FONT_NUM_ROBOT_LIGHT = loadfont("Roboto_Light", "gfx/fonts/Roboto_Light", "8 12 16 32", FONT_USER, FALSE, FALSE);
  FONT_NUM_ROBOT_THIN = loadfont("Roboto_Thin", "gfx/fonts/Roboto_Thin", "8 12 16 32", FONT_USER1, FALSE, FALSE);
  FONT_NUM_ROBOT_REGULAR = loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "8 12 16 32", FONT_USER2, FALSE, FALSE);
  FONT_NUM_ROBOT_MEDIUM = loadfont("Roboto_Medium", "gfx/fonts/Roboto_Medium", "8 12 16 32", FONT_USER3, FALSE, FALSE);
  loadfont("Roboto-Light", "gfx/fonts/Roboto_Light", "6 8 10 12 16", FONT_DEFAULT, FALSE, FALSE);
  loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "6 8 10 12 16", FONT_CONSOLE, FALSE, FALSE);
  FONT_NUM_DYSTOPIAN = loadfont("Dystopian_Future", "gfx/fonts/Dystopian_Future", "6 8 10 12 16", FONT_USER4, FALSE, FALSE);
  FONT_NUM_XOLONIUM_BOLD = loadfont("Xolonium Bold", "gfx/fonts/Xolonium-Bold", "10 12 16 24 32", FONT_USER5, FALSE, FALSE);
  
  menu_ini_ratelist();
  
  //setup textfield key filter;
  menu_ini_txtfilter();
  RESO_CHANGE = TRUE;
  
};

/*
  Quake C api hook -  function for when a key is pressed
*/
void(float keynr, float ascii) m_keydown={
  //intercept keyinput to populate textfield
  if(UI_INPUT_ACTIVE){
    menu_do_textfield(keynr, ascii);
    return;
  }
  if(UI_KEYBIND_ACTIVE){
    menu_do_keybind(keynr, ascii);
    return;
  }
  switch(M_STATE){
    case M_MAIN:
      m_main_k(keynr, ascii);
      break;
    case M_SINGLE:
      m_camp_k(keynr, ascii);
      break;
    case M_LOAD:
      m_load_k(keynr, ascii);
      break;
    case M_SAVE:
      m_save_k(keynr, ascii);
      break;
    case M_NEWGAME:
      m_newg_k(keynr, ascii);
      break;
    case M_MULTI:
      m_multi_k(keynr, ascii);
      break;
    case M_SETUP:
      m_setup_k(keynr, ascii);
      break;
    case M_HOST:
      m_host_k(keynr, ascii);
      break;
    case M_JOIN:
      m_join_k(keynr, ascii);
      break;
    case M_OPTIONS:
      m_options_k(keynr, ascii);
      break;
    case M_OPTIONS_CONTROLS:
      m_controls_k(keynr, ascii);
      break;
    case M_OPTIONS_GRAPHICS:
      m_graphics_k(keynr, ascii);
      break;
    case M_OPTIONS_EFFECT:
      m_effects_k(keynr, ascii);
      break;
    case M_OPTIONS_GFX:
      m_gfx_k(keynr, ascii);
      break;
    case M_OPTIONS_AUDIO:
      m_audio_k(keynr, ascii);
      break;
    case M_OPTIONS_GAMEPLAY:
      m_gameplay_k(keynr, ascii);
      break;
    case M_CREDITS:
      m_credits_k(keynr, ascii);
      break;
    case M_NEWSAVE:
      m_newsave_k(keynr, ascii);
      break;
    case M_HELP:
      m_help_k(keynr, ascii);
      break;
    case M_TRAINING:
      m_train_k(keynr, ascii);
      break;
  }
  if(keynr == K_MOUSE1){
    MOUSE_DOWN = TRUE;
    m_sys_doclick();
  }
};

/*
  Quake C api hook - function for when a key is RELEASED
*/
void(float keynr, float ascii) m_keyup={
  if(keynr == K_MOUSE1){
    MOUSE_DOWN_COUNT = 0;
    //mouse1 unpressed
    MOUSE_DOWN = FALSE;
  }
};

/*
  Quake C api hook - the primary render function, stuff all menu draw calls here
*/
void(float width, float height) m_draw={
  local vector bimg;
  
  VIEW_MPOS = getmousepos();
  
  if( getkeydest() == KEY_MENU ){
    if(RESO_CHANGE){
      RESO_CHANGE = FALSE;
      VIEW_ACT_x = width;
      VIEW_ACT_y = height;
      VIEW_ACT_z = cvar("vid_pixelheight");
      gui_set_screen_size(VIEW_ACT_x, VIEW_ACT_y);
    }
    if(MAIN_MISSION){
      drawfill(VIEW_ORG, VIEW_MAX, '0.1 0.1 0.1', 0.75, 0);
    }
    
    
    if( clientstate() == CS_DISCONNECTED){
      bimg = gui_newAspectRatio(drawgetimagesize("gfx/menu/splash.tga"), Vector2(VIEW_WIDTH, VIEW_MAX_y));
      drawpic(VIEW_ORG, "gfx/menu/splash.tga", bimg, '1 1 1', 1, 0);
    }
    if(cvar("developer")){
      gui_drawversion();
    }
  }
  
  //draw the selected Menu_d() function
  switch(M_STATE){
    case M_NONE:
      break;
    case M_MAIN:
      m_main_d();
      break;
    case M_SINGLE:
      m_camp_d();
      break;
    case M_LOAD:
      m_load_d();
      break;
    case M_SAVE:
      m_save_d();
      break;
    case M_NEWGAME:
      m_newg_d();
      break;
    case M_MULTI:
      m_multi_d();
      break;
    case M_SETUP:
      m_setup_d();
      break;
    case M_HOST:
      m_host_d();
      break;
    case M_JOIN:
      m_join_d();
      break;
    case M_OPTIONS:
      m_options_d();
      break;
    case M_OPTIONS_CONTROLS:
      m_controls_d();
      break;
    case M_OPTIONS_GRAPHICS:
      m_graphics_d();
      break;
    case M_OPTIONS_EFFECT:
      m_effects_d();
      break;
    case M_OPTIONS_GFX:
      m_gfx_d();
      break;
    case M_OPTIONS_AUDIO:
      m_audio_d();
      break;
    case M_OPTIONS_GAMEPLAY:
      m_gameplay_d();
      break;
    case M_CREDITS:
      m_credits_d();
      break;
    case M_NEWSAVE:
      m_newsave_d();
      break;
    case M_HELP:
      m_help_d();
      break;
    case M_TRAINING:
      m_train_d();
      break;
  }

  m_drawmouse(DRAW_MOUSE);
  //DEBUG
  /*drawstring('4 4', vtos(getmousepos()), '8 8 0', '1 1 1', 1, 0);
  drawstring('4 14', ftos(VIEW_MAX_x), '8 8 0', '1 1 1', 1, 0);
  drawstring('48 14', ftos(VIEW_MAX_y), '8 8 0', '1 1 1', 1, 0);
  drawstring('4 24', strcat("mouse : ", ftos(MOUSE_DOWN)), '8 8 0', '1 1 1', 1, 0);
  drawstring('4 34', strcat("target : ", MOUSE_TARGET.classname), '8 8 0', '1 1 1', 1, 0);*/
};

/*
  Quake C api hook - called, I believe when 'togglemenu' console command is invoked
*/
void(float mode) m_toggle={
  MAIN_MISSION = TRUE;
  if( clientstate() == CS_DISCONNECTED ){
    MAIN_MISSION = FALSE;
    localcmd("cd play 2;\n");
  }
  
  if( isdemo() ){
    setkeydest(KEY_MENU);
    menu_clear_items(M_MAIN); 
    m_main_f();
    return;
  }
  
  setkeydest(KEY_MENU);
  menu_clear_items(M_MAIN); 
  m_main_f();
};

/*
  Quake C api hook - not sure yet
*/
void() m_newmap={
  menu_clear_items(M_STATE); 
};

/*
  Quake C api hook - when the menu shuts down
*/
void() m_shutdown={
  MOUSE_TARGET = null_entity;
  TEXTFIELD_TARGET = null_entity;
  UI_INPUT_ACTIVE = FALSE;
  SUB_MENU = FALSE;
  DRAW_MOUSE = FALSE;
  M_STATE = M_NONE;
  setkeydest(KEY_GAME);
  setmousetarget(MT_CLIENT);
  menu_clear_items(M_STATE);
};

void(float drawmous) m_drawmouse={
  local vector mpos, i_sz;
  
  if(drawmous){
    
    i_sz = drawgetimagesize(UI_IMG_MOUSE);
    i_sz = gui_scaleSize(i_sz, VIEW_SCALE / 1.25);

    mpos_x = VIEW_MPOS_x;
    mpos_y = VIEW_MPOS_y;
    
    drawpic(mpos, UI_IMG_MOUSE, i_sz, '1 1 1', 1, 0);
  }
};