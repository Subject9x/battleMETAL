/*
mech Mod
Author: Peter Roohr
Date: 01/29/2018
mod: 9/15/2018
Overview: the implementation of the header file
*/

/*
  RENDER CROSSHAIRS - UNIVERSAL
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshairs={
  //convergence
  local vector spr_w, spr_h, hitclr, lckclr;
  local vector acc_left, acc_right, acc_up, acc_dn;
  local vector drift;
  
  drift = gui_percentToPixelRaw( 8 * accuracy, 8 * accuracy );
  
  acc_left = VIEW_CTR - gui_percentToPixelRawVec('11 1.5');
  acc_left_x = acc_left_x - drift_x;
  
  acc_right = VIEW_CTR + gui_percentToPixelRawVec('1 -1.5');
  acc_right_x = acc_right_x + drift_x;
  
  acc_up = VIEW_CTR - gui_percentToPixelRawVec('1.5 11');
  acc_up_y = acc_up_y - drift_y;
  
  acc_dn = VIEW_CTR + spr_h + gui_percentToPixelRawVec('-1.5 1');
  acc_dn_y = acc_dn_y + drift_y;
  
  gui_renderTintImage(TRUE, acc_left, HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, acc_right, HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, acc_up, HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, acc_dn, HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  if( (hitdirection & STAT_HIT_TRG) ){
    hitclr = CLR_DEF_GRAY_H;
    if(trg_shield > 0){
      hitclr = CLR_DEF_SHD_HALF;
    }
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('24 24')), HUD_RET_HIT, gui_percentToPixelRawVec('48 48'), hitclr, HUD_ALPHA, 0);
  }
  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lckclr = CLR_DEF_RET_GETLOCK;
    if( (lockval & LOCK_TARG_HAS) ){
      lckclr = CLR_DEF_RET_HASLOCK;
    }
    gui_renderTintImage(TRUE, VIEW_CTR - gui_percentToPixelRawVec('16 16'), HUT_RET_LOK, gui_percentToPixelRawVec('32 32'), lckclr, HUD_ALPHA, 0);
  }
};

/*
  RENDER DIRECTIONAL HIT INDICATORS
*/
void(float hitDirBit) hud_renderDirectionHit={
  local float l_fade; 
  if( (hitDirBit & STAT_HIT_LF) ){
    local vector lorg;
    lorg_x = VIEW_ORG_x + gui_percentXRaw(4);
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, lorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
  
  if( (hitDirBit & STAT_HIT_RT) ){
    local vector rorg;
    rorg_x = VIEW_MAX_x - gui_percentXRaw(18);
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, rorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
};

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
  RENDER TORSO PITCH INDICATOR
*/
void(vector pos, float algn, float pitchVal, float pitch_max, float pitch_min) hud_renderPitchIndicator={
  local float pcur, perc;
  local vector ofs;
  
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  
  pcur = pitchVal;
  if(pcur > -1){
    perc = (pcur / pitch_max) * 100;
  }
  else{
    pitch_min = pitch_min * -1;
    pcur = pcur *-1;
    perc = (pcur / pitch_min) * 100;
    perc = perc * -1;
  }
  ofs = gui_percentToPixelRawVec('2 13');
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_TOP), pos);
  gui_renderMeter(perc, ofs, gui_percentToPixelRawVec('4 26'), '-1 0 0', HUD_COLOR_DEF, HUD_ALPHA, 0, AXIS_V, 0);
  drawfill((ofs - gui_percentToPixelRawVec('0 0')), gui_percentToPixelRawVec('8 1'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfill((ofs + gui_percentToPixelRawVec('0 52')), gui_percentToPixelRawVec('8 1'), HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDER RETICLE DISTANCE INDICATOR
*/
void(vector pos, float algn, float val) hud_renderReticleRange={

  local string dist;
  local float len;
  dist = ftos(val);
  len = stringwidth(dist, 0, '8 8 0');
  len = len / 2;
  pos_x = pos_x + len;
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  
  drawstring(pos, dist, '8 8', HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDER NAV HEADING LETTER
*/
void(vector pos, float algn, vector angle) hud_renderNavHeading={
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  drawstring(pos, gui_angleToNav(angle_y), gui_percentToPixelRawVec('16 16'), HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDER SHIELD METER
*/
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis) hud_renderShield={
  local vector meterSize, label_org, shofs;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ARM_DED, gui_getColorForShield(val), HUD_ALPHA, 0, meterAxis, 0);
  if(bool_label){
    label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, pos); 
    drawstring(label_org, "SHIELD", '4 4 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  }
};

/*
  RENDER ENERGY METER
*/
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis) hud_renderEnergy={
  local vector meterSize, label_org, shofs;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA, 0, meterAxis, 0);
  if(bool_label){
    label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, pos); 
    drawstring(label_org, "ENERGY", '4 4 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  }
};

/*
  RENDER ARMOR METER
*/
void( vector pos, vector grpCtr, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, string label) hud_renderArmorMeter={
  local vector meterSize, label_org, shofs;
  
  shofs = grpCtr;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlignCustom(pos, (VIEW_CTX | VIEW_CTY), shofs);
  
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ARM_DED, gui_getColorForArmor(val), HUD_ALPHA, 0, meterAxis, 0);
  label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), (VIEW_LFT | VIEW_TOP), pos); 
  drawstring(label_org, label, '4 4 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDER ARMOR GRAPH STYLE 1
  used for mech targets
*/
void(vector vorg, float algn, float ct, float lt, float rt, float la, float ra, float lg) hud_renderArmorGraph={
  local vector pnl_ctr;
  pnl_ctr = gui_percentToPixelRawVec(vorg);
  pnl_ctr = gui_calcAlign(pnl_ctr, algn);
  
  hud_renderArmorMeter('-6 -27', pnl_ctr, ct, '12 55', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "CT");
  
  hud_renderArmorMeter('-22 -24', pnl_ctr, lt, '12 48', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "LT");
  
  hud_renderArmorMeter('-38 -18', pnl_ctr, la, '12 36', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "LA");
  
  hud_renderArmorMeter('10 -24', pnl_ctr, rt, '12 48', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "RT");
  
  hud_renderArmorMeter('26 -18', pnl_ctr, ra, '12 36', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "RA");
  
  hud_renderArmorMeter('-28 30', pnl_ctr, lg, '56 12', (VIEW_LFT | VIEW_CTY),'8 -1', AXIS_V, "LG");
};

/*
  RENDER ENTIRE RADAR PANEL
*/
void(vector vorg, float algn, float plrFaction, vector radarOrg, float radarRange, float radarMode, vector siz) hud_renderRadar={

  local vector  map_size, sweepvec;
  local entity blip;
  local float sweep, rad, nav;
  
  RADAR_ORG = radarOrg;
  
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  RADAR_VSIZE = gui_percentToPixelRawVec(siz);
  RADAR_VORG = gui_percentToPixelRawVec(vorg);
  RADAR_VORG = gui_calcAlign(RADAR_VORG, algn);
  
  RADAR_VCENTER_x = RADAR_VORG_x + (RADAR_VSIZE_x / 2);
  RADAR_VCENTER_y = RADAR_VORG_y + (RADAR_VSIZE_y / 2);
  
  drawpic(RADAR_VCENTER - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  blip = findchainfloat( data_idx, -2 );
  while( blip ){
    local entity kill;    
    blip.hardpoint_cnt = blip.hardpoint_cnt - blip.radar_time ;
    if( blip.hardpoint_cnt < 0 ){
      blip.hardpoint_cnt = 0;
    }
    hud_renderRadarContact( blip, plrFaction, radarRange );
    kill = blip;
    blip = blip.chain;
    if( time > kill.en_cur ){
      remove( kill );
    }
  }
  nav = 0;
  while( nav <= 21 ){
    local float navState;
    local vector navOrg;
    navState = NAVNAMES_ACTIVE[nav];
    navOrg = NAVNAMES_ORG[nav];
    if( navState > FALSE ){
      hud_renderRadarNav( navOrg, navState, radarRange );
    }
    nav = nav + 1;
  }
};

/*
  RENDER SINGLE RADAR CONTACT
*/
void( entity blip, float plrFaction, float radRange) hud_renderRadarContact={
  local vector hudorg;
  local float ang, entAngle, entAngleRadian, radDist;

  radDist = blip.radar_range / radRange * 1.5;
  
  ang = vectoyaw(blip.origin - RADAR_ORG);

  entAngle = anglemod( 90 + (input_angles_y - ang)); //go figure this works
  entAngleRadian = entAngle * DEG2RAD;
  hudorg_x = cos(entAngleRadian);
  hudorg_y = sin(entAngleRadian);
  hudorg_x = RADAR_VCENTER_x - (hudorg_x * ( RADAR_VSIZE_x * radDist));
  hudorg_y = RADAR_VCENTER_y - (hudorg_y * ( RADAR_VSIZE_y * radDist));

  local float draw;
  draw = TRUE;
  if( (hudorg_x < RADAR_VORG_x) || (hudorg_x > (RADAR_VORG_x + RADAR_VSIZE_x) ) ){
    draw = FALSE;
  }
  if( (hudorg_y < RADAR_VORG_y) || (hudorg_y > (RADAR_VORG_y + RADAR_VSIZE_y) ) ){
    draw = FALSE;
  }
  if( draw ){
    switch( blip.data_type ){
      case DATA_BLD:
        hud_RenderRadar_Building(hudorg, plrFaction, blip.i_faction, blip.hardpoint_cnt );  
        break;
      case DATA_VEHC:
        hud_RenderRadar_Vehc(hudorg, plrFaction, blip.i_faction, blip.hardpoint_cnt);
        break;
      case DATA_MECH:
        hud_RenderRadar_Mech(hudorg, plrFaction, blip.i_faction, blip.hardpoint_cnt); 
        break;
      default:
        drawpic(hudorg - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
    }
  }
};

/*
  RENDER A NAV POINT PIP ON THE RADAR
*/
void( vector navOrg, float navState, float radRange ) hud_renderRadarNav={
  local vector hudorg, colr;
  local float ang, entAngle, entAngleRadian, radDist, draw;

  radDist = vlen( navOrg - RADAR_ORG) / radRange * 1.5;
  
  ang = vectoyaw(navOrg - RADAR_ORG);

  entAngle = anglemod( 90 + (input_angles_y - ang)); //go figure this works
  entAngleRadian = entAngle * DEG2RAD;
  hudorg_x = cos(entAngleRadian);
  hudorg_y = sin(entAngleRadian);
  hudorg_x = RADAR_VCENTER_x - (hudorg_x * ( RADAR_VSIZE_x * radDist));
  hudorg_y = RADAR_VCENTER_y - (hudorg_y * ( RADAR_VSIZE_y * radDist));

  draw = TRUE;
  if( (hudorg_x < RADAR_VORG_x) || (hudorg_x > (RADAR_VORG_x + RADAR_VSIZE_x) ) ){
    draw = FALSE;
  }
  if( (hudorg_y < RADAR_VORG_y) || (hudorg_y > (RADAR_VORG_y + RADAR_VSIZE_y) ) ){
    draw = FALSE;
  }
  if( draw ){
    colr = CLR_DEF_ARM_OK;
    if( navState == 2 ){
      colr = CLR_DEF_TXT_NONSELECT;
    }
    drawpic(hudorg - gui_percentToPixelRawVec('3 3'), UI_DEF_NAVPOINT, gui_percentToPixelRawVec('10 10'), colr, HUD_ALPHA, 0);
  }
};
/*
  RENDER RADAR DATA
    draws radar status - ACTIVE OR PASSIVE
    draws radar range - range changes based on radius
    [MODE] <foo>
    [RADISU] <bar>
*/
void(vector torg, float algn, float status, float radius, float flag) hud_renderRadarStatus1={
  local float lbl_len_stat, lbl_len_range;
  local string stat;
  local vector tsize, colr, morg, radorg, rdorg;
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  tsize = '6 6 0';
  stat = "--PASSIVE--";
  colr = CLR_DEF_ENG_DED;
  if(status){
    stat = "((ACTIVE))";
    colr = CLR_DEF_ARM_HALF;
  }
  lbl_len_stat = stringwidth("[MODE]", 0, tsize);
  lbl_len_range = stringwidth("[RADIUS]", 0, tsize);
  
  morg = torg;
  morg_x = morg_x + gui_percentXRaw(lbl_len_stat + 4);
  drawstring(torg, "[MODE]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + gui_percentToPixelRawVec('0 12');
  rdorg = radorg;
  rdorg_x = rdorg_x + gui_percentXRaw(lbl_len_range + 4);
  drawstring(radorg, "[RADIUS]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag);
  drawstring(rdorg, ftos(radius), tsize, colr, HUD_ALPHA, flag);
};

/*
  RENDER RADAR DATA
    draws radar status - ACTIVE OR PASSIVE
    draws radar range - range changes based on radius
    [MODE] 
    <foo>
    [RADIUS] 
    <bar>
*/
void(vector torg, float algn, float status, float radius, float flag) hud_renderRadarStatus2={
  local float lbl_len_stat, lbl_len_range, stat_len, rad_len;
  local string stat;
  local vector tsize, colr, sorg, morg, radorg, rdorg;
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  tsize = '6 6 0';
  stat = "--PASSIVE--";
  colr = CLR_DEF_ENG_DED;
  if(status){
    stat = "((ACTIVE))";
    colr = CLR_DEF_ARM_HALF;
  }
  lbl_len_stat = stringwidth("[MODE]", 0, tsize);
  lbl_len_range = stringwidth("[RADIUS]", 0, tsize);
  stat_len = stringwidth(stat, 0, tsize);
  rad_len = stringwidth(ftos(radius), 0, tsize);
  
  sorg = torg;
  sorg_x = sorg_x - gui_percentXRaw(lbl_len_stat / 2);
  morg = torg;
  morg_x = morg_x - gui_percentXRaw(stat_len / 2);
  morg_y = morg_y + gui_percentYRaw(12);
  drawstring(sorg, "[MODE]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + gui_percentToPixelRawVec('0 24');
  radorg_x = radorg_x - gui_percentXRaw(lbl_len_range / 2);
  rdorg = radorg;
  rdorg_x = rdorg_x + gui_percentXRaw(lbl_len_range / 2) - gui_percentXRaw(rad_len / 2);
  rdorg_y = rdorg_y + gui_percentYRaw(12);
  drawstring(radorg, "[RADIUS]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag);
  drawstring(rdorg, ftos(radius), tsize, colr, HUD_ALPHA, flag);
};


/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon over the Reload bar
*/
void(vector torg, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon={
  local entity wep_dat;
  local vector iofs, ofs, metSize, wepState;
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  wepState = CLR_DEF_WHITE;
  if((wepGrp & w_bit)){
    //weapon selected
    wepState = CLR_DEF_ARM_OK;
  }
  if(w_rel < 100){
    //weapon reloading
    if((wepGrp & w_bit)){ 
      wepState = CLR_DEF_ARM_OK - '0.4 0.4 0.4';
    }
    else{
      wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
    }
  }
  
  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), torg);
  if( ITEM_DATA_ICONS[w_id] != ""){
    drawpic(iofs, ITEM_DATA_ICONS[w_id], imgSz, wepState, 1, 0);
  }
  
  ofs_x = imgSz_x / 2;
  ofs_y = (imgSz_y * 2) + gui_percentYRaw(2);
  metSize_x = imgSz_x;
  metSize_y = gui_percentYRaw(20);
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), torg); 
  gui_renderMeter(w_rel, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(w_rel), HUD_ALPHA, 0, AXIS_V, 0);
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon is right to Reload Bar
*/
void(vector torg, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon2={
  local entity wep_dat;
  local vector iofs, ofs, metSize, wepState;
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  wepState = CLR_DEF_WHITE;
  if( (wepGrp & w_bit) ){
    //weapon selected
    wepState = CLR_DEF_ARM_OK;
  }
  if(w_rel < 100){
    //weapon reloading
    if((wepGrp & w_bit)){ 
      wepState = CLR_DEF_ARM_OK - '0.4 0.4 0.4';
    }
    else{
      wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
    }
  }
  
  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), torg);
  if( ITEM_DATA_ICONS[w_id] != ""){
    drawpic(iofs, ITEM_DATA_ICONS[w_id], imgSz, wepState, 1, 0);
  }
  
  ofs_x = imgSz_x / 2;
  ofs_y = imgSz_y;
  metSize_x = gui_percentXRaw(-20);
  metSize_y = imgSz_y;
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), torg); 
  gui_renderMeter(w_rel, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(w_rel), HUD_ALPHA, 0, AXIS_V, 0);
};

/*
  RENDER A SHIELD METER IN 3d SPACE
*/
void(vector org, vector torg, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis) hud_renderShieldOverlay={
  local float height, dist;
  local vector vpos, nofs, aSize;
  if(val > 0){
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
      hud_renderShield(nofs, 0, val, aSize, FALSE, 0, '0 0', AXIS_H);
    }
  }
};

/*
  RENDER TARGET PIPS OVER AN ORIGIN IN 3D SPACE
*/
void(vector org, vector torg, float algn, float faction1, float faction2, float radRange) hud_renderTargetOverlay ={
  local float height, dist;
  local vector vpos, nofs, imgSize, aSize, factionColor;
    if(faction1 == faction2){
      factionColor = CLR_DEF_IIF_FRIEND;
    }
    else{
      factionColor = CLR_DEF_IFF_ENEMY;
    }
    dist = vlen(org - torg);
    dist = 1 - (dist / 1000);
    imgSize = draw_getimagesize(HUD_TARGET_BOX);
    imgSize = gui_percentToPixelRawVec(imgSize);
    imgSize = imgSize + gui_percentToPixelRawVec('50 50');

    aSize_x = imgSize_x * dist;
    if(aSize_x > imgSize_x){
      aSize_x = imgSize_x;
    }
    else if(aSize_x < gui_percentXRaw(32)){
      aSize_x = gui_percentXRaw(32);
    }
    
    aSize_y = imgSize_y * dist;
    if(aSize_y > imgSize_y){
      aSize_y = imgSize_y;
    }
    else if(aSize_y < gui_percentYRaw(32)){
      aSize_y = gui_percentYRaw(32);
    }
    
    vpos = org;
    vpos_z = vpos_z - CLIENT_target_vecsize;
    nofs = cs_project(vpos);
    if (nofs_z >= 0) {
      nofs_x = nofs_x - (aSize_x / 2);
      nofs_y = nofs_y - aSize_y;
      nofs_z = 0;
      gui_renderTintImage(TRUE, nofs, HUD_TARGET_BOX, aSize, factionColor, HUD_ALPHA, 0);
    }
};

/*
  RENDER A NAME OVER AN ORIGIN IN 3D SPACE
*/
void(vector pos, float algn, string name) hud_renderNameOverlay={

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
  RENDER A MECH ICON ON THE RADAR
*/
void(vector post, float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Mech={
  local vector clr;
  
  clr = CLR_DEF_IFF_ENEMY;
  if(plr_fact == e_fact){
    clr = CLR_DEF_IIF_FRIEND;
  }
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH,  gui_percentToPixelRawVec('6 6'), clr, e_alpha, 0);
};

/*
  RENDER A VEHICLE ICON ON THE RADAR
*/
void(vector post, float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Vehc={
  local vector clr;
  
  clr = CLR_DEF_IFF_ENEMY;
  if(plr_fact == e_fact){
    clr = CLR_DEF_IIF_FRIEND;
  }
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_VEC,  gui_percentToPixelRawVec('6 6'), clr, e_alpha, 0);
};

/*
  RENDER A BUILDING ICON ON THE RADAR
*/
void(vector post,float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Building={
  local vector clr;
  
  clr = CLR_DEF_IFF_ENEMY_BLD;
  if(plr_fact == e_fact){
    clr = CLR_DEF_IIF_FRIEND_BLD;
  }
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_BLD,  gui_percentToPixelRawVec('6 6'), clr, e_alpha, 0);
};

/*
  RENDER A NAV POINT ICON ON THE RADAR
*/
void(vector post, float isOn, vector fac_clr) hud_RenderRadar_Nav={
  if(isOn){
    drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_NAV,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
};

/*
  displays a background image on the hud
  always draws from bottom left of screen UP
*/
void(vector ofs, vector img_sz, string bimg, float valign, float alpha, vector tint) hud_HelmetImage={
  local vector nofs;
  
  nofs = gui_percentToPixelRawVec(ofs);
  nofs = gui_calcAlign(nofs, valign); 
  drawpic(nofs, bimg, gui_percentToPixelRawVec(img_sz), tint, alpha, DRAWFLAG_NORMAL);  
};

/*
  RENDERS A LABEL 'RANGE' AND DISTANCE TO ORIGIN
*/
void(vector ofs, vector torg, vector porg, float algn) hud_renderTargetRange={
  local float dist, msgLen;
  local vector tofs, msgSize;
  local string msg;
  ofs = gui_percentToPixelRawVec(ofs);
  ofs = gui_calcAlign(ofs, algn);
  dist = ceil(vlen(torg - porg));
  msg = strcat("[RANGE] ", ftos(dist));
  msgLen = stringwidth(msg, 0, '6 6 0');
  msgSize_x = gui_percentXRaw(msgLen/2);
  msgSize_y = gui_percentYRaw(6);
  tofs = gui_calcAlignCustom('0 0', (VIEW_LFT | VIEW_CTY), ofs);
  drawstring(tofs, msg, '6 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDERS A LABEL 'TARGET' AND THE TARGET'S NAME
*/
void(vector ofs, string targType, float algn) hud_renderTargetName={
  local float msgLen;
  local vector tofs, msgSize, factionColor;
  local string msg;
  
  factionColor = CLR_DEF_IFF_ENEMY;
  if(CLIENT_i_faction == CLIENT_target_faction){
    factionColor = CLR_DEF_IIF_FRIEND;
  }

  ofs = gui_percentToPixelRawVec(ofs);
  ofs = gui_calcAlign(ofs, algn);
  msg = strcat("[TARGET] ", targType);
  msgLen = stringwidth(msg, 0, '6 6 0');
  msgSize_x = gui_percentXRaw(msgLen/2);
  msgSize_y = gui_percentYRaw(6);
  tofs = gui_calcAlignCustom('0 0', (VIEW_LFT | VIEW_CTY), ofs);
  drawstring(tofs, msg, '6 6 0', factionColor, HUD_ALPHA, 0);
};

void(float delta) hud_renderRepairValue={
  local vector vorg, torg;
  local float len;
  local string str;
    
  if(delta > -1){
    str = "[Repair Bay - Current Total]";
    len = stringwidth(str, 0, '8 8 0');
    vorg = gui_percentToPixelRawVec('128 12');
    vorg = gui_calcAlign(vorg, (VIEW_CTX | VIEW_CTY));
    torg = vorg;
    torg_x = torg_x - gui_percentXRaw( len / 2 ) ;
    torg_y = torg_y - gui_percentYRaw(4);
    gui_renderMeter((delta * 100), vorg, gui_percentToPixelRawVec('256 24'), CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA, 0, AXIS_H, 0);
    drawstring(torg, str, '8 8 0', CLR_DEF_GRAY_H + '0.05 0.05 0.05', HUD_ALPHA, 0);
  }
};

void(float warnOn, float warnDir) hud_render_warningBounds={
  local vector warnPos;
  local vector warnClr;
  local vector warnArrowPos;
  local vector warnImgSize;
  local string warnMsg;
  local string warnImg;
  local float warnLen;
  local float guide;
  local float guideRad;
  local float warnArrow;
  
  if( time < HUD_WARN_MARK ){
    warnMsg = "[RETURN TO MISSION ZONE]";
    warnLen = stringwidth( warnMsg, 0, '9 11 0');
    warnLen = gui_percentXRaw( warnLen );
    warnPos_x = VIEW_CTR_x - (warnLen / 2);
    warnPos_y = VIEW_CTR_y - gui_percentYRaw(48);
    
    //angle check    
    guide = anglemod( 90 + (input_angles_y - warnDir) );
    guideRad = guide * DEG2RAD;
    warnArrowPos_x = cos(guideRad);
    warnArrowPos_y = sin(guideRad);
    warnArrowPos_x = VIEW_CTR_x - (warnArrowPos_x * 64);
    warnArrowPos_y = VIEW_CTR_y - (warnArrowPos_y * 64);
  
    warnArrow = gui_angleToEnum( anglemod(input_angles_y - warnDir) );
    switch( warnArrow ){
      default:
        warnImg = HUD_TRG_PIP_U;
        break;
      case 1:
        warnImg = HUD_TRG_PIP_R;
        break;
      case 2:
        warnImg = HUD_TRG_PIP_B;
        break;
      case 3:
        warnImg = HUD_TRG_PIP_L;
        break;
    }
    warnImgSize = draw_getimagesize(warnImg);
    warnImgSize = gui_percentToPixelRawVec( warnImgSize * 0.5);
    
    warnArrowPos_x = warnArrowPos_x - warnImgSize_x / 2;
    warnArrowPos_y = warnArrowPos_y - warnImgSize_y / 2;
    
    drawstring(warnPos, warnMsg, '9 11 0', CLR_DEF_IFF_ENEMY, 0.9, 0);
    drawpic(warnArrowPos, warnImg, warnImgSize, CLR_DEF_IFF_ENEMY, 0.9, DRAWFLAG_NORMAL); 
  }
};

vector( float wbit ) hud_data_weapon_info={
  local vector wep;
  switch( wbit ){
    case WEAPON1:
      wep_x = CLIENT_stat_w1_id;
      wep_y = CLIENT_stat_w1_rel;
      break;
    case WEAPON2:
      wep_x = CLIENT_stat_w2_id;
      wep_y = CLIENT_stat_w2_rel;
      break;
    case WEAPON3:
      wep_x = CLIENT_stat_w3_id;
      wep_y = CLIENT_stat_w3_rel;
      break;
    case WEAPON4:
      wep_x = CLIENT_stat_w4_id;
      wep_y = CLIENT_stat_w4_rel;
      break;
    case WEAPON5:
      wep_x = CLIENT_stat_w5_id;
      wep_y = CLIENT_stat_w5_rel;
      break;
    case WEAPON6:
      wep_x = CLIENT_stat_w6_id;
      wep_y = CLIENT_stat_w6_rel;
      break;
    case WEAPON7:
      wep_x = CLIENT_stat_w7_id;
      wep_y = CLIENT_stat_w7_rel;
      break;
    case WEAPON8:
      wep_x = CLIENT_stat_w8_id;
      wep_y = CLIENT_stat_w8_rel;
      break;
    case WEAPON9:
      wep_x = CLIENT_stat_w9_id;
      wep_y = CLIENT_stat_w9_rel;
      break;
  }
  return wep;
};

void( float uid, float targetId ) hud_data_renderTarget_Shield={
  local float algn, lflag, lalign, axis;
  local vector porg, vsize, lblofs;
  if( targetId > 0 ){
    porg = UI_DATA_POS[uid];
    vsize = UI_DATA_SIZE[uid];
    algn = UI_DATA_ALIGN[uid];
    lflag = UI_DATA_LABEL_FLAG[uid];
    lalign = UI_DATA_LABEL_ALIGN[uid];
    lblofs = UI_DATA_LABEL_OFS[uid];
    axis = UI_DATA_AXIS_FLAG[uid];
    hud_renderShield(porg, algn, CLIENT_target_shield, vsize, lflag, lalign, lblofs, axis);
  }
};

/*
  Main API call for new text-based HUD sys
*/
void() data_hud_frame={
  local float uid;
  local float hasTarget;
  local float accuracy;
  
  accuracy = getstatf(STAT_ACCURACY);
  
  switch( cvar("cl_hud_color") ){
    case 1:
      HUD_COLOR_DEF = CLR_HUD_GREEN;
      break;
    case 2:
      HUD_COLOR_DEF = CLR_HUD_ORANGE;
      break;
    case 3:
      HUD_COLOR_DEF = CLR_HUD_PURPLE;
      break;
    case 4:
      HUD_COLOR_DEF = CLR_HUD_BLUE;
      break;
    default:
      HUD_COLOR_DEF = CLR_HUD_WHITE;
      break;
  }
  
  hasTarget = FALSE;
  if( CLIENT_stat_trg_dataidx > 0 ){
    hasTarget = TRUE;
  }
  uid = 1;
  while( uid <= 32 ){
    local float objid, algn, lflag, lalign, axis, wbit;
    local vector porg, vsize, color1, color2, lblofs;
    local string icon, label;
    objid = UI_DATA_UIDS[uid];
    switch( objid ){
      case HUD_UID_IMG_HELM:
        porg = UI_DATA_POS[uid];
        vsize = UI_DATA_SIZE[uid];
        icon = UI_DATA_IMG[uid];
        algn = UI_DATA_ALIGN[uid];
        color1 = UI_DATA_COLOR1[uid];
        hud_HelmetImage(porg, vsize, icon, algn, 1, UI_DATA_COLOR1[uid]); 
        break;
      case HUD_UID_ENERGY:
        porg = UI_DATA_POS[uid];
        vsize = UI_DATA_SIZE[uid];
        algn = UI_DATA_ALIGN[uid];
        lflag = UI_DATA_LABEL_FLAG[uid];
        lalign = UI_DATA_LABEL_ALIGN[uid];
        lblofs = UI_DATA_LABEL_OFS[uid];
        axis = UI_DATA_AXIS_FLAG[uid];
        hud_renderEnergy(porg, algn, CLIENT_en_cur, vsize, lflag, lalign, lblofs, axis);
        break;
      case HUD_UID_ARM_PLAYER: 
        porg = UI_DATA_POS[uid];
        algn = UI_DATA_ALIGN[uid];
        hud_renderArmorGraph(porg, algn, CLIENT_hp_ctor, CLIENT_hp_stor, CLIENT_hp_stor2, CLIENT_hp_arm, CLIENT_hp_arm2, CLIENT_hp_leg);
        break;
      case HUD_UID_SHIELD_PLAYER: 
        porg = UI_DATA_POS[uid];
        vsize = UI_DATA_SIZE[uid];
        algn = UI_DATA_ALIGN[uid];
        lflag = UI_DATA_LABEL_FLAG[uid];
        lalign = UI_DATA_LABEL_ALIGN[uid];
        lblofs = UI_DATA_LABEL_OFS[uid];
        axis = UI_DATA_AXIS_FLAG[uid];
        hud_renderShield(porg, algn, CLIENT_sh_cur, vsize, lflag, lalign, lblofs, axis);
        break;
      case HUD_UID_ARM_TARGET:  
        if( hasTarget ){
          if( CLIENT_target_datatype == DATA_MECH ){
            porg = UI_DATA_POS[uid];
            algn = UI_DATA_ALIGN[uid];
            hud_renderArmorGraph(porg, algn, CLIENT_stat_trg_ct_hp, CLIENT_stat_trg_lt_hp, CLIENT_stat_trg_rt_hp, CLIENT_stat_trg_la_hp, CLIENT_stat_trg_ra_hp, CLIENT_stat_trg_lg_hp);
          }
        }
        break;
      case HUD_UID_SHIELD_TARGET: 
        hud_data_renderTarget_Shield( uid, CLIENT_stat_trg_dataidx );
        break;
      case HUD_UID_WEP_TYPE1:
        local vector wep;
        porg = UI_DATA_POS[uid];
        algn = UI_DATA_ALIGN[uid];
        wbit = UI_DATA_WEPBIT[uid];
        vsize = UI_DATA_SIZE[uid];
        if( vsize == '0 0 0' ){
          vsize = '32 32 0';  //default here
        }
        wep = hud_data_weapon_info( wbit );
        hud_renderWeapon(porg, vsize, algn, CLIENT_currentWeaponGroup, wep_x, WEAPON1, wep_y);
        break;
      case HUD_UID_WEP_TYPE2:    
        local vector wep;
        porg = UI_DATA_POS[uid];
        algn = UI_DATA_ALIGN[uid];
        wbit = UI_DATA_WEPBIT[uid];
        vsize = UI_DATA_SIZE[uid];
        if( vsize == '0 0 0' ){
          vsize = '32 32 0';  //default here
        }
        wep = hud_data_weapon_info( wbit );
        hud_renderWeapon2(porg, vsize, algn, CLIENT_currentWeaponGroup, wep_x, WEAPON1, wep_y);
        break;
      case HUD_UID_RADAR_TYPE1: 
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid];  
        hud_renderRadarStatus1(porg, algn, CLIENT_stat_rdr_mode, CLIENT_radar_range, 0);
        break;
      case HUD_UID_RADAR_TYPE2: 
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid]; 
        hud_renderRadarStatus2(porg, algn, CLIENT_stat_rdr_mode, CLIENT_radar_range, 0);
        break;
      case HUD_UID_RADAR_GRAPH: 
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid];
        vsize = UI_DATA_SIZE[uid];
        hud_renderRadar(porg, algn, CLIENT_i_faction, pmove_org, CLIENT_radar_range, CLIENT_stat_rdr_mode, vsize);
        break;
      case HUD_UID_NAV:      
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid];
        hud_renderNavHeading( porg, algn, input_angles);
        break;
      case HUD_UID_TARGET_NAME:
        if( hasTarget){
          porg = UI_DATA_POS[uid]; 
          algn = UI_DATA_ALIGN[uid];
          hud_renderTargetName(porg, CLIENT_w_icon, algn);
        }
        break;
      case HUD_UID_TARGET_RANGE:
        if( hasTarget ){
          porg = UI_DATA_POS[uid]; 
          algn = UI_DATA_ALIGN[uid];
          hud_renderTargetRange(porg, CLIENT_target_origin, pmove_org, algn);
        }
        break;
      case HUD_UID_ARM_TARG_VEC:  
        if( hasTarget ){ 
          if( CLIENT_target_datatype == DATA_VEHC ){
            porg = UI_DATA_POS[uid];
            algn = UI_DATA_ALIGN[uid];
            vsize = UI_DATA_SIZE[uid];
            hud_renderArmorBuilding(porg, algn, vsize, CLIENT_stat_trg_ct_hp);
          }
        }
        break;
      case HUD_UID_ARM_TARG_BLD:
        if( hasTarget ){
          if( CLIENT_target_datatype == DATA_BLD ){
            porg = UI_DATA_POS[uid];
            algn = UI_DATA_ALIGN[uid];
            vsize = UI_DATA_SIZE[uid];
            hud_renderArmorBuilding(porg, algn, vsize, CLIENT_stat_trg_ct_hp);
          }
        }
        break;
    }
    uid = uid + 1;
  }
  
  if( CLIENT_stat_trg_dataidx > 0 ){
    hud_renderTargetOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_i_faction, CLIENT_target_faction, CLIENT_radar_range);
    hud_renderShieldOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_target_shield, CLIENT_radar_range, CLIENT_target_vecsize, '64 6', AXIS_H);
  }  

  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(CLIENT_stat_hit_dirs);
  if( (CLIENT_flags & FL_NOSHOOT) ){
    //rad_bld.png
    hud_renderCrosshairDisabled();
  }
  else{
    switch( cvar("crosshair") ){
      case 1:
        hud_renderCrosshair1( CLIENT_stat_hit_dirs, CLIENT_stat_lck_stt, accuracy, CLIENT_target_shield );
        break;
      case 2:
        hud_renderCrosshair2( CLIENT_stat_hit_dirs, CLIENT_stat_lck_stt, accuracy, CLIENT_target_shield );
        break;
      case 3:
        hud_renderCrosshair3( CLIENT_stat_hit_dirs, CLIENT_stat_lck_stt, accuracy, CLIENT_target_shield );
        break;
      case 4:
        hud_renderCrosshair4( CLIENT_stat_hit_dirs, CLIENT_stat_lck_stt, accuracy, CLIENT_target_shield );
        break;
      case 5:
        hud_renderCrosshair5( CLIENT_stat_hit_dirs, CLIENT_stat_lck_stt, accuracy, CLIENT_target_shield );
        break;
      default:
        //no crosshair? bold move
        break;
    }
  }

  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x * -3, 270, -270);
  hud_renderTargetDirection(CLIENT_stat_trg_face, CLIENT_i_faction, CLIENT_target_faction, CLIENT_target_datatype);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), CLIENT_stat_ret_dist) ;
  
  //repair sits above all
  hud_renderRepairValue(getstatf(STAT_PLR_REP));
  
  hud_render_warningBounds( HUD_WARN_ON, HUD_WARN_DIR );
};

/*
  This is generally triggered by the player being given the FL_NOSHOOT flag from the server.
*/
void() hud_renderCrosshairDisabled={
  local vector stopOrg;
  local vector lblOrg;
  
  local vector stopSize;
  local float lblSize;
  
  local string lbl;
  
  lbl = "[FIRE CONTROL OVERRIDE]";
  
  stopSize = gui_percentToPixelRawVec('32 32');
  stopOrg_x = VIEW_CTR_x - (stopSize_x / 2);
  stopOrg_y = VIEW_CTR_y - (stopSize_y / 2);

  lblSize = stringwidth(lbl, 0, '8 8 0');
  lblSize = gui_percentXRaw( lblSize );
  
  lblOrg_x = VIEW_CTR_x - (lblSize / 2);
  lblOrg_y = VIEW_CTR_y - gui_percentYRaw( 40 );
  
  drawpic(stopOrg, "gfx/hud/rad_bld.png", stopSize, CLR_DEF_RED, 1, DRAWFLAG_NORMAL);  
  
  drawstring(lblOrg, lbl, '8 8 0', CLR_DEF_RED, 1, 0);
};

/*
  I have no regrets for these
  yes its a bespoke function for each crosshair style...because a generic system for
  crosshairs was egregious - ha.
*/
/*
  Crosshair Type 1
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshair1={
  local float lockAlpha;
  local vector lockColor;
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector pipSizeV;
  local vector drift;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector pipRight;
  local vector pipTop;
  local vector pipBottom;
  
  lockAlpha = HUD_ALPHA;
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = gui_percentToPixelRaw( 8 * accuracy, 8 * accuracy );
  imgSize = gui_percentToPixelRawVec('28 28');
  pipSizeH = gui_percentToPixelRawVec('8 3');
  pipSizeV = gui_percentToPixelRawVec('3 8');
  
  if( (hitdirection & STAT_HIT_TRG) ){
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
  }
  
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair1.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  

  //convergence
  pipLeft = VIEW_CTR - gui_percentToPixelRawVec('11 1.5');
  pipLeft_x = pipLeft_x - drift_x;
    
  pipRight = VIEW_CTR + gui_percentToPixelRawVec('3 -1.5');
  pipRight_x = pipRight_x + drift_x;
  
  pipTop = VIEW_CTR - gui_percentToPixelRawVec('1.5 11');
  pipTop_y = pipTop_y - drift_y;
  
  pipBottom = VIEW_CTR + gui_percentToPixelRawVec('-1.5 3');
  pipBottom_y = pipBottom_y + drift_y;
  
  drawpic(pipLeft, "gfx/hud/ret/crosshair1_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipRight, "gfx/hud/ret/crosshair1_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  
  drawpic(pipTop, "gfx/hud/ret/crosshair1_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipBottom, "gfx/hud/ret/crosshair1_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);

  //lock on indicators
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('34 34');
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    lockColor = CLR_DEF_RET_GETLOCK;
    lockAlpha = lockAlpha + 0.18;
    if( (lockval & LOCK_TARG_HAS) ){
      lockColor = CLR_DEF_RET_HASLOCK;
      lockAlpha = lockAlpha + 0.05;
    }
    if( lockAlpha > 1 ){
      lockAlpha = 1;
    }
    drawpic(lockCenter, "gfx/hud/ret/crosshair1_lock.png", lockSize, lockColor, lockAlpha, DRAWFLAG_NORMAL);
  }
}; 

/*
  Crosshair Type 2
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshair2={
  local float lockAlpha;
  local vector lockColor;
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector pipSizeV;
  local vector drift;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector pipRight;
  local vector pipTop;
  local vector pipBottom;
  
  lockAlpha = HUD_ALPHA;
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = gui_percentToPixelRaw( 8 * accuracy, 8 * accuracy );
  imgSize = gui_percentToPixelRawVec('28 28');
  pipSizeH = gui_percentToPixelRawVec('15 3');
  pipSizeV = gui_percentToPixelRawVec('3 15');
  
  if( (hitdirection & STAT_HIT_TRG) ){
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
  }
  
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair2.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  

  //convergence
  pipLeft = VIEW_CTR - gui_percentToPixelRawVec('17 1.5');
  pipLeft_x = pipLeft_x - drift_x;
    
  pipRight = VIEW_CTR + gui_percentToPixelRawVec('2 -1.5');
  pipRight_x = pipRight_x + drift_x;
  
  pipTop = VIEW_CTR - gui_percentToPixelRawVec('1.5 17');
  pipTop_y = pipTop_y - drift_y;
  
  pipBottom = VIEW_CTR + gui_percentToPixelRawVec('-1.5 2');
  pipBottom_y = pipBottom_y + drift_y;
  
  drawpic(pipLeft, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipRight, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  
  drawpic(pipTop, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipBottom, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);

  //lock on indicators
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('34 34');
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    lockColor = CLR_DEF_RET_GETLOCK;
    lockAlpha = lockAlpha + 0.18;
    if( (lockval & LOCK_TARG_HAS) ){
      lockColor = CLR_DEF_RET_HASLOCK;
      lockAlpha = lockAlpha + 0.05;
    }
    if( lockAlpha > 1 ){
      lockAlpha = 1;
    }
    drawpic(lockCenter, "gfx/hud/ret/crosshair2_lock.png", lockSize, lockColor, lockAlpha, DRAWFLAG_NORMAL);
  }
};

/*
  Crosshair Type 3
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshair3={
  local float lockAlpha;
  local vector lockColor;
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector hitSize;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector hitCenter;
  
  lockAlpha = HUD_ALPHA;
  
  imgSize = gui_percentToPixelRawVec('28 28');
  pipSizeH = gui_percentToPixelRawVec('34 34');
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair3.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  //accuracy pips
  pipSizeH_x = pipSizeH_x * accuracy;
  pipSizeH_y = pipSizeH_y * accuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair3_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('36 36');
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    lockColor = CLR_DEF_RET_GETLOCK;
    lockAlpha = lockAlpha + 0.18;
    if( (lockval & LOCK_TARG_HAS) ){
      lockColor = CLR_DEF_RET_HASLOCK;
      lockAlpha = lockAlpha + 0.05;
    }
    if( lockAlpha > 1 ){
      lockAlpha = 1;
    }
    drawpic(lockCenter, "gfx/hud/ret/crosshair3_lock.png", lockSize, lockColor, lockAlpha, DRAWFLAG_NORMAL);
  }
  
  if( (hitdirection & STAT_HIT_TRG) ){
    hitSize = gui_percentToPixelRawVec('27 27');
    hitCenter_x = VIEW_CTR_x - hitSize_x / 2;
    hitCenter_y = VIEW_CTR_y - hitSize_y / 2;
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
    drawpic(hitCenter, "gfx/hud/ret/crosshair3_hit.png", hitSize, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  }
};

/*
  Crosshair Type 4
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshair4={
  local float lockAlpha;
  local vector lockColor;
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector hitSize;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector hitCenter;
  
  lockAlpha = 0.65;
  
  imgSize = gui_percentToPixelRawVec('32 32');
  pipSizeH = gui_percentToPixelRawVec('34 34');
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair4.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  pipSizeH_x = pipSizeH_x * accuracy;
  pipSizeH_y = pipSizeH_y * accuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair4_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('36 36');
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    lockColor = CLR_DEF_RET_GETLOCK;
    lockAlpha = lockAlpha + 0.18;
    if( (lockval & LOCK_TARG_HAS) ){
      lockColor = CLR_DEF_RET_HASLOCK;
      lockAlpha = lockAlpha + 0.1;
    }
    if( lockAlpha > 1 ){
      lockAlpha = 1;
    }
    drawpic(lockCenter, "gfx/hud/ret/crosshair4_lock.png", lockSize, lockColor, lockAlpha, DRAWFLAG_NORMAL);
  }
};

/*
  Crosshair Type 5
*/
void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshair5={

};