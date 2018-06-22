/*
mech Mod
Author: Peter Roohr
Date: 4/15/2018
Overview: host game menu
*/

//constants
float FRAG_MAX = 1000;
float TIME_MAX = 20;
float SUB_COOP = 1;
float SUB_TDM = 2;
float PLRS_MAX_COOP = 4;
float PLRS_MIN_COOP = 2;
float PLRS_MAX_TDM = 32;
float PLRS_MIN_TDM = 2;
float RATE_MAX = 2000000;

float SELECT_TYPE;
float SELECT_PLAYERS;
float SELECT_SKILL;
float SELECT_RATE;

float SELECT_MAP;

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

//kustom funcs

void() host_update_type={
  if(SELECT_TYPE){
    host_public.label = "PUBLIC";
    cvar_set("sv_public", ftos(1));
  }
  else{
    host_public.label = "LAN";
    cvar_set("sv_public", ftos(0));
  }
};

void() host_update_playeramount={
  if( SUB_MENU == SUB_COOP ){
    host_map_lbl.label = strzone(MAPS_COOP[SELECT_MAP]);
    cvar_set("coop", ftos(1));
    cvar_set("deathmatch", ftos(0));
    if( SELECT_PLAYERS > PLRS_MAX_COOP ){
      SELECT_PLAYERS = PLRS_MAX_COOP;
    }
    if( SELECT_PLAYERS < PLRS_MIN_COOP ){
      SELECT_PLAYERS = PLRS_MIN_COOP;
    }
  }
  else if( SUB_MENU == SUB_TDM ){
    host_map_lbl.label = strzone(MAPS_TDM[SELECT_MAP]);
    cvar_set("coop", ftos(0));
    cvar_set("deathmatch", ftos(1));
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
  if(SELECT_RATE > RATE_MAX ){
    SELECT_RATE = RATE_MAX;
  }
  else if(SELECT_RATE < 250000 ){
    SELECT_RATE = 250000;
  }
  strunzone(host_serverrate.label);
  cmd("rate ", ftos(SELECT_RATE));
  host_serverrate.label = strzone(strcat(ftos(SELECT_RATE / 1000000)," Mbps"));
};

//callbacks
void() host_servername={
  cvar_set("hostname", self.data_text);
};

void() host_portnum={
  cvar_set("port", self.data_text);
};

void() click_host_public={
  SELECT_TYPE = TRUE;
  host_update_type();
};

void() click_host_lan={
  SELECT_TYPE = FALSE;
  host_update_type();
};

void() click_host_rate_up={
  SELECT_RATE = SELECT_RATE + 250000;
  host_update_rate(SELECT_RATE);
};

void() click_host_rate_down={
  SELECT_RATE = SELECT_RATE - 250000;
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
  if(SUB_MENU > 2){
    SUB_MENU = 1;
  }
  host_update_playeramount();
};

void() click_host_prevtype={
  SUB_MENU = SUB_MENU - 1;
  if(SUB_MENU < 1){
    SUB_MENU = 2;
  }
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
  if( SUB_MENU == SUB_TDM){
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
  if( SUB_MENU == SUB_TDM){
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
  host_title = lbl_img('10 100', '1 1 0', IMG_HOST_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_HOST, 1, (UI_FLAG_SIZE_IMG) );
  
  host_name = inp_textfield('140 133', '10 10 0', 64, host_servername, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC) );
  if( str_cvar("hostname") == ""){
    host_name.data_text = strzone("UNNAMED");
  }
  else{
    host_name.data_text = strzone(str_cvar("hostname"));
  }
  
  host_port = inp_textfield('140 148', '10 10 0', 64, host_portnum, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_port.data_text = strzone(str_cvar("port"));
  
  host_public = lbl_text('153 165', '10 10 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_type_nxt = btn_img_callback('220 162 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_public, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_type_prev = btn_img_callback('140 162 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_lan, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_public.label = "PUBLIC";
  
  host_serverrate = lbl_text('153 178', '10 10 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  local float rate;
  rate = cvar("rate");
  host_serverrate.label = strzone(strcat(ftos(rate / 1000000), " Mbps"));
  
  host_rate_up = btn_img_callback('307 176 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_rate_dn = btn_img_callback('140 176 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_rate_down, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  host_gametype = lbl_text('153 193', '10 10 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);  
  host_gametype_next = btn_img_callback('307 193 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_nexttype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_gametype_prev = btn_img_callback('140 193 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_prevtype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum = lbl_text('150 209', '10 10 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_playernum.label = strzone(ftos(cvar("maxplayers")));
  host_playermor = btn_img_callback('175 208 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_more_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_playerles = btn_img_callback('140 208 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_less_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum.subid = SUB_COOP;
  host_playermor.subid = SUB_COOP;
  host_playerles.subid = SUB_COOP;
  
  
  //map selector
  host_map_lbl = lbl_text('153 240', '10 10 0', " ", CLR_DEF_IIF_FRIEND, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_map_lbl.label = strzone(map_list_getmap(0));
  
  host_map_nxt = btn_img_callback('265 240 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_map_nxt, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_prev = btn_img_callback('140 240 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_map_prv, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_lbl.subid = SUB_COOP;
  host_map_nxt.subid = SUB_COOP;
  host_map_prev.subid = SUB_COOP;
  
  //COOP SUB MENU
  host_skill_lbl = lbl_text('153 226', '10 10 0', "NOVICE", CLR_DEF_BLUE, (VIEW_CTX | VIEW_CTY), M_HOST, 1, 0);
  host_skill_next = btn_img_callback('265 225 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_nextskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_prev = btn_img_callback('140 225 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_prevskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_lbl.subid = SUB_COOP;
  host_skill_next.subid = SUB_COOP;
  host_skill_prev.subid = SUB_COOP;
  
  //TDM SUB MENU
  host_dm_fraglim = inp_textfield('140 257', '10 10 0', 3, host_frag_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_dm_fraglim.data_text = strzone(ftos(cvar("fraglimit")));
  
  host_dm_timelim = inp_textfield('140 272', '10 10 0', 3, host_time_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  host_dm_timelim.data_text = strzone(ftos(cvar("timelimit")));

  host_dm_fraglim.subid = SUB_TDM;
  host_dm_timelim.subid = SUB_TDM;
  
  //LAAAAAAAAUNCH!
  host_launch = btn_img_callback('140 287 0', '96 16', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_launch, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL));
  //or not
  host_back = btn_img_callback('25 290 0', '56 12', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_HOST, click_host_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
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

  gui_renderString("Server Name  :", gui_percentToPixelRawVec('10 135'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("Port Number  :", gui_percentToPixelRawVec('10 150'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("Server Type  :", gui_percentToPixelRawVec('10 165'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("Server Rate  :", gui_percentToPixelRawVec('10 180'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("Game Type  :", gui_percentToPixelRawVec('28 195'), '1 1 1', '9 9 0', 1, 0);

  //kids, this is why implemnt _d funcs for every menu, some need a little extra functionality
  switch(SUB_MENU){
    case SUB_COOP:
      gui_renderString("Max Players  :", gui_percentToPixelRawVec('10 210'), '1 1 1', '9 9 0', 1, 0);
      host_gametype.label = "Cooperative";
      host_gametype.color = CLR_DEF_IIF_FRIEND;
      gui_renderString("Difficulty  :", gui_percentToPixelRawVec('19 227'), '1 1 1', '9 9 0', 1, 0);
      gui_renderString("Start Map  :", gui_percentToPixelRawVec('29 242'), '1 1 1', '9 9 0', 1, 0);
      break;
    
    case SUB_TDM:
      gui_renderString("Max Players  :", gui_percentToPixelRawVec('10 210'), '1 1 1', '9 9 0', 1, 0);
      host_gametype.label = "Team DeathMatch";
      host_gametype.color = CLR_DEF_IFF_ENEMY;
      gui_renderString("Start Map  :", gui_percentToPixelRawVec('29 242'), '1 1 1', '9 9 0', 1, 0);
      gui_renderString("Frag Limit  :", gui_percentToPixelRawVec('20 257'), '1 1 1', '9 9 0', 1, 0);
      gui_renderString("Time Limit  :", gui_percentToPixelRawVec('20 272'), '1 1 1', '9 9 0', 1, 0);
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

};

void(float key, float ascii) m_host_k={
  //cons_logAFloat("m_load_k.key", key);  //DEBUG
 //cons_logAFloat("m_load_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      SUB_MENU = 0;
      m_multi_f();
      break;
  }
};