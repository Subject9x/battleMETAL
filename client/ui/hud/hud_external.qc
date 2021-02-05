/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  External Camera HUD layout, this is universal for all mechs.
  This is activated when player kicks on "chase_active" and it overrides
  the hud file
*/
void() data_hud_external_cam_frame={
  local float hasTarget;
  local float weaponId;
  
  local vector drawOrg;
  local float wepBit;
  local float realWeapons;
  local entity theWep;
    
  hasTarget = FALSE;
  if( CLIENT_stat_trg_dataidx > 0 ){
    hasTarget = TRUE;
  }
  
  if( HUD_ZOOM_ACTIVE == FALSE){
    //Screen - Bottom Left
    //HUD_UID_ARM_PLAYER
      hud_renderArmorGraph('45 60', 6, CLIENT_health_center, CLIENT_health_torso_left, CLIENT_health_torso_right, CLIENT_health_arm_left, CLIENT_health_arm_right, CLIENT_health_legs, FALSE);
    //HUD_UID_ENERGY:
      hud_renderEnergy('90 98', 6, CLIENT_energy, '22 88', 1, 17, '0 6', 2);
    //HUD_UID_SHIELD_PLAYER
      hud_renderShield('118 98', 6, CLIENT_shield, '22 88', 1, 17, '0 6', 2, TRUE);
    //HUD_UID_RAM_METER:
      hud_render_ram('145 98', '24 96', getstatf(STAT_RAM_VALUE) * 100, 6, 2, '2 10', 17);
    //HUD_UID_RADAR_GRAPH
      hud_renderRadar('20 185', 6, CLIENT_faction, pmove_org, CLIENT_radar_range, CLIENT_stat_rdr_mode, '75 75');
    //HUD_UID_RADAR_TYPE2
      hud_renderRadarStatus2('133 165', 6, CLIENT_stat_rdr_mode, CLIENT_radar_range, 0);
    //HUD_UID_MSN_CLOCK
      hud_render_missionClock( '180 56', 6, 0);
        
    //Screen - Bottom Right
    //HUD_UID_ARM_TARGET
    if( hasTarget ){
      switch(CLIENT_target_datatype){
        case DATA_MECH:
          hud_renderArmorGraph('45 64', 10, CLIENT_stat_trg_ct_hp, CLIENT_stat_trg_lt_hp, CLIENT_stat_trg_rt_hp, CLIENT_stat_trg_la_hp, CLIENT_stat_trg_ra_hp, CLIENT_stat_trg_lg_hp, TRUE);
          break;
          
       case DATA_VEHC:
          hud_renderArmorBuilding('85 64', 10, '32 68', CLIENT_stat_trg_ct_hp);
          break;
        
        case DATA_BLD:
          hud_renderArmorBuilding('85 54', 10, '48 64', CLIENT_stat_trg_ct_hp);
          break;
      }
      hud_renderTargetName('100 126', 10);
      hud_renderTargetRange('100 116', CLIENT_target_origin, pmove_org, 10);
      hud_renderShield('110 92', 10, CLIENT_target_shield, '18 75', 1, 5, '2 6', 2, FALSE);
      
    }
    
  //Screen - Center Top
    //hud_renderNavHeading( '8 12', 17, input_angles);
    
    HUD_TXT_ORG = '0 45 0';
    HUD_TXT_SIZE = '16 16';
    HUD_TXT_ALIGN = 17;
  
  //HUD_UID_ENVIRO_BOX
    HUD_WARN_ENV_ORG = '0 200';
    
    hud_render_sprint(VIEW_CTR + gui_percentToPixelRawVec('0 -225'));
    
    weaponId = 0;
    realWeapons = 0;
    while( weaponId < 10 ){
      wepBit =  bitshift(1, weaponId);
      if( (CLIENT_weapon_state & wepBit) ){
        theWep = gui_get_weapon(wepBit);
        if( theWep.data_idx > 0 ){
          drawOrg = '0 0';
          drawOrg_x = drawOrg_x + (realWeapons * 28);
          drawOrg_y = drawOrg_y - 20;
          hud_renderWeapon(drawOrg, '24 24', 0, CLIENT_currentWeaponGroup, wepBit );
          realWeapons = realWeapons + 1;
        }
      }
      weaponId = weaponId + 1;
    }
  }
};