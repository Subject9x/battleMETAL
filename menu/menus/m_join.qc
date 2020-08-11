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
float SERVER_CURRENT;
float SERVER_TOTAL;
float SERVER_VIEW;

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
entity join_server_game;
entity join_server_map;
entity join_server_numplayer;
entity join_server_mods;

entity join_server_pagenext;
entity join_server_pageprev;

entity join_favs;
entity join_fav1;
entity join_fav1_btn;
entity join_fav2;
entity join_fav2_btn;
entity join_fav3;
entity join_fav3_btn;
entity join_fav4;
entity join_fav4_btn;
entity join_fav5;
entity join_fav5_btn;

//join constants
string IMG_JOIN_TITLE = "gfx/menu/join/title_join.png";
float SERVER_NAME_MAX = 24;
float SERVER_PAGE_SIZE = 8;  //technically 8, but PAGE - 1 is the start to account for hostnr 0 being valid

void() join_page_update={
  SERVER_TOTAL = gethostcachevalue(SLIST_HOSTCACHETOTALCOUNT);
  SERVER_VIEW = gethostcachevalue(SLIST_HOSTCACHEVIEWCOUNT);
  SERVER_PAGE_TOTAL = ceil(SERVER_TOTAL / SERVER_PAGE_SIZE);
  SERVER_PAGE_LIST_START = max((SERVER_PAGE * SERVER_PAGE_SIZE)-1, 0); 
  SERVER_PAGE_LIST_END = (SERVER_PAGE * SERVER_PAGE_SIZE) + SERVER_PAGE_SIZE;
};

//join callbacks
void() join_sort_name={
  refreshhostcache(TRUE);
  if( SERVER_SORT_NAME ) {
    sethostcachesort(SLIF_NAME, 0);
    SERVER_SORT_NAME = FALSE;
  }
  else{
    sethostcachesort(SLIF_NAME, SLSF_DESCENDING);
    SERVER_SORT_NAME = TRUE;
  }
  join_page_update();
};

void() join_sort_ping={
  refreshhostcache(TRUE);
  if(SERVER_SORT_PING) {
    sethostcachesort(SLIF_PING, 0);
    SERVER_SORT_PING = FALSE;
  }
  else{
  sethostcachesort(SLIF_PING, SLSF_DESCENDING);
    SERVER_SORT_PING = TRUE;
  }
  join_page_update();
};

void() join_sort_map={
  refreshhostcache(TRUE);
  if( SERVER_SORT_MAP ) {
    sethostcachesort(SLIF_MAP, 0);
    SERVER_SORT_MAP = FALSE;
  }
  else{
    sethostcachesort(SLIF_MAP, SLSF_DESCENDING);
    SERVER_SORT_MAP = TRUE;
  }
  join_page_update();
};

void() join_sort_numplayer={
  refreshhostcache(TRUE);
  if( SERVER_SORT_PLAYERS ) {
    sethostcachesort(SLIF_NUMPLAYERS, 0);
    SERVER_SORT_PLAYERS = FALSE;
  }
  else{
    sethostcachesort(SLIF_NUMPLAYERS, SLSF_DESCENDING);
    SERVER_SORT_PLAYERS = TRUE;
  }
  join_page_update();
};

void() join_sort_players={
  refreshhostcache(TRUE);
  sethostcachesort(SLIF_PING, 0);
  join_page_update();
};

void() join_server_page_next={
  if( SERVER_TOTAL > 0 ){
    if( SERVER_PAGE < SERVER_PAGE_TOTAL ){
      SERVER_PAGE = SERVER_PAGE + 1;
    }
  }
  join_page_update();
};
void() join_server_page_prev={
  if( SERVER_TOTAL > 0 ){
    if( SERVER_PAGE > 0 ){
      SERVER_PAGE = SERVER_PAGE - 1;
    }
  }
  join_page_update();
};

// ini function, called by '_f' function as a setup func
void() m_join_i={
  menu_setup_mainservers();
  resethostcachemasks();
  refreshhostcache(TRUE);
  sethostcachesort(SLIF_PING, 0);
  resorthostcache();
  
  SERVER_CURRENT = 0;
  SERVER_TOTAL = gethostcachevalue(SLIST_HOSTCACHETOTALCOUNT);
  SERVER_VIEW = gethostcachevalue(SLIST_HOSTCACHEVIEWCOUNT);
  
  SERVER_PAGE = 0;
  join_page_update();
  
  join_title = lbl_img('10 30', '1 1 0', IMG_JOIN_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_JOIN, 1, (UI_FLAG_SIZE_IMG) );
  join_favs = lbl_text('64 60', '14 14 0', "-Favorites-", CLR_DEF_IIF_FRIEND, (VIEW_CTX | VIEW_CTY), M_JOIN, 1, 0);
  join_server_name = btn_text_callback('10 180', '16 16', "[Server]", 0, M_JOIN, join_sort_name, CLR_DEF_WHITE, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_ping = btn_text_callback('135 180', '16 16', "[Ping]", 0, M_JOIN, join_sort_ping, CLR_DEF_WHITE, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_map = btn_text_callback('185 180', '16 16', "[Map]", 0, M_JOIN, join_sort_map, CLR_DEF_WHITE, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_numplayer = btn_text_callback('235 180', '16 16', "[Players]", 0, M_JOIN, join_sort_numplayer, CLR_DEF_WHITE, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);
  join_server_mods = btn_text_callback('285 180', '16 16', "[Mod]", 0, M_JOIN, join_sort_players, CLR_DEF_WHITE, CLR_DEF_IIF_FRIEND, 1, UI_FLAG_SIZE_IMG);  

  join_server_pagenext = btn_img_callback('52 160', '16 16', UI_IMG_ARW_RGT, 0, M_JOIN, join_server_page_next, '1 1 1', CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  join_server_pageprev = btn_img_callback('10 160', '16 16', UI_IMG_ARW_LFT, 0, M_JOIN, join_server_page_prev, '1 1 1', CLR_DEF_IIF_FRIEND_BLD, 1, 0) ;
  
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
void(float serverCacheId, vector ofset) join_render_serverinfo={
  local string serverName;
  local string serverIp;
  local string playerCount;
  
  serverName = gethostcachestring(SLIF_NAME, serverCacheId);
  serverIp = gethostcachestring(SLIF_CNAME, serverCacheId);
  if( strlen(serverName) > SERVER_NAME_MAX){
    serverName = substring(serverName,0,SERVER_NAME_MAX);
  }
  playerCount = ftos(gethostcachenumber(SLIF_NUMPLAYERS, serverCacheId));
  playerCount = strcat(playerCount, "/");
  playerCount = strcat(playerCount, ftos(gethostcachenumber(SLIF_MAXPLAYERS, serverCacheId)));
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
  
    gui_renderString(serverName, ofset , '1 1 1', '12 12 0', 1, 0);
    gui_renderString(serverIp, ofset + gui_percentToPixelRawVec('0 12'), '1 1 1', '10 10 0', 1, 0);
    
    gui_renderString(ftos(gethostcachenumber(SLIF_PING, serverCacheId)), ofset + gui_percentToPixelRawVec('135 0'), '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(gethostcachestring(SLIF_MAP, serverCacheId), ofset + gui_percentToPixelRawVec('180 0'), '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(playerCount, ofset + gui_percentToPixelRawVec('240 0'), '1 1 1', '12 12 0', 1, 0);
    
    gui_renderString(gethostcachestring(SLIF_MOD, serverCacheId),  ofset + gui_percentToPixelRawVec('282 0'), '1 1 1', '12 12 0', 1, 0);
  drawfont = drawfont_prev;
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_join_d={
  local float itr;
  local vector pos;
  
  resorthostcache();
  
  local entity widget;
  widget = findchainfloat(menuId, M_JOIN);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_MEDIUM;
    gui_renderString( ftos(SERVER_PAGE), join_server_pageprev.origin + gui_percentToPixelRawVec('26 0'), '1 1 1', '16 16 0', 1, 0);
  drawfont = drawfont_prev;
  SERVER_ROW_ITR = 0;
  
  SERVER_LIST_ORG = gui_percentToPixelRawVec('10 200');
  
  for(itr=0; itr < SERVER_TOTAL; itr=itr+1){
    if( (itr > SERVER_PAGE_LIST_START) && (itr < SERVER_PAGE_LIST_END) ){
      if( gethostcachenumber(SLIF_PING, itr) > -1 ){
        pos_x = SERVER_LIST_ORG_x;
        pos_y = SERVER_LIST_ORG_y + gui_percentYRaw(SERVER_ROW_ITR * 26);
        
        join_render_serverinfo( itr, pos );
        SERVER_ROW_ITR = SERVER_ROW_ITR + 1;
      }
    }
  }
  SERVER_LIST_SIZE_x = 350;
  SERVER_LIST_SIZE_y = SERVER_ROW_ITR * 26;
  SERVER_LIST_SIZE = gui_percentToPixelRawVec(SERVER_LIST_SIZE);
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_join_k={
  local float hostNumber;
  
  if(key == K_MOUSE1){
    SERVER_SELECTED = listListener(SERVER_LIST_ORG, SERVER_LIST_SIZE, gui_percentToPixelRawVec('350 26'), SERVER_ROW_ITR+1, 0);
    if( SERVER_SELECTED != -1 ){
      cmd("cl_ismenu 0\n");
      SERVER_SELECTED = SERVER_PAGE_LIST_START + SERVER_SELECTED;
      menu_clear_items(M_STATE);
      menu_exit_togame();
      cmd("connect ", gethostcachestring(SLIF_CNAME, SERVER_SELECTED));
      return;
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