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
void(float rad_mode,  float i_fact) mtk_Radar;
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
  self.img = "gfx/hud/hud_mtk_bck.png";
  
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
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = gui_percentToPixelRawVec('48 24');
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('8 10');
  self = oself;
  
  //radar panel
  self.hud_pnl2 = spawn();
  self = self.hud_pnl2;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.colortint = '1 1 1';
  self = oself;
  
  //energy panel
  self.hud_pnl3 = spawn();
  self = self.hud_pnl3;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
  
  //shield panel
  self.hud_pnl4 = spawn();
  self = self.hud_pnl4;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
 
  //target panel
  oself = self;
  self.hud_pnl5 = spawn();
  self = self.hud_pnl5;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_CTX | VIEW_BOT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('-2 6');
  self = oself;
 
 //widgets
  mtk_en = spawn();
  self = mtk_en;
    self.classname = "widget";
    self.owner = mtk_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('23 76');
    self.margin_ins = gui_percentToPixelRawVec('4 8');
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
    self.drawsize = gui_percentToPixelRawVec('23 76');
    self.margin_ins = gui_percentToPixelRawVec('4 8');
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
    self.drawsize = gui_percentToPixelRawVec('108 20');
    self.margin_ins = gui_percentToPixelRawVec('15 17 0');
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
    self.margin_ins = gui_percentToPixelRawVec('6 6');
    self.drawcolor1 = '0.7 0.11 0.23';
    self.drawme = TRUE;
    self.align = self.align | VIEW_TOP | VIEW_LFT;
    self.w1_ofs = gui_percentToPixelRawVec('15 10');
    self.w2_ofs = gui_percentToPixelRawVec('15 18');
    self.w3_ofs = gui_percentToPixelRawVec('15 26');
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
  tgpnl.asize = gui_percentToPixelRawVec('164.1 138.6');
  tgpnl.hsize = gui_getCenter(tgpnl.asize);
  ofs_x = tgpnl.hsize_x;
  ofs_y = tgpnl.asize_y + gui_percentYRaw(20);
  tgpnl.pos = gui_calcAlign(ofs, tgpnl.align);
  
  //ARMOR PANEL
  local entity ampnl;
  ampnl = self.hud_pnl1;
  ampnl.asize = gui_percentToPixelRawVec('105 105');
  ampnl.hsize = gui_getCenter(ampnl.asize);
  ofs_x = (ampnl.asize_x * 2) + gui_percentXRaw(4);
  ofs_y = ampnl.asize_y + gui_percentYRaw(22);
  ampnl.pos = gui_calcAlign(ofs, ampnl.align);
  
  //RADAR PANEL
  local entity rdpnl;
  rdpnl = self.hud_pnl2;
  rdpnl.asize = gui_percentToPixelRawVec('105 105');
  rdpnl.hsize = gui_getCenter(rdpnl.asize);
  ofs_x = (rdpnl.asize_x * 2) + gui_percentXRaw(4);
  ofs_y = rdpnl.asize_y + gui_percentYRaw(22);
  rdpnl.pos = gui_calcAlign(ofs, rdpnl.align);
  
  //ENERGY PANEL
  local entity enpnl;
  enpnl = self.hud_pnl3;
  enpnl.asize = gui_percentToPixelRawVec('35 97.3');
  enpnl.hsize = gui_getCenter(enpnl.asize);
  ofs_x = (enpnl.asize_x * 3) - gui_percentXRaw(2);
  ofs_y = enpnl.asize_y + gui_percentYRaw(15);
  enpnl.pos = gui_calcAlign(ofs, enpnl.align);
    
  //SHIELD PANEL
  local entity shpnl;
  shpnl = self.hud_pnl4;
  shpnl.asize = gui_percentToPixelRawVec('35 97.3');
  shpnl.hsize = gui_getCenter(shpnl.asize);
  ofs_x = shpnl.asize_x + gui_percentXRaw(38);
  ofs_y = shpnl.asize_y + gui_percentYRaw(3);
  shpnl.pos = gui_calcAlign(ofs, shpnl.align);
};

void(vector view_x, vector view_ctr) mtk_HelmetImage ={

  local vector npos,pct, img_sz, as, hs, bck;
  local string nav;  
  local float ang;
  
  img_sz = draw_getimagesize(self.img);
  as = gui_scaleSize(img_sz,VIEW_SCALE);
  hs = gui_percentToPixelRawVec( gui_getCenter(as) );
  
  bck_x = VIEW_CTR_x - hs_x;
  bck_y = (VIEW_CTR_y - gui_percentYRaw(16) )+ hs_y ;
  drawpic(bck, self.img, gui_percentToPixelRawVec(as), '1 1 1', HUD_ALPHA, 0);
  
  ang = getstati(STAT_PLR_ANG);  
  nav = gui_angleToNav(ang);
  npos_x = VIEW_CTR_x - gui_percentXRaw(8);
  npos_y = VIEW_ORG_y + gui_percentYRaw(16);
  drawstring(npos, nav, gui_percentToPixelRawVec('16 16'), '0 1 0', HUD_ALPHA, 0);
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
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('11 1.5')- spr_w), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_w + gui_percentToPixelRawVec('1 -1.5')), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('1.5 11') - spr_h), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_h + gui_percentToPixelRawVec('-1.5 1')), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
    if(getstatf(STAT_HIT_DIR) & STAT_HIT_TRG){
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('24 24')), HUD_RET_HIT, gui_percentToPixelRawVec('48 48'), CLR_DEF_ARM_DED, HUD_ALPHA, 0);
  }
  //pitch
  local float p;
  p = pitch; //passing the var doesn't mess with it for some reason
  hud_renderPitchSlider((VIEW_CTR - gui_percentToPixelRawVec('64 24')), 270, -270, p);
  drawfill((VIEW_CTR - gui_percentToPixelRawVec('68 25')), gui_percentToPixelRawVec('8 1'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  drawfill((VIEW_CTR + gui_percentToPixelRawVec('-68 28')), gui_percentToPixelRawVec('8 1'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
};  

/*SHIELD METER=====================================================*/
void(float shieldval) mtk_playerShield={
  self.wdg_sh.value1 = shieldval;
  self.wdg_sh.pos = self.hud_pnl4.pos;
  gui_renderMeter(self.wdg_sh.value1, self.wdg_sh.pos, gui_percentToPixelRawVec('23 76'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawpic(self.wdg_sh.pos, "gfx/hud/otl/otl_en_cvr.png", gui_percentToPixelRawVec('23 76'), self.hud_pnl4.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl4.pos + gui_percentToPixelRawVec('0 -5'), "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);   
};

/*ENERGY METER=====================================================*/
void(float energyval) mtk_playerEnergy={
  //drawpic(self.hud_pnl3.pos, self.hud_pnl3.img,  self.hud_pnl3.asize, self.hud_pnl3.colortint, HUD_ALPHA, 0);
  self.wdg_en.value1 = energyval;
  self.wdg_en.pos = self.hud_pnl3.pos + gui_percentToPixelRawVec('6 12');
  gui_renderMeter(self.wdg_en.value1, self.wdg_en.pos, gui_percentToPixelRawVec('23 76'), self.wdg_en.drawcolor1,
                                                              self.wdg_en.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  drawpic(self.wdg_en.pos, "gfx/hud/otl/otl_en_cvr.png", gui_percentToPixelRawVec('23 76'), self.hud_pnl3.colortint, HUD_ALPHA, 0);
  drawstring( self.wdg_en.pos + gui_percentToPixelRawVec('0 -5'), "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);
};

/*PLAYER ARMOR LAYOUT====================================================*/
void(float ct, float lt, float rt, float la, float ra, float lg) mtk_playerArmor={
  //drawpic(self.hud_pnl1.pos, self.hud_pnl1.img,  self.hud_pnl1.asize, self.hud_pnl1.colortint, HUD_ALPHA, 0);
  local vector pnl_ctr;
  pnl_ctr_x = self.hud_pnl1.pos_x + self.hud_pnl1.hsize_x;
  pnl_ctr_y = self.hud_pnl1.pos_y + self.hud_pnl1.hsize_y;
  drawstring((pnl_ctr + gui_percentToPixelRawVec('-4 -18')), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ct, (pnl_ctr + gui_percentToPixelRawVec('-6 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
  
  gui_renderMeter(lg, (pnl_ctr + gui_percentToPixelRawVec('-28 30')), gui_percentToPixelRawVec('56 16'), CLR_DEF_ARM_DED, gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRawVec('10 -18')), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(rt, (pnl_ctr + gui_percentToPixelRawVec('8 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRawVec('-18 -18')), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(lt, (pnl_ctr + gui_percentToPixelRawVec('-20 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRawVec('24 -18')), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ra, (pnl_ctr + gui_percentToPixelRawVec('22 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRawVec('-32 -18')), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(la, (pnl_ctr + gui_percentToPixelRawVec('-34 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
};

/*RADAR LAYOUT====================================================*/
void(float rad_mode, float i_fact) mtk_Radar={
  local vector lbl1, lbl2,  clr;
  local string mode;
  local float len, badj, rad_rng;
  lbl1 = self.hud_pnl2.pos + gui_percentToPixelRawVec('20 12');
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
  lbl2 = lbl1 + gui_percentToPixelRawVec('6 12');
  drawstring(lbl2, mode, '6 6 0', clr, HUD_ALPHA, 0);
  rad_rng = getstati(STAT_RDR_RNG);
  drawstring(lbl2 + gui_percentToPixelRawVec('-6 6'), strcat("Scale:", ftos(rad_rng), "m"), '6 6 0', clr, HUD_ALPHA, 0);
  local vector mpos, cprc;
  mpos_x = self.hud_pnl2.pos_x + gui_percentXRaw(8);
  mpos_y = self.hud_pnl2.pos_y + gui_percentYRaw(20);
  
  cprc_x = mpos_x + gui_percentXRaw(45);
  cprc_y = mpos_y + gui_percentYRaw(43);
  
  hud_RenderRadar (cprc, rad_rng, gui_percentToPixelRawVec('90 85'), i_fact);
  drawstring(lbl2 + gui_percentToPixelRawVec('-6 6'), strcat("Scale:", ftos(rad_rng), "m"), '6 6 0', clr, HUD_ALPHA, 0);
};

/*HIT DIRECTION PIPS===================================================*/
void(float hit_dir) mtk_hitDirectionPips={
  //RENDER HIT DIRECTION
  local float l_fade;
  
  if(hit_dir & STAT_HIT_LF){
    local vector lorg;
    lorg_x = VIEW_ORG_x + gui_percentXRaw(4);
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((lorg + gui_percentToPixelRawVec('0 -24')), gui_percentToPixelRawVec('8 48'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
  
  if(hit_dir & STAT_HIT_RT){
    local vector rorg;
    rorg_x = VIEW_MAX_x - gui_percentXRaw(18);
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    drawfill((rorg + gui_percentToPixelRawVec('0 -24')), gui_percentToPixelRawVec('8 48'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
};


/* WEAPON 1===================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon1={
  local vector pont,wstat,ofs;
  local entity wep_dat;

  pont_x = VIEW_CTR_x + self.hud_pnl5.hsize_x;
  pont_y = self.hud_pnl5.pos_y;
  ofs = pont + gui_percentToPixelRawVec('32 2');

  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);

  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('14 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 2====================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon2={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  
  pont_x = self.hud_pnl5.pos_x - self.hud_pnl5.hsize_x;
  pont_y = self.hud_pnl5.pos_y;
  ofs_x = pont_x - gui_percentXRaw(30); 
  ofs_y = pont_y + gui_percentYRaw(2);
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('14 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 3====================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon3={

  local vector pont,wstat,ofs;
  local entity wep_dat;
  pont_x = VIEW_CTR_x + self.hud_pnl5.hsize_x;
  pont_y = self.hud_pnl5.pos_y;
  ofs = pont + gui_percentToPixelRawVec('72 2');
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('14 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon4={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  pont_x = self.hud_pnl5.pos_x - self.hud_pnl5.hsize_x;
  pont_y = self.hud_pnl5.pos_y;
  ofs_x = pont_x + gui_percentXRaw(12); 
  ofs_y = pont_y + gui_percentYRaw(2);
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('14 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mtk_renderWeapon5={
  local vector isz,wstat,ofs;
  local entity wep_dat;
  local float wlen;
  ofs_x = self.hud_pnl5.pos_x + self.hud_pnl5.hsize_x + gui_percentXRaw(42);
  ofs_y = self.hud_pnl5.pos_y + gui_percentYRaw(4);
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('14 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('46 24'), '2 2', CLR_DEF_ARM_OK);
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
    pofs = self.hud_pnl1.pos + gui_percentToPixelRawVec('4 0');
    pofs_y = pofs_y + gui_percentYRaw(16);
    local float f;
    f = (time - (2 * floor(time/2)));
    if(f > 1){
      drawstring(pofs, "![INCOMING]!", '8 8 0', '1 0.1 0.1', HUD_ALPHA, 0);
    }
  }
  if(trgvid > -1){
    local entity dat;
    local float pcls;
    pcls = getstati(TRG_P_CLASS);
    if(pcls == P_MECH){
      dat = m_findMechData(getstati(TRG_VEC_SIZ), trgdat);
    }
    else{
      dat = m_findData(trgvid, trgdat);
    }

    if(dat){
      local vector ofs, rofs, apos, spos;
      local float tlen, nlen, dlen;
      local string dist;
      nlen = stringwidth(dat.vec_name, 0, '6 6 0');
      tlen = stringwidth("[Target]",0,'6 6 0');
      ofs = rofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('0 24');
      drawstring(ofs, "[Target]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
      rofs_x = ofs_x + tlen;
      drawstring(rofs, dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      
      apos = tpos;
      spos = cs_project(apos);
      if (spos_z >= 0) {
        local vector i_sz;
        i_sz = draw_getimagesize("gfx/hud/target_box.png");
        i_sz = gui_scaleSize(i_sz, VIEW_SCALE);
        i_sz = gui_percentToPixelRawVec(i_sz);
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
        pnl_ctr = pnl_ctr+ gui_percentToPixelRawVec('0 20');
        hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr, gui_percentToPixelRawVec('78 48'));
      }
      else if(dat.data_type == DATA_VEHC){
      
      }
      self.hud_targetShield(trgsh, tpos, dat.c_bbx_x_z / 2);
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
    pnl_ctr = pnl_ctr + gui_percentToPixelRawVec('0 14');
    //target center torso
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-4 -18')), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(ct, (pnl_ctr + gui_percentToPixelRawVec('-6 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target leg armor
    gui_renderMeter(lg, (pnl_ctr + gui_percentToPixelRawVec('-28 30')), gui_percentToPixelRawVec('56 16'), CLR_DEF_ARM_DED, gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target right torso
    drawstring((pnl_ctr + gui_percentToPixelRawVec('10 -18')), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(rt, (pnl_ctr + gui_percentToPixelRawVec('8 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);

    //target left torso	
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-18 -18')), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(lt, (pnl_ctr + gui_percentToPixelRawVec('-20 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);   
    
    //target right arm
    drawstring((pnl_ctr + gui_percentToPixelRawVec('24 -18')), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(ra, (pnl_ctr + gui_percentToPixelRawVec('22 -12')), gui_percentToPixelRawVec('12 36'),  CLR_DEF_ARM_DED, gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
   
    //target left arm
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-32 -18')), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(la, (pnl_ctr + gui_percentToPixelRawVec('-34 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
  }
};

/*
  TARGER SHIELD METER====================================================
*/
void(float shieldval, vector tpos, float zht) mtk_targetShield={
  local vector label_org, ofs;
  local float nlen;
  ofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('0 40');
  drawstring(ofs, "[Shield]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  nlen = stringwidth("[SHIELD]",0,'6 6 0');
  
  if(shieldval > 0){
    local vector spos;
    tpos_z = tpos_z + zht + (zht / 2 );
    spos = cs_project(tpos);
    if (spos_z >= 0) {
      spos_x -= gui_percentXRaw(36); //align horizontally to centre
      spos_y -= gui_percentYRaw(32); //align vertically again
      spos_z = 0; //shut up dp.
      //ofs_x = ofs_x + nlen + 2;
      gui_renderMeter(shieldval, spos, gui_percentToPixelRawVec('72 6'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
    }
    ofs_x = ofs_x + nlen + gui_percentXRaw(2);
    gui_renderMeter(shieldval, ofs, gui_percentToPixelRawVec('72 6'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
  }
};
/*
  TARGER RANGE====================================================
*/
void(float range) mtk_targetRange={
  if(range > -1){
    local vector tofs;
    tofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('0 32');
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
  tofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('0 48');
  llen = stringwidth("[Lock]",0,'6 6 0');
  drawstring(tofs, "[Lock]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  if(islock & LOCK_TARG){
    colr = '1 0.25 0.1';
    acq = "!ACQUIRED!";
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('12 12')), HUT_RET_LOK, gui_percentToPixelRawVec('24 24'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
  else{
    colr = '0.5 0.5 0.5';
    acq = "UNLOCKED";
  }
  tofs_x = tofs_x + llen + gui_percentXRaw(2);
  drawstring(tofs, acq, '6 6 0', colr, HUD_ALPHA, 0);
  
};
/*
  TARGER DIRECTIONAL PIP====================================================
*/
void(float targdir) mtk_targetDirectionPip={
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