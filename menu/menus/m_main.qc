/*
mech Mod
Author: Peter Roohr
Date: 4/11/2018
Overview: definition file for a menu ui
basically I'm mimicking the DP source architecture on this one cause there's no documentation
on how to use menu.dat. 
*/

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
  
*/
void() m_main_f={

  KEY_DEST = KEY_MENU;
  M_STATE = M_MAIN;
  
  cons_logAFloat("m_main_f.KEY_DEST", KEY_DEST);  //DEBUG
  cons_logAFloat("m_main_f.M_STATE", M_STATE);  //DEBUG
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void(float scr_w, float scr_h, vector mouse_pos) m_main_d={
  drawstring('10 4', "Main Menu", '8 8', '1 1 1', 1, 0);
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_main_k={
  switch(key){
    case K_ESCAPE:
      KEY_DEST = KEY_GAME;
      M_STATE = M_NONE;
      cons_logAFloat("m_main_k.KEY_DEST", KEY_DEST);  //DEBUG
      cons_logAFloat("m_main_k.M_STATE", M_STATE);  //DEBUG   
      break;
  }
};