/*
battleMETAL
Author: Peter Roohr
Date: 3/30/2020
  broke main hud file down for maintainability
  target - deals with all target hud stuff
*/

/*
  RENDER TARGET DIRECTION INDICATORS
  
  AIM_FACE_FRONT   = 1;
  AIM_FACE_LEFT    = 2;
  AIM_FACE_RIGHT   = 3;
  AIM_FACE_BACK    = 4;
*/ 
void(float targdir, float plrFaction, float trgfaction, float dattype) hud_renderTargetDirection={
  vector trg_color;
  local vector lorg;
  
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
  if(targdir > AIM_FACE_FRONT){
    if(targdir == AIM_FACE_LEFT){
      lorg_x = VIEW_ORG_x + gui_percentXRaw(5); 
      lorg_y = VIEW_CTR_y - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_L, gui_percentToPixelRawVec('16 48'), trg_color, HUD_ALPHA, 0);
    }
    else if(targdir == AIM_FACE_RIGHT){
      lorg_x = (VIEW_ORG_x + VIEW_MAX_x) - gui_percentXRaw(15); 
      lorg_y = VIEW_CTR_y  - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_R, gui_percentToPixelRawVec('16 48'), trg_color, HUD_ALPHA, 0);     
    }
    else if(targdir == AIM_FACE_BACK){
      lorg_x = VIEW_CTR_x - gui_percentXRaw(24);
      lorg_y = VIEW_CTR_y + gui_percentYRaw(48);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_B, gui_percentToPixelRawVec('48 16'), trg_color, HUD_ALPHA, 0);
    }
  }
};

/*
  2D HUD - RENDERS A LABEL 'TARGET' AND THE TARGET'S NAME
*/
void(vector ofs, float algn) hud_renderTargetName={
  local float msgLen;
  local vector tofs, msgSize, factionColor;
  local string msg;
  local string targType;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( CLIENT_target_faction == FACTION_ALL ){
    factionColor = CLR_DEF_IFF_ENEMY;
  }
  else if( CLIENT_target_faction != CLIENT_faction ){
    factionColor = CLR_DEF_IFF_ENEMY;
  }
  else{
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  
  if( (CLIENT_target_ent.flags & FL_CLIENT) ){
    targType = getplayerkeyvalue(CLIENT_target_ent.clientLocalNum, "name");
  }
  else{
    if( CLIENT_target_ent.netname != "" || strlen(CLIENT_target_ent.netname) > 0 ){
      targType = CLIENT_target_ent.netname;
    }
    else{
      targType = CLIENT_target_ent.vec_name;
    }
  }
  msgSize = '0 0';
  
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
  3D HUD - RENDER TARGET PIPS OVER AN ORIGIN IN 3D SPACE
*/
void(vector org, vector torg, float algn, float faction1, float faction2, float radRange) hud_renderTargetOverlay={
  local float dist;
  local float targSizeX, targSizeY, targSizeZ, targZbottom;
  local vector viewAngle;
  local vector imgSize, factionColor, lockColor;
  local float boxAlpha;
  
  local vector tl, tr, br, bl;
  local vector c_tl, c_tr, c_br, c_bl;
  
  local vector namepos, nameproj, drawSize;
  local float namelen, drawdist, adj;
  
  local string playerName;
  
  targSizeX = CLIENT_target_size_x;
  targSizeY = CLIENT_target_size_y; 
  targSizeZ = CLIENT_target_size_z;
  
  if( targSizeZ < 1 ){
    targZbottom = 0;
  }
  else{
    targZbottom = targSizeZ;
  }
  
  if( (faction1 == faction2) && (faction2 != FACTION_ALL && faction1 != FACTION_ALL) ){
    factionColor = CLR_DEF_IIF_FRIEND;
    lockColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY;
    if( (CLIENT_stat_lock_state & LOCK_TARG_START) || (CLIENT_stat_lock_state & LOCK_TARG_HAS) ){
      lockColor = HUD_LOCK_COLOR;
    }
    else{
      lockColor = CLR_DEF_IFF_ENEMY;
    }
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
  
  boxAlpha  = max(0.25, HUD_ALPHA - 0.15);
  
  viewAngle = input_angles;
  viewAngle_x = viewAngle_x * -1;

  makevectors(viewAngle);

  tl = org + (v_right * (targSizeX * -1)) + (v_up * targSizeZ);
  tr = org + (v_right * targSizeX) + (v_up * targSizeZ);
  br = org + (v_right * targSizeX) + (v_up * (targZbottom * -1));
  bl = org + (v_right * (targSizeX * -1)) + (v_up * (targZbottom * -1));
 
  c_tl = cs_project(tl);
  if (c_tl_z >= 0) {
    c_tl_x = c_tl_x - (imgSize_x / 2);
    c_tl_y = c_tl_y - (imgSize_y / 2);
    c_tl_z = 0;
    gui_renderTintImage(TRUE, c_tl, HUD_TARGET_BOX_TL, imgSize, lockColor, boxAlpha, 0);
  }

  c_tr = cs_project(tr);
  if (c_tr_z >= 0) {
    c_tr_x = c_tr_x - (imgSize_x / 2);
    c_tr_y = c_tr_y - (imgSize_y / 2);
    c_tr_z = 0;
    gui_renderTintImage(TRUE, c_tr, HUD_TARGET_BOX_TR, imgSize, lockColor, boxAlpha, 0);
  }
  
  c_br = cs_project(br);
  if (c_br_z >= 0) {
    c_br_x = c_br_x - (imgSize_x / 2);
    c_br_y = c_br_y - (imgSize_y / 2);
    c_br_z = 0;
    gui_renderTintImage(TRUE, c_br, HUD_TARGET_BOX_BR, imgSize, lockColor,boxAlpha, 0);
  }
  
  c_bl = cs_project(bl);
  if (c_tl_z >= 0) {
    c_bl_x = c_bl_x - (imgSize_x / 2);
    c_bl_y = c_bl_y - (imgSize_y / 2);
    c_bl_z = 0;
    gui_renderTintImage(TRUE, c_bl, HUD_TARGET_BOX_BL, imgSize, lockColor, boxAlpha, 0);
  }
  
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
  
  namelen = stringwidth(playerName, 0, drawSize);
  namepos = CLIENT_target_ent.origin;
  namepos_z = namepos_z - (adj + drawSize_y);  //magik numbers, :/
  nameproj = cs_project(namepos);
  if( nameproj_z >= 0 ){
    nameproj_x = nameproj_x - gui_percentXRaw(namelen / 2);
    nameproj_z = 0;
    drawstring(nameproj, playerName, drawSize, factionColor * 1.5, max(0.75, HUD_ALPHA), 0);
  }
  namepos = cs_unproject(nameproj);
  
};

/*
  3D HUD - RENDER A SHIELD METER IN 3d SPACE
*/
void(vector org, vector torg, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis) hud_renderShieldOverlay={
  local float dist;
  local vector vpos, nofs, aSize;
  local float scopeVal;
  local float adj;
  
  local vector meterSize, pos;
  local vector meterColor;
  
  scopeVal = rint(val);
  if(scopeVal != 0){
  
    dist = vlen(pmove_org - CLIENT_target_ent.origin);
    if(dist < CLIENT_radar_range * 0.1){
      adj = 25;
    }
    else if( dist < CLIENT_radar_range * 0.25 ){
      adj = 40;
    }
    else if( dist < CLIENT_radar_range * 0.5 ){
      adj = 65;
    }
    else if(  dist < CLIENT_radar_range * 0.75 ){
      adj = 85;
    }
    else{
      adj = 100;
    }
    
    aSize_x = mSize_x * dist;
    if(aSize_x > mSize_x){
      aSize_x = mSize_x;
    }
    aSize_y = mSize_y * dist;
    if(aSize_y > mSize_y){
      aSize_y = mSize_y;
    }
    vpos = org;
    vpos_z = vpos_z + (adj + (aSize_y * 7.5));  //magik numbers, :/
    nofs = cs_project(vpos);
    if (nofs_z >= 0) {
      nofs_x = nofs_x - (aSize_x / 2);
      nofs_z = 0;
      
      meterSize = gui_percentToPixelRawVec(aSize);
      pos = gui_percentToPixelRawVec(nofs);
      pos = gui_calcAlign(pos, algn);
     
      meterColor = CLR_DEF_ARM_DED;
      if( scopeVal > 100 ){
        //render delay regen
        scopeVal = 100 - scopeVal;
        gui_renderMeter( (scopeVal * -1), pos, aSize, meterColor, CLR_DEF_RED, HUD_ALPHA, 0, AXIS_H, FALSE);
      }
      else{
        gui_renderMeter(scopeVal, pos, aSize, meterColor, gui_getColorForShield(scopeVal), HUD_ALPHA, 0, AXIS_H, FALSE); 
      }
      drawpic(pos, "gfx/hud/hud_meter_cover3.png", aSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    }
    cs_unproject(vpos);
  }
};



/*
  2D HUD - RENDER ARMOR DIAGRAM: BUILDING
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val) hud_renderArmorBuilding={
  local vector meter;
  local vector tColor;
  
  if(CLIENT_target_faction == CLIENT_faction){
   tColor =  gui_getColorForArmor(val);
  }
  else{
   tColor =  gui_getColorForArmorTarget(val);
  }
  
  vorg = gui_percentToPixelRawVec(vorg);
  vorg = gui_calcAlign(vorg, algn);
  meter = gui_percentToPixelRawVec(siz);
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  
  gui_renderMeter(val, meter, siz, CLR_DEF_ARM_DED, tColor, HUD_ALPHA, 0, AXIS_V, 0);
  drawpic(meter, "gfx/hud/hud_meter_cover2.png", siz, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
};

/*
  2D HUD - RENDER ARMOR DIAGRAM: VEHICLE
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val)hud_renderArmorVehicle={
  local vector meter;
  local vector tColor;
  
  if(CLIENT_target_faction == CLIENT_faction){
   tColor =  gui_getColorForArmor(val);
  }
  else{
   tColor =  gui_getColorForArmorTarget(val);
  }
  
  vorg = gui_percentToPixelRawVec(vorg);
  vorg = gui_calcAlign(vorg, algn);
  meter = gui_percentToPixelRawVec(siz);
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  gui_renderMeter(val, meter, siz, CLR_DEF_ARM_DED, tColor, HUD_ALPHA, 0, AXIS_V, 0);
};

/*
  2D HUD - RENDERS A LABEL 'RANGE' AND DISTANCE TO ORIGIN
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
  msgSize = '0 0';
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
  local vector imgOrg, cImgOrg;

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


//inspired by original inFront function
float(entity trg) util_checkPointAngle={
  local float toSender;
  toSender = util_checkPointAngleImpl(trg.origin, self.origin, self.angles);
  return toSender;
};

/*
  Given a target origin, and a source origin, and the source's facing;  
    calculate if the source origin is FACING the target origin.
    If not, return which quadrant the target is actually in.

  AIM_FACE_FRONT   = 1;
  AIM_FACE_LEFT    = 2;
  AIM_FACE_RIGHT   = 3;
  AIM_FACE_BACK    = 4;
*/
float(vector orig, vector srcOrg, vector srcAngl) util_checkPointAngleImpl={
  
  local float targYaw;
  local float checkYaw;
  
  targYaw = vectoyaw( orig - srcOrg );
  checkYaw = anglemod( srcAngl_y - targYaw );
  
  //Target in Front
  if( checkYaw >= 305 && checkYaw <= 55){
    return AIM_FACE_FRONT;
  }
  
  //Target to the Left
  if( checkYaw > 255 && checkYaw <= 305){
    return AIM_FACE_LEFT;
  }
  
  //Target to the Right
  if( checkYaw >= 55 && checkYaw < 110){
    return AIM_FACE_RIGHT;
  }
  
  //Target to the Rear
  if( checkYaw > 110 && checkYaw < 255){
    return AIM_FACE_BACK;
  }
};