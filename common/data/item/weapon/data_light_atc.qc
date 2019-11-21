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
#ifndef CSQC
void() data_ini_attack_latc_;
#endif

void() data_ini_light_atc_={

  self.data_idx = 1;  
  self.w_name = "Light Autocannon";
  
  self.w_clipsize = 3;
  self.reloadRate = 0.075;
  self.reloadMax = 1.15;
  self.energyRate = 0;
  
  self.w_range = 1800;
  self.damageValue = 5;
  self.damageType = DMG_BAL;

  self.techLevel = 1;
  self.i_size = 1;
  
  #ifdef CSQC  
  self.abbrev = "ATC";
  self.description = "+ Instant-impact weapon.";
  self.icon = "gfx/ui/wep_icons/wi_atc.png";
  #endif
  
  #ifndef CSQC  
  self.spreadDefault = '0.025 0.025 0';
  self.w_attack = data_ini_attack_latc_;
  self.think = default_weapon_think;
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0.5 5';
  self.fire_sound = "sound/weapons/atc_fire.ogg";
  self.model = "q3mdl/weapons/w_atc.md3";
  #endif
};

#ifndef CSQC
void() data_ini_attack_latc_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
  
  pointparticles( particleeffectnum("TE_ATC_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 1);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  
  if( vlen(FIRE_ENDPOINT - FIRE_ORIGIN) > 100 )
    pointparticles( particleeffectnum("TE_ATC_TRACER"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1400, 1);
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) )
    return;
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) )
      pointparticles( particleeffectnum("TE_ATC_DIRT"), FIRE_ENDPOINT + (v_up *1), normalize( (FIRE_ENDPOINT + (v_up *1)) - FIRE_ENDPOINT ) * 20, 1);
    
    return;
  }
  
  if( trace_ent ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, DMG_BAL, FIRE_ENDPOINT, '0 0 0');    
    if( trace_ent.shield <= 0 )
      pointparticles( particleeffectnum("TE_ATC_ARMOR"), FIRE_ENDPOINT + v_forward * -3, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 3);
  }
};
#endif