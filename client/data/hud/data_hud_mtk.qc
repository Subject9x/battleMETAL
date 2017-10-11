/*
mech Mod
Author: Subject9x
Date: 11/02/2016
  refac 03/03/2017
Overview: Hud Layout data for mech 'matok'
*/

void() mtk_hud_ini;
void(entity vec_data) mtk_hud_prep;
void(vector view_x, vector view_ctr) mtk_HelmetImage;
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) mtk_renderCrosshairs;     
void(float shieldval) mtk_playerShield;
void(float energyval) mtk_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) mtk_playerArmor;
void(float rad_front, float rad_back, float rad_mode,  float i_fact) mtk_Radar;
void(float hit_dir) mtk_hitDirectionPips;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon1;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon2;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon3;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon4;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon5;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon6;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon7;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon8;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon9;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) mtk_renderTarget; 
void(float shieldval, vector tpos, float zht) mtk_targetShield;
void(float lg, float ct, float lt, float rt, float la, float ra) mtk_targetArmor;
void(float range) mtk_targetRange;
void(float islock) mtk_targetLock;
void(float targdir) mtk_targetDirectionPip;

//merely registers the hud into the ent list
void() mtk_hud_ini={

  local entity oself, mtk_hud, mtk_en, mtk_sh, mtk_pd, mtk_wp;
  mtk_hud = spawn();
  oself = self;
  self = mtk_hud;
  self.classname = "data";
  self.data_type = DATA_HUD;
  self.data_idx = ID_MCH_MATOK;
  self.vec_size = SZ_MCH_MATOK;
  self.drawmask = MASK_ENGINE;
  self.img = "gfx/hud/otl/otl_hd.png";
  
  self.hud_prep = mtk_hud_prep;
  self.hud_HelmetImage = mtk_HelmetImage;
  self.hud_renderCrosshairs = mtk_renderCrosshairs;
  self.hud_playerShield = mtk_playerShield;
  self.hud_playerEnergy = mtk_playerEnergy;
  self.hud_playerArmor = mtk_playerArmor;
  self.hud_Radar = mtk_Radar;
  self.hud_hitDirectionPips = mtk_hitDirectionPips;
  self.hud_renderWeapon1 = mtk_renderWeapon1;
  self.hud_renderWeapon2 = mtk_renderWeapon2;
  self.hud_renderWeapon3 = mtk_renderWeapon3;
  self.hud_renderWeapon4 = mtk_renderWeapon4;
  self.hud_renderWeapon5 = mtk_renderWeapon5;
  self.hud_renderWeapon6 = mtk_renderWeapon6;
  self.hud_renderWeapon7 = mtk_renderWeapon7;
  self.hud_renderWeapon8 = mtk_renderWeapon8;
  self.hud_renderWeapon9 = mtk_renderWeapon9;
  self.hud_targetShield = mtk_targetShield;
  self.hud_targetArmor = mtk_targetArmor;
  self.hud_targetRange = mtk_targetRange;
  self.hud_targetLock = mtk_targetLock;
  self.hud_targetDirectionPip = mtk_targetDirectionPip;
  self.hud_renderTarget = mtk_renderTarget;
  self.w_range = -1; //this is hack to check weapon range;
  
  //this is the armor panel
  oself = self;
  self.hud_pnl1 = spawn();
  self = self.hud_pnl1;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_am_2.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = '48 24';
    self.colortint = '1 1 1';
    self.margin_ins = '8 10';
  self = oself;
  
  //radar panel
  self.hud_pnl2 = spawn();
  self = self.hud_pnl2;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_am_2.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.colortint = '1 1 1';
  self = oself;
  
  //energy panel
  self.hud_pnl3 = spawn();
  self = self.hud_pnl3;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_en.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '6 10';
  self = oself;
  
  //shield panel
  self.hud_pnl4 = spawn();
  self = self.hud_pnl4;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_en.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '6 10';
  self = oself;
 
  //target panel
  oself = self;
  self.hud_pnl5 = spawn();
  self = self.hud_pnl5;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_rd.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_CTX | VIEW_BOT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '8 10';
  self = oself;
 
 //widgets
  mtk_en = spawn();
  self = mtk_en;
    self.classname = "widget";
    self.owner = mtk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '23 76';
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.18 0.32 0.6';
    self.drawcolor2 = '0.23 0.74 0.84';
    self.drawme = TRUE;
  mtk_hud.wdg_en = mtk_en;
  
  mtk_sh = spawn();
  self = mtk_sh;
    self.classname = "widget";
    self.owner = mtk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '23 76 0';
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  mtk_hud.wdg_sh = mtk_sh;
  
  mtk_pd = spawn();
  self = mtk_pd;
    self.classname = "widget";
    self.owner = mtk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '108 20 0';
    self.margin_ins = '15 17 0';
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  mtk_hud.wdg_pd = mtk_pd;
  
  mtk_wp = spawn();
  self = mtk_wp;
    self.classname = "widget";
    self.owner = mtk_hud;
    self.otype = OBJ_LIST;
    self.margin_ins = '6 6';
    self.drawcolor1 = '0.7 0.11 0.23';
    self.drawme = TRUE;
    self.align = self.align | VIEW_TOP | VIEW_LFT;
    self.w1_ofs = '15 10 0';
    self.w2_ofs = '15 18 0';
    self.w3_ofs = '15 26 0';
  mtk_hud.wdg_wp = mtk_wp;
  
  self = oself;
  addentity(mtk_hud);
};

//you can order the panels to sorta chain them if you desire
void(entity vec_data) mtk_hud_prep={
  self.data = vec_data;
  local vector  img_sz, ofs;
  
  //mtk uses the targetpanel as the root
  local entity tgpnl;
  tgpnl = self.hud_pnl5;
  img_sz = draw_getimagesize(tgpnl.img);
  tgpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
  tgpnl.hsize = gui_getCenter(tgpnl.asize);
  ofs_x = tgpnl.hsize_x;
  ofs_y = tgpnl.asize_y;
  tgpnl.pos = gui_calcAlign(ofs, tgpnl.align);
  
  //ARMOR PANEL
  local entity ampnl;
  ampnl = self.hud_pnl1;
  img_sz = draw_getimagesize(ampnl.img);
  ampnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
  ampnl.hsize = gui_getCenter(ampnl.asize);
  ofs_x = tgpnl.hsize_x + ampnl.asize_x;
  ofs_y = ampnl.asize_y;
  ampnl.pos = gui_calcAlign(ofs, ampnl.align);
  
  //RADAR PANEL
  local entity rdpnl;
  rdpnl = self.hud_pnl2;
  img_sz = draw_getimagesize(rdpnl.img);
  rdpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
  rdpnl.hsize = gui_getCenter(rdpnl.asize);
  ofs_x = tgpnl.pos_x + tgpnl.asize_x;
  ofs_y = rdpnl.asize_y;
  rdpnl.pos = gui_calcAlign(ofs, rdpnl.align);
  
  //ENERGY PANEL
  local entity enpnl;
  enpnl = self.hud_pnl3;
  img_sz = draw_getimagesize(enpnl.img);
  enpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
  enpnl.hsize = gui_getCenter(enpnl.asize);
  ofs_x = rdpnl.pos_x + rdpnl.asize_x;
  ofs_y = enpnl.asize_y;
  enpnl.pos = gui_calcAlign(ofs, enpnl.align);
  
  //SHIELD PANEL
  local entity shpnl;
  shpnl = self.hud_pnl4;
  img_sz = draw_getimagesize(shpnl.img);
  shpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
  shpnl.hsize = gui_getCenter(shpnl.asize);
  ofs_x = ampnl.pos_x - shpnl.asize_x;
  ofs_y = shpnl.asize_y;
  shpnl.pos = gui_calcAlign(ofs, shpnl.align);
};

void(vector view_x, vector view_ctr) mtk_HelmetImage ={
  gui_renderImageFullScreen(self.img, '1 1 1', HUD_ALPHA, 0);
  local vector npos;
  local string nav;  
  local float ang;
  local vector pct;
  ang = getstati(STAT_PLR_ANG);  
  nav = gui_angleToNav(ang);
  npos_x = VIEW_CTR_x - 8;
  npos_y = VIEW_ORG_y + 16;
  drawstring(npos, nav, '16 16 0', '0 1 0', HUD_ALPHA, 0);
  self.prev_ang = ang;
};

/*CROSSHAIRS ======================================================*/
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) mtk_renderCrosshairs={

  //convergence
  local vector spr_w, spr_h;
  spr_w_x = conv_x;
  spr_w_y = 0;
  spr_h_y = conv_y;
  spr_h_x = 0;
  
  gui_renderTintImage(TRUE, (VIEW_CTR - '11 1.5' - spr_w), HUT_RET_PIP_HRZ, '10 3', '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_w + '1 -1.5'), HUT_RET_PIP_HRZ, '10 3', '0.2 0.8 0.2', HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, (VIEW_CTR - '1.5 11' - spr_h), HUT_RET_PIP_VRT, '3 10', '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_h + '-1.5 1'), HUT_RET_PIP_VRT, '3 10', '0.2 0.8 0.2', HUD_ALPHA, 0);
  
  //pitch
  local float p;
  p = pitch; //passing the var doesn't mess with it for some reason
  hud_renderPitchSlider((VIEW_CTR - '64 24'), 270, -270, p);
  drawfill((VIEW_CTR - '68 25'), '8 1', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  drawfill((VIEW_CTR + '-68 28'), '8 1', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
};  

/*SHIELD METER=====================================================*/
void(float shieldval) mtk_playerShield={
  drawpic(self.hud_pnl4.pos, self.hud_pnl4.img,  self.hud_pnl4.asize, self.hud_pnl4.colortint, HUD_ALPHA, 0);
  self.wdg_sh.value1 = shieldval;
  self.wdg_sh.pos = self.hud_pnl4.pos + self.hud_pnl4.margin_ins + '0 5';
  gui_renderMeter(self.wdg_sh.value1, self.wdg_sh.pos, self.wdg_sh.drawsize, CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_V, 0);
  
  local vector isz;
  isz = draw_getimagesize("gfx/hud/otl/otl_en_cvr.png");
  isz = gui_scaleSize(isz,VIEW_SCALE);
  drawpic(self.wdg_sh.pos, "gfx/hud/otl/otl_en_cvr.png", self.wdg_sh.drawsize, self.hud_pnl4.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl4.pos + self.hud_pnl4.margin_ins, "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);   
};

/*ENERGY METER=====================================================*/
void(float energyval) mtk_playerEnergy={
  drawpic(self.hud_pnl3.pos, self.hud_pnl3.img,  self.hud_pnl3.asize, self.hud_pnl3.colortint, HUD_ALPHA, 0);
  self.wdg_en.value1 = energyval;
  self.wdg_en.pos = self.hud_pnl3.pos + self.hud_pnl3.margin_ins + '0 5';
  gui_renderMeter(self.wdg_en.value1, self.wdg_en.pos, self.wdg_en.drawsize, self.wdg_en.drawcolor1,
                                                              self.wdg_en.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  
  local vector isz;
  isz = draw_getimagesize("gfx/hud/otl/otl_en_cvr.png");
  isz = gui_scaleSize(isz,VIEW_SCALE);
  drawpic(self.wdg_en.pos, "gfx/hud/otl/otl_en_cvr.png", self.wdg_en.drawsize, self.hud_pnl3.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl3.pos + self.hud_pnl3.margin_ins, "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  drawstring( self.hud_pnl3.pos + self.hud_pnl3.margin_ins +'0 16', ftos(energyval), '4 4 0', '1 1 1', HUD_ALPHA, 0);
};

/*PLAYER ARMOR LAYOUT====================================================*/
void(float ct, float lt, float rt, float la, float ra, float lg) mtk_playerArmor={
  drawpic(self.hud_pnl1.pos, self.hud_pnl1.img,  self.hud_pnl1.asize, self.hud_pnl1.colortint, HUD_ALPHA, 0);
  local vector pnl_ctr;
  pnl_ctr_x = self.hud_pnl1.pos_x + self.hud_pnl1.hsize_x;
  pnl_ctr_y = self.hud_pnl1.pos_y + self.hud_pnl1.hsize_y;
  drawstring((pnl_ctr + '-4 -18'), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ct, (pnl_ctr + '-6 -12'), '12 36', CLR_DEF_ARM_DED, gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
  
  gui_renderMeter(lg, (pnl_ctr + '-28 30'), '56 16', CLR_DEF_ARM_DED, gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + '10 -18'), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(rt, (pnl_ctr + '8 -12'), '12 36', CLR_DEF_ARM_DED, gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + '-18 -18'), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(lt, (pnl_ctr + '-20 -12'), '12 36', CLR_DEF_ARM_DED, gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + '24 -18'), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ra, (pnl_ctr + '22 -12'), '12 36', CLR_DEF_ARM_DED, gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + '-32 -18'), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(la, (pnl_ctr + '-34 -12'), '12 36', CLR_DEF_ARM_DED, gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
};

/*RADAR LAYOUT====================================================*/
void(float rad_front, float rad_back, float rad_mode, float i_fact) mtk_Radar={
  drawpic(self.hud_pnl2.pos, self.hud_pnl2.img,  self.hud_pnl2.asize, self.hud_pnl2.colortint, HUD_ALPHA, 0);
  
  local vector lbl1, lbl2,  clr, cvr, c_sz, cvr_ctr, f_clr, b_clr, f_sz, b_sz, bpos;
  local string mode;
  local float len, badj;
  lbl1 = self.hud_pnl2.pos + '20 12';
  if(rad_mode == TRUE){
    mode = "-ACTIVE-";
    clr = STATUS_DMG;
  }
  else{
    mode = "#PASSIVE#";
    clr = STATUS_AOK;
  }
  len = stringwidth("[RADAR MODE]", 0, '6 6 0');
  drawstring(lbl1, "[RADAR MODE]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  lbl2 = lbl1;
  lbl2 = lbl1 + '6 12';
  drawstring(lbl2, mode, '6 6 0', clr, HUD_ALPHA, 0);
  
  cvr = self.hud_pnl2.pos + '18 32';
  c_sz = draw_getimagesize("gfx/hud/otl/otl_rd_cvr.png");
  c_sz = gui_scaleSize(c_sz, VIEW_SCALE/1.25);
  cvr_ctr = cvr + gui_getCenter(c_sz);

  f_clr = gui_calcRadarHeat(rad_front);
  f_sz = c_sz;
  f_sz_y = c_sz_y / 3;
  drawfill(cvr, f_sz, f_clr, HUD_ALPHA, 0);
  
  b_clr = gui_calcRadarHeat(rad_back);
  b_sz = f_sz;
  badj = (c_sz_y / 3)*2;
  bpos = cvr;
  bpos_y = cvr_y + badj;
  drawfill(bpos, f_sz, b_clr, HUD_ALPHA, 0);
  drawfill(cvr_ctr-'10 10', '20 20', self.wdg_en.drawcolor2, HUD_ALPHA, 0);
  drawpic(cvr, "gfx/hud/otl/otl_rd_cvr.png",  c_sz, self.hud_pnl2.colortint, HUD_ALPHA, 0);
};

/*HIT DIRECTION PIPS===================================================*/
void(float hit_dir) mtk_hitDirectionPips={
  //RENDER HIT DIRECTION
  local float l_fade;
  
  if(hit_dir & STAT_HIT_LF){
    local vector lorg;
    lorg_x = VIEW_ORG_x + 4;
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((lorg + '0 -24'), '8 48', '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
  
  if(hit_dir & STAT_HIT_RT){
    local vector rorg;
    rorg_x = VIEW_MAX_x - 18;
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((rorg + '0 -24'), '8 48', '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
};


/* WEAPON 1===================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon1={
  local vector pont,isz,wstat,ofs;
  local entity wep_dat;
  isz = draw_getimagesize("gfx/hud/otl/otl_wp.png");
  isz = gui_scaleSize(isz, VIEW_SCALE);
  pont = self.hud_pnl5.pos + self.hud_pnl5.asize;
  pont_y = self.hud_pnl5.pos_y - isz_y/2.75;
  ofs = pont + '14 6';
  drawpic(pont, "gfx/hud/otl/otl_wp.png",  isz, CLR_DEF_WHITE, HUD_ALPHA, 0);
  wep_dat = m_findData(w_id, DATA_WEPN);
  
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawpic(ofs, wep_dat.w_icon, '24 24', wstat, HUD_ALPHA,0);
  hud_RangeIndicator(ofs + '4 25', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + '0 32'), '24 10', CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_H, 0);
  //gui_renderModalPip((ofs + '8 32'), w_rel, WEAPON1_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
  
  if(w_grp & w_bit){
    gui_DrawRect(ofs, '24 42', '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 2====================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon2={
  local vector pont,isz,wstat,ofs;
  local entity wep_dat;
  isz = draw_getimagesize("gfx/hud/otl/otl_wp.png");
  isz = gui_scaleSize(isz, VIEW_SCALE);
  
  pont = self.hud_pnl5.pos - isz;
  pont_y = self.hud_pnl5.pos_y - isz_y/2.75;
  ofs_x = pont_x + isz_x - 38; 
  ofs_y = pont_y + 6;
  
  drawpic(pont, "gfx/hud/otl/otl_wp.png",  isz, '1 1 1', HUD_ALPHA, 0); 
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawpic(ofs, wep_dat.w_icon, '24 24', wstat, HUD_ALPHA,0);
  hud_RangeIndicator(ofs + '4 25', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + '0 32'), '24 10', CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_H, 0);
  //gui_renderModalPip((ofs + '8 32'), w_rel, WEAPON2_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
  
  if(w_grp & w_bit){
    gui_DrawRect(ofs, '24 42', '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 3====================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon3={
  //"gfx/hud/otl/otl_wp.png"
  local vector pont,isz,wstat,ofs;
  local entity wep_dat;
  isz = draw_getimagesize("gfx/hud/otl/otl_wp.png");
  isz = gui_scaleSize(isz, VIEW_SCALE);
  pont = self.hud_pnl5.pos + self.hud_pnl5.asize;
  pont_y = self.hud_pnl5.pos_y - isz_y/2.75;
  ofs_x = pont_x + isz_x - 38;
  ofs_y = pont_y + 6;
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawpic(ofs, wep_dat.w_icon, '24 24', wstat, HUD_ALPHA,0);
  hud_RangeIndicator(ofs + '4 25', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + '0 32'), '24 10', CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_H, 0);
  //gui_renderModalPip((ofs + '8 32'), w_rel, WEAPON3_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, '24 42', '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon4={
  local vector pont,isz,wstat,ofs;
  local entity wep_dat;
  isz = draw_getimagesize("gfx/hud/otl/otl_wp.png");
  isz = gui_scaleSize(isz, VIEW_SCALE);
  pont = self.hud_pnl5.pos - isz;
  pont_y = self.hud_pnl5.pos_y - isz_y/2.75;
  ofs = pont + '14 6';
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawpic(ofs, wep_dat.w_icon, '24 24', wstat, HUD_ALPHA,0);
  hud_RangeIndicator(ofs + '4 25', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + '0 32'), '24 10', CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_H, 0);
  //gui_renderModalPip((ofs + '8 32'), w_rel, WEAPON4_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, '24 42', '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon5={
  local vector isz,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  ofs = self.hud_pnl5.pos;
  ofs_y = self.hud_pnl5.pos_y - 28;
  ofs_x = VIEW_CTR_x - 12;
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawpic(ofs, wep_dat.w_icon, '24 24', wstat, HUD_ALPHA,0);
  hud_RangeIndicator(ofs + '26 0', '8 24', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + '36 0'), '10 24', CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  //gui_renderModalPip((ofs + '36 0'), w_rel, WEAPON4_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, '46 24', '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon6={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon7={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon8={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon9={};

/*RENDER TARGET====================================================*/
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) mtk_renderTarget={
  if(trglock & LOCK_PLYR){
    local vector pofs;
    pofs = self.hud_pnl1.pos + '4 0';
    pofs_y = pofs_y + 16;
    local float f;
    f = (time - (2 * floor(time/2)));
    if(f > 1){
      drawstring(pofs, "![INCOMING]!", '8 8 0', '1 0.1 0.1', HUD_ALPHA, 0);
    }
  }

  drawpic(self.hud_pnl5.pos, self.hud_pnl5.img,  self.hud_pnl5.asize, self.hud_pnl5.colortint, HUD_ALPHA, 0);
  if(trgvid > -1){
    local entity dat;
    dat = m_findData(trgvid, trgdat);

    if(dat){
      local vector ofs, rofs, apos, spos;
      local float tlen, nlen, dlen;
      local string dist;
      nlen = stringwidth(dat.vec_name, 0, '6 6 0');
      tlen = stringwidth("[Target]",0,'6 6 0');
      ofs = rofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + '0 2';
      drawstring(ofs, "[Target]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
      rofs_x = ofs_x + tlen;
      drawstring(rofs, dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      
      apos = tpos;
      if(dat.data_type == DATA_MECH){
        apos_z = apos_z - dat.c_bbx_x_z;
      }
      spos = cs_project(apos);
      if (spos_z >= 0) {
        local vector i_sz;
        i_sz = draw_getimagesize("gfx/hud/target_box.png");
        i_sz = gui_scaleSize(i_sz, VIEW_SCALE);
        spos_x -= i_sz_x/2; //align horizontally to centre
        spos_y -= i_sz_y/2; //align vertically again
        spos_z = 0; //shut up dp.
        drawpic(spos, "gfx/hud/target_box.png", i_sz, '1 0 0', HUD_ALPHA, 0);
      }
      
      if(dat.data_type == DATA_MECH){
        self.hud_targetArmor(getstatf(STAT_TRG_LEG_HP), getstatf(STAT_TRG_CTOR_HP), getstatf(STAT_TRG_LTOR_HP),
                            getstatf(STAT_TRG_RTOR_HP), getstatf(STAT_TRG_LARM_HP), getstatf(STAT_TRG_RARM_HP));
      }
      else if(dat.data_type == DATA_BLD){
        local vector pnl_ctr;
        pnl_ctr_x = self.hud_pnl5.pos_x + self.hud_pnl5.hsize_x;
        pnl_ctr_y = self.hud_pnl5.pos_y + self.hud_pnl5.hsize_y;
        pnl_ctr = pnl_ctr+ '0 12';
        hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr, '78 48');
      }
      else if(dat.data_type == DATA_VEHC){
      
      }
      self.hud_targetShield(trgsh, tpos, 12);
      self.hud_targetRange(trgdist);
      self.hud_targetLock(trglock);
      self.hud_targetDirectionPip(trgdir);
    }
  }
}; 


/*
  TARGET ARMOR LAYOUT====================================================
*/
void(float lg, float ct, float lt, float rt, float la, float ra) mtk_targetArmor={
  if(ct > -1){
    local vector pnl_ctr;
    pnl_ctr_x = self.hud_pnl5.pos_x + self.hud_pnl5.hsize_x;
    pnl_ctr_y = self.hud_pnl5.pos_y + self.hud_pnl5.hsize_y;
    pnl_ctr = pnl_ctr + '0 14';
    //target center torso
    drawstring((pnl_ctr + '-4 -18'), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + '-6 -12'), '12 36', '0 0 0', gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target leg armor
    gui_renderMeter(100, (pnl_ctr + '-28 30'), '56 16', '0 0 0', gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target right torso
    drawstring((pnl_ctr + '10 -18'), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + '8 -12'), '12 36', '0 0 0', gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);

    //target left torso	
    drawstring((pnl_ctr + '-18 -18'), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + '-20 -12'), '12 36', '0 0 0', gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);   
    
    //target right arm
    drawstring((pnl_ctr + '24 -18'), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + '22 -12'), '12 36',  '0 0 0', gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
   
    //target left arm
    drawstring((pnl_ctr + '-32 -18'), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + '-34 -12'), '12 36', '0 0 0', gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
  }
};

/*
  TARGER SHIELD METER====================================================
*/
void(float shieldval, vector tpos, float zht) mtk_targetShield={
  local vector label_org, ofs;
  local float nlen;
  ofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + '0 32';
  drawstring(ofs, "[Shield]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  nlen = stringwidth("[SHIELD]",0,'6 6 0');
  
  if(shieldval > 0){
    local vector spos;
    tpos_z = tpos_z + zht;
    spos = cs_project(tpos);
    if (spos_z >= 0) {
      spos_x -= 36; //align horizontally to centre
      spos_y -= 32; //align vertically again
      spos_z = 0; //shut up dp.
      //ofs_x = ofs_x + nlen + 2;
      gui_renderMeter(shieldval, spos, '72 6', CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
    }
    ofs_x = ofs_x + nlen + 2;
    gui_renderMeter(shieldval, ofs, '72 6', CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
  }
};
/*
  TARGER RANGE====================================================
*/
void(float range) mtk_targetRange={
  if(range > -1){
    local vector tofs;
    tofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + '0 4';
    tofs = tofs + '0 8';
    drawstring(tofs, "[Range]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
    tofs_x = tofs_x + (stringwidth("[Range]",0,'6 6 0'));
    drawstring(tofs, ftos(range), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
};
/*
  TARGER LOCK INDICATOR====================================================
*/
void(float islock) mtk_targetLock={
  local vector tofs, colr;
  local float llen;
  local string acq;
  tofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + '0 22';
  llen = stringwidth("[Lock]",0,'6 6 0');
  drawstring(tofs, "[Lock]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  if(islock & LOCK_TARG){
    colr = '1 0.25 0.1';
    acq = "!ACQUIRED!";
    gui_renderTintImage(TRUE, (VIEW_CTR - '12 12'), HUT_RET_LOK, '24 24', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
  else{
    colr = '0.5 0.5 0.5';
    acq = "UNLOCKED";
  }
  tofs_x = tofs_x + llen + 2;
  drawstring(tofs, acq, '6 6 0', colr, HUD_ALPHA, 0);
  
};
/*
  TARGER DIRECTIONAL PIP====================================================
*/
void(float targdir) mtk_targetDirectionPip={
  if(targdir > -1){
    local vector lorg, sz;
    if(targdir == 0){
      lorg_x = VIEW_ORG_x + 10; 
      lorg_y = VIEW_CTR_y - 24;
      sz = '8 48';
    }
    else if(targdir == 1){
      lorg_x = VIEW_ORG_x + VIEW_MAX_x - 10; 
      lorg_y = VIEW_CTR_y  - 24;
      sz = '8 48';        
    }
    else if(targdir == 2){
      lorg_x = VIEW_CTR_x - 24;
      lorg_y = VIEW_CTR_y + 48;
      sz = '48 8';
    }
    drawfill(lorg, sz, STATUS_DMG, HUD_ALPHA, 0);
  }
};