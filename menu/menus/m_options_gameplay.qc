/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
Overview: options - gameplay menu
*/

//gameplay Globals
entity gameplay_title;

entity gameplay_fov_lbl;
entity gameplay_fov_more;
entity gameplay_fov_less;

entity gameplay_fps_lbl;
entity gameplay_fps_on;
entity gameplay_fps_off;

entity gameplay_datetime_lbl;
entity gameplay_datetime_on;
entity gameplay_datetime_off;

entity gameplay_hudalpha_lbl;
entity gameplay_hudalpha_up;
entity gameplay_hudalpha_dn;

entity gameplay_back;
//gameplay constants

//gameplay callbacks
void() click_gameplay_fov_more={
  local float val;
  val = gameplay_fov_lbl.len;
  val = val + 10;
  if(val >= 130){
    val = 130;
    gameplay_fov_more.drawme = FALSE;
  }
  gameplay_fov_lbl.len = val;
  strunzone(gameplay_fov_lbl.label);
  gameplay_fov_lbl.label = strzone(ftos(gameplay_fov_lbl.len));
  cvar_set("fov", gameplay_fov_lbl.label);
  gameplay_fov_less.drawme = TRUE;
};
void() click_gameplay_fov_less={
  local float val;
  val = gameplay_fov_lbl.len;
  val = val - 10;
  if(val <= 40){
    val = 40;
    gameplay_fov_less.drawme = FALSE;
  }
  gameplay_fov_lbl.len = val;
  strunzone(gameplay_fov_lbl.label);
  gameplay_fov_lbl.label = strzone(ftos(gameplay_fov_lbl.len));
  cvar_set("fov", gameplay_fov_lbl.label);
  gameplay_fov_more.drawme = TRUE;
};

void() click_gameplay_date_on={
  cvar_set("showdate", "1");
  cvar_set("showtime", "1");
  strunzone(gameplay_datetime_lbl.label);
  gameplay_datetime_lbl.label = strzone("ON");
  gameplay_datetime_on.drawme = FALSE;
  gameplay_datetime_off.drawme = TRUE;
};
void() click_gameplay_date_off={
  cvar_set("showdate", "0");
  cvar_set("showtime", "0");
  strunzone(gameplay_datetime_lbl.label);
  gameplay_datetime_lbl.label = strzone("OFF");
  gameplay_datetime_on.drawme = TRUE;
  gameplay_datetime_off.drawme = FALSE;
};

void() click_gameplay_fps_on={
  cvar_set("showfps", "1");
  strunzone(gameplay_fps_lbl.label);
  gameplay_fps_lbl.label = strzone("ON");
  gameplay_fps_on.drawme = FALSE;
  gameplay_fps_off.drawme = TRUE;
};
void() click_gameplay_fps_off={
  cvar_set("showfps", "0");
  strunzone(gameplay_fps_lbl.label);
  gameplay_fps_lbl.label = strzone("OFF");
  gameplay_fps_on.drawme = TRUE;
  gameplay_fps_off.drawme = FALSE;
};

void() click_gameplay_back={
  cmd("saveconfig\n");
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_gameplay_hudalpha_up={
  local float val;
  val = gameplay_hudalpha_lbl.len;
  val = val + 0.05;
  if(val > 1.0){
    val = 1.0;
    gameplay_hudalpha_up.drawme = FALSE;
  }
  gameplay_hudalpha_lbl.len = val;
  strunzone(gameplay_hudalpha_lbl.label);
  gameplay_hudalpha_lbl.label = strzone(sprintf("%0.2f", gameplay_hudalpha_lbl.len) );
  cvar_set("cl_hud_alpha", gameplay_hudalpha_lbl.label);
  
  gameplay_hudalpha_dn.drawme = TRUE;
};

void() click_gameplay_hudalpha_dn={
  local float val;
  val = gameplay_hudalpha_lbl.len;
  val = val - 0.05;
  if(val < 0.1){
    val = 0.1;
    gameplay_hudalpha_dn.drawme = FALSE;
  }
  gameplay_hudalpha_lbl.len = val;
  strunzone(gameplay_hudalpha_lbl.label);
  gameplay_hudalpha_lbl.label = strzone(sprintf("%0.2f", gameplay_hudalpha_lbl.len) );
  cvar_set("cl_hud_alpha", gameplay_hudalpha_lbl.label);
  
  gameplay_hudalpha_up.drawme = TRUE;
};

// ini function, called by '_f' function as a setup func
void() m_gameplay_i={
  gameplay_title = lbl_img('10 100', '1 1 0', IMG_OPTION_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, (UI_FLAG_SIZE_IMG) );
  
  gameplay_fov_lbl = lbl_text('190 133', '9 9 0', strzone(ftos(cvar("fov"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_fov_lbl.len = cvar("fov");
  gameplay_fov_more = btn_img_callback('222 132', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_fov_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fov_less = btn_img_callback('176 132', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_fov_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fov_lbl.len == 40){
    gameplay_fov_less.drawme = FALSE;
  }
  else if(gameplay_fov_lbl.len == 130){
    gameplay_fov_more.drawme = FALSE;
  }
  
  gameplay_datetime_lbl = lbl_text('190 149', '9 9 0', strzone(menu_float_bool(cvar("showdate"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_datetime_lbl.len = cvar("showdate");
  gameplay_datetime_on = btn_img_callback('222 148', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_date_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_datetime_off = btn_img_callback('176 148', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_date_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_datetime_lbl.len){
    gameplay_datetime_on.drawme = FALSE;
  }
  else{
    gameplay_datetime_off.drawme = FALSE;
  }
   
  gameplay_fps_lbl = lbl_text('190 162', '9 9 0', strzone(menu_float_bool(cvar("showfps"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_fps_lbl.len = cvar("showfps");
  gameplay_fps_on = btn_img_callback('222 162', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_fps_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fps_off = btn_img_callback('176 162', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_fps_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fps_lbl.len){
    gameplay_fps_on.drawme = FALSE;
  }
  else{
    gameplay_fps_off.drawme = FALSE;
  }
  
  local float clean;
  clean = cvar("cl_hud_alpha");
  gameplay_hudalpha_lbl = lbl_text('190 175', '9 9 0', strzone(sprintf("%0.2f", clean)), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_hudalpha_lbl.len = cvar("cl_hud_alpha");
  gameplay_hudalpha_lbl.image1 = "gfx/hud/ret_lock.png";
  gameplay_hudalpha_up = btn_img_callback('230 175', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_hudalpha_dn = btn_img_callback('176 175', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if( gameplay_hudalpha_lbl.len < 0.1 ){
    gameplay_hudalpha_dn.drawme = FALSE;
  }
  if( gameplay_hudalpha_lbl.len > 0.95 ){
    gameplay_hudalpha_up.drawme = FALSE;
  }
  
  gameplay_back = btn_img_callback('10 230 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_back, '1 1 1',CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_gameplay_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GAMEPLAY;
  setkeydest(KEY_MENU);
  m_gameplay_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_gameplay_d={
  
  gui_renderString("Field of View :", gui_percentToPixelRawVec('45 136'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Show Date/Time :", gui_percentToPixelRawVec('37 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Show FPS :", gui_percentToPixelRawVec('85 164'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("HUD Alpha:", gui_percentToPixelRawVec('85 177'), CLR_DEF_WHITE, '8 8 0', 1, 0);

  drawpic( gui_percentToPixelRawVec('250 167'), gameplay_hudalpha_lbl.image1, '32 32', '1 1 1', gameplay_hudalpha_lbl.len, 0);
  
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GAMEPLAY);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_gameplay_k={
  //cons_logAFloat("m_gameplay_k.key", key);  //DEBUG
  //cons_logAFloat("m_gameplay_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};