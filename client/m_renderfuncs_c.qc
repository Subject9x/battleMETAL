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
    drawstring((pnl_ctr + '-4 -18'), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    css_renderMeter(hp_ct, (pnl_ctr + '-6 -12'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    
    css_renderMeter(hp_lg, (pnl_ctr + '-28 30'), '56 16', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    
    drawstring((pnl_ctr + '10 -18'), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    css_renderMeter(hp_rt, (pnl_ctr + '8 -12'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    
    drawstring((pnl_ctr + '-18 -18'), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    css_renderMeter(hp_lt, (pnl_ctr + '-20 -12'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    
    drawstring((pnl_ctr + '24 -18'), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    css_renderMeter(hp_ra, (pnl_ctr + '22 -12'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
    
    drawstring((pnl_ctr + '-32 -18'), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    css_renderMeter(hp_la, (pnl_ctr + '-34 -12'), '12 36', self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  self = oself;
  local float nlen;
  local vector title;
  nlen = stringwidth(strcat(self.vec_name, "(YOU)"), 0, '4 4 0');
  title_x = pnl_ctr_x - nlen;
  title_y = self.am_pnl_org_y + 8;
  drawstring(title, strcat(self.vec_name, "(YOU)"), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void() hud_renderShield={
  local entity oself;
  local vector ofs, torg;
  oself = self;
  self = oself.wdg_sh;
    self.pos = oself.am_pnl_org + self.margin_ins;
    self.value1 = getstati(STAT_SHIELD);
    css_renderMeter(self.value1, self.pos, self.drawsize, self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_H, 0);
    torg = self.pos - '0 4';
    drawstring(torg, "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);
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

void() hud_renderTarget={
  local float tvid, tdat, tshd, tam;
  tvid = getstati(STAT_TRG_VID);
  drawstring('0 0 0', ftos(tvid), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  tdat = getstati(STAT_TRG_DAT);
  drawstring('0 8 0', ftos(tdat), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  tshd = getstatf(STAT_TRG_SH);
  drawstring('0 16 0', ftos(tshd), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  tam = getstati(STAT_TRG_AM);
  local vector pnl_sz, img_sz, ofs;
  img_sz = draw_getimagesize(self.tg_pnl_img);
  pnl_sz = css_scaleSize(img_sz,VIEW_SCALE);
  ofs = self.tg_pnl_ofs;
  ofs_y = ofs_y + pnl_sz_y;
  self.tg_pnl_org = css_calcAlign(ofs, self.tg_pnl_aln);
  drawpic(self.tg_pnl_org, self.tg_pnl_img, pnl_sz, '1 1 1', 1, 0);
  if(tvid > -1){ 
    local entity oself, data;
    local vector ofs, torg, pos, title, pnl_ctr, pnl_sz;
    local float nlen;
    data = m_findData(tvid, tdat);
    
    if(data == world){
      return;
    }
    if(tshd == 0 ){
      tshd = 0;
    }
    oself = self;
    self = oself.wdg_sh;
      pos = oself.tg_pnl_org + self.margin_ins;
      if(tshd > -1){
        css_renderMeter(tshd, pos, self.drawsize, self.drawcolor1, self.drawcolor2, HUD_ALPHA, 0, AXIS_H, 0);
        torg = pos - '0 4';
        drawstring(torg, "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);
      }
    self = oself;
   
    pnl_ctr_x = self.tg_pnl_org_x + (pnl_sz_x/2);
    pnl_ctr_y = self.tg_pnl_org_y + (pnl_sz_y/2);
    pnl_ctr_x = pos + (pnl_sz_x/2);
    nlen = stringwidth(strcat("[Target] ", self.vec_name), 0, '4 4 0');
    title_x = pnl_ctr_x - nlen;
    title_y = self.tg_pnl_org_y + 8;
    drawstring(title, strcat("[Target] ", data.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
	
	local entity oself;
  oself = self;
  self = oself.wdg_pd;
	local vector colorBuffer;
	//target center torso
	drawstring((pnl_ctr + '-4 -18'), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
	if(tam & TARG_CT_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_CT_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_CT_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}
	css_renderMeter(100, (pnl_ctr + '-6 -12'), '12 36', '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
	
	//target leg armor
	if(tam & TARG_LG_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_LG_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_LG_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}	
	css_renderMeter(100, (pnl_ctr + '-28 30'), '56 16', '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
	
	
	//target right torso
	drawstring((pnl_ctr + '10 -18'), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
	if(tam & TARG_RT_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_RT_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_RT_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}	
	css_renderMeter(100, (pnl_ctr + '8 -12'), '12 36', '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
	
	//target left torso	
	drawstring((pnl_ctr + '-18 -18'), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
	if(tam & TARG_LT_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_LT_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_LT_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}
	css_renderMeter(100, (pnl_ctr + '-20 -12'), '12 36', '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
	
	//target right arm
	drawstring((pnl_ctr + '24 -18'), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
	if(tam & TARG_RA_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_RA_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_RA_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}
	css_renderMeter(100, (pnl_ctr + '22 -12'), '12 36',  '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
	
	//target left arm
	drawstring((pnl_ctr + '-32 -18'), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
	if(tam & TARG_LA_OK){
		colorBuffer = css_getStatusColor(2, 0);
	}
	else if(tam & TARG_LA_DM){
		colorBuffer = css_getStatusColor(1, 0);
	}
	else if(tam & TARG_LA_DD){
		colorBuffer = css_getStatusColor(0, 0);
	}
	css_renderMeter(100, (pnl_ctr + '-34 -12'), '12 36', '0 0 0', colorBuffer, HUD_ALPHA, 0, AXIS_V, 0);
  self = oself;
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
  local float front, back;
  front = getstatf(STAT_RDR_FRNT);
  back = getstatf(STAT_RDR_BACK);
  drawstring(self.rd_pnl_org + '8 15', "[RADAR]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector pnl_ctr, heat_f, heat_r;
  pnl_ctr_x = (pnl_sz_x/2);
  pnl_ctr_y = (pnl_sz_y/2);
  
  drawfill((self.rd_pnl_org + pnl_ctr + '-8 -8'), '16 16', '0.18 0.32 0.6', HUD_ALPHA, 0);
  
  
  heat_f = css_calcRadarHeat(front);
  heat_r = css_calcRadarHeat(back);
  
  drawfill((self.rd_pnl_org + pnl_ctr + '-32 -32'), '64 16', heat_f, HUD_ALPHA, 0);
  
  drawfill((self.rd_pnl_org + pnl_ctr + '-32 16'), '64 16', heat_r, HUD_ALPHA, 0);
  
  
  drawstring(self.rd_pnl_org + '25 50', ftos(front), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  
  drawstring(self.rd_pnl_org + '25 60', ftos(back), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
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
  
  if(wgr != cgrp){
    color = '0 0.75 0';
  }
  
  drawstring(ofsact, data.w_name, '4 4 0', color, HUD_ALPHA, 0);
  
};