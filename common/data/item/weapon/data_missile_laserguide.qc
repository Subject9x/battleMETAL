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
  local vector ang;

  traceline(self.wepFireOffset, self.wepFireOffset + (v_forward * 2.1), FALSE, self.owner);
  
  ang = vectoangles(trace_endpos - self.wepFireOffset);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.33 + (random() * 0.67)) * 100, SOUNDFLAG_DYNAMIC_INT);
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_LGM_MUZZLE"), self.wepFireOffset + (v_forward * 2) + (v_right * -0.65), normalize((self.wepFireOffset + v_up * 2) - self.wepFireOffset), 1);
    pointparticles( particleeffectnum("TE_LGM_MUZZLE"), self.wepFireOffset + (v_forward * 2) + (v_right * 0.65), normalize((self.wepFireOffset + v_up * 2) - self.wepFireOffset), 1);
    pointparticles( particleeffectnum("TE_LGM_MUZZLE"), self.wepFireOffset + (v_forward * 2) + (v_up * 1), normalize((self.wepFireOffset + v_up * 2) - self.wepFireOffset), 1);
  
    trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), trace_endpos + (v_right * 0.5), trace_endpos + (v_forward * 16) + (v_right * 0.5) );
    trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), trace_endpos + (v_right * -0.5), trace_endpos + (v_forward * 16) + (v_right * -0.5) );
  }
};
#endif
void() data_ini_missile_laserguide_={

  self.data_idx = UID_ITEM_missile_laserguide;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.22;
  self.reloadMax = 3.75;
  self.energyRate = 0;
  
  self.w_range = 2400;
  self.damageValue = 65; //45 v4.0.0-
  self.damageType = DMG_EXP | EFF_PTR;

  self.techLevel = 1;
  self.equipSize = MIS1;

  self.spreadDefault = '0.03 0.03 0';
  self.wepFireOffset = '0 0 2';
  self.burstRate = 1;
  
#ifdef CSQC
  precache_sound("sound/weapons/mis_fire.ogg");
  precache_sound("sound/weapons/mis_fire_int.ogg");
  precache_model("models/weapons/w_lgm.md3");
  precache_file( "gfx/ui/wep_icons/wi_mlgd.png");
  self.w_name = "Missile - Guided";
  self.fire_sound = "sound/weapons/mis_fire%s.ogg";
  self.model = "models/weapons/w_lgm.md3"; 
  self.abbrev = "MLGD";
  self.description = "+ Bonus 33% damage to BUILDINGS. + target <shields> reduce damage. + Missile will follow your reticle. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
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