/*
battleMETAL
Author: Peter Roohr
Date: 4/16/2018
Overview: 
  multiplayer join game menu
*/

/*
  reference
void 	resethostcachemasks(void);
void 	sethostcachemaskstring(float mask, float fld, string str, float op) = #616;
void	sethostcachemasknumber(float mask, float fld, float num, float op) = #617;
void 	resorthostcache(void);

void	sethostcachesort(float fld, float slsf);
void	refreshhostcache(...);  // optional boolean argument "clear_list"


float	gethostcacheindexforkey(string key)
void	addwantedhostcachekey(string key)

string	getextresponse(void)

float	gethostcachevalue(float type);

string	gethostcachestring(float fld, float hostnr);
float	gethostcachenumber(float fld, float hostnr)
*/

//join Globals

string SERVER_BASE_DATA_DIR = "metaldata";

float SERVER_CURRENT;

float SERVER_PAGE;
float SERVER_PAGE_TOTAL;
float SERVER_PAGE_LIST_START;
float SERVER_PAGE_LIST_END;

float SERVER_SORT_NAME;
float SERVER_SORT_PING;
float SERVER_SORT_MAP;
float SERVER_SORT_PLAYERS;

float SERVER_ROW_ITR;
vector SERVER_LIST_ORG;
vector SERVER_LIST_SIZE;

float SERVER_SELECTED;

entity join_title;

entity join_server_name;
entity join_server_ping;
entity join_server_map;
entity join_server_numplayer;
entity join_server_mods;

entity join_server_pagenext;
entity join_server_pageprev;
entity join_refresh_btn;

entity join_back;

//join constants
string IMG_JOIN_TITLE = "gfx/menu/join/title_join.png";
float SERVER_NAME_MAX = 24;
float SERVER_PAGE_SIZE = 10;  //technically 8, but PAGE - 1 is the start to account for hostnr 0 being valid

void() join_page_update={
  local float totalServer;
  totalServer = gethostcachevalue(SLIST_HOSTCACHEVIEWCOUNT);
  if(totalServer > SERVER_PAGE_SIZE ){
    SERVER_PAGE_TOTAL = rint(floor(totalServer / SERVER_PAGE_SIZE));
    SERVER_PAGE_LIST_START = max((SERVER_PAGE * SERVER_PAGE_SIZE), 1); 
    SERVER_PAGE_LIST_END = (SERVER_PAGE * SERVER_PAGE_SIZE) + SERVER_PAGE_SIZE;
  }
  else{
    SERVER_PAGE_TOTAL = 1;
    SERVER_PAGE_LIST_START = 0; 
    SERVER_PAGE_LIST_END = totalServer;
  }
};

//join callbacks
void() join_sort_name={
  if( SERVER_SORT_NAME ) {
    sethostcachesort(gethostcacheindexforkey("name"), 0);
    SERVER_SORT_NAME = FALSE;
  }
  else{
    sethostcachesort(gethostcacheindexforkey("name"), SLSF_DESCENDING);
    SERVER_SORT_NAME = TRUE;
  }
  refreshhostcache();
  resorthostcache();
};

void() join_sort_ping={

  if(SERVER_SORT_PING) {
    sethostcachesort(gethostcacheindexforkey("ping"), 0);
    SERVER_SORT_PING = FALSE;
  }
  else{
    sethostcachesort(gethostcacheindexforkey("ping"), SLSF_DESCENDING);
    SERVER_SORT_PING = TRUE;
  }
  resorthostcache();
};

void() join_sort_map={

  if( SERVER_SORT_MAP ) {
    sethostcachesort(gethostcacheindexforkey("map"), 0);
    SERVER_SORT_MAP = FALSE;
  }
  else{
    sethostcachesort(gethostcacheindexforkey("map"), SLSF_DESCENDING);
    SERVER_SORT_MAP = TRUE;
  }
  resorthostcache();
};

void() join_sort_numplayer={

  if( SERVER_SORT_PLAYERS ) {
    sethostcachesort(gethostcacheindexforkey("numplayers"), 0);
    SERVER_SORT_PLAYERS = FALSE;
  }
  else{
    sethostcachesort(gethostcacheindexforkey("numplayers"), SLSF_DESCENDING);
    SERVER_SORT_PLAYERS = TRUE;
  }
  resorthostcache();
};

void() join_sort_players={
  sethostcachesort(gethostcacheindexforkey("ping"), 0);
  resorthostcache();
};

void() join_server_page_next={
  if( (SERVER_PAGE + 1) < SERVER_PAGE_TOTAL ){
    SERVER_PAGE = SERVER_PAGE + 1;
  }
};
void() join_server_page_prev={
  if( SERVER_PAGE > 0 ){
    SERVER_PAGE = SERVER_PAGE - 1;
  }
};


void() join_refresh_action={
  refreshhostcache();
  resorthostcache();
};


void() join_back_click={
  localsound("sound/misc/menu2.wav");
  menu_clear_items(M_STATE);
  M_STATE = M_MULTI;
  m_multi_f();
};

// ini function, called by '_f' function as a setup func
void() m_join_i={
  
  menu_parent_setup(VIEW_ORG + '0 20', '512 416');
  
  menu_setup_mainservers();
  
  resethostcachemasks();
  sethostcachesort(gethostcacheindexforkey("ping"), FALSE);
  refreshhostcache();
  resorthostcache();
  
  SERVER_CURRENT = 0;
  SERVER_PAGE = 0;
  SERVER_PAGE_LIST_START = 0;
  SERVER_PAGE_LIST_END = 0;
  
  join_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_JOIN_TITLE, '1 1 1', VIEW_CTX, M_JOIN, 1, (UI_FLAG_SIZE_IMG) );
  
  join_server_pageprev = btn_img_callback(MENU_ORG + '10 45', '16 16', UI_IMG_ARW_LFT, 0, M_JOIN, join_server_page_prev, '1 1 1', CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  join_server_pagenext = btn_img_callback(MENU_ORG + '52 45', '16 16', UI_IMG_ARW_RGT, 0, M_JOIN, join_server_page_next, '1 1 1', CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  
  join_refresh_btn =  btn_text_callback(MENU_ORG + '100 45', '16 16', "Refresh", 0, M_JOIN, join_refresh_action, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_refresh_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_server_name = btn_text_callback(MENU_ORG + '10 65', '16 16', "Server", 0, M_JOIN, join_sort_name, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_name.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_server_ping = btn_text_callback(MENU_ORG + '135 65', '16 16', "Ping", 0, M_JOIN, join_sort_ping, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_ping.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_server_map = btn_text_callback(MENU_ORG + '185 65', '16 16', "Map", 0, M_JOIN, join_sort_map, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_map.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_server_numplayer = btn_text_callback(MENU_ORG + '235 65', '16 16', "Players", 0, M_JOIN, join_sort_numplayer, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_numplayer.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_server_mods = btn_text_callback(MENU_ORG + '300 65', '16 16', "Mod", 0, M_JOIN, join_sort_players, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);  
  join_server_mods.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  join_back = btn_text_callback(MENU_ORG + '45 380', '16 16', "BACK", VIEW_CTX, M_JOIN, join_back_click, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  join_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_join_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_JOIN;
  setkeydest(KEY_MENU);
  m_join_i();
};

//Server Info Rendering
void(float serverCacheId, vector ofset, float svPing, float svMaxPlayers, string svMap) join_render_serverinfo={
  local string serverName;
  local string serverIp;
  local string playerCount;
  local string modName;
  
  serverName = gethostcachestring(gethostcacheindexforkey("name"), serverCacheId);
  serverIp = gethostcachestring(gethostcacheindexforkey("cname"), serverCacheId);
  
  if( strlen(serverName) > SERVER_NAME_MAX){
    serverName = substring(serverName,0,SERVER_NAME_MAX);
  }
  playerCount = ftos(gethostcachenumber(gethostcacheindexforkey("numplayers"), serverCacheId));
  playerCount = strcat(playerCount, "/");
  playerCount = strcat(playerCount, ftos(svMaxPlayers));
  
  modName = gethostcachestring(gethostcacheindexforkey("mod"), serverCacheId);
  if( modName == SERVER_BASE_DATA_DIR ){
    modName = "none";
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
    gui_renderString(serverName, ofset , '1 1 1', '12 12 0', 1, 0);
  
  drawfont = FONT_NUM_ROBOT_LIGHT;
    gui_renderString(serverIp, ofset + '0 12', '1 1 1', '10 10 0', 1, 0);
  
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    
    gui_renderString(ftos(svPing), ofset + '135 0', '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(svMap, ofset + '180 0', '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(playerCount, ofset + '240 0', '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(modName, ofset + '298 0', '1 1 1', '12 12 0', 1, 0);
  drawfont = drawfont_prev;
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_join_d={
  local float serverId;
  local vector pos;
  local float total_servers;
  local float pingVal;
  local float maxPlayVal;
  local entity widget;
  local string mapVal;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_JOIN);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    gui_renderString( ftos(SERVER_PAGE), join_server_pageprev.origin + '26 0', '1 1 1', '16 16 0', 1, 0);
  drawfont = drawfont_prev;
  
  //serverId = SERVER_PAGE_LIST_START;
  SERVER_ROW_ITR = 0;
  
  SERVER_LIST_ORG = MENU_ORG + '10 90';
  
  total_servers = gethostcachevalue(SLIST_HOSTCACHEVIEWCOUNT);
  join_page_update();
  
  for(serverId=SERVER_PAGE_LIST_START; serverId < SERVER_PAGE_LIST_END; serverId=serverId+1){
    pingVal = gethostcachenumber(gethostcacheindexforkey("ping"), serverId);
    mapVal = gethostcachestring(gethostcacheindexforkey("map"), serverId);
    //9999 is most likely self-sever, ie the darn main_menu map!
    if( pingVal > -1 ){
      maxPlayVal = gethostcachenumber(gethostcacheindexforkey("maxplayers"), serverId);
      if( maxPlayVal > 1 ){
        pos_x = SERVER_LIST_ORG_x;
        pos_y = SERVER_LIST_ORG_y + (SERVER_ROW_ITR * 26);
        
        join_render_serverinfo( serverId, pos, pingVal, maxPlayVal, mapVal); 
        SERVER_ROW_ITR = SERVER_ROW_ITR + 1;
      }
    }
  }
  SERVER_LIST_SIZE_x = 350;
  SERVER_LIST_SIZE_y = SERVER_ROW_ITR * 26;
  SERVER_LIST_SIZE = SERVER_LIST_SIZE;
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_join_k={
  local string joinCmd;
  
  if(key == K_MOUSE1){
    SERVER_SELECTED = listListener(SERVER_LIST_ORG, SERVER_LIST_SIZE, '350 26', SERVER_ROW_ITR+1, 0);
    if( SERVER_SELECTED != -1 ){
      SERVER_SELECTED = SERVER_PAGE_LIST_START + SERVER_SELECTED;
      menu_clear_items(M_STATE);
      menu_exit_togame();
      joinCmd = strcat("connect ", gethostcachestring(gethostcacheindexforkey("cname"), SERVER_SELECTED), "\n");
      localcmd(joinCmd);
    }
    return;
  }
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MULTI;
      m_multi_f();
      break;
  }
};