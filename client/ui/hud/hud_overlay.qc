/*
battleMETAL
Author: Peter Roohr
Date: 3/30/2020
  broke main hud file down for maintainability
  overlays - deals with all view overlay hud stuff
*/

/*
  RENDER A SHIELD METER IN 3d SPACE
*/
void(vector org, vector torg, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis) hud_renderShieldOverlay={
  local float dist;
  local vector vpos, nofs, aSize;
  if(val != 0){
    dist = vlen(org - torg);
    dist = dist / radRange;
    dist = (1 / (dist * dist));    
    dist = dist / 10;
    aSize_x = mSize_x * dist;
    if(aSize_x > mSize_x){
      aSize_x = mSize_x;
    }
    aSize_y = mSize_y * dist;
    if(aSize_y > mSize_y){
      aSize_y = mSize_y;
    }
    vpos = org;
    vpos_z = vpos_z + CLIENT_target_vecsize;
    nofs = cs_project(vpos);
    if (nofs_z >= 0) {
      nofs_x = nofs_x - (aSize_x / 2);
      nofs_z = 0;
      
      local vector meterSize, pos;
      local vector meterColor;
      
      meterSize = gui_percentToPixelRawVec(mSize);
      pos = gui_percentToPixelRawVec(nofs);
      pos = gui_calcAlign(pos, algn);
     
      meterColor = CLR_DEF_ARM_DED;
      if( val < 0 ){
        //render delay regen
        gui_renderMeter( (val * -1), pos, aSize, meterColor, CLR_DEF_RED, HUD_ALPHA, 0, AXIS_H, FALSE); 
      }
      else{
        gui_renderMeter(val, pos, aSize, meterColor, gui_getColorForShield(val), HUD_ALPHA, 0, AXIS_H, FALSE); 
      }
    }
    cs_unproject(vpos);
  }
};

/*
  RENDER FRIENDLY CLIENT NAMES IN 3D SPACE
*/
void( entity thePlayer ) hud_render_ally_names={
  local vector namepos, nameproj, drawSize;
  local float namelen, drawdist, adj;

  drawdist = vlen(pmove_org - thePlayer.origin);
  if( drawdist < CLIENT_radar_range * 0.25 ){
    drawSize = '10 10 0';
    adj = 26;
  }
  else if( drawdist < CLIENT_radar_range * 0.5 ){
    drawSize = '12 12 0';
    adj = 34;
  }
  else{
    drawSize = '14 14 0';
    adj = 42;
  }
  
  local string playerName;
  playerName = getplayerkeyvalue(thePlayer.entId - 1, "name");
  namelen = stringwidth(playerName, 0, drawSize);
  namepos = thePlayer.origin;
  namepos_z = namepos_z + (gui_percentYRaw(thePlayer.vec_size * adj));
  nameproj = cs_project(namepos);
  if( nameproj_z >= 0 ){
    nameproj_x = nameproj_x - gui_percentXRaw(namelen / 2);
    nameproj_z = 0;
    drawstring(nameproj, playerName, drawSize, CLR_DEF_GREEN * 1.5, 1, 0);
  }
  namepos = cs_unproject(nameproj);
};

/*
  RENDER A NAME OVER AN ORIGIN IN 3D SPACE
*/
void() hud_renderNavOverlay={
  local float itr;
  local vector apos, tofs, iofs, i_sz, nofs, colr;
  local float nactive;
  local string navname;
  local float navDist;
  local float distThreshold;
  local float heat;

  distThreshold = CLIENT_radar_range * 4;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    
  local entity nav;
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction ){
      continue;
    }
    if( nav.isActive == FALSE ){
      continue;
    }
    i_sz = draw_getimagesize(UI_DEF_NAVPOINT);
    nofs = nav.origin;
    nofs_z = nofs_z + gui_percentYRaw(14);
    apos = cs_project(nofs);
    tofs = apos;
    if (apos_z >= 0) {
      tofs_x -= stringwidth(navname, TRUE, '12 12') * 0.5; //align horizontally to centre
      tofs_y = tofs_y - 24; //align vertically again
      tofs_z = 0;
      apos_z = 0;
      iofs = apos;
      i_sz_x = i_sz_x / 4;
      i_sz_y = i_sz_y / 4;
      iofs_x = iofs_x - (i_sz_x/2);
      iofs_y = iofs_y - (i_sz_y/2);
      
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
  RENDER DIRECTIONAL HIT INDICATORS
*/
void(float hitDirBit) hud_renderDirectionHit={
  local vector icoSize;
  local vector orgLeft;
  local vector orgRight;
  local vector hitColor;
  icoSize_x = gui_percentXRaw(24);
  icoSize_y = gui_percentYRaw(VIEW_MAX_y * 0.67);
  orgLeft_y = orgRight_y = VIEW_ORG_y + (VIEW_MAX_y * 0.15);
  
  
  if( CLIENT_shield > 0 ){
    hitColor = CLR_HUD_DMG_SHIELD;
  }
  else{
    hitColor = CLR_HUD_DMG_ARMOR;
  }
  
  if( (hitDirBit & STAT_HIT_LF) ){
    orgLeft_x = VIEW_ORG_x + gui_percentXRaw(1);
    gui_renderTintImage(TRUE, orgLeft, HUD_DMG_PIP_H, icoSize, hitColor, max(HUD_ALPHA / 2, 0.67), 0);
  }
  
  if( (hitDirBit & STAT_HIT_RT) ){
    orgRight_x = VIEW_MAX_x - gui_percentXRaw(24);
    gui_renderTintImage(TRUE, orgRight, HUD_DMG_PIP_H, icoSize, hitColor, max(HUD_ALPHA / 2, 0.67), 0);
  }
};