/*
  author: Peter Roohr
  date: 11/26/2017
  
  overview: what is a menu.dat? time to explore and find out
*/

void() m_init={
  VIEW_SCALE = 0.35;
  if(clientstate() == CS_DISCONNECTED){
    cmd("cd", " play 6");
    m_toggle(1);
  }
};

void(float keynr, float ascii) m_keydown={
  switch(M_STATE){
    case M_MAIN:
      m_main_k(keynr, ascii);
      break;
  }
};

void(float keynr, float ascii) m_keyup={

};

void(float width, float height) m_draw={

    VIEW_ORG = '0 0';
    VIEW_MAX_x = width;
    VIEW_MAX_y = height;
    VIEW_CTR_x = VIEW_CTR_x / 2;
    VIEW_CTR_y = VIEW_CTR_y / 2;
    VIEW_MPOS = getmousepos();
    
    switch(M_STATE){
      case M_NONE:
        break;
      case M_MAIN:
        m_main_d();
        break;
    }
    
    m_drawmouse(DRAW_MOUSE);
    drawstring('4 4', vtos(getmousepos()), '8 8 0', '1 1 1', 1, 0);
    drawstring('4 14', ftos(width), '8 8 0', '1 1 1', 1, 0);
    drawstring('48 14', ftos(height), '8 8 0', '1 1 1', 1, 0);
  
};

void(float mode) m_toggle={
  
  if ( (getkeydest() != KEY_MENU && getkeydest() != KEY_MENU_GRABBED) || M_STATE != M_MAIN ){
    if(mode == 0){
      return; // the menu is off, and we want it off
    }
    m_main_f();
  }
  else{
    if(mode == 1){
      return; // the menu is on, and we want it on
    }   
    DRAW_MOUSE = FALSE;
    M_STATE = M_NONE;
    setkeydest(KEY_GAME);
  }
};

void() m_newmap={

};

void() m_shutdown={
  //print("m_shutdown\n");  //DEBUG
  DRAW_MOUSE = FALSE;
  M_STATE = M_NONE;
  setkeydest(KEY_GAME);
  setmousetarget(MT_CLIENT);
};

void(float drawmous) m_drawmouse={
  if(drawmous){
    local vector mpos, i_sz;
    
    i_sz = drawgetimagesize(UI_IMG_MOUSE);
    i_sz = gui_percentToPixelRawVec( gui_scaleSize(i_sz, VIEW_SCALE / 1.25) );

    mpos_x = VIEW_MPOS_x - gui_percentXRaw(2);
    mpos_y = VIEW_MPOS_y - gui_percentYRaw(4);
    
    drawpic(mpos, UI_IMG_MOUSE, i_sz, '1 1 1', 1, 0);
  }
};