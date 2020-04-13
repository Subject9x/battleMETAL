/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Snub Field Artillery
      Range: Medium
      Medium AoE
      Arcing
*/
#ifndef CSQC
void() data_ini_attack_snub_artillery_;
#endif

void() data_ini_snub_artillery_={

  self.data_idx = 11;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 10;
  self.energyRate = 0;
  
  self.w_range = 3500;  //1000
  self.damageValue = 300;
  self.damageType = (DMG_BAL | EFF_ARC);

  self.techLevel = 2;
  self.equipSize = BAL3;

  self.wepFireOffset = '0 0 9';
  self.spreadDefault = '0.02 0.02 0';
  
  #ifdef CSQC
    self.w_name = "Snub Field Artillery";
    self.fire_sound = "sound/fx_boom.ogg";
    self.model = "q3mdl/weapons/w_sfga.md3";
    self.abbrev = "SFGA";
    self.description = "+ Minor parabolic arc. + Shot has Blast Radius on open ground.";
    self.icon = "gfx/ui/wep_icons/wi_sfg.png";
  #endif 
  
  #ifndef CSQC
    self.model = "q3mdl/weapons/w_sfga.md3";
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.w_attack = data_ini_attack_snub_artillery_;
    self.think = default_weapon_think;
    self.data_ini_projectile = data_projectile_ini_snub_artillery_;
  #endif
};
#ifndef CSQC
void() data_ini_attack_snub_artillery_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  ctrl_weapon_make_projectile( -1 );
  if((FIRE_ENT.flags & FL_CLIENT)){
    FIRE_ENT.punchangle_x = -1 + (crandom() * -2);
    FIRE_ENT.punchangle_y = -1 + (crandom() * -2);
  }
  
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, 0);
};
#endif