/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
  refac 03/01/2017
Overview: Hud Layout data for mech 'outlaw'
*/

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

  //MECH WEAPON DISPLAY
  hud_renderWeapon('205 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w1_id, WEAPON1, self.stat_w1_rel);
  hud_renderWeapon('168 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w3_id, WEAPON3, self.stat_w3_rel);
  hud_renderWeapon('131 -42', '32 32', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w2_id, WEAPON2, self.stat_w2_rel);
 
  //RADAR DISPLAY
  hud_renderRadar('60 90', (VIEW_CTX | VIEW_BOT), self.i_faction, self.origin, self.radar_range, self.stat_rdr_mode, '90 90');
 
   
  //TARGET STATS
  if(self.stat_trg_vid > 0 && self.stat_trg_vid != 255){   
    hud_renderShield('-125 92', (VIEW_BOT | VIEW_CTX), self.target_shield, '90 12', TRUE, (VIEW_LFT | VIEW_TOP), '0 10', AXIS_H);
    hud_renderTargetOverlay(self.target_origin, self.origin, 0, self.i_faction, self.target_faction, self.radar_range);
    hud_renderShieldOverlay(self.target_origin, self.origin, 0, self.target_shield, self.radar_range, self.target_vecsize, '64 4', AXIS_H);
    if(self.target_datatype == DATA_MECH){
      hud_renderArmorGraph('-170 45', (VIEW_CTX | VIEW_BOT), self.stat_trg_ct_hp, self.stat_trg_lt_hp, self.stat_trg_rt_hp,self.stat_trg_la_hp, self.stat_trg_ra_hp, self.stat_trg_lg_hp);
    }
    else if(self.target_datatype == DATA_VEHC){
      hud_renderArmorBuilding('-42 45', (VIEW_CTX | VIEW_BOT), '128 64', self.stat_trg_ct_hp);
    }
    else if(self.target_datatype == DATA_BLD){
      hud_renderArmorBuilding('-106 45', (VIEW_CTX | VIEW_BOT), '64 64', self.stat_trg_ct_hp);
    }
    data_get_target(self.target_datatype, self.stat_trg_vid,self.target_vecsize);
    
    hud_renderTargetName('65 126', buffer_TargetInfo[0], (VIEW_CTX | VIEW_BOT));
    hud_renderTargetRange('65 116', self.target_origin, self.origin, (VIEW_CTX | VIEW_BOT));
  }
 
 
  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(self.stat_hit_dirs);
  hud_renderCrosshairs(getstati(STAT_LCK_STT), 0, getstatf(STAT_SPR_X), getstatf(STAT_SPR_Y));
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x * -3, 270, -270);
  hud_renderTargetDirection(self.stat_trg_face);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), self.stat_ret_dist) ;
  
  hud_renderNavHeading( '8 16', (VIEW_CTX | VIEW_TOP), self.angles);
};