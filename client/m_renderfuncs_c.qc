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
  
  local float hitdir, l_fade;
  hitdir = getstatf(STAT_HIT_DIR);
  
  if(hitdir & STAT_HIT_LF){
    local vector lorg;
    lorg_x = VIEW_ORG_x + 10;
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((lorg + '0 -24'), '8 48', STATUS_DMG, HUD_ALPHA, 0);
  }
  
  /*if(hitdir & STAT_HIT_RT){
    local vector rorg;
    rorg_x = VIEW_MAX_x - 18;
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((rorg + '0 -24'), '8 48', STATUS_DMG, HUD_ALPHA, 0);
  }*/
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

  local float wep_stat, state;
  wep_stat = getstati(STAT_WEP_STT);
  if(getstati(STAT_WEP1_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP1_ID), WEAPON1, css_getWepStatusColor(wep_stat, WEAPON1_DD, WEAPON1_OK), self.wdg_wp.w1_ofs, self);
  }
  if(getstati(STAT_WEP2_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP2_ID), WEAPON2, css_getWepStatusColor(wep_stat, WEAPON2_DD, WEAPON2_OK), self.wdg_wp.w2_ofs, self);
  }
  if(getstati(STAT_WEP3_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP3_ID), WEAPON3, css_getWepStatusColor(wep_stat, WEAPON3_DD, WEAPON3_OK), self.wdg_wp.w3_ofs, self);
  }
  if(getstati(STAT_WEP4_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP4_ID), WEAPON4, css_getWepStatusColor(wep_stat, WEAPON4_DD, WEAPON4_OK), self.wdg_wp.w4_ofs, self);
  }
  if(getstati(STAT_WEP5_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP5_ID), WEAPON5, css_getWepStatusColor(wep_stat, WEAPON5_DD, WEAPON5_OK), self.wdg_wp.w5_ofs, self);
  }
  if(getstati(STAT_WEP6_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP6_ID), WEAPON6, css_getWepStatusColor(wep_stat, WEAPON6_DD, WEAPON6_OK), self.wdg_wp.w6_ofs, self);
  }  
  if(getstati(STAT_WEP7_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP7_ID), WEAPON7, css_getWepStatusColor(wep_stat, WEAPON7_DD, WEAPON7_OK), self.wdg_wp.w7_ofs, self);
  }  
  if(getstati(STAT_WEP8_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP8_ID), WEAPON8, css_getWepStatusColor(wep_stat, WEAPON8_DD, WEAPON8_OK), self.wdg_wp.w8_ofs, self);
  }  
  if(getstati(STAT_WEP9_ID) > -1){
    hud_renderWeapon(cur_group, getstati(STAT_WEP9_ID), WEAPON9, css_getWepStatusColor(wep_stat, WEAPON9_DD, WEAPON9_OK), self.wdg_wp.w9_ofs, self);
  }  
};

void() hud_renderTarget={
  local float tvid, tdat, tshd, tam;
  tvid = getstati(STAT_TRG_VID);
  tdat = getstati(STAT_TRG_DAT);
  tshd = getstatf(STAT_TRG_SH);
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
    nlen = stringwidth(strcat("[Target] ", data.vec_name), 0, '4 4 0');
    title_x = pnl_ctr_x - nlen;
    title_y = self.tg_pnl_org_y + 8;
    drawstring(title, strcat("[Target] ", data.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    
    local float range;
    range = getstati(STAT_TRG_DIST);
    drawstring(title + '0 25', ftos(range), '6 6 0', '1 1 1', HUD_ALPHA, 0);
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
	
	if(data.data_type == DATA_MECH){
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
  }
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
  drawstring(self.rd_pnl_org + '5 10', "[RADAR]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local float mode;
  mode = getstati(STAT_RDR_MODE);
  if(mode == TRUE){
    drawstring(self.rd_pnl_org + '48 10', "ACTIVE", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
  else if (mode == FALSE){
    drawstring(self.rd_pnl_org + '48 10', "PASSIVE", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
  
  
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

void(float cgrp, float wid, float wgr, vector statusColor, vector ofs, entity src) hud_renderWeapon={
  local vector ofsact;
  local entity data;
  ofsact = ofs;
  if(src!=world){
    ofsact = self.wp_pnl_org + ofs;
  }
  
  data = m_findData(wid, DATA_WEPN);
  if(cgrp & wgr){
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
  
  drawstring(ofsact, data.w_name, '4 4 0', statusColor, HUD_ALPHA, 0);
  
};