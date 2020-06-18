/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
    Player Setup for multiplayer
*/

float TINT_MIN = 0.2;
float TINT_STEP = 0.05;

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

vector setup_tint;

entity setup_tint_red_left;
entity setup_tint_red_right;
entity setup_tint_red_val;

entity setup_tint_red_left;
entity setup_tint_red_right;
entity setup_tint_red_val;

entity setup_tint_green_left;
entity setup_tint_green_right;
entity setup_tint_green_val;

entity setup_tint_blue_left;
entity setup_tint_blue_right;
entity setup_tint_blue_val;

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
  cvar_set("cl_tint_r", ftos(setup_tint_x));
  cvar_set("cl_tint_g", ftos(setup_tint_y));
  cvar_set("cl_tint_b", ftos(setup_tint_z));
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

void() setup_tint_red_more={
  setup_tint_x = setup_tint_x + 0.1;
  if( setup_tint_x > 1 ){
    setup_tint_x = 1;
  }
};
void() setup_tint_red_less={
  setup_tint_x = setup_tint_x - TINT_STEP;
  if( setup_tint_x < TINT_MIN ){
    setup_tint_x = TINT_MIN;
  }
};

void() setup_tint_green_more={
  setup_tint_y = setup_tint_y + TINT_STEP;
  if( setup_tint_y > 1 ){
    setup_tint_y = 1;
  }
};
void() setup_tint_green_less={
  setup_tint_y = setup_tint_y - TINT_STEP;
  if( setup_tint_y < TINT_MIN ){
    setup_tint_y = TINT_MIN;
  }
};

void() setup_tint_blue_more={
  setup_tint_z = setup_tint_z + TINT_STEP;
  if( setup_tint_z > 1 ){
    setup_tint_z = 1;
  }
};
void() setup_tint_blue_less={
  setup_tint_z = setup_tint_z - TINT_STEP;
  if( setup_tint_z < TINT_MIN ){
    setup_tint_z = TINT_MIN;
  }
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
  
  setup_pic_label = lbl_text('10 230 0', '12 12 0', "Player Color Tint : ", '1 1 1', 0, M_SETUP, 1, 0);
  
  setup_tint_x = cvar("cl_tint_r");
  setup_tint_y = cvar("cl_tint_g");
  setup_tint_z = cvar("cl_tint_b");
  
  setup_tint_red_left = btn_img_callback('150 230 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_red_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_tint_red_right = btn_img_callback('215 230 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_red_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  //setup_tint_red_val = lbl_text('0 0 0', '12 12 0', ftos(setup_tint_x), setup_tint + '0 -1 -1', 0, M_SETUP, 1, 0);

  setup_tint_green_left = btn_img_callback('150 265 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_green_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_tint_green_right = btn_img_callback('215 265 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_green_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
 //setup_tint_green_val = lbl_text('0 0 0', '12 12 0', ftos(setup_tint_y), setup_tint + '-1 0 -1', 0, M_SETUP, 1, 0);
  
  setup_tint_blue_left = btn_img_callback('150 300 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_blue_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_tint_blue_right = btn_img_callback('215 300 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_tint_blue_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  //setup_tint_blue_val = lbl_text('0 0 0', '12 12 0', ftos(setup_tint_z),setup_tint + '-1 -1 0', 0, M_SETUP, 1, 0);
  
  setup_pic = lbl_img('215 230', '1 1 0', "gfx/ui/mech_icons/icon_matok.png", setup_tint, (VIEW_CTX | VIEW_CTY), M_SETUP, 1, (UI_FLAG_SIZE_IMG) );
  
  setup_accept = btn_img_callback('10 300 0', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_SETUP, click_setup_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
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
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  setup_pic.color = setup_tint;
  
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  if( setup_team_value.len == 2 ){
    drawpic( gui_percentToPixelRawVec('175 160'), IMG_TEAM_SURVEST, gui_percentToPixelRawVec('75 64'), '1 1 1', 1, 0);
  }
  else{
    drawpic( gui_percentToPixelRawVec('175 160'), IMG_TEAM_MILITAR, gui_percentToPixelRawVec('75 64'), '1 1 1', 1, 0);
  }
  
  gui_renderString("[RED]", setup_tint_red_left.origin + gui_percentToPixelRawVec('-28 3'), CLR_DEF_RED * 0.9, '12 12 0', 1, 0);
  drawfill(setup_tint_red_left.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), setup_tint + '0 -1 -1', 1, 0);
  
  gui_renderString("[GREEN]", setup_tint_green_left.origin + gui_percentToPixelRawVec('-39 3'), '0 1 0' * 0.9, '12 12 0', 1, 0);
  drawfill(setup_tint_green_left.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), setup_tint + '-1 0 -1', 1, 0);
  
  gui_renderString("[BLUE]", setup_tint_blue_left.origin + gui_percentToPixelRawVec('-35 3'), '0 0 1'* 1.1, '12 12 0', 1, 0);
  drawfill(setup_tint_blue_left.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'),  setup_tint + '-1 -1 0', 1, 0);
  
  drawfont = drawfont_prev;
  
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_setup_k={
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_multi_f();
      cvar_set("cl_tint_r", ftos(setup_tint_x));
      cvar_set("cl_tint_g", ftos(setup_tint_y));
      cvar_set("cl_tint_b", ftos(setup_tint_z));
      break;
  }
};