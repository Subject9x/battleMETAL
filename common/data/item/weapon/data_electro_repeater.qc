/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Electro-Static Repeater
      Range - Short
      Consumes Energy
      High Damage
      20rnd Burst
      hit scan
      Inaccurate
*/
#ifndef CSQC
void() data_ini_attack_electro_repeater_;
#endif 

void() data_ini_electro_repeater_={
  
  self.data_idx = 8;
  self.w_name = "ESR";
  
  self.w_clipsize = 10; //20;
  self.reloadRate = 0.07;
  self.reloadMax = 5;
  self.energyRate =  200;
  
  self.w_range = 200;
  self.damageValue = 16;//25;
  self.damageType = DMG_ENE;

  self.techLevel = 2;
  self.equipSize = 2;

  #ifdef CSQC  
  self.abbrev = "ESR";
  self.description = "+ Instant-impact weapon. + Burst-fire. + Inaccurate.";
  self.icon = "gfx/ui/wep_icons/wi_esr.png";
  #endif
  
  #ifndef CSQC
  self.spreadDefault = '0.1 0.1 0';
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0 6'; 
  self.fire_sound = "sound/weapons/esr_fire.ogg";
  self.model = "q3mdl/weapons/w_esr.md3";
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_electro_repeater_;
  #endif
  
};

#ifndef CSQC
void() data_ini_attack_electro_repeater_={
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
  
  sound (self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ESR_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), FIRE_ORIGIN, FIRE_ENDPOINT);
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, DMG_ENE, FIRE_ENDPOINT, '0 0 0');
    if( trace_ent.shield > 0 ){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
    else{
      pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
  }
  else{
    pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
  }
  
  
  //double-tap
  ctrl_weapon_fireOffset();
  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), FIRE_ORIGIN, FIRE_ENDPOINT);
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, DMG_ENE, FIRE_ENDPOINT, '0 0 0');
    if( trace_ent.shield > 0 ){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
    else{
       pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
  }
  pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
};
#endif