// called during level initialization, before first entities are received, only world is valid at this point
void() CSQC_Init =
{
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
  VQIDX = 0;
  CRITBITS = -1;
  SQUED = FALSE;
  
  WEPBITS[0] = 1;
  WEPBITS[1] = 2;
  WEPBITS[2] = 4;
  WEPBITS[3] = 8;
  WEPBITS[4] = 16;
  WEPBITS[5] = 32;
  WEPBITS[6] = 64;
  WEPBITS[7] = 128;
  WEPBITS[8] = 256;
  
  SELECTED_MECH = world;  //ini the ui selection reference
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
  while(cnt < 25){
    MECHLIST_LIGHT_ARR[cnt] = 0;
    MECHLIST_MEDIUM_ARR[cnt] = 0;
    MECHLIST_HEAVY_ARR[cnt] = 0;
    cnt = cnt + 1;
  }
  //clear out and prepare master weapon list
  cnt = 1;
  while(cnt <= 32){
    WEPLIST_ALL[cnt] = 0;
    cnt = cnt + 1;
  }
  
  NAVNAMES[0] = "Unknown";
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
  snd_hud_vfx_cleanqueue();
  
  //get mission file
  cs_precache();
  data_ini_arrays();
  
  //clean up mapname global for file use
  tokenizebyseparator(mapname, "/", ".");
  MAP_NAME = argv(1);
  MAP_NAME = strzone(MAP_NAME);
  
  FRIK_FILE_precaches();
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
  local entity this;
  this = self;
  self = entitybyindex(player_localentnum);
  self.player_state = getstatf(STAT_PLR_STT);
  //console override
  if(evtype == 0){
    if( (scanx == K_TIL) || (scanx == K_APOS) || (scanx == K_ESCAPE) ){
      self = this;
      return FALSE; 
    }
  }
  //=====================
  if( (self.player_state == PLAYER_POWERUP_BEGIN) || (self.player_state == PLAYER_ANIM_STOP) ){
    self = this;
    return TRUE;
  }
  if(evtype == 0){
    if((scanx == K_TAB && self.data_type == DATA_POBS)){
        if(MENU_ACTIVE){
          MENU_ACTIVE = FALSE;
          self.plr_menu_choice = 0;
          setcursormode(0);
        }
        else{
          MENU_ACTIVE = TRUE;
          self.plr_menu_choice = MENU_BRIEF_ACTIVE;
          setcursormode(1);
        }
        self = this;
        return TRUE;
    }
    else if(scanx == K_MOUSE1){
      if(MENU_ACTIVE){
        if(self.plr_menu_choice == MENU_HANGAR_ACTIVE){
          menu_hangarListener();
        }
        else if(self.plr_menu_choice == MENU_BRIEF_ACTIVE){
          menu_briefListener();
        }
        else if(self.plr_menu_choice == MENU_ARMING_ACTIVE){
          menu_arming_listener();
        }
        else if(self.plr_menu_choice == MENU_DEPLOY_ACTIVE){
          menu_deployListener();
        }
        menu_mainListener();
        self = this;
        return TRUE;
      }
      else{
        self = this;
        return FALSE;
      }
    }
    else if(scanx == K_C){
      if(UI_OBJECTIVE_ACTIVE){
        UI_OBJECTIVE_ACTIVE = FALSE;
      }
      else{
        UI_OBJECTIVE_ACTIVE = TRUE;
      }
      self = this;
      return TRUE;
    }
    else if(scanx == K_SHIFT){
      self = this;
      return FALSE;
    }
  }
  else if(evtype == 2){
    if(MENU_ACTIVE){
      cursorpos_x = cursorpos_x + scanx;
      cursorpos_y = cursorpos_y + chary;
      if(cursorpos_x < 0){
        cursorpos_x = 0;
      }
      else if(cursorpos_x > VIEW_MAX_x){
        cursorpos_x = VIEW_MAX_x;
      }
      
      if(cursorpos_y < VIEW_ORG_y){
        cursorpos_y = VIEW_ORG_y;
      }
      else if(cursorpos_y > VIEW_MAX_y){
        cursorpos_y = VIEW_MAX_y;
      }
      self = this;
      return TRUE;
    }
    else{
      self = this;
      return FALSE;
    }
  }
  
  if(MENU_ACTIVE){
    self = this;
    return TRUE;
  }
  else{
    self = this;
    return FALSE;
  }
};

// the most important function in CSQC...
void(float w, float h, float menushown) CSQC_UpdateView =
{ 
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
    
  local entity this, player;
  this = self;
  //switch to client context
  self = entitybyindex(player_localentnum);
  
  receive_ent_bindData();
  
  //mission file load check
  if(MSN_FILEFOUND){
    if(MSN_LOADED == FALSE){
      msn_parsefile();
      MSN_LOADED = TRUE;
    }
  }
  
	// force switch to 2D polygon drawing in case we want to do any polygons before we draw pics and strings
	// FIXME: engine should have a drawflag for 3D and another for 2D (also would be nice to have 3D drawstring and drawpic)
	//drawstring('0 0 0', "", '1 1 0', '1 1 1', 0, 0);

	// draw custom hud
  //draw hud
  
  AVAILABLE_RESERVE = getstati(STAT_LVL_RES);
  if(self.player_state == PLAYER_SPAWN){
    localcmd(strcat("stopsound", "\n"));
  }
  
  if(self.data_type == DATA_MECH){  
    if(MENU_ACTIVE){
      if(self.player_state == PLAYER_POWERUP_BEGIN){
        MENU_ACTIVE = FALSE;
        self.plr_menu_choice = 0;
        setcursormode(0);
      }
    }
    
    //snd_hud_vfx_armlistener(plr_ct, 1, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_stor2, 2, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_stor, 4, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_arm2, 8, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(self.hp_arm, 16, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(self.hp_leg, 32, SND_HUD_VFX_CRITLEG);
    
    //HUD SOUND SYSTEM LISTENERS
    snd_hud_vfx_statelistener(self.player_state);
    snd_hud_vfx_enelistener(self.en_cur);
    snd_hud_vfx_toggleradar(self.stat_rdr_mode);
    snd_hud_vfx_targkill(self.stat_trg_ddflg);
    
    //target tracking info
    local float trg_dist;
    self.w_range = trg_dist;
    
    //render 
    local entity vec_data, oself;
    vec_data = m_findMechData(self.vec_size, self.data_idx);
    
    //UPDATE SPRINTING ABILITY BASED ON ENERGY
    if(self.en_cur < 10){
      cl_set_movespeedkey(1);
    }
    else {
      local float cl_sprint;
      cl_sprint = cvar("cl_movespeedkey");
      if(cl_sprint == 1){
        cl_set_movespeedkey(vec_data.m_maccel);
      }
    }
    
    //HUD RENDER FRAME SYSTEM
    hud_frame(self.data_idx, self.vec_size);
    
    local float bx_time;
    bx_time = getstati(UI_BOX_TIME);
    if(bx_time > 0){
      ui_renderHUDHighlight();
    }
    ui_objective_frame(VIEW_ORG);
  }
  else{
    if(self.player_state == PLAYER_IN_MENU){
      if(!MENU_ACTIVE){
        MENU_ACTIVE = TRUE;
        self.plr_menu_choice = MENU_BRIEF_ACTIVE;
        setcursormode(1);
      }
    } 
    if(UI_OBJECTIVE_ACTIVE){
      local float len;
      local vector og;
      local string mesg;
      if(self.player_state == PLAYER_SPAWN){
        len = stringwidth("Press any key to respawn", 0, '8 8 0');
        mesg = "Press any key to respawn";
      }
      else if(self.player_state == PLAYER_IN_MENU){
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
    if(self.player_state >= PLAYER_POWERUP_BEGIN){
      local entity nav;
      nav = findchain(classname, "data");
      while(nav){
        if(nav.data_type == DATA_NAVP){
          ui_renderNav(nav);
        }
        nav = nav.chain;
      }
      local entity player;
      player = findchainflags(flags, FL_CLIENT);
      while(player){
        if( (player.data_type != DATA_POBS) ){
          if(player.netname != self.netname){
            ui_renderClientName(player);
          }
        }
        player = player.chain;
      }
    }
  }
  
  //put this last on the rendering order to make sure it 
  //plays above all
  if(self.ANM_FILE_STATUS == 1){
    anm_execute_frame();
  }
  
  if(cvar("mechdev") == TRUE){
    local vector viewspot, viewang, porg, pang, torg;
    viewspot_x = getstatf(STAT_TRG_ORG_X);
    viewspot_y = getstatf(STAT_TRG_ORG_Y);
    viewspot_z = getstatf(STAT_TRG_ORG_Z);
    viewang_x = getstatf(STAT_PLR_ANG_X);
    viewang_y = getstatf(STAT_PLR_ANG_Y);
    viewang_z = getstatf(STAT_PLR_ANG_Z);
    porg_x = pang_x = torg_x = VIEW_ORG_x;
    porg_y = pang_y = torg_y = VIEW_MAX_y;
    drawstring(porg + gui_percentToPixelRawVec('1 -30'), strcat("Player Origin: ", vtos(pmove_org)), '8 8 0', '0.85 0.85 0.85', 1, 0);
    drawstring(pang + gui_percentToPixelRawVec('1 -20'), strcat("Player Angles: ", vtos(viewang)), '8 8 0', '0.85 0.85 0.85', 1, 0);
    drawstring(torg + gui_percentToPixelRawVec('1 -10'), strcat("Tag Origin: ", vtos(viewspot)), '8 8 0', '0.85 0.85 0.85', 1, 0); 
  }
  
  self = this;
};

// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command
float(string s) CSQC_ConsoleCommand =
{
	return FALSE;
};

// parse tempentity if it suits your fancy, return TRUE to tell engine you have finished parsing the tempentity, return FALSE to tell engine to parse tempentity itself (it will reset parse position automatically)
float() CSQC_Parse_TempEntity =
{
  local float id, handled;
  id = ReadByte();
  if(id == TE_LASER_BEAM){
    local vector org, end, ang;
    local float dist, p;
    org_x = ReadCoord();
    org_y = ReadCoord();
    org_z = ReadCoord();
    end_x = ReadCoord();
    end_y = ReadCoord();
    end_z = ReadCoord();
    te_beam_laser(org, end);
    handled = TRUE;
  }
  else if(id == TE_ESR_BEAM){
    local vector org, end, ang;
    local float dist, p;
    org_x = ReadCoord();
    org_y = ReadCoord();
    org_z = ReadCoord();
    end_x = ReadCoord();
    end_y = ReadCoord();
    end_z = ReadCoord();
    te_beam_esr(org, end);
    handled = TRUE;
  }
  else if(id == TE_PAC_BEAM){
    local vector org, end, ang;
    local float dist, p;
    org_x = ReadCoord();
    org_y = ReadCoord();
    org_z = ReadCoord();
    end_x = ReadCoord();
    end_y = ReadCoord();
    end_z = ReadCoord();
    te_beam_pac(org, end);
    handled = TRUE;
  }
	return handled;
};

// if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).
void(string s) CSQC_Parse_StuffCmd =
{
  local float argc;
  local entity client, this;
  client = entitybyindex(player_localentnum);
  this = self;
  self = client;
  argc = tokenize(s);
  if(argv(0) == "mech"){
    if(argv(1) == "msn_file"){
      cl_get_msnfile(strzone(argv(2)));
    }
    else if(argv(1) == "anm_file"){
      cl_get_animfile( argv(2) );
    }
    else if(argv(1) == "list_light"){
      tokenizebyseparator(s, "[", "]");
      cl_get_mechs_light( argv(1) );
    }
    else if(argv(1) == "list_med"){
      tokenizebyseparator(s, "[", "]");
      cl_get_mechs_medium( argv(1) );
    }
    else if(argv(1) == "list_hvy"){
      tokenizebyseparator(s, "[", "]");
      cl_get_mechs_heavy( argv(1) );
    }
    else if(argv(1) == "list_items"){
      tokenizebyseparator(s, "[", "]");
      cl_get_items_all( argv(1) );
    }
    else if(argv(1) == "gamemode"){
      cvar_set(argv(2), "1");
    }
  }
  else{
    localcmd(s);
  }
  self = this;
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

/*
// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
entity(float entnum) CSQC_Ent_Spawn =
{
	return spawn();
};
*/

// parse a network update, isnew indicates this network slot was previously empty
// if you wish to do interpolation, be sure to make use the proper time variables: time is previous packet time, servertime is new packet time, so the tick time between packets is servertime - time and the interpolation should begin the new move at servertime and end at servertime + (servertime - time)
void(float isnew) CSQC_Ent_Update =
{
  local float id;
  id = ReadByte();
  if(id == DATA_NAVP){
    if(isnew){
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.classname = "data";
      self.drawmask = MASK_ENGINE;
      self.value1 = 0;
      self.isActive = 0;
    }
    self.data_type = DATA_NAVP;
    self.nav_name = ReadByte();
    self.i_faction = ReadByte();
    self.value1 = self.isActive;
    self.isActive = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    setorigin(self, self.origin);
    self.w_name = gui_getNavName(self.nav_name);
    snd_hud_vfx_navpointlistener(self.value1, self.isActive);
  }
  else if(id == DATA_OBJT){
    if(isnew){
      self.classname = "data";
      self.data_type = DATA_OBJT;
      self.drawmask = MASK_ENGINE;
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.value1 = 0;
      self.isActive = 0;
      self.data_idx = 0;
    }
    self.data_idx = ReadByte();
    self.i_faction = ReadByte();
    self.value1 = self.isActive;
    self.isActive = ReadByte();
    setorigin(self, self.origin);
    snd_hud_vfx_objectivelistener(self.value1, self.isActive);
  }
  //AI test...
  else if(id == DATA_MECH_AI){
    self.data_idx = ReadByte();
    self.vec_size = ReadByte();
    self.data_type = DATA_MECH;
    if(isnew){
      self.drawmask = MASK_ENGINE;
    }
    self.sh_cur = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();  
    setorigin(self, self.origin);
  }
  else if(id == DATA_BLD){
    self.data_idx = ReadByte();
    self.data_type = DATA_BLD;
    if(isnew){
      local entity dat;
      dat = m_findData(self.data_idx, DATA_BLD);
      setmodel(self, dat.e_model);
      self.drawmask = MASK_ENGINE;
      //self.solid = SOLID_BSP;
    }
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
    setorigin(self, self.origin);
  }
  else if(id == DATA_VEHC){
    self.data_type = DATA_VEHC;
    self.data_idx = ReadByte();
    self.vec_size = ReadByte();
    if(isnew){
      self.drawmask = MASK_ENGINE;
    }
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    setorigin(self, self.origin);
  }
  else if(id == DATA_DEPL){
   if(isnew){
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.classname = "data";
      self.drawmask = MASK_ENGINE;
      self.value1 = 0;
      self.isActive = 0;
      addentity(self);
    }
    self.data_type = DATA_DEPL;
    self.nav_name = ReadByte();
    self.i_faction = ReadByte();
    self.isActive = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    setorigin(self, self.origin);
  }
  else if( id ==  DATA_INFO_START ){
    receive_ent_clientData(isnew);
  }
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

