// called during level initialization, before first entities are received, only world is valid at this point
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
};

// called on level shutdown (disconnect, level change, quit, loading a saved game, etc)
void() CSQC_Shutdown =
{
  //server string cleanup
  freeGlobalString(CLIENT_INFO_STRING)
  
  freeGlobalString(UNLOCKED_MECHS_DATA)
  freeGlobalString(UNLOCKED_ITEMS_DATA)
  freeGlobalString(MENU_DEBRIEF_unlocks_mechs)
  freeGlobalString(MENU_DEBRIEF_unlocks_equip)
  freeGlobalString(SV_NEXTMAP)
  freeGlobalString(ENT_SERVER_INFO.svAbout)
  freeGlobalString(ENT_SERVER_INFO.nextMap)
  
  freeGlobalString(PLAYER_COLOR_PSC)
  freeGlobalString(PLAYER_COLOR_SRV)
  freeGlobalString(PLAYER_COLOR_MIL)
  
  freeGlobalString(MAP_NAME);
  
  //config file cleanup
  freeGlobalString(DATA_CONFIG_BUFFER_NAME)
  
  freeGlobalString(UNLOCKED_MECHS_DATA)
  freeGlobalString(UNLOCKED_ITEMS_DATA)
  freeGlobalString(SAVEFILE_CAMPAIGN)
  freeGlobalString(SAVEFILE_CACHE_MAP)
  
  freeGlobalString(MENU_DEBRIEF_unlocks_mechs)
  freeGlobalString(MENU_DEBRIEF_unlocks_equip)
  
  freeGlobalString(DATA_CONFIG_BUFFER_NAME)
  
  //mission file cleanup
  msn_free_strings();
  
  //Entities
  freeGlobalString(CLIENT_netname)
  freeGlobalString(MISSION_NAME)
  freeGlobalString(HUD_INFO_MSG)
  
  localcmd("cd stop\n");
  
  menu_chat_cleanup();
  
  gui_set_screen_size();
  
};

// typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
// typ 1 = keyup (keysym, may have unicode character but generally not)
// typ 2 = mousemove (x, y) if inputmode is off
// typ 3 = mousepos (x, y) if inputmode is on
// return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent = {
  return handle_input(evtype, scanx, chary, devid);
};


// the most important function in CSQC...
/*
  DP engine -> CL_VM_UpdateView()
    w = vid.width
    h = vid.height
    menuView = key_dest = key_game
*/
void(float w, float h, float menuView) CSQC_UpdateView =
{
  local vector fovvec, vf_sz, vf_mn;
  local entity e;
  local vector porg, pang, torg;
  
  local float clientItr;
  local float frameItr;
  local entity oldSelf;
  local entity eClient;
  
  scoreboard_think();
  
  if(ISMENU_PREV != menuView){
    //check for player bringing up menu delta
    if( ISMENU_PREV == TRUE && menuView == FALSE ){
      if( CLIENT_faction == FACTION_SURVEST){
        if( PLAYER_COLOR_SRV != cvar_string("cl_color_srv") ){
          //player changed Survest color
          cacheGlobalString(PLAYER_COLOR_SRV, cvar_string("cl_color_srv") )
          cl_setmech( CLIENT_MENU_sel_mech );
        }
      }
      else if( CLIENT_faction == FACTION_MILITAR){
        if( PLAYER_COLOR_MIL != cvar_string("cl_color_mil") ){
          //player changed militar color
          cacheGlobalString(PLAYER_COLOR_MIL, cvar_string("cl_color_mil") )
          cl_setmech( CLIENT_MENU_sel_mech );
        }
      }
      else{
        if( PLAYER_COLOR_PSC != cvar_string("cl_color_psc") ){
          //player changed PSC color
          cacheGlobalString(PLAYER_COLOR_PSC, cvar_string("cl_color_psc") )
          cl_setmech( CLIENT_MENU_sel_mech );
        }
      }
    }
    ISMENU_PREV = menuView;
  }

  //oh this is an ugly hack
  if( !cvar("r_shadow_realtime_world") ){
    cvar_set("r_shadow_realtime_world", "1");
  }
  
  //run prediction...?
  eClient = findfloat(world, entnum, clientItr);
  while( eClient != world ){
    for (frameItr = eClient.sequence + 1; frameItr <= servercommandframe; frameItr = frameItr + 1) {
        if (!getinputstate(frameItr)){
            break;  //erk?... too old?
        }
        input_sequence = frameItr;
        oldSelf = self;
        self = eClient;
          runstandardplayerphysics(self);
          self.clientData.origin = self.origin;
        self = oldSelf;
      }
    clientItr = clientItr + 1;
    if( clientItr < 17){
      eClient = findfloat(eClient, entnum, clientItr);
    }
    else{
      eClient = world;
    }
  }
  
	/*
  local vector vf_size;
	local vector vf_min;
	local float chasecam, vid_width, vid_height,vid_conwidth,vid_conheight,vid_pixelheight;
  
	vf_size = getpropertyvec(VF_SIZE);
	vf_min = getpropertyvec(VF_MIN);
  CON_W = vid_conwidth = cvar("vid_conwidth");
	CON_H = vid_conheight = cvar("vid_conheight");
	vid_pixelheight = cvar("vid_pixelheight");
  VIEW_SCALE = (w/h)/10;
	chasecam = cvar("chase_active") != 0;
  */

	// do any manipulation we want on fov here (weapon zoom, respawn zoom, etc)
	// nothing right now

	// clear the scene information (entities, polygons, etc)
	clearscene();
  //=====================================================
	fovvec = getpropertyvec(VF_FOV); // note this is a vector (x and y are independent)
  vf_sz = getpropertyvec(VF_SIZE);
  vf_mn = getpropertyvec(VF_MIN);

	vf_sz_x = w;
  vf_sz_y = h;
  vf_sz_z = 0;
  vf_mn = '0 0 0';
	// set up the scene parameters
  //setproperty(VF_MIN, vf_mn);   //set the left of the view
  //setproperty(VF_SIZE, vf_sz);   //set how wide the view is (full width)
  
  //VF_ORIGIN+VF_ANGLES+VF_AFOV+VF_MIN+VF_SIZE
  
  //overide so player cannot look around while powering up, 
  //solves a lame visual issue with player mech shadows and player input during power up.
  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN ){
    if( cvar("chase_active") == FALSE ){
      setproperty(VF_ANGLES, HUD_FIXED_ANGLE); 
    }
  }
  else{
    //note: demonstrates the basics for player-observer mode where you follow another player
    if( VIEW_OBS_ID == 2 ){
      e = entitybyindex(stof(getplayerkeyvalue(VIEW_OBS_ID+1, "viewentity")));
      setproperty(VF_ORIGIN, e.origin);
      setproperty(VF_ANGLES, e.angles);
    }
    else{
      //setproperty(VF_ORIGIN, pmove_org);
      setproperty(VF_ANGLES, input_angles);
      //setproperty(VF_CL_VIEWANGLES, input_angles);
    }
  }
  
  setproperty(VF_FOV, fovvec);
  setproperty(VF_DRAWWORLD, 1);
  setproperty(VF_DRAWCROSSHAIR, 0);
  setproperty(VF_DRAWENGINESBAR, 0);
  VIEW_ORG = '0 0';
  
  VIEW_SCALE = 0.35;
  
  gui_set_screen_size();
  
  if(FOG_STATE){
    //alter fog settings if needed
    cl_particles_fogFrame();	//fog is disable for the time being (something up with depth-rendering and unit shaders)
    /*setproperty(VF_FOG_DENSITY, FOG_DENSITY);
    setproperty(VF_FOG_COLOR_R, FOG_RED);
    setproperty(VF_FOG_COLOR_G, FOG_GREEN);
    setproperty(VF_FOG_COLOR_B, FOG_BLUE);
    setproperty(VF_FOG_ALPHA,FOG_ALPHA );
    setproperty(VF_FOG_START, FOG_DIST_MIN);
    setproperty(VF_FOG_END, FOG_DIST_MAX);
    setproperty(VF_FOG_HEIGHT, FOG_DIST_TOP);
    setproperty(VF_FOG_FADEDEPTH, FOG_FADE_DEPTH);*/
  }

  // add any polygons we want here
  makevectors(input_angles);
  //=================================================
  
  // draw the main view
  if( !MENU_ACTIVE || CLIENT_MENU_menu_choice >= MENU_REBIND_ACTIVE){
    // add clientside entities (MASK_NORMAL)
    // add engine networked entities (MASK_ENGINE)
    // and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
    oldSelf = self;
    self = world;
    while( (self = nextent(self)) ){
      if( self.drawmask == MASK_NORMAL ){
        if( self.data_type && self.deadflag == DEAD_NO ){
          if( self.interpolate_entity ){
            self.interpolate_entity();
          }
        }
        if(self.render_dlights){
          self.render_dlights();
        }
      }
    }
    self = oldSelf;
    addentities( MASK_ENGINE | MASK_ENGINEVIEWMODELS | MASK_NORMAL );
    renderscene();
  }
  
  //DATA - Update local Client data vars from Server
  //note - make sure this is called AFTER addentities(), hehe
  client_get_info();
  receive_ent_bindData();
  client_state_events();
  
  /*
    special rant: the fact that the client itself, isn't a faffing global entity in the CLIENT
    module of all things is the height of idiocy.
  */
	// force switch to 2D polygon drawing in case we want to do any polygons before we draw pics and strings
	// FIXME: engine should have a drawflag for 3D and another for 2D (also would be nice to have 3D drawstring and drawpic)
	//drawstring('0 0 0', "", '1 1 0', '1 1 1', 0, 0);

	// draw custom hud
  if(CLIENT_data_type == DATA_MECH){
    
    //HUD RENDER FRAME SYSTEM
    if( CLIENT_health_center > 0 ){
      //HUD Highlight Boxes
      hud_renderHighlight_frame();
      
      //Main HUD entry point
      data_hud_frame();
      
      //Player has toggled 'Objectives' menu while in-mission.
      ui_objective_frame(VIEW_ORG);
      
      //Map has a .message value, and it's currently active for rendering
      if( MISSION_NAME_ON == TRUE ){
        client_event_mission_name_frame();
      }
    }
    //HUD sound system
    snd_hud_vfx_frame();
    
    if( PTC_CUBE_ON && servertime > PTC_CUBE_UPDATE){
      particle_box_think();
    }
  }
  
  //menu system
  if(MENU_ACTIVE){
    menu_handleFrame();
  }
  
  //put this last on the rendering order to make sure it 
  //plays above all
  if(ANM_FILE_STATUS == 1){
    anm_execute_frame();
  }
  
  if( cvar("developer") ){
    pang = '0 0 0'; //sh, compiler.
    torg = '0 0 0';
    porg = '0 0 0';
    porg_x = pang_x = torg_x = VIEW_ORG_x;
    porg_y = pang_y = torg_y = VIEW_MAX_y;
    //drawstring(porg + '1 -30', strcat("Player Origin: ", vtos(getpropertyvec(VF_ORIGIN))), '8 8 0', '0.85 0.85 0.85', 1, 0);
    //version wille eventually be only displayed as needed.
    gui_drawversion();
  }
  
};

// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command
float(string s) CSQC_ConsoleCommand =
{
  return FALSE;
};


// parse tempentity if it suits your fancy, return TRUE to tell engine you have finished parsing the 
//tempentity, return FALSE to tell engine to parse tempentity itself (it will reset parse position automatically)
float() CSQC_Parse_TempEntity =
{
  local float id;
  id = ReadByte();

  switch( id ){
    case TE_PLAYER_CRIT:
      client_handle_crit( ReadByte(), ReadLong() );
      return TRUE;
      
    case TE_CLIENT_INFO:
      client_campaign_end_data();
      return TRUE;
      
    case TE_CLIENT_INFO_DM:
      client_dm_end_data();
      return TRUE;
    
    case TE_UI_BOX:
      client_get_hud_highlight();
      return TRUE;
      
    case TE_FOG_SET:
      cl_get_new_fog();
      return TRUE;
    
    case TE_ISMENU:
      cl_set_menu();
      return TRUE;
    
    case TE_MSN_BOUND:
      client_event_boundary();
      return TRUE;
      
    case TE_MISSION_END:
      client_event_debrief_active( ReadByte(), ReadShort(), ReadShort(), ReadShort(), ReadShort() );
      return TRUE;
      
    case TE_VFX_EXPLODE:
      particle_missile_explode( te_read_vector(), ReadByte(), te_read_vector(), ReadByte() );
      return TRUE;
    
    case TE_MSG_INFO:
      client_event_info_box( ReadString(), CLR_DEF_TXT_GRAY_SMOOTH, ReadLong(), '14 14 0');
      return TRUE;
      
    case TE_REPAIRS_ON:
      if( ReadByte() ){
        hud_event_enqueue( HUD_EVENT_REPAIRS_ON, 1) ;
      }
      else{
        hud_event_enqueue( HUD_EVENT_REPAIRS_OFF, 1) ;
      }
      return TRUE;
      
    case TE_VFX_POINT:
      pointparticles( ReadShort(), te_read_vector(), te_read_vector(), ReadShort());
      return TRUE;
      
    case TE_VFX_RAIL:
      trailparticles( world, ReadShort(), te_read_vector(), te_read_vector() );
      return TRUE;
     
    case TE_PARTICLE_CUBE:
      particle_box_ini();
      return TRUE;
  } 
	return FALSE;
};
/*
  (Darkplaces)
  if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).

  (battleMETAL)
  All low-delta Client/Server commands go here, mostly stuff dealing with menu commands reaching the 
  server.
*/
void(string s) CSQC_Parse_StuffCmd =
{
  local float argc;
  
  if( cvar("developer") ){
    dprint(sprintf("CSQC_Parse_StuffCmd().s = %s\n", s));  //debug
  }
  argc = tokenize(s);
  if(argv(0) == "m"){
    if(argv(1) == "msn"){
      cl_get_msnfile( argv(2) );
      return;
    }
    if(argv(1) == "anm"){
      cl_get_animfile( argv(2) );
      ANM_SERV_TRIG = TRUE;
      return;
    }
    if(argv(1) == "ini"){
      cl_ini_event(s);
      return;
    }
  }
  else{  
    localcmd(s);
  }
};

// if string is interesting, deal with it, otherwise pass it to print() to invoke the engine code.
/*
an svc_print with a leading byte with value 1 will make the text red and play the chat beep sound... I guess you could call such prints as chat...
just beware that 2 and 3 have meanings too, at least in DP
this of course means that with sneaky naming you can get all your deaths to play chat sounds too, of course.
  -Spoike

I crufted my own message schema
see:
  common/data/data_values_game.qc
    Server<->Client string message layer
  
  CHAT_TYPE_MSG1 
  CHAT_TYPE_MSG2 
  CHAT_TYPE_SERVR
*/
void(string s) CSQC_Parse_Print =
{
  local string clientId;
  
  if( infoget(s, RSP_SRC) == SV_PRINT ){
    if( infoget(s, RSP_TYPE) == SAY_MSG1 ){
      clientId = infoget(s, RSP_CID);
      
      menu_chat_receive_new(CHAT_TYPE_MSG1, getplayerkeyvalue(stof(clientId) - 1, "name"), infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SAY_MSG2 ){
      clientId = infoget(s, RSP_CID);
      if( rint(stof(getplayerkeyvalue(stof(clientId) - 1, "colors"))) == CLIENT_faction ){
        menu_chat_receive_new(CHAT_TYPE_MSG2, getplayerkeyvalue(stof(clientId) - 1, "name"), infoget(s, RSP_BODY));
      }
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_CONN ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_KSELF ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_DSCON ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    return;
  }
	print(s);
};

// if string is interesting, deal with it, otherwise pass it to centerprint() to invoke the engine code.
void(string s) CSQC_Parse_CenterPrint =
{
  //TODO - how much string meta-data can we handle to actually take advantage of this function? <grumble>
  if( cvar("developer") ){
    if( strstrofs(s, " to go...", 0) != -1 ){
      //cons_logAFloat("caught fun string", 1); //debug
    }
  }
	centerprint(s);
};

// return TRUE if you wish to eat this sound, return FALSE to let engine handle it.
float(entity ent, float channel, string soundname, float volume, float attenuation, vector pos, float speed100, float sflags) CSQC_Event_Sound =
{
	return FALSE;
};

//not used in darkplaces
//float() CSQC_Parse_Event={
 // return FALSE;
//};


// return TRUE if you want to eat this event, otherwise return FALSE to let engine handle it.
// NOT USED IN DARKPLACES
float(float event) CSQC_Event =
{  
	return FALSE;
};


// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
// do. not. use. - tis borked - Roohr
/*entity(float entNum) CSQC_Ent_Spawn =
{
  local entity e;
  e = spawn();
  e.entnum = entNum;
  return e;
};*/


// parse a network update, isnew indicates this network slot was previously empty
// if you wish to do interpolation, be sure to make use the proper time variables: 
//  time is previous packet time, 
//  servertime is new packet time, 
//so the tick time between packets is servertime - time and the interpolation should begin 
//the new move at servertime and end at servertime + (servertime - time)
void(float isnew) CSQC_Ent_Update =
{
  sendent_handle_update( isnew );
};

// 
/*
  called when a network slot is emptied, you may choose to remove(self) or not - Darkplaces
  
  context: CSQC DOES NOT know the 'why' behind calling the Remove() function, but its important
    to know the 2 main 'whys'.
      1) Entity was removed/deallocated from the Server, ie SSQC.remove(entity);
      2) Entity fell out of client's view scope, and no longer visible to client.
      
    knowing these 2 cases makes all the difference about executing this function.
*/
void() CSQC_Ent_Remove ={
  local entity weps;
  local entity next;
  local entity rem;
  
  self.entnum = 0; //clears out old reference, must have!
  
  if( (self.flags & FL_CLIENT) ){
    if(self.t_remove){
      if(!self.t_remove()){
        remove(self);
      }
    }
    else{
      remove(self);
    }
  }
  else{  
    if( self.data_type == DATA_VEHC || self.data_type == DATA_MECH || self.data_type == DATA_BLD ){
      weps = self.w_slot;
      while( weps ){
        next = weps.w_slot;
        rem = weps;
        weps = next;
        if( rem.owner == self ){
          remove(rem);
        }
      }
      if( self.torsoCenter.owner == self ){
        remove(self.torsoCenter);
      }
      if( self.torsoLeft.owner == self ){
        remove(self.torsoLeft);
      }
      if( self.torsoRight.owner == self ){
        remove(self.torsoRight);
      }
      if( self.armLeft.owner == self ){
        remove(self.armLeft);
      }
      if( self.armRight.owner == self ){
        remove( self.armRight);
      }
      if( self.legs.owner == self ){
        remove(self.legs );
      }
      if( self.effect1.owner == self ){
        remove(self.effect1 );
      }
      if( self.effect2.owner == self ){
        remove(self.effect2 );
      }
      if( self.effect3.owner == self ){
        remove(self.effect3 );
      }
    }
    freeGlobalString(self.netname)
  }
  if( wasfreed(self) ){
    return;
  }
  remove(self);
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

