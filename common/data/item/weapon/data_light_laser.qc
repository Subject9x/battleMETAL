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
#ifndef CSQC
void() data_ini_attack_laser_;
#endif
 
void() data_ini_light_laser_={
  
  self.data_idx = 3;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.95;
  self.reloadMax = 0.95;
  self.energyRate = 12;

  self.w_range = 2000;
  self.damageValue = 15;
  self.damageType = (DMG_ENE | EFF_SHD);

  self.techLevel = 1;
  self.equipSize = ENE1;

  self.spreadDefault = '0.0075 0.0075 0';
  self.wepFireOffset = '0 0 3.5'; 
  
  #ifdef CSQC
    self.w_name = "Light Laser";
    self.fire_sound = "sound/weapons/laser_fire.ogg";
    self.model = "q3mdl/weapons/w_laser.md3";
    self.abbrev = "LAS";
    self.description = "+ Instant-impact weapon. + Small damage bonus against <shields>.";
    self.icon = "gfx/ui/wep_icons/wi_las.png";
  #endif
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.model = "q3mdl/weapons/w_laser.md3";
    self.think = default_weapon_think;
    self.w_attack = data_ini_attack_laser_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_laser_={
  local float impactStyle;
  local float damage;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    damage = self.damageValue;
    if( trace_ent.shield > 0 ){
      damage = damage + (damage * 0.16);
      t_damage_shield(trace_ent, self,self.owner, damage, trace_endpos, '0 0 0'); 
      impactStyle = IMPACT_SHIELD;
    }
    else{
      damage = damage * 0.85;
      t_damage(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, '0 0 0');  
      impactStyle = IMPACT_ARMOR;
    }
  }
  else{
    impactStyle = IMPACT_DIRT;
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle );
  
};
#endif