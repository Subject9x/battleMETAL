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
#ifdef SSQC
void() data_ini_attack_snub_artillery_;
#endif
#ifdef CSQC
void() te_muzzle_sfg={

  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.75 + (random() * 0.33)) * 100, SOUNDFLAG_DYNAMIC_INT);
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){  
    pointparticles( particleeffectnum("TE_SFGA_MUZZLE"), self.wepFireOffset, normalize(trace_endpos - self.wepFireOffset) * 2, 1);
  }
}
#endif
void() data_ini_snub_artillery_={

  self.data_idx = UID_ITEM_snub_artillery;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 10;
  self.energyRate = 0;
  
  self.w_range = 3500;
  self.damageValue = 300;
  self.damageType = (DMG_BAL | EFF_ARC);

  self.techLevel = 2;
  self.equipSize = BAL3;

  self.wepFireOffset = '0 0 9';
  self.spreadDefault = '0.02 0.02 0';
  self.burstRate = 0;
  
#ifdef CSQC
  precache_sound("sound/weapons/sfga_fire.ogg");
  precache_sound("sound/weapons/sfga_fire_int.ogg");
  precache_sound("sound/weapons/sfga_reload.ogg");
  precache_model("models/weapons/w_sfga.md3");
  precache_file( "gfx/ui/wep_icons/wi_sfg.png");
  self.w_name = "Snub Field Artillery";
  self.fire_sound = "sound/weapons/sfga_fire%s.ogg";
  self.reload_sound = "sound/weapons/sfga_reload.ogg";
  self.model = "models/weapons/w_sfga.md3";
  self.abbrev = "SFGA";
  self.description = "+ Minor parabolic arc. + Shot has Blast Radius on open ground.";
  self.icon = "gfx/ui/wep_icons/wi_sfg.png";
  self.itemMuzzleFlash = te_muzzle_sfg;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_snub_artillery_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_snub_artillery_;
#endif
};
#ifdef SSQC
void() data_ini_attack_snub_artillery_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  ctrl_weapon_make_projectile( -1 );
  if((FIRE_ENT.flags & FL_CLIENT)){
    FIRE_ENT.punchangle_x = -1 + (crandom() * -2);
    FIRE_ENT.punchangle_y = -1 + (crandom() * -2);
  }
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  self.SendFlags = self.SendFlags | SENDFLAG_ATTACK;
};
#endif