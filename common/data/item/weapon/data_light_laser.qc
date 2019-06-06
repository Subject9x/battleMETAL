/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Item - Weapon
    Light Laser
      Range - Long
      Consumes Energy
      Mild Dmg buff against shields

*/
void() data_ini_attack_laser_;

void() data_ini_light_laser_={
  
  self.data_idx = 3;
  self.w_name = "Light Laser";
  
  self.w_clipsize = 1;
  self.reloadRate = 0.6;
  self.reloadMax = 0.6;
  self.energyRate =  6.67;
  self.spreadDefault = '0.0075 0.0075 0';
  
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_laser_;

  self.w_range = 2000;
  self.damageValue = 10;
  self.damageType = (DMG_ENE | EFF_STX);
 
  self.w_fire_ofs = '0 0 3.5'; 
  self.fire_sound = "sound/weapons/laser_fire.ogg";
  self.model = "q3mdl/weapons/w_laser.md3";
  self.techLevel = 1;
  self.i_size = 1;
  
  self.w_isburst = FALSE;
  
  self.abbrev = "LAS";
  self.description = "Small bonus damage against shields.~";
  self.icon = "gfx/ui/wep_icons/wi_las.png";
};

void() data_ini_attack_laser_={
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE, 0 );
  
  sound ( self, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), self.origin, FIRE_ENT.angles, 1);
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), FIRE_ORIGIN, FIRE_ENDPOINT);
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, self.damageType, FIRE_ENDPOINT, '0 0 0');
    if( trace_ent.shield <= 0 ){
      pointparticles(particleeffectnum("TE_LAS_HIT"), FIRE_ENDPOINT , normalize( FIRE_ORIGIN - FIRE_ENDPOINT ), 1);
    }
    return;
  }
  
  pointparticles(particleeffectnum("TE_LAS_DIRT"), FIRE_ENDPOINT , '0 0 0', 1);
};
