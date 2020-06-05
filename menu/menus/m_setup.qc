/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
  menu definition file
  Player Setup
  
*/

//Main Menu Globals
entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;

entity setup_team_label;
entity setup_team_value;
entity setup_team_prev;
entity setup_team_next;

entity setup_pic_label;
entity setup_pic;


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
  if( self.data_text != "" ){
    cvar_set("_cl_name", self.data_text);
  }
  else{
    cvar_set("_cl_name", "DEAD_HAND");
    self.data_text = "DEAD_HAND";
  }
};

void() setup_team_prev_f={
  if( setup_team_value.len == 2 ){
   setup_team_value.len = 3;
  }
  else{
    setup_team_value.len = 2;
  }
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

void() setup_team_next_f={
  if( setup_team_value.len == 3 ){
   setup_team_value.len = 2;
  }
  else{
    setup_team_value.len = 3;
  }
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

// ini functions
void() m_setup_i={
  setup_title = lbl_img('10 100', '1 1 0', IMG_SETUP_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_SETUP, 1, (UI_FLAG_SIZE_IMG) );
  setup_label_playername = lbl_text('10 142 0', '12 12 0', "Player Name : ", '1 1 1', 0, M_SETUP, 1, 0);
  
  setup_txtfld_playername = inp_textfield('150 140', '14 14 0', 24, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_UPP));
  setup_txtfld_playername.data_text = strzone(str_cvar("_cl_name"));
  
  setup_team_label = lbl_text('10 165 0', '12 12 0', "Preferred TDM Team : ", '1 1 1', 0, M_SETUP, 1, 0);
  setup_team_value = lbl_text('200 185 0', '12 12 0', strzone(ftos(cvar("cl_team"))), '1 1 1', 0, M_SETUP, 1, 0);
  setup_team_value.len = cvar("cl_team");
  setup_team_prev = btn_img_callback('150 175 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_team_next = btn_img_callback('265 175 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  setup_pic_label = lbl_text('10 224 0', '12 12 0', "Player Color Tint : ", '1 1 1', 0, M_SETUP, 1, 0);
  //setup_pic = lbl_img('150 160', '1 1 0', "gfx/ui/mech_icons/icon_matok.png", '1 1 1', (VIEW_CTX | VIEW_CTY), M_SETUP, 1, (UI_FLAG_SIZE_IMG) );
  
  setup_accept = btn_img_callback('10 350 0', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_SETUP, click_setup_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
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
  if( setup_team_value.len == 1 ){
    drawpic( gui_percentToPixelRawVec('175 160'), IMG_TEAM_SURVEST, gui_percentToPixelRawVec('75 64'), '1 1 1', 1, 0);
  }
  else{
    drawpic( gui_percentToPixelRawVec('175 160'), IMG_TEAM_MILITAR, gui_percentToPixelRawVec('75 64'), '1 1 1', 1, 0);
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