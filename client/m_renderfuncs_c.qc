/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: implementation for hud widget callbacks
*/

void() hud_renderHelmet={
  local vector pnl_sz, img_sz, ofs, org;
  local float aln;
  aln = VIEW_BOT | VIEW_LFT;
  img_sz = draw_getimagesize(self.img);
  pnl_sz_x = VIEW_MAX_x;
  pnl_sz_y = img_sz_y;
  
  ofs = '0 0';
  ofs_y = ofs_y + pnl_sz_y;
  org = css_calcAlign(ofs, aln);
  drawpic(org, self.img, pnl_sz, '1 1 1', 1, 0);
  
  local float tvid;
  tvid = getstati(STAT_TRG_VID);
  if(tvid > -1){
    local entity data;
    data = m_findData(tvid, DATA_MECH);
    drawstring('2 2 0', data.vec_name, '8 8 0', '1 1 1', HUD_ALPHA, 0);
  }
};

void() hud_renderEnergy={
  local vector pnl_sz, img_sz, ofs;
  img_sz = draw_getimagesize(self.en_pnl_img);
  pnl_sz = css_scaleSize(img_sz,VIEW_SCALE);
  ofs = self.en_pnl_ofs;
  ofs_y = ofs_y + pnl_sz_y;
  self.en_pnl_org = css_calcAlign(ofs, self.en_pnl_aln);
  drawpic(self.en_pnl_org, self.en_pnl_img, pnl_sz, '1 1 1', 1, 0);
  
  local entity oself, en;
  oself = self;
  en = self.wdg_en;
  self = en;
    self.value1 = getstati(STAT_ENERGY);
    self.pos = self.owner.en_pnl_org + self.margin_ins;
    css_renderMeter(self.value1, self.pos, self.drawsize, self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  self = oself;
  
  drawstring(self.en_pnl_org + '2 3', "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);
};


void() hud_renderPaper={
  local vector pnl_sz, img_sz, ofs;
  img_sz = draw_getimagesize(self.am_pnl_img);
  pnl_sz = css_scaleSize(img_sz,VIEW_SCALE);
  ofs = self.am_pnl_ofs;
  ofs_y = ofs_y + pnl_sz_y;
  self.am_pnl_org = css_calcAlign(ofs, self.am_pnl_aln);
  drawpic(self.am_pnl_org, self.am_pnl_img, pnl_sz, '1 1 1', 1, 0);
  
  local float hp_lg, hp_ct, hp_lt, hp_rt, hp_la, hp_ra;
  hp_lg = getstatf(STAT_LEG_HP);
  hp_ct = getstatf(STAT_CTOR_HP);
  hp_lt = getstatf(STAT_LTOR_HP);
  hp_rt = getstatf(STAT_RTOR_HP);
  hp_la = getstatf(STAT_LARM_HP);
  hp_ra = getstatf(STAT_RARM_HP);
  
  //TODO: make as vars of widget
  local vector pnl_ctr, b_ct, b_st, b_ar, b_lg;
  b_ct = '16 48';
  b_st = '16 32';
  b_ar = '16 16';
  b_lg = '32 16';
  pnl_ctr_x = self.am_pnl_org_x + (pnl_sz_x/2);
  pnl_ctr_y = self.am_pnl_org_y + (pnl_sz_y/2);
  
  local entity oself;
  oself = self;
  self = oself.wdg_pd;
    css_renderMeter(hp_ct, (pnl_ctr + '-6 -16'), '12 40', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    css_renderMeter(hp_lg, (pnl_ctr + '-28 26'), '56 16', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    css_renderMeter(hp_rt, (pnl_ctr + '8 -16'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    css_renderMeter(hp_lt, (pnl_ctr + '-20 -16'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    css_renderMeter(hp_ra, (pnl_ctr + '22 -16'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    css_renderMeter(hp_la, (pnl_ctr + '-34 -16'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  self = oself;
};

void() hud_renderShield={
  local entity oself;
  local vector ofs, torg;
  oself = self;
  self = oself.wdg_sh;
    self.pos = oself.am_pnl_org + self.margin_ins;
    self.value1 = getstati(STAT_SHIELD);
    css_renderMeter(self.value1, self.pos, self.drawsize, self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_H, 0);
    torg = self.pos - '0 8';
    drawstring(torg, "SHIELD", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  self = oself;
};

void(float cur_group) hud_renderWeapons={
  local vector pnl_sz, img_sz, ofs;
  img_sz = draw_getimagesize(self.wp_pnl_img);
  pnl_sz = css_scaleSize(img_sz,VIEW_SCALE);
  ofs = self.wp_pnl_ofs;
  ofs_y = ofs_y + pnl_sz_y;
  self.wp_pnl_org = css_calcAlign(ofs, self.wp_pnl_aln);
  drawpic(self.wp_pnl_org, self.wp_pnl_img, pnl_sz, '1 1 1', 1, 0);

  if(getstati(STAT_WEP1_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP1_ID),getstati(STAT_WEP1_GR),getstati(STAT_WEP1_ST), self.wdg_wp.w1_ofs, self);
  }
  if(getstati(STAT_WEP2_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP2_ID),getstati(STAT_WEP2_GR),getstati(STAT_WEP2_ST), self.wdg_wp.w2_ofs, self);
  }
  if(getstati(STAT_WEP3_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP3_ID),getstati(STAT_WEP3_GR),getstati(STAT_WEP3_ST), self.wdg_wp.w3_ofs, self);
  }
  if(getstati(STAT_WEP4_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP4_ID),getstati(STAT_WEP4_GR),getstati(STAT_WEP4_ST), self.wdg_wp.w4_ofs, self);
  }
  if(getstati(STAT_WEP5_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP5_ID),getstati(STAT_WEP5_GR),getstati(STAT_WEP5_ST), self.wdg_wp.w5_ofs, self);
  }
  if(getstati(STAT_WEP6_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP6_ID),getstati(STAT_WEP6_GR),getstati(STAT_WEP6_ST), self.wdg_wp.w6_ofs, self);
  }  
  if(getstati(STAT_WEP7_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP7_ID),getstati(STAT_WEP7_GR),getstati(STAT_WEP7_ST), self.wdg_wp.w7_ofs, self);
  }  
  if(getstati(STAT_WEP8_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP8_ID),getstati(STAT_WEP8_GR),getstati(STAT_WEP8_ST), self.wdg_wp.w8_ofs, self);
  }  
  if(getstati(STAT_WEP9_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP9_ID),getstati(STAT_WEP9_GR),getstati(STAT_WEP9_ST), self.wdg_wp.w9_ofs, self);
  }  
};

void() hud_renderSpeed={
  

};

void() hud_renderRadar={
  local vector pnl_sz, img_sz, ofs;
  img_sz = draw_getimagesize(self.rd_pnl_img);
  pnl_sz = css_scaleSize(img_sz,VIEW_SCALE);
  ofs = self.rd_pnl_ofs;
  ofs_x = VIEW_CTR_x - (pnl_sz_x/2);
  ofs_y = ofs_y + pnl_sz_y;
  self.rd_pnl_org = css_calcAlign(ofs, self.rd_pnl_aln);
  drawpic(self.rd_pnl_org, self.rd_pnl_img, pnl_sz, '1 1 1', 1, 0);
};

void(float cgrp, float wid, float wgr, float wst, vector ofs, entity src) hud_renderWeapon={
  local vector ofsact, color;
  local entity data;
  ofsact = ofs;
  if(src!=world){
    ofsact = self.wp_pnl_org + ofs;
  }
  
  data = m_findData(wid, DATA_WEPN);
  if(wgr == cgrp){
    local float len;
    len = stringwidth(data.w_name, 0, '4 4 0');
    local vector tl, tr, bl, br;
    tl = ofsact - '2 2';
    tr = ofsact - '2 2';
    tr_x = tr_x + len + 4;
    bl = ofsact;
    bl_x = tl_x;
    bl_y = bl_y + 6;
    br = ofsact;
    br_x = ofsact_x + len + 2;
    br_y = bl_y;
    
    drawline(6, tl, tr, '0 1 0', 1, 0);
    drawline(6, tl, bl, '0 1 0', 1,0);
    drawline(6, tr, br, '0 1 0', 1,0);
    drawline(6, bl, br, '0 1 0', 1, 0);
  }
  
  if(wst == 3){
    color = '1 0 0 ';
  }
  else if(wst == 2){
    color = '1 1 0';
  }
  else{
    color = '0 1 0';
  }
  
  drawstring(ofsact, data.w_name, '4 4 0', color, HUD_ALPHA, 0);
  
};