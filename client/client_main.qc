// called during level initialization, before first entities are received, only world is valid at this point
void() CSQC_Init =
{
  local float i, cnt;
  registercvar("gamemode", "0");
  registercvar("gametype", "0");
  registercommand("fog");
  registercvar("cl_hud_sway", "1");

	maxclients = 0;
	while (maxclients < 1024 && getplayerkeyvalue(maxclients, "viewentity")){
		maxclients = maxclients + 1;
  }
  
	// this is the place to do any registercmd() calls we want for custom csqc commands (like replacing +showscores) so that they tab-complete properly
	// we can precache_sound and precache_model and precache_pic here
  VIEW_ORG = '0 0';
  
  //ini the HUD sound system
  CRITBITS = -1;
  SQSIZE = 6; //set to 6
  STIME = 0;
  STIME_NEXT = 0;
  VQSIZE = 6;
  SQUED = FALSE;
  
  TQSIZE = 8;
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
  NAVNAMES[19] = "Upsilon";
  NAVNAMES[20] = "Phi";
  NAVNAMES[21] = "Omega";
  
  ANM_FILE_STATUS = 0;
  
  //get mission file
  dynamic_precache();
  cs_precache();
  
  //clean up mapname global for file use
  tokenizebyseparator(mapname, "/", ".");
  MAP_NAME = argv(1);
  MAP_NAME = strzone(MAP_NAME);

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
  
  UI_HANGAR_DATA_mech.drawmask = MASK_NORMAL;
  UI_ARMING_DATA_item_a.drawmask = MASK_NORMAL;
  UI_ARMING_DATA_item_b.drawmask = MASK_NORMAL;
  UI_ARMING_DATA_item_list.drawmask = MASK_NORMAL;
  UI_ARMING_item_drag.drawmask = MASK_NORMAL;
  HUD_DATA_weapon.drawmask = MASK_NORMAL;
  UI_HANGAR_DATA_mech_list.drawmask = MASK_NORMAL;
  
  addentity(UI_HANGAR_DATA_mech);
  addentity(UI_ARMING_DATA_item_a);
  addentity(UI_ARMING_DATA_item_b);
  addentity(UI_ARMING_DATA_item_list);
  addentity(UI_ARMING_item_drag);
  addentity(HUD_DATA_weapon);
  addentity(UI_HANGAR_DATA_mech_list);
  
  MOUSE_drag_timer = 0;
  HUD_SHIELD_FLASH_TIME = 0;
  HUD_SHIELD_FLASH_ON = FALSE;
  HUD_SHIELD_FLASH = -1;
  
  //ui data from text files /data/ui/
  ui_data_load_mechsizes();
  ui_data_load_hudnames();

  //loadfont(string fontname, string fontmaps, string sizes, float slot, float fix_scale, float fix_voffset)
  FONT_NUM_ROBOT_LIGHT = loadfont("Roboto_Light", "gfx/fonts/Roboto_Light", "8 12 16 32", FONT_USER0, FALSE, FALSE);
  FONT_NUM_ROBOT_THIN = loadfont("Roboto_Thin", "gfx/fonts/Roboto_Thin", "8 12 16 32", FONT_USER1, FALSE, FALSE);
  FONT_NUM_ROBOT_REGULAR = loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "8 12 16 32", FONT_USER2, FALSE, FALSE);
  FONT_NUM_ROBOT_MEDIUM = loadfont("Roboto_Medium", "gfx/fonts/Roboto_Medium", "8 12 16 32", FONT_USER2, FALSE, FALSE);
  loadfont("Roboto-Light", "gfx/fonts/Roboto_Light", "6 8 10 12 16", FONT_DEFAULT, FALSE, FALSE);
  loadfont("Roboto_Regular", "gfx/fonts/Roboto_Regular", "6 8 10 12 16", FONT_CONSOLE, FALSE, FALSE);
  FONT_NUM_DYSTOPIAN = loadfont("Dystopian_Future", "gfx/fonts/Dystopian_Future", "6 8 10 12 16", FONT_USER3, FALSE, FALSE);
  
  cl_set_hud_vars_obs();
};

// called on level shutdown (disconnect, level change, quit, loading a saved game, etc)
void() CSQC_Shutdown =
{
  
  localcmd("cd stop\n");
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
void(float w, float h, float menushown) CSQC_UpdateView =
{

  //oh this is an ugly hack
  if( !cvar("r_shadow_realtime_world") ){
    cvar_set("r_shadow_realtime_world", "1");
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
  local vector fovvec,
                vf_sz,
                vf_mn;
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
  
  //setproperty(VF_ORIGIN, pmove_org);
  //setproperty(VF_ANGLES, input_angles);
  
  setproperty(VF_FOV, fovvec);
  setproperty(VF_DRAWWORLD, 1);
	setproperty(VF_DRAWCROSSHAIR, 0);
	setproperty(VF_DRAWENGINESBAR, 0);
  VIEW_ORG = '0 0';
  VIEW_MAX_x = cvar("vid_conwidth");
  VIEW_MAX_y = cvar("vid_conheight");
  VIEW_SIZE_x = VIEW_MAX_x * 2;
  VIEW_SIZE_y = VIEW_MAX_y * 2;
  VIEW_CTR_x = VIEW_MAX_x / 2;
  VIEW_CTR_y = VIEW_MAX_y / 2;
  VIEW_SCALE = 0.35;
  	// add any polygons we want here

	// add clientside entities (MASK_NORMAL)
	// add engine networked entities (MASK_ENGINE)
	// and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
	addentities( (MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS) );
  
	// draw the main view
	renderscene();
  
  //get player data from server
  client_get_info();
  
  //alter fog settings if needed
  cl_particles_fogFrame();
  
  //mission file load check
  if(MSN_FILEFOUND){
    if(MSN_LOADED == FALSE){
      msn_parsefile();
      MSN_LOADED = TRUE;
    }
  }
 
  /*
    special rant: the fact that the client itself, isn't a faffing global entity in the CLIENT
    module of all things is the height of idiocy.
  */
  //PLAYER_ENTITYNUM = getstati(STAT_PLR_ENT_ID); //this is ridiculous

  receive_ent_bindData();
	// force switch to 2D polygon drawing in case we want to do any polygons before we draw pics and strings
	// FIXME: engine should have a drawflag for 3D and another for 2D (also would be nice to have 3D drawstring and drawpic)
	//drawstring('0 0 0', "", '1 1 0', '1 1 1', 0, 0);

	// draw custom hud
  //draw hud
  
  AVAILABLE_RESERVE = 0;
  if(CLIENT_player_state == PLAYER_SPAWN){
    localcmd(strcat("stopsound", "\n"));
  }
  
  if(CLIENT_data_type == DATA_MECH){
    
    if(MENU_ACTIVE){
      if(CLIENT_player_state == PLAYER_POWERUP_BEGIN){
        MENU_ACTIVE = FALSE;
        CLIENT_MENU_menu_choice = 0;
        setcursormode(0);
        if( MECH_DATA_ID != CLIENT_data_idx ){
          ui_data_load_mech(CLIENT_data_idx);
        }
      }
    }

    //HUD SOUND SYSTEM LISTENERS
    
    //HUD RENDER FRAME SYSTEM
    if( CLIENT_health_center > 0 ){
      //Main HUD entry point
      data_hud_frame();
      
      //HUD Highlight Boxes
      hud_renderHighlight_frame();
      
      //Player has toggled 'Objectives' menu while in-mission.
      ui_objective_frame(VIEW_ORG);
      
      //Map has a .message value, and it's currently active for rendering
      if( MISSION_NAME_ON == TRUE ){
        client_event_mission_name_frame();
      }
    }
  }
  else{
    if(CLIENT_player_state == PLAYER_IN_MENU){
      if( !MENU_ACTIVE && !(LAUNCH_VALIDATION & VALID_LAUNCH) ){
        MENU_ACTIVE = TRUE;
        CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
        setcursormode( 1 );
        setpause( 1 );
      }
    }
    if(UI_OBJECTIVE_ACTIVE){
      //old PvP / co-op respawn state code. After death, this would tell the player to hit tab to spawn again.
      local float len;
      local vector og;
      local string mesg;
      if(CLIENT_player_state == PLAYER_SPAWN){
        len = stringwidth("Press any key to respawn", 0, '8 8 0');
        mesg = "Press any key to respawn";
      }
      else if(CLIENT_player_state == PLAYER_IN_MENU){
        len = stringwidth("Press [TAB] For Hangar Menu", 0, '8 8 0');
        mesg = "Press [TAB] For Hangar Menu";
      }
      og = VIEW_CTR;
      og_x = og_x - gui_percentXRaw(len/2);
      og_y = VIEW_CTR_y + gui_percentYRaw(32);
      drawstring(og, mesg, '8 8 0', '1 1 1', HUD_ALPHA, 0);
    }
  }
   
  //HUD sound system
  snd_hud_vfx_frame();
 
  //menu system
  if(MENU_ACTIVE){
    menu_handleFrame();
  }
  else{
    //multiplayer out of the question for now
    /*local entity player;
    player = findchainflags(flags, FL_CLIENT);
    while(player){
      if( (player.data_type != DATA_POBS) ){
        if(player.netname != self.netname){
          ui_renderClientName(player);
        }
      }
      player = player.chain;
    }*/
  }
  
  //put this last on the rendering order to make sure it 
  //plays above all
  if(ANM_FILE_STATUS == TRUE){
    anm_execute_frame();
  }
  
  if( cvar("developer") ){
    local vector porg, pang, torg;
    porg_x = pang_x = torg_x = VIEW_ORG_x;
    porg_y = pang_y = torg_y = VIEW_MAX_y;
    drawstring(porg + gui_percentToPixelRawVec('1 -30'), strcat("Player Origin: ", vtos(getpropertyvec(VF_ORIGIN))), '8 8 0', '0.85 0.85 0.85', 1, 0);
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
    case TE_UI_BOX:
      client_get_hud_highlight();
      return TRUE;
    case TE_MISSION_WIN:
      hud_event_enqueue( HUD_EVENT_MISSION_COMPLETE, 1) ;
      return TRUE;
    case TE_MISSION_LOSE:
      hud_event_enqueue( HUD_EVENT_MISSION_FAILED, 1) ;
      return TRUE;
    case TE_MISSION_END:
      client_event_debrief_active( ReadLong(), ReadLong(), ReadByte(), ReadShort(), ReadShort(), ReadShort(), ReadShort() );
      return TRUE;
    case TE_MSN_BOUND:
      client_event_boundary();
      return TRUE;
    case TE_AI_VOICE:
      snd_hud_trnsmsn_addtoqueue(ReadByte(), ReadByte(), ReadByte(), ReadLong());
      return TRUE;
    case TE_MISSION_NAME:
      client_event_mission_name( ReadString() );
      return TRUE;
    case TE_MSG_ENV_WARN:
      client_event_environment();
      return TRUE;
    //TODO -> MapKey Data to SendEntity
    case TE_MAPKEY_DATA:
      client_event_get_mapkeyinfo( ReadByte(), ReadLong(), ReadLong(), ReadByte() ) ;
      return TRUE;
    case TE_MSG_INFO:
      client_event_info_box( ReadString(), CLR_DEF_TXT_GRAY_SMOOTH, ReadLong(), '14 14 0');
      return TRUE;
    case TE_WEAPONS_ON:
      if( ReadByte() ){
        hud_event_enqueue( HUD_EVENT_WEAPONS_ON, 1) ;
      }
      else{
        hud_event_enqueue( HUD_EVENT_WEAPONS_OFF, 1) ;
      }
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
    case TE_VFX_WRECK:
      //                 float modelIndex, float skinNum, float lifetime, float vecSize, vector entOrg, vector entAngl
      particle_vehicle_wreck( ReadByte(), ReadByte(), ReadByte(), ReadByte(), te_read_vector(), te_read_angle() ) ;
      return TRUE;
    case TE_VFX_MECH:
      //                 float modelIndex, float skinNum, float vecSize, vector entOrg, vector entAngl
      particle_mech_chunk( ReadByte(), ReadByte(), ReadByte(), te_read_vector(), te_read_angle() ) ;
      return TRUE;
    case TE_VFX_EXPLODE:
      particle_missile_explode( te_read_vector(), ReadByte(), te_read_vector(), ReadByte(), ReadByte(), ReadByte() );
      return TRUE;
    case TE_MUZZLE_FLASH:
      particle_muzzle_flash( ReadByte(), te_read_vector(), te_read_vector(), ReadByte() ) ;
      return TRUE;
  } 
	return FALSE;
};
/*
  (Darkplaces)
  if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).

  (battleMETAL)
  All low-speed Client/Server commands go here, mostly stuff dealing with menu commands reaching the 
  server.
*/
void(string s) CSQC_Parse_StuffCmd =
{
  local float argc;

  argc = tokenize(s);
  if(argv(0) == "mech"){
    if(argv(1) == "missionFile"){
      cl_get_msnfile( argv(2) );
    }
    else if(argv(1) == "anm_file"){
      cl_get_animfile( argv(2) );
    }
    else if(argv(1) == "list_mechs"){
      tokenizebyseparator(s, "[", "]");
      cl_get_mechs_all( argv(1) );
    }
    else if(argv(1) == "list_items"){
      tokenizebyseparator(s, "[", "]");
      cl_get_items_all( argv(1) );
    }
    else if(argv(1) == "gamemode"){
      cvar_set("gamemode", argv(2));
    }
    else if(argv(1) == "unlock"){
      cl_unlock_stuff(s);
    }
    else if(argv(1) == "target"){
      CLIENT_target_name = strzone(argv(2));
    }
  }
  else{
    if( argv(0) == "fog" ){
      cl_get_new_fog( s );
    }
    else if( argv(0) == "cd" ){  
      cl_get_new_music( s ) ;
    }
    else{
      localcmd(s);
    }
  }
};

// if string is interesting, deal with it, otherwise pass it to print() to invoke the engine code.
void(string s) CSQC_Parse_Print =
{
	print(s);
};

// if string is interesting, deal with it, otherwise pass it to centerprint() to invoke the engine code.
void(string s) CSQC_Parse_CenterPrint =
{
	centerprint(s);
};

// return TRUE if you wish to eat this sound, return FALSE to let engine handle it.
float(entity ent, float channel, string soundname, float volume, float attenuation, vector pos, float speed100, float sflags) CSQC_Event_Sound =
{
	return FALSE;
};

float() CSQC_Parse_Event={
  return FALSE;
};


// return TRUE if you want to eat this event, otherwise return FALSE to let engine handle it.
// NOT USED IN DARKPLACES
float(float event) CSQC_Event =
{  
	return FALSE;
};


// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
/*entity(float entNum) CSQC_Ent_Spawn =
{
	return spawn();
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

// called when a network slot is emptied, you may choose to remove(self) or not
void() CSQC_Ent_Remove =
{
  if( self.torsoCenter != world ){
    remove(self.torsoCenter);
  }
  local entity weps;
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    remove(weps);
  }
	//if (self.t_remove)
		//if (self.t_remove())
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

