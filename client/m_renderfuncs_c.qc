/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: implementation for hud widget callbacks
*/

/*
TODO: fix bar length
TODO: allow for different axis alignments of bar
TODO: allow for different bar types: squares / spheres etc
*/
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
    
    css_renderMeter(self.value1, self.pos, self.drawsize, self.drawcolor1, self.drawcolor2, 1, 0, AXIS_V, 0);
    //drawfill(self.pos, self.drawsize, self.drawcolor1, 1, 0 );
    //local vector adj;
    //adj = self.drawsize;
    //adj_y = self.drawsize_y * (self.value1/100);
    //drawfill(self.pos, adj, self.drawcolor2, 1, 0 );
  self = oself;
  
  drawstring(self.en_pnl_org + '6 6 0', "ENERGY", '4 4 0', '1 1 1', 1, 0);
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
    css_renderMeter(hp_ct, (pnl_ctr + '-8 -24'), '16 48', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
    css_renderMeter(hp_lg, (pnl_ctr + '-28 26'), '56 16', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
  
    css_renderMeter(hp_lt, (pnl_ctr + '-26 -21'), '16 42', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
    css_renderMeter(hp_rt, (pnl_ctr + '10 -21'), '16 42', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
    
    if(hp_la > -1){
      css_renderMeter(hp_la, (pnl_ctr + '-44 -18'), '16 36', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
    }
    if(hp_ra > -1){
        css_renderMeter(hp_ra, (pnl_ctr + '28 -18'), '16 36', self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
    }

  self = oself;
};

void() hud_renderShield={
  local entity oself;
  local vector ofs;
  oself = self;
  self = oself.wdg_sh;
    self.pos = oself.am_pnl_org + self.margin_ins;
    self.value1 = getstati(STAT_SHIELD);
    css_renderMeter(self.value1, self.pos, self.drawsize, self.drawcolor1, self.drawcolor2, 1, 0, AXIS_H, 0);
  self = oself;
};

