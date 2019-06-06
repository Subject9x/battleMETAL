/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Missile - Laser Guided
      Range: Medium
      High Damage
      follow's player reticle
      Arcing
*/
void() data_ini_attack_missile_laserguide_;

void() data_ini_missile_laserguide_={

  self.data_idx = 9;  
  self.w_name = "Missile - Laser Guide";
  
  self.w_clipsize = 1;
  self.reloadRate = 0.22;
  self.reloadMax = 8;
  self.energyRate = 5;
  self.spreadDefault = '0.03 0.03 0';
  
  self.w_range = 1000;
  self.damageValue = 275;
  self.damageType = (DMG_EXP);
  
  self.w_attack = data_ini_attack_missile_laserguide_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_laserguide_;
  
  self.w_fire_ofs = '0 0 2';
  self.fire_sound = "sound/weapons/mis_fire.ogg";
  self.model = "q3mdl/weapons/w_lgm.md3";
  self.techLevel = 1;
  self.i_size = 1;
  
  self.w_isburst = FALSE;
  
  self.abbrev = "MLGD";
  self.description = "Missile will follow your reticle. | | Does not require [ACTIVE] RADAR. | | Does not require TARGET LOCK.~";
  self.icon = "gfx/ui/wep_icons/wi_mlgd.png";
};

void() data_ini_attack_missile_laserguide_={
  local vector lasOrg;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE, 1 );
   
  ctrl_weapon_make_projectile( 0.05 );
  
  lasOrg = FIRE_ORIGIN + (v_forward * 2.1) + (v_up * -0.5);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), FIRE_ORIGIN + (v_forward * 2) + (v_right * -0.65), normalize((FIRE_ORIGIN + v_up * 2) - FIRE_ORIGIN), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), FIRE_ORIGIN + (v_forward * 2) + (v_right * 0.65), normalize((FIRE_ORIGIN + v_up * 2) - FIRE_ORIGIN), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), FIRE_ORIGIN + (v_forward * 2) + (v_up * 1), normalize((FIRE_ORIGIN + v_up * 2) - FIRE_ORIGIN), 1);
  
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), lasOrg + (v_right * 0.5), lasOrg + (v_forward * 16) + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), lasOrg + (v_right * -0.5), lasOrg + (v_forward * 16) + (v_right * -0.5) );
  
};
