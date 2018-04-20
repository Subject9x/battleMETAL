/*
mech Mod
Author: Peter Roohr
Date: 4/19/2018
Overview: multiplayer join game menu
*/

/*
//effects menu
particles on/off
particles quality 1 -4

stainmaps on/off
onload clear stainmaps on/off

decals on/off

bullet impacts on/off
smoke on/off
sparks on/off
bubbles on/off

  blood -> off
  blood opacity -> 0.2
  force new blood effects -> off
  
  polygonal lightning -> off
  smooth sweep lightning ->off
  waist-level lightning -> off
  lighting end light -> off
  lighting thickness -> ignore
  
model interpolation on/off
sprite interpolation on/off
flicker interpolation on/off
view blen 0 - 1
water alpha 0 - 1
water movement 0 - 10
*/

//effects Globals

//effects constants

//effects callbacks


// ini function, called by '_f' function as a setup func
void() m_effects_i={

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_effects_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_EFFECT;
  setkeydest(KEY_MENU);
  m_effects_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_effects_d={
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_EFFECT);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_effects_k={
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