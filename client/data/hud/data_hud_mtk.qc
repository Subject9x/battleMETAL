/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
  refac 03/03/2017
Overview: Hud Layout data for mech 'matok'
*/

//entry point
void() hud_mtk_frame={
  local vector img_sz;
  img_sz = '575 180';
  hud_HelmetImage('287.5 170', img_sz, HUD_MTK_IMG_B, (VIEW_CTX | VIEW_BOT), HUD_ALPHA, CLR_DEF_WHITE); 
  
  //PLAYER STATS
  hud_renderEnergy('72 98', (VIEW_LFT | VIEW_BOT), self.en_cur, '22 82', TRUE, (VIEW_CTX | VIEW_TOP), '0 6', AXIS_V);
  hud_renderShield('94 98', (VIEW_RGT | VIEW_BOT), self.sh_cur, '22 82', TRUE, (VIEW_CTX | VIEW_TOP), '0 6', AXIS_V);
  hud_renderArmorGraph('160 70', (VIEW_LFT | VIEW_BOT), self.hp_ctor, self.hp_stor, self.hp_stor2, self.hp_arm, self.hp_arm2, self.hp_leg);
 
  //MECH WEAPON DISPLAY
  //RIGHT WEAPONS
  hud_renderWeapon2('-118 -58', '24 24', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w1_id, WEAPON1, self.stat_w1_rel);
  hud_renderWeapon2('-163 -58', '24 24', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w3_id, WEAPON3, self.stat_w3_rel);
  
  //LEFT WEAPONS
  hud_renderWeapon2('145 -58', '24 24', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w2_id, WEAPON2, self.stat_w2_rel);
  hud_renderWeapon2('188 -58', '24 24', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w4_id, WEAPON4, self.stat_w4_rel);
  
  //CENTER WEAPON
  hud_renderWeapon2('72 -60', '24 24', (VIEW_CTX | VIEW_CTY), self.currentWeaponGroup, self.stat_w5_id, WEAPON5, self.stat_w5_rel);
 
  //RADAR DISPLAY
  hud_renderRadar('200 110', (VIEW_RGT | VIEW_BOT), self.i_faction, pmove_org, self.radar_range, self.stat_rdr_mode, '85 85');
  hud_renderRadarStatus1('24 -88', (VIEW_CTX | VIEW_CTY), self.stat_rdr_mode, self.radar_range, 0);
  
  //TARGET STATS
  if(self.stat_trg_dataidx > 0 && self.stat_trg_dataidx != 255){   
    hud_renderShield('-55 92', (VIEW_BOT | VIEW_CTX), self.target_shield, '18 75', TRUE, (VIEW_LFT | VIEW_TOP), '2 6', AXIS_V);
    hud_renderTargetOverlay(self.target_origin, pmove_org, 0, self.i_faction, self.target_faction, self.radar_range);
    hud_renderShieldOverlay(self.target_origin, pmove_org, 0, self.target_shield, self.radar_range, self.target_vecsize, '64 4', AXIS_H);
    if(self.target_datatype == DATA_MECH){
      hud_renderArmorGraph('-12 64', (VIEW_CTX | VIEW_BOT), self.stat_trg_ct_hp, self.stat_trg_lt_hp, self.stat_trg_rt_hp,self.stat_trg_la_hp, self.stat_trg_ra_hp, self.stat_trg_lg_hp);
    }
    else if(self.target_datatype == DATA_VEHC){
      hud_renderArmorBuilding('-42 45', (VIEW_CTX | VIEW_BOT), '128 64', self.stat_trg_ct_hp);
    }
    else if(self.target_datatype == DATA_BLD){
      hud_renderArmorBuilding('6 55', (VIEW_BOT | VIEW_CTX), '36 75', self.stat_trg_ct_hp);
    }
    data_get_target(self.target_datatype, self.stat_trg_dataidx, self.target_vecsize);
    
    hud_renderTargetName('85 126', buffer_TargetInfo[0], (VIEW_CTX | VIEW_BOT));
    hud_renderTargetRange('85 116', self.target_origin, pmove_org, (VIEW_CTX | VIEW_BOT));
  }
  
  //CROSSHAIR AND DETAILS
  hud_renderDirectionHit(self.stat_hit_dirs);
  hud_renderCrosshairs(getstati(STAT_LCK_STT), 0, getstatf(STAT_SPR_X), getstatf(STAT_SPR_Y));
  hud_renderPitchIndicator('64 0', (VIEW_CTX | VIEW_CTY), input_angles_x * -3, 270, -270);
  hud_renderTargetDirection(self.stat_trg_face);
  hud_renderReticleRange('0 -24', (VIEW_CTX | VIEW_CTY), self.stat_ret_dist) ;
  hud_renderNavHeading( '8 16', (VIEW_CTX | VIEW_TOP), self.angles);  
  
  //repair sits above all
  hud_renderRepairValue(getstatf(STAT_PLR_REP));
};