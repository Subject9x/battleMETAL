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
  
  
  hud_renderEnergy('102 87', (VIEW_CTX | VIEW_BOT), self.en_cur, '26 84', TRUE, (VIEW_CTX | VIEW_TOP), '1 6', AXIS_V);
  hud_renderShield('215 92', (VIEW_BOT | VIEW_CTX), self.sh_cur, '90 12', TRUE, (VIEW_LFT | VIEW_TOP), '0 10', AXIS_H);
  hud_renderArmorGraph('170 45', (VIEW_CTX | VIEW_BOT), self.hp_ctor, self.hp_stor, self.hp_stor2, self.hp_arm, self.hp_arm2, self.hp_leg);
  
  hud_renderWeapon('205 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w1_id, WEAPON1, self.stat_w1_rel);
  hud_renderWeapon('168 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w3_id, WEAPON3, self.stat_w3_rel);
  hud_renderWeapon('131 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w2_id, WEAPON2, self.stat_w2_rel);
 
  hud_renderRadar('60 90', (VIEW_CTX | VIEW_BOT), self.i_faction, pmove_org, self.radar_range, self.stat_rdr_mode, '90 90');
 
  hud_renderDirectionHit(self.stat_hit_dirs);
  hud_renderCrosshairs(getstati(STAT_LCK_STT), 0, getstatf(STAT_SPR_X), getstatf(STAT_SPR_Y));
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x *-3, 270, -270);
  hud_renderTargetDirection(self.stat_trg_face);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), self.stat_ret_dist) ;
  
  hud_renderNavHeading( '8 16', (VIEW_CTX | VIEW_TOP), self.angles);
};

/*
  RADAR LAYOUT====================================================
*/
void(float rad_mode, float rad_range, float i_fact) otl_Radar={
  local vector rorg, lbl1, lbl2,  clr;
  local string mode;
  local float len, badj;
  rorg = gui_percentToPixelRawVec('72 135');
  rorg = gui_calcAlign(rorg, (VIEW_CTX | VIEW_BOT));
  lbl1 = rorg + gui_percentToPixelRawVec('10 10');
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
  drawstring(lbl1 + gui_percentToPixelRawVec('0 6'), strcat("SCALE:", ftos(rad_range), "m"), '6 6 0', clr, HUD_ALPHA, 0);
  
  local vector mpos, cprc;
  mpos = rorg + gui_percentToPixelRawVec('12 45');
  cprc = mpos + gui_percentToPixelRawVec('45 45');
  
  //hud_RenderRadar (cprc, rad_range, gui_percentToPixelRawVec('90 90'), i_fact);
};

/*
  RENDER TARGET====================================================
*/
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) otl_renderTarget={

  if((trglock & LOCK_PLYR)){  
    local vector pofs;
    pofs = self.hud_pnl2.pos + self.hud_pnl2.hsize + gui_percentToPixelRawVec('28 18');
    local float f;
    f = (time - (2 * floor(time/2)));
    if(f > 1){
      drawstring(pofs, "[INCOMING]", '6 6 0', CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0);
    }
  }
  
  if(trgvid > -1 && trgvid != 255){
    data_get_target(self.target_datatype, self.stat_trg_vid, self.target_vecsize);
    cons_logAString("t name", buffer_TargetInfo[0]);
    
    local vector ofs, rofs, spos, apos;
    local string dist;
    ofs = rofs = gui_percentToPixelRawVec('71 136');
    ofs = rofs = gui_calcAlign(rofs, (VIEW_CTX | VIEW_BOT));
    drawstring((ofs + gui_percentToPixelRawVec('8 26')), "[TARGET]", '6 6 0', STATUS_DMG, HUD_ALPHA, 0);
    drawstring((ofs + gui_percentToPixelRawVec('58 26')), buffer_TargetInfo[0], '6 6 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderTintImage(TRUE, (ofs + gui_percentToPixelRawVec('165 32')), HUD_TRG_PIP_R, '8 24', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
    apos = tpos;
    spos = cs_project(apos);
    if (spos_z >= 0) {
      local vector i_sz, tclr;
      i_sz = draw_getimagesize(HUD_TARGET_BOX);
      i_sz = gui_scaleSize(i_sz, VIEW_SCALE);
      spos_x -= i_sz_x/2; //align horizontally to centre
      spos_y -= i_sz_y/2; //align vertically again
      spos_z = 0; //shut up dp.
      if(self.target_faction == self.i_faction){
        tclr = CLR_DEF_IIF_FRIEND;
      }
      else{
        tclr = CLR_DEF_IFF_ENEMY;
      }
      drawpic(spos, HUD_TARGET_BOX, i_sz, tclr, HUD_ALPHA, 0);
    }
    if(self.target_datatype == DATA_MECH){
      //self.hud_targetArmor(getstatf(STAT_TRG_LEG_HP), getstatf(STAT_TRG_CTOR_HP), getstatf(STAT_TRG_LTOR_HP),
                 //         getstatf(STAT_TRG_RTOR_HP), getstatf(STAT_TRG_LARM_HP), getstatf(STAT_TRG_RARM_HP));
      
    }
    else if(self.target_datatype == DATA_BLD){
      /*local vector pnl_ctr;
      pnl_ctr_x = self.hud_pnl5.pos_x + self.hud_pnl5.asize_x/2;
      pnl_ctr_y = self.hud_pnl5.pos_y + self.hud_pnl5.asize_y/2;
      pnl_ctr = pnl_ctr;
      hud_renderArmorBuilding(getstatf(STAT_TRG_CTOR_HP), pnl_ctr + gui_percentToPixelRawVec('0 12'), gui_percentToPixelRawVec('78 56'));*/
    }
    else if(self.target_datatype == DATA_VEHC){
    
    }

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