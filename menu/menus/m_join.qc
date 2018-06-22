/*
mech Mod
Author: Peter Roohr
Date: 4/16/2018
Overview: multiplayer join game menu
*/

//join Globals
entity join_title;


//join constants

//join callbacks


// ini function, called by '_f' function as a setup func
void() m_join_i={

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_join_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_JOIN;
  setkeydest(KEY_MENU);
  m_join_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_join_d={
  local entity widget;
  widget = findchainfloat(menuId, M_JOIN);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_join_k={
  //cons_logAFloat("m_join_k.key", key);  //DEBUG
  //cons_logAFloat("m_join_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MULTI;
      m_multi_f();
      break;
  }
};