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
  
  local entity oldSelf;
  
  local string newText;
  
  scoreboard_think();
  
  if(CHAT_INP_SEND){
    freeGlobalString(CHAT_INP_VAL)
    CHAT_INP_SEND = FALSE;
  }
  MENU_PROG_OFF = menuView;
  CLIENT_server_ent = findfloat(world, entnum, player_localentnum);

  //oh this is an ugly hack
  //if( !cvar("r_shadow_realtime_world") ){
  //  cvar_set("r_shadow_realtime_world", "1");
  //}
  
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

	// clear the scene information (entities, polygons, etc)
	clearscene();
  //=====================================================
  
  //apparently this should always be called before any setproperty()!?
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
  
  
	// do any manipulation we want on fov here (weapon zoom, respawn zoom, etc)
	// nothing right now
  
  setproperty(VF_MAINVIEW, TRUE);
  
  VIEW_FOV = getpropertyvec(VF_FOV); // note this is a vector (x and y are independent)
  
  vf_sz = getpropertyvec(VF_SIZE);
  vf_mn = getpropertyvec(VF_MIN);
  
  vf_sz_z = 0;
  vf_mn = '0 0 0';
  VIEW_ACT = getpropertyvec(VF_SIZE);
	// set up the scene parameters
  //setproperty(VF_MIN, vf_mn);   //set the left of the view
  //setproperty(VF_SIZE, vf_sz);   //set how wide the view is (full width)
  
  //overide so player cannot look around while powering up, 
  //solves a lame visual issue with player mech shadows and player input during power up.
  
  VIEW_ORG = '0 0';
  VIEW_SCALE = 0.35;
  
  if(CLIENT_data_type == DATA_MECH){
    if( CLIENT_server_ent.chaseActive ){
      makevectors(view_angles);
      traceline( CLIENT_server_ent.rootOrigin,  CLIENT_server_ent.rootOrigin + (v_forward * cvar("chase_back") * -0.9) + (v_up * cvar("chase_up")), TRUE, CLIENT_server_ent);
      CLIENT_vis_org = trace_endpos + (v_forward * 2);
    }
    else{
    
      makevectors([0, CLIENT_server_ent.angles_y, 0]);
      //predraw takes care of mech geom in FPS cam
      CLIENT_vis_org =  CLIENT_server_ent.rootOrigin + (v_up * CLIENT_server_ent.cameraOffset_y);
      
      //viewbob
      if( CLIENT_server_ent.moveState > 0 ){
        CLIENT_vis_org = CLIENT_vis_org + (v_up* (cos(time * CLIENT_server_ent.hud_bob * (2.0 * M_PI)) + 1.0) * 0.5 * CLIENT_server_ent.hud_bob_up);
      }
      
    }
  }
  else{
    CLIENT_vis_org = CLIENT_server_ent.rootOrigin;
  }
  setproperty(VF_ORIGIN, CLIENT_vis_org);
  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN ){
    if( CLIENT_server_ent.chaseActive == FALSE ){
      setproperty(VF_ANGLES, HUD_FIXED_ANGLE); 
    }
  }
  //NOTE: this seems to fix 'input lag' when toggling menu during gameplay, but not sure why
  //else{
  //  setproperty(VF_ANGLES, input_angles);
  //}
  /*else{
    //note: demonstrates the basics for player-observer mode where you follow another player
    if( VIEW_OBS_ID == 2 ){
      e = entitybyindex(stof(getplayerkeyvalue(VIEW_OBS_ID+1, "viewentity")));
      setproperty(VF_ORIGIN, e.origin);
      setproperty(VF_ANGLES, e.angles);
    }
    else{
      setproperty(VF_ORIGIN, pmove_org);
      setproperty(VF_ANGLES, input_angles);
    }
  }*/
  
  setproperty(VF_FOV, VIEW_FOV);
  if( MENU_ACTIVE && CLIENT_MENU_menu_choice != MENU_REBIND_ACTIVE ){
    setproperty(VF_DRAWWORLD, FALSE);
  }
  else{
    setproperty(VF_DRAWWORLD, TRUE);
  }
  setproperty(VF_DRAWCROSSHAIR, 0);
  setproperty(VF_DRAWENGINESBAR, 0);  
  //=================================================
  
  if( [cvar("vid_conwidth"),cvar("vid_conheight")] != VIEW_MAX){
    //detect resolution change.
    gui_set_screen_size(VIEW_ACT_x, VIEW_ACT_y);
  }
  // add any polygons we want here
  //=================================================
  
  // draw the main view
  if( !MENU_ACTIVE || (MENU_ACTIVE && CLIENT_MENU_menu_choice == MENU_REBIND_ACTIVE)){
  //alter fog settings if needed
    cl_particles_fogFrame();
    setproperty(VF_FOG_DENSITY, FOG_DENSITY);
    setproperty(VF_FOG_COLOR, [FOG_RED, FOG_GREEN, FOG_BLUE]);
    setproperty(VF_FOG_ALPHA,FOG_ALPHA );
    setproperty(VF_FOG_START, FOG_DIST_MIN);
    setproperty(VF_FOG_END, FOG_DIST_MAX);
    setproperty(VF_FOG_HEIGHT, FOG_DIST_TOP);
    setproperty(VF_FOG_FADEDEPTH, FOG_FADE_DEPTH);
    // add clientside entities (MASK_NORMAL)
    // add engine networked entities (MASK_ENGINE)
    // and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
    
  }
  renderscene();
  
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
  if(MENU_ACTIVE || CLIENT_MENU_menu_choice == MENU_REBIND_ACTIVE){
    if(cvar("gamemode") == GAMEMODE_LORE){
      wiki_handleFrame();
    }
    else{
      menu_handleFrame();
    }
    
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
    drawstring(VIEW_ORG + '0 24', sprintf("VF_SIZE  = %s", vtos(getpropertyvec(VF_SIZE))), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 32', sprintf("W/H  = %s", vtos([w,h])), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 40', sprintf("CLIENT_VIS_ORG  = %s", vtos(CLIENT_vis_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 48', sprintf("VF_ORIGIN       = %s", vtos(getpropertyvec(VF_ORIGIN))), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 56', sprintf("VF_ANGLES       = %s", vtos(getpropertyvec(VF_ANGLES))), '8 8', '0.85 0.85 0.85', 1, 0);
    
    local vector mpos;
    mpos = getmousepos();
    if(MENU_ACTIVE){
      drawstring(VIEW_ORG + '0 64', sprintf("UI mouse  = %0.2f %0.2f", mpos_x - UI_ORG_x, mpos_y - UI_ORG_y), '8 8', '0.85 0.85 0.85', 1, 0);
    }
    else{
      drawstring(VIEW_ORG + '0 64', sprintf("Hud offset    = %s", vtos(CLIENT_server_ent.hud_StrutsOffset)), '8 8', '0.85 0.85 0.85', 1, 0);
    }
    drawstring(VIEW_ORG + '0 72', sprintf("CLIENT_VIS_ORG  = %s", vtos(CLIENT_vis_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 80', sprintf("MECH org  = %s", vtos(CLIENT_server_ent.rootOrigin)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 72', sprintf("DBG_PREDRAW_ORG = %s", vtos(CLIENT_server_ent.rootOrigin)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 80', sprintf("pmove_org        = %s", vtos(pmove_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 92',  sprintf("torso org      = %s", vtos(CLIENT_server_ent.torC_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 100', sprintf("left torso org = %s", vtos(CLIENT_server_ent.torL_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 108', sprintf("right torso org= %s", vtos(CLIENT_server_ent.torR_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 116', sprintf("left arm org   = %s", vtos(CLIENT_server_ent.armL_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 124', sprintf("right arm org  = %s", vtos(CLIENT_server_ent.armR_org)), '8 8', '0.85 0.85 0.85', 1, 0);
    drawstring(VIEW_ORG + '0 132', sprintf("legs org       = %s", vtos(CLIENT_server_ent.legs_org)), '8 8', '0.85 0.85 0.85', 1, 0);
  }
};