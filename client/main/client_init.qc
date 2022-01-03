/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/

/*
  Called when CSQC is loaded for a client after level connect / loadup.
    Initializes most of the globals and values for the CSQC systems.
*/
void() CSQC_Init =
{
  local float i, cnt;
  
  registercvar("gamemode", "1", CF_CLIENT | CF_SERVER | CF_CLIENT_FROM_SERVER | CF_SERVER_FROM_CLIENT);
  registercommand("fog");
  //registercvar("cl_hud_sway", "1");
  registercvar("cl_team", "0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_color_psc", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_color_mil", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  registercvar("cl_color_srv", "0 0 0 0 0 0", CF_CLIENT | CF_ARCHIVE);
  registercvar("chase_active", "0", CF_CLIENT | CF_SERVER | CF_ARCHIVE);
  
  registercvar("cl_newgameplus", "0", CF_CLIENT | CF_ARCHIVE);
  
  cvar_set("con_chat", "0", CF_CLIENT | CF_ARCHIVE);  //force old chat system off
  
	maxclients = 0;
	while (maxclients < 1024 && getplayerkeyvalue(maxclients, "viewentity")){
		maxclients = maxclients + 1;
  }
  
	// this is the place to do any registercmd() calls we want for custom csqc commands (like replacing +showscores) so that they tab-complete properly
	// we can precache_sound and precache_model and precache_pic here
  VIEW_ORG = '0 0';
  
  //ini the HUD sound system
  SQSIZE = 6; //set to 6
  STIME = 0;
  STIME_NEXT = 0;
  VQSIZE = 6;
  SQUED = FALSE;
  
  //Radio Transmission queue size
  TQSIZE = 4;
  TRTIME = 0;
  TR_TIME_NEXT = 0;
  TQUED = FALSE;

  i = 0;
  while( i <= TQSIZE ){
    TRANSMISSIONQUEUE[i] = NULL_STRING;
    TRANSMISSIONQUEUE_ENT[i] = -1;
    i = i + 1;
  }
  
  WEPBITS[0] = 1;
  WEPBITS[1] = 2;
  WEPBITS[2] = 4;
  WEPBITS[3] = 8;
  WEPBITS[4] = 16;
  WEPBITS[5] = 32;
  WEPBITS[6] = 64;
  WEPBITS[7] = 128;
  WEPBITS[8] = 256;

  SELECT_MECH = CLIENT_MENU_sel_mech = 0;
  LAUNCH_VALIDATION = 0; //set launch validation to 0 to prevent invalid deployments to game world

  UI_OBJECTIVE_ACTIVE = FALSE;
  HUD_TACMAP_ON = FALSE;
  HUD_SCORES_ON = FALSE;

  //clear out and prepare the sound queue
  i = 1;
  while( i < VQSIZE ){
    SOUNDQUEUE[i] = "null";
    i = i + 1;
  }
  HUD_EVENT_ID = -1;
  HUD_EVENTS[0] = -1;
  //clear out and prepare mech lists
  cnt = 1;
  while(cnt <= GAME_TOTAL_MECHS){
    UNLOCKED_MECHS[cnt] = 0;
    MECHLIST_LIGHT_ARR[cnt] = 0;
    MECHLIST_MEDIUM_ARR[cnt] = 0;
    MECHLIST_HEAVY_ARR[cnt] = 0;
    if( cnt <= HUD_EVENT_SIZE){
      HUD_EVENTS[cnt] = -1;
    }
    cnt = cnt + 1;
  }
  //clear out and prepare master weapon list
  cnt = 1;
  while(cnt <= 32){
    UNLOCKED_ITEMS[cnt] = 0;
    cnt = cnt + 1;
  }
  
  NAVNAMES[0] = "RANDOM";
  NAVNAMES[1] = "Alpha";
  NAVNAMES[2] = "Beta";
  NAVNAMES[3] = "Delta";
  NAVNAMES[4] = "Epsilon";
  NAVNAMES[5] = "Gamma";
  NAVNAMES[6] = "Iota";
  NAVNAMES[7] = "Kappa";
  NAVNAMES[8] = "Lambda";
  NAVNAMES[9] = "Mu";
  NAVNAMES[10] = "Nu";
  NAVNAMES[11] = "Omicron";
  NAVNAMES[12] = "Rho";
  NAVNAMES[13] = "Tau";
  NAVNAMES[14] = "Upsilon";
  NAVNAMES[15] = "Zeta";
  NAVNAMES[16] = "Eta";
  NAVNAMES[17] = "Theta";
  NAVNAMES[18] = "Xi";
  NAVNAMES[19] = "Phi";
  NAVNAMES[20] = "Omega";
  
  ANM_FILE_STATUS = 0;
  
  //get mission file
  dynamic_precache();
  cs_precache();
  
  particle_sys_ini_globals();
  
  textfilter_ini_keyarray();
  
  //clean up mapname global for file use
  tokenizebyseparator(mapname, "/", ".");
  cacheGlobalString( MAP_NAME, argv(1) )

  CFG_INDEX = 1;
  CFG_INDEX_PREV = CFG_INDEX;

  toolTip = spawn();
  UI_HANGAR_DATA_mech = spawn();
  UI_ARMING_DATA_item_a = spawn();
  UI_ARMING_DATA_item_b = spawn();
  UI_ARMING_DATA_item_list = spawn();
  UI_ARMING_item_drag = spawn();
  HUD_DATA_weapon = spawn();
  UI_HANGAR_DATA_mech_list = spawn();
  
  MOUSE_drag_timer = 0;
  HUD_SHIELD_FLASH_TIME = 0;
  HUD_SHIELD_FLASH_ON = FALSE;
  HUD_SHIELD_FLASH = -1;
  
  //ui data from text files /data/ui/
  ui_data_load_mechsizes();
  ui_data_load_hudnames();

  //loadfont(string fontname, string fontmaps, string sizes, float slot, float fix_scale, float fix_voffset)
  FONT_NUM_ROBOT_LIGHT = loadfont("Roboto_Light", "gfx/fonts/Roboto_Light", "8 12 16 32", FONT_USER0, TRUE, FALSE);
  FONT_NUM_ROBOT_THIN = loadfont("Roboto_Thin", "gfx/fonts/Roboto_Thin", "8 12 16 32", FONT_USER1, TRUE, FALSE);
  FONT_NUM_ROBOT_REGULAR = loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "8 12 16 32", FONT_USER2, TRUE, FALSE);
  FONT_NUM_ROBOT_MEDIUM = loadfont("Roboto_Medium", "gfx/fonts/Roboto_Medium", "8 12 16 32", FONT_USER3, TRUE, FALSE);
  FONT_NUM_DYSTOPIAN = loadfont("hatchetm", "gfx/fonts/hatchetm", "6 8 10 12 16", FONT_USER4, TRUE, FALSE);
  loadfont("Roboto-Light", "gfx/fonts/Roboto_Light", "6 8 10 12 16", FONT_DEFAULT, TRUE, FALSE);
  loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "6 8 10 12 16", FONT_CONSOLE, TRUE, FALSE);
  
  SCOREBOARDMAX = maxclients;
  SCORESTACK = 0;
  
  for( i=0; i < SCOREBOARDMAX; i=i+1){
    SCOREBOARD[i] = -1;
  }
  scoreboard_think();
  
  cl_set_hud_vars_obs();
  
  //this seams to appease the Garbage Collection gods...
  UNLOCKED_MECHS_DATA = ""; 
  UNLOCKED_ITEMS_DATA = ""; 
  MENU_DEBRIEF_unlocks_mechs = ""; 
  MENU_DEBRIEF_unlocks_equip = ""; 
  SV_NEXTMAP = "";
  
  initparticlespawner(16);
  VIEW_OBS_ID = 1;
  ui_colors_set_player_list();
  ISMENU_PREV = FALSE;

  
  freeGlobalString(PLAYER_COLOR_PSC)
  cacheGlobalString( PLAYER_COLOR_PSC, cvar_string("cl_color_psc") )
  
  freeGlobalString(PLAYER_COLOR_MIL)
  cacheGlobalString( PLAYER_COLOR_SRV, cvar_string("cl_color_srv") )
  
  freeGlobalString(PLAYER_COLOR_MIL)
  cacheGlobalString( PLAYER_COLOR_MIL, cvar_string("cl_color_mil") ) 
  
  ui_data_hud_ini_tags();
  
  cl_ini_infostring();
  
  CHAT_INP_SEND = FALSE;
};

// called when cl_cmd is used in the console (much like menu_cmd and sv_cmd for menu.dat and progs.dat), can perform special logic or useful functionality (like bestweapon)
void(string msg) GameCommand =
{
};


// called on each entity each frame if self.nextthink <= time + frametime
//.void() think;

// this function is called when a transformview message is received (when you enter a warpzone), to allow you to customize the view transform
// return value is new origin
// v_forward, v_right, v_up must be set correctly
// trace_endpos should be set correctly (before call it will be the same value as org)
//.vector(vector org, vector ang, vector forward, vector right, vector up) camera_transform;


