/*
battleMETAL
Author: Peter Roohr
Date: 4/17/2018
mod: 07/19/2019
Overview: 
  options - gameplay menu
    fun and helpful tweaks to the game experience like:
      showing FPS counter, adjusting HUD color and reticles.
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

entity gameplay_crosshair_lbl;
entity gameplay_crosshair_nx;
entity gameplay_crosshair_pr;

entity gameplay_hudalpha_lbl;
entity gameplay_hudalpha_up;
entity gameplay_hudalpha_dn;

entity gameplay_hudcolor_lbl;
entity gameplay_hudcolor_nx;
entity gameplay_hudcolor_pr;

//entity gameplay_hud_sway_less;
//entity gameplay_hud_sway_more;
//entity gameplay_hud_sway_set;

entity gameplay_back;

//gameplay constants
string( float id ) gameplay_hudcolor_name={
  switch( id ){
    case 1:
      return "GREEN";
    case 2:
      return "ORANGE";
    case 3:
      return "PURPLE";
    case 4:
      return "BLUE";
    default:
      return "WHITE";
  }
  return "NONE";
};

vector( float id ) gameplay_hudcolor_color={
  switch( id ){
    case 1:
      return CLR_HUD_GREEN;
    case 2:
      return CLR_HUD_ORANGE;
    case 3:
      return CLR_HUD_PURPLE;
    case 4:
      return CLR_HUD_BLUE;
    default:
      return CLR_HUD_WHITE;
  }
};

string( float id)gameplay_crosshair_img={
  switch( id ){
    case 1:
      return "gfx/hud/ret/crosshair1.png";
    case 2:
      return "gfx/hud/ret/crosshair2.png";
    case 3:
      return "gfx/hud/ret/crosshair3.png";
    case 4:
      return "gfx/hud/ret/crosshair4.png";
    default:
      return "gfx/hud/ret/crosshair1.png";
  }
};

/*string( float val ) gameplay_hud_sway_mode={
  switch(val){
    default:
      return "OFF";
    case 1:
      return "LOW";
    case 2:
      return "FULL";
  }
};*/

//gameplay callbacks
void() click_gameplay_fov_more={
  local float val;
  val = gameplay_fov_lbl.len;
  val = val + 10;
  if(val > 100 ){
    val = 100;
    gameplay_fov_more.drawme = FALSE;
  }
  gameplay_fov_lbl.len = val;
  cvar_set("fov", ftos(val));
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
  cvar_set("fov", ftos(val));
  gameplay_fov_more.drawme = TRUE;
};

void() click_gameplay_date_on={
  cvar_set("showdate", "1");
  cvar_set("showtime", "1");
  gameplay_datetime_lbl.len = TRUE;
  gameplay_datetime_on.drawme = FALSE;
  gameplay_datetime_off.drawme = TRUE;
};
void() click_gameplay_date_off={
  cvar_set("showdate", "0");
  cvar_set("showtime", "0");
  
  gameplay_datetime_lbl.len = FALSE;
  gameplay_datetime_on.drawme = TRUE;
  gameplay_datetime_off.drawme = FALSE;
};

void() click_gameplay_fps_on={
  cvar_set("showfps", "1");
  gameplay_fps_lbl.len = TRUE;
  gameplay_fps_on.drawme = FALSE;
  gameplay_fps_off.drawme = TRUE;
};
void() click_gameplay_fps_off={
  cvar_set("showfps", "0");
  gameplay_fps_lbl.len = FALSE;
  gameplay_fps_on.drawme = TRUE;
  gameplay_fps_off.drawme = FALSE;
};

void() click_gameplay_back={
  localcmd("saveconfig\n");
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_gameplay_crosshair_nx={
  local float val;
  val = cvar("crosshair");
  val = val + 1;
  if( val >= 4 ){
    gameplay_crosshair_nx.drawme = FALSE;
  }
  strunzone(gameplay_crosshair_lbl.label);
  gameplay_crosshair_lbl.label = strzone(ftos(val));
  cvar_set("crosshair", ftos(val));
  gameplay_crosshair_lbl.image1 = gameplay_crosshair_img( cvar("crosshair") );
  gameplay_crosshair_pr.drawme = TRUE;
};

void() click_gameplay_crosshair_pr={
  local float val;
  val = cvar("crosshair");
  val = val - 1;
  if( val <= 1 ){
    gameplay_crosshair_pr.drawme = FALSE;
  }
  strunzone(gameplay_crosshair_lbl.label);
  gameplay_crosshair_lbl.label = strzone(ftos(val));
  cvar_set("crosshair", ftos(val));
  gameplay_crosshair_lbl.image1 = gameplay_crosshair_img( cvar("crosshair") );
  gameplay_crosshair_nx.drawme = TRUE;
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

void() click_gameplay_hudcolor_nx={
  local float val;
  val = gameplay_hudcolor_lbl.len;
  val = val + 1;
  if(val >= 4){
    gameplay_hudcolor_nx.drawme = FALSE;
    val = 4;
  }
  gameplay_hudcolor_lbl.len = val;
  strunzone(gameplay_hudcolor_lbl.label);
  gameplay_hudcolor_lbl.label = strzone(gameplay_hudcolor_name( gameplay_hudcolor_lbl.len ));
  gameplay_hudcolor_lbl.color = gameplay_hudcolor_color( val );
  cvar_set("crosshair_color_red", ftos(gameplay_hudcolor_lbl.color_x) );
  cvar_set("crosshair_color_green", ftos(gameplay_hudcolor_lbl.color_y) );
  cvar_set("crosshair_color_blue", ftos(gameplay_hudcolor_lbl.color_z) );
  cvar_set("cl_hud_color", ftos(val) );
  
  gameplay_hudcolor_pr.drawme = TRUE;
};

void() click_gameplay_hudcolor_pr={
  local float val;
  val = gameplay_hudcolor_lbl.len;
  val = val - 1;
  if(val <= 0){
    gameplay_hudcolor_pr.drawme = FALSE;
    val = 0;
  }
  gameplay_hudcolor_lbl.len = val;
  strunzone(gameplay_hudcolor_lbl.label);
  gameplay_hudcolor_lbl.label = strzone(gameplay_hudcolor_name( gameplay_hudcolor_lbl.len ));
  gameplay_hudcolor_lbl.color = gameplay_hudcolor_color( val );
  cvar_set("crosshair_color_red", ftos(gameplay_hudcolor_lbl.color_x) );
  cvar_set("crosshair_color_green", ftos(gameplay_hudcolor_lbl.color_y) );
  cvar_set("crosshair_color_blue", ftos(gameplay_hudcolor_lbl.color_z) );
  cvar_set("cl_hud_color", ftos(val) );
  
  gameplay_hudcolor_nx.drawme = TRUE;
};

/*void() click_gameplay_hudsway_less={
  gameplay_hud_sway_set.len = gameplay_hud_sway_set.len - 1;
  if( gameplay_hud_sway_set.len < 0 ){
    gameplay_hud_sway_set.len = 0;
  }
  strunzone(gameplay_hud_sway_set.label);
  gameplay_hud_sway_set.label = strzone(gameplay_hud_sway_mode(gameplay_hud_sway_set.len));
  cvar_set("cl_hud_sway", ftos(gameplay_hud_sway_set.len));
  
};
void() click_gameplay_hudsway_more={
  gameplay_hud_sway_set.len = gameplay_hud_sway_set.len + 1;
  if( gameplay_hud_sway_set.len > 2 ){
    gameplay_hud_sway_set.len = 2;
  }
  strunzone(gameplay_hud_sway_set.label);
  gameplay_hud_sway_set.label = strzone(gameplay_hud_sway_mode(gameplay_hud_sway_set.len));
  cvar_set("cl_hud_sway", ftos(gameplay_hud_sway_set.len));
  
};*/

// ini function, called by '_f' function as a setup func
void() m_gameplay_i={
  
  menu_parent_setup(VIEW_ORG + '0 80', '288 240');
  
  gameplay_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_OPTION_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_SIZE_IMG );
  
  gameplay_fov_lbl = lbl_text(MENU_ORG + '125 63', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_USELEN);
  gameplay_fov_lbl.len = cvar("fov");
  gameplay_fov_more = btn_img_callback(gameplay_fov_lbl.origin + Vector2(stringwidth("100", 0, gameplay_fov_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fov_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fov_less = btn_img_callback(gameplay_fov_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fov_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fov_lbl.len == 40){
    gameplay_fov_less.drawme = FALSE;
  }
  else if(gameplay_fov_lbl.len == 130){
    gameplay_fov_more.drawme = FALSE;
  }
  
  gameplay_datetime_lbl = lbl_text(MENU_ORG + '125 83', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_BOOL_ON);
  gameplay_datetime_lbl.len = cvar("showdate");
  gameplay_datetime_on = btn_img_callback(gameplay_datetime_lbl.origin + Vector2(stringwidth("OFF", 0, gameplay_datetime_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_date_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_datetime_off = btn_img_callback(gameplay_datetime_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_date_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_datetime_lbl.len){
    gameplay_datetime_on.drawme = FALSE;
  }
  else{
    gameplay_datetime_off.drawme = FALSE;
  }
   
  gameplay_fps_lbl = lbl_text(MENU_ORG + '125 103', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_BOOL_ON);
  gameplay_fps_lbl.len = cvar("showfps");
  gameplay_fps_on = btn_img_callback(gameplay_fps_lbl.origin + Vector2(stringwidth("OFF", 0, gameplay_fps_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fps_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fps_off = btn_img_callback(gameplay_fps_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fps_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fps_lbl.len){
    gameplay_fps_on.drawme = FALSE;
  }
  else{
    gameplay_fps_off.drawme = FALSE;
  }
  
  local float clean;
  clean = cvar("crosshair");
  gameplay_crosshair_lbl = lbl_text(MENU_ORG + '125 123', '14 14', strzone(sprintf("%0.0f", clean)), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_crosshair_lbl.len = cvar("crosshair");
  gameplay_crosshair_lbl.image1 = gameplay_crosshair_img( cvar("crosshair") );
  gameplay_crosshair_nx = btn_img_callback(gameplay_crosshair_lbl.origin + Vector2(stringwidth("5", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_crosshair_nx, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_crosshair_pr = btn_img_callback(gameplay_crosshair_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_crosshair_pr, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  clean = cvar("cl_hud_alpha");
  gameplay_hudalpha_lbl = lbl_text(MENU_ORG + '125 143', '14 14', strzone(sprintf("%0.2f", clean)), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_hudalpha_lbl.len = cvar("cl_hud_alpha");
  gameplay_hudalpha_up = btn_img_callback(gameplay_hudalpha_lbl.origin + Vector2(stringwidth("9.99", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_hudalpha_dn = btn_img_callback(gameplay_hudalpha_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if( gameplay_hudalpha_lbl.len < 0.1 ){
    gameplay_hudalpha_dn.drawme = FALSE;
  }
  if( gameplay_hudalpha_lbl.len > 0.95 ){
    gameplay_hudalpha_up.drawme = FALSE;
  }
  
  local string colr;
  colr = gameplay_hudcolor_name( cvar("cl_hud_color") );
  gameplay_hudcolor_lbl = lbl_text(MENU_ORG + '125 163', '14 14', strzone(colr), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_hudcolor_lbl.len = cvar("cl_hud_color");
  gameplay_hudcolor_lbl.color_x = cvar("crosshair_color_red");
  gameplay_hudcolor_lbl.color_y = cvar("crosshair_color_green");
  gameplay_hudcolor_lbl.color_z = cvar("crosshair_color_blue");
  gameplay_hudcolor_nx = btn_img_callback(gameplay_hudcolor_lbl.origin + Vector2(stringwidth("PURPLE", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudcolor_nx, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_hudcolor_pr = btn_img_callback(gameplay_hudcolor_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudcolor_pr, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  //gameplay_hud_sway_set = lbl_text('150 263', '14 14 0', strzone(gameplay_hud_sway_mode(cvar("cl_hud_sway"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, 1, 0);
  //gameplay_hud_sway_set.len = cvar("cl_hud_sway");
  //gameplay_hud_sway_more = btn_img_callback('220 263', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_hudsway_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  //gameplay_hud_sway_less = btn_img_callback('176 263', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GAMEPLAY, click_gameplay_hudsway_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  gameplay_back = btn_text_callback(MENU_ORG + '45 190', '16 16', "BACK", VIEW_CTX, M_OPTIONS_GAMEPLAY, click_gameplay_back, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  gameplay_back.fontId = FONT_NUM_XOLONIUM_BOLD;
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
  local vector crossColor;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderString("- Gameplay -", MENU_ORG + menu_parent_center_width(40) - Vector2((stringwidth("- Particle Settings -", 0, '16 16')/2),0), CLR_DEF_WHITE, '16 16', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
    gui_renderString("Field of View:", gameplay_fov_less.origin - Vector2(stringwidth("Field of View:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Show FPS:", gameplay_fps_off.origin - Vector2(stringwidth("Show FPS:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Show Date/Time:", gameplay_datetime_off.origin - Vector2(stringwidth("Show Date/Time:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Crosshair Style:", gameplay_crosshair_pr.origin - Vector2(stringwidth("Crosshair Style:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HUD Alpha:", gameplay_hudalpha_dn.origin - Vector2(stringwidth("HUD Alpha:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HUD Color:", gameplay_hudcolor_pr.origin - Vector2(stringwidth("HUD Color:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    //gui_renderString("HUD Sway Mode:", '74 263', CLR_DEF_WHITE, '14 14 0', 1, 0);

  drawfont = drawfont_prev;

  crossColor_x = cvar("crosshair_color_red");
  crossColor_y = cvar("crosshair_color_green");
  crossColor_z = cvar("crosshair_color_blue");
  
  drawpic(MENU_ORG + '200 125', gameplay_crosshair_lbl.image1 , '64 64', crossColor, gameplay_hudalpha_lbl.len, 0);
  
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
      localcmd("saveconfig\n");
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};