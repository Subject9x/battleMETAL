/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
Overview: options - graphics menu
*/

//credits Globals

//credits constants

//credits callbacks


// ini function, called by '_f' function as a setup func
void() m_graphics_i={

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_graphics_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GRAPHICS;
  setkeydest(KEY_MENU);
  m_graphics_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_graphics_d={
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GRAPHICS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_graphics_k={
  cons_logAFloat("m_graphics_k.key", key);  //DEBUG
  cons_logAFloat("m_graphics_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
    case K_MOUSE1:
      m_sys_doclick();
      break;
  }
};