// called during level initialization, before first entities are received, only world is valid at this point
void() CSQC_Init =
{
  registercvar("gamemode", "0");
  registercvar("gametype", "0");
  registercommand("fog");

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
  
  TQSIZE = 3;
  TRTIME = 0;
  TR_TIME_NEXT = 0;
  TQUED = FALSE;
  
  TRANSMISSIONQUEUE[0] = strzone(NULL_SOUND);
  TRANSMISSIONQUEUE[1] = strzone(NULL_SOUND);
  TRANSMISSIONQUEUE[2] = strzone(NULL_SOUND);
  
  WEPBITS[0] = 1;
  WEPBITS[1] = 2;
  WEPBITS[2] = 4;
  WEPBITS[3] = 8;
  WEPBITS[4] = 16;
  WEPBITS[5] = 32;
  WEPBITS[6] = 64;
  WEPBITS[7] = 128;
  WEPBITS[8] = 256;

  SELECT_MECH = 0;
  LAUNCH_VALIDATION = 0; //set launch validation to 0 to prevent invalid deployments to game world
  
  local float i, cnt;
  //clear out and prepare the sound queue
  i = 1;
  while( i < VQSIZE ){
    SOUNDQUEUE[i] = "null";
    i = i + 1;
  }
  //clear out and prepare mech lists
  cnt = 1;
  while(cnt <= GAME_TOTAL_MECHS){
    UNLOCKED_MECHS[cnt] = 0;
    MECHLIST_LIGHT_ARR[cnt] = 0;
    MECHLIST_MEDIUM_ARR[cnt] = 0;
    MECHLIST_HEAVY_ARR[cnt] = 0;
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
  NAVNAMES[3] = "Gamma";
  NAVNAMES[4] = "Delta";
  NAVNAMES[5] = "Epsilon";
  NAVNAMES[6] = "Zeta";
  NAVNAMES[7] = "Eta";
  NAVNAMES[8] = "Theta";
  NAVNAMES[9] = "Iota";
  NAVNAMES[10] = "Kappa";
  NAVNAMES[11] = "Lambda";
  NAVNAMES[12] = "Mu";
  NAVNAMES[13] = "Nu";
  NAVNAMES[14] = "Xi";
  NAVNAMES[15] = "Omicron";
  NAVNAMES[16] = "Rho";
  NAVNAMES[17] = "Tau";
  NAVNAMES[18] = "Upsilon";
  NAVNAMES[19] = "Phi";
  NAVNAMES[20] = "Omega";
  
  ANM_FILE_STATUS = 0;
  
  //get mission file
  cs_precache();
  dynamic_precache();
  
  //clean up mapname global for file use
  tokenizebyseparator(mapname, "/", ".");
  MAP_NAME = argv(1);
  MAP_NAME = strzone(MAP_NAME);
  
  DEPLOY_CNT = 0;
  CFG_INDEX = 0;
  CFG_INDEX_PREV = CFG_INDEX;
  
  UI_HANGAR_DATA_mech = spawn();
  UI_ARMING_DATA_item_a = spawn();
  UI_ARMING_DATA_item_b = spawn();
  UI_ARMING_DATA_item_list = spawn();
  
  //ui data from text files /data/ui/
  ui_data_load_mechsizes();
  ui_data_load_itemnames();
  ui_data_load_itemicons();
  ui_data_load_hudnames();
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
    cvar_set("r_shadow_realtime_world", ftos(1));
  }
  HUD_ALPHA = cvar("cl_hud_alpha"); 
	/*local vector vf_size;
	local vector vf_min;
	
	local float chasecam, vid_width, vid_height,vid_conwidth,vid_conheight,vid_pixelheight;
	vf_size = getpropertyvec(VF_SIZE);
	vf_min = getpropertyvec(VF_MIN);
CON_W = vid_conwidth = cvar("vid_conwidth");
	CON_H = vid_conheight = cvar("vid_conheight");
	vid_pixelheight = cvar("vid_pixelheight");
  VIEW_SCALE = (w/h)/10;
	chasecam = cvar("chase_active") != 0;*/

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
  setproperty(VF_ORIGIN, pmove_org);
  setproperty(VF_ANGLES, input_angles);
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
        if( MECH_DATA_ID != CLIENT_data_idx){
          ui_data_load_mech(CLIENT_data_idx);
        }
      }
    }
    //nav points are occluded by player 2D HUD so that the overlap doesn't interfere with reading the HUD
    if(CLIENT_player_state >= PLAYER_POWERUP_BEGIN){
      local float itr;
      itr = 0;
      while( itr <= 21 ){
        ui_renderNav( itr );
        itr = itr + 1;
      }
    }
    //snd_hud_vfx_armlistener(plr_ct, 1, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(CLIENT_hp_stor2, 2, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(CLIENT_hp_stor, 4, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(CLIENT_hp_arm2, 8, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(CLIENT_hp_arm, 16, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(CLIENT_hp_leg, 32, SND_HUD_VFX_CRITLEG);
    
    //HUD SOUND SYSTEM LISTENERS
    snd_hud_vfx_statelistener(CLIENT_player_state);
    snd_hud_vfx_enelistener(CLIENT_energy);
    snd_hud_vfx_toggleradar(CLIENT_stat_rdr_mode);
    snd_hud_vfx_targkill(CLIENT_stat_trg_ddflg);
    
    //HUD RENDER FRAME SYSTEM
    data_hud_frame();
    
    if(CLIENT_player_state == PLAYER_SPRINT_ON){
      local float slen;
      local vector spos;
      local string msg;
      local vector msgClr;
      if( cvar("cl_movespeedkey") > 1 ){
        msg = "[EVASION ON]";
        msgClr = CLR_DEF_RET_GETLOCK;
      }
      else{
        msg = "[EVASION DISABLED]";
        msgClr = CLR_DEF_RED;
      }
        slen = stringwidth(msg, 0, '12 10 0');
      slen = gui_percentXRaw(slen);
      spos_x = VIEW_CTR_x - slen / 2;
      spos_y = VIEW_CTR_y + gui_percentYRaw(56);
      drawstring(spos, msg, '12 10 0', msgClr, HUD_ALPHA, 0);
    }
    
    //HUD Highlight Boxes
    ui_renderHUD_Highlight_frame();
    ui_objective_frame(VIEW_ORG);
  }
  else{
    if(CLIENT_player_state == PLAYER_IN_MENU){
      if(!MENU_ACTIVE){
        MENU_ACTIVE = TRUE;
        CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
        setcursormode(1);
      }
    } 
    if(UI_OBJECTIVE_ACTIVE){
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
   
  //sound system;
  snd_hud_vfx_frame();
 
  //menu system
  if(MENU_ACTIVE){
    cursorpos = getmousepos();
    menu_handleFrame();
  }else{
    if(CLIENT_player_state >= PLAYER_POWERUP_BEGIN){
      local float itr;
      itr = 0;
      while( itr <= 21 ){
        ui_renderNav( itr );
        itr = itr + 1;
      }

      //TODO - fix?
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
  }
  
  //put this last on the rendering order to make sure it 
  //plays above all
  if(ANM_FILE_STATUS == 1){
    anm_execute_frame();
  }
  
  if( cvar("developer") ){
    local vector viewspot, viewang, porg, pang, torg;
    viewang_x = getstatf(STAT_PLR_ANG_X);
    viewang_y = getstatf(STAT_PLR_ANG_Y);
    viewang_z = getstatf(STAT_PLR_ANG_Z);
    viewspot_x =  getstatf(STAT_PLR_ORG_X);
    viewspot_y =  getstatf(STAT_PLR_ORG_Y);
    viewspot_z =  getstatf(STAT_PLR_ORG_Z);
    porg_x = pang_x = torg_x = VIEW_ORG_x;
    porg_y = pang_y = torg_y = VIEW_MAX_y;
    drawstring(porg + gui_percentToPixelRawVec('1 -30'), strcat("Player Origin: ", vtos(viewspot)), '8 8 0', '0.85 0.85 0.85', 1, 0);
    drawstring(torg + gui_percentToPixelRawVec('1 -10'), strcat("Tag Origin: ", vtos( viewang )), '8 8 0', '0.85 0.85 0.85', 1, 0); 
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
    case TE_CLIENT_INFO:
      client_get_info();
      return TRUE;
    case TE_CLIENT_PING:
      client_get_contact();
      return TRUE;
    case TE_UI_BOX:
      client_get_hud_highlight();
      return TRUE;
    case TE_EVT_OBJ:
      client_event_objective();
      return TRUE;
    case TE_EVT_NAV:
      client_event_navpoint();
      return TRUE;
    case TE_EVT_DEP:
      client_event_deploypoint();
      return TRUE;
    case TE_OBJECTIVE_COMPLETE:
      te_objective_complete( ReadByte() );
      return TRUE;
    case TE_OBJECTIVE_FAILED:
      te_objective_failed();
      return TRUE;
    case TE_MISSION_WIN:
      te_mission_win();
      return TRUE;
    case TE_MISSION_LOSE:
      te_mission_lose();
      return TRUE;
    case TE_NAV_REACH:
      te_nav_reach();
      return TRUE;
    case TE_MSN_BOUND:
      client_event_boundary();
      return TRUE;
    case TE_AI_VOICE:
      snd_hud_trnsmsn_addtoqueue(ReadString(), 1);
      return TRUE;
    case TE_TARG_KILL:
      te_targ_kill();
      return TRUE;
  } 
	return FALSE;
};
//TODO - mechs are no longer stored by id + size, rather just id, so, refactor this
// if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).
void(string s) CSQC_Parse_StuffCmd =
{
  local float argc;

  argc = tokenize(s);
  if(argv(0) == "mech"){
    if(argv(1) == "msn_file"){
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
  }
  else{
    if( argv(0) == "fog" ){
      cl_get_new_fog( s );
    }
    else if( argv(0) == "cd" ){  
      cl_get_new_music( s ) ;
    }
    else if( argv(0) == "in_pitch_max" ){
      HUD_PITCH_MAX = stof(argv(1));
      HUD_PITCH_MIN = stof(argv(3));
      localcmd(s);
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
};

// called when a network slot is emptied, you may choose to remove(self) or not
void() CSQC_Ent_Remove =
{
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

