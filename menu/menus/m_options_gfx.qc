/*
mech Mod
Author: Peter Roohr
Date: 4/19/2018
Overview: gfx game menu
*/

/*
//gfx menu
corona intensity 0 - 4
gloss mode 0,1,2
  RT DLights -> always on
  RT DLight Shadow -> always on
  RT World -> always on
  RT World Shadow -> always on
  
Bloom Effect on/off
Scene brightness 0.25 - 4
glow brightness 0 - 4
bloom color scale 0 - 1
bloom color subtract 0 - 0.938
bloom color exponent 1 - 8
bloom intensity 0.0 - 4
bloom blur 1 - 16
bloomr resolution 64 - 2048 incr 64
*/

//gfx Globals

//gfx constants

//gfx callbacks


// ini function, called by '_f' function as a setup func
void() m_gfx_i={

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_gfx_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GFX;
  setkeydest(KEY_MENU);
  m_gfx_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_gfx_d={

  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GFX);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_gfx_k={
  cons_logAFloat("m_effects_k.key", key);  //DEBUG
  cons_logAFloat("m_effects_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS_GRAPHICS;
      m_graphics_f();
      break;
    case K_MOUSE1:
      m_sys_doclick();
      break;
  }
};