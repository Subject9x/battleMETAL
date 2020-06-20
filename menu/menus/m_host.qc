/*
battleMETAL
Author: Peter Roohr
Date: 4/15/2018
Overview: 
  host game menu
*/

//constants
float FRAG_MAX = 1000;
float TIME_MAX = 20;
float SUB_COOP = 2;
float SUB_DM  = 3;
float SUB_TDM = 4;
float PLRS_MAX_COOP = 4;
float PLRS_MIN_COOP = 2;
float PLRS_MAX_TDM = 16;
float PLRS_MIN_TDM = 2;
float RATE_MAX = 80000;

float SELECT_TYPE;
float SELECT_PLAYERS;
float SELECT_SKILL;
float SELECT_RATE;

float SELECT_MAP;

string PUBLIC_TYPE;

//globals
entity host_title;

entity host_name;

entity host_port;

entity host_public;
entity host_type_nxt;
entity host_type_prev;

entity host_serverrate;
entity host_rate_up;
entity host_rate_dn;

entity host_gametype;
entity host_gametype_next;
entity host_gametype_prev;

entity host_playernum;
entity host_playermor;
entity host_playerles;

//coop settings
entity host_skill_lbl;
entity host_skill_next;
entity host_skill_prev;

entity host_map_lbl;
entity host_map_nxt;
entity host_map_prev;

//non-coop settings
entity host_dm_fraglim;
entity host_dm_timelim;

entity host_launch;
entity host_back;
//images
string IMG_HOST_TITLE = "gfx/menu/host/host_title.png";

//custom funcs
void() host_update_type={
  switch(SELECT_TYPE){
    case 1:
      cvar_set("sv_public", ftos(-1));
      break;
    case 2:
      cvar_set("sv_public", ftos(0));
      break;
    case 3:
      cvar_set("sv_public", ftos(1));
      break;
  }
};

void() host_update_playeramount={
  if( SUB_MENU == SUB_COOP ){
    host_map_lbl.label = strzone(MAPS_COOP[SELECT_MAP]);
    cvar_set("coop", "1");
    cvar_set("deathmatch", "0");
    cvar_set("teamplay", "0");
    if( SELECT_PLAYERS > PLRS_MAX_COOP ){
      SELECT_PLAYERS = PLRS_MAX_COOP;
    }
    if( SELECT_PLAYERS < PLRS_MIN_COOP ){
      SELECT_PLAYERS = PLRS_MIN_COOP;
    }
  }
  else if( SUB_MENU == SUB_TDM ){
    host_dm_fraglim.subid = SUB_TDM;  //hack-fraud
    host_dm_timelim.subid = SUB_TDM;
    host_map_lbl.label = strzone(MAPS_TDM[SELECT_MAP]);
    cvar_set("coop", "0");
    cvar_set("deathmatch", "1");
    cvar_set("teamplay", "1");
    if( SELECT_PLAYERS > PLRS_MAX_TDM ){
      SELECT_PLAYERS = PLRS_MAX_TDM;
    }
    if( SELECT_PLAYERS < PLRS_MIN_TDM ){
      SELECT_PLAYERS = PLRS_MIN_TDM;
    }
  }
  else if( SUB_MENU == SUB_DM ){
    host_dm_fraglim.subid = SUB_DM;
    host_dm_timelim.subid = SUB_DM;
    host_map_lbl.label = strzone(MAPS_TDM[SELECT_MAP]);
    cvar_set("coop", "0");
    cvar_set("deathmatch", "1");
    cvar_set("teamplay", "0");
    if( SELECT_PLAYERS > PLRS_MAX_TDM ){
      SELECT_PLAYERS = PLRS_MAX_TDM;
    }
    if( SELECT_PLAYERS < PLRS_MIN_TDM ){
      SELECT_PLAYERS = PLRS_MIN_TDM;
    }
  }
  cmd("maxplayers ", ftos(SELECT_PLAYERS));
  strunzone(host_playernum.label);
  host_playernum.label = strzone(ftos(SELECT_PLAYERS));
  host_playernum.subid = SUB_MENU;
  host_playermor.subid = SUB_MENU;
  host_playerles.subid = SUB_MENU;
  host_map_lbl.subid = SUB_MENU;
  host_map_nxt.subid = SUB_MENU;
  host_map_prev.subid = SUB_MENU;
};

void(float skl) host_update_skilllbl={
  switch(skl){
    case 0:
      host_skill_lbl.label = "NOVICE";
      host_skill_lbl.color = CLR_DEF_BLUE;
      break;
    case 1:
      host_skill_lbl.label = "REGULAR";
      host_skill_lbl.color = CLR_DEF_GREEN;
      break;
    case 2:
      host_skill_lbl.label = "VETERAN";
      host_skill_lbl.color = CLR_DEF_ARM_THREEQ;
      break;
    case 3:
      host_skill_lbl.label = "FULL METAL";
      host_skill_lbl.color = CLR_DEF_RED;
      break;
  }
};

void(float rte) host_update_rate={
  
  cmd("rate ", ftos(HOST_RATE_TABLE[rte]));
  host_serverrate.len = HOST_RATE_TABLE[rte];
};

//callbacks
void() host_servername={
  cvar_set("hostname", self.data_text);
};

void() host_portnum={
  cvar_set("port", self.data_text);
};

void() click_host_public_next={
  SELECT_TYPE = SELECT_TYPE + 1;
  if( SELECT_TYPE >= 3 ){
    SELECT_TYPE = 3;
    host_type_nxt.drawme = FALSE;
    host_type_prev.drawme = TRUE;
  }
  else{
    host_type_nxt.drawme = TRUE;
  }
  host_update_type();
  
};
void() click_host_public_prev={
  SELECT_TYPE = SELECT_TYPE - 1;
  if( SELECT_TYPE <= 1 ){
    SELECT_TYPE = 1;
    host_type_nxt.drawme = TRUE;
    host_type_prev.drawme = FALSE;
  }
  else{
    host_type_prev.drawme = TRUE;
  }
  host_update_type();
};

void() click_host_rate_up={
  SELECT_RATE = SELECT_RATE + 1;
  if( SELECT_RATE > 10 ){
    SELECT_RATE = 11;
  }
  host_update_rate(SELECT_RATE);
};
void() click_host_rate_down={
  SELECT_RATE = SELECT_RATE - 1;
  if( SELECT_RATE < 2){
    SELECT_RATE = 1;
  }
  host_update_rate(SELECT_RATE);
};

void() click_host_more_plrs={
  SELECT_PLAYERS = SELECT_PLAYERS + 1;
  host_update_playeramount();
};

void() click_host_less_plrs={
  SELECT_PLAYERS = SELECT_PLAYERS - 1;
  host_update_playeramount();
};

void() click_host_nexttype={
  SUB_MENU = SUB_MENU + 1;
  if(SUB_MENU >= 4){
    SUB_MENU = 4;
    host_gametype_next.drawme = FALSE;
    host_gametype_prev.drawme = TRUE;
  }
  else{
    host_gametype_next.drawme = TRUE;
  }
  map_list_getmap((SUB_MENU==SUB_COOP));
  SELECT_MAP = 1;
  host_update_playeramount();
};

void() click_host_prevtype={
  SUB_MENU = SUB_MENU - 1;
  if(SUB_MENU <= 2){
    SUB_MENU = 2;
    host_gametype_next.drawme = TRUE;
    host_gametype_prev.drawme = FALSE;
  }
  else{
    host_gametype_prev.drawme = TRUE;
  }
  
  map_list_getmap((SUB_MENU==SUB_COOP));
  SELECT_MAP = 1;
  host_update_playeramount();
};

//coop callbacks
void() click_host_nextskill={
  SELECT_SKILL = SELECT_SKILL + 1;
  if( SELECT_SKILL > 3 ){
    SELECT_SKILL = 0;
  }
  host_update_skilllbl(SELECT_SKILL);
};

void() click_host_prevskill={
  SELECT_SKILL = SELECT_SKILL - 1;
  if( SELECT_SKILL < 0 ){
    SELECT_SKILL = 3;
  }
  host_update_skilllbl(SELECT_SKILL);
};

void() click_host_map_nxt={
  local string check;
  local float test;
  
  test = SELECT_MAP + 1;
  if( SUB_MENU != SUB_COOP ){
    check = MAPS_TDM[test];
  }else{
    check = MAPS_COOP[test];
  }
  if(test > 128){
    test = 128;
  }
  if(check != ""){
    strunzone(host_map_lbl.label);
    host_map_lbl.label = strzone(check);
    SELECT_MAP = test;
  }
};

void() click_host_map_prv={
  local string check;
  local float test;
  
  test = SELECT_MAP - 1;
  if( SUB_MENU != SUB_COOP ){
    check = MAPS_TDM[test];
  }else{
    check = MAPS_COOP[test];
  }
  if(test < 0){
    test = 0;
  }
  if(check != ""){
    strunzone(host_map_lbl.label);
    host_map_lbl.label = strzone(check);
    SELECT_MAP = test;
  }
};

void() host_frag_limit={
  cvar_set("fraglimit", self.data_text);
};

void() host_time_limit={
  cvar_set("timelimit", self.data_text);
};

void() click_host_back={
  menu_clear_items(M_STATE);
  m_multi_f();
};

void() click_host_launch={
  menu_clear_items(M_STATE);
  setkeydest(KEY_GAME);
  cvar_set("skill", ftos(SELECT_SKILL));
  cmd("map", strcat(" ", host_map_lbl.label));
};

void() m_host_i={
  PUBLIC_TYPE = "debug";
  
  host_title = lbl_img('10 90', '1 1 0', IMG_HOST_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_HOST, 1, (UI_FLAG_SIZE_IMG) );
  
  host_name = inp_textfield('100 133', '14 14 0', 48, host_servername, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC) );
  if( str_cvar("hostname") == ""){
    host_name.data_text = strzone("UNNAMED");
  }
  else{
    host_name.data_text = strzone(str_cvar("hostname"));
  }
  
  host_port = inp_textfield('100 153', '14 14 0', 16, host_portnum, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_port.data_text = strzone(str_cvar("port"));
  
  SELECT_TYPE = 3;
  host_public = lbl_text('120 173', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_type_nxt = btn_img_callback('180 173 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_public_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_type_prev = btn_img_callback('100 173 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_public_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  cvar_set("sv_public", "1");
  
  host_serverrate = lbl_text('120 193', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  local float rate;
  rate = cvar("rate");
  host_serverrate.len = SELECT_RATE = rate;
  
  host_rate_up = btn_img_callback('200 193 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_rate_dn = btn_img_callback('100 193 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_rate_down, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  SUB_MENU = SUB_COOP;
  
  host_gametype = lbl_text('120 213', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_gametype_next = btn_img_callback('230 213 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_nexttype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_gametype_prev = btn_img_callback('100 213 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_prevtype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum = lbl_text('120 233', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_playernum.label = strzone(ftos(cvar("maxplayers")));
  host_playermor = btn_img_callback('140 233 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_more_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_playerles = btn_img_callback('100 233 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_less_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum.subid = SUB_COOP;
  host_playermor.subid = SUB_COOP;
  host_playerles.subid = SUB_COOP;
  
  //map selector
  SELECT_MAP = 1;
  host_map_lbl = lbl_text('120 253', '14 14 0', " ", CLR_DEF_IIF_FRIEND, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_map_lbl.label = strzone(map_list_getmap(0));
  
  host_map_nxt = btn_img_callback('180 253 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_map_nxt, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_prev = btn_img_callback('100 253 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_map_prv, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_lbl.subid = SUB_COOP;
  host_map_nxt.subid = SUB_COOP;
  host_map_prev.subid = SUB_COOP;
  
  //COOP SUB MENU
  host_skill_lbl = lbl_text('120 273', '14 14 0', "NOVICE", CLR_DEF_BLUE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_skill_next = btn_img_callback('200 273 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_nextskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_prev = btn_img_callback('100 273 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_prevskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_lbl.subid = SUB_COOP;
  host_skill_next.subid = SUB_COOP;
  host_skill_prev.subid = SUB_COOP;
  
  //TDM SUB MENU
  host_dm_fraglim = inp_textfield('140 273', '14 14 0', 3, host_frag_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_dm_fraglim.data_text = strzone(ftos(cvar("fraglimit")));
  
  host_dm_timelim = inp_textfield('140 293', '14 14 0', 3, host_time_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_dm_timelim.data_text = strzone(ftos(cvar("timelimit")));

  host_dm_fraglim.subid = SUB_TDM;
  host_dm_timelim.subid = SUB_TDM;

  //LAAAAAAAAUNCH!
  host_launch = btn_img_callback('140 313 0', '96 16', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_launch, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL));
  //or not
  host_back = btn_img_callback('25 313 0', '56 12', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
};

void() m_host_f={
  SELECT_SKILL = 0;
  SELECT_TYPE = 0;
  SELECT_MAP = 1;
  map_list_getmap(FALSE);
  map_list_getmap(TRUE);
  M_STATE = M_HOST;
  setkeydest(KEY_MENU);
  m_host_i();
};

void() m_host_d={

  PUBLIC_TYPE = "";

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  gui_renderString("Server Name  :", host_name.origin + gui_percentToPixelRawVec('-80 1'), '1 1 1', '12 12 0', 1, 0);
  
  gui_renderString("Port Number  :", host_port.origin + gui_percentToPixelRawVec('-80 1'), '1 1 1', '12 12 0', 1, 0);
  gui_renderString("[You will need to port-forward this on your router]", host_port.origin + gui_percentToPixelRawVec('110 0'), '1 1 0.1', '12 12 0', 1, 0);
  
  gui_renderString("Server Type  :", host_public.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
  
  switch(SELECT_TYPE){
    case 1:
      PUBLIC_TYPE = "[Completely local, inaccessible from any other client.]";
      host_public.label = "LOCAL";
      break;
    case 2:
      PUBLIC_TYPE = "[Players connect to your IP directly.]";
      host_public.label = "PRIVATE";
      break;
    case 3:
      PUBLIC_TYPE = "[Anyone browsing the Server List will see this game.]";
      host_public.label = "PUBLIC";
      break;
  }
  
  gui_renderString(PUBLIC_TYPE, host_public.origin + gui_percentToPixelRawVec('85 1'), '1 1 0.1', '12 12 0', 1, 0);
  
  host_serverrate.label = strcat(sprintf("%2.2f", host_serverrate.len), " Kbps");
  gui_renderString("Server Rate  :", host_serverrate.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
  gui_renderString("Game Type  :", host_gametype.origin + gui_percentToPixelRawVec('-95 1'), '1 1 1', '12 12 0', 1, 0);

  //kids, this is why implemnt _d funcs for every menu, some need a little extra functionality
  switch(SUB_MENU){
    case SUB_COOP:
      gui_renderString("Max Players  :", host_playernum.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "Cooperative";
      host_gametype.color = CLR_DEF_IIF_FRIEND;
      gui_renderString("Difficulty  :", host_skill_lbl.origin + gui_percentToPixelRawVec('-90 1'), '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Start Map  :", host_map_lbl.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      if( host_map_lbl.label != "" ){
        drawpic(host_map_lbl.origin + gui_percentToPixelRawVec('120 -64'), strcat("data/maps/",host_map_lbl.label,"/",host_map_lbl.label,".png"), '256 256', '1 1 1', 1, 0);
      }
      break;
    
    case SUB_TDM:
      gui_renderString("Max Players  :", host_playernum.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "Team DeathMatch";
      host_gametype.color = CLR_DEF_IFF_ENEMY;
      gui_renderString("Start Map  :", host_map_lbl.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Frag Limit  :", host_dm_fraglim.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Time Limit  :", host_dm_timelim.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      if( host_map_lbl.label != "" ){
        drawpic(host_map_lbl.origin + gui_percentToPixelRawVec('120 -64'), strcat("data/maps/",host_map_lbl.label,"/",host_map_lbl.label,".png"), '256 256', '1 1 1', 1, 0);
      }
      break;
      
    case SUB_DM:
      gui_renderString("Max Players  :", host_playernum.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "DeathMatch";
      host_gametype.color = CLR_DEF_IFF_ENEMY_BLD;
      gui_renderString("Start Map  :", host_map_lbl.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Frag Limit  :", host_dm_fraglim.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Time Limit  :", host_dm_timelim.origin + gui_percentToPixelRawVec('-100 1'), '1 1 1', '12 12 0', 1, 0);
      if( host_map_lbl.label != "" ){
        drawpic(host_map_lbl.origin + gui_percentToPixelRawVec('120 -64'), strcat("data/maps/",host_map_lbl.label,"/",host_map_lbl.label,".png"), '256 256', '1 1 1', 1, 0);
      }
      break;
  }
  
  local entity widget;
  widget = findchainfloat(menuId, M_HOST);
  while(widget){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }
    else if( widget.subid == SUB_MENU){
      widget.draw(widget);
    }
    widget = widget.chain;
  }
  drawfont = drawfont_prev;
};

void(float key, float ascii) m_host_k={
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      SUB_MENU = 0;
      m_multi_f();
      break;
  }
};