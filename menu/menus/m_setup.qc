/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
    Player Setup for multiplayer
*/

float TINT_MIN = 0.2;
float TINT_STEP = 0.05;

float TINT_CT;
float TINT_LT;
float TINT_RT;
float TINT_LA;
float TINT_RA;
float TINT_LG;

//Main Menu Globals
entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;

entity setup_team_label;
entity setup_team_value;
entity setup_team_prev;
entity setup_team_next;

entity setup_pic_label;

//color tinting
string TINT_COLOR_TORSO_CENTER  = "gfx/ui/tint/tint_torso_center.png";
string TINT_COLOR_TORSO_LEFT    = "gfx/ui/tint/tint_torso_left.png";
string TINT_COLOR_TORSO_RIGHT   = "gfx/ui/tint/tint_torso_right.png";
string TINT_COLOR_ARM_LEFT      = "gfx/ui/tint/tint_arm_left.png";
string TINT_COLOR_ARM_RIGHT     = "gfx/ui/tint/tint_arm_right.png";
string TINT_COLOR_LEGS          = "gfx/ui/tint/tint_legs.png";

entity setup_pic_ct;
entity setup_pic_lt;
entity setup_pic_rt;
entity setup_pic_la;
entity setup_pic_ra;
entity setup_pic_lg;

entity setup_color_ct_up;
entity setup_color_ct_dn;

entity setup_color_lt_up;
entity setup_color_lt_dn;

entity setup_color_rt_up;
entity setup_color_rt_dn;

entity setup_color_la_up;
entity setup_color_la_dn;

entity setup_color_ra_up;
entity setup_color_ra_dn;

entity setup_color_lg_up;
entity setup_color_lg_dn;

entity setup_accept;

//Main Menu Constants
string IMG_SETUP_TITLE  = "gfx/menu/setup/setup_title.png";

void(float factionType) setup_set_tint={
  local string clientColors;
  switch(factionType){
    case 2:
      clientColors = cvar_string("cl_color_srv");
      break;
      
    case 3:
      clientColors = cvar_string("cl_color_mil");
      break;
    
    default:
      clientColors = cvar_string("cl_color_psc");
      break;
  }
  if( strlen(clientColors) > 0 ){
    tokenizebyseparator(clientColors, " ");
    TINT_CT = rint(stof(argv(0)));
    TINT_LT = rint(stof(argv(1)));
    TINT_RT = rint(stof(argv(2)));
    TINT_LA = rint(stof(argv(3)));
    TINT_RA = rint(stof(argv(4)));
    TINT_LG = rint(stof(argv(5)));
  }
};

void() setup_save_color_scheme={
  local string colorSet;
  
  colorSet = strcat(ftos(fabs(setup_pic_ct.len)), " ", ftos(fabs(setup_pic_lt.len))," ", ftos(fabs(setup_pic_rt.len)));
  colorSet = strcat(colorSet, " ", ftos(fabs(setup_pic_la.len)), " ", ftos(fabs(setup_pic_ra.len)), " ");
  colorSet = strcat(colorSet, ftos(fabs(setup_pic_lg.len)));
  
  switch(setup_team_value.len){
    case 2:
      cvar_set("cl_color_srv", colorSet);
      break;
      
    case 3:
      cvar_set("cl_color_mil", colorSet);
      break;
    
    default:
      cvar_set("cl_color_psc", colorSet);
      break;
  }
};

//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
/*void() click_newg_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  localsound("sound/misc/menu2.wav");
};*/
void() click_setup_accept={
  setup_save_color_scheme();
  menu_clear_items(M_STATE);
  if( MAIN_MISSION ) {
    m_main_f();
  }
  else{
    m_multi_f();
  }
};

void() textfield_setup_name={
  if( strlen(self.data_text) > 0 ){
    cvar_set("_cl_name", self.data_text);
  }
  else{
    cvar_set("_cl_name", "DEAD_HAND");
    cacheGlobalString(  self.data_text, str_cvar("_cl_name"));
  }
};

void() setup_team_prev_f={
  setup_save_color_scheme();
  setup_team_value.len = setup_team_value.len - 1;
  if( setup_team_value.len < 1 ){
    setup_team_value.len = 3;
  }
  setup_set_tint( setup_team_value.len);
  
  setup_pic_ct.color = CLR_PLAYER_LIST[TINT_CT];
  setup_pic_ct.len = TINT_CT;
  
  setup_pic_lt.color =  CLR_PLAYER_LIST[TINT_LT];
  setup_pic_lt.len = TINT_LT;
  
  setup_pic_rt.color =  CLR_PLAYER_LIST[TINT_RT];
  setup_pic_rt.len = TINT_RT;
  
  setup_pic_la.color =  CLR_PLAYER_LIST[TINT_LA];
  setup_pic_la.len = TINT_LA;
  
  setup_pic_ra.color =  CLR_PLAYER_LIST[TINT_RA];
  setup_pic_ra.len = TINT_RA;
  
  setup_pic_lg.color =  CLR_PLAYER_LIST[TINT_LG];
  setup_pic_lg.len = TINT_LG;
  
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

void() setup_team_next_f={
  setup_save_color_scheme();
  setup_team_value.len = setup_team_value.len + 1;
  if( setup_team_value.len > 3 ){
    setup_team_value.len = 1;
  }
  setup_set_tint( setup_team_value.len);
    
  setup_pic_ct.color = CLR_PLAYER_LIST[TINT_CT];
  setup_pic_ct.len = TINT_CT;
  
  setup_pic_lt.color =  CLR_PLAYER_LIST[TINT_LT];
  setup_pic_lt.len = TINT_LT;
  
  setup_pic_rt.color =  CLR_PLAYER_LIST[TINT_RT];
  setup_pic_rt.len = TINT_RT;
  
  setup_pic_la.color =  CLR_PLAYER_LIST[TINT_LA];
  setup_pic_la.len = TINT_LA;
  
  setup_pic_ra.color =  CLR_PLAYER_LIST[TINT_RA];
  setup_pic_ra.len = TINT_RA;
  
  setup_pic_lg.color =  CLR_PLAYER_LIST[TINT_LG];
  setup_pic_lg.len = TINT_LG;
  
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

void() setup_color_next={
  self.targ.len = self.targ.len + 1;
  if( self.targ.len > 21 ){
    self.targ.len = 1;
    self.targ.len = self.targ.len - 1; //ha
  }
  self.targ.color = CLR_PLAYER_LIST[self.targ.len];
};

void() setup_color_prev={
  self.targ.len = self.targ.len - 1;
  if( self.targ.len < 1 && self.targ.len > -1 ){
    self.targ.len = fabs(self.targ.len);  // blech, -0.0 bug
  }
  if( self.targ.len < 0 ){
    self.targ.len = 21;
  }
  self.targ.color = CLR_PLAYER_LIST[self.targ.len];
};

// ini functions
void() m_setup_i={
  setup_title = lbl_img('10 30', '1 1 0', IMG_SETUP_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_SETUP, 1, (UI_FLAG_SIZE_IMG) );
  setup_label_playername = lbl_text('10 72 0', '12 12 0', "Player Name : ", '1 1 1', 0, M_SETUP, 1, 0);
  
  setup_txtfld_playername = inp_textfield('150 70', '14 14 0', 24, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_UPP));
  cacheGlobalString( setup_txtfld_playername.data_text, str_cvar("_cl_name") )
  
  setup_team_label = lbl_text('10 95 0', '12 12 0', "Preferred TDM Team : ", '1 1 1', 0, M_SETUP, 1, 0);
  setup_team_value = lbl_text('200 115 0', '12 12 0', ftos(cvar("cl_team")), '1 1 1', 0, M_SETUP, 1, 0);
  setup_team_value.len = cvar("cl_team");
  setup_team_prev = btn_img_callback('150 105 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_team_next = btn_img_callback('265 105 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  setup_pic_label = lbl_text('10 160 0', '12 12 0', "Player Color Tint : ", '1 1 1', 0, M_SETUP, 1, 0);
  
  setup_set_tint(setup_team_value.len);
  
  setup_pic_ct = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_torso_center.png", CLR_PLAYER_LIST[TINT_CT], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_ct.len = TINT_CT;
  
  setup_pic_lt = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_torso_left.png", CLR_PLAYER_LIST[TINT_LT], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_lt.len = TINT_LT;
  
  setup_pic_rt = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_torso_right.png", CLR_PLAYER_LIST[TINT_RT], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_rt.len = TINT_RT;
  
  setup_pic_la = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_arm_left.png", CLR_PLAYER_LIST[TINT_LA], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_la.len = TINT_LA;
  
  setup_pic_ra = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_arm_right.png", CLR_PLAYER_LIST[TINT_RA], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_ra.len = TINT_RA;
  
  setup_pic_lg = lbl_img('175 195', '2 2 0', "gfx/ui/tint/tint_legs.png", CLR_PLAYER_LIST[TINT_LG], (VIEW_CTX | VIEW_CTY), M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_lg.len = TINT_LG;

  setup_color_ct_dn = btn_img_callback('75 195 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_ct_up = btn_img_callback('140 195 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_ct_dn.targ = setup_pic_ct;
  setup_color_ct_up.targ = setup_pic_ct;
 
  setup_color_lt_dn = btn_img_callback('75 230 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_lt_up = btn_img_callback('140 230 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_lt_dn.targ = setup_pic_lt;
  setup_color_lt_up.targ = setup_pic_lt;
  
  setup_color_rt_dn = btn_img_callback('75 265 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_rt_up = btn_img_callback('140 265 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_rt_dn.targ = setup_pic_rt;
  setup_color_rt_up.targ = setup_pic_rt;
    
  setup_color_la_dn = btn_img_callback('75 300 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_la_up = btn_img_callback('140 300 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_la_dn.targ = setup_pic_la;
  setup_color_la_up.targ = setup_pic_la;
    
  setup_color_ra_dn = btn_img_callback('75 335 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_ra_up = btn_img_callback('140 335 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_ra_dn.targ = setup_pic_ra;
  setup_color_ra_up.targ = setup_pic_ra;
   
  setup_color_lg_dn = btn_img_callback('75 370 0', '14 18', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_lg_up = btn_img_callback('140 370 0', '14 18', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_SETUP, setup_color_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_color_lg_dn.targ = setup_pic_lg;
  setup_color_lg_up.targ = setup_pic_lg;
  
  
  setup_accept = btn_img_callback('10 405 0', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_SETUP, click_setup_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
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
  
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  switch(setup_team_value.len){
    case 2:
      drawpic( gui_percentToPixelRawVec('175 110'), IMG_TEAM_SURVEST, gui_percentToPixelRawVec('75 60'), '1 1 1', 1, 0);
      break;
    
    case 3:
      drawpic( gui_percentToPixelRawVec('175 110'), IMG_TEAM_MILITAR, gui_percentToPixelRawVec('75 55'), '1 1 1', 1, 0);
      break;
    
    default:
      drawpic( gui_percentToPixelRawVec('175 110'), IMG_TEAM_PSC, gui_percentToPixelRawVec('75 60'), '1 1 1', 1, 0);
      break;
  }
  gui_renderString("Center Torso", setup_color_ct_dn.origin + gui_percentToPixelRawVec('-64 3'), '1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_ct_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_ct.len], 1, 0);
  
  gui_renderString("Left Torso", setup_color_lt_dn.origin + gui_percentToPixelRawVec('-64 3'), '1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_lt_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_lt.len], 1, 0);
  
  gui_renderString("Right Torso", setup_color_rt_dn.origin + gui_percentToPixelRawVec('-64 3'),'1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_rt_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_rt.len], 1, 0);
  
  gui_renderString("Left Arm", setup_color_la_dn.origin + gui_percentToPixelRawVec('-64 3'), '1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_la_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_la.len], 1, 0);
  
  gui_renderString("Right Arm", setup_color_ra_dn.origin + gui_percentToPixelRawVec('-64 3'), '1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_ra_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_ra.len], 1, 0);
  
  gui_renderString("Legs", setup_color_lg_dn.origin + gui_percentToPixelRawVec('-64 3'), '1 1 1', '12 12 0', 1, 0);
  drawfill(setup_color_lg_dn.origin + gui_percentToPixelRawVec('24 0'), gui_percentToPixelRawVec('32 16'), CLR_PLAYER_LIST[setup_pic_lg.len], 1, 0);
  
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
      setup_save_color_scheme();
      cmd("saveconfig\n");
      if( MAIN_MISSION ) {
        m_main_f();
      }
      else{
        m_multi_f();
      }
      break;
  }
};