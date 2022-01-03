/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/

/*
  DP engine -> CL_VM_UpdateView()
    w = vid.width
    h = vid.height
    menuView = key_dest = key_game
    
  Primary function of CSQC, called every render-frame to draw all your custom render code.
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
  
  local string newText;
  
  scoreboard_think();
  
  if(CHAT_INP_SEND){
    freeGlobalString(CHAT_INP_VAL)
    CHAT_INP_SEND = FALSE;
  }
  
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