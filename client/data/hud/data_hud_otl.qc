/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
  refac 03/01/2017
Overview: Hud Layout data for mech 'outlaw'
*/

void() otl_hud_ini;
void(float hit_dir) otl_hitDirectionPips;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) otl_renderTarget; 
void(float shieldval, vector tpos, float zht) otl_targetShield;
void(float range) otl_targetRange;
void(float islock) otl_targetLock;
void(float targdir) otl_targetDirectionPip;

/*
  Entry point coming from the m_hud function
*/
void() hud_blk_frame={
  local vector img_sz;
  img_sz = '452 180';
  hud_HelmetImage('226 175', img_sz, HUD_BLK_IMG_B, (VIEW_CTX | VIEW_BOT), HUD_ALPHA, CLR_DEF_WHITE); 
  
  //PLAYER STATS
  hud_renderEnergy('102 87', (VIEW_CTX | VIEW_BOT), self.en_cur, '26 84', TRUE, (VIEW_CTX | VIEW_TOP), '1 6', AXIS_V);
  hud_renderShield('215 92', (VIEW_BOT | VIEW_CTX), self.sh_cur, '90 12', TRUE, (VIEW_LFT | VIEW_TOP), '0 10', AXIS_H);
  hud_renderArmorGraph('170 45', (VIEW_CTX | VIEW_BOT), self.hp_ctor, self.hp_stor, self.hp_stor2, self.hp_arm, self.hp_arm2, self.hp_leg);
  
  //TARGET STATS
  if(self.stat_trg_vid > 0 && self.stat_trg_vid != 255){
    hud_renderShield('-125 92', (VIEW_BOT | VIEW_CTX), self.target_shield, '90 12', TRUE, (VIEW_LFT | VIEW_TOP), '0 10', AXIS_H);
    if(self.target_datatype == DATA_MECH){
      hud_renderArmorGraph('-170 45', (VIEW_CTX | VIEW_BOT), self.stat_trg_ct_hp, self.stat_trg_lt_hp, self.stat_trg_rt_hp,self.stat_trg_la_hp, self.stat_trg_ra_hp, self.stat_trg_lg_hp);
    }
    else if(self.target_datatype == DATA_VEHC){
      hud_renderArmorBuilding('-42 45', (VIEW_CTX | VIEW_BOT), '128 64', self.stat_trg_ct_hp);
    }
    else if(self.target_datatype == DATA_BLD){
      hud_renderArmorBuilding('-106 45', (VIEW_CTX | VIEW_BOT), '64 64', self.stat_trg_ct_hp);
    }
  }
  
  //MECH WEAPON DISPLAY
  hud_renderWeapon('205 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w1_id, WEAPON1, self.stat_w1_rel);
  hud_renderWeapon('168 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w3_id, WEAPON3, self.stat_w3_rel);
  hud_renderWeapon('131 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w2_id, WEAPON2, self.stat_w2_rel);
 
  //RADAR DISPLAY
  hud_renderRadar('60 90', (VIEW_CTX | VIEW_BOT), self.i_faction, self.origin, self.radar_range, self.stat_rdr_mode, '90 90');
 
  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(self.stat_hit_dirs);
  hud_renderCrosshairs(getstati(STAT_LCK_STT), 0, getstatf(STAT_SPR_X), getstatf(STAT_SPR_Y));
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x * -3, 270, -270);
  hud_renderTargetDirection(self.stat_trg_face);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), self.stat_ret_dist) ;
  
  hud_renderNavHeading( '8 16', (VIEW_CTX | VIEW_TOP), self.angles);
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
    tpos_z = tpos_z + zht + (zht / 2 );
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
    tofs = VIEW_CTR + gui_percentToPixelRawVec('34 155');
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
    tofs = gui_calcAlign('-34 55', (VIEW_BOT | VIEW_CTX));
    drawstring(tofs, "[LOCKED ON]", '6 6 0', CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0);
    gui_renderTintImage(TRUE, (VIEW_CTR - gui_percentToPixelRawVec('12 12')), HUT_RET_LOK, gui_percentToPixelRawVec('24 24'), CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  }
};