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
#ifdef SSQC
void() data_ini_attack_missile_laserguide_;
#endif

#ifdef CSQC
void() te_muzzle_lgm={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, startOrg + (v_forward * 2.1), FALSE, self.owner);
  endOrg = trace_endpos;
  
  local vector ang;
  ang = vectoangles(endOrg - startOrg);
  
  sound7(self, CHAN_AUTO, "sound/weapons/mis_fire.ogg", 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 80, 0 );
  
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), startOrg + (v_forward * 2) + (v_right * -0.65), normalize((startOrg + v_up * 2) - startOrg), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), startOrg + (v_forward * 2) + (v_right * 0.65), normalize((startOrg + v_up * 2) - startOrg), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), startOrg + (v_forward * 2) + (v_up * 1), normalize((startOrg + v_up * 2) - startOrg), 1);
  
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), endOrg + (v_right * 0.5), endOrg + (v_forward * 16) + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), endOrg + (v_right * -0.5), endOrg + (v_forward * 16) + (v_right * -0.5) );
};
#endif
void() data_ini_missile_laserguide_={

  self.data_idx = UID_ITEM_missile_laserguide;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.22;
  self.reloadMax = 3.75;
  self.energyRate = 0;
  
  self.w_range = 2400;
  self.damageValue = 45;
  self.damageType = DMG_EXP | EFF_PTR;

  self.techLevel = 1;
  self.equipSize = MIS1;

  self.spreadDefault = '0.03 0.03 0';
  self.wepFireOffset = '0 0 2';
  self.burstRate = 1;
  
#ifdef CSQC
  self.w_name = "Missile - Guided";
  self.fire_sound = "sound/weapons/mis_fire.ogg";
  self.model = "q3mdl/weapons/w_lgm.md3"; 
  self.abbrev = "MLGD";
  self.description = "+ target <shields> reduce damage. + Missile will follow your reticle. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
  self.icon = "gfx/ui/wep_icons/wi_mlgd.png"; 
  self.itemMuzzleFlash = te_muzzle_lgm;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_missile_laserguide_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_laserguide_;
#endif
};

#ifdef SSQC
void() data_ini_attack_missile_laserguide_={
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
   
  ctrl_weapon_make_projectile( 0.01 );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif