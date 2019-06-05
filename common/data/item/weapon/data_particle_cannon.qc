/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Particle Cannon
      Range - Long
      Consumes Energy
      Pierces Shields
      High Damage
      Single shot
      hit scan
*/
void() data_ini_attack_particle_cannon_;

void() data_ini_particle_cannon_={
  
  self.data_idx = 7;
  self.w_name = "PAC";
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 8;
  self.energyRate =  333.33;
  self.spreadDefault = '0.0025 0.0025 0';
  
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_particle_cannon_;

  self.w_range = 2000;
  self.damageValue = 250;
  self.damageType = (DMG_ENE | EFF_PRC);
 
  self.w_fire_ofs = '0 0 6.75'; 
  self.fire_sound = "sound/weapons/pac_fire.ogg";
  self.model = "q3mdl/weapons/w_pac.md3";
  self.techLevel = 3;
  self.i_size = 3;
};

void() data_ini_attack_particle_cannon_={
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE, 0 );
  
  pointparticles( particleeffectnum("TE_PAC_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 1);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  
  trailparticles( world, particleeffectnum("TE_PAC_RAIL"), FIRE_ORIGIN, FIRE_ENDPOINT);

  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, self.damageType, FIRE_ENDPOINT + (v_forward*3), '0 0 0');
    if( trace_ent.shield > 0 ){
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD"), FIRE_ENDPOINT + (v_forward * -5), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * -4, 1);
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD_POINT"), FIRE_ENDPOINT + (v_forward * -5), '0 0 0', 1);
    }
    else{
      pointparticles( particleeffectnum("TE_PAC_IMPACT_ARMOR"), FIRE_ENDPOINT + (v_forward * -5), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * -4, 1);
    }
    return;
  }
  
  pointparticles( particleeffectnum("TE_PAC_IMPACT_GROUND"), FIRE_ENDPOINT + (v_forward * -5), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * -4, 1);
};
