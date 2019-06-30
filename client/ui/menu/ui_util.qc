/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  Utility functions for the UI system.
  These are non-menu specific functions that I couldn't find a better
  place to put.
  
*/

/*
  Called by client_main.CSQC_UpdateView()
  
  this renders Nav point data in 3D game space.
  
  0 = nav either is not of same faction or not avaialable;
  -1 = visited and removed
  1 = active and unvisited
  2 = active and visited
*/
void(float navid) ui_renderNav={
  local vector apos, tofs, iofs, i_sz, nofs, colr;
  local float nactive;
  local string navname;

  nactive = NAVNAMES_ACTIVE[navid];
  navname = NAVNAMES[navid];
  
  if( nactive > 0 ){
    i_sz = draw_getimagesize(UI_DEF_NAVPOINT);
    nofs = NAVNAMES_ORG[navid];
    nofs_z = nofs_z + gui_percentYRaw(14);
    apos = cs_project(nofs);
    tofs = apos;
    if (apos_z >= 0) {
      tofs_x -= stringwidth(navname, TRUE, '6 6') * 0.5; //align horizontally to centre
      tofs_y = tofs_y - 14; //align vertically again
      tofs_z = 0;
      apos_z = 0;
      iofs = apos;
      i_sz_x = i_sz_x / 4;
      i_sz_y = i_sz_y / 4;
      iofs_x = iofs_x - (i_sz_x/2);
      iofs_y = iofs_y - (i_sz_y/2);
      colr = CLR_DEF_WEP_INRANGE;
      if( nactive == 2 ){
        colr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(tofs, navname, '6 6', colr, 1, 0);
      gui_renderTintImage(TRUE, iofs, UI_DEF_NAVPOINT, i_sz, colr, 1, 0) ;
    }
  }
};

/*
  [pseudo-deprecated]
  Called by client_main.CSQC_UpdateView()
  
  this renders a Player's name in 3D game space.
*/
void(entity clnt) ui_renderClientName={
  local vector namepos, nameproj, drawcolor;
  local float namelen,drawcheck, drawdist;
  drawcheck = FALSE;
  drawdist = vlen(pmove_org - clnt.origin);
  if(CLIENT_faction == clnt.faction){
    if(drawdist <= CLIENT_radar_range * 2){
      drawcheck = TRUE;
      drawcolor = CLR_DEF_IIF_FRIEND;
    }
  }
  else{
    if(CLIENT_stat_rdr_mode){
      if(drawdist <= CLIENT_radar_range){
        drawcheck = TRUE;
        drawcolor = CLR_DEF_IFF_ENEMY;
      }
    }
  }
  if( drawcheck ){
    namelen = stringwidth(clnt.netname, 0, '10 10 0');
    namepos = clnt.origin;
    namepos_z = namepos_z + gui_percentYRaw(clnt.vec_size * 18);
    nameproj = cs_project(namepos);
    if (nameproj_z >= 0) {
      //nameproj = gui_percentToPixelRawVec(nameproj);
      nameproj_x = nameproj_x - gui_percentXRaw(namelen / 2);
      nameproj_z = 0;
      drawstring(nameproj, clnt.netname, '10 10 0', drawcolor, 1, 0);
    }
    namepos = cs_unproject(nameproj);
  }
};

/*
  Renders the weapon icon, and a highlight box for a selected hardpoint in
  the Arming Menu.
*/
void(string imageIcon, vector org, float selected) ui_renderHardPointGraphic={
  local entity wep;
  local vector iorg;
  local vector noEditColorAdj;
  
  if( CFG_INDEX == 0 ){
    noEditColorAdj = '0.4 0.4 0.4';
  }
  if( imageIcon != ""){
    if(selected){
      iorg = org - gui_percentToPixelRawVec('2 2');
      gui_renderTintImage(selected, iorg, UI_DEF_BOX_256, gui_percentToPixelRawVec('32 32'), CLR_DEF_ARM_THREEQ + '0.1 0.1 0.1' , 1, 0);
    }
    drawpic( org, imageIcon,  gui_percentToPixelRawVec('28 28'), '1 1 1' - noEditColorAdj, 1, 0);
  }
};

/*
  Renders 1 row in the Hangar Menu.
  Displays Hardpoint data for the selected Mech.
*/
void(vector org, float hpt_num, float types, float sz) ui_renderHardpointRow={
  local vector pofs, iofs, szofs;
  local float hardpointSize;
  local string hardpointSizeLabel;
  
  pofs = org + gui_percentToPixelRawVec('0 8');
  pofs_x = org_x + gui_percentXRaw((hpt_num * 26));
  
  drawpic( pofs + gui_percentToPixelRawVec('0 -2'), UI_BOX_SELECT, gui_percentToPixelRawVec('25 150'), '0.45 0.45 0.45', 0.75, 0);
  
  hardpointSize = sz;
  hardpointSizeLabel = strcat( "(", ftos(hardpointSize), ")");
  
  drawstring(pofs, strcat("[",ftos(hpt_num + 1),"]"), '8 8 0', CLR_DEF_RET_HASLOCK, 1, 0);
  
  if( hardpointSize == 2 ){
    drawstring(pofs + gui_percentToPixelRawVec('0 24'), hardpointSizeLabel, '8 8 0', CLR_DEF_WHITE,1 , 0);
  }
  else if( hardpointSize == 3){
    drawstring(pofs+ gui_percentToPixelRawVec('0 24'), hardpointSizeLabel, '8 8 0', CLR_DEF_WHITE,1 , 0);
  }
  else{
    drawstring(pofs+ gui_percentToPixelRawVec('0 24'), hardpointSizeLabel, '8 8 0', CLR_DEF_WHITE,1 , 0);
  }
  
  if((types & DMG_ENE)){
    drawpic(pofs + gui_percentToPixelRawVec('3 60'), UI_WEP_ENE, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2', 1, 0);
  }
  if((types & DMG_BAL)){
    drawpic(pofs + gui_percentToPixelRawVec('3 80'), UI_WEP_BAL, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_HALF, 1, 0);
  }
  if((types & DMG_EXP)){
    drawpic(pofs + gui_percentToPixelRawVec('3 100'), UI_WEP_EXP, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_OK, 1, 0);
  }
  if((types & DMG_MSC)){
    drawpic(pofs + gui_percentToPixelRawVec('3 120'), UI_WEP_MSC, gui_percentToPixelRawVec('18 18'), CLR_HUD_PURPLE, 1, 0);
  }
};

/*

*/
void(float num, vector org) ui_renderHardPointNumber={
  local vector numberOrg;
  local float width;
  width = stringwidth(ftos(num), 0, gui_percentToPixelRawVec('12 10'));
  numberOrg = org;
  numberOrg_x = numberOrg_x - (width / 2);
  drawstring(numberOrg, ftos(num), gui_percentToPixelRawVec('12 10'), CLR_DEF_RET_HASLOCK, 1, 0);
};

/*
  Called when server sends a TE_ event to highlight a portion of the Player's screen.
*/
void() ui_renderHUD_Highlight_frame={
  local entity boxes;
  boxes = findchainfloat( data_idx, -3 );
  while( boxes ){
    local entity rem;
    rem = boxes;
    boxes = boxes.chain;
    ui_renderHUDHighlight( rem );
    if( time > rem.drawme ){
      remove( rem );
    }
  }
};

void( entity box ) ui_renderHUDHighlight={
  local vector bx_pos, bx_sz, bx_clr, l1, l2, l3;
  local float x,y;
  
  x = (0.1/100) * VIEW_MAX_x;
  y = (0.1/100) * VIEW_MAX_y;
  bx_pos_x = VIEW_ORG_x + ( VIEW_MAX_x * box.origin_x );
  bx_pos_y = VIEW_ORG_y + ( VIEW_MAX_y * box.origin_y );      
  bx_sz_x = box.drawsize_x * VIEW_MAX_x;
  bx_sz_y = box.drawsize_y * VIEW_MAX_y;
  
  l1_x = bx_pos_x + x;
  l1_y = bx_pos_y + y;
  l2_x = l1_x + x;
  l2_y = l1_y + y;
  l3_x = l2_x + x;
  l3_y = l2_y + y;
  gui_DrawRect (bx_pos, bx_sz, '2 1', box.drawcolor1);
  gui_DrawRect (l1, bx_sz, '2 1', box.drawcolor1);
  gui_DrawRect (l2, bx_sz, '1 2', box.drawcolor1);
  gui_DrawRect (l3, bx_sz, '2 1', box.drawcolor1);
};