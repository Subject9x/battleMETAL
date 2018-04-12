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
  DRAW_MOUSE = TRUE;
  setkeydest(KEY_MENU);
  M_STATE = M_MAIN;
  if(clientstate() == CS_CONNECTED){
    setmousetarget(MT_MENU);
  }
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_main_d={
  drawstring('10 4', "Main Menu", '8 8', '1 1 1', 1, 0);

};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_main_k={
  cons_logAFloat("m_main_k.key", key);  //DEBUG
  cons_logAFloat("m_main_k.ascii", ascii);  //DEBUG   

  switch(key){
    case K_ESCAPE:{
      DRAW_MOUSE = FALSE;
      setkeydest(KEY_GAME);
      if(clientstate() != CS_CONNECTED){
        setmousetarget(MT_CLIENT);
      }
      M_STATE = M_NONE;
      m_toggle(0);
      break;
    }
  }
};