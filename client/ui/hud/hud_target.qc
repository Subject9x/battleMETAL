/*
battleMETAL
Author: Peter Roohr
Date: 3/30/2020
  broke main hud file down for maintainability
  target - deals with all target hud stuff
*/

/*
  RENDER TARGET DIRECTION INDICATORS
*/ 
void(float targdir, float plrFaction, float trgfaction, float dattype) hud_renderTargetDirection={
  vector trg_color;
  trg_color = CLR_DEF_ARM_HALF;
  if( plrFaction == trgfaction ){
    trg_color = CLR_DEF_IIF_FRIEND;
    if( dattype == DATA_BLD ){
      trg_color = CLR_DEF_IIF_FRIEND_BLD;
    }
  }
  else{
    trg_color = CLR_DEF_IFF_ENEMY;
    if( dattype == DATA_BLD ){
      trg_color = CLR_DEF_IFF_ENEMY_BLD;
    }
  }
  if(targdir > -1){
    local vector lorg;
    if(targdir == 0){
      lorg_x = VIEW_ORG_x + gui_percentXRaw(5); 
      lorg_y = VIEW_CTR_y - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_L, gui_percentToPixelRawVec('16 48'), trg_color, HUD_ALPHA, 0);
    }
    else if(targdir == 1){
      lorg_x = (VIEW_ORG_x + VIEW_MAX_x) - gui_percentXRaw(15); 
      lorg_y = VIEW_CTR_y  - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_R, gui_percentToPixelRawVec('16 48'), trg_color, HUD_ALPHA, 0);     
    }
    else if(targdir == 2){
      lorg_x = VIEW_CTR_x - gui_percentXRaw(24);
      lorg_y = VIEW_CTR_y + gui_percentYRaw(48);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_B, gui_percentToPixelRawVec('48 16'), trg_color, HUD_ALPHA, 0);
    }
  }
};

/*
  RENDERS A LABEL 'TARGET' AND THE TARGET'S NAME
*/
void(vector ofs, float algn) hud_renderTargetName={
  local float msgLen;
  local vector tofs, msgSize, factionColor;
  local string msg;
  local string targType;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( (CLIENT_faction == CLIENT_target_faction) && (CLIENT_target_faction != FACTION_ALL) ){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY;
  }

  local entity playerTarg;
  playerTarg = findfloat(world, entId, CLIENT_stat_trg_ent_id);
  if( (playerTarg.flags & FL_CLIENT) ){
    targType = getplayerkeyvalue(CLIENT_stat_trg_ent_id - 1, "name");
  }
  else{
    targType = playerTarg.vec_name;
  }

  ofs = gui_percentToPixelRawVec(ofs);
  ofs = gui_calcAlign(ofs, algn);
  msg = strcat("[TARGET] ", targType);
  msgLen = stringwidth(msg, 0, '10 10 0');
  msgSize_x = gui_percentXRaw(msgLen/2);
  msgSize_y = gui_percentYRaw(6);
  tofs = gui_calcAlignCustom('0 0', (VIEW_LFT | VIEW_CTY), ofs);
  drawstring(tofs, msg, '10 10 0', factionColor, HUD_ALPHA, 0);
  
  drawfont = drawfont_prev;
};

/*
  RENDER TARGET PIPS OVER AN ORIGIN IN 3D SPACE
*/
void(vector org, vector torg, float algn, float faction1, float faction2, float radRange) hud_renderTargetOverlay={
  local float dist;
  local float targSizeX, targSizeY, targSizeZ, targZbottom;
  local vector viewAngle;
  local vector imgSize, factionColor;
  
  targSizeX = getstatf(ADDSTAT_TARGETSIZE_X);
  targSizeY = getstatf(ADDSTAT_TARGETSIZE_Y); 
  targSizeZ = getstatf(ADDSTAT_TARGETSIZE_Z);
  
  if( targSizeZ < 1 ){
    targZbottom = 0;
  }
  else{
    targZbottom = targSizeZ;
  }
  
  if( (faction1 == faction2) && (faction2 != FACTION_ALL) ){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY;
  }
  dist = vlen(org - torg);
  if( dist > radRange ){
    dist = radRange;
  }
  dist = 1 * (dist / radRange);
  
  imgSize = draw_getimagesize(HUD_TARGET_BOX_TL) * 0.5 ;
  imgSize = gui_percentToPixelRawVec(imgSize * dist) ;
  
  if( imgSize_x > gui_percentXRaw(48) ){
    imgSize_x = gui_percentXRaw(48);
  }
  if(imgSize_x < gui_percentXRaw(32)){
    imgSize_x = gui_percentXRaw(32);
  }
  if( imgSize_y > gui_percentYRaw(48) ){
    imgSize_y = gui_percentYRaw(48);
  }
  if(imgSize_y < gui_percentYRaw(32)){
    imgSize_y = gui_percentYRaw(32);
  }
  
  viewAngle = input_angles;
  viewAngle_x = viewAngle_x * -1;

  makevectors(viewAngle);
  local vector tl, tr, br, bl;
  local vector c_tl, c_tr, c_br, c_bl;

  tl = org + (v_right * (targSizeX * -1)) + (v_up * targSizeZ);
  tr = org + (v_right * targSizeX) + (v_up * targSizeZ);
  br = org + (v_right * targSizeX) + (v_up * (targZbottom * -1));
  bl = org + (v_right * (targSizeX * -1)) + (v_up * (targZbottom * -1));
 
  c_tl = cs_project(tl);
  if (c_tl_z >= 0) {
    c_tl_x = c_tl_x - (imgSize_x / 2);
    c_tl_y = c_tl_y - (imgSize_y / 2);
    c_tl_z = 0;
    gui_renderTintImage(TRUE, c_tl, HUD_TARGET_BOX_TL, imgSize, factionColor, HUD_ALPHA + 0.25, 0);
  }

  c_tr = cs_project(tr);
  if (c_tr_z >= 0) {
    c_tr_x = c_tr_x - (imgSize_x / 2);
    c_tr_y = c_tr_y - (imgSize_y / 2);
    c_tr_z = 0;
    gui_renderTintImage(TRUE, c_tr, HUD_TARGET_BOX_TR, imgSize, factionColor, HUD_ALPHA + 0.25, 0);
  }
  
  c_br = cs_project(br);
  if (c_br_z >= 0) {
    c_br_x = c_br_x - (imgSize_x / 2);
    c_br_y = c_br_y - (imgSize_y / 2);
    c_br_z = 0;
    gui_renderTintImage(TRUE, c_br, HUD_TARGET_BOX_BR, imgSize, factionColor, HUD_ALPHA + 0.25, 0);
  }
  
  c_bl = cs_project(bl);
  if (c_tl_z >= 0) {
    c_bl_x = c_bl_x - (imgSize_x / 2);
    c_bl_y = c_bl_y - (imgSize_y / 2);
    c_bl_z = 0;
    gui_renderTintImage(TRUE, c_bl, HUD_TARGET_BOX_BL, imgSize, factionColor, HUD_ALPHA + 0.25, 0);
  }
  
  local entity thePlayer;
  thePlayer = entitybyindex(CLIENT_stat_trg_ent_id);
  if( (thePlayer.flags & FL_CLIENT) ){
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
    playerName = getplayerkeyvalue(CLIENT_stat_trg_ent_id - 1, "name");
    namelen = stringwidth(playerName, 0, drawSize);
    namepos = thePlayer.origin;
    namepos_z = namepos_z + (gui_percentYRaw(thePlayer.vec_size * adj));
    nameproj = cs_project(namepos);
    if( nameproj_z >= 0 ){
      nameproj_x = nameproj_x - gui_percentXRaw(namelen / 2);
      nameproj_z = 0;
      drawstring(nameproj, playerName, drawSize, CLR_DEF_IFF_ENEMY * 1.5, 1, 0);
    }
    namepos = cs_unproject(nameproj);
  }
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val) hud_renderArmorBuilding={
  local vector meter;
  vorg = gui_percentToPixelRawVec(vorg);
  vorg = gui_calcAlign(vorg, algn);
  meter = gui_percentToPixelRawVec(siz);
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  gui_renderMeter(val, meter, siz, CLR_DEF_ARM_DED, gui_getColorForArmor(val), HUD_ALPHA, 0, AXIS_V, 0);
};


void(vector vorg, float algn, vector siz, float val)hud_renderArmorVehicle={
  local vector meter;
  vorg = gui_percentToPixelRawVec(vorg);
  vorg = gui_calcAlign(vorg, algn);
  meter = gui_percentToPixelRawVec(siz);
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  gui_renderMeter(val, meter, siz, CLR_DEF_ARM_DED, gui_getColorForArmor(val), HUD_ALPHA, 0, AXIS_V, 0);
};

/*
  RENDERS A LABEL 'RANGE' AND DISTANCE TO ORIGIN
*/
void(vector ofs, vector torg, vector porg, float algn) hud_renderTargetRange={
  local float dist, msgLen;
  local vector tofs, msgSize;
  local string msg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  ofs = gui_percentToPixelRawVec(ofs);
  ofs = gui_calcAlign(ofs, algn);
  dist = ceil(vlen(torg - porg));
  msg = strcat("[RANGE] ", ftos(dist));
  msgLen = stringwidth(msg, 0, '10 10 0');
  msgSize_x = gui_percentXRaw(msgLen/2);
  msgSize_y = gui_percentYRaw(6);
  tofs = gui_calcAlignCustom('0 0', (VIEW_LFT | VIEW_CTY), ofs);
  drawstring(tofs, msg, '10 10 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  drawfont = drawfont_prev;
};

/*
  RENDER allied target boxes
*/
void(vector org, entity allyTarget, float algn, float faction1, float radRange) hud_renderTargetOverlay_Ally={
  local float dist;
  local float targSizeZ, targZbottom;
  local vector viewAngle;
  local vector imgSize, factionColor;
  local string img;

  targSizeZ = allyTarget.vec_size * 16;
  
  if( targSizeZ < 1 ){
    targZbottom = 0;
  }
  else{
    targZbottom = targSizeZ;
  }
  
  if(faction1 == allyTarget.faction){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY_BLD;
  }
  
  dist = vlen(org - allyTarget.origin);
  if( dist > radRange ){
    dist = radRange;
  }
  dist = 1 * (dist / radRange);
  
  imgSize = '4 4 0';
  imgSize = gui_percentToPixelRawVec(imgSize * dist) ;
  
  if( imgSize_x > gui_percentXRaw(16) ){
    imgSize_x = gui_percentXRaw(16);
  }
  if(imgSize_x < gui_percentXRaw(8)){
    imgSize_x = gui_percentXRaw(8);
  }
  if( imgSize_y > gui_percentYRaw(16) ){
    imgSize_y = gui_percentYRaw(16);
  }
  if(imgSize_y < gui_percentYRaw(8)){
    imgSize_y = gui_percentYRaw(8);
  }
  
  viewAngle = input_angles;
  viewAngle_x = viewAngle_x * -1;

  makevectors(viewAngle);
  local vector imgOrg, cImgOrg;
  
  imgOrg = allyTarget.origin + (v_up * targSizeZ);
  
  switch( allyTarget.data_type ){
    case DATA_BLD:
      img = HUD_RAD_PIP_BLD;
      break;
    case DATA_VEHC:
      img = HUD_RAD_PIP_VEC;
      break;
    case DATA_MECH:
      img = HUD_RAD_PIP_MCH;
      break;
    default:
      img = UI_DEF_REC_64;
      break;
  }
  
  cImgOrg = cs_project(imgOrg);
  if (cImgOrg_z >= 0) {
    cImgOrg_x = cImgOrg_x - (imgSize_x / 2);
    cImgOrg_y = cImgOrg_y - (imgSize_y / 2);
    cImgOrg_z = 0;
    drawpic(cImgOrg, img, imgSize, factionColor * 2, 2, 0);
  }
};