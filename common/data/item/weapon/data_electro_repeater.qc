/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Electro-Static Repeater
      Range - Short
      Consumes Energy
      hit scan
      Inaccurate
      spin up and cooldown
*/
float DATA_ESR_BEAM_COUNT = 3;
float DATA_ESR_COOLDOWN_MAX = 2;

#ifndef CSQC

void() data_ini_attack_electro_repeater_;
#endif 

void() data_ini_electro_repeater_={
  
  self.data_idx = 8;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.23;
  self.reloadMax = 0.23;
  self.energyRate = 18;
  
  self.w_range = 450;
  self.damageValue = 7;
  self.damageType = DMG_ENE;

  self.techLevel = 2;
  self.equipSize = ENE2;

  self.spreadDefault = '0.15 0.2 0';
  self.wepFireOffset = '0 0 6'; 
  
  #ifdef CSQC  
    self.w_name = "Electro-Static Repeater";
    self.fire_sound = "sound/weapons/esr_fire.ogg";
    self.model = "q3mdl/weapons/w_esr.md3";
    self.abbrev = "ESR";
    self.description = "+ Instant-impact weapon. + Rate of Fire spin up/cool down. + Damage split when target is <shielded>";
    self.icon = "gfx/ui/wep_icons/wi_esr.png";
  #endif
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.model = "q3mdl/weapons/w_esr.md3";
    self.think = default_weapon_think;
    self.w_attack = data_ini_attack_electro_repeater_;
  #endif
  
};

#ifndef CSQC
void() data_ini_attack_electro_repeater_={
  local float impactStyle;
  local float damage;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_updateAmmo( FALSE );
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.reloadValue = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
    
  }
  else{
    if( (FIRE_ENT.flags & FL_MONSTER) ){
      self.w_firetime = time + (self.reloadRate / self.burstRate) * 1.67;
    }
    else{
      self.w_firetime = time + self.reloadRate / self.burstRate;
    }
    self.w_state = RECOIL;
    self.w_isburst = FALSE;
  }
  ctrl_weapon_fireOffset();

  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  if( trace_ent.takedamage ){
    damage = self.damageValue; 
    if( trace_ent.shield > 0 ){
      damage = damage / 2;
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, '0 0 0');
      t_damage(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, '0 0 0');
      impactStyle = IMPACT_SHIELD;
    }
    else{
      t_damage(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, '0 0 0');
      impactStyle = IMPACT_ARMOR;
    }
  }
  else{
    impactStyle = IMPACT_DIRT;
  }
  
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);
};
#endif