/*
battleMETAL
Author: Peter Roohr
Date: 01/29/2018
mod: 9/15/2018
mod: 07/19/2019
Overview:
  Implementation of HUD functions.
*/

/*
  RENDER CROSSHAIRS - UNIVERSAL
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshairs={
  //convergence
  local vector spr_h, hitclr, lckclr;
  local vector acc_left, acc_right, acc_up, acc_dn;
  local vector drift;
  
  drift = gui_percentToPixelRaw( 8 * unitAccuracy, 8 * unitAccuracy );
  
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
void(vector pos, float algn) hud_renderPitchIndicator={
  local float pcur, perc, pmax, pmin;
  local vector ofs;
  
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  
  //divide by 0 protection
  pmax = min(HUD_PITCH_MAX * -1, -1);
  pmin = max(HUD_PITCH_MIN * -1, 1);

  pcur = input_angles_x;
  if( pcur == 0 ){
    pcur = 1;
  }
  if( pcur < 0 ){
    //min is up
    pcur = pcur * -1;
    perc = (pcur / pmin) * 100;
  }
  else{
    perc = (pcur / pmax) * 100;
  }
  
  ofs = gui_percentToPixelRawVec('2 13');
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_TOP), pos);
  gui_renderMeter(perc, ofs, gui_percentToPixelRawVec('4 26'), '-1 0 0', HUD_COLOR_DEF, HUD_ALPHA, 0, AXIS_V, 0);
  drawfill( (ofs - gui_percentToPixelRawVec('0 0') ), gui_percentToPixelRawVec('8 1'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfill( (ofs + gui_percentToPixelRawVec('0 52') ), gui_percentToPixelRawVec('8 1'), HUD_COLOR_DEF, HUD_ALPHA, 0);  
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
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawstring(pos, dist, '12 12', HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  drawfont = drawfont_prev;
};

/*
  RENDER NAV HEADING LETTER
*/
void(vector pos, float algn, vector angle) hud_renderNavHeading={
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawstring(pos, gui_angleToNav(angle_y), gui_percentToPixelRawVec('32 32'), HUD_COLOR_DEF, HUD_ALPHA + 0.15, 0);
  
  drawfont = drawfont_prev;
};

/*
  RENDER SHIELD METER
*/
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis, float isClient) hud_renderShield={
  local vector meterSize, label_org;
  local vector meterColor;
  
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
 
  meterColor = CLR_DEF_ARM_DED;
  if( isClient ){
    if( val <= 0 ){
      if( !HUD_SHIELD_FLASH_ON ){
        HUD_SHIELD_FLASH_ON = TRUE;
      }
    }
    else{
      HUD_SHIELD_FLASH_ON = FALSE;
      meterColor = CLR_DEF_ARM_DED;
    }
    
    if( HUD_SHIELD_FLASH_ON ){
      if( time > HUD_SHIELD_FLASH_TIME ){
        HUD_SHIELD_FLASH = HUD_SHIELD_FLASH * -1;
        HUD_SHIELD_FLASH_TIME = time + HUD_SHIELD_FLASH_RATE;
      }
      if( HUD_SHIELD_FLASH == 1){
        meterColor = CLR_DEF_RED;
      }
      else{
        meterColor = CLR_DEF_ARM_DED;
      }
    }
  }

  gui_renderMeter(val, pos, meterSize, meterColor, gui_getColorForShield(val), HUD_ALPHA, 0, meterAxis, 0);
  
  
  if(bool_label){
    label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, pos);
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      drawstring(label_org, "SHIELD", '8 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
    drawfont = drawfont_prev;
  }
};

/*
  RENDER ENERGY METER
*/
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis) hud_renderEnergy={
  local vector meterSize, label_org;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA, 0, meterAxis, 0);
  if(bool_label){
    label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, pos);
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      drawstring(label_org, "ENERGY", '8 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
    drawfont = drawfont_prev;
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
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    drawstring(label_org, label, '8 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfont = drawfont_prev; 
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
  local vector  map_size;
  local vector radarLineLeft, radarLineRight;
  local entity blip;

  RADAR_ORG = radarOrg;
  
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  RADAR_VSIZE = gui_percentToPixelRawVec(siz);
  RADAR_VORG = gui_percentToPixelRawVec(vorg);
  RADAR_VORG = gui_calcAlign(RADAR_VORG, algn);
  
  RADAR_VCENTER_x = RADAR_VORG_x + (RADAR_VSIZE_x / 2);
  RADAR_VCENTER_y = RADAR_VORG_y + (RADAR_VSIZE_y / 2);
  
  drawpic(RADAR_VCENTER - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  radarLineLeft_x = RADAR_VSIZE_x / 2.25;
  radarLineLeft_x = radarLineLeft_x * -1;
  radarLineLeft_y = RADAR_VSIZE_x / 2.25;
  radarLineLeft_y = radarLineLeft_y * -1;
  
  radarLineRight = radarLineLeft;
  radarLineRight_x = radarLineRight_x * -1;
  drawline(1, RADAR_VCENTER + gui_percentToPixelRawVec('-3 0'), RADAR_VCENTER + radarLineLeft, CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawline(1, RADAR_VCENTER + gui_percentToPixelRawVec('3 0'), RADAR_VCENTER + radarLineRight, CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  for( blip = findchainflags( flags, FL_UNIT ); blip != world; blip = blip.chain){
    if( blip.deadflag > DEAD_NO ){
      continue;
    }
    if( vlen(blip.origin - RADAR_ORG) > radarRange ){
      continue;
    }
    hud_renderRadarContact( blip, plrFaction, radarRange );
  }
  
  local entity nav;
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction ){
      continue;
    }
    if( nav.isActive == FALSE ){
      continue;
    }
    hud_renderRadarNav( nav.origin, nav.isActive, radarRange );
  }
};

/*
  RENDER SINGLE RADAR CONTACT
*/
void( entity blip, float plrFaction, float radRange) hud_renderRadarContact={
  local vector hudorg;
  local float ang, entAngle, entAngleRadian, radDist;

  radDist = vlen(blip.origin - RADAR_ORG) / radRange * 1.5;
  
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
        hud_RenderRadar_Building(hudorg, blip.vec_size, blip.faction, 0.85 );  
        break;
      case DATA_VEHC:
        hud_RenderRadar_Vehc(hudorg, blip.vec_size, blip.faction, 0.9);
        break;
      case DATA_MECH:
        hud_RenderRadar_Mech(hudorg, blip.vec_size, blip.faction, 1); 
        break;
      default:
        drawpic(hudorg - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0.67);
    }
  }
};

/*
  RENDER A NAV POINT PIP ON THE RADAR
*/
void( vector navOrg, float navState, float radRange ) hud_renderRadarNav={
  local vector hudorg, colr;
  local float ang, entAngle, entAngleRadian, radDist, draw;
  local float alph;

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
    alph = HUD_ALPHA;
    if( navState == 2 ){
      colr = CLR_DEF_TXT_NONSELECT;
      alph = 0.33;
    }
    drawpic(hudorg - gui_percentToPixelRawVec('3 3'), UI_DEF_NAVPOINT, gui_percentToPixelRawVec('10 10'), colr, alph, 0);
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
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  tsize = '10 10 0';
  stat = "- PASSIVE -";
  colr = CLR_DEF_ENG_DED;
  if(status){
    stat = "{ ACTIVE }";
    colr = CLR_DEF_ARM_HALF;
  }
  lbl_len_stat = stringwidth("[Mode]", 0, tsize);
  lbl_len_range = stringwidth("[Range]", 0, tsize);
  
  morg = torg;
  morg_x = morg_x + gui_percentXRaw(lbl_len_stat + 4);
  drawstring(torg, "[Mode]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + gui_percentToPixelRawVec('0 12');
  rdorg = radorg;
  rdorg_x = rdorg_x + gui_percentXRaw(lbl_len_range + 4);
  drawstring(radorg, "[Range]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag);
  drawstring(rdorg, ftos(radius), tsize, colr, HUD_ALPHA, flag);
  
  drawfont = drawfont_prev;
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
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  tsize = '10 10 0';
  stat = "- PASSIVE -";
  colr = CLR_DEF_ENG_DED;
  if(status){
    stat = "{ ACTIVE }";
    colr = CLR_DEF_ARM_HALF;
  }
  lbl_len_stat = stringwidth("[Mode]", 0, tsize);
  lbl_len_range = stringwidth("[Range]", 0, tsize);
  stat_len = stringwidth(stat, 0, tsize);
  rad_len = stringwidth(ftos(radius), 0, tsize);
  
  sorg = torg;
  sorg_x = sorg_x - gui_percentXRaw(lbl_len_stat / 2);
  morg = torg;
  morg_x = morg_x - gui_percentXRaw(stat_len / 2);
  morg_y = morg_y + gui_percentYRaw(12);
  drawstring(sorg, "[Mode]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + gui_percentToPixelRawVec('0 24');
  radorg_x = radorg_x - gui_percentXRaw(lbl_len_range / 2);
  rdorg = radorg;
  rdorg_x = rdorg_x + gui_percentXRaw(lbl_len_range / 2) - gui_percentXRaw(rad_len / 2);
  rdorg_y = rdorg_y + gui_percentYRaw(12);
  drawstring(radorg, "[Range]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag);
  drawstring(rdorg, ftos(radius), tsize, colr, HUD_ALPHA, flag);
  
  drawfont = drawfont_prev;
};


/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon over the Reload bar
*/
void(vector torg, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon={
  local vector iofs, ofs, metSize, wepState;
  
  data_get_client_item_( HUD_DATA_weapon, w_id );
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK; 
    }
    else{
      wepState = CLR_DEF_WHITE;  
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
    if( HUD_ENERGY_ACTUAL < HUD_DATA_weapon.energyRate ){
      wepState = CLR_DEF_WEP_LOWENG;
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }

  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), torg);
  
  if( HUD_DATA_weapon.icon != ""){
    drawpic(iofs, HUD_DATA_weapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState != CLR_DEF_TXT_CANTSELECT){
    ofs_x = imgSz_x / 2;
    ofs_y = (imgSz_y * 2) + gui_percentYRaw(2);
    metSize_x = imgSz_x;
    metSize_y = gui_percentYRaw(20);
    ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), torg); 
    gui_renderMeter(w_rel, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(w_rel), HUD_ALPHA, 0, AXIS_V, 0);
  }
  else{
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
  
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon is right to Reload Bar
*/
void(vector torg, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon2={
  local vector iofs, ofs, metSize, wepState;
  
  data_get_client_item_( HUD_DATA_weapon, w_id );
  
  torg = gui_percentToPixelRawVec(torg);
  torg = gui_calcAlign(torg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK; 
    }
    else{
      wepState = CLR_DEF_WHITE;  
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
    if( HUD_ENERGY_ACTUAL < HUD_DATA_weapon.energyRate ){
      wepState = CLR_DEF_WEP_LOWENG;
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }
  
  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), torg);
  if( HUD_DATA_weapon.icon != ""){
    drawpic(iofs, HUD_DATA_weapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState != CLR_DEF_TXT_CANTSELECT){
    ofs_x = imgSz_x / 2;
    ofs_y = imgSz_y;
    metSize_x = gui_percentXRaw(-20);
    metSize_y = imgSz_y;
    ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), torg); 
    gui_renderMeter(w_rel, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(w_rel), HUD_ALPHA, 0, AXIS_V, 0);
  }
  else{
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
};

/*
  RENDER A SHIELD METER IN 3d SPACE
*/
void(vector org, vector torg, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis) hud_renderShieldOverlay={
  local float dist;
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
      
      local vector meterSize, pos;
      local vector meterColor;
      
      meterSize = gui_percentToPixelRawVec(mSize);
      pos = gui_percentToPixelRawVec(nofs);
      pos = gui_calcAlign(pos, algn);
     
      meterColor = CLR_DEF_ARM_DED;
      gui_renderMeter(val, pos, aSize, meterColor, gui_getColorForShield(val), HUD_ALPHA, 0, AXIS_H, FALSE); 
    }
    cs_unproject(vpos);
  }
};

/*
  RENDER TARGET PIPS OVER AN ORIGIN IN 3D SPACE
*/
void(vector org, vector torg, float algn, float faction1, float faction2, float radRange) hud_renderTargetOverlay ={
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
  
  if(faction1 == faction2){
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
  
  if( imgSize_x > gui_percentXRaw(24) ){
    imgSize_x = gui_percentXRaw(24);
  }
  if(imgSize_x < gui_percentXRaw(10)){
    imgSize_x = gui_percentXRaw(10);
  }
  if( imgSize_y > gui_percentYRaw(24) ){
    imgSize_y = gui_percentYRaw(24);
  }
  if(imgSize_y < gui_percentYRaw(10)){
    imgSize_y = gui_percentYRaw(10);
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
void(vector post, float e_size, float e_fact, float e_alpha) hud_RenderRadar_Mech={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY;
  if(CLIENT_faction == e_fact){
    clr = CLR_DEF_IIF_FRIEND;
  }
  blipSize = e_size * '4 4 4';
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
};

/*
  RENDER A VEHICLE ICON ON THE RADAR
*/
void(vector post, float e_size, float e_fact, float e_alpha) hud_RenderRadar_Vehc={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY;
  if(CLIENT_faction == e_fact){
    clr = CLR_DEF_IIF_FRIEND;
  }
  blipSize = e_size * '4 4 4';
  
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_VEC, gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
};

/*
  RENDER A BUILDING ICON ON THE RADAR
*/
void(vector post,float e_size, float e_fact, float e_alpha) hud_RenderRadar_Building={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY_BLD;
  if(CLIENT_faction == e_fact){
    clr = CLR_DEF_IIF_FRIEND_BLD;
  }
  blipSize = (e_size * 0.75) * '4 4 4';
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_BLD,  gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
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
void(vector ofs, vector img_sz, string bimg, float valign, float setAlpha, vector tint) hud_HelmetImage={
  local vector nofs;
  
  nofs = gui_percentToPixelRawVec(ofs);
  nofs = gui_calcAlign(nofs, valign); 
  drawpic(nofs, bimg, gui_percentToPixelRawVec(img_sz), tint, setAlpha, DRAWFLAG_NORMAL);  
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
  RENDERS A LABEL 'TARGET' AND THE TARGET'S NAME
*/
void(vector ofs, string targType, float algn) hud_renderTargetName={
  local float msgLen;
  local vector tofs, msgSize, factionColor;
  local string msg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if(CLIENT_faction == CLIENT_target_faction){
    factionColor = CLR_DEF_IIF_FRIEND;
  }
  else{
    factionColor = CLR_DEF_IFF_ENEMY;
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

void() hud_renderRepairValue={
  local vector vorg, torg;
  local float len;
  local string str;
    
  if(CLIENT_repair_value > -1){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    str = "Repair Bay - current energy";
    len = stringwidth(str, 0, '14 14 0');
    vorg_x = VIEW_CTR_x - gui_percentXRaw(128);
    vorg_y = VIEW_CTR_y - gui_percentYRaw(64);
    torg = vorg;
    torg_x = VIEW_CTR_x - gui_percentXRaw( len / 2 ) ;
    torg_y = torg_y - gui_percentYRaw(16);
    gui_renderMeter(CLIENT_repair_value, vorg, gui_percentToPixelRawVec('256 24'), CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA + 0.33, 0, AXIS_H, 0);
    drawstring(torg, str, '14 14 0', HUD_COLOR_DEF, HUD_ALPHA + 0.33, 0);
    drawfont = drawfont_prev;
  }
};

void(float warnOn, float warnDir) hud_render_warningBounds={
  local vector warnPos;
  local vector warnArrowPos;
  local vector warnImgSize;
  local string warnMsg;
  local string warnImg;
  local float warnLen;
  local float guide;
  local float guideRad;
  local float warnArrow;
    
  if( time < HUD_WARN_MARK ){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_LIGHT;
    
    warnMsg = "[RETURN TO MISSION ZONE]";
    warnLen = stringwidth( warnMsg, 0, '12 12 0');
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
    
    drawstring(warnPos, warnMsg, '12 12 0', CLR_DEF_IFF_ENEMY, 0.9, 0);
    drawpic(warnArrowPos, warnImg, warnImgSize, CLR_DEF_IFF_ENEMY, 0.9, DRAWFLAG_NORMAL); 
    drawfont = drawfont_prev;
  }
};

/*
  RENDER
*/
void(float warnOn, vector orgCenter, float dmgTypes, float labelAlpha) hud_render_warningEnvironment={
  local string warnMessage;
  local string warnTypes;
  
  local float messageWidth;
  
  local vector warnBoxOrg;
  local vector warnBoxSize;
  
  local vector warnMessageOrg;
  local vector warnTypesOrg;
  
  if( time < HUD_WARN_ENV_MARK ){
    warnBoxSize = gui_percentToPixelRawVec('175 38');
    warnBoxOrg_x = orgCenter_x - warnBoxSize_x / 2;
    warnBoxOrg_y = orgCenter_y - gui_percentYRaw(2);
    drawpic( warnBoxOrg, UI_DEF_BOX_256, warnBoxSize, '0.25 0.25 0.25', 1, 0);
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
  
    warnMessage = "!- Environment Damage -!";
    messageWidth = stringwidth( warnMessage, 0, '18 18');
    warnMessageOrg_x = orgCenter_x - gui_percentXRaw( messageWidth / 2 );
    warnMessageOrg_y = orgCenter_y;
    drawstring( warnMessageOrg, warnMessage, '18 18', CLR_DEF_ARM_HALF, labelAlpha, 0 );
    
    warnTypes = "[";
    if( (dmgTypes & 1) ){
      warnTypes = strcat(warnTypes, " Shields ");
    }
    if( (dmgTypes & 2) ){
      warnTypes = strcat(warnTypes, " Armor ");
    }
    if( (dmgTypes & 4) ){
      warnTypes = strcat(warnTypes, " Energy ");
    }
    warnTypes = strcat(warnTypes, "]");
    messageWidth = stringwidth( warnTypes, 0, '16 16' );
    warnTypesOrg_x = orgCenter_x - gui_percentXRaw( messageWidth / 2 );
    warnTypesOrg_y = warnMessageOrg_y + gui_percentYRaw(20);
    drawstring( warnTypesOrg, warnTypes, '16 16', CLR_DEF_ARM_HALF, labelAlpha, 0 );
    
    drawfont = drawfont_prev;
  }
};

/*
  Renders HUD notification system messages, red text and dark gray background
*/
void() hud_render_info={
  
  if( HUD_INFO_ON == TRUE ){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
  
    drawpic( HUD_INFO_ORG, UI_DEF_BOX_512, HUD_INFO_SIZE, CLR_DEF_GRAY_H, 1, 0);
    gui_wrapText(HUD_INFO_ORG, HUD_INFO_SIZE, HUD_INFO_MSG, '14 14 0', CLR_DEF_TXT_GRAY_SMOOTH, 1) ;
    
    drawfont = drawfont_prev;
  }

  if( time > HUD_INFO_MARK ){
    HUD_INFO_ON = FALSE;
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

/*
  Renders Target's shield meter on the main HUD, using
  the data from the hud file.
*/
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
    hud_renderShield(porg, algn, CLIENT_target_shield, vsize, lflag, lalign, lblofs, axis, FALSE);
  }
};

/*
  Render HUD Message
    draws a HUD event message sent from the server.
*/
void(vector msgOrg, string messageVal, vector messageFont, float labelAlpha, float labelAlign) hud_render_message={
  local vector messageOrigin;
  local vector boxOrgin;
  local float width;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
 
  messageOrigin = gui_percentToPixelRawVec(msgOrg);
  
  width = stringwidth( messageVal, 0, messageFont);
  messageOrigin = gui_calcAlign(messageOrigin, labelAlign);
  messageOrigin_x = messageOrigin_x - gui_percentXRaw( width / 2 );
  
  boxOrgin_x = VIEW_CTR_x - gui_percentXRaw(128);
  boxOrgin_y = messageOrigin_y - gui_percentYRaw(4);
  drawpic( boxOrgin, UI_DEF_BOX_512, '256 24', '0.45 0.45 0.45', 1, 0);
  
  drawstring(messageOrigin, messageVal, messageFont, CLR_DEF_RED * 0.85, 1, 0);
    
  drawfont = drawfont_prev;
};

/*
  Called when server sends a TE_ event to highlight a portion of the Player's screen.
*/
void() hud_renderHighlight_frame={
  local entity boxes;
  boxes = findchainfloat( data_idx, -3 );
  while( boxes ){
    local entity rem;
    rem = boxes;
    boxes = boxes.chain;
    hud_renderHighlight( rem );
    if( time > rem.drawme ){
      remove( rem );
    }
  }
};

/*
  Highlights a chosen section of the player's HUD
*/
void( entity box ) hud_renderHighlight={
  local vector bx_pos, bx_sz;
  local float x,y;
  
  x = (0.1/100) * VIEW_MAX_x;
  y = (0.1/100) * VIEW_MAX_y;
  bx_pos_x = VIEW_ORG_x + ( VIEW_MAX_x * box.origin_x );
  bx_pos_y = VIEW_ORG_y + ( VIEW_MAX_y * box.origin_y );
  bx_sz_x = box.drawsize_x * VIEW_MAX_x;
  bx_sz_y = box.drawsize_y * VIEW_MAX_y;
  
  drawpic( bx_pos, UI_DEF_BOX_256_THICK, bx_sz, box.drawcolor1, 0.75, 0);
};

/*
  Renders the RAM-SHOCKS charge up meter and ram state for the player.
*/
void(vector ramOrg, vector ramSize, float ramValue, float ramAlign, float meterAxis, vector lbl_ofs, float lbl_algn) hud_render_ram={
  local vector meterSize, label_org, ramPos;
  local vector ramColor;
  local string ramLabel;
  
  meterSize = gui_percentToPixelRawVec(ramSize);
  ramPos = gui_percentToPixelRawVec(ramOrg);
  ramPos = gui_calcAlign(ramPos, ramAlign);
  
  if( CLIENT_player_state == PLAYER_SPRINT_ON ){
    ramLabel = "SPRINT";
    ramColor = gui_getColorForArmor(ramValue);
    if(ramValue > 100 ){
      ramValue = 100;
    }
  }
  else if( ramValue == 256 ){
    ramLabel = "RAM!";
    ramColor =  '0.9 0.1 0.1';
    ramValue = 100;
  }
  else if( ramValue == 255 ){
    ramLabel = "----";
    ramColor =  '0.15 0.15 0.15';
    ramValue = 100;
  }
  else{
    ramLabel = "READY";
    ramColor = HUD_COLOR_DEF;
    ramValue = 0;
  }
  
  gui_renderMeter(ramValue, ramPos, meterSize, HUD_COLOR_DEF - '0.5 0.5 0.5', ramColor, HUD_ALPHA, 0, meterAxis, 0);

  label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, ramPos);
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    drawstring(label_org, ramLabel, '8 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfont = drawfont_prev;

};


/*
  Render Sprint STATE
  
*/
void() hud_render_sprint={
  local float slen;
  local vector spos;
  local string msg;
  local vector msgClr;
  if(CLIENT_player_state == PLAYER_SPRINT_ON){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    if( cvar("cl_movespeedkey") > 1 ){
      msg = HUD_SPRINT_ON;
      msgClr = CLR_DEF_RET_GETLOCK;
      if( getstatf(STAT_RAM) >= getstatf(STAT_RAM_MAX) ){
        msg = HUD_SPRINT_RAM;
        msgClr = CLR_DEF_RED;
      }
    }
    else{
      msg = HUD_SPRINT_OFF;
      msgClr = CLR_DEF_RED;
    }
    slen = stringwidth(msg, 0, '16 14 0');
    slen = gui_percentXRaw(slen);
    spos_x = VIEW_CTR_x - slen / 2;
    spos_y = VIEW_CTR_y + gui_percentYRaw(56);
    drawstring(spos, msg, '16 14 0', msgClr, max(HUD_ALPHA + 0.33, 0.8), 0);
    drawfont_prev = drawfont;
  }
};


/*
  Main API call for new text-based HUD system
*/
void() data_hud_frame={
  local float uid;
  local float hasTarget;
  local float playerAccuracy;

  HUD_ENERGY_ACTUAL = (CLIENT_energy / 100) * UI_HANGAR_DATA_mech.energyMax;

  //Alpha fade-in of HUD as mech powers up.
  if( CLIENT_player_state == PLAYER_POWERUP_BEGIN ){
    if(HUD_ALPHA_TIME <= 0){
      HUD_ALPHA_TIME = time + UI_HANGAR_DATA_mech.startupDelay;
      HUD_ALPHA_RATE = cvar("cl_hud_alpha") * (0.01 / UI_HANGAR_DATA_mech.startupDelay);
      HUD_ALPHA = 0;
      HUD_ALPHA_INC = time + 0.01;
    }
  }
  if( HUD_ALPHA != cvar("cl_hud_alpha") ){
    if( time < HUD_ALPHA_TIME ){
      if( time > HUD_ALPHA_INC ){
        HUD_ALPHA = HUD_ALPHA + HUD_ALPHA_RATE;
        HUD_ALPHA_INC = time + 0.01;
      }
    }
    else{
      HUD_ALPHA = cvar("cl_hud_alpha");
    }
  }
  
  playerAccuracy = getstatf(STAT_ACCURACY);
  
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
  
  hud_renderNavOverlay();

  uid = 1;
  while( uid <= 32 ){
    local float objid, algn, lflag, lalign, axis, wbit;
    local vector porg, vsize, color1, lblofs;
    local string localIcon;
    local vector wep;
    
    objid = UI_DATA_UIDS[uid];
    switch( objid ){
      case HUD_UID_ENERGY:
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          vsize = UI_DATA_SIZE[uid];
          algn = UI_DATA_ALIGN[uid];
          lflag = UI_DATA_LABEL_FLAG[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          axis = UI_DATA_AXIS_FLAG[uid];
          hud_renderEnergy(porg, algn, CLIENT_energy, vsize, lflag, lalign, lblofs, axis);
        }
        break;
      case HUD_UID_ARM_PLAYER: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          hud_renderArmorGraph(porg, algn, CLIENT_health_center, CLIENT_health_torso_left, CLIENT_health_torso_right, CLIENT_health_arm_left, CLIENT_health_arm_right, CLIENT_health_legs);
        }
        break;
      case HUD_UID_SHIELD_PLAYER: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          vsize = UI_DATA_SIZE[uid];
          algn = UI_DATA_ALIGN[uid];
          lflag = UI_DATA_LABEL_FLAG[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          axis = UI_DATA_AXIS_FLAG[uid];
          hud_renderShield(porg, algn, CLIENT_shield, vsize, lflag, lalign, lblofs, axis, TRUE);
        }
        break;
      case HUD_UID_ARM_TARGET:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget ){
            if( CLIENT_target_datatype == DATA_MECH ){
              porg = UI_DATA_POS[uid];
              algn = UI_DATA_ALIGN[uid];
              hud_renderArmorGraph(porg, algn, CLIENT_stat_trg_ct_hp, CLIENT_stat_trg_lt_hp, CLIENT_stat_trg_rt_hp, CLIENT_stat_trg_la_hp, CLIENT_stat_trg_ra_hp, CLIENT_stat_trg_lg_hp);
            }
          }
        }
        break;
      case HUD_UID_SHIELD_TARGET: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          hud_data_renderTarget_Shield( uid, CLIENT_stat_trg_dataidx );
        }
        break;
      case HUD_UID_WEP_TYPE1:
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          wbit = UI_DATA_WEPBIT[uid];
          vsize = UI_DATA_SIZE[uid];
          if( vsize == '0 0 0' ){
            vsize = '32 32 0';  //default here
          }
          wep = hud_data_weapon_info( wbit );
          hud_renderWeapon(porg, vsize, algn, CLIENT_currentWeaponGroup, wep_x, wbit, wep_y);
        }
        break;
      case HUD_UID_WEP_TYPE2:  
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          wbit = UI_DATA_WEPBIT[uid];
          vsize = UI_DATA_SIZE[uid];
          if( vsize == '0 0 0' ){
            vsize = '32 32 0';  //default here
          }
          wep = hud_data_weapon_info( wbit );
          hud_renderWeapon2(porg, vsize, algn, CLIENT_currentWeaponGroup, wep_x, wbit, wep_y);
        }
        break;
      case HUD_UID_RADAR_TYPE1: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid]; 
          algn = UI_DATA_ALIGN[uid];  
          hud_renderRadarStatus1(porg, algn, CLIENT_stat_rdr_mode, CLIENT_radar_range, 0);
        }
        break;
      case HUD_UID_RADAR_TYPE2: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid]; 
          algn = UI_DATA_ALIGN[uid]; 
          hud_renderRadarStatus2(porg, algn, CLIENT_stat_rdr_mode, CLIENT_radar_range, 0);
        }
        break;
      case HUD_UID_RADAR_GRAPH: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid]; 
          algn = UI_DATA_ALIGN[uid];
          vsize = UI_DATA_SIZE[uid];
          hud_renderRadar(porg, algn, CLIENT_faction, pmove_org, CLIENT_radar_range, CLIENT_stat_rdr_mode, vsize);
        }
        break;
      case HUD_UID_NAV:      
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid];
        hud_renderNavHeading( porg, algn, input_angles);
        break;
      case HUD_UID_TARGET_NAME:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget){
            porg = UI_DATA_POS[uid]; 
            algn = UI_DATA_ALIGN[uid];
            hud_renderTargetName(porg, CLIENT_target_name, algn);
          }
        }
        break;
      case HUD_UID_TARGET_RANGE:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget ){
            porg = UI_DATA_POS[uid]; 
            algn = UI_DATA_ALIGN[uid];
            hud_renderTargetRange(porg, CLIENT_target_origin, pmove_org, algn);
          }
        }
        break;
      case HUD_UID_ARM_TARG_VEC:  
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget ){ 
            if( CLIENT_target_datatype == DATA_VEHC ){
              porg = UI_DATA_POS[uid];
              algn = UI_DATA_ALIGN[uid];
              vsize = UI_DATA_SIZE[uid];
              hud_renderArmorBuilding(porg, algn, vsize, CLIENT_stat_trg_ct_hp);
            }
          }
        }
        break;
      case HUD_UID_ARM_TARG_BLD:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget ){
            if( CLIENT_target_datatype == DATA_BLD ){
              porg = UI_DATA_POS[uid];
              algn = UI_DATA_ALIGN[uid];
              vsize = UI_DATA_SIZE[uid];
              hud_renderArmorBuilding(porg, algn, vsize, CLIENT_stat_trg_ct_hp);
            }
          }
        }
        break;
      case HUD_UID_MESSAGE_BOX:
        HUD_TXT_ORG = UI_DATA_POS[uid];
        HUD_TXT_SIZE = UI_DATA_SIZE[uid];
        HUD_TXT_ALIGN = UI_DATA_ALIGN[uid];
        break;
      case HUD_UID_ENVIRO_BOX:
        if( HUD_ZOOM_ACTIVE == FALSE){
          HUD_WARN_ENV_ORG = UI_DATA_POS[uid];
        }
        break;
      case HUD_UID_RAM_METER:
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          vsize = UI_DATA_SIZE[uid];
          algn = UI_DATA_ALIGN[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          axis = UI_DATA_AXIS_FLAG[uid];
          hud_render_ram(porg, vsize, getstatf(STAT_RAM_VALUE), algn, axis, lblofs, lalign);
        }
        break;
    }
    uid = uid + 1;
  }
  
  if( CLIENT_stat_trg_dataidx > 0 ){
    hud_renderTargetOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_faction, CLIENT_target_faction, CLIENT_radar_range);
    hud_renderShieldOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_target_shield, CLIENT_radar_range, CLIENT_target_vecsize, '64 6', AXIS_H);
  }  

  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(CLIENT_stat_hit_dirs);
  if( (CLIENT_flags & FL_NOSHOOT) ){
    hud_renderCrosshairDisabled();
  }
  else{
    hud_lock_frame();
    switch( cvar("crosshair") ){
      case 1:
        hud_renderCrosshair1( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        break;
      case 2:
        hud_renderCrosshair2( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        break;
      case 3:
        hud_renderCrosshair3( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        break;
      case 4:
        hud_renderCrosshair4( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        break;
      case 5:
        hud_renderCrosshair5( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        break;
      default:
        //no crosshair? bold move
        break;
    }
  }
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY) );
  hud_renderTargetDirection(CLIENT_stat_trg_face, CLIENT_faction, CLIENT_target_faction, CLIENT_target_datatype);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), CLIENT_stat_ret_dist) ;
  
  //ZOOM ACTIVE cleans up the HUD when the player is zooming in on an object by hiding
  //various elements that would get in the way.
  //these funcs can be moved out of this check as desired.
  if( !HUD_ZOOM_ACTIVE ){
    //repair sits above all
    hud_renderRepairValue();
    hud_render_warningBounds( HUD_WARN_ON, HUD_WARN_DIR );
    hud_render_warningEnvironment( HUD_WARN_ENV_ON, VIEW_CTR + gui_percentToPixelRawVec(HUD_WARN_ENV_ORG), HUD_WARN_ENV_TYPES, HUD_ALPHA + 0.25 );
    hud_event_frame();
    hud_render_sprint();
    hud_render_info();
  }
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

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  lbl = "!- FIRE CONTROL OVERRIDE -!";
  
  stopSize = gui_percentToPixelRawVec('24 24');
  stopOrg_x = VIEW_CTR_x - (stopSize_x / 2);
  stopOrg_y = VIEW_CTR_y - (stopSize_y / 2);

  lblSize = stringwidth(lbl, 0, '14 14 0');
  lblSize = gui_percentXRaw( lblSize );
  
  lblOrg_x = VIEW_CTR_x - (lblSize / 2);
  lblOrg_y = VIEW_CTR_y - gui_percentYRaw( 32 );
  
  drawpic(stopOrg, "gfx/hud/rad_bld.png", stopSize, CLR_DEF_RED, HUD_ALPHA - 0.15, DRAWFLAG_NORMAL);  
  
  drawstring(lblOrg, lbl, '14 14 0', CLR_DEF_RED,  HUD_ALPHA - 0.15, 0);
  drawfont = drawfont_prev;
};

/*
  received lock start event, setup controller
*/
void(float lockTime) hud_lock_control_start={
  HUD_LOCK_TIME_START = time;
  HUD_LOCK_TIME_END = time + lockTime;
  HUD_LOCK_STEP_RATE = lockTime / 100;
  
  HUD_LOCK_ALPHA = 0.01;
  
  HUD_LOCK_SIZE = 2;
  HUD_LOCK_ALPHA_RATE = 1 * (HUD_LOCK_STEP_RATE / lockTime);
  HUD_LOCK_SIZE_RATE = 1 * (HUD_LOCK_STEP_RATE / lockTime);
  HUD_LOCK_COLOR = CLR_DEF_RET_GETLOCK;
};

/*
  per-frame function for hud lock state.
*/ 
void() hud_lock_frame={
  //cases
    //1) started lock
    if( !(HUD_LOCK_STATE_PREV & (LOCK_TARG_START | LOCK_TARG_HAS)) ){
      if( (CLIENT_stat_lock_state & LOCK_TARG_START) ){
        hud_lock_control_start( MECH_DATA_LOCKON ); 
      }
    }
  //2) just acquired lock
  if( (CLIENT_stat_lock_state & LOCK_TARG_START) ){
    if( (time > HUD_LOCK_STEP) && (time < HUD_LOCK_TIME_END) ){
      HUD_LOCK_ALPHA = HUD_LOCK_ALPHA + HUD_LOCK_ALPHA_RATE;
      HUD_LOCK_SIZE = HUD_LOCK_SIZE - HUD_LOCK_SIZE_RATE;
      HUD_LOCK_STEP = time + HUD_LOCK_STEP_RATE;
    }
  }
  else if( (CLIENT_stat_lock_state & LOCK_TARG_HAS) && (HUD_LOCK_STATE_PREV & LOCK_TARG_START) ){
    HUD_LOCK_ALPHA = 1;
    HUD_LOCK_COLOR = CLR_DEF_RET_HASLOCK;
  }
  HUD_LOCK_STATE_PREV = CLIENT_stat_lock_state;
};

/*
  I have no regrets for these
  yes its a bespoke function for each crosshair style...because a generic system for
  crosshairs was egregious - ha.
*/
/*
  Crosshair Type 1
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair1={
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
  
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = gui_percentToPixelRaw( 8 * unitAccuracy, 8 * unitAccuracy );
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
    lockSize = gui_percentToPixelRawVec('34 34') * HUD_LOCK_SIZE;
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair1_lock.png", lockSize, HUD_LOCK_COLOR, HUD_LOCK_ALPHA, DRAWFLAG_NORMAL);
  }
}; 

/*
  Crosshair Type 2
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair2={
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
  
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = gui_percentToPixelRaw( 8 * unitAccuracy, 8 * unitAccuracy );
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
    lockSize = gui_percentToPixelRawVec('34 34') * HUD_LOCK_SIZE;
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair2_lock.png", lockSize, HUD_LOCK_COLOR, HUD_LOCK_ALPHA, DRAWFLAG_NORMAL);
  }
};

/*
  Crosshair Type 3
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair3={
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
  
  imgSize = gui_percentToPixelRawVec('28 28');
  pipSizeH = gui_percentToPixelRawVec('34 34');
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair3.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  //accuracy pips
  pipSizeH_x = pipSizeH_x * unitAccuracy;
  pipSizeH_y = pipSizeH_y * unitAccuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair3_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('36 36') * HUD_LOCK_SIZE;
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair3_lock.png", lockSize, HUD_LOCK_COLOR, HUD_LOCK_ALPHA, DRAWFLAG_NORMAL);
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
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair4={  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  
  imgSize = gui_percentToPixelRawVec('32 32');
  pipSizeH = gui_percentToPixelRawVec('34 34');
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  drawpic(imgCenter, "gfx/hud/ret/crosshair4.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  pipSizeH_x = pipSizeH_x * unitAccuracy;
  pipSizeH_y = pipSizeH_y * unitAccuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair4_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('36 36') * HUD_LOCK_SIZE;
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair4_lock.png", lockSize, HUD_LOCK_COLOR, HUD_LOCK_ALPHA, DRAWFLAG_NORMAL);
  }
};

/*
  Crosshair Type 5
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair5={

};