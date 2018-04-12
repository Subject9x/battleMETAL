/*
  author: Peter Roohr
  date: 11/26/2017
  
  overview: what is a menu.dat? time to explore and find out
*/

void(float menu_choice) M_Switch_Menu={
  MMODE = menu_choice;
};

void() m_init={
  VIEW_SCALE = 0.35;
  if(clientstate() == CS_DISCONNECTED){
    cmd("cd", " play 6");
    setmousetarget(MT_CLIENT);
    M_STATE = M_NONE;
    setkeydest(KEY_GAME);
  }
  else{
    setmousetarget(MT_CLIENT);
    setkeydest(KEY_GAME);
    M_STATE = M_NONE;
  }
  VIEW_MPOS = getmousepos();
  cons_logAFloat("m_init.clientstate()", clientstate());  //DEBUG;
  cons_logAFloat("m_init.M_STATE", M_STATE);  //DEBUG;
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

  if( getkeydest() == KEY_MENU ){
    VIEW_ORG = '0 0';
    VIEW_MAX_x = width;
    VIEW_MAX_y = height;
    VIEW_CTR_x = VIEW_CTR_x / 2;
    VIEW_CTR_y = VIEW_CTR_y / 2;
    VIEW_MPOS =  getmousepos();
    
    switch(M_STATE){
      case M_MAIN:
        m_main_d();
        break;
    }
    
    m_drawmouse(DRAW_MOUSE);

  }
};

void(float mode) m_toggle={
  
  if ( (getkeydest() != KEY_MENU && getkeydest() != KEY_MENU_GRABBED) || M_STATE != M_MAIN ){
    if(mode == 0){
      return; // the menu is off, and we want it off
    }
    m_main_f();
  }
  else{
    cons_logAFloat("(mode)-> m_toggle      ", mode);  //DEBUG;
    if(mode == 1){
      return; // the menu is on, and we want it on
    }
    setkeydest(KEY_GAME);
    M_STATE = M_NONE;
  }
};

void() m_newmap={

};

void() m_shutdown={
  print("m_shutdown\n");  //DEBUG
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