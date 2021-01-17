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
  local float scopeVal;
  
  scopeVal = rint(val);
  
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
 
  meterColor = CLR_DEF_ARM_DED;
  if( isClient ){
    if( scopeVal <= 0 ){
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
  
  if( scopeVal > 100 ){
    //regen cooldown
    scopeVal = 100 - scopeVal;
    scopeVal = (scopeVal * -1);
    gui_renderMeter(scopeVal, pos, meterSize, meterColor, CLR_DEF_RED, HUD_ALPHA, 0, meterAxis, 0);
  }
  else{
    gui_renderMeter(scopeVal, pos, meterSize, meterColor, gui_getColorForShield(scopeVal), HUD_ALPHA, 0, meterAxis, 0);
  }

  if(  (meterAxis & AXIS_H) ){
    drawpic(pos, "gfx/hud/hud_meter_cover3.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  }
  else{
    drawpic(pos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  }
  
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
  drawpic(pos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
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
void( vector pos, vector grpCtr, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, string label, float thatTarget) hud_renderArmorMeter={
  local vector meterSize, label_org, shofs;
  
  local vector tColor;
  if( thatTarget ){
    if(CLIENT_target_faction == FACTION_ALL){
      tColor =  gui_getColorForArmorTarget(val);
    }
    else if(CLIENT_target_faction != CLIENT_faction){
      tColor =  gui_getColorForArmorTarget(val);
    }
    else{
      tColor =  gui_getColorForArmor(val);
    }
  }
  else{
    tColor =  gui_getColorForArmor(val);
  }
  
  shofs = grpCtr;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlignCustom(pos, (VIEW_CTX | VIEW_CTY), shofs);
  
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ARM_DED, tColor, HUD_ALPHA, 0, meterAxis, 0);
  
  drawpic(pos, "gfx/hud/hud_meter_cover2.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  
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
void(vector vorg, float algn, float ct, float lt, float rt, float la, float ra, float lg, float isTarget) hud_renderArmorGraph={
  local vector pnl_ctr;
  pnl_ctr = gui_percentToPixelRawVec(vorg);
  pnl_ctr = gui_calcAlign(pnl_ctr, algn);
  
  hud_renderArmorMeter('-6 -27', pnl_ctr, ct, '12 55', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "CT", isTarget);
  
  hud_renderArmorMeter('-22 -24', pnl_ctr, lt, '12 48', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "LT", isTarget);
  
  hud_renderArmorMeter('-38 -18', pnl_ctr, la, '12 36', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "LA", isTarget);
  
  hud_renderArmorMeter('10 -24', pnl_ctr, rt, '12 48', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "RT", isTarget);
  
  hud_renderArmorMeter('26 -18', pnl_ctr, ra, '12 36', (VIEW_CTX | VIEW_TOP),'-2 6', AXIS_V, "RA", isTarget);
  
  hud_renderArmorMeter('-28 30', pnl_ctr, lg, '56 12', (VIEW_LFT | VIEW_CTY),'8 -1', AXIS_V, "LG", isTarget);
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
  RENDER MISSION CLOCK
  shows the time elapsed since player got into their mech 
*/
void(vector pos, float algn, float flag) hud_render_missionClock={
  local float lbl_len;
  local string stat;
  local vector tsize, colr, morg, torg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  torg = gui_percentToPixelRawVec(pos);
  torg = gui_calcAlign(torg, algn);
  tsize = '10 10 0';
  colr = CLR_DEF_ARM_HALF;
  lbl_len = stringwidth("[Time]", 0, tsize);
  
  stat = ui_calculate_time_string( servertime - SV_PLAYERTIME );
  
  morg = torg;
  morg_x = morg_x + gui_percentXRaw(lbl_len + 4);
  drawstring(torg, "[Time]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
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
void(vector torg, vector imgSz, float algn, float wepGrp, float w_bit) hud_renderWeapon={
  local entity theWeapon;
  local vector iofs, ofs, metSize, wepState;
  local vector rOrg;
  
  theWeapon = gui_get_weapon(w_bit);
  
  //data_get_client_item_( HUD_DATA_weapon, w_id );
  
  rOrg = gui_percentToPixelRawVec(torg);
  rOrg = gui_calcAlign(rOrg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK; 
    }
    else{
      wepState = CLR_DEF_WHITE;  
    }
    
    if(theWeapon.reloadValue < 100){
      //weapon reloading
      if((wepGrp & w_bit)){ 
        wepState = CLR_DEF_ARM_OK - '0.4 0.4 0.4';
      }
      else{
        wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
      }
    }
    if( HUD_ENERGY_ACTUAL < theWeapon.energyRate ){
      wepState = CLR_DEF_WEP_LOWENG;
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }

  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), rOrg);
  
  if( theWeapon.icon != ""){
    drawpic(iofs, theWeapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState != CLR_DEF_TXT_CANTSELECT ){
    if( theWeapon.data_idx > 0 ){
      ofs_x = imgSz_x / 2;
      ofs_y = (imgSz_y * 2);
      metSize_x = imgSz_x;
      metSize_y = gui_percentYRaw(20);
      ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), rOrg); 
      gui_renderMeter(theWeapon.reloadValue, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(theWeapon.reloadValue), HUD_ALPHA, 0, AXIS_V, 0);
    }
  }
  else{
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon is right to Reload Bar
*/
void(vector torg, vector imgSz, float algn, float wepGrp, float w_bit) hud_renderWeapon2={
  local entity theWeapon;
  local vector rOrg;
  local vector iofs, ofs, metSize, wepState;
  
  theWeapon = gui_get_weapon(w_bit);
  
  rOrg = gui_percentToPixelRawVec(torg);
  rOrg = gui_calcAlign(torg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK; 
    }
    else{
      wepState = CLR_DEF_WHITE;  
    }
    
    if(theWeapon.reloadValue < 100){
      //weapon reloading
      if((wepGrp & w_bit)){ 
        wepState = CLR_DEF_ARM_OK - '0.4 0.4 0.4';
      }
      else{
        wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
      }
    }
    if( HUD_ENERGY_ACTUAL < theWeapon.energyRate ){
      wepState = CLR_DEF_WEP_LOWENG;
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }
  
  imgSz = gui_percentToPixelRawVec(imgSz);
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), rOrg);
  if( theWeapon.icon != ""){
    drawpic(iofs, theWeapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState != CLR_DEF_TXT_CANTSELECT){
    if( theWeapon.data_idx > 0 ){
      ofs_x = imgSz_x * -0.375;
      ofs_y = imgSz_y;
      metSize_x = gui_percentXRaw(20);
      metSize_y = imgSz_y;
      ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), rOrg); 
      gui_renderMeter(theWeapon.reloadValue, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(theWeapon.reloadValue), HUD_ALPHA, 0, AXIS_V, 0);
    }
  }
  else{
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
};

void() hud_renderRepairValue={
  local vector vorg, torg;
  local float len;
  local string str;
    
  if(CLIENT_repair_value > 0){
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
    
    drawpic(vorg, "gfx/hud/hud_meter_cover3.png", gui_percentToPixelRawVec('256 24'), '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
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
  else{
    HUD_WARN_ENV_TYPES = 0;
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
  local vector bx_pos, boxSize;
  local float x,y;
  local vector elmOrg, elmSize;
  local float elmAlign;
  
  x = (0.1/100) * VIEW_MAX_x;
  y = (0.1/100) * VIEW_MAX_y;
  
  if( box.partParentId != 0 ){
    elmOrg = UI_DATA_POS[box.partParentId];
    if(elmOrg != '0 0 0'){
      elmAlign = UI_DATA_ALIGN[box.partParentId];
      elmSize = UI_DATA_SIZE[box.partParentId];
      
      elmOrg = gui_percentToPixelRawVec(elmOrg);
      if(elmAlign != 0 ){
        elmOrg = gui_calcAlign(elmOrg, elmAlign);
      }
      if( elmSize != '0 0 0' ){
        boxSize = gui_percentToPixelRawVec(elmSize);
      }
      else{
        boxSize_x = box.drawsize_x * VIEW_MAX_x;
        boxSize_y = box.drawsize_y * VIEW_MAX_y;
      }
      if(box.partTypeId == HUD_UID_ARM_PLAYER){
        elmOrg = elmOrg - (boxSize*0.5);
      }
      drawpic( elmOrg, UI_DEF_BOX_256_THICK, boxSize, box.drawcolor1, 0.75, 0);
    }
  }
  else{  
    if( box.origin != '0 0 0'){
      bx_pos_x = VIEW_ORG_x + ( VIEW_MAX_x * box.origin_x );
      bx_pos_y = VIEW_ORG_y + ( VIEW_MAX_y * box.origin_y );
      boxSize_x = box.drawsize_x * VIEW_MAX_x;
      boxSize_y = box.drawsize_y * VIEW_MAX_y;
      drawpic( bx_pos, UI_DEF_BOX_256_THICK, boxSize, box.drawcolor1, 0.75, 0);
    }
  }
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
  
  if( ramValue > 0 ){
    ramLabel = "SPRINT";
    ramColor = gui_getColorForArmor(ramValue);
    if(ramValue > 100 ){
      ramValue = 100;
    }
  }
  else if( CLIENT_move_state == MOVE_RAM_CHARGE ){
    ramLabel = "RAM!";
    ramColor =  '0.9 0.1 0.1';
    ramValue = 100;
  }
  else if(CLIENT_move_state == MOVE_RAM_COOL ){
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
  
  if(  (meterAxis & AXIS_H) ){
    drawpic(ramPos, "gfx/hud/hud_meter_cover3.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  }
  else{
    drawpic(ramPos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  }
  

  label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), lbl_algn, ramPos);
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    drawstring(label_org, ramLabel, '8 6 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfont = drawfont_prev;

};


/*
  Render Sprint STATE
  
*/
void(vector porg) hud_render_sprint={
  local float slen;
  local vector spos;
  local string msg;
  local vector msgClr;
  
  if(CLIENT_move_state > MOVE_NORM){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    if( cvar("cl_movespeedkey") > 1 ){
      msg = HUD_SPRINT_ON;
      msgClr = CLR_DEF_RET_GETLOCK;
      if( getstatf(STAT_RAM) >= CLIENT_ram_max ){
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
    spos_x = porg_x - slen / 2;
    spos_y = porg_y + gui_percentYRaw(56);
    drawstring(spos, msg, '16 14 0', msgClr, max(HUD_ALPHA + 0.33, 0.8), 0);
    drawfont_prev = drawfont;
  }
};


/*
  Main API call for new text-based HUD system
*/
void() data_hud_frame={
  local float playerAccuracy;

  HUD_ENERGY_ACTUAL = CLIENT_energy_total;

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
  
  if( HUD_EXTERNAL_CAM_ACTIVE ){
    data_hud_external_cam_frame();
  }
  else{
    data_hud_fps_cam();
  }
  
  if( CLIENT_stat_trg_dataidx > 0 && CLIENT_stat_trg_face != AIM_FACE_FRONT){
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
      //case 5:
        //hud_renderCrosshair5( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, playerAccuracy, CLIENT_target_shield );
        //break;
      default:
        //no crosshair? bold move
        break;
    }
  }

  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY) );
  if( CLIENT_target_ent != world ){
    hud_renderTargetDirection(CLIENT_stat_trg_face, CLIENT_faction, CLIENT_target_faction, CLIENT_target_datatype);
  }
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), CLIENT_stat_ret_dist) ;
  
  //ZOOM ACTIVE cleans up the HUD when the player is zooming in on an object by hiding
  //various elements that would get in the way.
  //these funcs can be moved out of this check as desired.
  if( !HUD_ZOOM_ACTIVE ){
    //repair sits above all
    hud_render_vip_overlay();
    hud_renderRepairValue();
    hud_render_warningBounds( HUD_WARN_ON, HUD_WARN_DIR );
    hud_render_warningEnvironment( HUD_WARN_ENV_ON, VIEW_CTR + gui_percentToPixelRawVec(HUD_WARN_ENV_ORG), HUD_WARN_ENV_TYPES, HUD_ALPHA + 0.25 );
    hud_event_frame();
    if( HUD_EXTERNAL_CAM_ACTIVE == FALSE ){
      hud_render_sprint(VIEW_CTR);
    }
    hud_render_info();
  }
  
  if( HUD_TACMAP_ON ){
    hud_render_tactical_map();
  }
  if( HUD_SCORES_ON ){
    hud_render_scoreboard();
  }
  if( HUD_TACMAP_ON || HUD_SCORES_ON ){
    hud_renderNavOverlay();
    //only loop clients once per hud frame
  }
  local entity player;
  for( player = findchainflags(flags, FL_CLIENT); player != world; player = player.chain){
    if( !(player.flags & FL_CLIENT) ){continue;}
    if( player.clientLocalId == player_localentnum ){continue;}
    if( player.data_type == DATA_POBS ){continue;}
    if( player.faction != CLIENT_faction ){continue;}
    if( player.faction == FACTION_ALL){continue;}
    if( player != CLIENT_target_ent ){
      hud_render_ally_names( player );
    }
    
    if( player.targetEntId <= 0 ){continue;}
    if( player.enemy.deadflag != DEAD_NO ){continue;}
    hud_renderTargetOverlay_Ally(pmove_org, player.enemy, 0, CLIENT_faction, CLIENT_radar_range);
  }
  
  /*
    test doesnt really work
    void(string texturename, float flag[, float is2d, float lines]) R_BeginPolygon = #306;
    void(string texturename, float flag, ...) R_BeginPolygon = #306;
    void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307;
    void() R_EndPolygon = #308;
    R_BeginPolygon("q3mdl/mechs/matok/hud/matok_hud.tga", DRAWFLAG_2XMODULATE, 0);
      R_PolygonVertex(gui_percentToPixelRawVec('10 10'), '0 0', '1 1 1', 1) ;
      R_PolygonVertex(gui_percentToPixelRawVec('10 100'), '0 1', '1 1 1', 1) ;
      R_PolygonVertex(gui_percentToPixelRawVec('100 100'), '1 1', '1 1 1', 1) ;
      
      
      R_PolygonVertex(gui_percentToPixelRawVec('100 100'), '1 1', '1 1 1', 1) ;
      R_PolygonVertex(gui_percentToPixelRawVec('100 10'), '1 0', '1 1 1', 1) ;
      R_PolygonVertex(gui_percentToPixelRawVec('10 10'), '0 0', '1 1 1', 1) ;
    R_EndPolygon();
  */
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
  
  HUD_LOCK_SIZE = 1;
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
      HUD_LOCK_ALPHA = HUD_LOCK_ALPHA + HUD_LOCK_ALPHA_RATE * 0.4;
      HUD_LOCK_SIZE = HUD_LOCK_SIZE - HUD_LOCK_SIZE_RATE;
      HUD_LOCK_STEP = time + HUD_LOCK_STEP_RATE;
    }
  }
  else if( (CLIENT_stat_lock_state & LOCK_TARG_HAS) && (HUD_LOCK_STATE_PREV & LOCK_TARG_START) ){
    HUD_LOCK_ALPHA = 0.4;
    HUD_LOCK_COLOR = CLR_DEF_RET_HASLOCK;
  }
  HUD_LOCK_STATE_PREV = CLIENT_stat_lock_state;
};

void() data_hud_fps_cam={
  local float uid;
  local float hasTarget;
  
  hasTarget = FALSE;
  if( CLIENT_stat_trg_dataidx > 0 ){
    hasTarget = TRUE;
  }
  
  uid = 1;
  while( uid <= 32 ){
    local float objid, algn, lflag, lalign, axis, wbit;
    local vector porg, vsize, lblofs;
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
          hud_renderArmorGraph(porg, algn, CLIENT_health_center, CLIENT_health_torso_left, CLIENT_health_torso_right, CLIENT_health_arm_left, CLIENT_health_arm_right, CLIENT_health_legs, FALSE);
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
              hud_renderArmorGraph(porg, algn, CLIENT_stat_trg_ct_hp, CLIENT_stat_trg_lt_hp, CLIENT_stat_trg_rt_hp, CLIENT_stat_trg_la_hp, CLIENT_stat_trg_ra_hp, CLIENT_stat_trg_lg_hp, TRUE);
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
          hud_renderWeapon(porg, vsize, algn, CLIENT_currentWeaponGroup, wbit);
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
          hud_renderWeapon2(porg, vsize, algn, CLIENT_currentWeaponGroup, wbit);
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
      /*case HUD_UID_NAV:      
        porg = UI_DATA_POS[uid]; 
        algn = UI_DATA_ALIGN[uid];
        hud_renderNavHeading( porg, algn, input_angles);
        break;*/
      case HUD_UID_TARGET_NAME:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget){
            porg = UI_DATA_POS[uid]; 
            algn = UI_DATA_ALIGN[uid];
            hud_renderTargetName(porg, algn);
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
          hud_render_ram(porg, vsize, getstatf(STAT_RAM_VALUE) * 100, algn, axis, lblofs, lalign);
        }
        break;
      case HUD_UID_MSN_CLOCK:
        porg = UI_DATA_POS[uid];
        algn = UI_DATA_ALIGN[uid];
        hud_render_missionClock( porg, algn, 0);
        break;
    }
    uid = uid + 1;
  }
};