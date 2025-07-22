/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Light Autocannon
      Range: Long
      Rapid fire
      low accuracy
*/
#ifdef SSQC
void() data_ini_attack_latc_;
#endif

#ifdef CSQC
void() te_muzzle_latc={
  local vector ang;
  
  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  ang = vectoangles(trace_endpos - self.wepFireOffset);
  
  particleDraw = vlen(trace_endpos - self.wepFireOffset);
  if( particleDraw >= 1500 ){
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 100, 0 );
  }
  else{
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.67 + (random() * 0.33)) * 125, 0 );
  }
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_ATC_MUZZLE"), self.wepFireOffset, normalize(trace_endpos - self.wepFireOffset) * 4, 1);
  }
};
#endif
void() data_ini_light_atc_={

  self.data_idx = UID_ITEM_light_autocannon;
  
  if( (self.owner.flags & FL_CLIENT) ){
    self.w_clipsize = 1;
    self.reloadRate = 0.32;
    self.reloadMax = 0.32;
  }
  else{
    self.w_clipsize = 3;
    self.reloadRate = 0.5;
    self.reloadMax = 1.0;
  }
  
  self.damageValue = 9.0; //5.0 - v5.4.8
  self.energyRate = 0;
  self.w_range = 3200;  
  self.damageType = DMG_BAL;
  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '3.0 3.0 0.0';
  self.wepFireOffset = '0 0.5 5';
  self.burstRate = 1;
  
#ifdef CSQC  
  precache_sound("sound/weapons/atc_fire.ogg");
  precache_model("models/weapons/w_atc.md3");
  precache_file( "gfx/ui/wep_icons/wi_atc.png");
  self.w_name = "Light Autocannon";
  self.abbrev = "ATC";
  self.description = "+ Instant-impact weapon. + fully automatic, hold down trigger to fire. + Better against <Armor>.";
  self.icon = "gfx/ui/wep_icons/wi_atc.png";
  self.model = "models/weapons/w_atc.md3";
  self.fire_sound = "sound/weapons/atc_fire.ogg";
  self.itemMuzzleFlash = te_muzzle_latc;
  self.w_clipsize = 1;
  self.reloadRate = 0.3;
  self.reloadMax = 0.3;
  self.damageValue = 5;
#endif

#ifdef SSQC  
  self.w_attack = data_ini_attack_latc_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_latc_;
  self.w_isburst = FALSE;
#endif
};

#ifdef SSQC
void() data_ini_attack_latc_={
  
  ctrl_weapon_fireOffset();
  
  ctrl_weapon_updateAmmo( TRUE );
  
  ctrl_weapon_make_projectile( -1 );

  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif