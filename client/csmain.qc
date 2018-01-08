
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
};

// called on level shutdown (disconnect, level change, quit, loading a saved game, etc)
void() CSQC_Shutdown =
{
};

// typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
// typ 1 = keyup (keysym, may have unicode character but generally not)
// typ 2 = mousemove (x, y) if inputmode is off
// typ 3 = mousepos (x, y) if inputmode is on
// return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent = {
  if(evtype == 0){
    if((scanx == K_TAB && getstati(STAT_PCLASS) == P_OBS)){
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
  setproperty(VF_ANGLES, view_angles);
  //VF_ORIGIN+VF_ANGLES+VF_AFOV+VF_MIN+VF_SIZE
  setproperty(VF_FOV, fovvec);
  setproperty(VF_DRAWWORLD, 1);
  /*if(MENU_ACTIVE){
  	setproperty(VF_DRAWCROSSHAIR, 0); // TODO custom crosshairs
  }
  else{
  	setproperty(VF_DRAWCROSSHAIR, 1); // TODO custom crosshairs
  }*/
	//setproperty(VF_DRAWCROSSHAIR, 1); // TODO custom crosshairs
	setproperty(VF_DRAWENGINESBAR, 0); // TODO custom hud
  VIEW_ORG = '0 0';
  VIEW_MAX_x = cvar("vid_conwidth");
  VIEW_MAX_y = cvar("vid_conheight");
  VIEW_SIZE_x = VIEW_MAX_x * 2;
  VIEW_SIZE_y = VIEW_MAX_y * 2;
  VIEW_CTR_x = VIEW_MAX_x / 2;
  VIEW_CTR_y = VIEW_MAX_y / 2;
  VIEW_SCALE = 0.35;
  
	// add clientside entities (MASK_NORMAL)
	// add engine networked entities (MASK_ENGINE)
	// and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
	// TODO: do clientside viewmodel entity instead
	addentities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);

	// add any polygons we want here

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
 
  local float pclas, eid;
  local vector vforg;
  vforg = getpropertyvec(VF_ANGLES);
  pclas = getstati(STAT_PCLASS);
  eid = getstati(STAT_ENTITY_ID);
  /*drawstring('0 0 0', vtos(VIEW_ORG), '8 8 0', '1 1 1', 1, 0);
  drawstring('0 8 0', vtos(VIEW_MAX), '8 8 0', '1 1 1', 1, 0);
  drawstring('0 16 0', vtos(VIEW_MAX), '8 8 0', '1 1 1', 1, 0);
 */
  
  AVAILABLE_RESERVE = getstati(STAT_LVL_RES);
  if(pclas != P_OBS){
    //player general info
    local float vec_id, hitdir, conv_x, conv_y, pitch;
    vec_id = getstati(STAT_VID);
    hitdir = getstatf(STAT_HIT_DIR);
    conv_x = getstatf(STAT_SPR_X);
    conv_y = getstatf(STAT_SPR_Y);
    pitch = input_angles_x *-3;
    
    //player camera_transform
    PLR_VIEW_x = getstatf(STAT_CAM_ORG_X);
    PLR_VIEW_y = getstatf(STAT_CAM_ORG_Y);
    PLR_VIEW_z = getstatf(STAT_CAM_ORG_Z);
    makevectors(input_angles);
    PLAYER_HELPER.angles_y = input_angles_y;
    PLR_VIEW = pmove_org; //+ (v_up * PLR_VIEW_y) + (v_right * PLR_VIEW_x) + (v_forward * PLR_VIEW_z);
    setproperty(VF_ORIGIN, PLR_VIEW);
    setorigin(PLAYER_HELPER, PLR_VIEW);
    
    //player mech hp info
    local float plr_state, plr_sh, plr_en, plr_ct, plr_rt, plr_lt, plr_ra, plr_la, plr_lg;
    plr_state = getstati(STAT_PLR_STT);
    plr_sh = getstati(STAT_SHIELD);
    plr_en = getstati(STAT_ENERGY);
    plr_ct = getstatf(STAT_CTOR_HP);
    plr_rt = getstatf(STAT_RTOR_HP);
    plr_lt = getstatf(STAT_LTOR_HP);
    plr_ra = getstatf(STAT_RARM_HP);
    plr_la = getstatf(STAT_LARM_HP);
    plr_lg = getstatf(STAT_LEG_HP);
    
    //snd_hud_vfx_armlistener(plr_ct, 1, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(plr_rt, 2, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(plr_lt, 4, SND_HUD_VFX_CRITTOR);
    snd_hud_vfx_armlistener(plr_ra, 8, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(plr_la, 16, SND_HUD_VFX_CRITARM);
    snd_hud_vfx_armlistener(plr_lg, 32, SND_HUD_VFX_CRITLEG);
    //player weapon tracking info
    local float plr_wgrp, plr_wstate, plr_wrel, w1_id, w2_id, w3_id, w4_id, w5_id, w6_id, w7_id, w8_id, w9_id;
    local float w1_r, w2_r, w3_r, w4_r, w5_r, w6_r, w7_r, w8_r, w9_r;
    plr_wgrp = getstati(STAT_WEP_GRP);
    plr_wstate = getstati(STAT_WEP_STT);
    plr_wrel = getstati(STAT_WEP_REL);
    w1_id = getstati(STAT_WEP1_ID);
    w2_id = getstati(STAT_WEP2_ID);
    w3_id = getstati(STAT_WEP3_ID);
    w4_id = getstati(STAT_WEP4_ID);
    w5_id = getstati(STAT_WEP5_ID);
    w6_id = getstati(STAT_WEP6_ID);
    w7_id = getstati(STAT_WEP7_ID);
    w8_id = getstati(STAT_WEP8_ID);
    w9_id = getstati(STAT_WEP9_ID);
    w1_r = getstatf(STAT_WEP1_REL);
    w2_r = getstatf(STAT_WEP2_REL);
    w3_r = getstatf(STAT_WEP3_REL);
    w4_r = getstatf(STAT_WEP4_REL);
    w5_r = getstatf(STAT_WEP5_REL);
    w6_r = getstatf(STAT_WEP6_REL);
    w7_r = getstatf(STAT_WEP7_REL);
    w8_r = getstatf(STAT_WEP8_REL);
    w9_r = getstatf(STAT_WEP9_REL);
    
    //player radar info
    local float rad_mode;
    rad_mode = getstati(STAT_RDR_MODE);
    //target tracking info
    local float trg_vid, trg_datid, trg_ddflg, trg_sh, trg_am, trg_dist, trg_dir, trg_lock;
    local vector trg_pos;
    trg_vid = getstati(STAT_TRG_VID);
    trg_datid = getstati(STAT_TRG_DAT);
    trg_ddflg = getstati(STAT_TRG_DDFLG);
    trg_sh = getstatf(STAT_TRG_SH);
    trg_dist = getstati(STAT_TRG_DIST);
    trg_dir = getstati(STAT_TRG_FACE);
    trg_lock = getstati(STAT_LCK_STT);
    trg_pos_x = getstatf(STAT_TRG_ORGX);
    trg_pos_y = getstatf(STAT_TRG_ORGY);
    trg_pos_z = getstatf(STAT_TRG_ORGZ);
    PLAYER_HELPER.w_range = trg_dist;
    //render 
    local entity player_hud, vec_data, oself;
    vec_data = m_findMechData(PLAYER_HELPER.vec_size, vec_id);
    player_hud = m_findHUDData(PLAYER_HELPER.vec_size, vec_id);
    
    
    //update sprinting based on player energy state.
    
    if(plr_en < 10){
      cl_set_movespeedkey(1);
    }
    else{
      local float cl_sprint;
      cl_sprint = cvar("cl_movespeedkey");
      if(cl_sprint == 1){
        cl_set_movespeedkey(vec_data.m_maccel);
      }
    }
    
    
    snd_hud_vfx_statelistener(plr_state);
    snd_hud_vfx_enelistener(plr_en);
    snd_hud_vfx_toggleradar(rad_mode);
    snd_hud_vfx_targkill(trg_ddflg);
    oself = self;
    self = player_hud;
      self.w_range = trg_dist;
      self.hud_prep(vec_data);
      self.hud_HelmetImage(VIEW_MAX, VIEW_CTR);
      self.hud_playerArmor(plr_ct, plr_lt, plr_rt, plr_la, plr_ra, plr_lg);     
      self.hud_playerShield(plr_sh);
      self.hud_playerEnergy(plr_en);  
      self.hud_Radar(rad_mode, getstati(STAT_PLR_IFAC));
      self.hud_hitDirectionPips(hitdir);
      self.hud_renderWeapon1(plr_wgrp, plr_wstate, w1_id, WEAPON1, WEAPON1_DD, WEAPON1_OK, w1_r);
      self.hud_renderWeapon2(plr_wgrp, plr_wstate, w2_id, WEAPON2, WEAPON2_DD, WEAPON2_OK, w2_r);
      self.hud_renderWeapon3(plr_wgrp, plr_wstate, w3_id, WEAPON3, WEAPON3_DD, WEAPON3_OK, w3_r);
      self.hud_renderWeapon4(plr_wgrp, plr_wstate, w4_id, WEAPON4, WEAPON4_DD, WEAPON4_OK, w4_r);
      self.hud_renderWeapon5(plr_wgrp, plr_wstate, w5_id, WEAPON5, WEAPON5_DD, WEAPON5_OK, w5_r);
      self.hud_renderWeapon6(plr_wgrp, plr_wstate, w6_id, WEAPON6, WEAPON6_DD, WEAPON6_OK, w6_r);
      self.hud_renderWeapon7(plr_wgrp, plr_wstate, w7_id, WEAPON7, WEAPON7_DD, WEAPON7_OK, w7_r);
      self.hud_renderWeapon8(plr_wgrp, plr_wstate, w8_id, WEAPON8, WEAPON8_DD, WEAPON8_OK, w8_r);
      self.hud_renderWeapon9(plr_wgrp, plr_wstate, w9_id, WEAPON9, WEAPON9_DD, WEAPON9_OK, w9_r);
      self.hud_renderTarget(trg_vid,trg_datid,trg_sh,trg_dist,trg_lock,trg_dir,trg_pos);
      self.hud_renderCrosshairs(vec_id, trg_lock, conv_x, conv_y, pitch);
    self = oself;
    local float rng, l;
    local string s;
    local vector v;
    v = VIEW_CTR;
    rng = getstati(STAT_RET_DIST);
    s = ftos(rng);
    l = stringwidth(s, 0, '8 8 0');
    v_x = v_x - l/2;
    v_y = v_y + 32;
    drawstring(v, s, '8 8', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    
    local float bx_time;
    bx_time = getstati(UI_BOX_TIME);
    if(bx_time > 0){
      ui_renderHUDHighlight();
    }
  }
  else{
    local float len;
    local vector og;
    local string mesg;
    if(getstati(STAT_PLR_STT) == PLAYER_SPAWN){
      len = stringwidth("Press any key to respawn", 0, '8 8 0');
      mesg = "Press any key to respawn";
    }
    else if(getstati(STAT_PLR_STT) == PLAYER_MENU){
      len = stringwidth("Press [TAB] For Hangar Menu", 0, '8 8 0');
      mesg = "Press [TAB] For Hangar Menu";
    }
    og = VIEW_CTR;
    og_x = og_x - gui_percentXRaw(len/2);
    og_y = VIEW_CTR_y + gui_percentYRaw(32);
    drawstring(og, mesg, '8 8 0', '1 1 1', HUD_ALPHA, 0);
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
  setorigin(PLAYER_HELPER, PLR_VIEW);
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
    // draw custom crosshair
    //drawstring(VIEW_ORG+'2 2', vtos(cursorpos), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    
    //local vector prj, temp;
    
    //
    /*temp_x = getstatf(STAT_TRG_ORGX);
    temp_y = getstatf(STAT_TRG_ORGY);
    temp_z = getstatf(STAT_TRG_ORGZ);
    prj = cs_project(temp);
    if (prj_z >= 0) {
      prj_x -= stringwidth("foo", TRUE, '6 6') * 0.5; //align horizontally to centre
      prj_y -= 6 * 0.5; //align vertically again
      prj_z = 0; //shut up dp.
      drawstring(prj, "foo", '6 6', '1 1 1', 1, 0);
    }*/
    local entity nav;
    nav = findchain(classname, "data");
    while(nav){
      if(nav.data_type == DATA_NAVP){
        ui_renderNav(nav);
      }
      nav = nav.chain;
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
  handled = FALSE;
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
  if(id == E_NAV){
    if(isnew){
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.classname = "data";
      self.drawmask = MASK_ENGINE;
      self.value1 = 0;
      self.isActive = 0;
      setorigin(self, self.origin);
      addentity(self);
    }
    self.p_class = E_NAV;
    self.data_type = ReadByte();
    self.nav_name = ReadByte();
    self.i_faction = ReadByte();
    self.value1 = self.isActive;
    self.isActive = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.w_name = gui_getNavName(self.nav_name);
    snd_hud_vfx_navpointlistener(self.value1, self.isActive);
  }
  else if(id == E_OBJ){
    if(isnew){
      self.classname = "data";
      self.data_type = DATA_OBJT;
      self.drawmask = MASK_ENGINE;
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.value1 = 0;
      self.isActive = 0;
      self.data_idx = 0;
      setorigin(self, self.origin);
      addentity(self);
    }
    self.data_idx = ReadByte();
    self.i_faction = ReadByte();
    self.value1 = self.isActive;
    self.isActive = ReadByte();
    snd_hud_vfx_objectivelistener(self.value1, self.isActive);
  }
  //AI test...
  else if(id == E_AIU){
    self.data_idx = ReadByte();
    self.p_class = E_AIU;
    if(isnew){
      self.drawmask = MASK_ENGINE;
      addentity(self);
    }
    self.sh_cur = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();  
    setorigin(self, self.origin);
  }
  else if(id == E_BLD){
    self.data_idx = ReadByte();
    self.p_class = E_BLD;
    if(isnew){
      local entity dat;
      dat = m_findData(self.data_idx, DATA_BLD);
      setmodel(self, dat.e_model);
      self.drawmask = MASK_ENGINE;
      addentity(self);
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
  else if(id == E_VEC){
    self.data_idx = ReadByte();
    self.p_class = E_VEC;
    if(isnew){
      self.drawmask = MASK_ENGINE;
      addentity(self);
    }
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    setorigin(self, self.origin);
  }
  else if(id == E_DEP){
   if(isnew){
      self.ui_org = '0 0 0'; 
      self.ui_size = '0 0 0';
      self.classname = "data";
      self.drawmask = MASK_ENGINE;
      self.value1 = 0;
      self.isActive = 0;
      setorigin(self, self.origin);
      addentity(self);
    }
    self.p_class = E_DEP;
    self.data_type = ReadByte();
    self.nav_name = ReadByte();
    self.i_faction = ReadByte();
    self.isActive = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  /*else if(id == E_MEC){
    if(isnew){
      self.drawmask = MASK_ENGINE;
      addentity(self);
    }
    local float eid;
    eid = ReadByte();
    self.data_idx = ReadByte();
    self.p_class = ReadByte();
    self.i_faction = ReadByte();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.stat_rdr_mode = ReadByte();
    self.hp_ctor = ReadByte();
    self.hp_leg = ReadByte();
    self.hp_stor = ReadByte();
    self.hp_stor2 = ReadByte();
    self.hp_arm = ReadByte();
    self.hp_arm2 = ReadByte();
  }*/
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

// called on each entity each time it is about to be added to the scene (by R_AddEntities)
//.void() predraw;

// called on each entity each frame if self.nextthink <= time + frametime
//.void() think;

// this function is called when a transformview message is received (when you enter a warpzone), to allow you to customize the view transform
// return value is new origin
// v_forward, v_right, v_up must be set correctly
// trace_endpos should be set correctly (before call it will be the same value as org)
//.vector(vector org, vector ang, vector forward, vector right, vector up) camera_transform;

