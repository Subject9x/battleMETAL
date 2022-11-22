/*
battleMETAL
Author: Peter Roohr
Date: 4/15/2018
Overview: 
  host game menu
*/

//constants
#define FRAG_MAX 1000
#define TIME_MAX 20

 //defaults to make sure they're always set.
#define TIME_DEF 30 
#define FRAG_DEF 15

#define SUB_COOP 1
#define SUB_DM 2
#define SUB_TDM 3

#define PLRS_MAX_COOP 4
#define PLRS_MIN_COOP 2
#define PLRS_MAX_TDM 16
#define PLRS_MIN_TDM 2

#define RATE_MAX 80000

float SELECT_TYPE;
float SELECT_PLAYERS;
//float SELECT_SKILL;
float SELECT_RATE;

float SELECT_MAP;

float SERVER_FLAGS;

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
/*entity host_skill_lbl;
entity host_skill_next;
entity host_skill_prev;*/

entity host_map_lbl;
entity host_map_nxt;
entity host_map_prev;

//non-coop settings
entity host_dm_fraglim;
entity host_dm_timelim;

entity host_launch;
entity host_back;

//serverflags

entity host_flag_spawnfar;
entity host_flag_powerup;
entity host_flag_cheats;
entity host_flag_fireon;
entity host_flag_nolives;
entity host_flag_nomap;
entity host_flag_noradar;
entity host_flag_nostatus;
entity host_flag_nocam;

//images
#define IMG_HOST_TITLE "gfx/menu/host/host_title.png"

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
    cacheGlobalString(host_map_lbl.label, MAPS_COOP[SELECT_MAP])
    cvar_set("coop", "1");
    cvar_set("deathmatch", "0");
    cvar_set("teamplay", "0");
    cvar_set("gamemode", ftos(GAMEMODE_COOP));
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
    cacheGlobalString(host_map_lbl.label, MAPS_TDM[SELECT_MAP])
    cvar_set("coop", "0");
    cvar_set("deathmatch", "1");
    cvar_set("teamplay", "1");
    cvar_set("gamemode", ftos(GAMEMODE_TEAMDM));
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
    cacheGlobalString(host_map_lbl.label, MAPS_TDM[SELECT_MAP])
    cvar_set("coop", "0");
    cvar_set("deathmatch", "1");
    cvar_set("teamplay", "0");
    cvar_set("gamemode", ftos(GAMEMODE_DM));
    if( SELECT_PLAYERS > PLRS_MAX_TDM ){
      SELECT_PLAYERS = PLRS_MAX_TDM;
    }
    if( SELECT_PLAYERS < PLRS_MIN_TDM ){
      SELECT_PLAYERS = PLRS_MIN_TDM;
    }
  }
  
  localcmd(strcat("maxplayers ",  ftos(rint(SELECT_PLAYERS)),"\n"));
  host_playernum.len = SELECT_PLAYERS;
  host_playernum.subid = SUB_MENU;
  host_playermor.subid = SUB_MENU;
  host_playerles.subid = SUB_MENU;
  host_map_lbl.subid = SUB_MENU;
  host_map_nxt.subid = SUB_MENU;
  host_map_prev.subid = SUB_MENU;
};

/*void(float skl) host_update_skilllbl={
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
};*/

void(float rte) host_update_rate={
  local string cmdString;
  cmdString = strcat("rate ", ftos(HOST_RATE_TABLE[rte]),"\n");
  localcmd(cmdString);
  host_serverrate.len = HOST_RATE_TABLE[rte];
};

float( float rateVal ) host_rate_find={
  local float itr;
  local float rateFind;
  
  rateFind = 0;
  while( itr < 8 ){
    if( HOST_RATE_TABLE[itr] == rateVal ){
      rateFind = itr;
    }
    itr = itr + 1;
  }
  
  return rateFind;
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
  if( SELECT_RATE > 7 ){
    SELECT_RATE = 0;
  }
  host_update_rate(SELECT_RATE);
};
void() click_host_rate_down={
  if( SELECT_RATE != 0 ){
    SELECT_RATE = SELECT_RATE - 1;
  }
  else{
    SELECT_RATE = 7;
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
  if(SUB_MENU > 2){
    SUB_MENU = 3;
    host_gametype_next.drawme = FALSE;
    host_gametype_prev.drawme = TRUE;
  }
  else{
    host_gametype_next.drawme = TRUE;
    host_gametype_prev.drawme = TRUE;
  }
  map_list_getmap((SUB_MENU==SUB_COOP));
  SELECT_MAP = 1;
  host_update_playeramount();
  if( SUB_MENU == SUB_COOP ){
    host_flag_spawnfar.drawme = FALSE;
  }
  else{
    host_flag_spawnfar.drawme = TRUE;
  }
};

void() click_host_prevtype={
  SUB_MENU = SUB_MENU - 1;
  if(SUB_MENU < 2){
    SUB_MENU = 1;
    host_gametype_next.drawme = TRUE;
    host_gametype_prev.drawme = FALSE;
  }
  else{
    host_gametype_prev.drawme = TRUE;
    host_gametype_next.drawme = TRUE;
  }
  
  map_list_getmap((SUB_MENU==SUB_COOP));
  SELECT_MAP = 1;
  host_update_playeramount();
  if( SUB_MENU == SUB_COOP ){
    host_flag_spawnfar.drawme = FALSE;
  }
  else{
    host_flag_spawnfar.drawme = TRUE;
  }
};

//coop callbacks
//co-op skill always ACE/ELITE
/*void() click_host_nextskill={
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
};*/

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
    cacheGlobalString(host_map_lbl.label, check)
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
    cacheGlobalString(host_map_lbl.label, check)
    SELECT_MAP = test;
  }
};

void() host_frag_limit={
  cvar_set("fraglimit", self.data_text);
};

void() host_time_limit={
  cvar_set("timelimit", self.data_text);
};

//Server Flag callbacks
void() host_check_flag_spawn={
  if( host_flag_spawnfar.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_SPAWNFAR;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_SPAWNFAR);
  }
};

void() host_check_flag_powerup={
  if( host_flag_powerup.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_POWERUP;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_POWERUP);
  }
};

void() host_check_flag_cheats={
  if( host_flag_cheats.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_CHEATS;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_CHEATS);
  }
};

void() host_check_flag_fireon={
  if( host_flag_fireon.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_FIREON;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_FIREON);
  }
};

void() host_check_flag_nolives={
  if( host_flag_nolives.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_NOLIVES;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_NOLIVES);
  }
};

void() host_check_flag_nomap={
  if( host_flag_nomap.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_NOMAP;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_NOMAP);
  }
};

void() host_check_flag_noradar={
  if( host_flag_noradar.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_NORADAR;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_NORADAR);
  }
};

void() host_check_flag_nostatus={
  if( host_flag_nostatus.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_NOSTATUS;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_NOSTATUS);
  }
};

void() host_check_flag_nocamera={
  if( host_flag_nocam.len == TRUE ){
    SERVER_FLAGS = SERVER_FLAGS | SVFLAG_FPSONLY;
  }
  else{
    SERVER_FLAGS = SERVER_FLAGS - (SERVER_FLAGS & SVFLAG_FPSONLY);
  }
};

void() click_host_back={
  cvar_set("sv_serverflags", "0");  //dont save serverflags
  cvar_set("sv_public", "-2");
  localcmd("maxplayers 1\n");
  cvar_set("coop" , "0");
  cvar_set("deathmatch" , "0");
  cvar_set("teamplay" , "0");
  localcmd("rate 250000\n");
  menu_clear_items(M_STATE);
  m_multi_f();
};

void() click_host_launch={
  if( host_map_lbl.label == "" || !host_map_lbl.label){
    return;
  }
  
  //default protection
  if( cvar("fraglimit") <= 0 ){
    cvar_set("fraglimit", ftos(FRAG_DEF));
  }
  if( cvar("timelimit") <= 0 ){
    cvar_set("timelimit", ftos(TIME_DEF));
  }
  
  localcmd(strcat("maxplayers ",  ftos(rint(SELECT_PLAYERS)),"\n"));
  cvar_set("skill", "3");
  
  cvar_set("sv_serverflags", ftos(rint(SERVER_FLAGS)));
  
  menu_clear_items(M_STATE);
  menu_exit_togame();
  localcmd(strcat("map ", host_map_lbl.label, "\n"));
};

void() m_host_i={
  local float rate;
  local string tmpGetMap;
  
  menu_parent_setup(VIEW_ORG + '0 40', '512 416');
  
  PUBLIC_TYPE = "debug";
  SERVER_FLAGS = cvar("sv_serverflags");
  
  host_title = lbl_img( MENU_ORG + menu_parent_center_width(10), '1 1 0', IMG_HOST_TITLE, '1 1 1', VIEW_CTX, M_HOST, 1, UI_FLAG_SIZE_IMG );
  
  host_name = inp_textfield( MENU_ORG + '100 53', '14 14 0', 48, host_servername, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC) );
  if( str_cvar("hostname") == ""){
    cvar_set("hostname", "UNNAMED");
  }
  cacheGlobalString(host_name.data_text,str_cvar("hostname"))
  
  host_port = inp_textfield( MENU_ORG + '100 83', '14 14 0', 16, host_portnum, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  cacheGlobalString(host_port.data_text,str_cvar("port"))
  
  SELECT_TYPE = 3;
  host_public = lbl_text( MENU_ORG + '120 103', '14 14 0', "", CLR_DEF_WHITE, VIEW_CTX, M_HOST, 1, 0);
  host_type_nxt = btn_img_callback(MENU_ORG + '180 103 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_public_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_type_prev = btn_img_callback(MENU_ORG + '100 103 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_public_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  cvar_set("sv_public", "1");
  
  host_serverrate = lbl_text(MENU_ORG + '120 123', '14 14 0', "", CLR_DEF_WHITE, VIEW_CTX, M_HOST, 1, 0);

  rate = cvar("rate");
  host_serverrate.len = rate;
  SELECT_RATE = host_rate_find( rate );
  
  host_rate_up = btn_img_callback(MENU_ORG + '180 123 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_rate_dn = btn_img_callback(MENU_ORG + '100 123 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_rate_down, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  SUB_MENU = SUB_COOP;
  
  host_gametype = lbl_text(MENU_ORG + '120 143', '14 14 0', "", CLR_DEF_WHITE, VIEW_CTX, M_HOST, 1, 0);
  host_gametype_next = btn_img_callback(MENU_ORG + '230 143 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_nexttype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_gametype_prev = btn_img_callback(MENU_ORG + '100 143 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_prevtype, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum = lbl_text(MENU_ORG + '120 163', '14 14 0', "", CLR_DEF_WHITE, VIEW_CTX, M_HOST, 1, UI_FLAG_LBL_USELEN);
  if(host_playernum.len < 2){
    host_playernum.len = 2;
  }
  SELECT_PLAYERS = host_playernum.len;
  
  host_playermor = btn_img_callback(MENU_ORG + '140 163 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_more_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_playerles = btn_img_callback(MENU_ORG + '100 163 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_less_plrs, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  host_playernum.subid = SUB_COOP;
  host_playermor.subid = SUB_COOP;
  host_playerles.subid = SUB_COOP;
  
  //map selector
  SELECT_MAP = 1;
  host_map_lbl = lbl_text(MENU_ORG + '120 183', '14 14 0', map_list_getmap(0), CLR_DEF_IIF_FRIEND, VIEW_CTX, M_HOST, 1, 0);
  
  host_map_nxt = btn_img_callback(MENU_ORG + '180 183 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_map_nxt, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_prev = btn_img_callback(MENU_ORG + '100 183 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_map_prv, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_map_lbl.subid = SUB_COOP;
  host_map_nxt.subid = SUB_COOP;
  host_map_prev.subid = SUB_COOP;
  
  //COOP SUB MENU
  /*host_skill_lbl = lbl_text(MENU_ORG + '120 203', '14 14 0', "NOVICE", CLR_DEF_BLUE, VIEW_CTX, M_HOST, 1, 0);
  host_skill_next = btn_img_callback(MENU_ORG + '200 203 0', '8 12', UI_IMG_ARW_RGT, VIEW_CTX, M_HOST, click_host_nextskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_prev = btn_img_callback(MENU_ORG + '100 203 0', '8 12', UI_IMG_ARW_LFT, VIEW_CTX, M_HOST, click_host_prevskill, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  host_skill_lbl.subid = SUB_COOP;
  host_skill_next.subid = SUB_COOP;
  host_skill_prev.subid = SUB_COOP;*/
  
  //DM / TDM SUB MENU  
  //default protection
  if( cvar("fraglimit") <= 0 ){
    cvar_set("fraglimit", ftos(FRAG_DEF));
  }
  host_dm_fraglim = inp_textfield(MENU_ORG + '100 203', '14 14 0', 3, host_frag_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  cacheGlobalString(host_dm_fraglim.data_text, ftos(cvar("fraglimit")))
  
  if( cvar("timelimit") <= 0 ){
    cvar_set("timelimit", ftos(TIME_DEF));
  }
  host_dm_timelim = inp_textfield(MENU_ORG + '100 223', '14 14 0', 3, host_time_limit, 0, M_HOST, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_TXTFIELD_NUM);
  cacheGlobalString(host_dm_timelim.data_text,  ftos(cvar("timelimit")))

  host_dm_fraglim.subid = SUB_TDM;
  host_dm_timelim.subid = SUB_TDM;

  //serverflags
  host_flag_spawnfar = btn_check_callback(MENU_ORG + '100 263', '14 14', 0, M_HOST, host_check_flag_spawn, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_spawnfar.label = "Spawn Furthest";
  
  cacheGlobalString(host_map_lbl.label, tmpGetMap)
  
  if( SUB_MENU == SUB_COOP ){
    host_flag_spawnfar.drawme = FALSE;
  }
  else{
    host_flag_spawnfar.drawme = TRUE;
  }
  
  host_flag_powerup = btn_check_callback(MENU_ORG + '210 263', '14 14', 0, M_HOST, host_check_flag_powerup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_powerup.label = "Powerup Delay";
  
  host_flag_cheats = btn_check_callback(MENU_ORG + '100 283', '14 14', 0, M_HOST, host_check_flag_cheats, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_cheats.label = "Cheats";
  
  host_flag_fireon = btn_check_callback(MENU_ORG + '210 283', '14 14', 0, M_HOST, host_check_flag_fireon, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_fireon.label = "Friendly Fire";
  
  //host_flag_nolives = btn_check_callback('100 273', '14 14', 0, M_HOST, host_check_flag_nolives, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, UI_FLAG_SIZE_IMG);
  //host_flag_nolives.label = strzone("Respawn");
  
  host_flag_nomap = btn_check_callback(MENU_ORG + '100 303', '14 14', 0, M_HOST, host_check_flag_nomap, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_nomap.label = "No Map ";
  
  host_flag_noradar = btn_check_callback(MENU_ORG + '210 303', '14 14', 0, M_HOST, host_check_flag_noradar, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_noradar.label = "No Radar";
  
  host_flag_nostatus = btn_check_callback(MENU_ORG + '100 323', '14 14', 0, M_HOST, host_check_flag_nostatus, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_nostatus.label = "Hide Menu Status";
  
  host_flag_nocam = btn_check_callback(MENU_ORG + '210 323', '14 14', 0, M_HOST, host_check_flag_nocamera, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0.5', 1, 0);
  host_flag_nocam.label = "No Ext. Camera";
  
  //LAAAAAAAAUNCH!
  host_launch = btn_text_callback(MENU_ORG + '200 360 0', '16 16', "LAUNCH", VIEW_CTX, M_HOST, click_host_launch, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  host_launch.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  //or not
  host_back = btn_text_callback(MENU_ORG + '40 360 0', '16 16', "BACK", VIEW_CTX, M_HOST, click_host_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  host_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  host_update_playeramount();
};

void() m_host_f={
  //SELECT_SKILL = 0;
  SELECT_TYPE = 0;
  SELECT_MAP = 1;
  map_list_getmap(FALSE);
  map_list_getmap(TRUE);
  M_STATE = M_HOST;
  setkeydest(KEY_MENU);
  cvar_set("sv_serverflags", "0");
  m_host_i();
};

void() m_host_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  PUBLIC_TYPE = "";
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
  gui_renderString("Server Name  :", host_name.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
  
  gui_renderString("Port Number  :", host_port.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
  gui_renderString("[You will need to port-forward this on your router]", host_port.origin + '110 0', '1 1 0.1', '12 12 0', 1, 0);
  
  gui_renderString("Server Type  :", host_public.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
  
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
  
  gui_renderString(PUBLIC_TYPE, host_public.origin + '85 1', '1 1 0.1', '12 12 0', 1, 0);
  
  host_serverrate.label = HOST_RATE_TABLE_NAME[SELECT_RATE];
  gui_renderString("Server Rate  :", host_serverrate.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
  gui_renderString("[Make sure this matches your internet speed or is lower than it.]", host_serverrate.origin + '85 1', '1 1 0.1', '12 12 0', 1, 0);
  
  
  gui_renderString("Game Type  :", host_gametype.origin + '-95 1', '1 1 1', '12 12 0', 1, 0);

  //kids, this is why implemnt _d funcs for every menu, some need a little extra functionality
  switch(SUB_MENU){
    case SUB_COOP:
      gui_renderString("Max Players  :", host_playernum.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "Cooperative";
      host_gametype.color = CLR_DEF_IIF_FRIEND;
      //gui_renderString("Difficulty  :", host_skill_lbl.origin + '-90 1', '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Start Map  :", host_map_lbl.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      break;
    
    case SUB_TDM:
      gui_renderString("Max Players  :", host_playernum.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "Team DeathMatch";
      host_gametype.color = CLR_DEF_IFF_ENEMY;
      gui_renderString("Start Map  :", host_map_lbl.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Frag Limit  :", host_dm_fraglim.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Time Limit  :                 Minutes", host_dm_timelim.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
      break;
      
    case SUB_DM:
      gui_renderString("Max Players  :", host_playernum.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      host_gametype.label = "DeathMatch";
      host_gametype.color = CLR_DEF_IFF_ENEMY_BLD;
      gui_renderString("Start Map  :", host_map_lbl.origin + '-100 1', '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Frag Limit  :", host_dm_fraglim.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
      gui_renderString("Time Limit  :                 Minutes", host_dm_timelim.origin + '-80 1', '1 1 1', '12 12 0', 1, 0);
      break;
  }
  if( strlen(host_map_lbl.label) != 0 ){
    drawpic(host_map_lbl.origin + '130 -32', strcat("data/maps/",host_map_lbl.label,"/",host_map_lbl.label,".png"), '256 256', '1 1 1', 1, 0);
  }
  else{
    gui_renderString("No Map Image Found", host_map_lbl.origin + '200 32', '1 1 1', '12 12 0', 1, 0);
  }
  gui_renderString("-Server Flags-", MENU_ORG + '80 243', '1 1 0.33', '14 14 0', 1, 0);
  
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
      cvar_set("sv_serverflags", "0");  //dont save serverflags
      cvar_set("sv_public", "-2");
      localcmd("maxplayers 1\n");
      cvar_set("coop" , "0");
      cvar_set("deathmatch" , "0");
      cvar_set("teamplay" , "0");
      localcmd("rate 250000\n");
      
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      SUB_MENU = 0;
      m_multi_f();
      break;
  }
};