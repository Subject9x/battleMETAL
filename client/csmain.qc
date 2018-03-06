
float() player_predraw;
float() obs_predraw;
// called during level initialization, before first entities are received, only world is valid at this point
void() CSQC_Init =
{
	maxclients = 0;
	while (maxclients < 1024 && getplayerkeyvalue(maxclients, "viewentity")){
		maxclients = maxclients + 1;
  }
  
	// this is the place to do any registercmd() calls we want for custom csqc commands (like replacing +showscores) so that they tab-complete properly
	// we can precache_sound and precache_model and precache_pic here
  //plr_orig = '0 0 0';
  //plr_angles = '0 0 0';
  VIEW_ORG = '0 0';
  PLAYER_HELPER = spawn();
  PLAYER_HELPER.drawmask = MASK_ENGINE;
  PLAYER_HELPER.plr_sel_mech = 0;
  PLAYER_HELPER.vec_size = 1;
  PLAYER_HELPER.plr_nex_mech = 0;
  PLAYER_HELPER.plr_sel_list_wep = 0;
  PLAYER_HELPER.plr_nex_wep1 = -1;
  PLAYER_HELPER.plr_nex_wep2 = -1;
  PLAYER_HELPER.plr_nex_wep3 = -1;
  PLAYER_HELPER.plr_nex_wep4 = -1;
  PLAYER_HELPER.plr_nex_wep6 = -1;
  PLAYER_HELPER.plr_nex_wep7 = -1;
  PLAYER_HELPER.plr_nex_wep8 = -1;
  PLAYER_HELPER.plr_nex_wep9 = -1;
  PLAYER_HELPER.plr_nex_grp1 = 0;
  PLAYER_HELPER.plr_nex_grp2 = 0;
  PLAYER_HELPER.plr_nex_grp3 = 0;
  PLAYER_HELPER.plr_nex_grp4 = 0;
  PLAYER_HELPER.plr_nex_grp5 = 0;
  PLAYER_HELPER.plr_nav_pnt = 0;
  PLAYER_HELPER.plr_menu_choice = MENU_BRIEF_ACTIVE;
  PLAYER_HELPER.w_range = 0;
  PLAYER_HELPER.wep1_reload = 0;
  PLAYER_HELPER.drawme = 0;
  PLAYER_HELPER.VOICE_QUEUE_SIZE = 6;
  PLAYER_HELPER.SOUND_QUEUE_1 = "null";
  PLAYER_HELPER.SOUND_QUEUE_2 = "null";
  PLAYER_HELPER.SOUND_QUEUE_3 = "null";
  PLAYER_HELPER.SOUND_QUEUE_4 = "null";
  PLAYER_HELPER.SOUND_QUEUE_5 = "null";
  PLAYER_HELPER.SOUND_QUEUE_6 = "null";
  setorigin(PLAYER_HELPER, '0 0 64');
  
  WEPBITS[0] = 1;
  WEPBITS[1] = 2;
  WEPBITS[2] = 4;
  WEPBITS[3] = 8;
  WEPBITS[4] = 16;
  WEPBITS[5] = 32;
  WEPBITS[6] = 64;
  WEPBITS[7] = 128;
  WEPBITS[8] = 256;
  
  local float i, cnt;
  i = 1;
  cnt = 1;
  while(i < 25){
    MECHLIST_LIGHT_ARR[cnt] = i;
    i = i * 2;
    cnt = cnt + 1;
  }
  i = 1;
  cnt = 1;
  while(i < 25){
    MECHLIST_MEDIUM_ARR[cnt] = i;
    i = i * 2;
    cnt = cnt + 1;
  }
  i = 1;
  cnt = 1;
  while(i < 25){
    MECHLIST_HEAVY_ARR[cnt] = i;
    i = i * 2;
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
  if(self.player_state == PLAYER_POWERUP_BEGIN){
    return TRUE;
  }
  if(evtype == 0){
    if((scanx == K_TAB && self.data_type == DATA_POBS)){
        if(MENU_ACTIVE){
          MENU_ACTIVE = FALSE;
          PLAYER_HELPER.plr_menu_choice = 0;
          setcursormode(0);
        }
        else{
          MENU_ACTIVE = TRUE;
          PLAYER_HELPER.plr_menu_choice = MENU_BRIEF_ACTIVE;
          setcursormode(1);
        }
        return TRUE;
    }
    else if(scanx == K_MOUSE1){
      if(MENU_ACTIVE){
        if(PLAYER_HELPER.plr_menu_choice == MENU_HANGAR_ACTIVE){
          menu_hangarListener();
        }
        else if(PLAYER_HELPER.plr_menu_choice == MENU_BRIEF_ACTIVE){
          menu_briefListener();
        }
        else if(PLAYER_HELPER.plr_menu_choice == MENU_ARMING_ACTIVE){
          menu_arming_listener();
        }
        else if(PLAYER_HELPER.plr_menu_choice == MENU_DEPLOY_ACTIVE){
          menu_deployListener();
        }
          menu_mainListener();
        return TRUE;
      }
      else{
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
      return TRUE;
    }
    else if(scanx == K_SHIFT){
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
      return TRUE;
    }
    else{
      return FALSE;
    }
  }
  
  if(MENU_ACTIVE){
    return TRUE;
  }
  else{
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
  if(self.data_type == DATA_MECH){
    setproperty(VF_ORIGIN, pmove_org);
    setproperty(VF_ANGLES, input_angles);
  }
  else{ 
    setproperty( VF_ORIGIN, self.origin);
    setproperty( VF_ANGLES, input_angles );
  }

  setproperty(VF_ANGLES, view_angles);
  //VF_ORIGIN+VF_ANGLES+VF_AFOV+VF_MIN+VF_SIZE
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
	// TODO: do clientside viewmodel entity instead
	addentities(MASK_NORMAL | MASK_ENGINE);

  /*if(self.data_type == DATA_MECH){
    setproperty(VF_ORIGIN, pmove_org);
    setproperty(VF_ANGLES, input_angles);
  }
  else{ 
    setproperty( VF_ORIGIN, self.origin);
    setproperty( VF_ANGLES, input_angles );
  }*/
  

	// draw the main view
	renderscene();

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
        PLAYER_HELPER.plr_menu_choice = 0;
        setcursormode(0);
      }
    }
    //player general info
    local float conv_x, conv_y, pitch;
    conv_x = getstatf(STAT_SPR_X);
    conv_y = getstatf(STAT_SPR_Y);
    pitch = input_angles_x *-3;
    
    //player camera_transform
    PLR_VIEW_x = getstatf(STAT_CAM_ORG_X);
    PLR_VIEW_y = getstatf(STAT_CAM_ORG_Y);
    PLR_VIEW_z = getstatf(STAT_CAM_ORG_Z);
    makevectors(input_angles);
    PLAYER_HELPER.angles_y = input_angles_y;
    PLR_VIEW = pmove_org;
    setorigin(PLAYER_HELPER, pmove_org);
    
    //snd_hud_vfx_armlistener(plr_ct, 1, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_stor2, 2, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_stor, 4, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(self.hp_arm2, 8, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(self.hp_arm, 16, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(self.hp_leg, 32, SND_HUD_VFX_CRITLEG);
    
    //target tracking info
    local float trg_ddflg, trg_dist, trg_dir, trg_lock;
    local vector trg_pos;
    trg_ddflg = getstati(STAT_TRG_DDFLG);
    trg_dir = getstati(STAT_TRG_FACE);
    trg_lock = getstati(STAT_LCK_STT);
    PLAYER_HELPER.w_range = trg_dist;
    //render 
    local entity player_hud, vec_data, oself;
    vec_data = m_findMechData(self.vec_size, self.data_idx);
    player_hud = m_findHUDData(self.vec_size, self.data_idx);
    
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
    
    //HUD SOUND SYSTEM LISTENERS
    snd_hud_vfx_statelistener(self.player_state);
    snd_hud_vfx_enelistener(self.en_cur);
    snd_hud_vfx_toggleradar(self.stat_rdr_mode);
    snd_hud_vfx_targkill(trg_ddflg);
    
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
        PLAYER_HELPER.plr_menu_choice = MENU_BRIEF_ACTIVE;
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
  if(isdemo()){
    local float len;
    local vector og;
    local string mesg;
    len = stringwidth("Alpha v0.0.1", 0, '8 8 0');
    mesg = "Alpha v0.0.1";
    drawstring(gui_percentToPixelRawVec('4 4'), mesg, '8 8 0', '1 1 1', 0.85, 0);
    
    og_x = VIEW_MAX_x - gui_percentXRaw((len/2) + 4);
    og_y = VIEW_MAX_y - gui_percentYRaw(12);
    drawstring(og, mesg, '8 8 0', '1 1 1', 0.85, 0);
    
    og_x = VIEW_MAX_x - gui_percentXRaw((len/2) + 4);
    og_y = VIEW_ORG_y + gui_percentYRaw(4);
    drawstring(og, mesg, '8 8 0', '1 1 1', 0.85, 0);
    
    og_x = VIEW_ORG_x + gui_percentXRaw(4);
    og_y = VIEW_MAX_y - gui_percentYRaw(12);
    drawstring(og, mesg, '8 8 0', '1 1 1', 0.85, 0);
  }
  //setorigin(PLAYER_HELPER, PLR_VIEW);
  PLAYER_HELPER.origin = PLR_VIEW;
  
  //display remaining reserves;
  //10/28/2017 - MOVE TO OBJECTIVE / MISSION STATUS HOTKEY SCREEN
  /*local string res;
  local float reslen;
  local vector src;
  res = strcat("[RESERVES]:",ftos(AVAILABLE_RESERVE),"/", MSN_RESERVETOTAL);
  reslen = stringwidth(res, 0, '8 8 0');
  src_x = VIEW_ORG_x + gui_percentX(0.008);
  src_y = VIEW_ORG_y + gui_percentY(0.008);
  drawstring(src, res, '8 8 0', CLR_DEF_ARM_OK, HUD_ALPHA, 0);*/
  
  //sound system;
  snd_hud_vfx_frame();
 
  //menu system
  if(MENU_ACTIVE){
    cursorpos = getmousepos();
    menu_handleFrame();
  }else{  
    if(self.ANM_FILE_STATUS == 1){
      anm_execute_frame();
    }
    
    drawstring(VIEW_ORG+'2 2', vtos(self.origin), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(self.player_state >= PLAYER_POWERUP_BEGIN){
      local entity nav;
      nav = findchain(classname, "data");
      while(nav){
        if(nav.data_type == DATA_NAVP){
          ui_renderNav(nav);
        }
        nav = nav.chain;
      }
    }
  }
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
  argc = tokenize(s);
  if(argv(0) == "mech"){
    if(argv(1) == "msn_file"){
      MSN_FILENAME = strzone(argv(2));
      msn_getfile();
    }
    else if(argv(1) == "anm_file"){
      if(self.ANM_FILE_STATUS == 0){
        anm_parseFile(argv(2));
      }
    }
    else if(argv(1) == "list_light"){
      PLAYER_HELPER.parm7 = stof(argv(2));
    }
    else if(argv(1) == "list_med"){
      PLAYER_HELPER.parm8 = stof(argv(2));
    }
    else if(argv(1) == "list_hvy"){
      PLAYER_HELPER.parm9 = stof(argv(2));
    }
  }
  else{
    localcmd(s);
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
  if(soundname == "sound/misc/menu1.wav"){
    return FALSE;
  }
  else if((self.player_state < PLAYER_POWERUP_BEGIN) && (self.data_type == DATA_MECH)){
    return TRUE;
  }
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
      self.solid = SOLID_BSP;
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
  else if(id == DATA_PLR){
    if(isnew){
      self.ANM_FILE_STATUS = 0;
      self.classname = "player";
      self.solid = SOLID_SLIDEBOX;
      self.predraw = obs_predraw;       
      self.drawmask = MASK_ENGINE;
      setmodel(self, "q3mdl/testball.md3");
    }
    self.data_type = ReadByte();
    self.i_faction = ReadByte();
    self.player_state = ReadByte();
    self.flags = ReadByte();
    
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.origin_phys = self.origin;
    
    
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
    self.velocity_x = ReadLong();
    self.velocity_y = ReadLong();
    self.velocity_z = ReadLong();
    
    setsize(self, '-4 -4 -4', '4 4 4');
    setorigin(self, self.origin);
    
    if(self.data_type == DATA_MECH){
      self.data_idx = ReadByte();
      self.vec_size = ReadByte(); 
      self.stat_rdr_mode = ReadByte();
      self.radar_range = ReadLong();
      self.hp_ctor = ReadByte();
      self.hp_leg = ReadByte();
      self.hp_stor = ReadByte();
      self.hp_stor2 = ReadByte();
      self.hp_arm = ReadByte();
      self.hp_arm2 = ReadByte();
      
      self.en_cur = ReadByte();
      self.sh_cur = ReadByte();
      self.stat_hit_dirs = ReadByte();
      self.stat_ret_dist = ReadLong();
      //WEAPON DATA
      self.currentWeaponGroup = ReadByte();
      self.stat_wep_rel = ReadByte();
      local float wepCount, wepItr;
      wepCount = ReadByte();
      wepItr = 1;
      while(wepItr < wepCount + 1){
        if(wepItr == 1){
          self.stat_w1_id = ReadByte();
          self.stat_w1_rel = ReadByte();
        }
        else if(wepItr == 2){
          self.stat_w2_id = ReadByte();
          self.stat_w2_rel = ReadByte();
        }
        else if(wepItr == 3){
          self.stat_w3_id = ReadByte();
          self.stat_w3_rel = ReadByte();
        }
        else if(wepItr == 4){
          self.stat_w4_id = ReadByte();
          self.stat_w4_rel = ReadByte();
        }
        else if(wepItr == 5){
          self.stat_w5_id = ReadByte();
          self.stat_w5_rel = ReadByte();
        }
        else if(wepItr == 6){
          self.stat_w6_id = ReadByte();
          self.stat_w6_rel = ReadByte();
        }
        else if(wepItr == 7){
          self.stat_w7_id = ReadByte();
          self.stat_w7_rel = ReadByte();
        }
        else if(wepItr == 8){
          self.stat_w8_id = ReadByte();
          self.stat_w8_rel = ReadByte();
        }
        else if(wepItr == 9){
          self.stat_w9_id = ReadByte();
          self.stat_w9_rel = ReadByte();
        }
        wepItr = wepItr + 1;
      }
    }
    
    self.stat_trg_vid = ReadByte();
    if(self.stat_trg_vid != 255 && self.stat_trg_vid > 0){
      self.target_datatype = ReadByte();
      self.target_faction = ReadByte();
      self.stat_trg_face = ReadByte();
      self.stat_trg_ct_hp = ReadByte();
      self.target_origin_x = ReadCoord();
      self.target_origin_y = ReadCoord();
      self.target_origin_z = ReadCoord();
      if((self.target_datatype == DATA_MECH) || (self.target_datatype == DATA_MECH_AI)){
        self.target_datatype = DATA_MECH;
        self.target_vecsize = ReadByte();
        self.stat_trg_lt_hp = ReadByte();
        self.stat_trg_rt_hp = ReadByte();
        self.stat_trg_la_hp = ReadByte();
        self.stat_trg_ra_hp = ReadByte();
        self.stat_trg_lg_hp = ReadByte();
        self.target_shield = ReadByte();
      }
      else if(self.target_datatype == DATA_VEHC){
        self.target_vecsize = ReadByte();
        self.stat_trg_lg_hp = ReadByte();
        self.target_shield = ReadByte();
      }
      else if(self.target_datatype == DATA_BLD){
        self.target_vecsize = 0 ;
        self.target_shield = ReadByte();
      }
    }
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

//http://forums.insideqc.com/viewtopic.php?f=2&t=2871
float() obs_predraw={
  if(self.entnum == player_localentnum){
    local float sys_ticrate;
    local vector v;
    sys_ticrate = cvar("sys_ticrate");

    if (self.solid){
      if (time > self.timer_phys + sys_ticrate){
        
        self.origin_old = self.origin_phys;
        while (time > self.timer_phys + sys_ticrate){
          self.timer_phys = self.timer_phys + sys_ticrate;
          self.origin_phys = self.origin_phys + self.velocity * sys_ticrate;
        }
      }
      
      self.timer_r = ( time - self.timer_phys ) / sys_ticrate;
      v = self.origin_old + ( self.origin_phys - self.origin_old ) * self.timer_r;

      setorigin(self, v);
    } 
    addentity( self );
  }
  else{
    addentity( self );
  }
};

// called on each entity each frame if self.nextthink <= time + frametime
//.void() think;

// this function is called when a transformview message is received (when you enter a warpzone), to allow you to customize the view transform
// return value is new origin
// v_forward, v_right, v_up must be set correctly
// trace_endpos should be set correctly (before call it will be the same value as org)
//.vector(vector org, vector ang, vector forward, vector right, vector up) camera_transform;

