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
  
  drawdist = vlen(pmove_org - CLIENT_target_ent.origin);
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
    
    dist = vlen(ent.origin - pmove_org);
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
    
    viewAngle = input_angles;
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
  
  
  if( CLIENT_shield > 0 ){
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

  CLIENT_server_ent = self;
  HUD_VIEW_CL_ANGLES = self.angles;
  HUD_VIEW_OFS = self.cameraOffset_z;
  
  HUD_MODEL_STRUTS = spawn();
  
  HUD_MODEL_STRUTS.effects = HUD_MODEL_STRUTS.effects | EF_NOSHADOW;
  setmodel(HUD_MODEL_STRUTS, self.weaponmodel);
  setorigin(HUD_MODEL_STRUTS, pmove_org);
  HUD_MODEL_STRUTS.angles_y = input_angles_y;
  HUD_MODEL_STRUTS.angles_x = 0;
  HUD_MODEL_STRUTS.angles_z = 0;
  HUD_MODEL_STRUTS.drawmask = 0;
  HUD_MODEL_STRUTS.alpha = 1.0;
  
  HUD_MODEL_CONSOLE = spawn();
  
  HUD_MODEL_CONSOLE.effects = HUD_MODEL_CONSOLE.effects | EF_NOSHADOW;
  setmodel(HUD_MODEL_CONSOLE, self.hud_model);
  setorigin(HUD_MODEL_CONSOLE, pmove_org);
  HUD_MODEL_CONSOLE.angles_y = input_angles_y;
  HUD_MODEL_CONSOLE.angles_x = 45;
  HUD_MODEL_CONSOLE.angles_z = 0;
  HUD_MODEL_CONSOLE.drawmask = 0;
  HUD_MODEL_CONSOLE.alpha = 1.0;
  
  if( cvar("chase_active") ){
    if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
      HUD_EXTERNAL_CAM_ACTIVE = FALSE;
      cvar_set("chase_active", "0");
    }
    else{
      HUD_EXTERNAL_CAM_ACTIVE = TRUE;
      HUD_MODEL_CONSOLE.alpha = 0.0;
      HUD_MODEL_STRUTS.alpha = 0.0;
    }
  }
  HUD_FIXED_ANGLE = self.angles;
};

/*
  called in receive_sendent_player.qc - player_predraw()
    SCOPE[
      self = player mech entity.
    ]
*/
void() hud_model_cockpit_draw_frame={
  local vector hudAng;
  local vector strutOrg;
  local vector consOrg;
  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN && cvar("chase_active") == FALSE){
    hudAng = HUD_FIXED_ANGLE;
    HUD_MODEL_STRUTS.angles_y = HUD_FIXED_ANGLE_y;
    HUD_MODEL_STRUTS.angles_x = 0;
    HUD_MODEL_STRUTS.angles_z = 0;
    
    HUD_MODEL_CONSOLE.angles_y = HUD_FIXED_ANGLE_y;
    HUD_MODEL_CONSOLE.angles_x = 33;
    HUD_MODEL_CONSOLE.angles_z = 0;
  }
  else{
    hudAng = input_angles;
    hudAng_x = 0;
    
    HUD_MODEL_STRUTS.angles_y = input_angles_y;
    HUD_MODEL_STRUTS.angles_x = 0;
    HUD_MODEL_STRUTS.angles_z = 0;
    
    HUD_MODEL_CONSOLE.angles_y = input_angles_y;
    HUD_MODEL_CONSOLE.angles_x = 33;
    HUD_MODEL_CONSOLE.angles_z = 0;
  }
  makevectors(hudAng);
  strutOrg = getpropertyvec(VF_ORIGIN) + (v_forward * self.hud_StrutsOffset_z)  + (v_right * self.hud_StrutsOffset_x)  + (v_up * self.hud_StrutsOffset_y);
  setorigin(HUD_MODEL_STRUTS, strutOrg);
  
  consOrg = getpropertyvec(VF_ORIGIN) + (v_forward * 0.75) + (v_up * -1.55);
  setorigin(HUD_MODEL_CONSOLE, consOrg);
    HUD_MODEL_STRUTS.drawmask = 0;
    HUD_MODEL_CONSOLE.drawmask = 0;
  if( !cvar("chase_active") ){
    addentity(HUD_MODEL_CONSOLE);
    addentity(HUD_MODEL_STRUTS);
  }
};

/*
  HUD MODEL stuff
*/
void( entity srcEnt, entity dstEnt) hud_model_armor_config={
  if(srcEnt.model){
    dstEnt.model = srcEnt.model;
    setmodel(dstEnt, dstEnt.model);
    dstEnt.model = "";
  }
  
  dstEnt.colormod = '0 1.5 0';
  dstEnt.alpha = 1.0;
  dstEnt.effects = 0| EF_FULLBRIGHT | EF_NOSHADOW;
  dstEnt.compOffset_x = srcEnt.compOffset_x; 
  dstEnt.compOffset_y = srcEnt.compOffset_y; 
  dstEnt.compOffset_z = srcEnt.compOffset_z; 
  dstEnt.partParentId = srcEnt.partParentId;
  dstEnt.solid = SOLID_NOT;
  dstEnt.takedamage = DAMAGE_NO;
  dstEnt.movetype = MOVETYPE_NONE;
  dstEnt.drawmask = 0;
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
  HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags = 0 | self.unitModFlags;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.mins = self.mins;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.maxs = self.maxs;
  
  if( self.torsoCenter && !HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter = spawn();
    hud_model_armor_config( self.torsoCenter, HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_L) && !HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft = spawn();
    hud_model_armor_config( self.torsoLeft, HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) && !HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight = spawn();
    hud_model_armor_config( self.torsoRight, HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) && !HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft = spawn();
    hud_model_armor_config( self.armLeft, HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) && !HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight = spawn();
    hud_model_armor_config( self.armRight, HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight);
  }
  if( !HUD_MODEL_ARMOR_GRAPH_PLAYER.legs ){
    HUD_MODEL_ARMOR_GRAPH_PLAYER.legs = spawn();
  }
  hud_model_armor_config( self.legs, HUD_MODEL_ARMOR_GRAPH_PLAYER.legs);
};

/*  
  Draw player mech as 3D Model with armor coloring.
*/
void(vector vueOrg, float hpCt, float hpLt, float hpRt, float hpLa, float hpRa, float hpLg ) hud_armor_model_player_frame={
  
  HUD_MODEL_ARMOR_GRAPH_PLAYER.origin = vueOrg;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.ai_dir = anglemod(HUD_MODEL_ARMOR_GRAPH_PLAYER.ai_dir + frametime*33);
  HUD_MODEL_ARMOR_GRAPH_PLAYER.angles = [0, HUD_MODEL_ARMOR_GRAPH_PLAYER.ai_dir, 0];
  
  makevectors(HUD_MODEL_ARMOR_GRAPH_PLAYER.angles);
  
  hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter, HUD_MODEL_ARMOR_GRAPH_PLAYER);
  
  HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter.angles = [CLIENT_mech_self.torsoCenter.angles_x, HUD_MODEL_ARMOR_GRAPH_PLAYER.angles_y, 0];
  HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter.colormod = gui_getColorForArmor(hpCt) * 2;
  addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoCenter);
  
  if( (HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags & MOD_HAS_TOR_L) ){
    hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft, HUD_MODEL_ARMOR_GRAPH_PLAYER);
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft.angles   = [CLIENT_mech_self.torsoLeft.angles_x, HUD_MODEL_ARMOR_GRAPH_PLAYER.angles_y, 0];  
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft.colormod   = gui_getColorForArmor(hpLt) * 2;
    addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoLeft);
  }
  if( (HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags & MOD_HAS_TOR_R) ){
    hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight, HUD_MODEL_ARMOR_GRAPH_PLAYER);
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight.angles  = [CLIENT_mech_self.torsoRight.angles_x, HUD_MODEL_ARMOR_GRAPH_PLAYER.angles_y, 0];
    HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight.colormod  = gui_getColorForArmor(hpRt) * 2;  
    addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.torsoRight);
  }
  if( (HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags & MOD_HAS_ARM_L) ){
    hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft, HUD_MODEL_ARMOR_GRAPH_PLAYER);
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft.angles     = [CLIENT_mech_self.armLeft.angles_x, HUD_MODEL_ARMOR_GRAPH_PLAYER.angles_y, 0];
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft.colormod     = gui_getColorForArmor(hpLa) * 2;
    addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.armLeft);
  }
  if( (HUD_MODEL_ARMOR_GRAPH_PLAYER.unitModFlags & MOD_HAS_ARM_R) ){
    hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight, HUD_MODEL_ARMOR_GRAPH_PLAYER);
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight.angles    = [CLIENT_mech_self.armRight.angles_x, HUD_MODEL_ARMOR_GRAPH_PLAYER.angles_y, 0];
    HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight.colormod    = gui_getColorForArmor(hpRa) * 2;
    addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.armRight);
  }
    
  hud_model_armor_part_frame(HUD_MODEL_ARMOR_GRAPH_PLAYER.legs, HUD_MODEL_ARMOR_GRAPH_PLAYER);
  HUD_MODEL_ARMOR_GRAPH_PLAYER.legs.angles        = HUD_MODEL_ARMOR_GRAPH_PLAYER.angles;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.legs.frame = CLIENT_mech_self.legs.frame;
  HUD_MODEL_ARMOR_GRAPH_PLAYER.legs.colormod = gui_getColorForArmor(hpLg) * 2;
  addentity(HUD_MODEL_ARMOR_GRAPH_PLAYER.legs);
};