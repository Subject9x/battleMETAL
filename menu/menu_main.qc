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
  
  registercvar("cl_hud_alpha", "0", 1);
  
  VIEW_SCALE = 0.35;
  if(clientstate() == CS_DISCONNECTED){
    cmd("cd", " play 6");
    m_toggle(1);
  }
  MOUSE_TARGET = null_entity;
  TEXTFIELD_TARGET = null_entity;
  KEYBIND_TARGET = null_entity;
  UI_INPUT_ACTIVE = FALSE;
  UI_KEYBIND_ACTIVE = FALSE;
  SUB_MENU = FALSE;
  
  //setup textfield key filter;
  menu_ini_txtfilter();
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
  //prepare VIEW globals per-frame
  VIEW_ORG = '0 0';
  VIEW_MAX_x = cvar("vid_conwidth");
  VIEW_MAX_y = cvar("vid_conheight");
  VIEW_MAX_z = cvar("vid_pixelheight");
  
  VIEW_CTR_x = VIEW_CTR_x / 2;
  VIEW_CTR_y = VIEW_CTR_y / 2;
  VIEW_MPOS = getmousepos();
  VIEW_ACT_x = cvar("vid_width");
  VIEW_ACT_y = cvar("vid_height");
  VIEW_ACT_z = cvar("vid_pixelheight");
  
  if( (clientstate() == CS_CONNECTED) && (getkeydest() == KEY_MENU) ){
    local vector p;
    p = VIEW_MAX;
    p_z = 0;
    drawpic('0 0', "gfx/ui/box_512.png", p, '0.231 0.27 0.32', 0.9, 0);
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
  Quake C api hook - called, I believe when 'togglemenu' console command is invoke
*/
void(float mode) m_toggle={
  
  if ( (getkeydest() != KEY_MENU && getkeydest() != KEY_MENU_GRABBED) || M_STATE != M_MAIN ){
    if(mode == 0){
      // the menu is off, and we want it off
      return; 
    }
    if(clientstate() == CS_CONNECTED){
      //todo - in-game main menu
    }
    m_main_f();
  }
  else{
    if(mode == 1){
      // the menu is on, and we want it on
      return; 
    }   
    DRAW_MOUSE = FALSE;
    M_STATE = M_NONE;
    setkeydest(KEY_GAME);
  }
};

/*
  Quake C api hook - not sure yet
*/
void() m_newmap={

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
  if(drawmous){
    local vector mpos, i_sz;
    
    i_sz = drawgetimagesize(UI_IMG_MOUSE);
    i_sz = gui_percentToPixelRawVec( gui_scaleSize(i_sz, VIEW_SCALE / 1.25) );

    mpos_x = VIEW_MPOS_x;
    mpos_y = VIEW_MPOS_y;
    
    drawpic(mpos, UI_IMG_MOUSE, i_sz, '1 1 1', 1, 0);
  }
};