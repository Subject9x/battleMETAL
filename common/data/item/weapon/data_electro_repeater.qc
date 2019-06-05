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
void() data_ini_attack_electro_repeater_;

void() data_ini_electro_repeater_={
  
  self.data_idx = 8;
  self.w_name = "ESR";
  
  self.w_clipsize = 20;
  self.reloadRate = 0.07;
  self.reloadMax = 5;
  self.energyRate =  200;
  self.spreadDefault = '0.1 0.1 0';
  
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_electro_repeater_;

  self.w_range = 200;
  self.p_damage = 25;
  self.p_dmgtype = (DMG_ENE | EFF_PRC);
 
  self.w_fire_ofs = '0 0 6'; 
  self.fire_sound = "sound/weapons/esr_fire.ogg";
  self.model = "q3mdl/weapons/w_esr.md3";
  self.techLevel = 2;
  self.i_size = 2;
  self.w_isburst = FALSE;
  
};

void() data_ini_attack_electro_repeater_={
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE, 1 );
  
  sound (self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ESR_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), FIRE_ORIGIN, FIRE_ENDPOINT);
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.p_damage, DMG_ENE, FIRE_ENDPOINT, '0 0 0');
    if( trace_ent.shield > 0 ){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
    else{
       pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
    return;
  }
  
  pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
};
