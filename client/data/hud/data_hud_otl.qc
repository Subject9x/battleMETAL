/*
mech Mod
Author: Subject9x
Date: 11/02/2016
  refac 03/01/2017
Overview: Hud Layout data for mech 'outlaw'
*/

void() otl_hud_ini;
void(entity vec_data) otl_hud_prep;
void(vector view_x, vector view_ctr) otl_HelmetImage;
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) otl_renderCrosshairs;     
void(float shieldval) otl_playerShield;
void(float energyval) otl_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) otl_playerArmor;
void(float rad_front, float rad_back, float rad_mode, float i_fact) otl_Radar;
void(float hit_dir) otl_hitDirectionPips;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon1;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon2;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon3;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon4;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon5;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon6;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon7;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon8;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon9;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) otl_renderTarget; 
void(float shieldval, vector tpos, float zht) otl_targetShield;
void(float lg, float ct, float lt, float rt, float la, float ra) otl_targetArmor;
void(float range) otl_targetRange;
void(float islock) otl_targetLock;
void(float targdir) otl_targetDirectionPip;

//merely registers the hud into the ent list
void() otl_hud_ini={

  local entity oself, otl_hud, otl_en, otl_sh, otl_pd, otl_wp;
  otl_hud = spawn();
  oself = self;
  self = otl_hud;
  self.classname = "data";
  self.data_type = DATA_HUD;
  self.data_idx = ID_MCH_BALAKET;
  self.vec_size = SZ_MCH_BALAKET;
  self.drawmask = MASK_ENGINE;
  self.img = "gfx/hud/hud_blk_bck.png";
  
  self.hud_prep = otl_hud_prep;
  self.hud_HelmetImage = otl_HelmetImage;
  self.hud_renderCrosshairs = otl_renderCrosshairs;
  self.hud_playerShield = otl_playerShield;
  self.hud_playerEnergy = otl_playerEnergy;
  self.hud_playerArmor = otl_playerArmor;
  self.hud_Radar = otl_Radar;
  self.hud_hitDirectionPips = otl_hitDirectionPips;
  self.hud_renderWeapon1 = otl_renderWeapon1;
  self.hud_renderWeapon2 = otl_renderWeapon2;
  self.hud_renderWeapon3 = otl_renderWeapon3;
  self.hud_renderWeapon4 = otl_renderWeapon4;
  self.hud_renderWeapon5 = otl_renderWeapon5;
  self.hud_renderWeapon6 = otl_renderWeapon6;
  self.hud_renderWeapon7 = otl_renderWeapon7;
  self.hud_renderWeapon8 = otl_renderWeapon8;
  self.hud_renderWeapon9 = otl_renderWeapon9;
  self.hud_targetShield = otl_targetShield;
  self.hud_targetArmor = otl_targetArmor;
  self.hud_targetRange = otl_targetRange;
  self.hud_targetLock = otl_targetLock;
  self.hud_targetDirectionPip = otl_targetDirectionPip;
  self.hud_renderTarget = otl_renderTarget;
  self.w_range = -1; //this is hack to check weapon range;
  
  //this is the armor panel
  oself = self;
  self.hud_pnl1 = spawn();
  self = self.hud_pnl1;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = gui_percentToPixelRawVec('48 0');
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('8 10');
  self = oself;
  
  //radar panel
  self.hud_pnl2 = spawn();
  self = self.hud_pnl2;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.colortint = '1 1 1';
  self = oself;
  
  //energy panel
  self.hud_pnl3 = spawn();
  self = self.hud_pnl3;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixel(0.0046, 0.0104);
  self = oself;
  
  //weapon panel
  self.hud_pnl4 = spawn();
  self = self.hud_pnl4;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixel(0.0125, 0.0104);
  self = oself;
 
  //target panel
  oself = self;
  self.hud_pnl5 = spawn();
  self = self.hud_pnl5;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixel(0.0062, 0.0104);
  self = oself;
 
  otl_en = spawn();
  self = otl_en;
    self.classname = "widget";
    self.owner = otl_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('23 76');
    self.margin_ins = gui_percentToPixelRawVec('4 8');
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.18 0.32 0.6';
    self.drawcolor2 = '0.23 0.74 0.84';
    self.drawme = TRUE;
  self = oself;
 otl_hud.wdg_en = otl_en;
  
  otl_sh = spawn();
  self = otl_sh;
    self.classname = "widget";
    self.owner = otl_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('82 12');
    self.margin_ins = gui_percentToPixelRawVec('12 20');
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  self = oself;
  otl_hud.wdg_sh = otl_sh;
  
  otl_pd = spawn();
  self = otl_pd;
    self.classname = "widget";
    self.owner = otl_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('108 20');
    self.margin_ins = gui_percentToPixel(0.0117, 0.0177);
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  self = oself;
  otl_hud.wdg_pd = otl_pd;
  
  otl_wp = spawn();
  self = otl_wp;
    self.classname = "widget";
    self.owner = otl_hud;
    self.otype = OBJ_LIST;
    self.margin_ins = gui_percentToPixelRawVec('6 6');
    self.drawcolor1 = '0.7 0.11 0.23';
    self.drawme = TRUE;
    self.align = self.align | VIEW_TOP | VIEW_LFT;
    self.w1_ofs = gui_percentToPixel(0.0117, 0.0104);
    self.w2_ofs = gui_percentToPixel(0.0117, 0.0187);
    self.w3_ofs = gui_percentToPixel(0.0117, 0.027);
  self = oself;
  otl_hud.wdg_wp = otl_wp;
  
  self = oself;
  addentity(otl_hud);
};

//you can order the panels to sorta chain them if you desire
void(entity vec_data) otl_hud_prep={
  self.data = vec_data;
  //prep the panels 
  //ARMOR PANEL
  local vector  img_sz, ofs;
  local entity rdpnl;
  rdpnl = self.hud_pnl2;
  rdpnl.asize = gui_percentToPixel(0.1281, 0.143);
  rdpnl.hsize = gui_getCenter(rdpnl.asize);
  ofs_x = VIEW_CTR_x - rdpnl.hsize_x + gui_percentXRaw(8);
  ofs_y = ofs_y + rdpnl.asize_y + gui_percentYRaw(4);
  rdpnl.pos = gui_calcAlign(ofs, rdpnl.align);
   
  local entity enpnl;
  enpnl = self.hud_pnl3;
  enpnl.asize = gui_percentToPixelRawVec('35 97.3');
  enpnl.hsize = gui_getCenter(enpnl.asize);
  ofs_x = rdpnl.pos_x - enpnl.asize_x;
  ofs_y = enpnl.asize_y;
  enpnl.pos = gui_calcAlign(ofs, enpnl.align);
  
  local entity ampnl;
  ampnl = self.hud_pnl1;
  ampnl.asize = gui_percentToPixelRawVec('105 105');
  ampnl.hsize = gui_getCenter(ampnl.asize);
  ofs_x = enpnl.pos_x - ampnl.asize_x - gui_percentXRaw(8);
  ofs_y = ampnl.asize_y;
  ampnl.pos = gui_calcAlign(ofs, ampnl.align);
    
  local entity wepnl;
  wepnl = self.hud_pnl4;
  wepnl.asize = gui_percentToPixel(0.0984, 0.3229);
  wepnl.hsize = gui_getCenter(wepnl.asize);
  ofs_x = rdpnl.pos_x - gui_percentXRaw(120);
  ofs_y = ampnl.asize_y + gui_percentYRaw(72);
  wepnl.pos = gui_calcAlign(ofs, wepnl.align);

  local entity tgpnl;
  tgpnl = self.hud_pnl5;
  tgpnl.asize = gui_percentToPixel(0.1281,0.143);
  tgpnl.hsize = gui_getCenter(tgpnl.asize);
  ofs_x = tgpnl.asize_x + tgpnl.hsize_x / gui_percentXRaw(1.1);
  ofs_y = tgpnl.asize_y - gui_percentYRaw(6);
  tgpnl.pos = gui_calcAlign(ofs, tgpnl.align);  
};

void(vector view_x, vector view_ctr) otl_HelmetImage ={

  local vector img_sz, npos, pct, bck, as, hs;
  local string nav;  
  local float ang;
  
  img_sz = draw_getimagesize(self.img);
  as = gui_scaleSize(img_sz,VIEW_SCALE);
  hs = gui_percentToPixelRawVec( gui_getCenter(as) );
  
  bck_x = VIEW_CTR_x - hs_x;
  bck_y = (VIEW_CTR_y - gui_percentYRaw(44) ) + hs_y;
  drawpic(bck, self.img, gui_percentToPixelRawVec(as), '1 1 1', HUD_ALPHA, 0); //DEBUG
  
  ang = getstati(STAT_PLR_ANG);  
  nav = gui_angleToNav(ang);
  npos_x = VIEW_CTR_x - gui_percentXRaw(8);
  npos_y = VIEW_ORG_y + gui_percentYRaw(16);
  drawstring(npos, nav, gui_percentToPixelRawVec('16 16'), '0 1 0', HUD_ALPHA, 0);
  self.prev_ang = ang;
};

/*
 CROSSHAIRS =======================================================
*/
void(float pvid, float lockval, float conv_x, float conv_y, float pitch) otl_renderCrosshairs={

  //convergence
  local vector spr_w, spr_h;
  spr_w_x = conv_x;
  spr_w_y = 0;
  spr_h_y = conv_y;
  spr_h_x = 0;
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(11, 1.5) - spr_w), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_w + gui_percentToPixelRaw(1 ,-1.5)), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(1.5, 11) - spr_h), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_h + gui_percentToPixelRaw(-1.5, 1)), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  if(getstatf(STAT_HIT_DIR) & STAT_HIT_TRG){
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRaw(24,24)), HUD_RET_HIT, gui_percentToPixelRawVec('48 48'), CLR_DEF_ARM_DED, HUD_ALPHA, 0);
  }
  //pitch
  local float p;
  p = pitch; //passing the var doesn't mess with it for some reason
  hud_renderPitchSlider((VIEW_CTR - gui_percentToPixelRaw(64, 24)), 270, -270, p);
  drawfill((VIEW_CTR - gui_percentToPixelRaw(68, 25)), gui_percentToPixelRawVec('8 1'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  drawfill((VIEW_CTR + gui_percentToPixelRaw(-68, 28)), gui_percentToPixelRawVec('8 1'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
};  

/*
  SHIELD METER=====================================================
*/
void(float shieldval) otl_playerShield={
  local vector label_org;
  self.wdg_sh.pos = self.hud_pnl1.pos + self.hud_pnl1.margin_ins +  gui_percentToPixelRawVec('12 18');
  self.wdg_sh.value1 = shieldval;
  gui_renderMeter(self.wdg_sh.value1, self.wdg_sh.pos, gui_percentToPixelRawVec('82 12'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval) , HUD_ALPHA, 0, AXIS_H, 0);
  label_org = self.wdg_sh.pos - gui_percentToPixelRawVec('0 4');
  drawstring(label_org, "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);
};

/*
  ENERGY METER=====================================================
*/
void(float energyval) otl_playerEnergy={
  self.wdg_en.value1 = energyval;
  self.wdg_en.pos = self.hud_pnl3.pos + self.hud_pnl3.margin_ins + gui_percentToPixelRawVec('6 5');
  gui_renderMeter(self.wdg_en.value1, self.wdg_en.pos, gui_percentToPixelRawVec('26 84'), self.wdg_en.drawcolor1,
                                                              self.wdg_en.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
                                                              
  drawpic(self.wdg_en.pos, "gfx/hud/otl/otl_en_cvr.png", gui_percentToPixelRawVec('26 84'), self.hud_pnl3.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl3.pos + self.hud_pnl3.margin_ins + gui_percentToPixelRawVec('8 0'), "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);
};

/*
  PLAYER ARMOR LAYOUT====================================================
*/
void(float ct, float lt, float rt, float la, float ra, float lg) otl_playerArmor={
  local vector pnl_ctr;
  pnl_ctr_x = self.hud_pnl1.pos_x + self.hud_pnl1.asize_x/2;
  pnl_ctr_y = self.hud_pnl1.pos_y +self.hud_pnl1.asize_y/2;
  drawstring((pnl_ctr + gui_percentToPixelRaw(-4, -18)), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ct, (pnl_ctr + gui_percentToPixelRaw(-6, -12)), gui_percentToPixelRaw(12, 36), CLR_DEF_ARM_DED, gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
  
  gui_renderMeter(lg, (pnl_ctr + gui_percentToPixelRaw(-28, 30)), gui_percentToPixelRaw(56, 16), CLR_DEF_ARM_DED, gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRaw(10, -18)), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(rt, (pnl_ctr + gui_percentToPixelRaw(8, -12)), gui_percentToPixelRaw(12, 36),CLR_DEF_ARM_DED, gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRaw(-18,-18)), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(lt, (pnl_ctr + gui_percentToPixelRaw(-20,-12)),gui_percentToPixelRaw(12,36), CLR_DEF_ARM_DED, gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRaw(24,-18)), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(ra, (pnl_ctr + gui_percentToPixelRaw(22,-12)), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawstring((pnl_ctr + gui_percentToPixelRawVec('-32 -18')), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter(la, (pnl_ctr + gui_percentToPixelRawVec('-34 -12')), gui_percentToPixelRawVec('12 36'), CLR_DEF_ARM_DED, gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
};

/*
  RADAR LAYOUT====================================================
*/
void(float rad_front, float rad_back, float rad_mode, float i_fact) otl_Radar={
  local vector lbl1, lbl2,  clr, cvr, c_sz, cvr_ctr, f_clr, b_clr, f_sz, b_sz, bpos;
  local string mode;
  local float len, badj, rad_rng;
  lbl1 = self.hud_pnl2.pos + gui_percentToPixelRawVec('10 10');
  if(rad_mode == TRUE){
    mode = "[ACTIVE]";
    clr = STATUS_DMG;
  }
  else{
    mode = "[PASSIVE]";
    clr = STATUS_AOK;
  }
  len = stringwidth("RADAR MODE:", 0, '6 6 0');
  lbl2 = lbl1;
  lbl2_x = lbl2_x + len + gui_percentXRaw(2);
  drawstring(lbl1, "RADAR MODE:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(lbl2, mode, '6 6 0', clr, HUD_ALPHA, 0);
  rad_rng = getstati(STAT_RDR_RNG);
  drawstring(lbl1 + gui_percentToPixelRawVec('0 6'), strcat("SCALE:", ftos(rad_rng), "m"), '6 6 0', clr, HUD_ALPHA, 0);
  local vector mpos, cprc;
  mpos_x = self.hud_pnl2.pos_x + self.hud_pnl2.hsize_x;
  mpos_x = mpos_x - gui_percentXRaw(71);
  mpos_y = self.hud_pnl2.pos_y + self.hud_pnl2.hsize_y;
  mpos_y = mpos_y - gui_percentYRaw(20);
  
  cprc_x = mpos_x + gui_percentXRaw(45);
  cprc_y = mpos_y + gui_percentYRaw(45);
  
  hud_RenderRadar (cprc, rad_rng, gui_percentToPixelRawVec('90 90'), i_fact);
};

/*
 HIT DIRECTION PIPS===================================================
*/
void(float hit_dir) otl_hitDirectionPips={
  //RE?NDER HIT DIRECTION
  local float l_fade;
  
  if(hit_dir & STAT_HIT_LF){
    local vector lorg;
    lorg_x = VIEW_ORG_x + gui_percentXRaw(4);
    lorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, lorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
  
  if(hit_dir & STAT_HIT_RT){
    local vector rorg;
    rorg_x = VIEW_MAX_x - gui_percentXRaw(18);
    rorg_y = VIEW_ORG_y + (VIEW_MAX_y / 2);
    gui_renderTintImage(TRUE, rorg, HUD_DMG_PIP_H, gui_percentToPixelRawVec('16 128'), '0.85 0.1 0.1', HUD_ALPHA, 0);
  }
};

//all the weapons for the outlaw are on the same panel, so 
//we put the base panel pic in the first weapon function call
/*
  WEAPON 1===================================================
*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon1={
  local entity wep_dat;
  local vector ofs, wstat;
  wep_dat = m_findData(w_id, DATA_WEPN);

  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  ofs = self.hud_pnl4.pos + gui_percentToPixelRawVec('10 4');
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
    
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('2 24')), gui_percentToPixelRawVec('20 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  } 
};
/*
  WEAPON 2====================================================
*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon2={
  local entity wep_dat;
  local vector ofs, stat, wstat;
  wep_dat = m_findData(w_id, DATA_WEPN);
  ofs_x = self.hud_pnl4.pos_x + self.hud_pnl4.asize_x -gui_percentXRaw(46);
  ofs_y = self.hud_pnl4.pos_y + gui_percentYRaw(4);
  
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('2 24')), gui_percentToPixelRawVec('20 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  } 
};
/*
  WEAPON 3====================================================
*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon3={
  local entity wep_dat;
  local vector ofs, stat, wstat;
  wep_dat = m_findData(w_id, DATA_WEPN);
  ofs_x = self.hud_pnl4.pos_x + self.hud_pnl4.hsize_x - gui_percentXRaw(18);
  ofs_y = self.hud_pnl4.pos_y + gui_percentYRaw(4);
  
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(ofs, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (ofs + gui_percentToPixelRawVec('2 24')), gui_percentToPixelRawVec('20 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(ofs, gui_percentToPixelRawVec('24 42'), '2 2', CLR_DEF_ARM_OK);
  }
};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon4={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon5={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon6={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon7={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon8={};
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) otl_renderWeapon9={};

/*
  RENDER TARGET====================================================
*/
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) otl_renderTarget={

  if((trglock & LOCK_PLYR)){  
    local vector pofs;
    pofs = self.hud_pnl2.pos + self.hud_pnl2.hsize+ gui_percentToPixelRawVec('28 18');
    local float f;
    f = (time - (2 * floor(time/2)));
    if(f > 1){
      drawstring(pofs, "[INCOMING]", '6 6 0', CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0);
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
      local vector ofs, rofs, spos, apos;
      local string dist;
      ofs = rofs = self.hud_pnl2.pos;
      drawstring((ofs + gui_percentToPixelRawVec('8 26')), "[TARGET]", '6 6 0', STATUS_DMG, HUD_ALPHA, 0);
      drawstring((ofs + gui_percentToPixelRawVec('58 26')), dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      gui_renderTintImage(TRUE, (ofs + gui_percentToPixelRawVec('165 32')), HUD_TRG_PIP_R, '8 24', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
      apos = tpos;
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
        pnl_ctr_x = self.hud_pnl5.pos_x + self.hud_pnl5.asize_x/2;
        pnl_ctr_y = self.hud_pnl5.pos_y + self.hud_pnl5.asize_y/2;
        pnl_ctr = pnl_ctr;
        hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr + gui_percentToPixelRawVec('0 12'), gui_percentToPixelRawVec('78 56'));
      }
      else if(dat.data_type == DATA_VEHC){
      
      }
      self.hud_targetShield(trgsh, tpos);
      self.hud_targetRange(trgdist);
      self.hud_targetLock(trglock);
      self.hud_targetDirectionPip(trgdir);
    }
  }
}; 


/*
  TARGET ARMOR LAYOUT====================================================
*/
void(float lg, float ct, float lt, float rt, float la, float ra) otl_targetArmor={
  if(ct > -1){
    local vector pnl_ctr;
    pnl_ctr_x = self.hud_pnl5.pos_x + self.hud_pnl5.hsize_x;
    pnl_ctr_y = self.hud_pnl5.pos_y + self.hud_pnl5.hsize_y + gui_percentYRaw(12);
    local vector colorBuffer;
    //target center torso
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-4 -18')), "CT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('-6 -12')), gui_percentToPixelRawVec('12 36'), '0 0 0', gui_getColorForArmor(ct), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target leg armor
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('-28 30')), gui_percentToPixelRawVec('56 16'), '0 0 0', gui_getColorForArmor(lg), HUD_ALPHA, 0, AXIS_V, 0);
    
    //target right torso
    drawstring((pnl_ctr + gui_percentToPixelRawVec('10 -18')), "RT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('8 -12')), gui_percentToPixelRawVec('12 36'), '0 0 0', gui_getColorForArmor(rt), HUD_ALPHA, 0, AXIS_V, 0);

    //target left torso	
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-18 -18')), "LT", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('-20 -12')), gui_percentToPixelRawVec('12 36'), '0 0 0', gui_getColorForArmor(lt), HUD_ALPHA, 0, AXIS_V, 0);   
    
    //target right arm
    drawstring((pnl_ctr + gui_percentToPixelRawVec('24 -18')), "RA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('22 -12')), gui_percentToPixelRawVec('12 36'),  '0 0 0', gui_getColorForArmor(ra), HUD_ALPHA, 0, AXIS_V, 0);
   
    //target left arm
    drawstring((pnl_ctr + gui_percentToPixelRawVec('-32 -18')), "LA", '4 4 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter(100, (pnl_ctr + gui_percentToPixelRawVec('-34 -12')), gui_percentToPixelRawVec('12 36'), '0 0 0', gui_getColorForArmor(la), HUD_ALPHA, 0, AXIS_V, 0);
  }
};

/*
  TARGER SHIELD METER====================================================
*/
void(float shieldval, vector tpos, float zht) otl_targetShield={
  local vector label_org, ofs, spos;
  local float nlen;
  ofs = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('42 48');
  nlen = stringwidth("[TARGET SHIELD]",0,'6 6 0');
  drawstring(ofs +gui_percentToPixelRawVec('0 -8'), "[TARGET SHIELD]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  if(shieldval > 0){
    gui_renderMeter(shieldval, ofs, gui_percentToPixelRawVec('72 10'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval) , HUD_ALPHA, 0, AXIS_H, 0);
    tpos_z = tpos_z + zht*1.5;
    spos = cs_project(tpos);
    if (spos_z >= 0) {
      spos_x -= 36; //align horizontally to centre
      spos_y -= 3; //align vertically again
      spos_z = 0; //shut up dp.
      gui_renderMeter(shieldval, spos, gui_percentToPixelRawVec('72 6'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval) , HUD_ALPHA, 0, AXIS_H, 0);
    }
  }
};
/*
  TARGER RANGE====================================================
*/
void(float range) otl_targetRange={
  if(range > -1){
    local vector tofs;
    tofs = self.hud_pnl2.pos;
    tofs = tofs + gui_percentToPixelRawVec('118 48');
    drawstring(tofs, "[Range]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
    drawstring(tofs + gui_percentToPixelRawVec('0 12'), ftos(range), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
};
/*
  TARGER LOCK INDICATOR====================================================
*/
void(float islock) otl_targetLock={
  if(islock & LOCK_TARG){
    local vector tofs;
    tofs = self.hud_pnl2.pos + self.hud_pnl2.hsize;
    tofs = tofs + gui_percentToPixelRawVec('28 12');
    drawstring(tofs, "[LOCKED ON]", '6 6 0', CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0);
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('12 12')), HUT_RET_LOK, gui_percentToPixelRawVec('24 24'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
};
/*
  TARGER DIRECTIONAL PIP====================================================
*/
void(float targdir) otl_targetDirectionPip={
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