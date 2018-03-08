/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
  refac 03/04/2017
Overview: Hud Layout data for mech 'monitor'
*/

void() mnt_hud_ini;
void(entity vec_data) mnt_hud_prep;
void(float hit_dir) mnt_hitDirectionPips;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon1;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon2;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon3;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon4;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon5;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon6;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon7;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon8;
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon9;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) mnt_renderTarget; 
void(float shieldval, vector tpos, float zht) mnt_targetShield;
void(float lg, float ct, float lt, float rt, float la, float ra) mnt_targetArmor;
void(float range) mnt_targetRange;
void(float islock) mnt_targetLock;
void(float targdir) mnt_targetDirectionPip;


//entry point
void() hud_mnt_frame={
  local vector img_sz;
  img_sz = '675 180';
  hud_HelmetImage('337.5 165', img_sz, HUD_MNT_IMG_B, (VIEW_CTX | VIEW_BOT), HUD_ALPHA, CLR_DEF_WHITE); 
  
  //PLAYER STATS
  hud_renderEnergy('-15 87', (VIEW_CTX | VIEW_BOT), self.en_cur, '26 84', TRUE, (VIEW_CTX | VIEW_TOP), '1 6', AXIS_V);
  hud_renderShield('45 87', (VIEW_BOT | VIEW_CTX), self.sh_cur, '26 84', TRUE, (VIEW_LFT | VIEW_TOP), '0 6', AXIS_V);
  hud_renderArmorGraph('170 -124', (VIEW_CTX | VIEW_CTY), self.hp_ctor, self.hp_stor, self.hp_stor2, self.hp_arm, self.hp_arm2, self.hp_leg);
    
  //MECH WEAPON DISPLAY
  //RIGHT WEAPONS
  hud_renderWeapon2('50 135', '24 24', (VIEW_RGT | VIEW_BOT), self.currentWeaponGroup, self.stat_w1_id, WEAPON1, self.stat_w1_rel);
  hud_renderWeapon2('95 135', '24 24', (VIEW_RGT | VIEW_BOT), self.currentWeaponGroup, self.stat_w2_id, WEAPON2, self.stat_w2_rel);
  hud_renderWeapon2('50 100', '24 24', (VIEW_RGT | VIEW_BOT), self.currentWeaponGroup, self.stat_w5_id, WEAPON5, self.stat_w5_rel);
  hud_renderWeapon2('95 100', '24 24', (VIEW_RGT | VIEW_BOT), self.currentWeaponGroup, self.stat_w8_id, WEAPON8, self.stat_w8_rel);
  
  //LEFT WEAPONS
  hud_renderWeapon2('18 135', '24 24', (VIEW_LFT | VIEW_BOT), self.currentWeaponGroup, self.stat_w3_id, WEAPON3, self.stat_w3_rel);
  hud_renderWeapon2('62 135', '24 24', (VIEW_LFT | VIEW_BOT), self.currentWeaponGroup, self.stat_w4_id, WEAPON4, self.stat_w4_rel);
  hud_renderWeapon2('18 100', '24 24', (VIEW_LFT | VIEW_BOT), self.currentWeaponGroup, self.stat_w6_id, WEAPON6, self.stat_w6_rel);
  hud_renderWeapon2('62 100', '24 24', (VIEW_LFT | VIEW_BOT), self.currentWeaponGroup, self.stat_w7_id, WEAPON7, self.stat_w7_rel);
  
  //CENTER WEAPON
  hud_renderWeapon2('62 70', '24 24', (VIEW_LFT | VIEW_BOT), self.currentWeaponGroup, self.stat_w9_id, WEAPON9, self.stat_w9_rel);
  
  //RADAR DISPLAY
  hud_renderRadar('135 80', (VIEW_CTX | VIEW_BOT), self.i_faction, self.origin, self.radar_range, self.stat_rdr_mode, '70 70');
  hud_renderRadarStatus2('95 -100', (VIEW_CTX | VIEW_CTY), self.stat_rdr_mode, self.radar_range, 0);
  
  //TARGET STATS
  if(self.stat_trg_vid > 0 && self.stat_trg_vid != 255){   
    hud_renderShield('-90 104', (VIEW_BOT | VIEW_CTX), self.target_shield, '90 12', TRUE, (VIEW_LFT | VIEW_TOP), '0 10', AXIS_H);
    hud_renderTargetOverlay(self.target_origin, self.origin, 0, self.i_faction, self.target_faction, self.radar_range);
    hud_renderShieldOverlay(self.target_origin, self.origin, 0, self.target_shield, self.radar_range, self.target_vecsize, '64 4', AXIS_H);
    if(self.target_datatype == DATA_MECH){
      hud_renderArmorGraph('-135 55', (VIEW_CTX | VIEW_BOT), self.stat_trg_ct_hp, self.stat_trg_lt_hp, self.stat_trg_rt_hp,self.stat_trg_la_hp, self.stat_trg_ra_hp, self.stat_trg_lg_hp);
    }
    else if(self.target_datatype == DATA_VEHC){
      hud_renderArmorBuilding('-42 45', (VIEW_CTX | VIEW_BOT), '32 75', self.stat_trg_ct_hp);
    }
    else if(self.target_datatype == DATA_BLD){
      hud_renderArmorBuilding('-105 50', (VIEW_CTX | VIEW_BOT), '32 75', self.stat_trg_ct_hp);
    }
    data_get_target(self.target_datatype, self.stat_trg_vid,self.target_vecsize);
    
    hud_renderTargetName('-54 -92', buffer_TargetInfo[0], (VIEW_CTX | VIEW_CTY));
    hud_renderTargetRange('-54 -100', self.target_origin, self.origin, (VIEW_CTX | VIEW_CTY));
  }
  
  
  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(self.stat_hit_dirs);
  hud_renderCrosshairs(getstati(STAT_LCK_STT), 0, getstatf(STAT_SPR_X), getstatf(STAT_SPR_Y));
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x * -3, 270, -270);
  hud_renderTargetDirection(self.stat_trg_face);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), self.stat_ret_dist) ;
  hud_renderNavHeading( '8 16', (VIEW_CTX | VIEW_TOP), self.angles);
};


//merely registers the hud into the ent list
void() mnt_hud_ini={

  local entity oself, mnt_hud, mnt_en, mnt_sh, mnt_pd, mnt_wp;
  mnt_hud = spawn();
  oself = self;
  self = mnt_hud;
  self.classname = "data";
  self.data_type = DATA_HUD;
  self.data_idx = ID_MCH_MONITOR;
  self.vec_size = SZ_MCH_MONITOR;
  self.drawmask = MASK_ENGINE;
  self.img = "gfx/hud/hud_mnt_bck.png";
  self.w_range = -1; //this is hack to check weapon range;
  
  //Right Weapons box
  oself = self;
  self.hud_pnl1 = spawn();
  self = self.hud_pnl1;
    self.classname = "widget";
    self.owner = oself;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
  
  //right big box
  self.hud_pnl2 = spawn();
  self = self.hud_pnl2;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_RGT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('10 15');
  self = oself;
 
  //Left Weapons box
  self.hud_pnl3 = spawn();
  self = self.hud_pnl3;
    self.classname = "widget";
    self.owner = oself;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
  
  //left big box
  self.hud_pnl4 = spawn();
  self = self.hud_pnl4;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('10 15');
  self = oself;
  
  //shield
  self.hud_pnl5 = spawn();
  self = self.hud_pnl5;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
  
  //energy
  self.hud_pnl6 = spawn();
  self = self.hud_pnl6;
    self.classname = "widget";
    self.owner = oself;
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_CTX;
    self.offset = '0 0';
    self.colortint = '1 1 1';
    self.margin_ins = gui_percentToPixelRawVec('6 10');
  self = oself;
  
  //WIDGETS
  mnt_en = spawn();
  self = mnt_en;
    self.classname = "widget";
    self.owner = mnt_hud;
    self.otype = OBJ_METER;
    self.drawsize = '23 76';
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.18 0.32 0.6';
    self.drawcolor2 = '0.23 0.74 0.84';
    self.drawme = TRUE;
  mnt_hud.wdg_en = mnt_en;
  
  mnt_sh = spawn();
  self = mnt_sh;
    self.classname = "widget";
    self.owner = mnt_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('23 76');
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  mnt_hud.wdg_sh = mnt_sh;
  
  mnt_pd = spawn();
  self = mnt_pd;
    self.classname = "widget";
    self.owner = mnt_hud;
    self.otype = OBJ_METER;
    self.drawsize = gui_percentToPixelRawVec('108 20');
    self.margin_ins = gui_percentToPixelRawVec('15 17');
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  mnt_hud.wdg_pd = mnt_pd;
  
  self = oself;
  addentity(mnt_hud);
};

void(entity vec_data) mnt_hud_prep={
  self.data = vec_data;
  local vector  img_sz, ofs;
  
  //HVD uses 2 weapon panels for the roots
  //RIGHT WEAPONS
    local entity wep_pnl1;
    wep_pnl1 = self.hud_pnl1;
    wep_pnl1.asize = gui_percentToPixelRawVec('105 105');
    wep_pnl1.hsize = gui_percentToPixelRawVec( gui_getCenter(wep_pnl1.asize) );
    ofs = wep_pnl1.asize;
    wep_pnl1.pos = gui_calcAlign(ofs, wep_pnl1.align);
    
  //RIGHT BOX
   local entity rpnl;
    rpnl = self.hud_pnl2;
    rpnl.asize = gui_percentToPixelRawVec('164.1 138.6');
    rpnl.hsize = gui_getCenter(rpnl.asize);
    ofs_x = rpnl.asize_x + wep_pnl1.asize_x;
    ofs_y = rpnl.asize_y;
    rpnl.pos = gui_calcAlign(ofs, rpnl.align);
    rpnl.margin_ins = gui_percentToPixelRawVec('10 15');
    
  //LEFT WEAPONS
    local entity panel2;
    panel2 = self.hud_pnl3;
    panel2.asize = gui_percentToPixelRawVec('105 105');
    panel2.hsize = gui_getCenter(panel2.asize);
    ofs_x = 0;
    ofs_y = panel2.asize_y;
    panel2.pos = gui_calcAlign(ofs, panel2.align);
  
  //LEFT BOX
    local entity lpnl;
    lpnl = self.hud_pnl4;
    lpnl.asize = gui_percentToPixelRawVec('164.1 138.6');
    lpnl.hsize = gui_getCenter(lpnl.asize);
    ofs_x = panel2.asize_x;
    ofs_y = lpnl.asize_y + gui_percentYRaw(1);
    lpnl.pos = gui_calcAlign(ofs, lpnl.align);

  //ENERGY
    local entity sh_pnl;
    sh_pnl = self.hud_pnl5;
    sh_pnl.asize = gui_percentToPixelRawVec('35 97.3');
    sh_pnl.hsize = gui_getCenter(sh_pnl.asize);
    sh_pnl.margin_ins =  gui_percentToPixelRawVec('6 10');
    ofs_x = sh_pnl.asize_x + gui_percentXRaw(16);
    ofs_y = sh_pnl.asize_y;
    sh_pnl.pos = gui_calcAlign(ofs, sh_pnl.align);

  //SHIELD
    local entity en_pnl;
    en_pnl = self.hud_pnl6;
    en_pnl.asize = gui_percentToPixelRawVec('35 97.3');
    en_pnl.hsize = gui_getCenter(en_pnl.asize);
    en_pnl.margin_ins =  gui_percentToPixelRawVec('6 10');
    ofs_x = gui_percentXRaw(-6);
    ofs_y = en_pnl.asize_y;
    en_pnl.pos = gui_calcAlign(ofs, en_pnl.align);
};

void() mnt_HelmetImage={
  local vector img_sz;
  img_sz = '640 140'; 
  //hud_HelmetImage('320 135', img_sz, HUD_MNT_IMG_B, (VIEW_CTX | VIEW_BOT),  HUD_ALPHA, CLR_DEF_WHITE); 
  //hud_Navbar('8 16', CLR_DEF_ARM_OK, HUD_ALPHA);
};
void(float lockval, float conv_x, float conv_y, float pitch) mnt_renderCrosshairs={
  //convergence
  local vector spr_w, spr_h;
  spr_w_x = conv_x;
  spr_w_y = 0;
  spr_h_y = conv_y;
  spr_h_x = 0;
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('11 1.5') - spr_w), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_w + gui_percentToPixelRawVec('1 -1.5')), HUT_RET_PIP_HRZ, gui_percentToPixelRawVec('10 3'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  
  gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('1.5 11') - spr_h), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  gui_renderTintImage(TRUE, (VIEW_CTR + spr_h + gui_percentToPixelRawVec('-1.5 1')), HUT_RET_PIP_VRT, gui_percentToPixelRawVec('3 10'), '0.2 0.8 0.2', HUD_ALPHA, 0);
  if((self.stat_hit_dirs & STAT_HIT_TRG)){
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('24 24')), HUD_RET_HIT, gui_percentToPixelRawVec('48 48'), CLR_DEF_ARM_DED, HUD_ALPHA, 0);
  }
  //pitch
  local float p;
  p = pitch; //passing the var doesn't mess with it for some reason
  //hud_renderPitchSlider((VIEW_CTR - gui_percentToPixelRawVec('64 24')), 270, -270, p);
};     
/* PLAYER SHIELD =======================================================*/
void(float shieldval) mnt_playerShield={
  self.wdg_sh.value1 = shieldval;
  self.wdg_sh.pos = self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('3 14');
  gui_renderMeter(self.wdg_sh.value1, self.wdg_sh.pos, gui_percentToPixelRawVec('23 70'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_V, 0);
  
  drawpic(self.wdg_sh.pos, "gfx/hud/otl/otl_en_cvr.png", gui_percentToPixelRawVec('23 70'), self.hud_pnl5.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl5.pos + self.hud_pnl5.margin_ins + gui_percentToPixelRawVec('1 8'), "SHIELD", '4 4 0', '1 1 1', HUD_ALPHA, 0);   
};
/* PLAYER ENERGY =======================================================*/
void(float energyval) mnt_playerEnergy={
  self.wdg_en.value1 = energyval;
  self.wdg_en.pos = self.hud_pnl6.pos + self.hud_pnl6.margin_ins + gui_percentToPixelRawVec('3 14');
  gui_renderMeter(self.wdg_en.value1, self.wdg_en.pos, gui_percentToPixelRawVec('23 70'), self.wdg_en.drawcolor1,
                                                              self.wdg_en.drawcolor2, HUD_ALPHA, 0, AXIS_V, 0);
  
  drawpic(self.wdg_en.pos, "gfx/hud/otl/otl_en_cvr.png", gui_percentToPixelRawVec('23 70'), self.hud_pnl6.colortint, HUD_ALPHA, 0);
  drawstring( self.hud_pnl6.pos + self.hud_pnl6.margin_ins + gui_percentToPixelRawVec('1 8'), "ENERGY", '4 4 0', '1 1 1', HUD_ALPHA, 0);

};
/* PLAYER ARMOR PANEL ==============================================*/
void(float ct, float lt, float rt, float la, float ra, float lg) mnt_playerArmor={
  local vector pnl_ctr;
  pnl_ctr_x = self.hud_pnl4.pos_x + gui_percentXRaw(49);
  pnl_ctr_y = self.hud_pnl4.pos_y + ( self.hud_pnl4.hsize_y / 2) ;
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

void(float rad_mode, float rad_range, float i_fact) mnt_Radar={
 local vector lbl1, lbl2,  clr;
  local string mode;
  local float len, badj, rad_rng;
  lbl1 = self.hud_pnl4.pos + self.hud_pnl4.hsize;
  lbl1_y = lbl1_y - gui_percentXRaw(50);
  lbl1_x = lbl1_x + gui_percentYRaw(4);
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
  rad_rng = self.radar_range;
  local vector mpos, cprc;
  mpos_x = self.hud_pnl4.pos_x + self.hud_pnl4.hsize_x;
  mpos_x = mpos_x - gui_percentXRaw(20);
  mpos_y = self.hud_pnl4.pos_y + self.hud_pnl4.hsize_y;
  mpos_y = mpos_y - gui_percentYRaw(10);
  
  cprc_x = mpos_x + gui_percentXRaw(45);
  cprc_y = mpos_y + gui_percentYRaw(45);
  
  //hud_RenderRadar (cprc, rad_rng, gui_percentToPixelRawVec('90 90'), i_fact);
  drawstring(lbl2 + gui_percentToPixelRawVec('-6 6'), strcat("Scale:", ftos(rad_rng), "m"), '6 6 0', clr, HUD_ALPHA, 0);
};

void(float hit_dir) mnt_hitDirectionPips={
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

/*WEAPON 1 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon1={
  //right side weapons - 1, 2, 5, 8
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl1.pos + gui_percentToPixelRawVec('38 20');
  wep_dat = m_findData(w_id, DATA_WEPN);
  
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);  
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 2 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon2={
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl1.pos + gui_percentToPixelRawVec('38 46');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 3 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon3={
  //left side weapons - 3, 4, 6, 7
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl3.pos + gui_percentToPixelRawVec('27 20');
  
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);

  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);  
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 4 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon4={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  pont = self.hud_pnl3.pos + gui_percentToPixelRawVec('27 46');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);

  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);  

  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 5 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon5={
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl1.pos + gui_percentToPixelRawVec('-3 20');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 6 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon6={
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl3.pos + gui_percentToPixelRawVec('69 20');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);

  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);

  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 7 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon7={
  local vector pont,wstat,ofs;
  local entity wep_dat;
  pont = self.hud_pnl3.pos + gui_percentToPixelRawVec('69 46');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};

/*WEAPON 8 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon8={
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl1.pos + gui_percentToPixelRawVec('-3 46');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);
  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);
  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*WEAPON 9 ========================================================*/
void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) mnt_renderWeapon9={
  local vector pont,wstat;
  local entity wep_dat;
  pont = self.hud_pnl1.pos + gui_percentToPixelRawVec('-3 72');
  wep_dat = m_findData(w_id, DATA_WEPN);
  wstat = gui_getWepStatusColor(w_state, w_dd, w_ok, wep_dat.w_range, self.w_range);
  drawpic(pont, wep_dat.w_icon, gui_percentToPixelRawVec('24 24'), wstat, HUD_ALPHA,0);

  local float d;
  d = w_rel *100;
  gui_renderMeter(d, (pont + gui_percentToPixelRawVec('24 0')), gui_percentToPixelRawVec('10 24'), CLR_DEF_ARM_DED, gui_getColorForArmor(d), HUD_ALPHA, 0, AXIS_V, 0);

  if(w_grp & w_bit){
    gui_DrawRect(pont, gui_percentToPixelRawVec('22 24'), '2 2', CLR_DEF_ARM_OK);
  }
};
/*TARGET ARMOR PANEL ==============================================*/
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) mnt_renderTarget={
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

/*  if(trgvid > -1){
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
      ofs = rofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + gui_percentToPixelRawVec('0 2');
      drawstring(ofs, "[Target]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
      rofs_x = ofs_x + tlen;
      drawstring(rofs, dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
      
      apos = tpos;
      if(dat.data_type == DATA_MECH){
        apos_z = apos_z - dat.c_bbx_x_z;
      }
      spos = cs_project(apos);
      if (spos_z >= 0) {
        local vector i_sz, tclr;
        i_sz = draw_getimagesize(HUD_TARGET_BOX);
        i_sz = gui_scaleSize(i_sz, VIEW_SCALE);
        spos_x -= i_sz_x/2; //align horizontally to centre
        spos_y -= i_sz_y/2; //align vertically again
        spos_z = 0; //shut up dp.
        if(getstati(STAT_TRG_IFAC) == self.i_faction){
          tclr = CLR_DEF_IIF_FRIEND;
        }
        else{
          tclr = CLR_DEF_IFF_ENEMY;
        }
        drawpic(spos,HUD_TARGET_BOX, i_sz, tclr, HUD_ALPHA, 0);
      }
      if(dat.data_type == DATA_MECH){
        //self.hud_targetArmor(getstatf(STAT_TRG_LEG_HP), getstatf(STAT_TRG_CTOR_HP), getstatf(STAT_TRG_LTOR_HP),
                       //getstatf(STAT_TRG_RTOR_HP), getstatf(STAT_TRG_LARM_HP), getstatf(STAT_TRG_RARM_HP));
      }
      else if(dat.data_type == DATA_BLD){
        local vector pnl_ctr;
        pnl_ctr_x = self.hud_pnl2.pos_x + self.hud_pnl2.hsize_x;
        pnl_ctr_y = self.hud_pnl2.pos_y + self.hud_pnl2.hsize_y;
        pnl_ctr = pnl_ctr + gui_percentToPixelRawVec('0 12');
        //hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr, gui_percentToPixelRawVec('96 48'));
      }
      else if(dat.data_type == DATA_VEHC){
      
      }

     // self.hud_targetShield(trgsh, tpos, dat.c_bbx_x_z + 10);
      //self.hud_targetRange(trgdist);
     // self.hud_targetLock(trglock);
      //self.hud_targetDirectionPip(trgdir);
    }
  }*/
}; 

void(float shieldval, vector tpos, float zht) mnt_targetShield={
  local vector label_org, ofs;
  local float nlen;
  ofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + gui_percentToPixelRawVec('0 32');
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
      gui_renderMeter(shieldval, spos, gui_percentToPixelRawVec('72 6'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval), HUD_ALPHA, 0, AXIS_H, 0);
    }
    ofs_x = ofs_x + nlen + gui_percentXRaw(2);
    gui_renderMeter(shieldval, ofs, gui_percentToPixelRawVec('72 10'), CLR_DEF_ARM_DED, gui_getColorForShield(shieldval) , HUD_ALPHA, 0, AXIS_H, 0);
  }
};

void(float lg, float ct, float lt, float rt, float la, float ra) mnt_targetArmor={
  if(ct > -1){
    local vector pnl_ctr;
    pnl_ctr_x = self.hud_pnl2.pos_x + (self.hud_pnl2.hsize_x - gui_percentXRaw(4));
    pnl_ctr_y = self.hud_pnl2.pos_y + self.hud_pnl2.hsize_y;
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

void(float range) mnt_targetRange={
  if(range > -1){
    local vector tofs;
    tofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + gui_percentToPixelRawVec('0 4');
    tofs = tofs + gui_percentToPixelRawVec('0 8');
    drawstring(tofs, "[Range]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
    tofs_x = tofs_x + (stringwidth("[Range]",0,'6 6 0'));
    drawstring(tofs, ftos(range), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  }
};

void(float islock) mnt_targetLock={
  local vector tofs, colr;
  local float llen;
  local string acq;
  tofs = self.hud_pnl2.pos + self.hud_pnl2.margin_ins + gui_percentToPixelRawVec('0 22');
  llen = stringwidth("[Lock]",0,'6 6 0');
  drawstring(tofs, "[Lock]", '6 6 0', '0 0.85 0', HUD_ALPHA, 0);
  if(islock & LOCK_TARG){
    colr = '1 0.25 0.1';
    acq = "!ACQUIRED!";
    gui_renderTintImage(TRUE, (VIEW_CTR - '12 12'), HUT_RET_LOK, gui_percentToPixelRawVec('24 24'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
  else{
    colr = '0.5 0.5 0.5';
    acq = "UNLOCKED";
  }
  tofs_x = tofs_x + llen + gui_percentXRaw(2);
  drawstring(tofs, acq, '6 6 0', colr, HUD_ALPHA, 0);
};

void(float targdir) mnt_targetDirectionPip={
  if(targdir > -1){
    local vector lorg;
    if(targdir == 0){
      lorg_x = VIEW_ORG_x + gui_percentXRaw(10); 
      lorg_y = VIEW_CTR_y - gui_percentYRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_L, gui_percentToPixelRawVec('16 48'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    }
    else if(targdir == 1){
      lorg_x = VIEW_ORG_x + VIEW_MAX_x - gui_percentYRaw(10);
      lorg_y = VIEW_CTR_y  - gui_percentXRaw(24);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_R, gui_percentToPixelRawVec('16 48'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);     
    }
    else if(targdir == 2){
      lorg_x = VIEW_CTR_x - gui_percentXRaw(24);
      lorg_y = VIEW_CTR_y + gui_percentYRaw(48);
      gui_renderTintImage(TRUE, lorg, HUD_TRG_PIP_B, gui_percentToPixelRawVec('48 16'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    }
  }
};