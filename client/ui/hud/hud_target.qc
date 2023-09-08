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
  
  if( targdir <= 270 && targdir >= 45 ){
    lorg_x = VIEW_CTR_x + 128 * cos(anglemod(270 - targdir) * M_PI/180);
    lorg_y = VIEW_CTR_y + 128 * sin(anglemod(270 - targdir) * M_PI/180);
    drawrotpic(lorg , "gfx/hud/map_up.png", '64 64', '32 32', targdir, trg_color, HUD_ALPHA, 0);
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
  local string varType;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( CLIENT_target_ent.faction == FACTION_ALL ){
    factionColor = CLR_DEF_IFF_ENEMY;
  }
  else if( CLIENT_target_ent.faction != CLIENT_faction ){
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
  
  switch(CLIENT_target_ent.subType){
    default:
      varType = "";
      break;
    case AI_UTYPE_MIS:
      varType = "MIS";
      break;
    case AI_UTYPE_DIR:
      varType = "DIR";
      break;
    case AI_UTYPE_ENE:
      varType = "ENE";
      break;
    case AI_UTYPE_SKR:
      varType = "SKR";
      break;
  }
  
  msgSize = '0 0';
  
  ofs = gui_calcAlign(ofs, algn);
  msg = sprintf("[TARGET] %s-%s", targType, varType);
  
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
void(entity targetEnt) hud_renderTargetOverlay={
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
  
  targSizeX = (targetEnt.cache_maxs_x + targetEnt.cache_maxs_y) / 3;
  targSizeZ = targetEnt.cache_maxs_z;
  
  if( targSizeZ < 1 ){
    targZbottom = 0;
  }
  else{
    targZbottom = targSizeZ;
  }
  
  if( (CLIENT_server_ent.faction == targetEnt.faction) && (targetEnt.faction != FACTION_ALL && CLIENT_server_ent.faction != FACTION_ALL) ){
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
  dist = vlen(targetEnt.rootOrigin - CLIENT_vis_org);

  if( dist > CLIENT_radar_range ){
    dist = CLIENT_radar_range;
  }
  dist = 1 * (dist / CLIENT_radar_range);
  
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
  
  boxAlpha  = max(0.25, HUD_ALPHA - 0.25);
  
  viewAngle = view_angles;
  viewAngle_x = viewAngle_x * -1;

  makevectors(viewAngle);

  tl = targetEnt.rootOrigin + (v_right * (targSizeX * -1)) + (v_up * targSizeZ);
  tr = targetEnt.rootOrigin + (v_right * targSizeX) + (v_up * targSizeZ);
  br = targetEnt.rootOrigin + (v_right * targSizeX) + (v_up * (targZbottom * -1));
  bl = targetEnt.rootOrigin + (v_right * (targSizeX * -1)) + (v_up * (targZbottom * -1));

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
  if (c_bl_z >= 0) {
    c_bl_x = c_bl_x - (imgSize_x / 2);
    c_bl_y = c_bl_y - (imgSize_y / 2);
    c_bl_z = 0;
    gui_renderTintImage(TRUE, c_bl, HUD_TARGET_BOX_BL, imgSize, lockColor, boxAlpha, 0);
  }

  drawdist = vlen(CLIENT_vis_org - targetEnt.rootOrigin); 
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
  
  if( (targetEnt.flags & FL_CLIENT) ){
    playerName = getplayerkeyvalue(targetEnt.clientLocalNum, "name");
  }
  else{
    if( targetEnt.netname != "" || strlen(targetEnt.netname) > 0 ){
      playerName = targetEnt.netname;
    }
    else{
      playerName = targetEnt.vec_name;
    }
  }
  if( playerName == "" ){
    return;
  }
  namelen = stringwidth(playerName, 0, drawSize);
  namepos = targetEnt.rootOrigin;
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
void(entity targetEnt, float algn, float val, vector mSize, float meterAxis) hud_renderShieldOverlay={
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
  if( (CLIENT_faction == targetEnt.faction) && (targetEnt.faction != FACTION_ALL && CLIENT_faction != FACTION_ALL) ){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY_BLD;
  }

  dist = vlen(CLIENT_vis_org - targetEnt.rootOrigin);
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
  vpos = targetEnt.rootOrigin;
  vpos_z = vpos_z + (adj + (aSize_y * 7.5));  //magik numbers, :/
  nofs = cs_project(vpos);
  if (nofs_z >= 0) {
    nofs_x = nofs_x - (aSize_x / 2);
    nofs_z = 0;
    
    meterSize = aSize;
    pos = nofs;
    pos = gui_calcAlign(pos, algn);
   
    meterColor = CLR_DEF_ARM_DED;
    if( scopeVal > 100.01){
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
void(vector vorg, vector vSize, float algn, float lalgn, vector lblOfs, vector lblSize, float isTarget) hud_renderArmorMech={
  local vector panelOrg;
  local vector pnl_ctr;

  local vector backOrg;
  local vector backSize;
  local vector backColor;
  local float ct, lt, rt, la, ra, lg;

  panelOrg = gui_calcAlign(vorg, algn);
  
  if(isTarget){
    if(CLIENT_target_ent.faction == CLIENT_faction && CLIENT_faction != FACTION_ALL ){
      backColor = CLR_DEF_IIF_FRIEND_BLD;
    }
    else{
      backColor = CLR_DEF_IFF_ENEMY;
    }
  }
  else{
    backColor = CLR_DEF_IIF_FRIEND;
  }
   
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
  
  pnl_ctr = backOrg + backSize * 0.5;

  if(isTarget){
    ct = CLIENT_target_ent.torC_hp;
    lt = CLIENT_target_ent.torL_hp;
    rt = CLIENT_target_ent.torR_hp;
    la = CLIENT_target_ent.armL_hp;
    ra = CLIENT_target_ent.armR_hp;
    lg = CLIENT_target_ent.legs_hp;
  }
  else{
    ct = CLIENT_server_ent.torC_hp;
    lt = CLIENT_server_ent.torL_hp;
    rt = CLIENT_server_ent.torR_hp;
    la = CLIENT_server_ent.armL_hp;
    ra = CLIENT_server_ent.armR_hp;
    lg = CLIENT_server_ent.legs_hp;
  }  
  hud_renderArmorMeter('-10 -34', pnl_ctr, ct, '20 32', HUD_MECH_CT, isTarget, M_TOR_CENTER );
  
  hud_renderArmorMeter('-23 -38', pnl_ctr, lt, '13 31', HUD_MECH_ST, isTarget, M_TOR_LEFT);
  hud_renderArmorMeter('10 -38', pnl_ctr, rt, '13 31', HUD_MECH_ST, isTarget, M_TOR_RIGHT);
  
  hud_renderArmorMeter('-34 -26', pnl_ctr, la, '12 32', HUD_MECH_LA, isTarget, M_ARM_LEFT);
  hud_renderArmorMeter('22 -26', pnl_ctr, ra, '12 32', HUD_MECH_RA, isTarget, M_ARM_RIGHT);
  
  hud_renderArmorMeter('-20 -2', pnl_ctr, lg, '40 64', HUD_MECH_LEG, isTarget, M_LEGS);
  
};

void(vector vorg, vector vSize, float algn, float lalgn, vector lblOfs, vector lblSize) hud_renderArmorMech3D={
  local vector panelOrg;
  local vector viewOrg;
  
  local float ct, lt, rt, la, ra, lg;
  
  local entity hudEnt;
  local float zTotal;
  local float zBias;
  local float zHalf;
  local float xHalf;

  local vector panelOrg;

  local vector backOrg;
  local vector backSize;
  local vector backColor;

  local vector tAngles;
  local vector prevAngl;
  local vector colorCT, colorRT, colorLT, colorLA, colorRA, colorLG;

  panelOrg = gui_calcAlign(vorg, algn);

  backColor = CLR_DEF_IFF_ENEMY;
  if(CLIENT_target_ent.faction == CLIENT_faction && CLIENT_faction != FACTION_ALL ){
    backColor = CLR_DEF_IIF_FRIEND_BLD;
  } 

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
  
  panelOrg = gui_calcAlign(vorg, algn);
    ct = CLIENT_target_ent.torC_hp;
    lt = CLIENT_target_ent.torL_hp;
    rt = CLIENT_target_ent.torR_hp;
    la = CLIENT_target_ent.armL_hp;
    ra = CLIENT_target_ent.armR_hp;
    lg = CLIENT_target_ent.legs_hp;
    HUD_MODEL_ARMOR_GRAPH_TARGET.mins = CLIENT_target_ent.cache_mins;
    HUD_MODEL_ARMOR_GRAPH_TARGET.maxs = CLIENT_target_ent.cache_maxs;
    hudEnt = HUD_MODEL_ARMOR_GRAPH_TARGET;
    
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
    clearscene();
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
    
    if( CLIENT_faction == CLIENT_target_ent.faction && CLIENT_faction != FACTION_ALL){
      colorCT = gui_getColorForArmor(ct) * 2;
      colorLT = gui_getColorForArmor(lt) * 2;
      colorRT = gui_getColorForArmor(rt) * 2;
      colorLA = gui_getColorForArmor(la) * 2;
      colorRA = gui_getColorForArmor(ra) * 2;
      colorLG = gui_getColorForArmor(lg) * 2;
      
    }
    else{
      colorCT = gui_getColorForArmorTarget(ct) * 2;
      colorLT = gui_getColorForArmorTarget(lt) * 2;
      colorRT = gui_getColorForArmorTarget(rt) * 2;
      colorLA = gui_getColorForArmorTarget(la) * 2;
      colorRA = gui_getColorForArmorTarget(ra) * 2;
      colorLG = gui_getColorForArmorTarget(lg) * 2;
    }
    
    hudEnt.origin = viewOrg;
    tAngles = vectoangles(CLIENT_target_ent.origin - CLIENT_vis_org);
    
    prevAngl = hudEnt.angles = [CLIENT_target_ent.angles_x, anglemod(CLIENT_target_ent.angles_y - tAngles_y), 0];
    
    hudEnt.torC_org = hud_model_armor_part_frame(CLIENT_target_ent.torC_compOffset, viewOrg);
    hudEnt.torC_angl = [CLIENT_target_ent.torC_angl_x, anglemod(CLIENT_target_ent.torC_angl_y - tAngles_y), 0];
    hudEnt.colormod = colorCT;
    setmodel(hudEnt, CLIENT_target_ent.torC_mdl);
    hudEnt.origin = hudEnt.torC_org;
    hudEnt.angles = hudEnt.torC_angl;
    addentity(hudEnt);
    hudEnt.angles = prevAngl;
    
    makevectors(hudEnt.torC_angl);
    if( (hudEnt.unitModFlags & MOD_HAS_TOR_L) ){
      hudEnt.torL_org = hud_model_armor_part_frame(CLIENT_target_ent.torL_compOffset, viewOrg);
      hudEnt.torL_angl   = [CLIENT_target_ent.torL_angl_x, hudEnt.torC_angl_y, 0];  
      hudEnt.colormod   = colorLT;
      setmodel(hudEnt, CLIENT_target_ent.torL_mdl);
      hudEnt.origin = hudEnt.torL_org;
      hudEnt.angles = hudEnt.torL_angl;
      addentity(hudEnt);
      hudEnt.angles = prevAngl;
    }
    if( (hudEnt.unitModFlags & MOD_HAS_TOR_R) ){
      hudEnt.torR_org = hud_model_armor_part_frame(CLIENT_target_ent.torR_compOffset, viewOrg);
      hudEnt.torR_angl  = [CLIENT_target_ent.torR_angl_x, hudEnt.torC_angl_y, 0];
      hudEnt.colormod  = colorRT;  
      setmodel(hudEnt, CLIENT_target_ent.torR_mdl);
      hudEnt.origin = hudEnt.torR_org;
      hudEnt.angles = hudEnt.torR_angl;
      addentity(hudEnt);
      hudEnt.angles = prevAngl;
    }
    if( (hudEnt.unitModFlags & MOD_HAS_ARM_L) ){
      hudEnt.armL_org = hud_model_armor_part_frame(CLIENT_target_ent.armL_compOffset, viewOrg);
      hudEnt.armL_angl     = [CLIENT_target_ent.armL_angl_x, hudEnt.torC_angl_y, 0];
      hudEnt.colormod           = colorLA;
      setmodel(hudEnt, CLIENT_target_ent.armL_mdl);
      hudEnt.origin = hudEnt.armL_org;
      hudEnt.angles = hudEnt.armL_angl;
      addentity(hudEnt);
      hudEnt.angles = prevAngl;
    }
    if( (hudEnt.unitModFlags & MOD_HAS_ARM_R) ){
      hudEnt.armR_org = hud_model_armor_part_frame(CLIENT_target_ent.armR_compOffset, viewOrg);
      hudEnt.armR_angl    = [CLIENT_target_ent.armR_angl_x, hudEnt.torC_angl_y, 0];
      hudEnt.colormod          = colorRA;
      setmodel(hudEnt, CLIENT_target_ent.armR_mdl);
      hudEnt.origin = hudEnt.armR_org;
      hudEnt.angles = hudEnt.armR_angl;
      addentity(hudEnt);
      hudEnt.angles = prevAngl;
    }
    
    hudEnt.legs_org = hud_model_armor_part_frame(CLIENT_target_ent.legs_compOffset, viewOrg);
    hudEnt.frame = CLIENT_target_ent.legs_frame;
    hudEnt.colormod = colorLG;
    setmodel(hudEnt, CLIENT_target_ent.legs_mdl);
    hudEnt.origin = hudEnt.legs_org;
    addentity(hudEnt);   
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
  HUD_MODEL_ARMOR_GRAPH_TARGET.mins = CLIENT_target_ent.cache_mins;
  HUD_MODEL_ARMOR_GRAPH_TARGET.maxs = CLIENT_target_ent.cache_maxs;
}; 

/*
  2D HUD - RENDER ARMOR DIAGRAM: BUILDING
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val, float lFlag, float lalgn, vector lblOfs, vector lblSize) hud_renderArmorBuilding={

  local vector panelOrg;
  local vector meter;
  local vector tColor;
  
  local vector backOrg;
  local vector backSize;
  local vector backColor;
  
  local vector viewMins;
  local vector viewMaxs;
  
  local vector viewOrg;
  local float zTotal;
  local float zBias;
  local float zHalf;
  local float xHalf;
  local vector tAngles;
  local vector cOrg;

  panelOrg = gui_calcAlign(vorg, algn);
  meter = siz;
  
  meter_x = meter_x / 2;
  meter_y = meter_y / 2;
  meter = gui_calcAlignCustom(meter, (VIEW_CTX | VIEW_TOP), panelOrg);
  
  if(CLIENT_faction != CLIENT_target_ent.faction && CLIENT_faction != FACTION_ALL){
    backColor = CLR_DEF_IFF_ENEMY;
    tColor = gui_getColorForArmorTarget(val);
  }
  else{
    backColor = CLR_DEF_IIF_FRIEND;
    tColor = gui_getColorForArmor(val);
  }
  
  if( lblSize != '0 0 0'){
    backSize_x = ceil(lblSize_x / 16) * 16;
    backSize_y = ceil(lblSize_y / 16) * 16;
    backOrg = gui_calcAlignBiased(siz, lblSize, lalgn, panelOrg, '0.9 0.9'); 
  }
  else{
    backSize_x = (ceil(siz_x / 16)) * 16;
    backSize_y = (ceil(siz_y / 16) + 1) * 16;
    backOrg_x = backOrg_x - 8;
    backOrg_y = backOrg_y - 8;
    backOrg = backOrg + gui_calcAlignCustom(lblOfs, lalgn, panelOrg);
  }
  
  gui_renderPatch9_1_32(backOrg, backSize, backColor, max(0.8, HUD_ALPHA), 0);
  
  if(HUD_TARGET_3D){
    viewMins_x = max(CLIENT_target_ent.maxs_x, CLIENT_target_ent.maxs_y) * -1;
    viewMins_y = viewMins_x;
    viewMins_z = CLIENT_target_ent.mins_z;
    
    viewMaxs_x = viewMins_x * -1;
    viewMaxs_y = viewMaxs_x;
    viewMaxs_z = CLIENT_target_ent.maxs_z;
    
    if(ENT_SERVER_INFO.uiViewBoxOrg != '0 0 0'){
      viewOrg = ENT_SERVER_INFO.uiViewBoxOrg;
    }
    else{
      viewOrg = CLIENT_vis_org;
    }
      
      zBias = (viewMins_z - viewMaxs_z)/2 - viewMins_z;
      zTotal = ((viewMins_z * -1) + viewMaxs_z) / 2;
      zHalf = ((viewMins_z * -1) + viewMaxs_z * 1.25);
      xHalf = viewMaxs_x * 0.5;
      
      makevectors('0 0 0');

      clearscene();
      setproperty(VF_ORIGIN, viewOrg + (v_forward * (viewMaxs_x * 0.55) * -4));	//look towards it.
      setproperty(VF_ANGLES, '0 0 0');
      setproperty(VF_MIN, vtodpp([panelOrg_x, panelOrg_y, 0]) );
      setproperty(VF_SIZE, vtodpp([siz_x, siz_y, 0]) );
      
      //NOTE - 5.0.0 - disabling it for buildings, because WTH this doesn't work for building mins/maxs but somehow works for
        //mechs and vehcs? bizarre.
      //set an explicit fov. this thing had better be square. DP doesn't support VF_AFOV
      //setproperty(VF_FOV, [40, atan(siz_y/(siz_x/tan(40/360*6.28))) * 360/6.28, 0]); 
      
      setproperty(VF_FOV, [45, 45, 0]); 
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
    
      HUD_MODEL_ARMOR_GRAPH_TARGET.colormod = tColor * 2;
      
      tAngles = vectoangles(CLIENT_target_ent.origin - CLIENT_vis_org);
    
      HUD_MODEL_ARMOR_GRAPH_TARGET.origin = viewOrg ;
      HUD_MODEL_ARMOR_GRAPH_TARGET.angles = CLIENT_target_ent.angles;
      HUD_MODEL_ARMOR_GRAPH_TARGET.angles_x = 0;
      HUD_MODEL_ARMOR_GRAPH_TARGET.angles_y = anglemod(HUD_MODEL_ARMOR_GRAPH_TARGET.angles_y - tAngles_y);
      setmodel(HUD_MODEL_ARMOR_GRAPH_TARGET, CLIENT_target_ent.model);
      addentity(HUD_MODEL_ARMOR_GRAPH_TARGET);
      
      //building is a Turret
      if( (CLIENT_target_ent.flags & FL_TURRET) ){
        local vector turAngl;
        turAngl = [0, CLIENT_target_ent.angles_y, CLIENT_target_ent.angles_z];
        makevectors(turAngl);
        cOrg = HUD_MODEL_ARMOR_GRAPH_TARGET.origin + (v_forward * CLIENT_target_ent.torC_compOffset_z) +
            (v_right * CLIENT_target_ent.torC_compOffset_x) + (v_up * CLIENT_target_ent.torC_compOffset_y);
        HUD_MODEL_ARMOR_GRAPH_TARGET.torC_org = cOrg;
        
        HUD_MODEL_ARMOR_GRAPH_TARGET.origin = HUD_MODEL_ARMOR_GRAPH_TARGET.torC_org;
        HUD_MODEL_ARMOR_GRAPH_TARGET.angles_x = CLIENT_target_ent.torC_angl_x;
        HUD_MODEL_ARMOR_GRAPH_TARGET.angles_y = anglemod(CLIENT_target_ent.torC_angl_y - tAngles_y);
        
        setmodel(HUD_MODEL_ARMOR_GRAPH_TARGET, CLIENT_target_ent.torC_mdl);      
        addentity(HUD_MODEL_ARMOR_GRAPH_TARGET);
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
    HUD_MODEL_ARMOR_GRAPH_TARGET.mins = CLIENT_target_ent.cache_mins;
    HUD_MODEL_ARMOR_GRAPH_TARGET.maxs = CLIENT_target_ent.cache_maxs;
    //------------------------------------------------------------------------
  }
  else{
    siz = gui_newAspectRatio(draw_getimagesize(HUD_BUILD_TRG), siz);
    meter = siz;
    meter_x = meter_x / 2;
    meter_y = meter_y / 2;
    meter = gui_calcAlignCustom(meter, (VIEW_LFT | VIEW_TOP), backOrg + (backSize * 0.5));
    drawpic(meter, HUD_BUILD_TRG, siz, tColor, HUD_ALPHA, 0);
  }
};

/*
  2D HUD - RENDER ARMOR DIAGRAM: VEHICLE
  you might want to cover this with a nice overlay picture
*/
void(vector vorg, float algn, vector siz, float val,  float lFlag, float lalgn, vector lblOfs, vector lblSize)hud_renderArmorVehicle={
  local vector panelOrg;
  local vector meter;
  local vector tColor;
  
  local vector backOrg;
  local vector backSize;
  local vector backColor;
  
  local vector viewOrg;
  local float zTotal;
  local float zBias;
  local float zHalf;
  local float xHalf;
  local vector tAngles;
  local vector cOrg;
  
  vorg = gui_calcAlign(vorg, algn);
  
  if(CLIENT_faction != CLIENT_target_ent.faction && CLIENT_faction != FACTION_ALL){
    backColor = CLR_DEF_IFF_ENEMY;
    tColor = gui_getColorForArmorTarget(val);
  }
  else{
    backColor = CLR_DEF_IIF_FRIEND;
    tColor = gui_getColorForArmor(val);
  }
  
  if( lblSize != '0 0 0'){
    backSize_x = ceil(lblSize_x / 16) * 16;
    backSize_y = ceil(lblSize_y / 16) * 16;
    backOrg = gui_calcAlignBiased(siz, lblSize, lalgn, vorg, '0.9 0.9'); 
  }
  else{
    backSize_x = (ceil(siz_x / 16)) * 16;
    backSize_y = (ceil(siz_y / 16) + 1) * 16;
    backOrg_x = backOrg_x - 8;
    backOrg_y = backOrg_y - 8;
    backOrg = backOrg + gui_calcAlignCustom(lblOfs, lalgn, vorg);
  }
  
  gui_renderPatch9_1_32(backOrg, backSize, backColor, max(0.8, HUD_ALPHA), 0);
  
  if(HUD_TARGET_3D){
    if(ENT_SERVER_INFO.uiViewBoxOrg != '0 0 0'){
      viewOrg = ENT_SERVER_INFO.uiViewBoxOrg;
    }
    else{
      viewOrg = CLIENT_vis_org;
    }
      HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_z = max(HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_z, 24); //test
      
      zBias = (HUD_MODEL_ARMOR_GRAPH_TARGET.mins_z - HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_z)/2 - HUD_MODEL_ARMOR_GRAPH_TARGET.mins_z;
      zTotal = ((HUD_MODEL_ARMOR_GRAPH_TARGET.mins_z * -1) + HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_z) / 2;
      zHalf = ((HUD_MODEL_ARMOR_GRAPH_TARGET.mins_z * -1) + HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_z * 1.25);
      xHalf = HUD_MODEL_ARMOR_GRAPH_TARGET.maxs_x * 1.5;
      
      makevectors('30 0 0');
      clearscene();
      setproperty(VF_ORIGIN, viewOrg + (v_forward * -175 - xHalf) - (v_right * xHalf) + (v_up * zHalf));	//look towards it.
      setproperty(VF_ANGLES, '30 0 0');
      setproperty(VF_MIN, vtodpp([vorg_x,vorg_y, 0]) );
      setproperty(VF_SIZE, vtodpp([siz_x, siz_y, 0]) );
      //set an explicit fov. this thing had better be square. DP doesn't support VF_AFOV
      setproperty(VF_FOV, [zTotal, atan(siz_y/(siz_x/tan(zTotal/360*6.28))) * 360/6.28, 0]); 
      
      
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
    
      HUD_MODEL_ARMOR_GRAPH_TARGET.colormod = tColor * 2;
      
      tAngles = vectoangles(CLIENT_target_ent.origin - CLIENT_vis_org);
    
      setmodel(HUD_MODEL_ARMOR_GRAPH_TARGET, CLIENT_target_ent.legs_mdl);
      HUD_MODEL_ARMOR_GRAPH_TARGET.origin =  viewOrg;
      HUD_MODEL_ARMOR_GRAPH_TARGET.angles = CLIENT_target_ent.angles;
      HUD_MODEL_ARMOR_GRAPH_TARGET.angles_y = anglemod(HUD_MODEL_ARMOR_GRAPH_TARGET.angles_y - tAngles_y);
      addentity(HUD_MODEL_ARMOR_GRAPH_TARGET);
      
      //Vehicle has a Turret
      if( (CLIENT_target_ent.flags & FL_TURRET) ){
        local vector turAngl;
        turAngl = [0, CLIENT_target_ent.angles_y, CLIENT_target_ent.angles_z];
        makevectors(turAngl);
        cOrg = HUD_MODEL_ARMOR_GRAPH_TARGET.origin + (v_forward * CLIENT_target_ent.torC_compOffset_z) +
            (v_right * CLIENT_target_ent.torC_compOffset_x) + (v_up * CLIENT_target_ent.torC_compOffset_y);
        HUD_MODEL_ARMOR_GRAPH_TARGET.torC_org = cOrg;
        HUD_MODEL_ARMOR_GRAPH_TARGET.torC_angl_x = HUD_MODEL_ARMOR_GRAPH_TARGET.angles_x;
        HUD_MODEL_ARMOR_GRAPH_TARGET.torC_angl_y = anglemod(CLIENT_target_ent.torC_angl_y - tAngles_y);
        
        HUD_MODEL_ARMOR_GRAPH_TARGET.colormod = tColor * 2;
        setmodel(HUD_MODEL_ARMOR_GRAPH_TARGET, CLIENT_target_ent.torC_mdl);
        HUD_MODEL_ARMOR_GRAPH_TARGET.origin = HUD_MODEL_ARMOR_GRAPH_TARGET.torC_org;
        HUD_MODEL_ARMOR_GRAPH_TARGET.angles = HUD_MODEL_ARMOR_GRAPH_TARGET.torC_angl;
        addentity(HUD_MODEL_ARMOR_GRAPH_TARGET);
        HUD_MODEL_ARMOR_GRAPH_TARGET.angles = CLIENT_target_ent.angles;
        HUD_MODEL_ARMOR_GRAPH_TARGET.origin = viewOrg;
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
      HUD_MODEL_ARMOR_GRAPH_TARGET.mins = CLIENT_target_ent.cache_mins;
      HUD_MODEL_ARMOR_GRAPH_TARGET.maxs = CLIENT_target_ent.cache_maxs;
  }
  else{
    siz = gui_newAspectRatio(draw_getimagesize(HUD_VEC_TRG), siz * 0.9);
    meter = siz;
    meter_x = meter_x / 2;
    meter_y = meter_y / 2;
    meter = gui_calcAlignCustom(meter, (VIEW_LFT | VIEW_TOP), backOrg + (backSize * 0.5));
    drawpic(meter, HUD_VEC_TRG, siz, tColor, HUD_ALPHA, 0);
  }
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
  
  viewAngle = view_angles;
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
*/
float(vector orig, vector srcOrg, vector srcAngl) util_checkPointAngleImpl={
  
  local float targYaw;
  local float checkYaw;
  
  targYaw = vectoyaw( orig - srcOrg );
  checkYaw = anglemod( srcAngl_y - targYaw );
  
  return checkYaw;
};


vector(vector partOffset, vector rootOrg) hud_model_armor_part_frame={
  local vector offset;
  
  offset = rootOrg + (v_right * partOffset_x) + (v_up * partOffset_y) + (v_forward * partOffset_z);
  return offset;
};

/*
  receive_sendevent_player.qc - called when SENDFLAG_TARGET changes.
*/
void() hud_armor_model_target_cleanup={
  
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.netname)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.torC_mdl)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.torL_mdl)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.torR_mdl)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.armL_mdl)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.armR_mdl)
  freeGlobalString(HUD_MODEL_ARMOR_GRAPH_TARGET.legs_mdl)

};