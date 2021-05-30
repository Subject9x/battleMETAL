/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  External Camera HUD layout, this is universal for all mechs.
  This is activated when player kicks on "chase_active" and it overrides
  the hud file
*/

/*
  Weapons in External Camera are updated programmatically
*/
void() data_hud_external={
  local float weaponId;
  local vector drawOrg;
  local float wepBit;
  local float realWeapons;
  local entity theWep;

  if( HUD_ZOOM_ACTIVE == FALSE){
    
    HUD_TXT_ORG = '0 45 0';
    HUD_TXT_SIZE = '16 16';
    HUD_TXT_ALIGN = 17;
    
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
          hud_renderWeapon(drawOrg, '24 24', 0, wepBit );
          realWeapons = realWeapons + 1;
        }
      }
      weaponId = weaponId + 1;
    }
  }
};