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