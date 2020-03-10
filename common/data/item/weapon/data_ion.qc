/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Weapon
    Ion
      range: medium
      Shield breaking.
      Small AoE.
      Consumes Energy.
*/
#ifndef CSQC
void() data_ini_attack_ion_;
#endif

void() data_ini_ion_={

  self.data_idx = 13;  
  self.w_name = "Ion Coil";
  
  self.w_clipsize = 3;
  self.reloadRate = 0.12;
  self.reloadMax = 5;
  self.energyRate = 120;
  
  self.w_range = 800;
  self.damageValue = 75;
  self.damageType = (DMG_ENE | EFF_STX | EFF_ENE);

  self.techLevel = 1;
  self.equipSize = 2;
  
  #ifdef CSQC
  self.abbrev = "ION";
  self.description = "+ Damages <shields> ONLY. + 3-Round burst. + Small proximity detonation.";
  self.icon = "gfx/ui/wep_icons/wi_ion.png";
  #endif
  
  #ifndef CSQC
  self.spreadDefault = '0.018 0.013 0';
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0 4';
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_ion.md3";
  self.w_attack = data_ini_attack_ion_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_ion_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_ion_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
  
  ctrl_weapon_make_projectile( 0.01 );
  if( NEWSHOT ){
    NEWSHOT.w_firetime = time + 0.5;
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN + v_forward * 3 + v_up * 0.1, FIRE_ENDPOINT );
};
#endif
