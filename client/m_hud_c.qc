/*
mech Mod
Author: Peter Roohr
Date: 01/29/2018
Overview: the implementation of the header file
*/

/*
  RENDER CROSSHAIRS - UNIVERSAL
*/
void(float hitdirection, float lockval, float conv_x, float conv_y) hud_renderCrosshairs={
  //convergence
  local vector spr_w, spr_h;
  spr_w_x = conv_x;
  spr_w_y = 0;
  spr_h_y = conv_y;
  spr_h_x = 0;
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(11, 1.5) - spr_w), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_w + gui_percentToPixelRaw(1 ,-1.5)), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(1.5, 11) - spr_h), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_h + gui_percentToPixelRaw(-1.5, 1)), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), HUD_COLOR_DEF, HUD_ALPHA, 0);
  
  if((hitdirection & STAT_HIT_TRG)){
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(24,24)), HUD_RET_HIT, gui_percentToPixelRawVec('48 48'), CLR_DEF_ARM_DED, HUD_ALPHA, 0);
  }
};

/*
  RENDER DIRECTIONAL HIT INDICATORS
*/
void(float hitDirBit) hud_renderDirectionHit={
  local float l_fade; 
  if((hitDirBit & STAT_HIT_LF)){
    local vector lorg;
    lorg_x = VIEW_ORG_x + gui_percentXRaw(4);
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, lorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
  
  if((hitDirBit & STAT_HIT_RT)){
    local vector rorg;
    rorg_x = VIEW_MAX_x - gui_percentXRaw(18);
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, rorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
};

/*
  RENDER TARGET DIRECTION INDICATORS
*/ 
void(float targdir) hud_renderTargetDirection={
  if(targdir > -1){
    local vector lorg;
    if(targdir == 0){
      lorg_x = VIEW_ORG_x + gui_percentXRaw(10); 
      lorg_y = VIEW_CTR_y - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_L, gui_percentToPixelRawVec('16 48'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    }
    else if(targdir == 1){
      lorg_x = VIEW_ORG_x + VIEW_MAX_x - gui_percentXRaw(10); 
      lorg_y = VIEW_CTR_y  - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_R, gui_percentToPixelRawVec('16 48'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);     
    }
    else if(targdir == 2){
      lorg_x = VIEW_CTR_x - gui_percentXRaw(24);
      lorg_y = VIEW_CTR_y + gui_percentYRaw(48);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_B, gui_percentToPixelRawVec('48 16'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
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
  pos_x = pos_x + gui_percentXRaw(len);
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
void(vector grpCtr, vector pos, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, string label) hud_renderArmorMeter={
  local vector meterSize, label_org, shofs;
  meterSize = gui_percentToPixelRawVec(mSize);
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlignCustom(pos, (VIEW_CTX | VIEW_CTY), grpCtr);
  gui_renderMeter(val, pos, meterSize, CLR_DEF_ARM_DED, gui_getColorForArmor(val), HUD_ALPHA, 0, meterAxis, 0);
  label_org = gui_calcAlignCustom(gui_percentToPixelRawVec(lbl_ofs), (VIEW_LFT | VIEW_TOP), pos); 
  drawstring(label_org, label, '4 4 0', HUD_COLOR_DEF, HUD_ALPHA, 0);
};

/*
  RENDER ARMOR GRAPH STYLE 1
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
void(vector vorg, float algn, float i_faction, vector radarOrg, float radarRange, float radarMode, vector siz) hud_renderRadar={

  local vector radCenter, radarFidelity, map_size;
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  siz = gui_percentToPixelRawVec(siz);
  vorg = gui_percentToPixelRawVec(vorg);
  vorg = gui_calcAlign(vorg, algn);
  
  radCenter_x = vorg_x + (siz_x / 2);
  radCenter_y = vorg_y + (siz_y / 2);
  
  if(radarMode){
    radarFidelity = RADAR_ACTIVE_ARC_PLAYER;
    radarFidelity_z = radarRange / 3;
  }
  else{
    radarFidelity = RADAR_PASSIVE_ARC_PLAYER;
    radarFidelity_z = radarRange / 4;
  }
  drawpic(radCenter - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  local entity e;
  e = findradius(radarOrg, radarRange);
  while(e){
    if(e.data_type){
      if((e.data_type == DATA_BLD) || (e.data_type == DATA_MECH) || (e.data_type == DATA_VEHC) || (e.data_type == DATA_MECH_AI)){
        local vector hudorg;
        hudorg = gui_mapCoordToImgCoord(map_size, e.origin, vorg, siz);
        drawpic(hudorg - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
      }
    }
    e = e.chain;
  }
};

/*
  RENDER A SINGLE WEAPON AND ITS RELOAD BAR
*/
void(vector pos, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon={
  local entity wep_dat;
  local vector iofs, ofs, metSize, wepState;
  
  pos = gui_percentToPixelRawVec(pos);
  pos = gui_calcAlign(pos, algn);
  
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
  iofs = gui_calcAlignCustom(iofs, (VIEW_CTX | VIEW_CTY), pos);
  drawpic(iofs, data_get_weapon_icon(w_id), imgSz, wepState, HUD_ALPHA, 0);
  
  ofs_x = imgSz_x / 2;
  ofs_y = imgSz_y * 2 + 2;
  metSize_x = imgSz_x;
  metSize_y = gui_percentXRaw(20);
  ofs = gui_percentToPixelRawVec(ofs);
  ofs = gui_calcAlignCustom(ofs, (VIEW_CTX | VIEW_CTY), pos); 
  gui_renderMeter(w_rel, ofs, metSize, CLR_DEF_ARM_DED, gui_getColorForArmor(w_rel), HUD_ALPHA, 0, AXIS_V, 0);
};

void(vector pos, float algn, float val) hud_renderShieldOverlay={

};
void(vector pos, float algn, float val) hud_renderTargetOverlay={

};
void(vector pos, float algn, string name) hud_renderNameOverlay={

};


void(float hp, vector org, vector sz) hud_renderArmorBuilding={
  local vector ofs;
  ofs = org;
  ofs_x = ofs_x - (sz_x/2);
  ofs_y = ofs_y - (sz_y/2);
  gui_renderMeter(hp, ofs, sz, CLR_DEF_ARM_DED, gui_getColorForArmor(hp), HUD_ALPHA, 0, AXIS_V, 0);
};

void(float hp, vector org) hud_renderArmorVehicle={

};

//pos, icon, clr
void(vector post, vector fac_clr) hud_RenderRadar_Mech={
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, 0);
};

void(vector post, vector fac_clr) hud_RenderRadar_Vehc={
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_VEC,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, 0);
};

void(vector post, vector fac_clr) hud_RenderRadar_Building={
  drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_BLD,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, 0);
};

void(vector post, float isOn, vector fac_clr) hud_RenderRadar_Nav={
  if(isOn){
    drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_NAV,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, 0);
  }
};

/*void(vector cofs, float range, vector pnl_sz, float p_faction) hud_RenderRadar={
  local entity e;
  drawpic(cofs - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH,  gui_percentToPixelRawVec('6 6'), '1 1 1', HUD_ALPHA, 0);
  e = findradius(pmove_org, range);
  while(e){
    if((e.data_type == DATA_MECH) || (e.data_type == DATA_BLD) || (e.data_type == DATA_VEHC)){
      local float draw, p_ifac, pyaw;
      local vector ang, clr, eorg, corg, nofs, ctr;
      p_ifac = self.i_faction;
      ctr_x = pnl_sz_x / 2;
      ctr_y = pnl_sz_y / 2;
      draw = TRUE;
      
      corg_x = (e.origin_x - pmove_org_x) / 35;
      corg_y = (e.origin_y - pmove_org_y) / 35; 
      nofs_x = ( cofs_x + corg_x );
      nofs_y = ( cofs_y + corg_y );
      
      if((nofs_x > (cofs_x + ctr_x)) || (nofs_x < (cofs_x - ctr_x))){
        draw = FALSE;
      }  
      if((nofs_y > (cofs_y + ctr_y)) || (nofs_y < (cofs_y - ctr_y))){
        draw = FALSE;
      }
      
      if(e.data_type == DATA_NAVP){
        if(e.i_faction == p_ifac){
          if(draw){
            hud_RenderRadar_Nav(nofs, e.isActive, CLR_DEF_ARM_OK);         
          }
        }
      }
      else if(e.data_type == DATA_BLD){
        if(draw){ 
          traceline(pmove_org+'0 0 128', e.origin + '0 0 128', FALSE, self);
          if(trace_fraction >= 0.9){
            if(e.i_faction == p_ifac){
              clr = CLR_DEF_IIF_FRIEND_BLD;
            }
            else{
              clr = CLR_DEF_IFF_ENEMY_BLD;
            }
            hud_RenderRadar_Building(nofs, clr);
          }
        }
      }
      else if(e.data_type == DATA_MECH){
        if(draw){
          traceline(pmove_org+'0 0 128', e.origin + '0 0 64', FALSE, self);
          if(trace_fraction >= 0.9){
            if(e.i_faction == p_ifac){
              clr = CLR_DEF_IIF_FRIEND;
            }
            else{
              clr = CLR_DEF_IFF_ENEMY;
            }
            hud_RenderRadar_Mech(nofs, clr);
          }
        }
      }
      else if(e.data_type == DATA_VEHC){
        if(draw){      
          traceline(pmove_org+'0 0 128', e.origin + '0 0 64', FALSE, self);
          if(trace_fraction >= 0.9){
            if(e.i_faction == p_ifac){
              clr = CLR_DEF_IIF_FRIEND;
            }
            else{
              clr = CLR_DEF_IFF_ENEMY;
            }
            hud_RenderRadar_Vehc(nofs, clr);
          }
        }
      }
    }
    e = e.chain;
  }
};*/

/*
  displays a background image on the hud
  always draws from bottom left of screen UP
*/
void(vector ofs, vector img_sz, string bimg, float valign, float alpha, vector clr) hud_HelmetImage={
  local vector nofs;
  nofs = gui_percentToPixelRawVec(ofs);
  nofs = gui_calcAlign(ofs, valign); 
  drawpic(nofs, bimg, gui_percentToPixelRawVec(img_sz), clr, alpha, 0);  
};


//entry point for the mech hud system
void(float mech_id, float mech_size) hud_frame={
  if(mech_size == 1){
    if(mech_id == ID_MCH_BALAKET){
      hud_blk_frame(); 
    }
  }
  else if(mech_size == 2){
    if(mech_id == ID_MCH_MATOK){
      hud_mtk_frame(); 
    }
  }
  else if(mech_size == 3){
    if(mech_id == ID_MCH_MONITOR){
      hud_mnt_frame(); 
    }
  }
};
