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
void() data_ini_attack_ion_;

void() data_ini_ion_={

  self.data_idx = 13;  
  self.w_name = "Ion Coil";
  
  self.w_clipsize = 3;
  self.reloadRate = 0.12;
  self.reloadMax = 5;
  self.energyRate = 133.3;
  self.spreadDefault = '0.018 0.013 0';
  
  self.w_range = 800;
  self.damageValue = 75;
  self.damageType = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.w_attack = data_ini_attack_ion_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_ion_;
  
  self.w_fire_ofs = '0 0 4';
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_ion.md3";
  self.techLevel = 1;
  self.i_size = 2;
  
  self.w_isburst = FALSE;
  
  self.abbrev = "ION";
  self.description = "3-Round burst. | Damages Shields ONLY. | Small proximity detonation.~";
  self.icon = "gfx/ui/wep_icons/wi_ion.png";
};

void() data_ini_attack_ion_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE, 1 );
  
  ctrl_weapon_make_projectile( 0.01 );
  if( NEWSHOT ){
    NEWSHOT.w_firetime = time + 0.5;
  }
  
  sound (NEWSHOT, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ION_MUZZLE"), FIRE_ORIGIN + v_forward * 3 + v_up * 0.1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 1);
};
