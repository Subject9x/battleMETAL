/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Rotary Plasma Chamber
      Range: Medium
      8rnd Burst.
      medium accuracy.
      projectiles burn unshielded targets.
*/
#ifndef CSQC
void() data_ini_attack_plasma_;
#endif
void() data_ini_plasma_={

  self.data_idx = 6;  
  self.w_name = "Rotary Plasma Chamber";
  
  self.w_clipsize = 6;
  self.reloadRate = 0.18;
  self.reloadMax = 5;
  self.energyRate = 0;
  
  self.w_range = 1000;
  self.damageValue = 10;
  self.damageType = DMG_BAL;
  
  self.techLevel = 3;
  self.equipSize = 2;
  
  #ifdef CSQC  
  self.abbrev = "RPC";
  self.description = "+ Burst-Fires 6 sub-munitions. + Submunitions burn over time on unshielded targets.";
  self.icon = "gfx/ui/wep_icons/wi_rpc.png";
  #endif 
  
  #ifndef CSQC
  self.spreadDefault = '0.015 0.015 0';
  self.w_isburst = FALSE;
  self.burstRate = 1.5;
  self.wepFireOffset = '0 0 6';
  self.fire_sound = "sound/weapons/rpls_fire.ogg";
  self.model = "q3mdl/weapons/w_rpc.md3";
  self.w_attack = data_ini_attack_plasma_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_plasma_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_plasma_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
   
  pointparticles( particleeffectnum("TE_RPC_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 2, 1);
  
  ctrl_weapon_make_projectile( -1 );
  sound (self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM);
};
#endif