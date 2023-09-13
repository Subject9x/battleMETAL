/*
battleMETAL
Author: Peter Roohr
Date: 3/30/2020
  broke main hud file down for maintainability
  overlays - deals with all view overlay hud stuff
*/

/*
  RENDER FRIENDLY CLIENT NAMES IN 3D SPACE
*/
void( entity thePlayer ) hud_render_ally_names={
  local vector namepos, nameproj, drawSize;
  local float namelen, drawdist, adj;
  local string playerName;
  
  drawdist = vlen(CLIENT_vis_org - CLIENT_target_ent.origin);
  if(drawdist < CLIENT_radar_range * 0.1){
    adj = 25;
    drawSize = '10 10 0';
  }
  else if( drawdist < CLIENT_radar_range * 0.25 ){
    adj = 40;
    drawSize = '10 10 0';
  }
  else if( drawdist < CLIENT_radar_range * 0.5 ){
    adj = 65;
    drawSize = '12 12 0';
  }
  else if(  drawdist < CLIENT_radar_range * 0.75 ){
    adj = 85;
    drawSize = '12 12 0';
  }
  else{
    adj = 100;
    drawSize = '14 14 0';
  }
  
  if( (CLIENT_target_ent.flags & FL_CLIENT) ){
    playerName = getplayerkeyvalue(CLIENT_target_ent.clientLocalNum, "name");
  }
  else{
    if( CLIENT_target_ent.netname != "" || strlen(CLIENT_target_ent.netname) > 0 ){
      playerName = CLIENT_target_ent.netname;
    }
    else{
      playerName = CLIENT_target_ent.vec_name;
    }
  }
  if( playerName == "" ){
    return;
  }
  namelen = stringwidth(playerName, 0, drawSize);
  namepos = CLIENT_target_ent.origin;
  namepos_z = namepos_z - (adj + drawSize_y);  //magik numbers, :/
  nameproj = cs_project(namepos);
  if( nameproj_z >= 0 ){
    nameproj_x = nameproj_x - (namelen / 2);
    nameproj_z = 0;
    drawstring(nameproj, playerName, drawSize, CLR_DEF_GREEN * 1.5, max(0.75, HUD_ALPHA), 0);
  }
  
};

/*
  RENDER A NAME OVER AN ORIGIN IN 3D SPACE
*/
void() hud_renderNavOverlay={
  local vector apos, tofs, iofs, i_sz, nofs, colr;
  local float nactive;
  local string navname;
  local float navDist;
  local float distThreshold;
  local float heat;
  local entity nav;

  distThreshold = CLIENT_radar_range * 4;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction ){
      continue;
    }
    if( nav.isActive == FALSE ){
      continue;
    }
    i_sz = draw_getimagesize(UI_DEF_NAVPOINT);
    nofs = nav.origin;
    nofs_z = nofs_z + 14;
    apos = cs_project(nofs);
    tofs = apos;
    navname = NAVNAMES[nav.data_idx];
    if (apos_z >= 0) {
      apos_z = 0;
      iofs = apos;
      i_sz_x = i_sz_x / 4;
      i_sz_y = i_sz_y / 4;
      
      iofs_x = iofs_x - (i_sz_x/2);
      iofs_y = iofs_y - (i_sz_y/2);
      
      tofs_x -= stringwidth(navname, TRUE, '12 12') * 0.5; //align horizontally to centre
      tofs_y = tofs_y - (i_sz_y + 12); //align vertically again
      tofs_z = 0;
      
      navDist = vlen( nav.origin - RADAR_ORG );
      heat = (1 - ( navDist / distThreshold ));
      if( heat < 0.33 ){
        heat = 0.33;
      }
      if( nactive == 2 ){
        colr = CLR_DEF_TXT_NONSELECT;
      }
      else{
        colr = CLR_DEF_WEP_INRANGE;
        colr = colr * heat;
      }
      
      drawstring(tofs, navname, '12 12', colr, 1, 0);
      gui_renderTintImage(TRUE, iofs, UI_DEF_NAVPOINT, i_sz, colr, 1, 0) ;
    }
  }
  
  drawfont = drawfont_prev;
};
/*
  RENDER VIP ITEM TARGET BOX
*/
void() hud_render_vip_overlay={
  local entity ent;
  local float dist;
  local float targSizeX, targSizeY, targSizeZ, targZbottom;
  local vector viewAngle;
  local vector imgSize;
  local vector br, bl;
  local vector c_br, c_bl;
    
  for(ent = nextent(world); ent != world; ent = nextent(ent)){
    if( !(ent.spawnflags & IS_VIP) ){
      continue;
    }
    if( ent.deadflag != DEAD_NO ){
      continue;
    }
    if( ent.faction != CLIENT_faction ){
      continue;
    }
    
    targSizeX = ent.maxs_x;
    targSizeY = ent.maxs_y; 
    targSizeZ = ent.maxs_z / 2;
    
    if( targSizeZ < 1 ){
      targZbottom = 0;
    }
    else{
      targZbottom = targSizeZ;
    }
    
    dist = vlen(ent.origin - CLIENT_vis_org);
    if( dist > CLIENT_radar_range ){
      dist = CLIENT_radar_range;
    }
    dist = 1 * (dist / CLIENT_radar_range);
    
    imgSize = draw_getimagesize(HUD_TARGET_BOX_TL) * 0.5 ;
    imgSize = imgSize * dist;
    
    if( imgSize_x > 32 ){
      imgSize_x = 32;
    }
    if(imgSize_x < 32){
      imgSize_x = 32;
    }
    if( imgSize_y > 24 ){
      imgSize_y = 24;
    }
    if(imgSize_y < 16){
      imgSize_y = 16;
    }
    
    viewAngle = view_angles;
    viewAngle_x = viewAngle_x * -1;

    makevectors(viewAngle);

    br = ent.origin + (v_right * targSizeX) + (v_up * (targZbottom * -1));
    bl = ent.origin + (v_right * (targSizeX * -1)) + (v_up * (targZbottom * -1));
    
    c_br = cs_project(br);
    if (c_br_z >= 0) {
      c_br_x = c_br_x - (imgSize_x / 2);
      c_br_y = c_br_y - (imgSize_y / 2);
      c_br_z = 0;
      gui_renderTintImage(TRUE, c_br, HUD_TARGET_BOX_BR, imgSize, CLR_DEF_IIF_FRIEND_BLD, 1- ((HUD_ALPHA + 0.25) * dist), 0);
      
    }
    
    c_bl = cs_project(bl);
    if (c_bl_z >= 0) {
      c_bl_x = c_bl_x - (imgSize_x / 2);
      c_bl_y = c_bl_y - (imgSize_y / 2);
      c_bl_z = 0;
      gui_renderTintImage(TRUE, c_bl, HUD_TARGET_BOX_BL, imgSize, CLR_DEF_IIF_FRIEND_BLD, 1 - ((HUD_ALPHA + 0.25) * dist), 0);
    }
  }
};

/*
  RENDER DIRECTIONAL HIT INDICATORS
*/
void(float hitDirBit) hud_renderDirectionHit={
  local vector icoSize;
  local vector orgLeft;
  local vector orgRight;
  local vector hitColor;
  
  icoSize_x = 24;
  icoSize_y = VIEW_MAX_y * 0.67;
  orgLeft_y = orgRight_y = VIEW_ORG_y + (VIEW_MAX_y * 0.15);
  
  
  if( CLIENT_shield > 0  && CLIENT_shield < 100.1){
    hitColor = CLR_HUD_DMG_SHIELD;
  }
  else{
    hitColor = CLR_HUD_DMG_ARMOR;
  }
  
  if( (hitDirBit & STAT_HIT_LF) ){
    orgLeft_x = VIEW_ORG_x + 1;
    gui_renderTintImage(TRUE, orgLeft, HUD_DMG_PIP_H, icoSize, hitColor, max(HUD_ALPHA / 2, 0.67), 0);
  }
  
  if( (hitDirBit & STAT_HIT_RT) ){
    orgRight_x = VIEW_MAX_x - 24;
    gui_renderTintImage(TRUE, orgRight, HUD_DMG_PIP_H, icoSize, hitColor, max(HUD_ALPHA / 2, 0.67), 0);
  }
};

/*
  called in receive_sendent_player.qc
    SCOPE[
      self = player mech entity.
    ]
*/
void() hud_model_cockpit_ini={
  HUD_VIEW_CL_ANGLES = self.rootAngle;
  HUD_VIEW_OFS = self.cameraOffset_z;
  
  HUD_FIXED_ANGLE = self.angles;
  if( self.chaseActive ){
    if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
      HUD_EXTERNAL_CAM_ACTIVE = FALSE;
      self.chaseActive = FALSE;
    }
    else{
      HUD_EXTERNAL_CAM_ACTIVE = TRUE;
    }
  }
};

/*
  called in receive_sendent_player.qc - player_predraw()
    SCOPE[
      self = player mech entity.
    ]
*/
void() hud_model_cockpit_draw_frame={
  local vector hudAngle;
  local float hudRoll;
  
  local float cacheEffects;
  local float cacheRenderFlags;

  local vector vel;
  local float aimdir;

  local float lerp;
  
  if( self.chaseActive ){
    return;
  }

  cacheEffects = 0 | self.effects;
  cacheEffects = 0 | self.renderflags;

  hudAngle = [0, self.angles_y, 0];
  
  makevectors(hudAngle);
  
  HUD_MODEL_STRUTS_origin = self.rootOrigin;
  HUD_MODEL_STRUTS_origin = HUD_MODEL_STRUTS_origin + (v_right * self.hud_StrutsOffset_x);
  HUD_MODEL_STRUTS_origin = HUD_MODEL_STRUTS_origin + (v_forward *  (self.hud_StrutsOffset_z));
  HUD_MODEL_STRUTS_origin = HUD_MODEL_STRUTS_origin + (v_up *  (self.hud_StrutsOffset_y + self.cameraOffset_y));
  
  if( self.moveState != MOVE_STAND ){
    HUD_MODEL_STRUTS_origin = HUD_MODEL_STRUTS_origin + (v_up* (cos(time * CLIENT_server_ent.hud_bob * (2.0 * M_PI)) + 1.0) * 0.5 * CLIENT_server_ent.hud_bob_up);
    
    
    vel = vectoangles(self.velocity);
    aimdir = anglemod(view_angles_y - vel_y );
    
    if( aimdir > 15 && aimdir <= 105){
      self.hud_roll_val = min(self.hud_roll_val + (frametime * 4), 3);
    }
    else if( aimdir < 345 && aimdir >= 255){
      self.hud_roll_val = max(self.hud_roll_val - (frametime * 4), -3);
    }
    else{
      if(  self.hud_roll_val < 0 ){
        self.hud_roll_val = min(self.hud_roll_val + (frametime * 6), 0);
      }
      else  if(  self.hud_roll_val > 0 ){
        self.hud_roll_val = max(self.hud_roll_val - (frametime * 6), 0);
      }
    }
    
  }
  
  self.alpha = 1.0;
  self.scale = 1.0;
  self.renderflags = 0;

  if(self.torC_hp <= 50){
    if( time > HUD_STRUT_COLOR_TIME ){
      if(HUD_STRUT_COLOR == CLR_DEF_RED * 3){
        HUD_STRUT_COLOR = CLR_DEF_WHITE * 2;
      }
      else{
        HUD_STRUT_COLOR = CLR_DEF_RED * 3;
      }
      HUD_STRUT_COLOR_TIME = time + 10 * frametime;
    }
  }
  else if((self.criticalHits & M_TOR_LEFT) || (self.criticalHits & M_TOR_RIGHT)){
    if( time > HUD_STRUT_COLOR_TIME ){
      if(HUD_STRUT_COLOR == CLR_HUD_ORANGE * 3){
        HUD_STRUT_COLOR = CLR_DEF_WHITE * 2;
      }
      else{
        HUD_STRUT_COLOR = CLR_HUD_ORANGE * 3;
      }
      HUD_STRUT_COLOR_TIME = time + 20 * frametime;
    }
  }
  else{
    HUD_STRUT_COLOR = CLR_DEF_WHITE * 2;
  }
  self.colormod = HUD_STRUT_COLOR;
  
  setmodel(self, self.weaponmodel);
  self.origin = HUD_MODEL_STRUTS_origin;
  
  self.effects = 0 | EF_NOSHADOW;
  if(self.torC_hp <= 50){
    self.effects = self.effects | EF_RED;
  }

  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN){
    self.angles_y = self.rootAngle_y;
  }
  else{
    self.angles_y = view_angles_y;
  }
  self.angles_x = self.torC_angl_x;
  self.angles_z = self.torC_angl_z;
  self.angles_z = self.hud_roll_val;
  
  addentity(self);
  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  
  makevectors([0, self.angles_y, 0]);
  HUD_MODEL_CONSOLE_origin = HUD_MODEL_STRUTS_origin;
  HUD_MODEL_CONSOLE_origin = HUD_MODEL_CONSOLE_origin + (v_forward * 0.8);
  HUD_MODEL_CONSOLE_origin = HUD_MODEL_CONSOLE_origin + (v_up * -0.5);
  // HUD_MODEL_CONSOLE_origin = HUD_MODEL_CONSOLE_origin + (v_up *  (self.hud_StrutsOffset_y + -1.55 + self.cameraOffset_y));
  
  setmodel(self, self.hud_model);
  
  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN){
    self.angles_y = self.rootAngle_y;
  }
  else{
    self.angles_y = view_angles_y;
  }
  self.angles_x = self.torC_angl_x + 45;
  self.angles_z = self.torC_angl_z;
  self.angles_z = self.hud_roll_val;

  self.origin = HUD_MODEL_CONSOLE_origin;
  self.effects = 0 | EF_NOSHADOW;
  
  addentity(self);

  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  
  self.renderflags = 0;
};

/*
  called in receive_sendent_player.qc
    SCOPE[
      self = player mech entity.
    ]
*/
void() hud_model_armor_player_ini={
  if( !HUD_MODEL_ARMOR_GRAPH_PLAYER ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER = spawn();
  }
  HUD_MODEL_ARMOR_GRAPH_PLAYER.solid = SOLID_NOT;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.movetype = MOVETYPE_NONE;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags = 0 | rint(self.unitModFlags);
  setmodel(HUD_MODEL_ARMOR_GRAPH_PLAYER, "models/testball.md3");
  HUD_MODEL_ARMOR_GRAPH_PLAYER.mins = self.mins;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.maxs = self.maxs;

  HUD_MODEL_ARMOR_GRAPH_PLAYER.torC_compOffset = self.torC_compOffset;
  cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.torC_mdl, self.torC_mdl);

  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torL_compOffset = self.torL_compOffset;
    cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.torL_mdl, self.torL_mdl);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torR_compOffset = self.torR_compOffset;
    cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.torR_mdl, self.torR_mdl);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armL_compOffset = self.armL_compOffset;
    cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.armL_mdl, self.armL_mdl);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armR_compOffset = self.armR_compOffset;
    cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.armR_mdl, self.armR_mdl);
  }
  
  HUD_MODEL_ARMOR_GRAPH_PLAYER.legs_compOffset = self.legs_compOffset;
  cacheGlobalString(HUD_MODEL_ARMOR_GRAPH_PLAYER.legs_mdl, self.legs_mdl);
  
};

void(vector vorg, vector vSize, float algn, float lalgn, vector lblOfs, vector lblSize) hud_renderArmorPlayer3D={
  local vector panelOrg;
  local vector viewOrg;

  local vector backOrg;
  local vector backSize;
  local vector backColor;
  local float ct, lt, rt, la, ra, lg;

  local entity hudEnt;
  local float zTotal;
  local float zBias;
  local float zHalf;
  local float xHalf;

  local vector mOffset;
  local vector prevAngl;

  panelOrg = gui_calcAlign(vorg, algn);
  backColor = CLR_DEF_IIF_FRIEND;
   
  if( lblSize != '0 0 0'){
    backSize_x = ceil(lblSize_x / 16) * 16;
    backSize_y = ceil(lblSize_y / 16) * 16;
    backOrg = gui_calcAlignBiased(vSize, lblSize, lalgn, panelOrg, '0.9 0.9'); 
  }
  else{
    backSize_x = (ceil(vSize_x / 16)) * 16;
    backSize_y = (ceil(vSize_y / 16) + 1) * 16;
    backOrg_x = backOrg_x - 8;
    backOrg_y = backOrg_y - 8;
    backOrg = backOrg + gui_calcAlignCustom(lblOfs, lalgn, panelOrg);
  }
  
  gui_renderPatch9_1_32(backOrg, backSize, backColor, max(0.8, HUD_ALPHA), 0);

  clearscene();
    ct = CLIENT_server_ent.torC_hp;
    lt = CLIENT_server_ent.torL_hp;
    rt = CLIENT_server_ent.torR_hp;
    la = CLIENT_server_ent.armL_hp;
    ra = CLIENT_server_ent.armR_hp;
    lg = CLIENT_server_ent.legs_hp;

    hudEnt = HUD_MODEL_ARMOR_GRAPH_PLAYER;

    if(ENT_SERVER_INFO.uiViewBoxOrg != '0 0 0'){
      viewOrg = ENT_SERVER_INFO.uiViewBoxOrg;
    }
    else{
      viewOrg = CLIENT_vis_org;
    }
    hudEnt.maxs_z = max(hudEnt.maxs_z, 24); //test
    
    zBias = (hudEnt.mins_z - hudEnt.maxs_z)/2 - hudEnt.mins_z;
    zTotal = ((hudEnt.mins_z * -1) + hudEnt.maxs_z) / 2;
    zHalf = ((hudEnt.mins_z * -1) + hudEnt.maxs_z) / 2;
    xHalf = hudEnt.maxs_x * 1.5;
    
    makevectors('30 0 0');
    setproperty(VF_ORIGIN, viewOrg + (v_forward * -100 - xHalf) - (v_right * xHalf) + (v_up * (zHalf * 0.9)));	//look towards it.
    setproperty(VF_ANGLES, '30 0 0');
    setproperty(VF_MIN, vtodpp([panelOrg_x, panelOrg_y, 0]) );
    setproperty(VF_SIZE, vtodpp([vSize_x, vSize_y, 0]) );
    //set an explicit fov. this thing had better be square. DP doesn't support VF_AFOV
    setproperty(VF_FOV, [zTotal, atan(vSize_y/(vSize_x/tan(zTotal/360*6.28))) * 360/6.28, 0]); 

    setproperty(VF_DRAWENGINESBAR, FALSE);
    setproperty(VF_DRAWWORLD, FALSE);
    setproperty(VF_DRAWCROSSHAIR, FALSE);
    
    setproperty(VF_FOG_DENSITY, 0.0);
    setproperty(VF_FOG_ALPHA, 0.0);
    setproperty(VF_FOG_COLOR, '0 0 0');
    setproperty(VF_FOG_START, 0.0);
    setproperty(VF_FOG_HEIGHT, 0.0);
    setproperty(VF_FOG_FADEDEPTH, 0.0);
    setproperty(VF_MAINVIEW, FALSE);
    
    if(HUD_MODEL_ARMOR_GRAPH_PLAYER){
      hudEnt.origin = viewOrg;
      hudEnt.rootOrigin = viewOrg;
      hudEnt.ai_dir = anglemod(hudEnt.ai_dir + frametime*33);
      hudEnt.angles = [0, hudEnt.ai_dir, 0];
      prevAngl = hudEnt.angles;
      makevectors(hudEnt.angles);
      
      hudEnt.effects = hudEnt.effects | EF_FULLBRIGHT | EF_NOSHADOW;
      
      hudEnt.torC_org = hud_model_armor_part_frame(hudEnt.torC_compOffset, viewOrg);
      hudEnt.torC_angl = [CLIENT_server_ent.torC_angl_x, hudEnt.angles_y, 0];
      hudEnt.colormod = gui_getColorForArmor(ct) * 2;
      setmodel(hudEnt, hudEnt.torC_mdl);
      hudEnt.origin = hudEnt.torC_org;
      hudEnt.angles = hudEnt.torC_angl;
      addentity(hudEnt);
      hudEnt.angles = prevAngl;
      
      if( (hudEnt.unitModFlags & MOD_HAS_TOR_L) ){
        hudEnt.torL_org = hud_model_armor_part_frame(hudEnt.torL_compOffset, viewOrg);
        hudEnt.torL_angl   = [CLIENT_server_ent.torL_angl_x, hudEnt.angles_y, 0];  
        hudEnt.colormod   = gui_getColorForArmor(lt) * 2;
        setmodel(hudEnt, hudEnt.torL_mdl);
        hudEnt.origin = hudEnt.torL_org;
        hudEnt.angles = hudEnt.torL_angl;
        addentity(hudEnt);
        hudEnt.angles = prevAngl;
      }
      if( (hudEnt.unitModFlags & MOD_HAS_TOR_R) ){
        hudEnt.torR_org = hud_model_armor_part_frame(hudEnt.torR_compOffset, viewOrg);
        hudEnt.torR_angl = [CLIENT_server_ent.torR_angl_x, hudEnt.angles_y, 0];
        hudEnt.colormod  = gui_getColorForArmor(rt) * 2;  
        setmodel(hudEnt, hudEnt.torR_mdl);
        hudEnt.origin = hudEnt.torR_org;
        hudEnt.angles = hudEnt.torR_angl;
        addentity(hudEnt);
        hudEnt.angles = prevAngl;
      }
      if( (hudEnt.unitModFlags & MOD_HAS_ARM_L) ){
        hudEnt.armL_org = hud_model_armor_part_frame(hudEnt.armL_compOffset, viewOrg);
        hudEnt.armL_angl     = [CLIENT_server_ent.armL_angl_x, hudEnt.angles_y, 0];
        hudEnt.colormod    = gui_getColorForArmor(la) * 2;
        setmodel(hudEnt, hudEnt.armL_mdl);
        hudEnt.origin = hudEnt.armL_org;
        hudEnt.angles = hudEnt.armL_angl;
        addentity(hudEnt);
        hudEnt.angles = prevAngl;
      }
      if( (hudEnt.unitModFlags & MOD_HAS_ARM_R) ){
        hudEnt.armR_org = hud_model_armor_part_frame(hudEnt.armR_compOffset, viewOrg);
        hudEnt.armR_angl    = [CLIENT_server_ent.armR_angl_x, hudEnt.angles_y, 0];
        hudEnt.colormod    = gui_getColorForArmor(ra) * 2;
        setmodel(hudEnt, hudEnt.armR_mdl);
        hudEnt.origin = hudEnt.armR_org;
        hudEnt.angles = hudEnt.armR_angl;
        addentity(hudEnt);
        hudEnt.angles = prevAngl;
      }
        
      hudEnt.legs_org = hud_model_armor_part_frame(hudEnt.legs_compOffset, viewOrg);
      hudEnt.legs_angl        = hudEnt.angles;
      hudEnt.frame = CLIENT_server_ent.legs_frame;
      setmodel(hudEnt, hudEnt.legs_mdl);
      hudEnt.colormod = gui_getColorForArmor(lg) * 2;
      hudEnt.origin = hudEnt.legs_org;
      hudEnt.effects = hudEnt.effects | EF_FULLBRIGHT | EF_NOSHADOW;
      addentity(hudEnt);
    }
  renderscene();
  //WARN - must have these so that the REST of the 3D-hud stuff projects correctly!
  setproperty(VF_ORIGIN, CLIENT_vis_org);
  setproperty(VF_FOV, VIEW_FOV); 
  setproperty(VF_ANGLES, input_angles);
  setproperty(VF_MIN, '0 0 0');
  setproperty(VF_SIZE, VIEW_ACT);
  setproperty(VF_DRAWWORLD, TRUE);
  setproperty(VF_MAINVIEW, TRUE);
  //------------------------------------------------------------------------
  HUD_MODEL_ARMOR_GRAPH_PLAYER.mins = CLIENT_server_ent.cache_mins;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.maxs = CLIENT_server_ent.cache_maxs;
}; 