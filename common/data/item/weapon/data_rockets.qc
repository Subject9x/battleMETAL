/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Rocket Pack
      Range: Short
      6rnd Burst.
      low accuracy.
*/
#ifdef SSQC
void() data_ini_attack_rockets_;
#endif

#ifdef CSQC
void() te_muzzle_rck={

  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.25 + (random() * 0.75)) * 133, SOUNDFLAG_DYNAMIC_INT);
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){  
    pointparticles( particleeffectnum("TE_MIS_MUZZLE"), self.wepFireOffset, normalize(trace_endpos - self.wepFireOffset), 1);
  }
}
#endif
void() data_ini_rockets_={

  self.data_idx = UID_ITEM_rocket_launcher;  
  
  self.w_clipsize = 1;
  self.reloadRate = 1.4; //1.25 v4.0.0-
  self.reloadMax = 1.4; //1.25 v4.0.0-
  self.energyRate = 0;
  
  self.w_range = 1800;
  self.damageValue = 43;  //55
  self.damageType = DMG_EXP;
  
  self.techLevel = 1;
  self.equipSize = MIS1;
  
  self.wepFireOffset = '0 0 3';
  self.spreadDefault = '6.0 6.0 0';
  self.burstRate = 1.75;
  
#ifdef CSQC
  precache_sound("sound/weapons/rckt_fire.ogg");
  precache_sound("sound/weapons/rckt_fire_int.ogg");
  precache_model("models/weapons/w_mis.md3");
  precache_file( "gfx/ui/wep_icons/wi_rck.png");
  self.w_name = "Rocket Launcher";
  self.fire_sound = "sound/weapons/rckt_fire%s.ogg";
  self.model = "models/weapons/w_mis.md3";
  self.abbrev = "RCK";
  self.description = "+ Bonus 33% damage to BUILDINGS. + target <shields> reduce damage. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
  self.icon = "gfx/ui/wep_icons/wi_rck.png";
  self.itemMuzzleFlash = te_muzzle_rck;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_rockets_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_rocket_;
#endif
};

#ifdef SSQC
void() data_ini_attack_rockets_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
   
  self.owner.punchangle_x = -1 + crandom() * -1;
  self.owner.punchangle_y = -1 + crandom() * -1;

  ctrl_weapon_make_projectile( 0.01 );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif