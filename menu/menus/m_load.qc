/*
mech Mod
Author: Peter Roohr
Date: 4/14/2018
Overview: load campaign menu
*/

//load Globals
entity load_title;
entity load_back;
entity load_list;

//load Constants
string IMG_LOAD_TITLE   = "gfx/menu/load/load_title.png";

//button callbacks
void() click_load_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
  localsound("sound/misc/menu2.wav");
};

void() click_load_loadgame={
  menu_clear_items(M_STATE);
  menu_exit_togame();
  cvar_set("saveslot", ftos(self.data_bind));
  cvar_set("gamemode", ftos(1));
  cvar_set("coop", ftos(0));
  cvar_set("deathmatch", ftos(0));
  tokenizebyseparator(GAME_SAVES_DRAWNAME[self.data_bind], "  ");
  
  cmd("map ", strcat(argv(1),"\n"));
};

// ini function, called by '_f' function as a setup func
void() m_load_i={
  load_title = lbl_img('10 100', '1 1 0', IMG_LOAD_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_LOAD, 1, (UI_FLAG_SIZE_IMG) );
 
  load_back = btn_img_callback('10 132 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_LOAD, click_load_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  
  local vector start;
  start = '10 150';

  local float itr;
  itr = 0;
  
  if(GAME_SAVES[itr] != ""){
    load_list = btn_text_callback(start,'8 8 0', GAME_SAVES_DRAWNAME[itr], 0, M_LOAD, click_load_loadgame, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    load_list.data_bind = itr; //databind
    itr = itr + 1;
    if(GAME_SAVES[itr] != ""){
      while (itr < GAME_SAVES_MAX ){
        local entity list;
        local vector next;
        next = start;
        next_y = next_y + (itr * 10);
        list = btn_text_callback(next, '8 8 0', GAME_SAVES_DRAWNAME[itr], 0, M_LOAD, click_load_loadgame, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
        list.data_bind = itr; //databind
        itr = itr + 1;
      }
    }
  }
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