/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
mod: 07/20/2019
Overview: load campaign menu
*/

//load Globals
entity load_title;
entity load_back;

//load Constants
string IMG_LOAD_TITLE = "gfx/menu/load/load_title.png";

//"- EMPTY SAVE -" 

//button callbacks
void() click_load_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
  localsound("sound/misc/menu2.wav");
};

void() click_load_loadgame={
  
  if( GAME_SAVES_DRAWNAME[self.data_bind] != ""){
    menu_clear_items(M_STATE);
    cvar_set("saveslot", ftos(self.data_bind));
    cvar_set("gamemode", ftos(1));
    cvar_set("coop", ftos(0));
    cvar_set("deathmatch", ftos(0));
    cvar_set("skill", ftos(GAME_SAVES_SKILL[self.data_bind]));
    localcmd("maxplayers 1;\n");
    cvar_set("cl_newgameplus", ftos(GAME_SAVES_NEWG[self.data_bind]));
    menu_exit_togame();
    localcmd(strcat("map ", GAME_SAVES_MAP[self.data_bind]),"\n");
  }
};

// ini function, called by '_f' function as a setup func
void() m_load_i={
  local vector start;
  local float itr;
  local entity list;
  local vector next;
  local string name;
  
  menu_parent_setup(VIEW_ORG + '0 70', '320 288');
  
  load_title = lbl_img(MENU_ORG +  menu_parent_center_width(10), '1 1 0', IMG_LOAD_TITLE, '1 1 1', VIEW_CTX, M_LOAD, 1, UI_FLAG_SIZE_IMG );
  
  start = MENU_ORG + '10 45';
  
  itr = 0;
  while (itr < GAME_SAVES_MAX ){
    next = start;
    next_y = next_y + (itr * 20);
    
    if( GAME_SAVES_DRAWNAME[itr] == "" ){
      name = "- EMPTY -";
      list = lbl_text(next, '14 14 0', name, CLR_DEF_TXT_CANTSELECT, 0, M_LOAD, 1, 0) ;
      list.fontId = FONT_NUM_ROBOT_LIGHT;
    }
    else{
      name = GAME_SAVES_DRAWNAME[itr];
      list = btn_text_callback(next, '14 14', name, 0, M_LOAD, click_load_loadgame, CLR_DEF_WHITE, CLR_DEF_ARM_OK, 1, UI_FLAG_SIZE_IMG);
      list.fontId = FONT_NUM_XOLONIUM_BOLD;
    }
    
    list.data_bind = itr; //databind
    itr = itr + 1;
  }
  load_back = btn_text_callback(next + '45 24', '16 16', "BACK", VIEW_CTX, M_LOAD, click_load_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  load_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_load_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_LOAD;
  setkeydest(KEY_MENU);
  menu_scan_saves();
  m_load_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_load_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_LOAD);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_load_k={
  //cons_logAFloat("m_load_k.key", key);  //DEBUG
  //cons_logAFloat("m_load_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};