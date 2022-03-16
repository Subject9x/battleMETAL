/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
    Player Setup for multiplayer
*/

float TINT_MIN = 0.2;
float TINT_STEP = 0.05;

#define SETUP_COLOR_PART_CT 1
#define SETUP_COLOR_PART_LT 2
#define SETUP_COLOR_PART_RT 3
#define SETUP_COLOR_PART_LA 4
#define SETUP_COLOR_PART_RA 5
#define SETUP_COLOR_PART_LG 6

float TINT_CT;
float TINT_LT;
float TINT_RT;
float TINT_LA;
float TINT_RA;
float TINT_LG;

float SETUP_COLOR_PART_SELECTED;

float SETUP_COLOR_SHOW;

//Main Menu Globals
entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;

entity setup_team_label;
entity setup_team_value;
entity setup_team_icon;
entity setup_team_prev;
entity setup_team_next;

entity setup_pic_label;



//color tinting
#define TINT_COLOR_TORSO_CENTER "gfx/ui/tint/tint_torso_center.png"
#define TINT_COLOR_TORSO_LEFT   "gfx/ui/tint/tint_torso_left.png"
#define TINT_COLOR_TORSO_RIGHT  "gfx/ui/tint/tint_torso_right.png"
#define TINT_COLOR_ARM_LEFT     "gfx/ui/tint/tint_arm_left.png"
#define TINT_COLOR_ARM_RIGHT    "gfx/ui/tint/tint_arm_right.png"
#define TINT_COLOR_LEGS         "gfx/ui/tint/tint_legs.png"

entity setup_pic_ct;
entity setup_pic_lt;
entity setup_pic_rt;
entity setup_pic_la;
entity setup_pic_ra;
entity setup_pic_lg;

entity setup_color_part_ct_btn;
entity setup_color_part_lt_btn;
entity setup_color_part_rt_btn;
entity setup_color_part_la_btn;
entity setup_color_part_ra_btn;
entity setup_color_part_lg_btn;

entity setup_accept;

//Main Menu Constants
#define IMG_SETUP_TITLE "gfx/menu/setup/setup_title.png"

string(float factionType) setup_set_icon={
  switch(setup_team_value.len){
    case 2:
      return IMG_TEAM_SURVEST;
    
    case 3:
      return IMG_TEAM_MILITAR;
    
    default:
      return IMG_TEAM_PSC;
  }
};

void(float factionType) setup_set_tint={
  local string clientColors;
  switch(factionType){
    case FACTION_SURVEST:
      clientColors = cvar_string("cl_color_srv");
      break;
      
    case FACTION_MILITAR:
      clientColors = cvar_string("cl_color_mil");
      break;
    
    case FACTION_PSC:
      clientColors = cvar_string("cl_color_psc");
      break;
  }
  if( strlen(clientColors) > 0 ){
    tokenizebyseparator(clientColors, " ");
    TINT_CT = fabs(stof(argv(0)));
    TINT_LT = fabs(stof(argv(1)));
    TINT_RT = fabs(stof(argv(2)));
    TINT_LA = fabs(stof(argv(3)));
    TINT_RA = fabs(stof(argv(4)));
    TINT_LG = fabs(stof(argv(5)));
  }
};

void() setup_save_color_scheme={
  local string colorSet;
  
  colorSet = sprintf("%s %s %s %s %s %s", ftos(fabs(setup_pic_ct.len)), ftos(fabs(setup_pic_lt.len)), ftos(fabs(setup_pic_rt.len)), ftos(fabs(setup_pic_la.len)), ftos(fabs(setup_pic_ra.len)), ftos(fabs(setup_pic_lg.len)));
  
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
  localcmd("saveconfig\n");
  if( clientstate() == CS_CONNECTED ){
    //send update to client, and then eventually the server.
    
    localcmd("cl_cmd tint");
  }
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
    freeGlobalString(self.data_text)
    cvar_set("_cl_name", "DEAD_HAND");
    cacheGlobalString(  self.data_text, str_cvar("_cl_name"))
  }
};

void() setup_color_show_grid={
  SETUP_COLOR_SHOW = TRUE;
  
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    if(widget.subid == TRUE){
      widget.drawme = TRUE;
    }
    widget = widget.chain;
  }
};

void() setup_color_hide_grid={
  SETUP_COLOR_SHOW = FALSE;
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    if(widget.subid == TRUE){
      widget.drawme = FALSE;
    }
    widget = widget.chain;
  }
};

void(float selectTeam) setup_team_set={
  setup_save_color_scheme();
  
  setup_team_value.len = selectTeam;
  
  setup_set_tint( setup_team_value.len );
  
  setup_team_icon.image1 = setup_set_icon( setup_team_value.len );

  setup_pic_ct.color = CLR_PLAYER_LIST[TINT_CT];
  setup_pic_ct.len = TINT_CT;
  
  setup_pic_lt.color = CLR_PLAYER_LIST[TINT_LT];
  setup_pic_lt.len = TINT_LT;
  
  setup_pic_rt.color = CLR_PLAYER_LIST[TINT_RT];
  setup_pic_rt.len = TINT_RT;
  
  setup_pic_la.color = CLR_PLAYER_LIST[TINT_LA];
  setup_pic_la.len = TINT_LA;
  
  setup_pic_ra.color = CLR_PLAYER_LIST[TINT_RA];
  setup_pic_ra.len = TINT_RA;
  
  setup_pic_lg.color = CLR_PLAYER_LIST[TINT_LG];
  setup_pic_lg.len = TINT_LG;
  
  setup_color_hide_grid();
  
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

void() setup_team_prev_f={
  local float prevTeam;
  prevTeam = setup_team_value.len - 1;
  if( prevTeam < 1 ){
    prevTeam = 3;
  }
  setup_team_set(prevTeam);
};

void() setup_team_next_f={
  local float nextTeam;
  nextTeam = setup_team_value.len + 1;
  if( nextTeam > 3 ){
    nextTeam = 1;
  }
  setup_team_set(nextTeam);
};


void() setup_color_pick_color={
  switch(SETUP_COLOR_PART_SELECTED){
    case SETUP_COLOR_PART_LT:
      TINT_LT = self.len;
      setup_pic_lt.color =  CLR_PLAYER_LIST[TINT_LT];
      setup_pic_lt.len = TINT_LT;
      break;
    
    case SETUP_COLOR_PART_RT:
      TINT_RT = self.len;
      setup_pic_rt.color = CLR_PLAYER_LIST[TINT_RT];
      setup_pic_rt.len = TINT_RT;
      break;
    
    case SETUP_COLOR_PART_LA:
      TINT_LA = self.len;
      setup_pic_la.color =  CLR_PLAYER_LIST[TINT_LA];
      setup_pic_la.len = TINT_LA;
      break;
   
    case SETUP_COLOR_PART_RA:
      TINT_RA = self.len;
      setup_pic_ra.color =  CLR_PLAYER_LIST[TINT_RA];
      setup_pic_ra.len = TINT_RA;
      break;
      
    case SETUP_COLOR_PART_LG:
      TINT_LG = self.len;
      setup_pic_lg.color = CLR_PLAYER_LIST[TINT_LG];
      setup_pic_lg.len = TINT_LG;
      break;
    
    default:
      TINT_CT = self.len;
      setup_pic_ct.color = CLR_PLAYER_LIST[TINT_CT];
      setup_pic_ct.len = TINT_CT;
      break;
  }
};

void() setup_color_select_ct={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_CT;
  setup_color_show_grid();
};
void() setup_color_select_lt={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_LT;
  setup_color_show_grid();
};
void() setup_color_select_rt={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_RT;
  setup_color_show_grid();
};
void() setup_color_select_la={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_LA;
  setup_color_show_grid();
};
void() setup_color_select_ra={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_RA;
  setup_color_show_grid();
};
void() setup_color_select_lg={
  SETUP_COLOR_PART_SELECTED = SETUP_COLOR_PART_LG;
  setup_color_show_grid();
};

void(entity elm) setup_draw_color_highlight={
  local float drawPanel;
  drawPanel = FALSE;
  
  switch(SETUP_COLOR_PART_SELECTED){
    case SETUP_COLOR_PART_LT:
      if( elm.len == TINT_LT ){
        drawPanel = TRUE;
      }
      break;
    
    case SETUP_COLOR_PART_RT:
      if( elm.len == TINT_RT ){
        drawPanel = TRUE;
      }
      break;
    
    case SETUP_COLOR_PART_LA:
      if( elm.len == TINT_LA ){
        drawPanel = TRUE;
      }
      break;
   
    case SETUP_COLOR_PART_RA:
      if( elm.len == TINT_RA ){
        drawPanel = TRUE;
      }
      break;
      
    case SETUP_COLOR_PART_LG:
      if( elm.len == TINT_LG ){
        drawPanel = TRUE;
      }
      break;
    
    case SETUP_COLOR_PART_CT:
      if( elm.len == TINT_CT ){
        drawPanel = TRUE;
      }
      break;
  }
  if( drawPanel ){
    drawpic(elm.origin - '4 4', "gfx/ui/box_64.png", '22 22', '1 1 0.5', 1.0 , 0);
  }
};

// ini functions
void() m_setup_i={
  
  menu_parent_setup(VIEW_ORG + '0 20', '432 416');
  
  setup_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_SETUP_TITLE, '1 1 1', VIEW_CTX, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  
  setup_label_playername = lbl_text(MENU_ORG + '10 45', '12 12', "Player Name : ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  
  setup_txtfld_playername = inp_textfield(setup_label_playername.origin + Vector2(stringwidth("Player Name :   ", 0, '12 12'), 0), '14 14', 24, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_UPP));
  cacheGlobalString( setup_txtfld_playername.data_text, str_cvar("_cl_name") )
  
  setup_team_label = lbl_text(MENU_ORG + '10 115', '12 12', "TDM Team Colors : ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  setup_team_value = lbl_text(setup_team_label.origin + Vector2(stringwidth("TDM Team Colors : ", 0, '12 12') + 128, 0), '12 12', "", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  setup_team_value.len = cvar("cl_team");
  
  setup_team_icon = lbl_img(setup_team_value.origin, '96 96', setup_set_icon(setup_team_value.len), '1 1 1', 0, M_SETUP, 1, UI_FLAG_IMG_SIZE_ASPECT | UI_FLAG_CENTER_IMG );
  
  setup_team_prev = btn_img_callback(setup_team_value.origin - '64 0', '14 14', UI_IMG_ARW_LFT, 0, M_SETUP, setup_team_prev_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_team_next = btn_img_callback(setup_team_value.origin + '64 0', '14 14', UI_IMG_ARW_RGT, 0, M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  setup_pic_label = lbl_text(MENU_ORG + '10 160', '16 16', "Player Color Tint", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, UI_FLAG_SIZE_IMG);
  
  setup_set_tint(setup_team_value.len);
  
  local vector tintOfs;
  tintOfs = '125 195';
  
  setup_pic_ct = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_torso_center.png", CLR_PLAYER_LIST[TINT_CT], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_ct.len = TINT_CT;
  
  setup_pic_lt = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_torso_left.png", CLR_PLAYER_LIST[TINT_LT], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_lt.len = TINT_LT;
  
  setup_pic_rt = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_torso_right.png", CLR_PLAYER_LIST[TINT_RT], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_rt.len = TINT_RT;
  
  setup_pic_la = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_arm_left.png", CLR_PLAYER_LIST[TINT_LA], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_la.len = TINT_LA;
  
  setup_pic_ra = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_arm_right.png", CLR_PLAYER_LIST[TINT_RA], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_ra.len = TINT_RA;
  
  setup_pic_lg = lbl_img(MENU_ORG + tintOfs, '2 2 0', "gfx/ui/tint/tint_legs.png", CLR_PLAYER_LIST[TINT_LG], 0, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  setup_pic_lg.len = TINT_LG;


  setup_color_part_ct_btn = btn_text_callback(MENU_ORG + '10 195', '16 16', "Center Torso", 0, M_SETUP, setup_color_select_ct, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_ct_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_ct_btn.len = SETUP_COLOR_PART_CT;
  
  setup_color_part_lt_btn = btn_text_callback(MENU_ORG + '10 220', '16 16', "Left Torso", 0, M_SETUP, setup_color_select_lt, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_lt_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_lt_btn.len = SETUP_COLOR_PART_LT;
  
  setup_color_part_rt_btn = btn_text_callback(MENU_ORG + '10 245', '16 16', "Right Torso", 0, M_SETUP, setup_color_select_rt, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_rt_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_rt_btn.len = SETUP_COLOR_PART_RT;
  
  setup_color_part_la_btn = btn_text_callback(MENU_ORG + '10 270', '16 16', "Left Arm", 0, M_SETUP, setup_color_select_la, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_la_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_la_btn.len = SETUP_COLOR_PART_LA;
  
  setup_color_part_ra_btn = btn_text_callback(MENU_ORG + '10 295', '16 16', "Right Arm", 0, M_SETUP, setup_color_select_ra, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_ra_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_ra_btn.len = SETUP_COLOR_PART_RA;
  
  setup_color_part_lg_btn = btn_text_callback(MENU_ORG + '10 320', '16 16', "Legs", 0, M_SETUP, setup_color_select_lg, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_color_part_lg_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  setup_color_part_lg_btn.len = SETUP_COLOR_PART_LG;
  
  local entity colorGrid;
  local float row, col;
  local vector startOrg;
  local float idx;

  startOrg = MENU_ORG + '250 195';
  for(row=0; row < 14; row = row + 1){
    for(col=0; col < 10; col = col + 1){
      idx = (row * 10) + col;
      if( idx < CLR_PLAYER_MAX ){
        colorGrid = btn_img_callback(startOrg + Vector2(col * 20, row * 20), '14 14', "", 0, M_SETUP, setup_color_pick_color, CLR_PLAYER_LIST[idx], CLR_PLAYER_LIST[idx] * 1.5, 1, UI_FLAG_NOLABEL);
        colorGrid.len = idx;
        colorGrid.subid = 1;
        colorGrid.drawme = FALSE;
      }
    }
  }
  
  setup_accept = btn_text_callback(MENU_ORG + '45 395', '16 16', "SAVE", VIEW_CTX, M_SETUP, click_setup_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_accept.fontId = FONT_NUM_XOLONIUM_BOLD;
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
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawfont = drawfont_prev;
  
  
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    if( widget.subid == 1 && SETUP_COLOR_SHOW){
      setup_draw_color_highlight(widget);
    }
    widget.draw(widget);
    widget = widget.chain;
  }
  
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
      localcmd("saveconfig\n");
      if( MAIN_MISSION ) {
        m_main_f();
      }
      else{
        m_multi_f();
      }
      break;
  }
};