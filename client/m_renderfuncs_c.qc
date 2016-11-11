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
    drawfill(self.pos, self.drawsize, self.drawcolor1, 1, 0 );
    local vector adj;
    adj = self.drawsize;
    adj_y = self.drawsize_y * (self.value1/100);
    drawfill(self.pos, adj, self.drawcolor2, 1, 0 );
  self = oself;
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
  
  
};

void() hud_renderShield={
  local entity oself;
  local vector ofs;
  oself = self;
  self = oself.wdg_sh;
    self.pos = oself.am_pnl_org + self.margin_ins;
    //ofs = css_calcAlign(self.pos, self.align);
    self.value1 = getstati(STAT_SHIELD);
    drawfill( self.pos, self.drawsize, self.drawcolor1, 1, 0 );
    local vector adj;
    adj = self.drawsize;
    adj_x = self.drawsize_x * (self.value1/100);
    drawfill(self.pos, adj, self.drawcolor2, 1, 0 );
  self = oself;
};

