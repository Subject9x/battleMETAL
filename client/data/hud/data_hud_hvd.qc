/*
mech Mod
Author: Subject9x
Date: 11/02/2016
  refac 03/04/2017
Overview: Hud Layout data for mech 'hevidahl'
*/

void() hvd_hud_ini;
void(entity vec_data) hvd_hud_prep;
void(vector view_x, vector view_ctr) hvd_HelmetImage;
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) hvd_renderCrosshairs;     
void(float shieldval) hvd_playerShield;
void(float energyval) hvd_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) hvd_playerArmor;
void(float rad_front, float rad_back, float rad_mode) hvd_Radar;
void(float hit_dir) hvd_hitDirectionPips;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon1;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon2;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon3;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon4;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon5;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon6;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon7;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon8;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon9;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) hvd_renderTarget; 
void(float shieldval, vector tpos, float zht) hvd_targetShield;
void(float lg, float ct, float lt, float rt, float la, float ra) hvd_targetArmor;
void(float range) hvd_targetRange;
void(float islock) hvd_targetLock;
void(float targdir) hvd_targetDirectionPip;

//merely registers the hud into the ent list
void() hvd_hud_ini={

  local entity oself, hvd_hud, hvd_en, hvd_sh, hvd_pd, hvd_wp;
  hvd_hud = spawn();
  oself = self;
  self = hvd_hud;
  self.classname = "data";
  self.data_type = DATA_HUD;
  self.data_idx = 3;
  self.drawmask = MASK_ENGINE;
  self.img = "gfx/hud/otl/otl_hd.png";
  
  self.hud_prep = hvd_hud_prep;
  self.hud_HelmetImage = hvd_HelmetImage;
  self.hud_renderCrosshairs = hvd_renderCrosshairs;
  self.hud_playerShield = hvd_playerShield;
  self.hud_playerEnergy = hvd_playerEnergy;
  self.hud_playerArmor = hvd_playerArmor;
  self.hud_Radar = hvd_Radar;
  self.hud_hitDirectionPips = hvd_hitDirectionPips;
  self.hud_renderWeapon1 = hvd_renderWeapon1;
  self.hud_renderWeapon2 = hvd_renderWeapon2;
  self.hud_renderWeapon3 = hvd_renderWeapon3;
  self.hud_renderWeapon4 = hvd_renderWeapon4;
  self.hud_renderWeapon5 = hvd_renderWeapon5;
  self.hud_renderWeapon6 = hvd_renderWeapon6;
  self.hud_renderWeapon7 = hvd_renderWeapon7;
  self.hud_renderWeapon8 = hvd_renderWeapon8;
  self.hud_renderWeapon9 = hvd_renderWeapon9;
  self.hud_targetShield = hvd_targetShield;
  self.hud_targetArmor = hvd_targetArmor;
  self.hud_targetRange = hvd_targetRange;
  self.hud_targetLock = hvd_targetLock;
  self.hud_targetDirectionPip = hvd_targetDirectionPip;
  self.hud_renderTarget = hvd_renderTarget;
  self.w_range = -1; //this is hack to check weapon range;
  
  //Right Weapons box
  oself = self;
  self.hud_pnl1 = spawn();
  self = self.hud_pnl1;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_am_2.png";
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '10 15';
  self = oself;
  
  //right big box
  self.hud_pnl2 = spawn();
  self = self.hud_pnl2;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_rd.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '10 15';
  self = oself;
 
  //Left Weapons box
  self.hud_pnl3 = spawn();
  self = self.hud_pnl3;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_am_2.png";
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '10 15';
  self = oself;
  
  //left big box
  self.hud_pnl4 = spawn();
  self = self.hud_pnl4;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_rd.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '10 15';
  self = oself;
  
  //shield
  self.hud_pnl5 = spawn();
  self = self.hud_pnl5;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_en.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '6 10';
  self = oself;
  
  //energy
  self.hud_pnl6 = spawn();
  self = self.hud_pnl6;
    self.classname = "widget";
    self.owner = oself;
    self.img = "gfx/hud/otl/otl_en.png";
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = '6 10';
  self = oself;
  
  //WIDGETS
  hvd_en = spawn();
  self = hvd_en;
    self.classname = "widget";
    self.owner = hvd_hud;
    self.otype = OBJ_METER;
    self.drawsize = '23 76';
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.18 0.32 0.6';
    self.drawcolor2 = '0.23 0.74 0.84';
    self.drawme = TRUE;
  hvd_hud.wdg_en = hvd_en;
  
  hvd_sh = spawn();
  self = hvd_sh;
    self.classname = "widget";
    self.owner = hvd_hud;
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
  hvd_hud.wdg_sh = hvd_sh;
  
  hvd_pd = spawn();
  self = hvd_pd;
    self.classname = "widget";
    self.owner = hvd_hud;
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
  hvd_hud.wdg_pd = hvd_pd;
  
  self = oself;
  addentity(hvd_hud);
};

void(entity vec_data) hvd_hud_prep={
  self.data = vec_data;
  local vector  img_sz, ofs;
  
  //HVD uses 2 weapon panels for the roots
  //RIGHT WEAPONS
    local entity wep_pnl1;
    wep_pnl1 = self.hud_pnl1;
    img_sz = draw_getimagesize(wep_pnl1.img);
    wep_pnl1.asize = gui_scaleSize(img_sz,VIEW_SCALE);
    wep_pnl1.hsize = gui_getCenter(wep_pnl1.asize);
    ofs = wep_pnl1.asize;
    wep_pnl1.pos = gui_calcAlign(ofs, wep_pnl1.align);
  //RIGHT BOX
   local entity rpnl;
    rpnl = self.hud_pnl2;
    img_sz = draw_getimagesize(rpnl.img);
    rpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
    rpnl.hsize = gui_getCenter(rpnl.asize);
    ofs_x = rpnl.asize_x + wep_pnl1.asize_x;
    ofs_y = rpnl.asize_y;
    rpnl.pos = gui_calcAlign(ofs, rpnl.align);
 
  //LEFT WEAPONS
    local entity panel2;
    panel2 = self.hud_pnl3;
    img_sz = draw_getimagesize(panel2.img);
    panel2.asize = gui_scaleSize(img_sz, VIEW_SCALE);
    panel2.hsize = gui_getCenter(panel2.asize);
    ofs_x = 0;
    ofs_y = panel2.asize_y;
    panel2.pos = gui_calcAlign(ofs, panel2.align);
  //LEFT BOX
    local entity lpnl;
    lpnl = self.hud_pnl4;
    img_sz = draw_getimagesize(lpnl.img);
    lpnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
    lpnl.hsize = gui_getCenter(lpnl.asize);
    ofs_x = panel2.asize_x;
    ofs_y = lpnl.asize_y;
    lpnl.pos = gui_calcAlign(ofs, lpnl.align);
    
  //ENERGY
    local entity sh_pnl;
    sh_pnl = self.hud_pnl5;
    img_sz = draw_getimagesize(sh_pnl.img);
    sh_pnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
    sh_pnl.hsize = gui_getCenter(sh_pnl.asize);
    ofs_x = sh_pnl.asize_x + 16;
    ofs_y = sh_pnl.asize_y;
    sh_pnl.pos = gui_calcAlign(ofs, sh_pnl.align);
  //SHIELD
    local entity en_pnl;
    en_pnl = self.hud_pnl6;
    img_sz = draw_getimagesize(en_pnl.img);
    en_pnl.asize = gui_scaleSize(img_sz,VIEW_SCALE);
    en_pnl.hsize = gui_getCenter(en_pnl.asize);
    ofs_x = -16;
    ofs_y = en_pnl.asize_y;
    en_pnl.pos = gui_calcAlign(ofs, en_pnl.align);
};

void(vector view_x, vector view_ctr) hvd_HelmetImage={
  gui_renderImageFullScreen(self.img, '1 1 1', HUD_ALPHA, 0);
  
  local vector sz, hsz, ofs;
  sz = draw_getimagesize("gfx/hud/navbar.png");
  sz = gui_scaleSize(sz,VIEW_SCALE);
  ofs_x = VIEW_CTR_x - (sz_x/2);
  ofs_y = VIEW_ORG_y + 16;
  
  local float ang;
  local vector pct;
  ang = getstati(STAT_PLR_ANG);
  if(ang >= 359){
    ang = 0;
  }
  pct_x = (ang / 360);
  pct_y = 0;
  
  
  gui_renderImageReel(ofs, pct, "gfx/hud/navbar.png", '64 32', '0 1 0', HUD_ALPHA, 0);
  self.prev_ang = ang;
 
};
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) hvd_renderCrosshairs={
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
  drawstring(VIEW_CTR - '24 0', ftos(pitch), '6 6 0', '1 1 1', HUD_ALPHA, 0); 

};     
/* PLAYER SHIELD =======================================================*/
void(float shieldval) hvd_playerShield={
  drawpic(self.hud_pnl5.pos, self.hud_pnl5.img,  self.hud_pnl5.asize, self.hud_pnl5.colortint, HUD_ALPHA, 0);
  self.wdg_sh.value1 = shieldval;
  self.wdg_sh.pos = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + '0 5';
  gui_renderMeter(self.wdg_sh.value1, self.wdg_sh.pos, self.wdg_sh.drawsize, CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_V, 0);
  
  local vector isz;
  isz = draw_getimagesize("gfx/hud/otl/otl_en_cvr.png");
  isz = gui_scaleSize(isz,VIEW_SCALE);
  drawpic(self.wdg_sh.pos, "gfx/hud/otl/otl_en_cvr.png", self.wdg_sh.drawsize, self.hud_pnl5.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl5.pos + self.hud_pnl5.margin_ins, "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);   
};
/* PLAYER ENERGY =======================================================*/
void(float energyval) hvd_playerEnergy={
  drawpic(self.hud_pnl6.pos, self.hud_pnl6.img, self.hud_pnl6.asize, self.hud_pnl6.colortint, HUD_ALPHA, 0);
  self.wdg_en.value1 = energyval;
  self.wdg_en.pos = self.hud_pnl6.pos + self.hud_pnl6.margin_ins + '0 5';
  gui_renderMeter(self.wdg_en.value1, self.wdg_en.pos, self.wdg_en.drawsize, self.wdg_en.drawcolor1,
                                                              self.wdg_en.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  
  local vector isz;
  isz = draw_getimagesize("gfx/hud/otl/otl_en_cvr.png");
  isz = gui_scaleSize(isz,VIEW_SCALE);
  drawpic(self.wdg_en.pos, "gfx/hud/otl/otl_en_cvr.png", self.wdg_en.drawsize, self.hud_pnl6.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl6.pos + self.hud_pnl6.margin_ins, "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);

};
/* PLAYER ARMOR PANEL ==============================================*/
void(float ct, float lt, float rt, float la, float ra, float lg) hvd_playerArmor={
  drawpic(self.hud_pnl4.pos, self.hud_pnl4.img, self.hud_pnl4.asize, '1 1 1', HUD_ALPHA, 0);
   
  local vector pnl_ctr;
  pnl_ctr_x = self.hud_pnl4.pos_x + 44;
  pnl_ctr_y = self.hud_pnl4.pos_y + self.hud_pnl4.hsize_y;
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

void(float rad_front, float rad_back, float rad_mode) hvd_Radar={
 local vector lbl1, lbl2,  clr, cvr, c_sz, cvr_ctr, f_clr, b_clr, f_sz, b_sz, bpos;
  local string mode;
  local float len, badj;
  lbl1 = self.hud_pnl4.pos + self.hud_pnl4.hsize;
  lbl1_y = lbl1_y - 40;
  lbl1_x = lbl1_x + 4;
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
  
  cvr = self.hud_pnl4.pos + self.hud_pnl4.hsize;
  cvr_y = cvr_y - 16;
  cvr_x = cvr_x + 4;
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

void(float hit_dir) hvd_hitDirectionPips={
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

/*WEAPON 1 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon1={
  //right side weapons - 1, 2, 5, 8
  drawpic(self.hud_pnl1.pos, self.hud_pnl1.img, self.hud_pnl1.asize, '1 1 1', HUD_ALPHA, 0);
  
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl1.pos + self.hud_pnl1.margin_ins;
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;

  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON1_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*WEAPON 2 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon2={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl1.pos + self.hud_pnl1.margin_ins + '0 10';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON2_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*WEAPON 3 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon3={
  //right side weapons - 1, 2, 5, 8
  drawpic(self.hud_pnl3.pos,self.hud_pnl3.img,  self.hud_pnl3.asize, '1 1 1', HUD_ALPHA, 0);
  
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl3.pos + self.hud_pnl3.margin_ins;
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON1_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*WEAPON 4 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon4={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl3.pos + self.hud_pnl3.margin_ins + '0 10';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
   
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON2_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*WEAPON 5 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon5={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl1.pos + self.hud_pnl1.margin_ins + '0 20';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
    
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON5_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);

};
/*WEAPON 6 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon6={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl3.pos + self.hud_pnl3.margin_ins + '0 20';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
  
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON5_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);

};
/*WEAPON 7 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon7={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl3.pos + self.hud_pnl3.margin_ins + '0 30';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
    
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON8_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};

/*WEAPON 8 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon8={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl1.pos + self.hud_pnl1.margin_ins + '0 30';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
    
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON8_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*WEAPON 9 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hvd_renderWeapon9={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  pont = self.hud_pnl1.pos + self.hud_pnl1.margin_ins + '0 40';
  wep_dat = m_findData(w_id, DATA_WEPN);
  wlen = stringwidth(wep_dat.w_abbr, 0, '5 6 0');
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok);
  drawstring(pont + '2 0', wep_dat.w_abbr, '5 6 0', wstat, HUD_ALPHA, 0);
  hud_RangeIndicator(pont + '32 0', '16 6', wep_dat.w_range, self.w_range, HUD_ALPHA, 0) ;
   
  if(w_grp & w_bit){
    gui_BoxOnLabel(wep_dat.w_abbr, pont + '3 1', '5 6 0', '2 2 0', '0 1 0'); 
  }
  ofs = pont;
  ofs_x = ofs_x + wlen + 6;
  gui_renderModalPip(ofs, w_rel, WEAPON9_REL, '1 0.1 0.1', '0.1 1 0.1', '8 6', HUD_ALPHA,0);
};
/*TARGET ARMOR PANEL ==============================================*/
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) hvd_renderTarget={
  drawpic(self.hud_pnl2.pos, self.hud_pnl2.img, self.hud_pnl2.asize, '1 1 1', HUD_ALPHA, 0);
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

  if(trgvid > -1){
    local entity dat;
    dat = m_findData(trgvid, trgdat);

    if(dat){
      local vector ofs, rofs, apos, spos;
      local float tlen, nlen, dlen;
      local string dist;
      nlen = stringwidth(dat.vec_name, 0, '6 6 0');
      tlen = stringwidth("[Target]",0,'6 6 0');
      ofs = rofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + '0 2';
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
        pnl_ctr_x = self.hud_pnl2.pos_x + self.hud_pnl2.hsize_x;
        pnl_ctr_y = self.hud_pnl2.pos_y + self.hud_pnl2.hsize_y;
        pnl_ctr = pnl_ctr +'0 12';
        hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr, '96 48');
      }
      else if(dat.data_type == DATA_VEHC){
      
      }

      self.hud_targetShield(trgsh, tpos, 24);
      self.hud_targetRange(trgdist);
      self.hud_targetLock(trglock);
      self.hud_targetDirectionPip(trgdir);
    }
  }
}; 

void(float shieldval, vector tpos, float zht) hvd_targetShield={
  local vector label_org, ofs;
  local float nlen;
  ofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + '0 32';
  drawstring(ofs, "[Shield]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  nlen = stringwidth("[SHIELD]",0,'6 6 0');
    
  if(shieldval > 0){
    local vector spos;
    tpos_z = tpos_z + zht;
    spos = cs_project(tpos);
    if (spos_z >= 0) {
      spos_x -= 36; //align horizontally to centre
      spos_y -= 3; //align vertically again
      spos_z = 0; //shut up dp.
      //ofs_x = ofs_x + nlen + 2;
      gui_renderMeter(shieldval, spos, '72 6', CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
    }
    ofs_x = ofs_x + nlen + 2;
    gui_renderMeter(shieldval, ofs, '72 6', CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
  }
};

void(float lg, float ct, float lt, float rt, float la, float ra) hvd_targetArmor={
  if(ct > -1){
    local vector pnl_ctr;
    pnl_ctr_x = self.hud_pnl2.pos_x + self.hud_pnl2.hsize_x;
    pnl_ctr_y = self.hud_pnl2.pos_y + self.hud_pnl2.hsize_y;
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

void(float range) hvd_targetRange={
  if(range > -1){
    local vector tofs;
    tofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + '0 4';
    tofs = tofs + '0 8';
    drawstring(tofs, "[Range]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
    tofs_x = tofs_x + (stringwidth("[Range]",0,'6 6 0'));
    drawstring(tofs, ftos(range), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
};

void(float islock) hvd_targetLock={
  local vector tofs, colr;
  local float llen;
  local string acq;
  tofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + '0 22';
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

void(float targdir) hvd_targetDirectionPip={
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