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
      lorg_x = VIEW_ORG_x + 5; 
      lorg_y = VIEW_CTR_y - 24;
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_L, '16 48', trg_color, HUD_ALPHA, 0);
    }
    else if(targdir == AIM_FACE_RIGHT){
      lorg_x = (VIEW_ORG_x + VIEW_MAX_x) - 15; 
      lorg_y = VIEW_CTR_y  - 24;
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_R, '16 48', trg_color, HUD_ALPHA, 0);     
    }
    else if(targdir == AIM_FACE_BACK){
      lorg_x = VIEW_CTR_x - 24;
      lorg_y = VIEW_CTR_y + 48;
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_B, '48 16', trg_color, HUD_ALPHA, 0);
    }
  }
};

/*
  2D HUD - RENDERS A LABEL 'TARGET' AND THE TARGET'S NAME
*/
void(vector ofs, float algn) hud_renderTargetName={
  local float msgLen;
  local vector msgSize, factionColor;
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
  
  ofs = gui_calcAlign(ofs, algn);
  msg = strcat("[TARGET] ", targType);
  msgLen = stringwidth(msg, 0, '10 10 0');
  msgSize_x = msgLen/2;
  msgSize_y = 6;
  ofs_z = 0;
  drawstring(ofs, msg, '10 10', factionColor, HUD_ALPHA, 0);
  
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
    //2.0.0: lock-on timer DEPRECATED
    /*if( (CLIENT_stat_lock_state & LOCK_TARG_START) || (CLIENT_stat_lock_state & LOCK_TARG_HAS) ){
      lockColor = HUD_LOCK_COLOR;
    }
    else{
      lockColor = CLR_DEF_IFF_ENEMY;
    }*/
    
    lockColor = CLR_DEF_IFF_ENEMY;
  }
  dist = vlen(org - torg);
  if( dist > radRange ){
    dist = radRange;
  }
  dist = 1 * (dist / radRange);
  
  imgSize = draw_getimagesize(HUD_TARGET_BOX_TL) * 0.5 ;
  imgSize = imgSize * dist;
  
  if( imgSize_x > 48 ){
    imgSize_x = 48;
  }
  if(imgSize_x < 32){
    imgSize_x = 32;
  }
  if( imgSize_y > 48 ){
    imgSize_y = 48;
  }
  if(imgSize_y < 32){
    imgSize_y = 32;
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
    drawstring(nameproj, playerName, drawSize, factionColor * 1.5, max(0.75, HUD_ALPHA), 0);
  }
};

/*
  3D HUD - RENDER A SHIELD METER IN 3d SPACE
*/
void(vector org, vector torg, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis, float targFaction) hud_renderShieldOverlay={
  local float dist;
  local vector vpos, nofs, aSize;
  local float scopeVal;
  local float adj;
  
  local vector meterSize, pos;
  local vector meterColor;
  
  local vector iconOrg;
  local vector iconSize;
  local vector factionColor;
  
  scopeVal = rint(val);
  if( (CLIENT_faction == targFaction) && (targFaction != FACTION_ALL && CLIENT_faction != FACTION_ALL) ){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY_BLD;
  }

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
    
    meterSize = aSize;
    pos = nofs;
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
    
    if( (meterAxis & AXIS_H) ){
      drawpic(pos, "gfx/hud/hud_meter_cover3.png", aSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
      iconSize_x = meterSize_y;
      iconSize_y = meterSize_y;
    }
    else{
      drawpic(pos, "gfx/hud/hud_meter_cover.png", aSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
      iconSize_x = meterSize_x;
      iconSize_y = meterSize_x;
    }
    iconSize = iconSize * 2;
    iconSize_z = 0;
    iconOrg = gui_calcAlignCustom('10 2',(VIEW_LFT | VIEW_TOP), pos);
    iconOrg_z = 0;
    drawpic(iconOrg, HUD_ICON_SHIELD, iconSize, factionColor, HUD_ALPHA, 0);
  }
};

/*
  RENDER ARMOR METER
*/
void( vector pos, vector grpCtr, float val, vector mSize, string imgPiece, float thatTarget, float partFlag) hud_renderArmorMeter={
  local vector meterSize, shofs;
  local vector tColor;

  local float tAlpha;

  tColor = gui_getColorForArmor(val);
  
  shofs = grpCtr;
  meterSize = mSize;
  pos = gui_calcAlignCustom(pos, (VIEW_CTX | VIEW_CTY), shofs);
  
  if(thatTarget){
    tAlpha = max(HUD_ALPHA - 0.25, 0.1);
  }
  else{
    tAlpha = max(0.9, HUD_ALPHA);
  }
  
  drawpic(pos, imgPiece, meterSize, tColor, tAlpha, 0);
  
  if( thatTarget && (CLIENT_stat_hit_parts & partFlag) ){
    drawfill(pos, meterSize, CLR_DEF_RED, max(1.0, HUD_ALPHA * 1.5) , 0);
  }
};

/*
  RENDER ARMOR GRAPH STYLE 1
  used for mech targets
*/
void(vector vorg, float algn, float lFlag, float lalgn, vector lblOfs, vector lblSize, float isTarget) hud_renderArmorGraph={
  local vector pnl_ctr;

  local float ct, lt, rt, la, ra, lg;
  
  local vector backOrg;
  local vector backSize;
  local vector backColor;
  
  pnl_ctr = vorg;
  pnl_ctr = gui_calcAlign(pnl_ctr, algn);
  
  if(isTarget){
    ct = CLIENT_stat_trg_ct_hp;
    lt = CLIENT_stat_trg_lt_hp;
    rt = CLIENT_stat_trg_rt_hp;
    la = CLIENT_stat_trg_la_hp;
    ra = CLIENT_stat_trg_ra_hp;
    lg = CLIENT_stat_trg_lg_hp;
    backColor = CLR_DEF_IFF_ENEMY;
  }
  else{
    ct = CLIENT_health_center;
    lt = CLIENT_health_torso_left;
    rt = CLIENT_health_torso_right;
    la = CLIENT_health_arm_left;
    ra = CLIENT_health_arm_right;
    lg = CLIENT_health_legs;
    backColor = CLR_DEF_IIF_FRIEND;
  }
  
  if(lFlag){
    backOrg = lblOfs;
    backOrg = gui_calcAlignCustom(backOrg, lalgn, pnl_ctr);
    backSize = lblSize;
    gui_renderPatch9_1_32(backOrg, backSize, backColor, max(0.8, HUD_ALPHA), 0);
  }
  
  hud_renderArmorMeter('-10 -34', pnl_ctr, ct, '20 32', HUD_MECH_CT, isTarget, M_TOR_CENTER );
  
  hud_renderArmorMeter('-23 -38', pnl_ctr, lt, '13 31', HUD_MECH_ST, isTarget, M_TOR_LEFT);
  hud_renderArmorMeter('10 -38', pnl_ctr, rt, '13 31', HUD_MECH_ST, isTarget, M_TOR_RIGHT);
  
  hud_renderArmorMeter('-34 -26', pnl_ctr, la, '12 32', HUD_MECH_LA, isTarget, M_ARM_LEFT);
  hud_renderArmorMeter('22 -26', pnl_ctr, ra, '12 32', HUD_MECH_RA, isTarget, M_ARM_RIGHT);
  
  hud_renderArmorMeter('-20 -2', pnl_ctr, lg, '40 64', HUD_MECH_LEG, isTarget, M_LEGS);
  
};

/*
  2D HUD - RENDER ARMOR DIAGRAM: BUILDING
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val, float lFlag, float lalgn, vector lblOfs, vector lblSize) hud_renderArmorBuilding={
  local vector meter;
  local vector tColor;
  
  local vector backOrg;
  local vector backSize;
  local vector backColor;
  
  tColor =  gui_getColorForArmor(val);
  
  vorg = gui_calcAlign(vorg, algn);
  meter = siz;
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  
  if(CLIENT_faction != CLIENT_target_faction && CLIENT_faction != FACTION_ALL){
    backColor = CLR_DEF_IFF_ENEMY;
  }
  else{
    backColor = CLR_DEF_IIF_FRIEND;
  }
  
  if(lFlag){
    backOrg = lblOfs;
    backOrg = gui_calcAlignCustom(backOrg, lalgn, meter);
    backSize = lblSize;
    gui_renderPatch9_1_32(backOrg -'8 0', backSize, backColor, max(0.8, HUD_ALPHA), 0);
  }
  
  drawpic(meter, HUD_BUILD_TRG, siz, tColor, HUD_ALPHA, 0);
};

/*
  2D HUD - RENDER ARMOR DIAGRAM: VEHICLE
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val,  float lFlag, float lalgn, vector lblOfs, vector lblSize)hud_renderArmorVehicle={
  local vector meter;
  local vector tColor;
  
  local vector backOrg;
  local vector backSize;
  local vector backColor;
  
  tColor =  gui_getColorForArmor(val);
  
  vorg = gui_calcAlign(vorg, algn);
  meter = siz;
  
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), vorg);
  
  if(CLIENT_faction != CLIENT_target_faction && CLIENT_faction != FACTION_ALL){
    backColor = CLR_DEF_IFF_ENEMY;
  }
  else{
    backColor = CLR_DEF_IIF_FRIEND;
  }
  
  if(lFlag){
    backOrg = lblOfs;
    backOrg = gui_calcAlignCustom(backOrg, lalgn, meter);
    backSize = lblSize;
    gui_renderPatch9_1_32(backOrg, backSize, backColor, max(0.8, HUD_ALPHA), 0);
  }
  
  drawpic(meter, HUD_VEC_TRG, siz, tColor, HUD_ALPHA, 0);
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
  
  ofs = gui_calcAlign(ofs, algn);
  dist = ceil(vlen(torg - porg));
  msg = strcat("[RANGE] ", ftos(dist));
  msgSize = '0 0';
  msgLen = stringwidth(msg, 0, '10 10 0');
  msgSize_x = msgLen/2;
  msgSize_y = 6;
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
  imgSize = imgSize * dist ;
  
  if( imgSize_x > 16 ){
    imgSize_x = 16;
  }
  if(imgSize_x < 8){
    imgSize_x = 8;
  }
  if( imgSize_y > 16 ){
    imgSize_y = 16;
  }
  if(imgSize_y < 8){
    imgSize_y = 8;
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
  //func call optimization, 
  //util_checkPointAngleImpl(trg.origin, self.origin, self.angles);
  
  local float targYaw;
  local float checkYaw;
  
  targYaw = vectoyaw( trg.origin - self.origin );
  checkYaw = anglemod( self.angles_y - targYaw );
  
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
  
  return AIM_FACE_FRONT;
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
  
  return AIM_FACE_FRONT;
};