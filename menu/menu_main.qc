/*
  author: Peter Roohr
  date: 11/26/2017
  
  overview: what is a menu.dat? time to explore and find out
*/

float MMODE;


void(float menu_choice) M_Switch_Menu={
  MMODE = menu_choice;
};

void() m_init={
  if(clientstate() == CS_DISCONNECTED){
    cmd("cd", " play 6");
    m_main_f();
  }
  else{
    KEY_DEST = KEY_GAME;
    M_STATE = M_NONE;
  }

  cons_logAFloat("m_init.clientstate()", clientstate());  //DEBUG;
  cons_logAFloat("m_init.KEY_DEST", KEY_DEST);  //DEBUG;
  cons_logAFloat("m_init.M_STATE", M_STATE);  //DEBUG;
};

void(float keynr, float ascii) m_keydown={

};

void(float keynr, float ascii, float downevent) m_keyevent={
  switch(M_STATE){
    case M_MAIN:
      m_main_k(keynr, ascii);
      break;
  }
};

void(float keynr, float ascii) m_up={

};

void(float width, float height) m_draw={
  local vector mouse_pos;
  mouse_pos = getmousepos();
  switch(M_STATE){
    case M_MAIN:
      m_main_d(width, height, mouse_pos);
      break;
  }
};

void(float mode) m_toggle={
  cons_logAFloat("(mode)-> m_toggle      ", mode);  //DEBUG;
//m_entersound = true;
  
  if ( (KEY_DEST != KEY_MENU && KEY_DEST != KEY_MENU_GRABBED) || M_STATE != M_MAIN )
  {
    if(mode == 0){
      return; // the menu is off, and we want it off
    }
    m_main_f();
  }
  else
  {
    if(mode == 1){
      return; // the menu is on, and we want it on
    }
    KEY_DEST = KEY_GAME;
    M_STATE = M_NONE;
  }
};

void() m_newmap={

};

void() m_shutdown={
  
};

void(string msg) GameCommand={

};

void() menu_main={
  print("foo \n");  //DEBUG
};