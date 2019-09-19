/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
  menu definition file
  NEW GAME MENU
  
  WARNING - MULTIPLAYER DEPRECATED AT THIS TIME
*/

//Main Menu Globals
entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;
entity setup_accept;

//Main Menu Constants
string IMG_SETUP_TITLE  = "gfx/menu/setup/setup_title.png";

//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
/*void() click_newg_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  localsound("sound/misc/menu2.wav");
};*/
void() click_setup_accept={
  menu_clear_items(M_STATE);
  m_multi_f();
};

void() textfield_setup_name={
  cvar_set("_cl_name", self.data_text);
};

// ini functions
void() m_setup_i={
  setup_title = lbl_img('10 100', '1 1 0', IMG_SETUP_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_SETUP, 1, (UI_FLAG_SIZE_IMG) );
  setup_label_playername = lbl_text('10 142 0', '10 10 0', "Player Name", '1 1 1', 0, M_SETUP, 1, 0);
  
  setup_txtfld_playername = inp_textfield('150 144', '8 8 0', 32, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC));
  setup_txtfld_playername.data_text = strzone(str_cvar("_cl_name"));
  
  setup_accept = btn_img_callback('10 230 0', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_SETUP, click_setup_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_setup_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_SETUP;
  setkeydest(KEY_MENU);
  m_setup_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_setup_d={

  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_setup_k={
  //cons_logAFloat("m_setup_k.key", key);  //DEBUG
  //cons_logAFloat("m_setup_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_multi_f();
      break;
  }
};