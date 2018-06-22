/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
Overview: credits menu
*/

//credits Globals
entity credits_title;
entity credits_back;

//credits constants
string IMG_CREDITS_TITLE = "gfx/menu/help/credits_title.png";

//credits callbacks
void() click_credits_back={
  menu_clear_items(M_STATE);
  m_main_f();
};

// ini function, called by '_f' function as a setup func
void() m_credits_i={
  credits_title = lbl_img('10 100', '1 1 0', IMG_CREDITS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
  credits_back = btn_img_callback('10 138 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_CREDITS, click_credits_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_credits_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_CREDITS;
  setkeydest(KEY_MENU);
  m_credits_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_credits_d={
    
  gui_renderString("[battleMETAL Design Team]", gui_percentToPixelRawVec('207.5 138'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
    gui_renderString("Lead Coder | Principal Artist | Level Designer | Game Designer | Story", gui_percentToPixelRawVec('5 168'), CLR_DEF_IIF_FRIEND_BLD, '9 9 0', 1, 0);
    gui_renderString("[ Peter Roohr ]", gui_percentToPixelRawVec('226 180'), '0 0.8 0.6', '12 12 0', 1, 0);
    gui_renderString("http://www.roohrorbitalyards.com/", gui_percentToPixelRawVec('171.5 195'), CLR_DEF_WHITE, '9 9 0', 1, 0);
    
    gui_renderString("Music | SFX | Voice Work | Design Consultant", gui_percentToPixelRawVec('122 220'), CLR_DEF_IIF_FRIEND_BLD, '9 9 0', 1, 0);
    gui_renderString("[ Eamonn McHugh-Roohr ]", gui_percentToPixelRawVec('182 232'), '0.27 0.95 0.25', '12 12 0', 0.65, 0);
    gui_renderString("http://eamonnmr.com/", gui_percentToPixelRawVec('230 247'), CLR_DEF_WHITE, '9 9 0', 0.65, 0);
   
   gui_renderString("Support | Resources", gui_percentToPixelRawVec('234.5 272'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
    gui_renderString("www.insideqc.com", gui_percentToPixelRawVec('256 284'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("www.quakeone.com", gui_percentToPixelRawVec('256 296'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("http://www.mechwarriorsunited.com/", gui_percentToPixelRawVec('184 308'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    
  local entity widget;
  widget = findchainfloat(menuId, M_CREDITS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_credits_k={
  //cons_logAFloat("m_join_k.key", key);  //DEBUG
  //cons_logAFloat("m_join_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};