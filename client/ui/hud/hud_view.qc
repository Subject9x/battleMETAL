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
  local vector spr_h, hitclr;
  local vector acc_left, acc_right, acc_up, acc_dn;
  local vector drift;
  
  drift = Vector2( 8 * unitAccuracy, 8 * unitAccuracy );
  
  acc_left = VIEW_CTR - '11 1.5';
  acc_left_x = acc_left_x - drift_x;
  
  acc_right = VIEW_CTR + '1 -1.5';
  acc_right_x = acc_right_x + drift_x;
  
  acc_up = VIEW_CTR - '1.5 11';
  acc_up_y = acc_up_y - drift_y;
  
  acc_dn = VIEW_CTR + spr_h + '-1.5 1';
  acc_dn_y = acc_dn_y + drift_y;
  
  gui_renderTintImage(TRUE, acc_left, HUT_RET_PIP_HRZ, '10 3', HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, acc_right, HUT_RET_PIP_HRZ, '10 3', HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, acc_up, HUT_RET_PIP_VRT, '3 10', HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, acc_dn, HUT_RET_PIP_VRT, '3 10', HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  if( (hitdirection & STAT_HIT_TRG) ){
    hitclr = CLR_DEF_GRAY_H;
    if(trg_shield > 0){
      hitclr = CLR_DEF_SHD_HALF;
    }
    gui_renderTintImage(TRUE, (VIEW_CTR - '24 24'), HUD_RET_HIT, '48 48', hitclr, HUD_ALPHA, 0);
  }
  
  if( CLIENT_stat_lock_state ){
    if( CLIENT_stat_trg_dataidx > 0 && CLIENT_stat_trg_face == AIM_FACE_FRONT ){
      gui_renderTintImage(TRUE, VIEW_CTR - '16 16', HUT_RET_LOK, '32 32', CLR_DEF_RET_HASLOCK, HUD_ALPHA, 0);
    }
  }
};

/*
  RENDER TORSO PITCH INDICATOR
*/
void(vector pos, float algn) hud_renderPitchIndicator={
  local float pcur, perc, pmax, pmin;
  local vector ofs;
  
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
  
  ofs = '2 13';
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_TOP), pos);
  gui_renderMeter(perc, ofs, '4 26', '-1 0 0', HUD_COLOR_DEF, HUD_ALPHA, 0, AXIS_V, 0);
  drawfill( (ofs - '0 0' ), '8 1', HUD_COLOR_DEF, HUD_ALPHA, 0);
  drawfill( (ofs + '0 52' ), '8 1', HUD_COLOR_DEF, HUD_ALPHA, 0);  
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

  pos = gui_calcAlign(pos, algn);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawstring(pos, gui_angleToNav(angle_y), '32 32', HUD_COLOR_DEF, HUD_ALPHA + 0.15, 0);
  
  drawfont = drawfont_prev;
};

/*
  RENDER SHIELD METER
*/
void(vector pos, float algn, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, float isClient, vector mColor) hud_renderShield={
  local vector meterSize;
  local vector meterColor;
  local float scopeVal;
  local vector iconOrg;
  local vector iconSize;
  
  scopeVal = rint(val);
  
  meterSize = mSize;
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

  if( (meterAxis & AXIS_H) ){
    drawpic(pos, "gfx/hud/hud_meter_cover3.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize_x = meterSize_y;
    iconSize_y = meterSize_y;
  }
  else{
    drawpic(pos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize_x = meterSize_x;
    iconSize_y = meterSize_x;
  }
  
  iconOrg = gui_calcAlignCustom(lbl_ofs,lbl_algn, pos);
  drawpic(iconOrg, HUD_ICON_SHIELD, iconSize, mColor, HUD_ALPHA, 0);
};

/*
  RENDER ENERGY METER
*/
void(vector pos, float algn, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, vector mColor) hud_renderEnergy={
  local vector meterSize;
  local vector iconOrg;
  local vector iconSize;
  
  meterSize = mSize;
  pos = gui_calcAlign(pos, algn);
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA, 0, meterAxis, 0);
  
  if( (meterAxis & AXIS_H) ){
    drawpic(pos, "gfx/hud/hud_meter_cover3.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize_x = meterSize_y;
    iconSize_y = meterSize_y;
  }
  else{
    drawpic(pos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize_x = meterSize_x;
    iconSize_y = meterSize_x;
  }
  
  iconOrg = gui_calcAlignCustom(lbl_ofs,lbl_algn, pos);
  drawpic(iconOrg, HUD_ICON_POWER, iconSize, mColor, HUD_ALPHA, 0);
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
  morg_x = morg_x + lbl_len_stat + 4;
  drawstring(torg, "[Mode]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + '0 12';
  rdorg = radorg;
  rdorg_x = rdorg_x + lbl_len_range + 4;
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
  
  torg = pos;
  torg = gui_calcAlign(torg, algn);
  tsize = '10 10 0';
  colr = CLR_DEF_ARM_HALF;
  lbl_len = stringwidth("[Time]", 0, tsize);
  
  stat = ui_calculate_time_string( servertime - SV_PLAYERTIME );
  
  morg = torg;
  morg_x = morg_x + lbl_len + 4;
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
  sorg_x = sorg_x - (lbl_len_stat / 2);
  morg = torg;
  morg_x = morg_x - (stat_len / 2);
  morg_y = morg_y + 12;
  drawstring(sorg, "[Mode]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag); 
  drawstring(morg, stat, tsize, colr, HUD_ALPHA, flag);
  
  radorg = torg + '0 24';
  radorg_x = radorg_x - (lbl_len_range / 2);
  rdorg = radorg;
  rdorg_x = rdorg_x + (lbl_len_range / 2) - (rad_len / 2);
  rdorg_y = rdorg_y + 12;
  drawstring(radorg, "[Range]", tsize, HUD_COLOR_DEF, HUD_ALPHA, flag);
  drawstring(rdorg, ftos(radius), tsize, colr, HUD_ALPHA, flag);
  
  drawfont = drawfont_prev;
};


/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon over the Reload bar
*/
void(vector torg, vector imgSz, float algn, float w_bit) hud_renderWeapon={
  local entity theWeapon;
  local vector iofs, ofs, metSize, wepState;
  local vector rOrg;
  
  theWeapon = gui_get_weapon(w_bit);
  
  //data_get_client_item_( HUD_DATA_weapon, w_id );
  
  rOrg = torg;
  rOrg = gui_calcAlign(rOrg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    /*if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK;
    }
    else{
      wepState = CLR_DEF_WHITE;
    }*/
    
    wepState = '1 1 1';
    if( theWeapon.equipSize < MSC1 ){
      if(theWeapon.reloadValue < 100){
        //weapon reloading
        wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
      }
      if( HUD_ENERGY_ACTUAL < theWeapon.energyRate ){
        wepState = CLR_DEF_WEP_LOWENG;
      }
      if( CLIENT_stat_trg_dataidx != 0 && CLIENT_target_dist > theWeapon.w_range ){
        wepState = CLR_DEF_ARM_DED;
      }
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }
  
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), rOrg);
  
  if( theWeapon.icon != ""){
    drawpic(iofs, theWeapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState == CLR_DEF_TXT_CANTSELECT ){
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
  else{
    if( theWeapon.data_idx > 0 ){
      ofs_x = imgSz_x / 2;
      ofs_y = (imgSz_y * 2);
      metSize_x = imgSz_x;
      metSize_y = 20;
      ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), rOrg); 
      gui_renderMeter(theWeapon.reloadValue, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(theWeapon.reloadValue), HUD_ALPHA, 0, AXIS_V, 0);
    }
  }
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
  Weapon Icon is right to Reload Bar
*/
void(vector torg, vector imgSz, float algn, float w_bit) hud_renderWeapon2={
  local entity theWeapon;
  local vector rOrg;
  local vector iofs, ofs, metSize, wepState;
  
  theWeapon = gui_get_weapon(w_bit);
  
  rOrg = torg;
  rOrg = gui_calcAlign(torg, algn);
  
  if( (CLIENT_weapon_state & w_bit) ){
    //weapon selected
    /*if( (wepGrp & w_bit) ){
      wepState = CLR_DEF_ARM_OK; 
    }
    else{
      wepState = CLR_DEF_WHITE;  
    }*/
    wepState = '1 1 1';
    if( theWeapon.equipSize < MSC1 ){
      if(theWeapon.reloadValue < 100){
        //weapon reloading
        wepState = CLR_DEF_ARM_THREEQ - '0.5 0.5 0.5';
      }
      if( HUD_ENERGY_ACTUAL < theWeapon.energyRate ){
        wepState = CLR_DEF_WEP_LOWENG;
      }
      if( CLIENT_stat_trg_dataidx != 0 && CLIENT_target_dist > theWeapon.w_range ){
        wepState = CLR_DEF_ARM_DED;
      }
    }
  }
  else{
    wepState = CLR_DEF_TXT_CANTSELECT;
  }
  
  iofs_x = imgSz_x / 2;
  iofs_y = imgSz_y;
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), rOrg);
  if( theWeapon.icon != ""){
    drawpic(iofs, theWeapon.icon, imgSz, wepState, HUD_ALPHA, 0);
  }
  
  if( wepState == CLR_DEF_TXT_CANTSELECT){
    drawpic(iofs, HUD_RAD_PIP_BLD, imgSz, CLR_DEF_RED - '0.25 0 0', HUD_ALPHA - 0.25, 0);
  }
  else{
    if( theWeapon.data_idx > 0 ){
      ofs_x = imgSz_x * -0.2;
      ofs_y = imgSz_y;
      metSize_x = 16;
      metSize_y = imgSz_y;
      ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), rOrg); 
      gui_renderMeter(theWeapon.reloadValue, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(theWeapon.reloadValue), HUD_ALPHA, 0, AXIS_V, 0);
    }
  }
};

void() hud_renderRepairValue={
  local vector vorg, torg;
  local float len;
  local string str;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  str = "Repair Bay - current energy";
  len = stringwidth(str, 0, '14 14 0');
  vorg_x = VIEW_CTR_x - 128;
  vorg_y = VIEW_CTR_y - 64;
  torg = vorg;
  torg_x = VIEW_CTR_x - ( len / 2 ) ;
  torg_y = torg_y - 16;
  gui_renderMeter(CLIENT_repair_value, vorg, '256 24', CLR_DEF_ENG_DED, CLR_DEF_ENG_OK, HUD_ALPHA + 0.33, 0, AXIS_H, 0);
  
  drawpic(vorg, "gfx/hud/hud_meter_cover3.png", '256 24', '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
  drawstring(torg, str, '14 14 0', HUD_COLOR_DEF, HUD_ALPHA + 0.33, 0);
  drawfont = drawfont_prev;
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
    warnPos_x = UI_CTR_x - (warnLen / 2);
    warnPos_y = UI_CTR_y - 48;
    
    //angle check    
    guide = anglemod( 90 + (input_angles_y - warnDir) );
    guideRad = guide * DEG2RAD;
    warnArrowPos_x = cos(guideRad);
    warnArrowPos_y = sin(guideRad);
    warnArrowPos_x = UI_CTR_x - (warnArrowPos_x * 64);
    warnArrowPos_y = UI_CTR_y - (warnArrowPos_y * 64);
  
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
    warnImgSize =  warnImgSize * 0.5;
    
    warnArrowPos_x = warnArrowPos_x - warnImgSize_x / 2;
    warnArrowPos_y = warnArrowPos_y - warnImgSize_y / 2;
    
    drawstring(warnPos, warnMsg, '12 12 0', CLR_DEF_IFF_ENEMY, 0.9, 0);
    drawpic(warnArrowPos, warnImg, warnImgSize, CLR_DEF_IFF_ENEMY, 0.9, DRAWFLAG_NORMAL); 
    drawfont = drawfont_prev;
  }
};

/*
  RENDER ENVIRONMENT HAZARD 
*/
void(float warnOn, vector orgCenter, float dmgTypes, float labelAlpha) hud_render_warningEnvironment={
  local vector anchorOrg;
  local vector shockOrg;
  local vector radOrg;
  local vector quantOrg;
  
  if( time < HUD_WARN_ENV_MARK ){
    anchorOrg = orgCenter;
    
    if( (dmgTypes & 1) ){
      shockOrg = gui_calcAlignCustom('48 0', (VIEW_LFT | VIEW_TOP), anchorOrg);
      drawpic(shockOrg, HUD_HAZ_SHOCK, '32 32', CLR_DEF_IIF_FRIEND_BLD, 0.9, 0);
    }
    if( (dmgTypes & 2) ){
      radOrg = gui_calcAlignCustom('-16 0', (VIEW_CTX | VIEW_TOP), anchorOrg);
      drawpic(radOrg, HUD_HAZ_RAD, '32 32', CLR_DEF_ARM_THREEQ, 0.9, 0);
      
    }
    if( (dmgTypes & 4) ){
      quantOrg = gui_calcAlignCustom('48 0', (VIEW_RGT | VIEW_TOP), anchorOrg);
      drawpic(quantOrg, HUD_HAZ_QUANT, '32 32', CLR_HUD_PURPLE * 1.25, 0.9, 0);
    }
  }
  else{
    HUD_WARN_ENV_TYPES = 0;
  }
};

/*
  Renders HUD notification system messages, red text and dark gray background
*/
void() hud_render_info={
  local vector panelSize;
  
  panelSize_x = max(32, HUD_INFO_SIZE_x) - 16;
  panelSize_y = max(32, HUD_INFO_MSG_Y + 16);
  
  gui_renderPatch9_1_32(HUD_INFO_ORG, panelSize, CLR_DEF_GRAY_H, 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  HUD_INFO_MSG_Y = gui_wrapText(HUD_INFO_ORG + '8 8', HUD_INFO_SIZE - '16 16', HUD_INFO_MSG, '14 14', CLR_DEF_ARM_OK * 1.25, 1) ;
  
  drawfont = drawfont_prev;

  if( time > HUD_INFO_MARK ){
    HUD_INFO_ON = FALSE;
  }
};

/*
  Renders Target's shield meter on the main HUD, using
  the data from the hud file.
*/
void( float uid, float targetId ) hud_data_renderTarget_Shield={
  local float algn, lalign, axis;
  local vector porg, vsize, lblofs;
  
  porg = UI_DATA_POS[uid];
  vsize = UI_DATA_SIZE[uid];
  algn = UI_DATA_ALIGN[uid];
  lalign = UI_DATA_LABEL_ALIGN[uid];
  lblofs = UI_DATA_LABEL_OFS[uid];
  axis = UI_DATA_AXIS_FLAG[uid];
  hud_renderShield(porg, algn, CLIENT_target_shield, vsize, lalign, lblofs, axis, FALSE, CLR_DEF_ARM_HALF);
};

/*
  Render HUD Message
    draws a HUD event message originates from reading player state, which comes in from the server.
*/
void(vector msgOrg, string messageVal, vector messageFont, float labelAlpha, float labelAlign) hud_render_message={
  local vector messageOrigin;
  local vector boxOrgin;
  local float width;
  local float strWidth;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
 
  messageOrigin = msgOrg;
  
  strWidth = width = stringwidth( messageVal, 0, messageFont);
  
  width = rint(width / 16) * 16;
  
  boxOrgin_x = VIEW_CTR_x - (width/2);
  boxOrgin_y = messageOrigin_y;
  
  messageOrigin_x = boxOrgin_x + ( width / 2 ) - (strWidth / 2) + 8;
  messageOrigin_y = messageOrigin_y + 8;
  
  gui_renderPatch9_1_32(boxOrgin, Vector2(width, 32), '0.45 0.45 0.45', 1, 0);
  
  drawstring(messageOrigin, messageVal, messageFont, CLR_DEF_RED * 0.85, 1, 0);
    
  drawfont = drawfont_prev;
};

/*
  Called when server sends a TE_ event to highlight a portion of the Player's screen.
*/
void() hud_renderHighlight_frame={
  local entity boxes;
  local entity rem;
  
  boxes = findchain( classname, "UI_HIGHLIGHT" );
  while( boxes ){
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
      
      if(elmAlign != 0 ){
        elmOrg = gui_calcAlign(elmOrg, elmAlign);
      }
      if( elmSize != '0 0 0' ){
        boxSize = elmSize * 1.33;
      }
      else{
        boxSize_x = box.drawsize_x * VIEW_MAX_x;
        boxSize_y = box.drawsize_y * VIEW_MAX_y;
      }
      if(box.partTypeId == HUD_UID_ARM_PLAYER){
        elmOrg = elmOrg - (boxSize*0.5);
      }
      elmOrg_x = elmOrg_x - (boxSize_x*0.15);
      elmOrg_y = elmOrg_y - (boxSize_y*0.15);
      
      boxSize_x = max(32, boxSize_x);
      boxSize_y =  max(32, boxSize_y);
      gui_renderPatch9_1_32( elmOrg - '4 4', boxSize, box.drawcolor1, 0.85, 0);
    }

  }
  else{  
    if( box.origin != '0 0 0'){
      bx_pos_x = VIEW_ORG_x + ( VIEW_MAX_x * box.origin_x );
      bx_pos_y = VIEW_ORG_y + ( VIEW_MAX_y * box.origin_y );
      boxSize_x = max(32, box.drawsize_x * VIEW_MAX_x);
      boxSize_y = max(32, box.drawsize_y * VIEW_MAX_y);
      gui_renderPatch9_1_32( bx_pos, boxSize, box.drawcolor1, 0.85, 0);
    }
  }
};

/*
  Renders the RAM-SHOCKS charge up meter and ram state for the player.
*/
void(vector ramOrg, vector ramSize, float ramValue, float ramAlign, float meterAxis, vector lbl_ofs, float lbl_algn) hud_render_ram={
  local vector meterSize, ramPos;
  local vector ramColor;
  local vector iconOrg;
  local string ramIcon;
  local vector iconSize;
  
  meterSize = ramSize;
  ramPos = ramOrg;
  ramPos = gui_calcAlign(ramPos, ramAlign);

  if( CLIENT_move_state == MOVE_SPRINT ){
    ramColor = gui_getColorForArmor(ramValue);
    if(ramValue > 100 ){
      ramValue = 100;
    }
    ramIcon = HUD_ICON_SPRINT;
  }
  else if( CLIENT_move_state == MOVE_RAM_CHARGE ){
    ramColor =  '0.9 0.1 0.1';
    ramValue = 100;
    ramIcon = HUD_ICON_RAM;
  }
  else if(CLIENT_move_state == MOVE_RAM_COOL ){
    ramColor =  '0.15 0.15 0.15';
    ramValue = 100;
    ramIcon = "";
  }
  else{
    ramColor = HUD_COLOR_DEF;
    ramValue = 0;
    ramIcon = "";
  }
  
  gui_renderMeter(ramValue, ramPos, meterSize, HUD_COLOR_DEF - '0.5 0.5 0.5', ramColor, HUD_ALPHA, 0, meterAxis, 0);
  
  if(  (meterAxis & AXIS_H) ){
    drawpic(ramPos, "gfx/hud/hud_meter_cover3.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize = Vector2(meterSize_y, meterSize_y);
  }
  else{
    drawpic(ramPos, "gfx/hud/hud_meter_cover.png", meterSize, '1 1 1', max(HUD_ALPHA - 0.25, 0.1), 0);
    iconSize = Vector2(meterSize_x, meterSize_x);
  }
  if( ramIcon != "" ){
    iconOrg = gui_calcAlignCustom(lbl_ofs, lbl_algn, ramPos);
    drawpic(iconOrg, ramIcon, iconSize, CLR_DEF_WHITE, HUD_ALPHA, 0);
  }
};

/*
  Main API call for new text-based HUD system
*/
void() data_hud_frame={
  local entity player;

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
  
  data_hud_fps_cam();
  if( HUD_EXTERNAL_CAM_ACTIVE ){
    data_hud_external();
  }
  menu_chat_render_frame( Vector2(UI_MAX_x - 250, UI_ORG_y),'262 144',10);
  
  if( CLIENT_stat_trg_dataidx > 0 && CLIENT_stat_trg_face == AIM_FACE_FRONT){
    hud_renderTargetOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_faction, CLIENT_target_faction, CLIENT_radar_range);
    
    //func call optimization, adding shield-down filter, players are confused about a target's shield flashing red to indicate 'time-before-regen' delay.
    if( CLIENT_target_shield > 0.0 && CLIENT_target_shield <= 100.0){
      hud_renderShieldOverlay(CLIENT_target_origin, pmove_org, 0, CLIENT_target_shield, CLIENT_radar_range, CLIENT_target_vecsize, '64 6', AXIS_H, CLIENT_target_faction);
    }
  }

  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(CLIENT_stat_hit_dirs);
  if( (CLIENT_flags & FL_NOSHOOT) ){
    hud_renderCrosshairDisabled();
  }
  else{
    //hud_lock_frame();
    CLIENT_stat_lock_state = FALSE;
    if( HUD_LOCK_FLAG ){
      if( CLIENT_stat_trg_dataidx > 0 && CLIENT_stat_trg_face == AIM_FACE_FRONT ){
        CLIENT_stat_lock_state = TRUE;
      }
    }
    switch( cvar("crosshair") ){
      case 1:
        hud_renderCrosshair1( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, CLIENT_accuracy, CLIENT_target_shield );
        break;
      case 2:
        hud_renderCrosshair2( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, CLIENT_accuracy, CLIENT_target_shield );
        break;
      case 3:
        hud_renderCrosshair3( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, CLIENT_accuracy, CLIENT_target_shield );
        break;
      case 4:
        hud_renderCrosshair4( CLIENT_stat_hit_dirs, CLIENT_stat_lock_state, CLIENT_accuracy, CLIENT_target_shield );
        break;
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
    
    if(CLIENT_repair_value > 0){
      hud_renderRepairValue();
    }
    hud_render_warningBounds( HUD_WARN_ON, HUD_WARN_DIR );
    hud_render_warningEnvironment( HUD_WARN_ENV_ON, VIEW_CTR + HUD_WARN_ENV_ORG, HUD_WARN_ENV_TYPES, HUD_ALPHA + 0.25 );
    hud_event_frame();
    
    if( HUD_INFO_ON == TRUE ){
      hud_render_info();
    }
    
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
  for( player = findchainflags(flags, FL_CLIENT); player != world; player = player.chain){
    if( !(player.flags & FL_CLIENT) ){continue;}
    if( player.clientLocalId == player_localentnum ){continue;}
    if( player.data_type == DATA_POBS ){continue;}
    if( player.faction != CLIENT_faction ){continue;}
    if( player.faction == FACTION_ALL){continue;}
    if( player != CLIENT_target_ent ){
      if( vlen(player.origin - pmove_org) <= (CLIENT_radar_range * 0.3) ){
        hud_render_ally_names( player );
      }
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
      R_PolygonVertex('10 10', '0 0', '1 1 1', 1) ;
      R_PolygonVertex('10 100', '0 1', '1 1 1', 1) ;
      R_PolygonVertex('100 100', '1 1', '1 1 1', 1) ;
      
      
      R_PolygonVertex('100 100', '1 1', '1 1 1', 1) ;
      R_PolygonVertex('100 10', '1 0', '1 1 1', 1) ;
      R_PolygonVertex('10 10', '0 0', '1 1 1', 1) ;
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

  lbl = "!-OVERRIDE-!";
  
  stopSize = '24 24';
  stopOrg_x = VIEW_CTR_x - (stopSize_x / 2);
  stopOrg_y = VIEW_CTR_y - (stopSize_y / 2);

  lblSize = stringwidth(lbl, 0, '14 14 0');
  
  lblOrg_x = VIEW_CTR_x - (lblSize / 2);
  lblOrg_y = VIEW_CTR_y -  32;
  
  drawpic(stopOrg, "gfx/hud/rad_bld.png", stopSize, CLR_DEF_RED, HUD_ALPHA - 0.15, DRAWFLAG_NORMAL);  
  
  drawstring(lblOrg, lbl, '14 14 0', CLR_DEF_RED,  HUD_ALPHA - 0.15, 0);
  drawfont = drawfont_prev;
};

/*
  //2.0.0: DEPRECATED lock-on not timer-based anymore
  received lock start event, setup controller
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
*/
/*
  DEPRECATED - //2.0.0: lock-on not timer-based anymore
  per-frame function for hud lock state.
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
*/ 

void() data_hud_fps_cam={
  local float uid;
  local float hasTarget;
  local float objid, algn, lflag, lalign, axis, wbit;
  local vector porg, vsize, lblofs;
  local vector color2;
  
  hasTarget = FALSE;
  if( CLIENT_stat_trg_dataidx > 0 ){
    hasTarget = TRUE;
  }
  
  uid = 1;
  while( uid <= 32 ){
    
    objid = UI_DATA_UIDS[uid];
    switch( objid ){
      case HUD_UID_ENERGY:
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          vsize = UI_DATA_SIZE[uid];
          algn = UI_DATA_ALIGN[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          axis = UI_DATA_AXIS_FLAG[uid];
          hud_renderEnergy(porg, algn, CLIENT_energy, vsize, lalign, lblofs, axis, CLR_HUD_BLUE);
        }
        break;
      case HUD_UID_ARM_PLAYER: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          lflag = UI_DATA_LABEL_FLAG[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          color2 = UI_DATA_COLOR2[uid];
          hud_renderArmorGraph(porg, algn, lflag, lalign, lblofs, color2, FALSE);
        }
        break;
      case HUD_UID_SHIELD_PLAYER: 
        if( HUD_ZOOM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          vsize = UI_DATA_SIZE[uid];
          algn = UI_DATA_ALIGN[uid];
          lalign = UI_DATA_LABEL_ALIGN[uid];
          lblofs = UI_DATA_LABEL_OFS[uid];
          axis = UI_DATA_AXIS_FLAG[uid];
          hud_renderShield(porg, algn, CLIENT_shield, vsize, lalign, lblofs, axis, TRUE, CLR_DEF_ARM_OK);
        }
        break;
      case HUD_UID_ARM_TARGET:
        if( HUD_ZOOM_ACTIVE == FALSE){
          if( hasTarget ){
            if( CLIENT_target_datatype == DATA_MECH ){
              porg = UI_DATA_POS[uid];
              algn = UI_DATA_ALIGN[uid];
              lflag = UI_DATA_LABEL_FLAG[uid];
              lalign = UI_DATA_LABEL_ALIGN[uid];
              lblofs = UI_DATA_LABEL_OFS[uid];
              color2 = UI_DATA_COLOR2[uid];
              hud_renderArmorGraph(porg, algn, lflag, lalign, lblofs, color2, TRUE);
            }
          }
        }
        break;
      case HUD_UID_SHIELD_TARGET: 
        if( HUD_ZOOM_ACTIVE == FALSE && CLIENT_stat_trg_dataidx != 0){
          //func call optimization
          if( CLIENT_target_shield <= 100.0 && CLIENT_target_shield >= 0.0 ){
            hud_data_renderTarget_Shield( uid, CLIENT_stat_trg_dataidx );
          }
        }
        break;
      case HUD_UID_WEP_TYPE1:
        if( HUD_ZOOM_ACTIVE == FALSE && HUD_EXTERNAL_CAM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          wbit = UI_DATA_WEPBIT[uid];
          vsize = UI_DATA_SIZE[uid];
          if( !vsize || vsize == '0 0 0' ){
            vsize = '24 24';  //default here
          }
          hud_renderWeapon(porg, vsize, algn, wbit);
        }
        break;
      case HUD_UID_WEP_TYPE2:
        if( HUD_ZOOM_ACTIVE == FALSE && HUD_EXTERNAL_CAM_ACTIVE == FALSE){
          porg = UI_DATA_POS[uid];
          algn = UI_DATA_ALIGN[uid];
          wbit = UI_DATA_WEPBIT[uid];
          vsize = UI_DATA_SIZE[uid];
          if( !vsize || vsize == '0 0 0' ){
            vsize = '24 24 0';  //default here
          }
          hud_renderWeapon2(porg, vsize, algn, wbit);
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
              lflag = UI_DATA_LABEL_FLAG[uid];
              lalign = UI_DATA_LABEL_ALIGN[uid];
              lblofs = UI_DATA_LABEL_OFS[uid];
              color2 = UI_DATA_COLOR2[uid];
              hud_renderArmorVehicle(porg, algn, vsize, CLIENT_stat_trg_ct_hp, lflag, lalign, lblofs, color2);
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
              lflag = UI_DATA_LABEL_FLAG[uid];
              lalign = UI_DATA_LABEL_ALIGN[uid];
              lblofs = UI_DATA_LABEL_OFS[uid];
              color2 = UI_DATA_COLOR2[uid];
              hud_renderArmorBuilding(porg, algn, vsize, CLIENT_stat_trg_ct_hp, lflag, lalign,  lblofs, color2);
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